class UsersController < ApplicationController
  load_and_authorize_resource

  def new
    @user=User.new
  end

  def show
    if params[:id].blank?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  def index
    @users = User.paginate(:page => params[:page], :per_page => 3)
  end

  def create
    @user = User.new(user_params)
    if  @user.save
      flash[:notice]="Success user created"
      redirect_to user_path(@user)
     else
       render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "Profile updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:email,:user_id, :password,:password_confirmation,
                :address,:city,:state,:country,
                 :bday,:full_name,:login,:zip,:latitude,:longitude,{:role_ids => []})
  end
end
