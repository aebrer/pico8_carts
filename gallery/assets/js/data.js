// Gallery data structure
// This will be populated as we migrate each piece

const SERIES = {
  ideocart: {
    name: 'Ideocart',
    description: 'Interactive generative systems as lofi Rorschach tests with an SCP Foundation-esque twist.',
    works: []
  },
  vestiges: {
    name: 'Vestiges',
    description: 'Explorations of remnants, traces, and what remains after something has passed.',
    works: []
  },
  emergence: {
    name: 'Emergence',
    description: 'Complex patterns arising from simple rules across platforms.',
    works: []
  },
  'three-body-problem': {
    name: 'Three Body Problem',
    description: 'Physics simulation exploring n-body orbital mechanics and chaos theory.',
    works: []
  },
  'entropy-locked': {
    name: 'Entropy-Locked',
    description: 'Pieces showcasing entropy locking—probabilistic RNG reseeding creating controlled chaos.',
    works: []
  },
  'pico-punks': {
    name: 'Pico Punks',
    description: 'Generative character/avatar systems exploring procedural generation.',
    works: []
  },
  screensavers: {
    name: 'Screensavers',
    description: 'Ambient generative pieces designed to run indefinitely.',
    works: []
  }
};

const WORKS = {
  // Example structure - will be populated during migration
  // 'beginner-ideocartography': {
  //   title: 'beginner_ideocartography',
  //   series: 'ideocart',
  //   year: 2022,
  //   platform: 'fxhash',
  //   description: 'Entry point to the ideocart system...',
  //   ipfs: 'ipfs://...',
  //   links: {
  //     fxhash: 'https://www.fxhash.xyz/generative/...',
  //   },
  //   favorite: true,
  //   themes: ['pareidolia', 'emergence', 'interactive']
  // }
};

// Get all favorites for random selection
function getFavorites() {
  return Object.values(WORKS).filter(work => work.favorite);
}

// Get random favorite
function getRandomFavorite() {
  const favorites = getFavorites();
  if (favorites.length === 0) return null;
  return favorites[Math.floor(Math.random() * favorites.length)];
}

// Get works by series
function getWorksBySeries(seriesId) {
  return Object.values(WORKS).filter(work => work.series === seriesId);
}

// Get random favorite from series
function getRandomFavoriteFromSeries(seriesId) {
  const works = getWorksBySeries(seriesId).filter(work => work.favorite);
  if (works.length === 0) return null;
  return works[Math.floor(Math.random() * works.length)];
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { SERIES, WORKS, getFavorites, getRandomFavorite, getWorksBySeries, getRandomFavoriteFromSeries };
}
