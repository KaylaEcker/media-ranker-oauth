class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def login

    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      user = User.find_by(provider: params[:provider], uid: auth_hash['uid'])

      if user.nil?
        user = User.from_auth_hash(params[:provider], auth_hash)

        if user.save
          session[:user_id] = user.id
          flash[:status] = :success
          flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
        else
          flash.now[:status] = :failure
          flash.now[:result_text] = "Could not log in"
          flash.now[:messages] = user.errors.messages
        end

      else
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as returning user #{user.name}"
      end

      session[:user_id] = user.id

    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create user from OAuth data"
    end

    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
    flash[:status] = :success
    flash[:message] = "Successfully logged out"
  end
end
