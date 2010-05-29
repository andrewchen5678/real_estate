# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    render
  end

  def create
    @user_auth = UserAuth.find_by_email(params[:email])
    if @user_auth
      @user_auth.deliver_password_reset_instructions! request.host,request.port
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_url
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    @user_auth.password = params[:user_auth][:password]
    @user_auth.password_confirmation = params[:user_auth][:password_confirmation]
    if @user_auth.save
      flash[:notice] = "Password successfully updated"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user_auth = UserAuth.find_using_perishable_token(params[:id])
    unless @user_auth
      flash[:notice] = "We're sorry, but we could not locate your account. " +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_url
    end
  end


end
