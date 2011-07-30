Gem::Specification.new do |s|
  s.name = "simple_model"
  s.authors = ["Mike Fulcher"]
  s.summary = "Simple, ActiveModel-compliant models"
  s.description = "Simple, ActiveModel-compliant models. Like Structs, but better!"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.version = "0.0.1"
  
  s.add_dependency "activemodel", "~> 3"
  s.add_development_dependency "rails", "~> 3"
  s.add_development_dependency "sqlite3"
end