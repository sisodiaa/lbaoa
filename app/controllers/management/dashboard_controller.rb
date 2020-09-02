module Management
  class DashboardController < ApplicationController
    layout 'cms_sidebar'

    before_action :authenticate_admin!

    def index; end
  end
end
