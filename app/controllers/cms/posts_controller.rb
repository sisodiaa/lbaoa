module CMS
  class PostsController < ApplicationController
    include Pagy::Backend

    layout 'admin_sidebar'

    before_action :authenticate_admin!
    before_action :set_post, only: %i[show edit update publish cast destroy]

    # GET /posts
    def index
      @status = params[:status]
      @pagy, @posts = if params[:status] == 'draft'
                        pagy(Post.draft.includes([:category]).order('created_at ASC'), items: 10)
                      else
                        pagy(Post.finished.includes([:category]).order('published_at DESC'), items: 10)
                      end
    end

    # GET /posts/1
    def show
      @documents = @post.documents.with_attached_attachment
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

    def cast
      flash_message = cast_and_set_flash_message

      @post.save

      flash[:success] = flash_message if flash_message.present?
      redirect_to cms_post_path(@post)
    end

    # DELETE /posts/1
    def destroy
      authorize @post, policy_class: CMS::PostPolicy

      @post.documents.with_attached_attachment.destroy_all
      @post.destroy
      redirect_to cms_posts_url,
                  flash: { success: 'Post was successfully destroyed.' }
    end

    private

    def pundit_user
      current_admin
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :category_id, :content, :tag_list)
    end

    def cast_and_set_flash_message
      case params.dig(:post, :visibility_state)
      when 'visitors'
        @post.broadcast
        'Post visibility status set for visitors.'
      when 'members'
        @post.narrowcast
        'Post visibility status set for members only.'
      end
    end
  end
end
