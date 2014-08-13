class PersonsController < ApplicationController

  def profile
    #@userinfo = Userinfo.new(user_params)
    @user = current_user
    #User.find(params[:id])
  end

  def new
    @user=User.new
  end

  def show
    @user = User.find(params[:id])
  end
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
   # @userinfo = Userinfo.new(user_params)
     @user.save
      flash[:notice]="success"
      redirect_to person_path(@user)

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to person_path(@user)
    #else
   #   render 'edit'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email,:user_id,:password,:password_confirmation,
                :userinfo_attributes => [:id,:address,:city,:state,:country,
                 :bday,:full_name,:login,:zip,:latitude,:longitude ])
  end
end
