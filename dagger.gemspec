
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

begin
  require 'git-version-bump'
  GIT_VERSION = GVB.version.freeze
rescue LoadError
  GIT_VERSION = '0.0.0.UNDEF'.freeze
end

Gem::Specification.new do |spec|
  spec.name          = 'dagger'
  spec.version       = GIT_VERSION
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

  spec.add_dependency 'key_tree', '~> 0.4.0'
  spec.add_dependency 'tangle', '~> 0.6.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'git-version-bump', '~> 0.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52'
end
