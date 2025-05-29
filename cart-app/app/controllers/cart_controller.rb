class CartController < ApplicationController
  before_action :create_or_update_cart

  def create_or_update_cart
    cart_id = request.headers['X-Cart-Token']
    if cart_id.present?
      @cart = Cart.find_by(id: cart_id)
      unless @cart
        return render json: { error: 'Carrinho não encontrado' }, status: :not_found
      end
    else
      @cart = Cart.create
    end
    response.headers['X-Cart-Token'] = @cart.id
  end

  # GET /cart
  def list_items
    render json: format_cart_response
  end

  # POST /cart/add_item
  def add_item
    product_id = params[:product_id] || params.dig(:product, :product_id)
    quantity = params[:quantity] || params.dig(:product, :quantity)

    unless product_id && quantity
      return render json: { error: 'product_id e quantity são obrigatórios' }, status: :unprocessable_entity
    end

    product = Product.find_by(id: product_id)
    unless product
      return render json: { error: 'Produto não encontrado' }, status: :not_found
    end

    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product_id)
    cart_item.quantity = cart_item.new_record? ? quantity : cart_item.quantity.to_i + quantity.to_i

    if cart_item.save
      render json: format_cart_response, status: :created
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /cart/:product_id
  def remove_item
    product_id = params[:product_id]
    @cart.cart_items.find_by(product_id: product_id).destroy
    render json: format_cart_response
  end

  private

  def format_cart_response
    products = @cart.cart_items.includes(:product).map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price,
        total_price: item.product.price * item.quantity
      }
    end

    {
      id: @cart.id,
      products: products,
      total_price: products.sum { |p| p[:total_price] }
    }
  end
end
