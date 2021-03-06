lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "argo/version"

spec = Gem::Specification.new do |s|
  s.name             = "argo"
  s.version          = Argo::VERSION
  s.author           = "Paul Battley"
  s.email            = "pbattley@gmail.com"
  s.description      = "Expand JSON Schema(s) into introspectable Ruby objects"
  s.summary          = "JSON Schema expander"
  s.files            = Dir["{lib,spec}/**/*.rb"]
  s.homepage         = "https://github.com/threedaymonk/argo"
  s.license          = "ISC"
  s.require_path     = "lib"
  s.test_files       = Dir["test/*_test.rb"]
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[COPYING.txt]
  s.required_ruby_version = ">= 2.1.0"
  s.add_development_dependency "rake", "~> 0.9"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 0.32"
  s.add_development_dependency "rubocop-rspec", "~> 1.3"
end
