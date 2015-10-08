class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save

        format.html { redirect_to users_url,
        notice: "User #{@user.name} was successfully created." }
        format.json { render action: 'show',
        status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors,
        status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url,
        notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors,
        status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.order(:name)
  end

  def destroy
    begin
      @user.destroy
      flash[:notice] = "User #{@user.name} deleted"
    rescue StandardError => e
      flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      debugger
      params.require(:user).permit(:name, :password, :password_confirmation, :old_pass)
    end

end