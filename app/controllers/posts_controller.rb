class PostsController < ApplicationController
  def index
    @posts = Post.finished.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end
end
