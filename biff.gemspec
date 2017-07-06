lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'biff'
  spec.version       = File.read('VERSION').chomp # file managed by version gem...

  spec.authors       = ['Rick Frankel']
  spec.email         = ['biff@cybercode.nyc']

  spec.summary       = 'Imap IDLE based biff client'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/cybercode/biff'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -z -- spec/*`.split("\x0")
  spec.bindir        = 'bin'
  spec.executables   = %w[biffer biff.5m.rb]
  spec.require_paths = ['lib']

  spec.add_dependency 'version', '~> 1.1'
  spec.add_dependency 'rfc2047', '>= 0.3'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
