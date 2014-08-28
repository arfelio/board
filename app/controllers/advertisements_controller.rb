class AdvertisementsController < ApplicationController
  load_and_authorize_resource
  def index
    if params[:query].present?
      @advertisements = Advertisement.text_search(params[:query])
    else
      @advertisements = Advertisement.all
    end
    #@advertisements = Advertisement.all
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
    redirect_to :back
  end

  private

  def advertisement_params
    params.require(:advertisement).permit(:user_id,:image,:author,:content)
  end
end
