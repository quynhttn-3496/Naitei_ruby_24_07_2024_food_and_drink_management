document.addEventListener('turbo:load', () => {
  const decrementButtons = document.querySelectorAll('.decrement-cart-item');
  const incrementButtons = document.querySelectorAll('.increment-cart-item');

  decrementButtons.forEach(button => {
    button.addEventListener('click', () => {
      const row = button.closest('tr');
      const quantitySpan = row.querySelector('.cart-items-quatity');
      let quantity = parseInt(quantitySpan.textContent);

      if (quantity > 1) {
        quantity -= 1;
        quantitySpan.textContent = quantity;
        updateCartItem(button.dataset.url, quantity);
      }
    });
  });

  incrementButtons.forEach(button => {
    button.addEventListener('click', () => {
      const row = button.closest('tr');
      const quantitySpan = row.querySelector('.cart-items-quatity');
      let quantity = parseInt(quantitySpan.textContent);

      quantity += 1;
      quantitySpan.textContent = quantity;
      updateCartItem(button.dataset.url, quantity);
    });
  });

  function updateCartItem(url, quantity) {
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ cart_item: { quantity: quantity } })
    })
    .then(response => response.json())
    .then(data => {
      window.location.reload();
    })
    .catch(error => {
      console.error(error);
    });
  }
});
