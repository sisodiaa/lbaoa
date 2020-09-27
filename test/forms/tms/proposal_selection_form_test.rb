require 'test_helper'

module TMS
  class ProposalSelectionFormTest < ActiveSupport::TestCase
    include ActiveModel::Lint::Tests

    setup do
      @water_purifier = tender_notices(:water_purifier)
      @waterwala = tender_proposals(:waterwala)
      @model = TMS::ProposalSelectionForm.new(
        {
          reference_token: @water_purifier.reference_token,
          proposal_selection_form: {
            token: @waterwala.token,
            selection_reason: 'Good service and cost'
          }
        }
      )
    end

    teardown do
      @water_purifier = @waterwala = @model = nil
    end

    test 'that selection reason is given' do
      @model.selection_reason = ''

      assert_not @model.valid?
      assert_equal ["can't be blank"], @model.errors[:selection_reason]
    end

    test 'that proposal exist' do
      @model.token = 'abc123'

      assert_not @model.valid?
      assert_equal ['is not found in proposals submitted for the tender notice'],
                   @model.errors[:email]
    end

    test 'selection will not happen for tender notice is not under review' do
      @model.reference_token = tender_notices(:elevator_buttons).reference_token

      assert_not @model.select

      assert_equal ['is not found in proposals submitted for the tender notice'],
                   @model.errors[:email]
    end

    test 'successfull proposal selection' do
      @water_purifier.proposals.each do |proposal|
        attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
      end

      assert @model.select

      assert @waterwala.reload.selected?
      assert @water_purifier.reload.archived?
      assert_equal 'Good service and cost', @water_purifier.reload.selection_reason
      assert tender_proposals(:paaniwala).rejected?
      assert tender_proposals(:purifierwala).rejected?
    end
  end
end
