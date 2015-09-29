class SessionsController < ApplicationController

  def new
  end

  def create_base
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        
      	return user
      else
        message  = "Неактивиран акаунт. "
        message += "Провери си пощата за линк за активация."
        flash[:warning] = message
        
        #redirect_to root_url
        return "unactivated"
      end
    else
      flash.now[:danger] = "Невалидни email и/или парола"
      return false
      #render 'new'
    end
  end
  
  def create
		user = create_base
		
		case user
			when User
				redirect_back_or user	
			
			when "unactivated"
				redirect_to root_url
			
			when false
				render 'new'
		end
	end
	
	def create_remote
		user = create_base
		
		case user
			when User
				render :json => user
			
			else
				render "penis"
		end
	end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
