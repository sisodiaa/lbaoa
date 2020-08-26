require 'application_system_test_case'

class MemberAuthenticationTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_member = members(:confirmed_member)
    @unconfirmed_member = members(:unconfirmed_member)
  end

  teardown do
    @confirmed_member = @unconfirmed_member = nil
    Warden.test_reset!
  end

  test 'that error message is shown for invalid confirmation token' do
    visit 'members/confirmation?confirmation_token=abc123'

    assert_selector '.invalid-feedback', text: 'Confirmation token is invalid'
  end

  test 'confirms an unconfirmed member' do
    visit "members/confirmation?confirmation_token=#{confirmation_token}"

    assert_no_selector 'p#notice'

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your email address has been successfully confirmed'
    end
  end

  test 'resend confirmation instructions cases' do
    visit new_member_confirmation_path

    # No Input
    click_on 'Resend confirmation instructions'

    assert_selector '#member_email.form-control.is-invalid'
    assert_selector '.invalid-feedback', text: "Email can't be blank"

    # Fill in an email which is not stored in DB
    fill_in 'member_email', with: 'test@example.com'
    click_on 'Resend confirmation instructions'

    assert_selector '#member_email.form-control.is-invalid'
    assert_selector '.invalid-feedback', text: 'Email not found'

    # Fill in an email which is already confirmed
    fill_in 'member_email', with: 'member_one@example.com'
    click_on 'Resend confirmation instructions'

    assert_selector '#member_email.form-control.is-invalid'
    assert_selector '.invalid-feedback',
                    text: 'Email was already confirmed, please try signing in'

    # Fill with valid input
    fill_in 'member_email', with: @unconfirmed_member.email
    click_on 'Resend confirmation instructions'

    within('.toast') do
      toast_body = 'You will receive an email with instructions for how to '\
                   'confirm your email address in a few minutes.'
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body', text: toast_body
    end
  end

  test 'authenticated root for members' do
    visit new_member_session_path

    within('form#new_member') do
      fill_in 'member_email', with: @confirmed_member.email
      fill_in 'member_password', with: 'password'

      click_on 'Log in'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body', text: 'Signed in successfully.'
    end

    assert_selector '.posts.row'

    within('nav.navbar') do
      click_on @confirmed_member.email.to_s
      click_on 'Logout'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body', text: 'Signed out successfully.'
    end

    assert_selector 'section#main'
  end

  test 'that sign in form show error for invalid email and/or password' do
    visit new_member_session_path

    within('form#new_member') do
      click_on 'Log in'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Alert'
      assert_selector '.toast-body', text: 'Invalid Email or password.'
    end
  end

  test 'that current password is required to make changes to member model' do
    login_as @confirmed_member, scope: :member

    visit edit_member_registration_path

    within('form#edit_member') do
      click_on 'Update'

      assert_selector '#member_current_password.form-control.is-invalid'
      assert_selector '.invalid-feedback',
                      text: "Current password can't be blank"

      fill_in 'member_current_password', with: 'password'
      fill_in 'member_password', with: 'dassworp'
      fill_in 'member_password_confirmation', with: 'dassworp'

      click_on 'Update'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your account has been updated successfully.'
    end

    logout :member
  end

  test 'that error message is shown for invalid reset password token' do
    visit 'members/password/edit?reset_password_token=abc123'

    click_on 'Change my password'

    assert_selector '.invalid-feedback', text: 'Reset password token is invalid'
  end

  test 'changes password of a member who forgot password' do
    visit "members/password/edit?reset_password_token=#{reset_password_token}"

    within('form#new_member') do
      fill_in 'member_password', with: 'dassworp'
      fill_in 'member_password_confirmation', with: 'dassworp'
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
    visit edit_member_password_path

    within('.toast') do
      toast_body = "You can't access this page without coming from a password "\
                   'reset email. If you do come from a password reset email, '\
                   'please make sure you used the full URL provided.'

      assert_selector '.toast-header strong', text: 'Alert'
      assert_selector '.toast-body',
                      text: toast_body
    end
  end

  test 'when member forget the password' do
    visit new_member_password_path

    within('form#new_member') do
      click_on 'Send me reset password instructions'

      assert_selector '#member_email.is-invalid'

      fill_in 'member_email', with: @confirmed_member.email
      click_on 'Send me reset password instructions'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'You will receive an email with instructions on '\
                            'how to reset your password in a few minutes.'
    end
  end

  test 'that error message is shown for invalid unlock token' do
    visit 'members/unlock?unlock_token=abc123'

    assert_selector '.invalid-feedback', text: 'Unlock token is invalid'
  end

  test 'unlocking a member account with unlock_token' do
    visit "/members/unlock?unlock_token=#{unlock_token}"

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'Your account has been unlocked successfully. '\
                            'Please sign in to continue.'
    end
  end

  test 'unlocking a member account' do
    visit new_member_unlock_path

    fill_in 'member_email', with: @confirmed_member.email
    click_on 'Resend unlock instructions'

    assert_selector '#member_email.is-invalid'
    assert_selector '.invalid-feedback', text: 'Email was not locked'

    @confirmed_member.lock_access!

    fill_in 'member_email', with: @confirmed_member.email
    click_on 'Resend unlock instructions'

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Notice'
      assert_selector '.toast-body',
                      text: 'You will receive an email with instructions for '\
                            'how to unlock your account in a few minutes.'
    end
  end

  test 'that inactive member can not log in ' do
    skip
    visit new_member_session_path

    within('form#new_member') do
      fill_in 'member_email', with: members(:inactive_member).email
      fill_in 'member_password', with: 'password'
      click_on 'Log in'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Alert'
      assert_selector '.toast-body', text: 'Your account is not active.'
    end
  end

  private

  def confirmation_token
    devise_token_generator(Member, :confirmation_token) do |raw, hashed|
      @unconfirmed_member.confirmation_token = hashed
      @unconfirmed_member.confirmation_sent_at = Time.now.utc
      @unconfirmed_member.save

      raw
    end
  end

  def reset_password_token
    devise_token_generator(Member, :reset_password_token) do |raw, hashed|
      @confirmed_member.reset_password_token = hashed
      @confirmed_member.reset_password_sent_at = Time.now.utc
      @confirmed_member.save

      raw
    end
  end

  def unlock_token
    devise_token_generator(Member, :unlock_token) do |raw, hashed|
      @confirmed_member.unlock_token = hashed
      @confirmed_member.locked_at = Time.now.utc - 2.hours
      @confirmed_member.save

      raw
    end
  end
end
