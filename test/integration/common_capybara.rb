def sign_in
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: '123456'
  click_on 'Sign in'
end