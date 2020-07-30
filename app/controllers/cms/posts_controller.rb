module CMS
  class PostsController < ApplicationController
    include Pagy::Backend

    layout 'cms'

    before_action :authenticate_cms_admin!
    before_action :set_post, only: %i[show edit update publish destroy]

    # GET /posts
    def index
      @status = params[:status]
      @pagy, @posts = if params[:status] == 'draft'
                        pagy(Post.draft.order('created_at ASC'), items: 10)
                      else
                        pagy(Post.finished.order('published_at DESC'), items: 10)
                      end
    end

    # GET /posts/1
    def show
    end

    # GET /posts/new
    def new
      @post = Post.new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts
    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to cms_post_path(@post),
                    flash: { success: 'Post was successfully created.' }
      else
        render :new
      end
    end

    # PATCH/PUT /posts/1
    def update
      if @post.update(post_params)
        redirect_to cms_post_path(@post),
                    flash: { success: 'Post was successfully updated.' }
      else
        render :edit
      end
    end

    # PATCH/PUT /posts/1
    def publish
      authorize @post, policy_class: CMS::PostPolicy

      @post.publish if params.dig(:post, :publication_state) == 'finished'
      @post.published_at = Time.current

      if @post.finished? && @post.save
        redirect_to post_path(@post),
                    flash: { success: 'Post published successfully.' }
      else
        redirect_to cms_post_path(@post)
      end
    end

    # DELETE /posts/1
    def destroy
      authorize @post, policy_class: CMS::PostPolicy

      @post.destroy
      redirect_to cms_posts_url,
                  flash: { success: 'Post was successfully destroyed.' }
    end

    private

    def pundit_user
      current_cms_admin
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :category_id, :content, :tag_list)
    end
  end
end
