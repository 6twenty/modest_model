require 'test_helper'
require 'fixtures/sample_model'

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

  test 'sample mail can ask if an attribute is present or not' do
    sample = SampleModel.new
    assert !sample.name?

    sample.name = "User"
    assert sample.name?

    sample.email = ""
    assert !sample.email?
  end

  test 'sample mail can clear attributes using clear_ prefix' do
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

  test 'sample mail has name and email as attributes' do
    sample = SampleModel.new
    sample.name = "User"
    assert_equal "User", sample.name
    sample.email = "user@example.com"
    assert_equal "user@example.com", sample.email
  end
end
