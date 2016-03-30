# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbl_mcafee/version'

Gem::Specification.new do |spec|
  spec.name          = "rbl_mcafee"
  spec.version       = RblMcafee::VERSION
  spec.authors       = ["Romain Salles"]
  spec.email         = ["romainsalles@users.noreply.github.com"]
  spec.summary       = %q{Solution to test if an IP address is listed in the
    McAfee RBL}
  spec.description   = %q{Solution to test if an IP address is listed in the
    McAfee RBL}
  spec.homepage      = "https://github.com/romainsalles/rbl_mcafee"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.4"
end
