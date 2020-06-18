class SessionsController < ApplicationController
  skip_before_action :authorize, :check_last_active
  # before_action :reset_counter
  
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      current_user.update_columns(last_active_at: Time.current)
      redirect_to user.role == 'user' ? admin_url : admin_reports_url
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: "Logged out"
  end

  # protected
  # def reset_counter
  #   session[:counter] = 0
  # end
end
