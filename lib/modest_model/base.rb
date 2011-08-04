module ModestModel
  class Base
    include   ActiveModel::Conversion
    extend    ActiveModel::Naming
    extend    ActiveModel::Translation
    include   ActiveModel::Serialization
    include   ActiveModel::Validations
    include   ActiveModel::AttributeMethods

    include   ModestModel::Validators
    extend    ModestModel::CombinedAttr
    
    def initialize(attributes = {}, options={})
      self.assign_attributes(attributes, options)
    end

    class_attribute :_attributes
    self._attributes = []

    attribute_method_prefix 'clear_'
    attribute_method_suffix '?'

    def self.attributes(*names)
      attr_accessor *names
      define_attribute_methods names

      self._attributes += names
    end

    def attributes
      self._attributes.inject({}) do |hash, attr|
        hash[attr.to_s] = send(attr)
        hash
      end
    end
    
    def attributes= attributes, options = {}
      assign_attributes attributes, options = {}
    end
    
    def [] attr
      attributes[attr.to_s]
    end
    
    def []= attr, val
      self.send "#{attr}=", val
    end
    
    def persisted?
      false
    end
    
    protected
    
    def assign_attributes attributes, options = {}
      attributes.each do |attr, value|
        self[attr] = value
      end unless attributes.blank?
    end
        
    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end

    def attribute?(attribute)
      send(attribute).present?
    end
  end
end