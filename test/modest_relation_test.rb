require 'test_helper'
require 'fixtures/sample_relation'

class ModestModelTest < ActiveSupport::TestCase
  test 'sample relation should have_one :address' do
    sample = SampleRelation.new
    sample.address = Address.new
    assert_equal Address, sample.address.class
  end

  test 'sample relation should have_many :orders' do
    sample = SampleRelation.new
    assert_equal 0, sample.orders.size
    sample.orders << Order.new
    sample.orders << Order.new
    assert_equal 2, sample.orders.size
  end

  test 'sample relation should belong_to :owner' do
    sample = SampleRelation.new
    sample.owner = Owner.new
    assert_equal Owner, sample.owner.class
  end

  test 'sample relation attributes should exclude the associations' do
    sample = SampleRelation.new
    sample.address = Address.new
    sample.orders << Order.new
    sample.orders << Order.new
    sample.owner = Owner.new
    sample.name = "Dummy Name"
    sample.email = "dummy@email.com"
    assert_equal 2, sample.attributes.size
  end

  test 'sample relation should only allow an Address to be set as the has_one :address' do
    sample = SampleRelation.new
    assert_raise(ModestModel::AssociationTypeMismatch) { sample.address = "INVALID" }
    assert_nothing_raised { sample.address = Address.new }
  end
end