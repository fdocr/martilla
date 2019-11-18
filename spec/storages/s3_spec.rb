RSpec.describe Martilla::S3 do
  let(:output_file) { 'test/backup_2019-05-01T143129.sql.gz' }
  let(:root_output_file) { 'backup_2019-05-01T143129.sql.gz' }

  let(:subdirectory_s3_config) do
    opts = Martilla::Backup.sample_config['storage']['options']
    opts['filename'] = 'test/backup.sql'
    opts['bucket'] = 'test'
    opts['retention'] = 2
    opts
  end

  let(:root_s3_config) do
    opts = Martilla::Backup.sample_config['storage']['options']
    opts['filename'] = 'backup.sql'
    opts['bucket'] = 'test'
    opts['retention'] = 2
    opts
  end

  it 'enforces retention on valid files within a subdirectory in the bucket' do
    # Override private `s3_resource` method to use custom Client with stubs
    s3_storage = Martilla::S3.new(subdirectory_s3_config)
    def s3_storage.s3_resource
      s3_client = Aws::S3::Client.new(stub_responses: true)
      s3_client.stub_responses(:list_objects, {
        contents: [
          { key: 'image.jpeg' },
          { key: 'test/image.jpeg' },
          { key: 'test/backup_2019-03-01T143129.sql.gz' },
          { key: 'test/backup_2019-04-01T143129.sql.gz' },
          { key: 'test/backup_2019-05-01T143129.sql.gz' },
          { key: 'test/image2.jpeg' },
          { key: 'backup_2019-06-01T143129.sql.gz' },
          { key: 'backup_2019-07-01T143129.sql.gz' },
          { key: 'backup_2019-08-01T143129.sql.gz' },
          { key: 'backup_2019-09-01T143129.sql.gz' },
          { key: 'backup_2019-10-01T143129.sql.gz' }
        ]
      })
      Aws::S3::Resource.new({ client: s3_client })
    end

    objs = s3_storage.send(:bucket_objs_for_retention, output_file: output_file)
    expect(objs.count).to eq(3)

    result_keys = objs.map(&:key)
    [
      'test/backup_2019-03-01T143129.sql.gz',
      'test/backup_2019-04-01T143129.sql.gz',
      'test/backup_2019-05-01T143129.sql.gz'
    ].each do |filename|
      expect(result_keys).to include(filename)
    end
  end

  it 'enforces retention on valid files in the bucket root directory' do
    # Override private `s3_resource` method to use custom Client with stubs
    root_s3_storage = Martilla::S3.new(root_s3_config)
    def root_s3_storage.s3_resource
      s3_client = Aws::S3::Client.new(stub_responses: true)
      s3_client.stub_responses(:list_objects, {
        contents: [
          { key: 'image.jpeg' },
          { key: 'test/image.jpeg' },
          { key: 'test/backup_2019-03-01T143129.sql.gz' },
          { key: 'test/backup_2019-04-01T143129.sql.gz' },
          { key: 'test/backup_2019-05-01T143129.sql.gz' },
          { key: 'test/image2.jpeg' },
          { key: 'backup_2019-06-01T143129.sql.gz' },
          { key: 'backup_2019-07-01T143129.sql.gz' },
          { key: 'backup_2019-08-01T143129.sql.gz' },
          { key: 'backup_2019-09-01T143129.sql.gz' },
          { key: 'backup_2019-10-01T143129.sql.gz' }
        ]
      })
      Aws::S3::Resource.new({ client: s3_client })
    end

    objs = root_s3_storage.send(:bucket_objs_for_retention, output_file: root_output_file)
    expect(objs.count).to eq(5)

    result_keys = objs.map(&:key)
    [
      'backup_2019-06-01T143129.sql.gz',
      'backup_2019-07-01T143129.sql.gz',
      'backup_2019-08-01T143129.sql.gz',
      'backup_2019-09-01T143129.sql.gz',
      'backup_2019-10-01T143129.sql.gz'
    ].each do |filename|
      expect(result_keys).to include(filename)
    end
  end
end
