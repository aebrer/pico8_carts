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
    works: ['the-trace-gallery', 'containment-breach']
  },
  emergence: {
    name: 'Emergence',
    description: 'Complex patterns arising from simple rules across platforms.',
    works: ['emergence-iii']
  },
  'three-body-problem': {
    name: 'Three Body Problem',
    description: 'Physics simulation exploring n-body orbital mechanics and chaos theory. This was my first series and what got me started on generative/code art, as well as pixel art—the earliest outputs frankly look like shit.',
    works: ['luna-theory-emulator']
  },
  'entropy-locked': {
    name: 'Entropy-Locked',
    description: 'Pieces showcasing entropy locking—probabilistic RNG reseeding creating controlled chaos.',
    works: ['entropy-locked-wfc', 'sedimentary-city', 'the-city-is-burning']
  },
  'pico_punks': {
    name: 'pico_punks',
    description: 'Generative character/avatar systems exploring procedural generation.',
    works: []
  },
  'pico_galaxies': {
    name: 'pico_galaxies',
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
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/ideocart/beginner_ideocartography',
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
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/ideocart/intermediate_ideocartography',
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
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/screensavers/VISIONS',
    favorite: true,
    themes: ['screensaver', 'entropy locking', 'wave function collapse', 'ideocart', 'pareidolia', 'ambient', 'infinite', 'p5js']
  },
  'the-trace-gallery': {
    id: 'the-trace-gallery',
    title: 'The Trace Gallery',
    series: 'vestiges',
    year: 2022,
    platform: 'teia',
    description: 'A forgotten video game cartridge containing a full interactive gallery/game. Features inventory system, achievements, doom timer, mirror world mechanics, and ideocartography integration.',
    ipfs: 'https://ipfs.io/ipfs/QmWQ5dUBCUqfJ3LeKRcHmsXoKmMUDdpPLDdg4HaudgLSBC/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/717500'
    },
    provenance: 'ipfs://QmYt25faE3S8cypApJfv4Fq2YdoLMujokEMCxcbB3Fs8hJ',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/vestiges/the_trace',
    favorite: true,
    themes: ['vestiges', 'ideocart', 'game', 'interactive', 'narrative', 'infohazard', 'cognitohazard', 'memetic', 'pico-8', 'gif export', 'multiple endings', 'neoretro', 'achievement system', 'doom timer', 'easter egg', 'secret hunting', 'entropy locking', 'text-based', 'CYOA', 'the hierophant', 'music', 'audio']
  },
  'containment-breach': {
    id: 'containment-breach',
    title: 'vestige_005: CONTAINMENT BREACH',
    series: 'vestiges',
    year: 2021,
    platform: 'teia',
    description: 'A dangerous remnant that destabilizes with each interaction. The piece that crashes as part of its mechanics—an infohazard that breaks its own container.',
    ipfs: 'https://ipfs.io/ipfs/Qmd2dUEeYwcwHET7rEgFuYFtAgf8pzJLJTPGrBEySVifkm/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/127402'
    },
    provenance: 'ipfs://Qmb8c79wVDBLzKLCXHzMWDxzKRD5vFXh9aKYLbxw6V5rVH',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/vestiges/vestige_005',
    favorite: true,
    themes: ['vestiges', 'infohazard', 'entropy locking', 'pico-8', 'intentional crash', 'the hierophant', 'containment failure', 'neoretro', 'SCP aesthetics', 'generative', 'ambient', 'infinite']
  },
  'emergence-iii': {
    id: 'emergence-iii',
    title: 'emergence III [TTC S01T08]',
    series: 'emergence',
    year: 2022,
    platform: 'fxhash',
    description: 'A Pico-8 tweetcart demonstrating entropy locking (originally called "seed looping"). Generator generator where each piece has its own unique starting position in a massive linear sequence. Featured in the Creative Code Toronto talk on entropy locking.',
    ipfs: 'https://gateway.fxhash2.xyz/ipfs/QmQPNXi1Yf9eajWQVgw99jzW6hDwntg8PhdB1rTCDX5NGA/',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/generative/slug/emergence-iii-ttc-s01t08',
      ttc: 'https://objkt.com/asset/hicetnunc/414400'
    },
    provenance: 'ipfs://QmUaJin2BiJJczVLvk4REyDYtGWmMbidFj5mcbXtwV5Usz',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/emergence/emergence_iii',
    favorite: true,
    themes: ['emergence', 'tweetcart', 'entropy locking', 'pico-8', 'generator generator', 'seed looping', 'TTC', 'tweetcart token club', 'opensource', 'lua', 'neoretro', 'rainbow', 'animated', 'pixelart', 'constrained code']
  },
  'luna-theory-emulator': {
    id: 'luna-theory-emulator',
    title: 'luna theory | EMULATOR',
    series: 'three-body-problem',
    year: 2021,
    platform: 'teia',
    description: 'Infinite cosmic exploration. Dive into the simulation and live the three body problem. Features ambient lofi soundtrack by @bisdvrk.',
    ipfs: 'https://ipfs.io/ipfs/Qme6DgdHgYr14yis4ibxPcRZzr5TcvZgSmKAtQHGXqBr1U/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/161642',
      bisdvrk: 'https://teia.art/bisdvrk'
    },
    provenance: 'ipfs://QmRmoaTBx7MBKGLBt3ZKzsG8Zgo9ARJGALk6wWh4kb8X6r',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/three-body-problem/luna_theory_emulator',
    favorite: true,
    themes: ['three body problem', 'animated', 'noise', 'interactive', 'simulation', 'pico-8', 'pixelart', 'space', 'cosmic', '3bodyprob', 'generative', 'sciart', 'lofi', 'music', 'audio', 'collaboration', 'soundtrack']
  },
  'entropy-locked-wfc': {
    id: 'entropy-locked-wfc',
    title: 'Entropy Locked Wave Function Collapse',
    series: 'entropy-locked',
    year: 2022,
    platform: 'fxhash',
    description: 'Not really Wave Function Collapse—merely inspired by it. Pixels as tiling units with HSB-based connection rules. Entropy increases rather than decreases, possibilities expand rather than contract. Entropy locking triggers emergence from controlled chaos.',
    ipfs: 'https://gateway.fxhash2.xyz/ipfs/QmboJtrRdzLahaudhbcsdQnLPyrfEAuNFXCXySChfk7rzc/',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/project/entropy-locked-wave-function-collapse'
    },
    provenance: 'ipfs://QmdZwda29bdrtGL666srfXVpv53esUcySjDsPgSG2YzzM2',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/entropy-locked/entropy_locked_wave_function_collapse',
    favorite: true,
    themes: ['entropy locking', 'wave function collapse', 'p5js', 'generative', 'abstract', 'pixelart', 'neoretro', 'opensource', 'creative coding', 'fullscreen', 'CC0', 'tileable']
  },
  'sedimentary-city': {
    id: 'sedimentary-city',
    title: 'sedimentary city',
    series: 'entropy-locked',
    year: 2022,
    platform: 'fxhash',
    description: 'Part one of a two-piece diptych. A tweetcart inspired by burning cities and layers of sediment—like the sins of those who came before us, piling up forever. Abstract entropy-locked patterns building over time.',
    ipfs: 'https://gateway.fxhash2.xyz/ipfs/QmUZfwEkJ1zzBtgQckU47jHqNYi3BSttUFr2mogS3Zyr1v/',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/project/sedimentary-city',
      diptych: 'the-city-is-burning'
    },
    provenance: 'ipfs://QmVB5LhUZbMxUFp8ZoH8BPMjBtTzh5mmhn2ftUkXfsB8ZJ',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/entropy-locked/sedimentary_city',
    favorite: true,
    themes: ['entropy locking', 'tweetcart', 'pico-8', 'lua', 'neoretro', 'pixelart', 'abstract', 'still', 'opensource', 'diptych', 'landscape', 'city', 'sediment']
  },
  'the-city-is-burning': {
    id: 'the-city-is-burning',
    title: 'the city is burning',
    series: 'entropy-locked',
    year: 2022,
    platform: 'fxhash',
    description: 'Part two of a two-piece diptych. The p5.js expansion of sedimentary city—3D camera, fire palette cycling through dark to bright yellows. Lemme just say fuck cars and be done with it.',
    ipfs: 'https://gateway.fxhash2.xyz/ipfs/QmeW1zwysTjkLSaU2o7ugVfZSYH9TzwyMHKbrsx4uJY5q5/',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/project/the-city-is-burning',
      diptych: 'sedimentary-city'
    },
    provenance: 'ipfs://QmNoEC2TZpRaCML514WGoEDmk6XPqoh2pmEpESFhhzFQH4',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/entropy-locked/the_city_is_burning',
    favorite: true,
    themes: ['entropy locking', 'p5js', 'minimal', 'creative coding', 'neoretro', 'pixelart', 'landscape', 'city', 'fire', 'breadfond', 'diptych', 'fuck cars']
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
