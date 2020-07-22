module CMS
  class PostPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end

    def publish?
      record.draft? && user.board_member?
    end

    def destroy?
      record.draft? || (record.finished? && user.board_member?)
    end
  end
end
