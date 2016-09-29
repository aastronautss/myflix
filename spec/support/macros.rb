# ====-----------------------------====
# Controller and Model Specs
# ====-----------------------------====

def set_user user = nil
  user ||= Fabricate :user
  session[:user_id] = user.id
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  @current_user ||= User.find session[:user_id]
end

# ====-----------------------------====
# Feature Specs
# ====-----------------------------====

def sign_in(a_user = nil)
  user = a_user || Fabricate(:user)

  visit login_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
