module Search
  class MembersController < ApplicationController
    layout 'cms_sidebar'

    before_action :authenticate_admin!

    def index
      @member = Search::MemberForm.new(params)
      @results = @member.search
    end
  end
end
