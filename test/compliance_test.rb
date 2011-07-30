require 'test_helper'
require 'fixtures/sample_model'

class ComplianceTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  test "model_name.human uses I18n" do
    begin
      I18n.backend.store_translations :en,
        :activemodel => { :models => { :sample_model => "My Sample Model" } }

      assert_equal "My Sample Model", model.class.model_name.human
    ensure
      I18n.reload!
    end
  end

  test "model_name exposes singular and human name" do
    assert_equal "sample_model", model.class.model_name.singular
    assert_equal "Sample model", model.class.model_name.human
  end

  def setup
    @model = SampleModel.new
  end
end