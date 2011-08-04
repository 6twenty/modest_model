module ModestModel

  class ResourceNotFound < ::StandardError; end
  class InvalidResource < ::StandardError; end
  
  module Tenacity
    extend ActiveSupport::Concern
    
    included do
      class_attribute :_find
      self._find = Proc.new {}
      
      class_attribute :_save
      self._save = Proc.new {}
      
      class_attribute :_destroy
      self._destroy = Proc.new {}
      
      class_attribute :primary_key
      set_primary_key :id
    end
    
    module ClassMethods
      
      def undefine_attribute_method attr # :nodoc:
        self._attributes = self._attributes - [attr]
        undef_method attr if method_defined? attr
        undef_method "#{attr}=" if method_defined? "#{attr}="
      end
      
      # Sets the +primary_key+ and its associated attribute
      def set_primary_key attr
        undefine_attribute_method :id if attr == :id # Remove id, always
        if self.primary_key
          undefine_attribute_method self.primary_key
          # TODO: remove any validations on the current PK
          # self._validators.except!(self.primary_key.to_sym)
        end
        self.primary_key = attr
        attributes attr
        # TODO: add a presence validation on the new PK
        # validates  attr, :presence => true
      end
      
      # When a block is passed, that block is set to +_find+.
      # When +id_+ is passed (or no +block+ is passed) a new record is instantiated with the passed +id_+ and the +_find+ block is called.
      # If the return from the +_find+ block is +nil+ or +false+, a ResourceNotFound error is raised.
      def find id_=nil, &block
        if block_given?
          self._find = block
        else
          resource = new(primary_key.to_sym => id_)
          resource.send(:call_find!) || raise(ModestModel::ResourceNotFound)
          resource.found
        end
      end
      
      # TODO - docs
      def create attributes = nil, options = {}, &block
        if attributes.is_a?(Array)
          attributes.collect { |attr| create(attr, options, &block) }
        else
          object = new(attributes, options)
          yield(object) if block_given?
          object.save
          object
        end
      end
      
      # The passed +block+ is set to +_save+ and called on save
      def save &block
        self._save = block if block_given?
      end

      # The passed +block+ is set to +_destroy+ and called on destroyed
      def destroy &block
        self._destroy = block if block_given?
      end
    end
    
    module InstanceMethods
      
      def initialize attributes = {}, options={} #:nodoc:
        super attributes, options
        @new_resource = true
        @destroyed  = false
      end
      
      def found #:nodoc:
        @new_resource = false
        return self
      end      
      
      def to_param #:nodoc:
        send(self.class.primary_key)
      end
      
      def new_resource? #:nodoc:
        @new_resource
      end
      alias :new_record? :new_resource?

      def destroyed? #:nodoc:
        @destroyed
      end

      def persisted? #:nodoc:
        false
      end

      # Runs the save block and returns true if the operation was successful, false if not
      def save(*)
        create_or_update
      end
      
      # Runs the save block and returns true if the operation was successful or raises an InvalidResource error if not
      def save!(*)
        create_or_update || raise(ModestModel::InvalidResource)
      end
      
      # Runs the destroy block and sets the resource as destroyed
      def destroy
        call_destroy!
        @destroyed = true
        return self
      end

      # Updates a single attribute and calls save.
      # This is especially useful for boolean flags on existing records. Also note that
      #
      # * Validation is skipped.
      # * Callbacks are invoked.
      #
      def update_attribute(name, value)
        send("#{name.to_s}=", value)
        save(:validate => false)
      end

      # Updates the attributes of the model from the passed-in hash and calls save the
      # will fail and false will be returned.
      def update_attributes(attributes, options = {})
        self.assign_attributes(attributes, options)
        save
      end

      # Updates its receiver just like +update_attributes+ but calls <tt>save!</tt> instead
      # of +save+, so an exception is raised if the resource is invalid.
      def update_attributes!(attributes, options = {})
        self.assign_attributes(attributes, options)
        save!
      end 

      private
        
        def create_or_update #:nodoc:
          valid? ? (new_resource? ? create : update) : false
        end
        
        def create #:nodoc:
          @new_resource = false
          call_save!
        end
        
        def update #:nodoc:
          call_save!
        end
        
        def call_save! #:nodoc:
          instance_exec &self.class._save
        end

        def call_find! #:nodoc:
          instance_exec &self.class._find
        end

        def call_destroy! #:nodoc:
          instance_exec &self.class._destroy
        end
    end
  end
end