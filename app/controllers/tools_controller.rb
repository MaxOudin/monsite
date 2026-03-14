class ToolsController < ApplicationController
  before_action :validate_file, only: %i[process_resize process_convert process_remove_bg]

  # GET /tools
  def index; end

  # GET /tools/resize
  def resize; end

  # POST /tools/resize
  def process_resize
    width  = params[:width].to_i
    height = params[:height].to_i
    mode   = (params[:mode] || "fit").to_sym

    result = ImageProcessor.resize(params[:file], width: width, height: height, mode: mode)
    send_processed_file(result, "resized")
  rescue => e
    redirect_back fallback_location: tools_resize_path, alert: friendly_error(e)
  end

  # GET /tools/convert
  def convert; end

  # POST /tools/convert
  def process_convert
    format  = params[:format]
    quality = params[:quality].present? ? params[:quality].to_i : nil

    result = ImageProcessor.convert(params[:file], format: format, quality: quality)
    send_processed_file(result, "converted", format: format)
  rescue => e
    redirect_back fallback_location: tools_convert_path, alert: friendly_error(e)
  end

  # GET /tools/remove_bg
  def remove_bg; end

  # POST /tools/remove_bg
  def process_remove_bg
    result = ImageProcessor.remove_bg(params[:file])
    original_name = File.basename(params[:file].original_filename, ".*")
    send_data File.binread(result.path),
              filename: "#{original_name}-sans-fond.png",
              type: "image/png",
              disposition: "attachment"
  rescue => e
    redirect_back fallback_location: tools_remove_bg_path, alert: friendly_error(e)
  ensure
    result&.close! if result.respond_to?(:close!)
  end

  private

  def validate_file
    if params[:file].blank?
      redirect_back fallback_location: tools_path, alert: "Veuillez sélectionner un fichier."
      return
    end

    if params[:file].respond_to?(:size) && params[:file].size > ImageProcessor::MAX_FILE_SIZE
      redirect_back fallback_location: tools_path,
                    alert: "Fichier trop volumineux (max #{ImageProcessor::MAX_FILE_SIZE / 1.megabyte} Mo)."
      return
    end
  end

  def send_processed_file(result, suffix, format: nil)
    original_name = File.basename(params[:file].original_filename, ".*")
    ext           = format || File.extname(params[:file].original_filename).delete(".")
    filename      = "#{original_name}-#{suffix}.#{ext}"
    content_type  = Rack::Mime.mime_type(".#{ext}", "application/octet-stream")

    send_data File.binread(result.path), filename: filename, type: content_type, disposition: "attachment"
  ensure
    result&.close! if result.respond_to?(:close!)
  end

  def friendly_error(error)
    message = error.message.to_s
    case message
    when /is not a known file format/
      "Format de fichier non reconnu par libvips. Essayez JPG, PNG ou WebP."
    when /No such file/
      "Fichier introuvable. Veuillez réessayer."
    when /Remove BG failed/
      "Le service de suppression de fond est indisponible (#{message})."
    when /VipsForeignLoad/, /Vips/
      "Impossible de lire ce fichier image. Vérifiez qu'il n'est pas corrompu."
    else
      "Une erreur est survenue lors du traitement. Vérifiez que le fichier est valide."
    end
  end
end
