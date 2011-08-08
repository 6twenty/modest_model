# Need to add more methods to mimic Hash and/or Struct functionality!

module ModestModel
  class Object
    include ActiveModel::Conversion
    include ActiveModel::Serialization
    include ActiveModel::AttributeMethods
    
    def initialize(attributes={})
      unless attributes.blank?
        self.class.attributes *attributes.keys.map(&:to_sym)
        attributes.each do |attr, value|
          self.send("#{attr}=", value)
        end
      end
    end
    
    class << self
      alias_method :new_original, :new
      
      def new(attrs={})
        klass = ModestModel.const_set("Object#{::Object.new.object_id}", Class.new(self))
        class << self
          undef_method :new
          define_method :new do |*args|
            new_original(*args)
          end
        end
        klass.new(attrs)
      end
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
    
    def persisted?
      false
    end
    
    def []=(attribute, value)
      self.class.attributes attribute.to_sym unless self.respond_to?(attribute.to_sym)
      self.send("#{attribute}=", value)
    end
    
    def [](attribute)
      self.send(attribute.to_sym)
    end
    
    def delete(attribute)
      if self.respond_to?(attribute)
        self.class._attributes = self.class._attributes - [attribute]
        self.class.send(:undef_method, "#{attribute}")  if self.class.method_defined?("#{attribute}")
        self.class.send(:undef_method, "#{attribute}=") if self.class.method_defined?("#{attribute}=")
        remove_instance_variable("@#{attribute}")
      end
    end
    
    protected
    
    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end
    
    def attribute?(attribute)
      send(attribute).present?
    end
    
    private
    
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