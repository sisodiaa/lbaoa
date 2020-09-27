require 'test_helper'

class TMS::ProposalSelectionFormPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @confirmed_staff_admin = admins(:confirmed_staff_admin)

    @proposal_selection_form = TMS::ProposalSelectionForm.new
  end

  teardown do
    @proposal_selection_form = nil
    @confirmed_staff_admin = @confirmed_board_admin = nil
  end

  test '#create?' do
    assert_not TMS::ProposalSelectionFormPolicy.new(
      @confirmed_staff_admin, @proposal_selection_form
    ).create?

    assert TMS::ProposalSelectionFormPolicy.new(
      @confirmed_board_admin, @proposal_selection_form
    ).create?
  end
end
