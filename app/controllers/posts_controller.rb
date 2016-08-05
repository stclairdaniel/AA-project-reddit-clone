class PostsController < ApplicationController
  before_action :author_check, only: [:edit, :update, :delete]
  before_action :user_check, only: [:new, :create]

  def destroy
    @post = Post.find(params[:id])
    sub_id = @post.sub_id
    @post.destroy
    redirect_to sub_url(sub_id)
  end

  def new
    @post = Post.new
    render :new
  end

  def edit
    @post = Post.find_by(id: params[:id])
    render :edit
  end

  def update
    @post = Post.find_by(id: params[:id])
    sub = Sub.find_by(title: post_params[:sub_title])
    sub_id = sub.id if sub
    if @post.update(title: post_params[:title],
                     content: post_params[:content],
                     url: post_params[:url],
                     sub_id: sub_id,
                     author_id: current_user.id)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = [@post.errors.full_messages]
      render :new
    end

  end

  def create
    sub = Sub.find_by(title: post_params[:sub_title])
    sub_id = sub.id if sub

    @post = Post.new(title: post_params[:title],
                     content: post_params[:content],
                     url: post_params[:url],
                     sub_id: sub_id,
                     author_id: current_user.id)
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = [@post.errors.full_messages]
      render :new
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post
      render :show
    else
      flash[:errors] = ["No post found"]
      redirect_to subs_url
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :url, :sub_title)
  end

  def author_check
    @post = Post.find_by(id: params[:id])
    unless current_user && current_user.id == @post.author_id
      flash[:errors] = ["Only this post's author can make edits"]
      redirect_to post_url(@post)
    end
  end

  def user_check
    unless current_user
      flash[:errors] = ["Only logged in users can make posts"]
      redirect_to subs_url
    end
  end
end
