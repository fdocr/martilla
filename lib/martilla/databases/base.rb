class Martilla::Databases::Base
  attr_reader :options

  def initialize(opts)
    @options = opts
  end

  def temp_filepath
    @options['tmp_file'] || '/tmp/db.sql'
  end
end
