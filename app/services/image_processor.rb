class ImageProcessor
  MAX_FILE_SIZE = 50.megabytes
  RASTER_FORMATS = %w[jpg jpeg png webp tiff gif bmp heic].freeze
  ALLOWED_FORMATS = (RASTER_FORMATS + %w[svg ico]).freeze
  FAVICON_SIZES = [ 16, 32, 48, 64, 128, 256 ].freeze

  class << self
    def resize(file, width:, height:, mode: :fit)
      require_vips!
      pipeline = ImageProcessing::Vips.source(file.tempfile)

      case mode
      when :fit
        pipeline.resize_to_fit(width.presence, height.presence)
      when :fill
        pipeline.resize_to_fill(width, height)
      when :exact
        pipeline.resize_to_limit(width, height)
      else
        pipeline.resize_to_fit(width.presence, height.presence)
      end.call
    end

    def convert(file, format:, quality: nil)
      require_vips!
      format = normalize_format(format)

      log_heic_diagnostics(file) if detect_format(file) == "heic"

      Rails.logger.info "[ImageProcessor#convert] source=#{file.original_filename} " \
                        "size=#{file.size} content_type=#{file.content_type} " \
                        "tempfile=#{file.tempfile.path} target_format=#{format}"

      Rails.logger.info "[ImageProcessor#convert] Étape 1 — lecture du fichier source par vips"
      pipeline = ImageProcessing::Vips.source(file.tempfile).convert(format)
      pipeline = pipeline.saver(Q: quality) if quality && %w[jpg jpeg webp heic].include?(format)

      Rails.logger.info "[ImageProcessor#convert] Étape 2 — lancement du pipeline vips"
      result = pipeline.call
      Rails.logger.info "[ImageProcessor#convert] Succès — résultat: #{result.path}"
      result
    end

    def compress(file, quality:)
      require_vips!
      format = detect_format(file)
      image = Vips::Image.new_from_file(file.tempfile.path)

      case format
      when "png"
        tempfile = Tempfile.new([ "compressed", ".png" ])
        image = image.colourspace("srgb") if image.bands >= 3
        image.pngsave(tempfile.path, compression: 9, palette: true, Q: quality, strip: true)
        tempfile
      when "jpg", "jpeg"
        tempfile = Tempfile.new([ "compressed", ".jpg" ])
        image.jpegsave(tempfile.path, Q: quality, strip: true, optimize_coding: true, interlace: true)
        tempfile
      when "webp"
        tempfile = Tempfile.new([ "compressed", ".webp" ])
        image.webpsave(tempfile.path, Q: quality, strip: true)
        tempfile
      else
        tempfile = Tempfile.new([ "compressed", ".webp" ])
        image.webpsave(tempfile.path, Q: quality, strip: true)
        tempfile
      end
    end

    def remove_bg(file)
      rembg_url = ENV.fetch("REMBG_URL", "http://localhost:7000")
      uri = URI("#{rembg_url}/api/remove")

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = file.content_type
      request.body = file.read

      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.read_timeout = 60
        http.request(request)
      end

      raise "Remove BG failed: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      tempfile = Tempfile.new([ "nobg", ".png" ])
      tempfile.binmode
      tempfile.write(response.body)
      tempfile.rewind
      tempfile
    end

    def favicon(file)
      require_vips!
      require "zip"

      buffer = Zip::OutputStream.write_buffer do |zip|
        FAVICON_SIZES.each do |size|
          result = ImageProcessing::Vips.source(file.tempfile)
            .resize_to_fill(size, size)
            .convert("png")
            .call

          zip.put_next_entry("favicon-#{size}x#{size}.png")
          zip.write(File.binread(result.path))
          result.close! if result.respond_to?(:close!)
        end

        ico_sizes = [ 16, 32, 48 ]
        ico_images = ico_sizes.map do |size|
          ImageProcessing::Vips.source(file.tempfile)
            .resize_to_fill(size, size)
            .convert("png")
            .call
        end

        zip.put_next_entry("favicon.ico")
        zip.write(build_ico(ico_images))
        ico_images.each { |img| img.close! if img.respond_to?(:close!) }
      end

      buffer.string
    end

    def optimize_svg(content)
      SvgOptimizer.optimize(content)
    end

    def bulk(files, operation:, **options)
      require_vips!
      require "zip"

      buffer = Zip::OutputStream.write_buffer do |zip|
        files.each do |file|
          result = case operation
          when "resize"
            resize(file, width: options[:width], height: options[:height], mode: options.fetch(:mode, :fit))
          when "convert"
            convert(file, format: options[:format], quality: options[:quality])
          when "compress"
            compress(file, quality: options.fetch(:quality, 80))
          end

          ext = operation == "convert" ? options[:format] : File.extname(file.original_filename)
          name = File.basename(file.original_filename, ".*")
          zip.put_next_entry("#{name}-#{operation}#{ext.start_with?('.') ? ext : ".#{ext}"}")
          zip.write(File.binread(result.path))
          result.close! if result.respond_to?(:close!)
        end
      end

      buffer.string
    end

    private

    def require_vips!
      require "image_processing/vips"
    end

    def log_heic_diagnostics(file)
      Rails.logger.info "[ImageProcessor] === Diagnostic HEIC ==="
      Rails.logger.info "[ImageProcessor] libvips version: #{Vips::VERSION}"
      Rails.logger.info "[ImageProcessor] ruby-vips version: #{Vips::VERSION_STRING}"

      # Loaders disponibles pour heic/heif
      heic_loaders = Vips::get_suffixes.select { |s| s.match?(/heic|heif/i) } rescue []
      Rails.logger.info "[ImageProcessor] Suffixes heic/heif reconnus par vips: #{heic_loaders.inspect}"

      # Vérifie si le fichier est lisible
      Rails.logger.info "[ImageProcessor] Fichier tempfile existe ? #{File.exist?(file.tempfile.path)}"
      Rails.logger.info "[ImageProcessor] Taille fichier: #{File.size(file.tempfile.path)} octets"
      Rails.logger.info "[ImageProcessor] Magic bytes (hex): #{File.binread(file.tempfile.path, 16).unpack1('H*')}"

      # Tente une ouverture directe vips pour isoler l'erreur
      Rails.logger.info "[ImageProcessor] Tentative Vips::Image.new_from_file..."
      Vips::Image.new_from_file(file.tempfile.path)
      Rails.logger.info "[ImageProcessor] new_from_file OK"
    rescue => e
      Rails.logger.error "[ImageProcessor] new_from_file a échoué: #{e.class} — #{e.message}"
    ensure
      Rails.logger.info "[ImageProcessor] === Fin diagnostic HEIC ==="
    end

    def normalize_format(format)
      format = format.to_s.downcase.strip
      format == "jpeg" ? "jpg" : format
    end

    def detect_format(file)
      ext = File.extname(file.original_filename).delete(".").downcase
      ext == "jpeg" ? "jpg" : ext
    end

    def build_ico(png_files)
      entries = png_files.map { |f| File.binread(f.path) }
      count = entries.size
      header_size = 6
      dir_entry_size = 16
      offset = header_size + (dir_entry_size * count)

      ico = "".b
      ico << [ 0, 1, count ].pack("vvv")

      entries.each do |png_data|
        vips_img = Vips::Image.new_from_buffer(png_data, "")
        w = vips_img.width
        h = vips_img.height
        ico << [ w >= 256 ? 0 : w, h >= 256 ? 0 : h, 0, 0, 1, 32, png_data.size, offset ].pack("CCCCvvVV")
        offset += png_data.size
      end

      entries.each { |png_data| ico << png_data }
      ico
    end
  end
end

module SvgOptimizer
  def self.optimize(content)
    content
      .gsub(/<!--.*?-->/m, "")
      .gsub(/\s+/, " ")
      .gsub(/> </, "><")
      .strip
  end
end
