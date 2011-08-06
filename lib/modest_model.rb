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
  
  # Build a basic ModestModel by passing in a hash of key/value attributes
  def self.new(attributes={})
    klass = const_set("Generic#{Object.new.object_id}", Class.new(Base))
    klass.attributes *attributes.keys.map(&:to_sym)
    klass.new(attributes)
  end
end