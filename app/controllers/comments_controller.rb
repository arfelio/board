class CommentsController < ApplicationController
  load_and_authorize_resource

  # The comment form and the Destroy buttons are submitted by Turbo, which asks for a
  # Turbo Stream: the page then updates in place (comments/*.turbo_stream.erb). Without
  # JavaScript the same requests are plain HTML and redirect back to the advertisement.
  def create
    @advertisement = Advertisement.find(params[:comment][:advertisement_id])
    @comment = current_user.comment.build(comment_params)
    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "You add a comment"
          @comment = Comment.new # empty form for the next comment
        end
        format.html { redirect_to @advertisement, notice: "You add a comment" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Comment not added"
          render :create, status: :unprocessable_content
        end
        format.html { redirect_to @advertisement, alert: "Comment not added" }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @advertisement = Advertisement.find(@comment.advertisement_id)
    if @comment.update(comment_params)
      flash[:notice] = "Comment updated"
      redirect_to @advertisement
    else
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Comment deleted." }
      format.html do
        redirect_back fallback_location: advertisements_path, notice: "Comment deleted.", status: :see_other
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:user_id,:advertisement_id)
  end
end
