module ModestModel
  module CombinedAttr
    def attribute *attrs
      options = attrs.extract_options!
      validations = options.slice!(*_validates_default_keys)
      attributes *attrs
      validates *(attrs +[validations]) if validations.any?
    end
  end
end