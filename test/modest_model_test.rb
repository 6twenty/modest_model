require 'test_helper'
require 'fixtures/sample_model'
require 'fixtures/sample_relation'

class ModestModelTest < ActiveSupport::TestCase
  test "validates absence of nickname" do
    sample = SampleModel.new(:nickname => "Spam")
    assert !sample.valid?
    assert_equal ["is invalid"], sample.errors[:nickname]
  end
  
  test "can retrieve all attributes values" do
    sample = SampleModel.new
    sample.name = "John Doe"
    sample.email = "john.doe@example.com"
    assert_equal "John Doe", sample.attributes["name"]
    assert_equal "john.doe@example.com", sample.attributes["email"]
  end

  test 'sample model can ask if an attribute is present or not' do
    sample = SampleModel.new
    assert !sample.name?

    sample.name = "User"
    assert sample.name?

    sample.email = ""
    assert !sample.email?
  end

  test 'sample model can clear attributes using clear_ prefix' do
    sample = SampleModel.new
    sample.name  = "User"
    sample.email = "user@example.com"
    assert_equal "User", sample.name
    assert_equal "user@example.com", sample.email
    sample.clear_name
    sample.clear_email
    assert_nil sample.name
    assert_nil sample.email
  end

  test 'sample model has name and email as attributes' do
    sample = SampleModel.new
    sample.name = "User"
    assert_equal "User", sample.name
    sample.email = "user@example.com"
    assert_equal "user@example.com", sample.email
  end
  
  test 'sample relation should have_one :address' do
    sample = SampleRelation.new
    sample.address = "Dummy Address"
    assert_equal "Dummy Address", sample.address
  end
  
  test 'sample relation should have_many :orders' do
    sample = SampleRelation.new
    assert_equal 0, sample.orders.size
    sample.orders << "Dummy Order 1"
    sample.orders << "Dummy Order 2"
    assert_equal 2, sample.orders.size
  end
  
  test 'sample relation should belong_to :owner' do
    sample = SampleRelation.new
    sample.owner = "Dummy Owner"
    assert_equal "Dummy Owner", sample.owner
  end
  
  test 'sample relation should collect all associations' do
    sample = SampleRelation.new
    assert_equal 3, sample.class._associations.size
  end
  
  test 'sample relation attributes should exclude the associations' do
    sample = SampleRelation.new
    sample.address = "Dummy Address"
    sample.orders << "Dummy Order 1"
    sample.orders << "Dummy Order 2"
    sample.owner = "Dummy Owner"
    sample.name = "Dummy Name"
    sample.email = "dummy@email.com"
    assert_equal 2, sample.attributes.size
  end
  
  # test 'sample relation should only allow an Address to be set as the has_one :address' do
  #   sample = SampleRelation.new
  #   sample.address = "Dummy Address" # raise error? see AR
  #   sample.address = SampleAddress.new
  # end
end
