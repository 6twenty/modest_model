# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "simple_model"
  s.authors = ["Mike Fulcher"]
  s.summary = "Simple, ActiveModel-compliant models"
  s.description = "Simple, ActiveModel-compliant models. Like Structs, but better!"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.version = "0.0.1"
end