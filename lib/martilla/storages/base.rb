class Martilla::Storages::Base
  attr_reader :options

  def initialize(opts)
    @options = opts
  end
end
