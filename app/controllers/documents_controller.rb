class DocumentsController < ApplicationController
  layout 'cms_sidebar'

  before_action :authenticate_admin!
  before_action :set_documentable
  before_action :set_url
  before_action :set_documents, if: -> { @documentable.is_a? Post }, except: :destroy

  def index
    @document = @documentable.documents.new
  end

  def show
    @document = @documentable.document || @documentable.build_document
  end

  def create
    @document = set_document_for_create

    if @document.save
      redirect_to @url, flash: { success: 'Attachment was successfully created.' }
    else
      render template
    end
  end

  def destroy
    @document = set_document_for_destroy
    authorize @document, policy_class: DocumentPolicy

    @document.destroy
    redirect_to @url, flash: { success: 'Attachment was successfully destroyed.' }
  end

  private

  def pundit_user
    current_admin
  end

  def set_url
    @url = polymorphic_path([@documentable, document])
  end

  def document
    @documentable.is_a?(Post) ? Document : :document
  end

  def template
    @documentable.is_a?(Post) ? 'index' : 'show'
  end

  def set_documentable
    @documentable = documentable
  end

  def documentable
    return Post.find(params[:post_id]) if params.key?(:post_id)

    TenderNotice.find_by(reference_token: params[:tender_notice_reference_token])
  end

  def set_documents
    @documents = @documentable.documents.with_attached_attachment
  end

  def set_document_for_create
    if @documentable.is_a? Post
      @documentable.documents.build(document_params)
    else
      @documentable.build_document(document_params)
    end
  end

  def set_document_for_destroy
    if @documentable.is_a? Post
      @documentable.documents.find(params[:id])
    else
      @documentable.document
    end
  end

  def document_params
    params.require(:document).permit(:annotation, :attachment)
  end
end
