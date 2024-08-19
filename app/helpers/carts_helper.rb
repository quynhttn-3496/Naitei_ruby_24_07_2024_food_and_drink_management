module CartsHelper
  def total_cart_amount cart_items
    cart_items.sum{|item| item.product.price * item.quantity}
  end
end
