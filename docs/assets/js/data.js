// Gallery data structure
// This will be populated as we migrate each piece

const SERIES = {
  ideocart: {
    name: 'Ideocart',
    description: 'Interactive generative systems as lofi Rorschach tests with an SCP Foundation-esque twist.',
    works: ['beginner-ideocartography', 'intermediate-ideocartography']
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
  'pico-galaxies': {
    name: 'Pico Galaxies',
    description: 'Looping gif project exploring spirals, recursion, and dynamic equilibria on Pico-8.',
    works: []
  },
  screensavers: {
    name: 'Screensavers',
    description: 'Ambient generative pieces designed to run indefinitely.',
    works: ['visions']
  }
};

const WORKS = {
  'beginner-ideocartography': {
    id: 'beginner-ideocartography',
    title: 'Beginner Ideocartography',
    series: 'ideocart',
    year: 2022,
    platform: 'fxhash',
    description: 'Entry point to the ideocart system. An interactive exploration tool for perceiving entities compressed into two dimensions.',
    ipfs: 'https://gateway.fxhash2.xyz/ipfs/QmV7C8QtpeyzJzAfh2Y6b3Y9AdeRsbDqLsE6ykva4GZ6f7/',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/generative/5529',
    },
    provenance: 'ipfs://QmXb4vXaF1T89HkXaY6PPMMNCokrunaraAnxMn9PR1EVzP',
    favorite: true,
    themes: ['ideocart', 'pareidolia', 'interactive', 'SCP aesthetics', 'generative', 'pico-8', 'easter egg']
  },
  'intermediate-ideocartography': {
    id: 'intermediate-ideocartography',
    title: 'Intermediate Ideocartography',
    series: 'ideocart',
    year: 2022,
    platform: 'versum',
    description: 'Going deeper. More control, more danger. Navigate metalayers with entropy networks preventing seed adjacency.',
    ipfs: 'https://ipfs.io/ipfs/Qmf7NBtXHyAL3EiXJyKxqGSuW8AHXC9B1v6aotm6GcJP8g/',
    isGenerative: false, // Self-randomizes on launch
    links: {
      objkt: 'https://objkt.com/tokens/versum_items/10',
    },
    provenance: 'ipfs://QmQ8gj1rqYFzqyZwCeLRfMuBUMJ2ATT7MTqTUV7dJYPgWy',
    favorite: true,
    themes: ['ideocart', 'pareidolia', 'interactive', 'SCP aesthetics', 'entropy locking', 'pico-8', 'dark']
  },
  'visions': {
    id: 'visions',
    title: 'VISIONS',
    series: 'screensavers',
    year: 2024,
    platform: 'teia',
    description: 'Entropy locking meets wave function collapse algorithm, plus ideocartography. A screensaver exploration with bombastic colors—gods and temples emerging from controlled chaos.',
    ipfs: 'https://ipfs.io/ipfs/bafybeibt6vi2jkvvf2cvhgw6qhwfsjuqcazbumds6vjags4i4hosh224yi/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/844464'
    },
    provenance: 'ipfs://QmT6sc5d7MP3gG9sdnqFNifmYRVbRWcSdVcLW6C9R7LGPD',
    favorite: true,
    themes: ['screensaver', 'entropy locking', 'wave function collapse', 'ideocart', 'pareidolia', 'ambient', 'infinite', 'p5js']
  }
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

// Generate random fxhash (for generative pieces)
function generateFxHash() {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let hash = 'oo'; // fxhash format starts with 'oo'
  for (let i = 0; i < 49; i++) {
    hash += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return hash;
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { SERIES, WORKS, getFavorites, getRandomFavorite, getWorksBySeries, getRandomFavoriteFromSeries, generateFxHash };
}
