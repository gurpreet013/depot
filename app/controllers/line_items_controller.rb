class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create, :destroy, :increment, :decrement]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :decrement, :increment]
  skip_before_action :authorize, only: :create
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    # product.line_items_count += 1
    # product.save
    @line_item = @cart.add_product(product.id, product.price)
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.js { @current_item = @line_item }
        # format.html { redirect_to @line_item.cart, notice: 'Line item was successfully created.' }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(product_id: params[:line_item][:product_id])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to @cart, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def increment
    @line_item = @cart.increment(@line_item.product_id)
    @line_item.save
    respond_to do |format|
      format.html { redirect_to store_url }
      format.js { @current_item = @line_item }
    end
  end


  def decrement
    @line_item = @cart.decrement(@line_item.product_id)
    if @line_item.quantity == 0
      @line_item.destroy
    else
      @line_item.save
    end
    respond_to do |format|
      format.html { redirect_to store_url }
      format.js { @current_item = @line_item }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find_by(id:params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
