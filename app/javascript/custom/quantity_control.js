document.addEventListener('turbo:load', function() {
  const decrementButton = document.getElementById('decrement');
  const incrementButton = document.getElementById('increment');
  const quantityInput = document.getElementById('cart-items-quatity');
  const hiddenQuantityInput = document.getElementById('quantity');

  if (hiddenQuantityInput && quantityInput) {
    function updateQuantity(amount) {
      let currentQuantity = parseInt(quantityInput.value, 10);
      currentQuantity += amount;
      if (currentQuantity < 1) currentQuantity = 1;
      quantityInput.value = currentQuantity;
      hiddenQuantityInput.value = currentQuantity; // Cập nhật giá trị của hidden field
    }

    decrementButton.addEventListener('click', function() {
      updateQuantity(-1);
    });

    incrementButton.addEventListener('click', function() {
      updateQuantity(1);
    });

    // Đồng bộ hóa giá trị của hidden field với giá trị ban đầu của input
    hiddenQuantityInput.value = quantityInput.value;
  } else {
    console.error('Không thể tìm thấy các phần tử cần thiết.');
  }
});
