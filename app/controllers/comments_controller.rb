class CommentsController < ApplicationController

  def new
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.new
    render :new
  end

  def create
    @comment = Comment.new(
                     content: comment_params[:content],
                     post_id: comment_params[:post_id],
                     author_id: current_user.id)
    if @comment.save
      redirect_to post_url(comment_params[:post_id])
    else
      flash.now[:errors] = [@comment.errors.full_messages]
      render :new
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def user_check
    unless current_user
      flash[:errors] = ["Only logged in users can make posts"]
      redirect_to subs_url
    end
  end

end
