module Search
  class PostsController < ApplicationController
    include Pagy::Backend

    before_action :authenticate_member!

    def index
      @post = Search::PostForm.new(params)
      @pagy, @results = pagy(@post.search.order(published_at: :desc), items: 10)
    end
  end
end
