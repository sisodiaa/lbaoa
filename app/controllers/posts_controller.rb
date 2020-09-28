class PostsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @posts = pagy(
      posts.finished.includes(:category, :rich_text_content).order(published_at: :desc), items: 6
    )
  end

  def show
    @post = Post.find(params[:id])
    @documents = @post.documents.with_attached_attachment
  end

  private

  def posts
    return Post.all if member_signed_in?

    Post.visitors
  end
end
