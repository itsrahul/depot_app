class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize, :update_counter
  helper_method :current_user, :logged_in?
  before_action :check_last_active, if: :logged_in?
  around_action :time_taken

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user != nil
  end
  protected

  def update_counter
    @page_counter = Counter.find_or_create_by(url: request.path)
    @page_counter.increment(:count, by = 1)
    @page_counter.save
  end

  # def set_counter
  #   if session[:counter].nil?
  #     session[:counter] = 0
  #   else
  #     session[:counter] = session[:counter] + 1
  #   end 
  # end

  def time_taken
    start_time = Time.current
    yield
    headers["X-Responded-In"] = Time.current - start_time
  end

  def check_last_active
    if (Time.current - current_user.last_active_at > 3000)
      redirect_to sessions_destroy_path, notice: 'Session expired due to inactivity for 5 minutes'
    else
      current_user.update_columns(last_active_at: Time.current)
    end
  end

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
        if logged_in?
          current_user.update_columns(language: params[:locale])
        end
      else
        flash.now[:notice] = 
          "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end
end
