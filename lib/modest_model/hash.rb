class Hash
  def to_modest_model
    ModestModel::Object.new(self)
  end
end