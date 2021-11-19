class UsersController < ApplicationController
  def index
    @users = User.all.order(:id)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy unless @user.admin?

    redirect_to users_path
  end

  def lock
    @user = User.find(params[:user_id])
    @user.lock_access! unless @user.admin?
    redirect_to users_path
  end

  def unlock
    @user = User.find(params[:user_id])
    @user.unlock_access!
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:role, :first_name, :last_name, :email, :notifications)
  end
end
