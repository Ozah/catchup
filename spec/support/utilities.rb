def sign_in(user)
	# I couldn't find a way to use the cookie to sign in therefore I used the
	# password...
	user.set_password "foobar"
  user.save

  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: "foobar"
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end