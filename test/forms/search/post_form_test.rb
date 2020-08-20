require 'test_helper'

module Search
  class PostFormTest < ActiveSupport::TestCase
    include ActiveModel::Lint::Tests

    setup do
      @model = Search::PostForm.new(
        {
          search_post_form: {
            category: 'helpdesk',
            tag_list: 'lotus, boulevard',
            start_date: '2020-08-11',
            end_date: '2022-08-12'
          }
        }
      )
    end

    teardown do
      @model = nil
    end

    test 'that tags should be fewer than 3' do
      @model.tag_list = 'lotus, boulevard, society, noida'

      assert_not @model.valid?
      assert_equal ['should be 3 or fewer'], @model.errors[:tags]
    end

    test 'that start_date should be before or on end_date' do
      @model.start_date = '2022-08-12'.to_date
      @model.end_date = '2020-08-11'.to_date

      assert_not @model.valid?
      assert_equal ['should be before end date'], @model.errors[:start_date]
    end

    test 'that start_date should be present when end_date is given' do
      @model.start_date = nil
      @model.end_date = '2020-08-11'.to_date

      assert_not @model.valid?
      assert_equal ['is required if end date is present'],
                   @model.errors[:start_date]
    end
  end
end
