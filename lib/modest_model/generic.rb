module ModestModel
  class Generic < Base
    # Allow setting the initial attributes by passing in a hash of key/value pairs
    def initialize(attributes={})
      self.class.attributes *attributes.keys.map(&:to_sym)
      attributes.each do |attr, value|
        self.send("#{attr}=", value)
      end unless attributes.blank?
    end
    
    # Hashes support setting values using the `hash[key] = value` syntax
    def []=(attribute, value)
      self.class.attributes attribute.to_sym unless self.respond_to?(attribute.to_sym)
      self.send("#{attribute}=", value)
    end
    
    # Hashes support getting values using the `hash[key]` syntax
    def [](attribute)
      self.send(attribute.to_sym)
    end
    
    # Support removing attributes entirely
    def delete(attribute)
      if self.respond_to?(attribute)
        self.class._attributes = self.class._attributes - [attribute]
        self.class.send(:undef_method, "#{attribute}")  if self.class.method_defined?("#{attribute}")
        self.class.send(:undef_method, "#{attribute}=") if self.class.method_defined?("#{attribute}=")
        remove_instance_variable("@#{attribute}")
      end
    end
    
    private
    
    # Hashes have no restriction on attributes, so if the attribute doesn't exist, create it
    def method_missing(method_name, *args)
      if method_name.to_s =~ /=$/
        attribute_name = method_name.to_s.gsub(/=$/,'')
        self.class.attributes attribute_name.to_sym
        instance_variable_set("@#{attribute_name}", nil)
        self.send(method_name.to_sym, args.first)
      else
        super
      end
    end
  end
end