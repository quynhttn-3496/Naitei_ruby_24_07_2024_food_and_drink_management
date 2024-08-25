document.addEventListener('turbo:load', function() {
  const decrementButton = document.getElementById('decrement');
  const incrementButton = document.getElementById('increment');
  const quantityInput = document.getElementById('cart-items-quatity');
  const hiddenQuantityInput = document.getElementById('quantity');

  function updateQuantity(amount) {
    let currentQuantity = parseInt(quantityInput.value, 10);
    currentQuantity += amount;
    if (currentQuantity < 1) currentQuantity = 1;
    quantityInput.value = currentQuantity;
    hiddenQuantityInput.value = currentQuantity;
  }

  decrementButton.addEventListener('click', function() {
    updateQuantity(-1);
  });

  incrementButton.addEventListener('click', function() {
    updateQuantity(1);
  });

  hiddenQuantityInput.value = quantityInput.value;
});
