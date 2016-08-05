class SubsController < ApplicationController
  def new
    @sub = Sub.new
    render :new
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = [@sub.errors.full_messages]
      render :edit
    end
  end

  def create
    @sub = Sub.new(sub_params)
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = [@sub.errors.full_messages]
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
    if @sub
      render :show
    else
      flash[:errors] = ["No sub found"]
      redirect_to subs_url
    end
  end

  private
  def subs_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end
end
