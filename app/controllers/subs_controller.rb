class SubsController < ApplicationController

  before_action :moderator_check, only: [:edit, :update]

  def index
    @subs = Sub.all
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def edit
    @sub = Sub.find_by(id: params[:id])
    render :edit
  end

  def update
    @sub = Sub.find_by(id: params[:id])
    user = User.find_by(user_name: params[:sub][:moderator])
    if user
      moderator_id = user.id
    end

    if @sub.update(title: sub_params[:title], description: sub_params[:description], moderator_id: @sub.moderator_id)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = [@sub.errors.full_messages]
      render :edit
    end
  end

  def create
    user = User.find_by(user_name: params[:sub][:moderator])
    if user
      moderator_id = user.id
    end

    @sub = Sub.new(title: sub_params[:title], description: sub_params[:description], moderator_id: moderator_id)

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = [@sub.errors.full_messages]
      render :new
    end
  end

  def show
    @sub = Sub.find_by(id: params[:id])
    if @sub
      render :show
    else
      flash[:errors] = ["No sub found"]
      redirect_to subs_url
    end
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def moderator_check
    @sub = Sub.find_by(id: params[:id])
    unless current_user && current_user.id == @sub.moderator_id
      flash[:errors] = ["Only moderators can edit subs"]
      redirect_to sub_url(@sub)
    end
  end
end
