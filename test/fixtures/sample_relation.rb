class SampleRelation < ModestModel::Base
  attributes :name, :email
  has_one :address
  has_many :orders
  belongs_to :owner
end

class Address < ModestModel::Base
  attributes :name
  belongs_to :sample_relation
end

class Order < ModestModel::Base
  attributes :name
  belongs_to :sample_relation
end

class Owner < ModestModel::Base
  attributes :name
  has_one :sample_relation
end