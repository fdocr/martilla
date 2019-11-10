require 'fileutils'

RSpec.describe Martilla::Storage do
  let(:local_config) do
    config = Martilla::Backup.sample_config['storage']['options']
    config['filename'] = './backups/bak.sql'
    config
  end

  describe 'Local#backup_file_list' do
    context 'gzip: false' do
      before(:each) do
        FileUtils.mkdir_p('backups')
        Dir['./backups/*'].each { |f| File.delete(f) }
        # Generates 3 sample backup files
        3.times do |i|
          ts = Time.now.strftime("%Y-%m-%dT%H%M") + (i+1).to_s
          File.open("./backups/bak_#{ts}.sql", 'w')
        end
      end

      after(:each) do
        Dir['./backups/*'].each { |f| File.delete(f) }
      end

      it 'lists backup files ordered by time of creation' do
        storage = Martilla::Local.new(local_config)
        output_filename = storage.output_filename(false)
        file_list = storage.send(:backup_file_list, output_filename)

        # Checks we get the correct amount of files fetched
        expect(file_list.count).to eq(3)

        # Must also check the array returned is sorted
        creation_times = file_list.sort.map { |f| File.mtime(f) }
        expect(creation_times).to eq(creation_times.sort)
      end
    end

    context 'gzip: true' do
      before(:each) do
        FileUtils.mkdir_p('backups')
        Dir['./backups/*'].each { |f| File.delete(f) }
        # Generates 3 sample backup files
        3.times do |i|
          ts = Time.now.strftime("%Y-%m-%dT%H%M") + (i+1).to_s
          File.open("./backups/bak_#{ts}.sql.gz", 'w')
        end
      end

      after(:each) do
        Dir['./backups/*'].each { |f| File.delete(f) }
      end

      it 'lists backup files ordered by time of creation' do
        storage = Martilla::Local.new(local_config)
        output_filename = storage.output_filename(true)
        file_list = storage.send(:backup_file_list, output_filename)

        # Checks we get the correct amount of files fetched
        expect(file_list.count).to eq(3)

        # Must also check the array returned is sorted
        creation_times = file_list.sort.map { |f| File.mtime(f) }
        expect(creation_times).to eq(creation_times.sort)
      end
    end
  end
end
