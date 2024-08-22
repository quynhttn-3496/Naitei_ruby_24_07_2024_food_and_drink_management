document.addEventListener('turbo:load', function() {
  const createButton = document.getElementById('product-new');
  const modalProduct = document.getElementById('product-modal');

  createButton.addEventListener('click', function() {
    modalProduct.classList.remove('hidden');
  });
});
