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
    });
  });
});
