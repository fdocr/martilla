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
      pg = Martilla::Postgres.new(postgres_config)
      args = pg.send(:connection_string)
      expect(args).to eq('postgres://travis:pastrana@8.8.8.8:4444/test')
    end

    it 'using ENV variables' do
      ENV['PG_HOST'] = '9.9.9.9'
      ENV['PG_PORT'] = '5555'
      ENV['PG_USER'] = 'tony'
      ENV['PG_PASSWORD'] = 'hawk'
      ENV['PG_DATABASE'] = 'sample'

      pg = Martilla::Postgres.new({})
      args = pg.send(:connection_string)
      expect(args).to eq('postgres://tony:hawk@9.9.9.9:5555/sample')
    end

    it 'using ENV variables except for defaults' do
      ENV['PG_USER'] = 'tony'
      ENV['PG_PASSWORD'] = 'hawk'
      ENV['PG_DATABASE'] = 'example'

      pg = Martilla::Postgres.new({})
      args = pg.send(:connection_string)
      expect(args).to eq('postgres://tony:hawk@localhost:5432/example')
    end
  end

  it 'using config paramters loaded from YAML file' do
      config = YAML.load_file('spec/fixtures/postgres_special_characters.yml')
      pg = Martilla::Database.create(config['db'])
      args = pg.send(:connection_string)
      expect(args).to eq('postgres://test:te&s%t_passw(^)rd@localhost:5432/sample-db')
    end
end
