# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dagger/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-dagger'
  spec.version       = Dagger::VERSION
  spec.authors       = ['Calle Englund']
  spec.email         = ['calle@discord.bofh.se']

  spec.summary       = 'Manage a DAG, stored in posix file structures'
  spec.homepage      = 'https://github.com/notcalle/ruby-dagger'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6', '< 4.0'

  spec.add_dependency 'git-version-bump', '~> 0.17.0'
  spec.add_dependency 'key_tree', '~> 0.8.0'
  spec.add_dependency 'tangle', '~> 0.11.0'

  spec.add_development_dependency 'bundler', '~> 2.4.15'
  spec.add_development_dependency 'codecov', '~> 0.5.0'
  spec.add_development_dependency 'pry', '~> 0.14.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.15'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'simplecov', '~> 0.21.0'

  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
