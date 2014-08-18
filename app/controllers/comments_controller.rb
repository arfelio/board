class CommentsController < ApplicationController
  def create
    @advertisement = Advertisement.find(params[:comment][:advertisement_id])
    @comment = current_user.comment.build(comment_params)
    if @comment.save
      flash[:notice] = "You add a comment"
      redirect_to @advertisement
    else
      flash[:alert] = "Comment not added"
      redirect_to @advertisement
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @advertisement = Advertisement.find(@comment.advertisement_id)
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Comment updated"
      redirect_to @advertisement
    else
      render 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:notice] = "Comment deleted."
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:user_id,:advertisement_id)
  end
end
