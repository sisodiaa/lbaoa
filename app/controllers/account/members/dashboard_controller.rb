module Account
  module Members
    class DashboardController < ApplicationController
      include Pagy::Backend

      layout 'admin_sidebar'

      before_action :authenticate_admin!
      before_action :set_member, only: %i[show edit update]

      def index
        @status = params[:status]
        @pagy, @members = pagy(confirmed_members.order('created_at ASC'), items: 25)
      end

      def show; end

      def edit
        respond_to :js
      end

      def update
        if @member.update(member_params)
          redirect_to request.referer,
                      flash: { success: 'Member detail was successfully updated.' }
        else
          redirect_to request.referer,
                      flash: { error: 'Member detail was not updated.' }
        end
      end

      private

      def set_member
        @member = Member.find(params[:id])
      end

      def confirmed_members
        Member.confirmed.try!(@status.to_sym)
      rescue NoMethodError
        Member.none
      end

      def member_params
        params.require(:member).permit(:status)
      end
    end
  end
end
