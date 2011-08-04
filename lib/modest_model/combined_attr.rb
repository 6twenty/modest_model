module ModestModel
  module CombinedAttr
    def attribute *attrs
      validations = attrs.extract_options!
      attributes *attrs
      validates *(attrs +[validations]) if validations.any?
    end
  end
end