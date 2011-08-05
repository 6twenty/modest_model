module ModestModel
  module Relation
    extend ActiveSupport::Concern
    
    # Store the associations so that they can be referenced later
    included do
      class_attribute :_has_one_cache
      class_attribute :_has_many_cache
      class_attribute :_belongs_to_cache
      self._has_many_cache    = []
      self._has_one_cache     = []
      self._belongs_to_cache  = []
    end
    
    module ClassMethods

      # has_one
      def has_one association_name, *args
        options = args.extract_options!
        klass = options[:class_name]
        if association_name
          _has_one_cache << association_name
          send(:attributes, association_name)
        end
      end

      # has_many
      def has_many association_name, *args
        options = args.extract_options!
        klass = options[:class_name]
        if association_name
          _has_many_cache << association_name
          send(:attributes, association_name)
        end
      end

      # belongs_to
      def belongs_to association_name, *args
        options = args.extract_options!
        klass = options[:class_name]
        if association_name
          _belongs_to_cache << association_name
          send(:attributes, association_name)
        end
      end

      # Collect all associations
      def _associations
        _has_one_cache | _has_many_cache | _belongs_to_cache
      end
      
    end
    
    module InstanceMethods
    
      # Define defaults
      def initialize attributes={}
        send(:class)._belongs_to_cache.each { |name| send(:instance_variable_set, "@#{name}".to_sym, nil) }
        send(:class)._has_one_cache.each    { |name| send(:instance_variable_set, "@#{name}".to_sym, nil) }
        send(:class)._has_many_cache.each   { |name| send(:instance_variable_set, "@#{name}".to_sym, []) }
        super(attributes) # initialize as usual
      end
    
      # Exclude the associations from the attributes hash
      def attributes
        super.except(*send(:class)._associations.map(&:to_s))
      end
      
    end
  end
end