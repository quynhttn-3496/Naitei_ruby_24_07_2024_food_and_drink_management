document.addEventListener('turbo:load', function () {
  const updateReviewButtons = () => {
    document.querySelectorAll('.edit-review-button').forEach(button => {
      button.addEventListener('click', () => {
        const reviewId = button.getAttribute('data-review-id');
        document.querySelector(`#review-${reviewId}`).classList.add('hidden');
        document.querySelector(`#edit-review-${reviewId}`).classList.remove('hidden');
      });
    });
  };

  updateReviewButtons();

  const observeDOMChanges = () => {
    const observer = new MutationObserver((mutations) => {
      mutations.forEach(mutation => {
        if (mutation.addedNodes.length) {
          updateReviewButtons();
        }
      });
    });

    observer.observe(document.body, { childList: true, subtree: true });
  };

  observeDOMChanges();
});
