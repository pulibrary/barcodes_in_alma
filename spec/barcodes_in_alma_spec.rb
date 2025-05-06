# frozen_string_literal: true

RSpec.describe BarcodesInAlma do
  it "has a version number" do
    expect(BarcodesInAlma::VERSION).not_to be nil
  end

  describe "sftp_connection" do
    let(:sftp_session) { instance_double("Net::SFTP::Session", dir: sftp_dir) }
    let(:sftp_dir) { instance_double("Net::SFTP::Operations::Dir") }
    before do
      allow(Net::SFTP).to receive(:start).and_yield(sftp_session)
      allow(sftp_session).to receive(:download!)
        .with("/alma/aspace/sc_active_barcodes.csv")
    end
    it "downloads a csv file containing barcodes in Alma" do
      described_class.download_barcodes
      expect(sftp_session).to have_received(:download!).with("/alma/aspace/sc_active_barcodes.csv")
    end
  end
end
