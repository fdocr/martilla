lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'martilla/version'

Gem::Specification.new do |spec|
  spec.name          = 'martilla'
  spec.version       = Martilla::VERSION
  spec.authors       = ['Fernando Valverde']
  spec.email         = ['fdov88@gmail.com']

  spec.summary       = 'Modern backup tool'
  spec.description   = ''
  spec.homepage      = 'https://github.com/fdoxyz/martilla'
  spec.license       = 'MIT'

  # spec.metadata['allowed_push_host'] = 'TODO: Set to 'http://mygemserver.com''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fdoxyz/martilla'
  spec.metadata['changelog_uri'] = 'https://github.com/fdoxyz/martilla/changelog'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'pony', '~> 1.13'
  spec.add_dependency 'aws-ses', '~> 0.6.0'
  spec.add_dependency 'thor', '~> 0.20.3'
  spec.add_dependency 'memoist', '~> 0.16.0'
  spec.add_dependency 'aws-sdk-s3', '~> 1.49'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.7'
end
