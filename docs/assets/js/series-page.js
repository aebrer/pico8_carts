// series-page.js
// Auto-renders series pages from data.js
// Usage: Add <meta name="series-id" content="series-id"> to HTML

document.addEventListener('DOMContentLoaded', function() {
  // Get series ID from meta tag
  const seriesIdMeta = document.querySelector('meta[name="series-id"]');
  if (!seriesIdMeta) {
    console.error('No series-id meta tag found');
    return;
  }

  const seriesId = seriesIdMeta.content;
  const series = SERIES[seriesId];

  if (!series) {
    console.error(`Series "${seriesId}" not found in data.js`);
    return;
  }

  // Get all works for this series
  const seriesWorks = series.works.map(id => WORKS[id]).filter(w => w);

  // Render featured work
  renderFeaturedWork(seriesId, seriesWorks);

  // Render works grid
  renderWorksGrid(seriesWorks);
});

function renderFeaturedWork(seriesId, seriesWorks) {
  const featuredContainer = document.getElementById('series-featured');
  if (!featuredContainer) return;

  // Get random favorite from this series
  const favorites = seriesWorks.filter(work => work.favorite);
  const featuredWork = favorites.length > 0
    ? favorites[Math.floor(Math.random() * favorites.length)]
    : null;

  if (featuredWork) {
    // Handle generative works with fxhash
    const hash = featuredWork.isGenerative ? generateFxHash() : '';
    const url = featuredWork.isGenerative
      ? `${featuredWork.ipfs}?fxhash=${hash}`
      : featuredWork.ipfs;

    // Check if it's marked as an image in data.js
    if (featuredWork.isImage) {
      featuredContainer.innerHTML = `
        <div class="featured-iframe">
          <img src="${url}" alt="${featuredWork.title}">
        </div>
        <div class="featured-info">
          <a href="../works/${featuredWork.id}.html">${featuredWork.title}</a> (${featuredWork.year})
        </div>
      `;
    } else {
      featuredContainer.innerHTML = `
        <iframe class="featured-iframe"
                src="${url}"
                sandbox="allow-scripts allow-downloads"
                scrolling="no">
        </iframe>
        <div class="featured-info">
          <a href="../works/${featuredWork.id}.html">${featuredWork.title}</a> (${featuredWork.year})
        </div>
      `;
    }
  } else {
    featuredContainer.innerHTML = `
      <div class="text-center">
        <p style="color: var(--link-hover);">Works in this series will appear here as they're migrated.</p>
      </div>
    `;
  }
}

function renderWorksGrid(seriesWorks) {
  const worksGrid = document.getElementById('works-grid');
  if (!worksGrid) return;

  if (seriesWorks.length > 0) {
    worksGrid.innerHTML = ''; // Clear existing content
    seriesWorks.forEach(work => {
      const card = document.createElement('a');
      card.href = `../works/${work.id}.html`;
      card.className = 'card';
      card.innerHTML = `
        <h3>${work.title}${work.favorite ? ' ⭐' : ''}</h3>
        <p>${work.year} · ${work.platform}</p>
      `;
      worksGrid.appendChild(card);
    });
  } else {
    worksGrid.innerHTML = `
      <p style="color: var(--link-hover);">Works in this series are being migrated. Check back soon!</p>
    `;
  }
}
