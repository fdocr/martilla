RSpec.describe Martilla::Mysql do
  let(:mysql_config) do
    {
      'user' => 'travis',
      'host' => '8.8.8.8',
      'port' => '4406',
      'password' => 'pastrana',
      'db' => 'test'
    }
  end

  describe 'formats the mysqldump arguments' do
    it 'using config params' do
      mysql = Martilla::Mysql.new(mysql_config)
      args = mysql.send(:connection_arguments)
      expect(args).to eq('-u travis --password=pastrana --host=8.8.8.8 -P 4406 test')
    end

    it 'using ENV variables' do
      ENV['MYSQL_HOST'] = '9.9.9.9'
      ENV['MYSQL_PORT'] = '5506'
      ENV['MYSQL_USER'] = 'tony'
      ENV['MYSQL_PASSWORD'] = 'hawk'
      ENV['MYSQL_DATABASE'] = 'sample'

      mysql = Martilla::Mysql.new({})
      args = mysql.send(:connection_arguments)
      expect(args).to eq('-u tony --password=hawk --host=9.9.9.9 -P 5506 sample')

      ENV['MYSQL_HOST'] = nil
      ENV['MYSQL_PORT'] = nil
      ENV['MYSQL_USER'] = nil
      ENV['MYSQL_PASSWORD'] = nil
      ENV['MYSQL_DATABASE'] = nil
    end

    it 'using ENV variables except for defaults' do
      ENV['MYSQL_USER'] = 'tony'
      ENV['MYSQL_PASSWORD'] = 'hawk'

      mysql = Martilla::Mysql.new({})
      args = mysql.send(:connection_arguments)
      expect(args).to eq('-u tony --password=hawk --host=localhost -P 3306 --all-databases')

      ENV['MYSQL_USER'] = nil
      ENV['MYSQL_PASSWORD'] = nil
    end

    it 'using config paramters loaded from YAML file' do
      config = YAML.load_file('spec/fixtures/mysql_special_characters.yml')
      mysql = Martilla::Database.create(config['db'])
      args = mysql.send(:connection_arguments)
      expect(args).to eq('-u test --password=te&s%t_passw(^)rd --host=localhost -P 3306 --all-databases')
    end
  end
end
