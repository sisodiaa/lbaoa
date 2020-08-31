require 'test_helper'

module Search
  class MemberFormTest < ActiveSupport::TestCase
    include ActiveModel::Lint::Tests

    setup do
      @model = Search::MemberForm.new(
        {
          search_member_form: {
            email: 'test@example.com'
          }
        }
      )
    end

    teardown do
      @model = nil
    end

    test 'that email is present' do
      @model.email = ''

      assert_not @model.valid?
      assert_includes @model.errors[:email], "can't be blank"
    end

    test 'that email address format is valid' do
      @model.email = 'a@b'

      assert_not @model.valid?
      assert_equal ['is invalid'], @model.errors[:email]
    end
  end
end
