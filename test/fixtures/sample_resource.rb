class SampleResource < ModestModel::Resource
  attributes :id, :name, :email
  attributes :saved_at, :destroyed_at
  attributes :find_callback, :create_callback, :save_callback, :update_callback, :destroy_callback

  # Attributes with validations
  attribute :nickname, :absence => true
  attribute :number, :numericality => {:allow_blank => true}
  
  after_find :set_find_callback
  def set_find_callback
    self.find_callback = true
  end
  
  after_create  do
    self.create_callback = true
  end
  
  after_update  do
    self.update_callback = true
  end
  

  after_save  do
    self.save_callback = true
  end
  
  after_destroy  do
    self.destroy_callback = true
  end
  
  find do
    # Some call
    self.attributes = {:name => "User", :email => "user@example.com"}
  end
  
  save do
    self.saved_at = Time.now
  end

  destroy do
    self.destroyed_at = Time.now
  end
  
end