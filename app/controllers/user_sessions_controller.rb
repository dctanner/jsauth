class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_no_user_so_destroy_if_exists, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def require_no_user_so_destroy_if_exists
    current_user_session.destroy if current_user
  end
  
  def new
    @this_base_url = "http://#{self.request.host}#{':'+self.request.port.to_s if self.request.port != 80}"
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
        @user = @user_session.record
        # redirect_back_or_default account_url
        app_url = "http://localhost:9393/authenticate"
        params_to_send = Hash[*([:id, :email, :first_name, :last_name].map {|k| [k, @user.send(k)] }).flatten]
        params_to_send[:signature] = "USEHMACSIGN"
        success_url = "#{app_url}?#{params_to_send.to_query}"
        redirect_to success_url
      else
        # TODO: A very brittle way of catching non-registered users and then submitting the registration form so they don't notice. We really should raise and rescue, but I would rather wait until auto_register works properly and fetches the email then hack authlogic_openid
        if @user_session.errors.on(:openid_identifier) == "did not match any users in our database, have you set up your account to use OpenID?"
          redirect_to :controller => 'users', :action => 'new', :autosubmit => 'true'
        else
          render :action => :new
        end
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
