require 'application_system_test_case'

class AdminAuthenticationTest < ApplicationSystemTestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @unconfirmed_board_admin = admins(:unconfirmed_board_admin)
  end

  teardown do
    @confirmed_board_admin = @unconfirmed_board_admin = nil
  end

  test 'that error message is shown for invalid confirmation token' do
    skip
  end

  test 'confirms an unconfirmed admin' do
    visit "cms/admins/confirmation?confirmation_token=#{confirmation_token}"

    assert_no_selector 'p#notice'

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your email address has been successfully confirmed'
    end
  end

  test 'resend confirmation instructions cases' do
    visit new_cms_admin_confirmation_path

    # No Input
    click_on 'Resend confirmation instructions'

    assert_selector '#cms_admin_email.form-control.is-invalid'
    assert_selector '.invalid-feedback', text: "Email can't be blank"

    # Fill in an email which is not stored in DB
    fill_in 'cms_admin_email', with: 'test@example.com'
    click_on 'Resend confirmation instructions'

    assert_selector '#cms_admin_email.form-control.is-invalid'
    assert_selector '.invalid-feedback', text: 'Email not found'

    # Fill in an email which is already confirmed
    fill_in 'cms_admin_email', with: 'admin_one@example.com'
    click_on 'Resend confirmation instructions'

    assert_selector '#cms_admin_email.form-control.is-invalid'
    assert_selector '.invalid-feedback',
                    text: 'Email was already confirmed, please try signing in'

    # Fill with valid input
    fill_in 'cms_admin_email', with: @unconfirmed_board_admin.email
    click_on 'Resend confirmation instructions'

    within('.toast') do
      toast_body = 'You will receive an email with instructions for how to '\
                   'confirm your email address in a few minutes.'
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body', text: toast_body
    end
  end

  test 'authenticated and unauthenticated roots for CMS Admin' do
    visit cms_root_path

    assert_selector 'a.navbar-brand', text: 'Lotus Boulevard AOA CMS'

    within('form#new_cms_admin') do
      fill_in 'cms_admin_email', with: @confirmed_board_admin.email
      fill_in 'cms_admin_password', with: 'password'

      click_on 'Log in'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body', text: 'Signed in successfully.'
    end

    within('.posts.row') do
      assert_selector '#posts__draft'
      assert_selector '#posts__published'
    end

    within('nav.navbar') do
      click_on 'Logout'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body', text: 'Signed out successfully.'
    end

    assert_selector 'form#new_cms_admin'
  end

  test 'that sign in form show error for invalid email and/or password' do
    visit new_cms_admin_session_path

    within('form#new_cms_admin') do
      click_on 'Log in'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Alert'
      assert_selector '.toast-body', text: 'Invalid Email or password.'
    end
  end

  test 'that current password is required to make changes to admin model' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit edit_cms_admin_registration_path

    within('form#edit_cms_admin') do
      click_on 'Update'

      assert_selector '#cms_admin_current_password.form-control.is-invalid'
      assert_selector '.invalid-feedback',
                      text: "Current password can't be blank"

      fill_in 'cms_admin_current_password', with: 'password'
      fill_in 'cms_admin_password', with: 'dassworp'
      fill_in 'cms_admin_password_confirmation', with: 'dassworp'

      click_on 'Update'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your account has been updated successfully.'
    end

    logout :cms_admin
  end

  test 'changes password of an admin who forgot password' do
    visit "cms/admins/password/edit?reset_password_token=#{reset_password_token}"

    within('form#new_cms_admin') do
      fill_in 'cms_admin_password', with: 'dassworp'
      fill_in 'cms_admin_password_confirmation', with: 'dassworp'
      click_on 'Change my password'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your password has been changed successfully. '\
                            'You are now signed in.'
    end
  end

  test 'visiting password reset view without token' do
    visit edit_cms_admin_password_path

    within('.toast') do
      toast_body = "You can't access this page without coming from a password "\
                   'reset email. If you do come from a password reset email, '\
                   'please make sure you used the full URL provided.'

      assert_selector '.toast-header strong', text: 'Alert'
      assert_selector '.toast-body',
                      text: toast_body
    end
  end

  test 'when admin forgot the password' do
    visit new_cms_admin_password_path

    within('form#new_cms_admin') do
      click_on 'Send me reset password instructions'

      assert_selector '#cms_admin_email.is-invalid'

      fill_in 'cms_admin_email', with: @confirmed_board_admin.email
      click_on 'Send me reset password instructions'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'You will receive an email with instructions on '\
                            'how to reset your password in a few minutes.'
    end
  end

  test 'unlocking an admin account with unlock_token' do
    visit "/cms/admins/unlock?unlock_token=#{unlock_token}"

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your account has been unlocked successfully. '\
                            'Please sign in to continue.'
    end
  end

  test 'unlocking an admin account' do
    visit new_cms_admin_unlock_path

    fill_in 'cms_admin_email', with: @confirmed_board_admin.email
    click_on 'Resend unlock instructions'

    assert_selector '#cms_admin_email.is-invalid'
    assert_selector '.invalid-feedback', text: 'Email was not locked'

    @confirmed_board_admin.lock_access!

    fill_in 'cms_admin_email', with: @confirmed_board_admin.email
    click_on 'Resend unlock instructions'

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'You will receive an email with instructions for '\
                            'how to unlock your account in a few minutes.'
    end
  end

  private

  def confirmation_token
    devise_token_generator(Admin, :confirmation_token) do |raw, hashed|
      @unconfirmed_board_admin.confirmation_token = hashed
      @unconfirmed_board_admin.confirmation_sent_at = Time.now.utc
      @unconfirmed_board_admin.save

      raw
    end
  end

  def reset_password_token
    devise_token_generator(Admin, :reset_password_token) do |raw, hashed|
      @confirmed_board_admin.reset_password_token = hashed
      @confirmed_board_admin.reset_password_sent_at = Time.now.utc
      @confirmed_board_admin.save

      raw
    end
  end

  def unlock_token
    devise_token_generator(Admin, :unlock_token) do |raw, hashed|
      @confirmed_board_admin.unlock_token = hashed
      @confirmed_board_admin.locked_at = Time.now.utc - 2.hours
      @confirmed_board_admin.save

      raw
    end
  end
end
