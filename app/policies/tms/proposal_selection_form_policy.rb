module TMS
  class ProposalSelectionFormPolicy
    attr_reader :user, :proposal_selection_form

    def initialize(user, proposal_selection_form)
      @user = user
      @proposal_selection_form = proposal_selection_form
    end

    def create?
      user.board_member?
    end
  end
end
