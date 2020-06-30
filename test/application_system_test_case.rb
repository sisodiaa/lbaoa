require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def remove_uploaded_files
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end

  def after_teardown
    super
    remove_uploaded_files
  end
end
