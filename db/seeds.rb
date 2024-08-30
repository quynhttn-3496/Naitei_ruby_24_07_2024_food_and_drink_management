categories = ["com", "tra sua", "tra da", "my", "pho"]
categories.each do |category_name|
  Category.create(name: category_name)
end
2.times do |i|
  user = User.create!(
    email: "admin#{i + 1}@example.com",
    username: "admin#{i + 1}",
    password: "password",
    role: 0
  )
  user.create_cart!
end
18.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    username: "user#{i + 1}",
    password: "password",
    role: 1
  )
  user.create_cart!
end
50.times do |i|
  category = Category.order("RAND()").first
  Product.create!(
    name: "Product #{i + 1}",
    price: Money.new(rand(100000..1000000), "VND"),
    delivery_quantity: rand(1..10),
    description: "Description for product #{i + 1}",
    quantity_in_stock: rand(1..50),
    category: category
  )
end
payment_methods = ["credit_card", "paypal", "bank_transfer"]
payment_methods.each do |method|
  PaymentMethod.create!(payment_method: method)
end
User.all.each do |user|
  2.times do
    Address.create!(
      user: user,
      name: Faker::Name.name,
      address: Faker::Address.full_address,
      phone: Faker::PhoneNumber.cell_phone
    )
  end
end
20.times do
  user = User.order("RAND()").first
  payment_method = PaymentMethod.order("RAND()").first
  address = user.addresses.order("RAND()").first  
  status = rand(0..2)
  reason = status == 0 ? "Reason for failed order #{rand(1..100)}" : nil  
  order = Order.create!(
    user: user,
    status: rand(0..2),
    reason: reason,
    payment_method: payment_method,
    address: address,
    total_invoice: 0
    )  
    total_invoice = 0
  3.times do
    product = Product.order("RAND()").first
    quantity = rand(1..5)
    total_amount = product.price * quantity    
    OrderItem.create!(
      order: order,
      product: product,
      quantity: quantity,
      total_amount: Money.new(rand(100000..1000000), "USD"),
    )  
  end
  order.update(total_invoice: Money.new(rand(100000..1000000), "USD"))
end
