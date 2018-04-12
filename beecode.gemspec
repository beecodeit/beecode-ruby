
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "beecode/version"

Gem::Specification.new do |spec|
  spec.name          = "beecode"
  spec.version       = Beecode::VERSION
  spec.authors       = ["Beecode S.r.l."]
  spec.email         = ["info@beecode.it"]

  spec.summary       = %q{Beecode's official API's client}
  spec.description   = %q{Beecode's official API's client}
  spec.homepage      = "https://beecode.it"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'rest-client', '~> 2.0'
end
