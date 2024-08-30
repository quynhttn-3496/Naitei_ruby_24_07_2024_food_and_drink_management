document.addEventListener('DOMContentLoaded', function() {
  const openModalButtons = document.querySelectorAll('[data-modal-target]');
  const closeModalBtns = document.querySelectorAll('[data-modal-hide="reason-modal"]');
  const reasonModal = document.getElementById('reason-modal');

  openModalButtons.forEach(button => {
      button.addEventListener('click', () => {
          reasonModal.classList.remove('hidden');
      });
  });

  closeModalBtns.forEach(button => {
      button.addEventListener('click', () => {
          reasonModal.classList.add('hidden');
      });
  });
});
document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('cancel-order-form');

  if (form) {
    form.addEventListener('submit', function(event) {
      const submitButton = event.submitter;
      if (submitButton && submitButton.hasAttribute('data-confirm')) {
        const confirmMessage = submitButton.getAttribute('data-confirm');
        
        if (!confirm(confirmMessage)) {
          event.preventDefault(); 
        }
      }
    });
  }
});
