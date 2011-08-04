require 'test_helper'
require 'fixtures/sample_resource'

class SampleResourceTest < ActiveSupport::TestCase
  
  # Test the base functionality works!
  
  test "validates absence of nickname" do
    sample = SampleResource.new(:nickname => "Spam")
    assert !sample.valid?
    assert_equal ["is invalid"], sample.errors[:nickname]
  end
  
  test "can retrieve all attributes values" do
    sample = SampleResource.new
    sample.name = "John Doe"
    sample.email = "john.doe@example.com"
    assert_equal "John Doe", sample.attributes["name"]
    assert_equal "john.doe@example.com", sample.attributes["email"]
  end

  test 'sample mail can ask if an attribute is present or not' do
    sample = SampleResource.new
    assert !sample.name?

    sample.name = "User"
    assert sample.name?

    sample.email = ""
    assert !sample.email?
  end

  test 'sample mail can clear attributes using clear_ prefix' do
    sample = SampleResource.new
    sample.name  = "User"
    sample.email = "user@example.com"
    assert_equal "User", sample.name
    assert_equal "user@example.com", sample.email
    sample.clear_name
    sample.clear_email
    assert_nil sample.name
    assert_nil sample.email
  end

  test 'sample mail has name and email as attributes' do
    sample = SampleResource.new
    sample.name = "User"
    assert_equal "User", sample.name
    sample.email = "user@example.com"
    assert_equal "user@example.com", sample.email
  end
  
  # Testing the resource ability
  
  test "the create method returns a newly created object" do
    sample = SampleResource.create(:name => 'User', :email => 'user@example.com')
    assert_equal false, sample.new_record?
    assert_equal "User", sample.name
    assert_equal "user@example.com", sample.email
  end
  
  test "the find method returns a record with the id set" do
    sample = SampleResource.find(1)
    assert_equal 1, sample.id
    assert_equal "User", sample.name
    assert_equal "user@example.com", sample.email
  end
  
  test "the save method perfoms its action correctly" do
    sample = SampleResource.find(1)
    assert_equal nil, sample.saved_at
    sample.save
    assert_equal Time.now.to_s, sample.saved_at.to_s
  end
  
  test "the destroy method perfoms its action correctly" do
    sample = SampleResource.find(1)
    assert_equal nil, sample.destroyed_at
    assert_equal false, sample.destroyed?
    sample.destroy
    assert_equal true, sample.destroyed?
    assert_equal Time.now.to_s, sample.destroyed_at.to_s
  end

  test "setting the primary key sets a new attribute and removes the old one" do
    sample = SampleResource.find(1)
    assert_equal false, SampleResource.method_defined?(:new_id)
    assert_equal 1, sample.id
    SampleResource.set_primary_key :new_id
    sample = SampleResource.find(1)
    assert_equal false, SampleResource.method_defined?(:id)
    assert_equal 1, sample.new_id
    # Teardown
    SampleResource.set_primary_key :id
  end
  
  # Testing the validations on save
  
  test "the validations work on save not just valid?" do
    sample = SampleResource.new(:number => 'INVALID')
    assert_equal false, sample.save
    assert_equal ["is not a number"], sample.errors[:number]

    sample = SampleResource.create(:number => 'INVALID')
    assert_equal ["is not a number"], sample.errors[:number]

    sample = SampleResource.new
    assert_equal false, sample.update_attributes(:number => 'INVALID')
    assert_equal ["is not a number"], sample.errors[:number]
  end
  
  # Testing the callbacks
  
  test "the find callback works" do
    sample = SampleResource.new
    assert_equal nil, sample.find_callback
    sample = SampleResource.find(1)
    assert_equal true, sample.find_callback
  end
  
  test "the create callback works" do
    sample = SampleResource.new
    assert_equal nil, sample.create_callback
    sample = SampleResource.create
    assert_equal true, sample.create_callback
  end

  test "the save callback works" do
    sample = SampleResource.new
    assert_equal nil, sample.save_callback
    sample.save
    assert_equal true, sample.save_callback
    sample = SampleResource.create
    assert_equal true, sample.save_callback
    sample.update_attribute :save_callback, false
    assert_equal true, sample.save_callback
  end

  test "the update callback works" do
    sample = SampleResource.find(1)
    assert_equal nil, sample.update_callback
    sample.update_attribute :update_callback, false
    assert_equal true, sample.update_callback
  end

  test "the destroy callback works" do
    sample = SampleResource.find(1)
    assert_equal nil, sample.destroy_callback
    sample.destroy
    assert_equal true, sample.destroy_callback
  end

end
