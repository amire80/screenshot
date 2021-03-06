# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'screenshot/version'

Gem::Specification.new do |spec|
  spec.name          = 'screenshot'
  spec.version       = Screenshot::VERSION
  spec.authors       = ['Vikas Yaligar', 'Željko Filipin', 'Amir E. Aharoni']
  spec.email         = ['amir.aharoni@mail.huji.ac.il']
  spec.description   = %q{A library for taking and cropping screenshots of web pages. It uses Selenium and chunky_png. It was originally built for taking screenshots in many languages for the translations of the Wikimedia VisualEditor user manual, but now it can be used for any project.}
  spec.summary       = %q{A library for taking and cropping screenshots of web pages.}
  spec.homepage      = 'https://github.com/amire80/screenshot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'chunky_png', '~> 1.3.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
end
