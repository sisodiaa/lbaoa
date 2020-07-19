module CMS
  class DepartmentsController < ApplicationController
    before_action :authenticate_cms_admin!
    before_action :set_department, only: [:show, :edit, :update]

    # GET /departments
    def index
      @departments = Department.all
    end

    # GET /departments/1
    def show
    end

    # GET /departments/new
    def new
      @department = Department.new
    end

    # GET /departments/1/edit
    def edit
    end

    # POST /departments
    def create
      @department = Department.new(department_params)

      if @department.save
        redirect_to cms_department_path(@department),
                    flash: { success: 'Department was successfully created.' }
      else
        render :new
      end
    end

    # PATCH/PUT /departments/1
    def update
      if @department.update(department_params)
        redirect_to cms_department_path(@department),
                    flash: { success: 'Department was successfully updated.' }
      else
        render :edit
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def department_params
      params.require(:department).permit(:title, :description)
    end
  end
end
