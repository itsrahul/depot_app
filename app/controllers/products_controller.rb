class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    unless params[:category_id].nil?
      @category = Category.find(params[:category_id])
      @products = @category.products
      @products += @category.sub_category_products.map(&:products)[0] if @category.is_root?
    end
    respond_to do |format|
      format.html { @products }
      format.json { render json: @products.to_json( only: [:title], include: {category: { only: [:name] } }  ) }
      end
    end
    
  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        puts @product.errors.full_messages
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
        @products = Product.all
        ActionCable.server.broadcast 'products',
        html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        format.atom
      end
    end
  end

  def rate
    rating = Rating.find_or_create_by(product_id: params[:id], user_id: session[:user_id])
    rating.value = params[:product_rating]
    # respond_to do |format|
    #   format.js
    # end
    if rating.save
      @rating = Product.find(params[:id]).avg_rating
      new_rating = Product.find(params[:id]).avg_rating
      render json: { product_id: params[:id] , rating: new_rating }
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :enabled, :discount_price, :permalink, :category_id, :product_rating, product_images: [])
    end
end
