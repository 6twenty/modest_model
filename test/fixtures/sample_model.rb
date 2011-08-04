class SampleModel < ModestModel::Base
  attributes :name, :email
  attribute :nickname, :absence => true
end