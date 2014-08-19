class CommentsController < ApplicationController
  def create
    @advertisement = Advertisement.find(params[:comment][:advertisement_id])
    @comment = current_user.comment.build(comment_params)
    if @comment.save
      flash[:notice] = "You add a comment"
      respond_to do |format|
        format.html { redirect_to @advertisement }
        format.js
      end
    else
      flash[:alert] = "Comment not added"
      redirect_to @advertisement
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @advertisement = Advertisement.find(params[:advertisement_id])
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
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.destroy
        flash[:notice] = "Comment deleted."
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:user_id,:advertisement_id)
  end
end
