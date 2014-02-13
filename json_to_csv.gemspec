require "./lib/json_to_csv/version.rb"

Gem::Specification.new do |s| 
  s.name         = "json_to_csv"
  s.version      =  VERSION
  s.author       = "Barun Thapa"
  s.email        = "barunthapa.bvdt@gmail.com"
  s.homepage     = "http://example.com"
  s.summary      = "INSERT SUMMARY HERE"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README'))
  s.license      = 'ALL RIGHTS RESERVED'
  s.files         = Dir["{bin,lib,spec,assets}/**/*"]
  s.test_files    = Dir["spec/**/*"]
  s.executables   = [ 'json_to_csv' ]

  s.required_ruby_version = '>=1.9'
#  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'thor', [">= 0.18.1"]
end
