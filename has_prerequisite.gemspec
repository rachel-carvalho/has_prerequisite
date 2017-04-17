$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_prerequisite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "has_prerequisite"
  s.version     = HasPrerequisite::VERSION
  s.authors     = ["Sophie Déziel"]
  s.email       = ["courrier@sophiedeziel.com"]
  s.homepage    = "http://github.com/sophiedeziel/has_prerequisite"
  s.summary     = "Simple authorization method to redirect to specific pages when a prerequisite is not met."
  s.description = "Simple authorization method to redirect to specific pages when a prerequisite is not met."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
  s.add_development_dependency "rspec-rails"
end
