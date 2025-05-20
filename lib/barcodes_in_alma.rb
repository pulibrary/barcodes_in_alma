# frozen_string_literal: true

require 'csv'
require 'net/sftp'
require_relative 'barcodes_in_alma/version'

class BarcodesInAlma
  class Error < StandardError; end

  def self.download_barcodes(remote_filename)
    Net::SFTP.start(ENV.fetch('SFTP_HOST', nil), ENV.fetch('SFTP_USERNAME', nil),
                    { password: ENV.fetch('SFTP_PASSWORD', nil) }) do |sftp|
      sftp.download!(File.join('/alma/aspace/', File.basename(remote_filename)), remote_filename)
    end
  end

  def barcodes
    csv = BarcodesInAlma.download_barcodes('sc_active_barcodes.csv')
    CSV.read(csv, headers: true).map { |row| row['Barcode'] }.to_set
  end

  def already_in_alma?(barcode)
    barcodes.include?(barcode)
  end
end
