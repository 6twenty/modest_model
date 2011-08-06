module ModestModel
  class HasManyCollection < Array
    
    def initialize class_name
      @class_name = class_name.to_s.singularize.camelize
    end
    
    def <<(value)
      msg = "#{@class_name} expected, got #{value.class.to_s}"
      raise AssociationTypeMismatch.new(msg) unless value.nil? || value.class.to_s =~ /#{@class_name}/
      super(value)
    end
    
  end
end