class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_no_user_so_destroy_if_exists, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def require_no_user_so_destroy_if_exists
    current_user_session.destroy if current_user
  end
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    # We are saving with a block to accomodate for OpenID authentication
    # If you are not using OpenID you can save without a block:
    #
    #   if @user_session.save
    #     # ... successful login
    #   else
    #     # ... unsuccessful login
    #   end
    @user_session.save do |result|
      if result
        flash[:notice] = "Login successful!"
        # @user = @user_session.record
        # render :action => :jsauth_success, :layout => 'jsauth'
        redirect_back_or_default account_url
      else
        render :action => :new
      end
    end
  end
  
  def jsauth_success
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
