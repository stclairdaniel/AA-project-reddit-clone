class SessionsController < ApplicationController
  def create
    @user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Incorrect credentials"]
      render :new
    end
  end

  def new
    render :new
  end

  def destroy
    if current_user
      logout!
      redirect_to new_session_url
    end
  end

  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
