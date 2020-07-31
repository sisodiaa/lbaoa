module CMS
  class DashboardController < ApplicationController
    layout 'cms_sidebar'

    before_action :authenticate_cms_admin!

    def index; end
  end
end
