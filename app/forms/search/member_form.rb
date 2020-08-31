module Search
  class MemberForm
    include ActiveModel::Model

    attr_accessor :email, :search_params
    validates :email,
              presence: true,
              format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }

    def initialize(attributes = {})
      @search_params = attributes.key?(:search_member_form) ? true : false

      form_attributes = attributes.fetch(:search_member_form, {})
      @email = form_attributes.fetch(:email, '')
    end

    def search
      return Member.none unless search_params?
      return Member.none unless valid?

      results
    end

    def results
      Member.confirmed.where(email: email)
    end

    def search_params?
      search_params
    end
  end
end
