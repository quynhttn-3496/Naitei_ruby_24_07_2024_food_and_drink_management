# Tạo các danh mục
categories = ["com", "tra sua", "tra da", "my", "pho"]
categories.each do |category_name|
  Category.create(name: category_name)
end

# Tạo admin và user, kèm theo giỏ hàng cho mỗi người dùng
2.times do |i|
  user = User.create!(
    email: "admin#{i + 1}@example.com",
    username: "admin#{i + 1}",
    password: "password",
    role: 0
  )
  # Tạo giỏ hàng cho người dùng admin
  user.create_cart!
end

18.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    username: "user#{i + 1}",
    password: "password",
    role: 1
  )
  # Tạo giỏ hàng cho người dùng bình thường
  user.create_cart!
end

# Tạo các sản phẩm
50.times do |i|
  category = Category.order("RAND()").first
  Product.create!(
    name: "Product #{i + 1}",
    price: rand(10..100),
    delivery_quantity: rand(1..10),
    image_url: "http://example.com/product_#{i + 1}.jpg",
    description: "Description for product #{i + 1}",
    quantity_in_stock: rand(1..50),
    category: category
  )
end
