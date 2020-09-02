module CMS
  class CategoriesController < ApplicationController
    include Pagy::Backend

    layout 'cms_sidebar'

    before_action :authenticate_admin!
    before_action :set_category, only: %i[show edit update]

    # GET /categories
    def index
      @pagy, @categories = pagy(Category.all, items: 10)
    end

    # GET /categories/1
    def show
    end

    # GET /categories/new
    def new
      @category = Category.new
    end

    # GET /categories/1/edit
    def edit
    end

    # POST /categories
    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to cms_category_path(@category),
                    flash: { success: 'Category was successfully created.' }
      else
        render :new
      end
    end

    # PATCH/PUT /categories/1
    def update
      if @category.update(category_params)
        redirect_to cms_category_path(@category),
                    flash: { success: 'Category was successfully updated.' }
      else
        render :edit
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:title, :description)
    end
  end
end
