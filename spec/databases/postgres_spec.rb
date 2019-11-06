RSpec.describe Martilla::Postgres do
  let(:postgres_config) do
    {
      'user' => 'travis',
      'host' => '8.8.8.8',
      'port' => '4444',
      'password' => 'pastrana',
      'db' => 'test'
    }
  end

  describe 'formats the mysqldump arguments' do
    after(:each) do
      # ENV variable cleanup
      ENV['PG_HOST'] = nil
      ENV['PG_PORT'] = nil
      ENV['PG_USER'] = nil
      ENV['PG_PASSWORD'] = nil
      ENV['PG_DATABASE'] = nil
    end

    it 'using config params' do
      mysql = Martilla::Postgres.new(postgres_config)
      args = mysql.send(:connection_string)
      expect(args).to eq('postgres://travis:pastrana@8.8.8.8:4444/test')
    end

    it 'using ENV variables' do
      ENV['PG_HOST'] = '9.9.9.9'
      ENV['PG_PORT'] = '5555'
      ENV['PG_USER'] = 'tony'
      ENV['PG_PASSWORD'] = 'hawk'
      ENV['PG_DATABASE'] = 'sample'

      mysql = Martilla::Postgres.new({})
      args = mysql.send(:connection_string)
      expect(args).to eq('postgres://tony:hawk@9.9.9.9:5555/sample')
    end

    it 'using ENV variables except for defaults' do
      ENV['PG_USER'] = 'tony'
      ENV['PG_PASSWORD'] = 'hawk'
      ENV['PG_DATABASE'] = 'example'

      mysql = Martilla::Postgres.new({})
      args = mysql.send(:connection_string)
      expect(args).to eq('postgres://tony:hawk@localhost:5432/example')
    end
  end
end
