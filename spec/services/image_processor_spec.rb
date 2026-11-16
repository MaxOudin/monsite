# frozen_string_literal: true

require "rails_helper"
require "zip"

RSpec.describe ImageProcessor do
  describe ".favicon" do
    let(:tempfile) do
      file = Tempfile.new(["logo", ".svg"])
      file.write(<<~SVG)
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32">
          <rect width="32" height="32" fill="black"/>
        </svg>
      SVG
      file.rewind
      file
    end
    let(:upload) { Struct.new(:tempfile).new(tempfile) }

    after { tempfile.close! }

    it "produit le pack PNG et ICO à partir d'un SVG" do
      Vips.block_untrusted(true)

      entries = Zip::File.open_buffer(described_class.favicon(upload)).entries.map(&:name)

      expect(entries).to include("favicon-16x16.png", "favicon-256x256.png", "favicon.ico")
    end
  end
end
