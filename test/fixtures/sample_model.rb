class SampleModel < SimpleModel::Base
  attributes :name, :email
  attributes :nickname
  validates :nickname, :absence => true
end