class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = [@user.errors.full_messages]
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    if @user
      render :show
    else
      flash[:errors] = ["No user found"]
      redirect_to new_session_url
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :session_token, :password)
  end
end
