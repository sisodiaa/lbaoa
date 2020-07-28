class PostsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @posts = pagy(Post.finished.order(published_at: :desc), items: 6)
  end

  def show
    @post = Post.find(params[:id])
  end
end
