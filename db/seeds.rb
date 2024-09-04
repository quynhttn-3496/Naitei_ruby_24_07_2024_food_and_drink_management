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
