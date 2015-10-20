class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :get_user_from_session, only: [:orders, :line_items]
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

  def orders
    @orders = @user.orders
  end

  def line_items
    @line_items = @user.line_items.includes(:product)
  end

  private

    def set_user
      @user = User.find_by(id:params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :old_pass)
    end

    def get_user_from_session
      @user = User.find_by(id: session[:user_id])
    end

end
