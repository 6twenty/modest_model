begin
  require 'active_model'
rescue LoadError => e
  retry if require('rubygems')
end

module ModestModel
  autoload :Base,         File.expand_path('../modest_model/base', __FILE__)
  autoload :Validators,   File.expand_path('../modest_model/validators', __FILE__)
  autoload :Relation,     File.expand_path('../modest_model/relation', __FILE__)
end