RSpec.describe Martilla::Storage do
  let(:filename_option) { 'backup_filename.sql' }
  let(:regex_timestamp) { Time.now.strftime("%Y-%m-%dT") }
  let(:timestamp_regex) { /backup_filename_#{regex_timestamp}\d{6}\.sql/ }
  let(:timestamp_gzip_regex) { /backup_filename_#{regex_timestamp}\d{6}\.sql.gz/ }

  describe 'output_filename formats filename options' do
    before(:each) {
      @storage_config = Martilla::Backup.sample_config['storage']['options']
      @storage_config['filename'] = filename_option
    }

    context 'when suffix option is disabled' do
      before(:each) { @storage_config['suffix'] = false }

      it 'without gzip' do
        storage = Martilla::Storage.new(@storage_config)
        expect(storage.output_filename(false)).to eq(filename_option)
      end

      it 'with gzip' do
        storage = Martilla::Storage.new(@storage_config)
        expect(storage.output_filename(true)).to eq("#{filename_option}.gz")
      end
    end

    context 'when suffix option is enabled' do
      before(:each) { @storage_config['suffix'] = true }

      it 'without gzip' do
        storage = Martilla::Storage.new(@storage_config)
        expect(storage.output_filename(false)).to match(timestamp_regex)
      end

      it 'with gzip' do
        storage = Martilla::Storage.new(@storage_config)
        expect(storage.output_filename(true)).to match(timestamp_gzip_regex)
      end
    end
  end
end
