require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  setup do
    @image_document = documents(:image)
    @excel_document = documents(:excel)
  end

  teardown do
    @image_document = @excel_document = nil
  end

  test 'that a document without annotation is valid' do
    attach_file_to_record(@image_document.attachment, 'square.png')
    @image_document.annotation = ''
    assert @image_document.valid?
  end

  test 'that an annotation if present should not be more than 50 characters' do
    attach_file_to_record(@image_document.attachment, 'square.png')
    @image_document.annotation = 'a' * 51
    assert_not @image_document.valid?, 'Annotation is longer than 50 characters'
  end

  test 'that attachment without file is invalid' do
    assert_not @image_document.attachment.attached?,
               'Document should have attachment'

    assert_not @image_document.valid?, 'Document without file is invalid'
  end

  test 'that document with attachment is valid' do
    attach_file_to_record(@image_document.attachment, 'square.png')
    assert @image_document.valid?
  end

  test 'that attachment should not be more than 5 MB in size' do
    attach_file_to_record(@image_document.attachment, 'square.png')
    # stub the file size to 21 MB
    @image_document.attachment.stub(:byte_size, 21.megabytes) do
      assert_not @image_document.valid?, 'Attachment size is bigger than 5 MB'
    end
  end

  test 'that only pdf and images are allowed as attachment for Post' do
    attach_file_to_record(@image_document.attachment, 'square.png')
    # stub the content type to zip format
    @image_document.attachment.stub(:content_type, 'application/zip') do
      assert_not @image_document.valid?, 'Attachment should be image or pdf'
    end
  end

  test 'that only xls and xlsx are allowed as attachment for TenderNotice' do
    attach_file_to_record(@excel_document.attachment, 'tender_notice.xlsx')
    # stub the content type to zip format
    @excel_document.attachment.stub(:content_type, 'application/zip') do
      assert_not @excel_document.valid?, 'Attachment should be xls or xlsx'
    end
  end
end
