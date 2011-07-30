Gem::Specification.new do |s|
  s.name = "modest_model"
  s.authors = ["Mike Fulcher"]
  s.summary = "Simple, tableless ActiveModel-compliant models"
  s.description = "Simple, tableless ActiveModel-compliant models. Like ActiveRecord models without the database."
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.version = "0.0.1"
  
  s.add_dependency "activemodel", "~> 3"
  s.add_development_dependency "rails", "~> 3.1.rc5"
  s.add_development_dependency "sqlite3"
end