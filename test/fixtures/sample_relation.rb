class SampleRelation < ModestModel::Base
  include ModestModel::Relation
  attributes :name, :email
  
  has_one :address
  has_many :orders
  belongs_to :owner
end