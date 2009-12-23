class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :destroy]
  
  def new
    @user = User.new
    
    respond_to do |format|
      format.html do
        @ugly_js = "openid.signin(openid.readCookie(), false);" if params[:autosubmit]
        render
      end
      format.js { render :layout => false }
    end
  end
  
  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = "Account registered!"
        # redirect_back_or_default account_url
        redirect_to jsauth_success_url(@user)
      else
        render :action => :new
      end
    end
  end
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user # makes our views "cleaner" and more consistent
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = "Account updated!"
        redirect_to account_url
      else
        render :action => :edit
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    current_user_session.destroy
    @user.destroy
    flash[:notice] = "Account deleted!"
    redirect_to new_account_url
  end
end
