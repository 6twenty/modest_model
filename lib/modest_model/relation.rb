module ModestModel
  class AssociationTypeMismatch < ::StandardError; end
  
  module Relation
    extend ActiveSupport::Concern
    
    # Store the associations so that they can be referenced later
    included do
      class_attribute :_has_one_cache
      class_attribute :_has_many_cache
      class_attribute :_belongs_to_cache
      self._has_many_cache    = {}
      self._has_one_cache     = {}
      self._belongs_to_cache  = {}
    end
    
    module ClassMethods
      
      # has_one
      def has_one association_name, *args
        define_association_methods(:has_one, association_name, *args) if association_name
      end
      
      # has_many
      def has_many association_name, *args
        define_association_methods(:has_many, association_name, *args) if association_name
      end
      
      # belongs_to
      def belongs_to association_name, *args
        define_association_methods(:belongs_to, association_name, *args) if association_name
      end
      
      private

      def define_association_methods(association_type, association_name, *args)
        options = args.extract_options!
        class_name = (options[:class_name] ? options[:class_name] : association_name.to_s.camelize)
        self.send("_#{association_type}_cache")[association_name] = class_name

        getter = "#{association_name}"
        setter = "#{association_name}="

        define_method(getter) do
          default = association_type == :has_many ? Collection.new(class_name) : nil
          instance_variable_set("@#{association_name}", instance_variable_get("@#{association_name}") || default)
        end
        
        expected_value = self.send("_#{association_type}_cache")[association_name]
        
        define_method(setter) do |value|
          if association_type == :has_many
            raise_error = true unless value.nil? || value.kind_of?(Array)
            if value
              value.reject! { |item| !(expected_value =~ /#{item.class.to_s}/) }
              unless value.is_a?(ModestModel::Collection)
                collection = Collection.new(class_name)
                value.each { |v| collection << v }
                value = collection
              end
            end
          else
            raise_error = true unless value.nil? || expected_value =~ /#{value.class.to_s}/
          end
          
          if raise_error
            error_message = "#{expected_value} expected, got #{value.class.to_s}"
            raise AssociationTypeMismatch.new(error_message)
          end
          
          instance_variable_set("@#{association_name}", value)
        end
      end
    end
  end
end