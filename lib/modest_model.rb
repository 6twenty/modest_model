begin
  require 'active_model'
rescue LoadError => e
  retry if require('rubygems')
end

module ModestModel
  autoload :Base,               File.expand_path('../modest_model/base', __FILE__)
  autoload :Validators,         File.expand_path('../modest_model/validators', __FILE__)
  autoload :Relation,           File.expand_path('../modest_model/relation', __FILE__)
  autoload :HasManyCollection,  File.expand_path('../modest_model/has_many_collection', __FILE__)
  autoload :Generic,            File.expand_path('../modest_model/generic', __FILE__)
  
  # Build a basic ModestModel by passing in a hash of key/value attributes
  def self.new(attrs={})
    const_set("Generic#{Object.new.object_id}", Class.new(Generic)).new(attrs)
  end
end