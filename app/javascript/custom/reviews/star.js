document.addEventListener('turbo:load', function () {
  const updateCreateButton = () => {
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('rating');
    let currentRating = 0;
    
    const ratingMap = {
      1: 'one_star',
      2: 'two_stars',
      3: 'three_stars',
      4: 'four_stars',
      5: 'five_stars'
    };

    stars.forEach((star, index) => {
      star.addEventListener('mouseover', () => {
        highlightStars(index);
      });

      star.addEventListener('mouseout', () => {
        highlightStars(currentRating - 1);
      });

      star.addEventListener('click', () => {
        currentRating = index + 1;
        ratingInput.value = ratingMap[currentRating];
        highlightStars(index);
      });
    });

    function highlightStars(index) {
      stars.forEach((star, i) => {
        if (i <= index) {
          star.classList.remove('text-gray-400');
          star.classList.add('text-yellow-500');
        } else {
          star.classList.remove('text-yellow-500');
          star.classList.add('text-gray-400');
        }
      });
    }
  }

  updateCreateButton()

  const observeDOMChanges = () => {
    const observer = new MutationObserver((mutations) => {
      mutations.forEach(mutation => {
        if (mutation.addedNodes.length) {
          updateCreateButton();
        }
      });
    });

    observer.observe(document.body, { childList: true, subtree: true });
  };

  observeDOMChanges();
});
