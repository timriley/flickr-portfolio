class Admin::LoginsController < Admin::AdminController
  skip_before_filter :login_required, :only => [:new, :create]
  
  def new
  end
  
  def create
    if Settings.instance.crypted_password?(params[:password])
      session[:logged_in] = true
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      flash[:error] = 'Incorrect password'
      render :action => 'new'
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = 'Logged out'
    redirect_back_or_default('/')
  end
end
