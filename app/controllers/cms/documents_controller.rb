module CMS
  class DocumentsController < ApplicationController
    before_action :set_documentable

    def index
      @documents = @documentable.documents.with_attached_attachment
    end

    def create
      @document = @documentable.documents.build(document_params)

      if @document.save
        redirect_to cms_post_documents_url(@documentable),
                    notice: 'Attachment was successfully created.'
      else
        render :index
      end
    end

    def destroy
      @document = @documentable.documents.find(params[:id])
      @document.destroy
      redirect_to cms_post_documents_url(@documentable),
                  notice: 'Attachment was successfully destroyed.'
    end

    private

    def set_documentable
      @documentable = Post.find(params[:post_id])
    end

    def document_params
      params.require(:document).permit(:annotation, :attachment)
    end
  end
end
