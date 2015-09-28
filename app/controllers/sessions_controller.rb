class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      	render :json => user
      else
        message  = "Неактивиран акаунт. "
        message += "Провери си пощата за линк за активация."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Невалидни email и/или парола"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
