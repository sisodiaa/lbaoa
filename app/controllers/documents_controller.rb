class DocumentsController < ApplicationController
  layout 'cms_sidebar'

  before_action :authenticate_admin!
  before_action :set_documentable
  before_action :set_documents, except: :destroy

  def index
    @document = @documentable.documents.new
    render 'main'
  end

  def create
    @document = @documentable.documents.build(document_params)

    if @document.save
      redirect_to post_documents_url(@documentable),
                  flash: { success: 'Attachment was successfully created.' }
    else
      render :index
    end
  end

  def destroy
    @document = @documentable.documents.find(params[:id])
    @document.destroy
    redirect_to post_documents_url(@documentable),
                flash: { success: 'Attachment was successfully destroyed.' }
  end

  private

  def set_documentable
    @documentable = Post.find(params[:post_id])
  end

  def set_documents
    @documents = @documentable.documents.with_attached_attachment
  end

  def document_params
    params.require(:document).permit(:annotation, :attachment)
  end
end
