def set_user
  user = Fabricate :user
  session[:user_id] = user.id
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  @current_user ||= User.find session[:user_id]
end
