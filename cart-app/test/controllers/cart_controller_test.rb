require "test_helper"

class CartControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = Product.create!(name: "Test Product", price: 10.0)
  end

  test "should create a new cart if no X-Cart-Token header is present" do
    get "/cart"
    assert_response :success
    assert response.headers["X-Cart-Token"].present?
    body = JSON.parse(response.body)
    assert_equal [], body["products"]
    assert_equal 0, body["total_price"]
  end

  test "should use existing cart if X-Cart-Token header is present" do
    cart = Cart.create!
    get "/cart", headers: { "X-Cart-Token" => cart.id }
    assert_response :success
    assert_equal cart.id.to_s, response.headers["X-Cart-Token"]
  end

  test "should return not found if cart does not exist for X-Cart-Token" do
    get "/cart", headers: { "X-Cart-Token" => 999999 }
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal "Carrinho não encontrado", body["error"]
  end

  test "should add item to cart" do
    post "/cart/add_item", params: { product_id: @product.id, quantity: 2 }
    assert_response :created
    body = JSON.parse(response.body)
    assert_equal 1, body["products"].size
    assert_equal @product.id, body["products"][0]["id"]
    assert_equal 2, body["products"][0]["quantity"]
    assert_equal "Test Product", body["products"][0]["name"]
    assert_equal 20.0, body["total_price"].to_f
  end

  test "should increment quantity if adding same product again" do
    post "/cart/add_item", params: { product_id: @product.id, quantity: 1 }
    cart_token = response.headers["X-Cart-Token"]
    post "/cart/add_item", params: { product_id: @product.id, quantity: 3 }, headers: { "X-Cart-Token" => cart_token }
    assert_response :created
    body = JSON.parse(response.body)
    assert_equal 4, body["products"][0]["quantity"]
    assert_equal 40.0, body["total_price"].to_f
  end

  test "should return error if product_id or quantity missing" do
    post "/cart/add_item", params: { product_id: @product.id }
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_match /obrigat.rio/, body["error"]

    post "/cart/add_item", params: { quantity: 1 }
    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_match /obrigat.rio/, body["error"]
  end

  test "should return error if product not found" do
    post "/cart/add_item", params: { product_id: 999999, quantity: 1 }
    assert_response :not_found
    body = JSON.parse(response.body)
    assert_equal "Produto não encontrado", body["error"]
  end

  test "should remove item from cart" do
    post "/cart/add_item", params: { product_id: @product.id, quantity: 2 }
    cart_token = response.headers["X-Cart-Token"]
    delete "/cart/#{@product.id}", headers: { "X-Cart-Token" => cart_token }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [], body["products"]
    assert_equal 0, body["total_price"]
  end

  test "should do nothing if removing non-existent item" do
    cart = Cart.create!
    delete "/cart/999999", headers: { "X-Cart-Token" => cart.id }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [], body["products"]
    assert_equal 0, body["total_price"]
  end
end
