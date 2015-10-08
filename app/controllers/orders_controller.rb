class OrdersController < ApplicationController

  include CurrentCart

  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create]
# GET /orders
#...

  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        OrderNotifier.received(@order).deliver
        session[:cart_id] = nil
        format.html { redirect_to store_url, notice:
        'Thank you for your order.' }
        format.json { render action: 'show', status: :created,
        location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors,
        status: :unprocessable_entity }
      end
    end
  end

private

  def order_params
    params.require(:order).permit(:name, :address, :email, :pay_type)
  end

end
