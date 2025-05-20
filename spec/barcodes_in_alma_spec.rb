# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BarcodesInAlma do
  it 'has a version number' do
    expect(BarcodesInAlma::VERSION).not_to be nil
  end

  describe 'sftp_connection' do
    let(:sftp_session) { instance_double('Net::SFTP::Session', dir: sftp_dir) }
    let(:sftp_dir) { instance_double('Net::SFTP::Operations::Dir') }
    let(:barcode1) { '32101000000008' }
    let(:barcode2) { '32101000000009' }
    before do
      allow(Net::SFTP).to receive(:start).and_yield(sftp_session)
      allow(sftp_session).to receive(:download!)
        .with('/alma/aspace/sc_active_barcodes.csv', 'sc_active_barcodes.csv')
        .and_return(File.open('spec/fixtures/sc_active_barcodes_short.csv'))
    end
    it 'downloads a csv file containing barcodes in Alma' do
      described_class.download_barcodes('sc_active_barcodes.csv')
      expect(sftp_session).to have_received(:download!).with('/alma/aspace/sc_active_barcodes.csv',
                                                             'sc_active_barcodes.csv')
    end

    it 'creates a set of barcodes' do
      expect(described_class.new.barcodes).to be_an_instance_of(Set)
      expect(described_class.new.barcodes.first).to eq('02101052513221')
    end

    it 'compares a single barcode that is included to the set of barcodes' do
      expect(described_class.new.already_in_alma?(barcode1)).to eq(true)
    end

    it 'compares a single barcode that is not included to the set of barcodes' do
      expect(described_class.new.already_in_alma?(barcode2)).to eq(false)
    end
  end
end
