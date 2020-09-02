class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_out_path_for(resource)
    if resource == :admin
      management_root_path
    else
      root_path
    end
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}",
                      scope: 'pundit',
                      default: :default

    redirect_to(request.referer || admin_root_path)
  end
end
