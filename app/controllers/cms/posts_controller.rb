module CMS
  class PostsController < ApplicationController
    layout 'cms'

    before_action :authenticate_cms_admin!
    before_action :set_post, only: %i[show edit update publish destroy]
    before_action :check_publication_status, only: %i[edit update destroy]

    # GET /posts
    def index
      @draft_posts = Post.draft.order('created_at ASC')
      @finished_posts = Post.finished.order('updated_at DESC')
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
      @post.publish if params.dig(:post, :publication_state) == 'finished'

      if @post.finished? && @post.save
        redirect_to post_path(@post),
                    flash: { success: 'Post published successfully.' }
      else
        redirect_to cms_post_path(@post)
      end
    end

    # DELETE /posts/1
    def destroy
      @post.destroy
      redirect_to cms_posts_url,
                  flash: { success: 'Post was successfully destroyed.' }
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def check_publication_status
      return unless @post.finished?

      redirect_to cms_post_path(@post),
                  notice: 'This operation is not allowed on finished post'
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :department_id, :content)
    end
  end
end
