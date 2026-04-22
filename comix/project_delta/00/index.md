---
layout: page
title: Project Delta
---

<style>
  .comic-viewer {
    display: grid;
    gap: 16px;
  }

  .comic-viewer__controls {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 12px;
  }

  .comic-viewer__button,
  .comic-viewer__select {
    border: 1px solid rgba(255, 255, 255, 0.18);
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.06);
    color: inherit;
    font: inherit;
  }

  .comic-viewer__button {
    padding: 10px 16px;
    cursor: pointer;
  }

  .comic-viewer__button:disabled {
    opacity: 0.45;
    cursor: default;
  }

  .comic-viewer__select {
    min-width: 180px;
    padding: 10px 12px;
  }

  .comic-viewer__status {
    min-width: 84px;
    text-align: center;
    font-variant-numeric: tabular-nums;
  }

  .comic-viewer__hint {
    margin: 0;
    text-align: center;
    opacity: 0.75;
    font-size: 0.95rem;
  }

  .comic-viewer__frame {
    margin: 0;
    display: flex;
    justify-content: center;
  }

  .comic-viewer__image {
    display: block;
    width: auto;
    max-width: 100%;
    max-height: min(82vh, 1800px);
    height: auto;
    border-radius: 12px;
    box-shadow: 0 18px 56px rgba(0, 0, 0, 0.42);
  }

  @media (max-width: 640px) {
    .comic-viewer__controls {
      gap: 10px;
    }

    .comic-viewer__button,
    .comic-viewer__select {
      width: 100%;
    }

    .comic-viewer__status {
      width: 100%;
    }
  }
</style>

<div class="comic-viewer" id="comic-viewer">
  <div class="comic-viewer__controls">
    <button class="comic-viewer__button" id="comic-prev" type="button">← Назад</button>
    <select class="comic-viewer__select" id="comic-select" aria-label="Выбор страницы"></select>
    <button class="comic-viewer__button" id="comic-next" type="button">Вперёд →</button>
    <div class="comic-viewer__status" id="comic-status">1 / 18</div>
  </div>

  <p class="comic-viewer__hint">Стрелки клавиатуры тоже работают.</p>

  <figure class="comic-viewer__frame">
    <img class="comic-viewer__image" id="comic-image" src="p01.jpg" alt="Project Delta, страница 1">
  </figure>
</div>

<script>
  (function () {
    var pages = [
      'p01.jpg',
      'p02.jpg',
      'p03.jpg',
      'p04.jpg',
      'p05.jpg',
      'p06.jpg',
      'p07.jpg',
      'p08.jpg',
      'p09.jpg',
      'p10.jpg',
      'p11.jpg',
      'p12.jpg',
      'p13.jpg',
      'p14.jpg',
      'p15.jpg',
      'p16.jpg',
      'p17.jpg',
      'p18.jpg'
    ];

    var image = document.getElementById('comic-image');
    var prevButton = document.getElementById('comic-prev');
    var nextButton = document.getElementById('comic-next');
    var select = document.getElementById('comic-select');
    var status = document.getElementById('comic-status');
    var currentIndex = 0;

    function render() {
      image.src = pages[currentIndex];
      image.alt = 'Project Delta, страница ' + (currentIndex + 1);
      select.value = String(currentIndex);
      status.textContent = (currentIndex + 1) + ' / ' + pages.length;
      prevButton.disabled = currentIndex === 0;
      nextButton.disabled = currentIndex === pages.length - 1;
    }

    pages.forEach(function (page, index) {
      var option = document.createElement('option');
      option.value = String(index);
      option.textContent = 'Страница ' + (index + 1);
      select.appendChild(option);
    });

    prevButton.addEventListener('click', function () {
      if (currentIndex > 0) {
        currentIndex -= 1;
        render();
      }
    });

    nextButton.addEventListener('click', function () {
      if (currentIndex < pages.length - 1) {
        currentIndex += 1;
        render();
      }
    });

    select.addEventListener('change', function () {
      currentIndex = Number(select.value);
      render();
    });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'ArrowLeft' && currentIndex > 0) {
        currentIndex -= 1;
        render();
      }

      if (event.key === 'ArrowRight' && currentIndex < pages.length - 1) {
        currentIndex += 1;
        render();
      }
    });

    render();
  }());
</script>
