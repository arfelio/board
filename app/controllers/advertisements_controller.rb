class AdvertisementsController < ApplicationController
  load_and_authorize_resource
  def index
    @categories = Category.all
    if params[:query].present?
      @advertisements = Advertisement.text_search(params[:query]).
        paginate(:page => params[:page], :per_page => 10)
    elsif params[:user_id]
      @advertisements = Advertisement.where(user_id: params[:user_id]).
        paginate(:page => params[:page], :per_page => 10)
    else
      @advertisements = params[:category_id] ? Advertisement.where(category_id: params[:category_id]).
        paginate(:page => params[:page], :per_page => 10) : Advertisement.
        paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @comment = Comment.new
    @advertisement = Advertisement.find(params[:id])
  end

  def create
    @advertisement = current_user.advertisement.build(advertisement_params)
    if @advertisement.save
      flash[:success] = "Success! Advertisement created"
      redirect_to @advertisement
    else
      render 'new'
    end
  end

  def new
    @advertisement = Advertisement.new
  end

  def edit
    @advertisement = Advertisement.find(params[:id])
  end

  def update
    @advertisement = Advertisement.find(params[:id])
    if @advertisement.update_attributes(advertisement_params)
      flash[:success] = "Advertisement updated"
      redirect_to @advertisement
    else
      render 'edit'
    end
  end

  def destroy
    Advertisement.find(params[:id]).destroy
    flash[:success] = "Advertisement deleted."
    redirect_to advertisements_path
  end

  private

  def advertisement_params
    params.require(:advertisement).permit(:user_id,:image,:title,:category_id,:remote_image_url,:content=>[])
  end
end
