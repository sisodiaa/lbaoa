class ApplicationController < ActionController::Base
  def after_sign_out_path_for(resource)
    if resource == :cms_admin
      cms_root_path
    else
      root_path
    end
  end
end
