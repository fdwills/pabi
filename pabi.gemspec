# -*- encoding: utf-8 -*-
lib = File.expand_path(File.join(File.dirname(__FILE__),'lib/'))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pabi/version'

Gem::Specification.new do |s|
  s.name        = 'pabi'
  s.version     = Pabi::VERSION
  s.date        = '2014-06-20'
  s.summary     = ""
  s.description = "iap ( apple In-App purchase) and iab (google In-App Billing) ruby gem for server receipt validation"
  s.authors     = ["wills"]
  s.email       = 'weirenzhong@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'https://github.com/fdwills/pabi'
  s.license     = 'MIT'
  s.executables << 'pabi'

  s.add_runtime_dependency "rspec", ">= 2.13.0"
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
