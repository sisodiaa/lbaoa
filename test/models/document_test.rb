require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  setup do
    @image_document = documents(:image)
  end

  teardown do
    @image_document = nil
  end

  test 'that a document without annotation is valid' do
    attach_file_to_record @image_document.attachment
    @image_document.annotation = ''
    assert @image_document.valid?
  end

  test 'that an annotation if present should not be more than 50 characters' do
    attach_file_to_record @image_document.attachment
    @image_document.annotation = 'a' * 51
    assert_not @image_document.valid?, 'Annotation is longer than 50 characters'
  end

  test 'that attachment without attachment is invalid' do
    assert_not @image_document.attachment.attached?,
               'Document should not have attachment'

    assert_not @image_document.valid?, 'Document without attachment is invalid'
  end

  test 'that document with attachment is valid' do
    attach_file_to_record @image_document.attachment
    assert @image_document.valid?
  end

  test 'that attachment should not be more than 5 MB in size' do
    attach_file_to_record @image_document.attachment
    # stub the file size to 21 MB
    @image_document.attachment.stub(:byte_size, 21.megabytes) do
      assert_not @image_document.valid?, 'Attachment size is bigger than 5 MB'
    end
  end

  test 'that only pdf and images are allowed as attachment' do
    attach_file_to_record @image_document.attachment
    # stub the content type to zip format
    @image_document.attachment.stub(:content_type, 'application/zip') do
      assert_not @image_document.valid?, 'Attachment should be image or pdf'
    end
  end
end
