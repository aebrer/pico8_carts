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
  'three-body-problem': {
    name: 'Three Body Problem',
    description: 'Physics simulation exploring n-body orbital mechanics and chaos theory. This was my first series and what got me started on generative/code art, as well as pixel art—the earliest outputs frankly look like shit.',
    works: ['luna-theory-emulator']
  },
  'entropy-locked': {
    name: 'Entropy-Locked',
    description: 'Pieces showcasing entropy locking—probabilistic RNG reseeding creating controlled chaos.',
    works: ['entropy-generator', 'entropy-locked-wfc', 'sedimentary-city', 'the-city-is-burning']
  },
  'pico_punks': {
    name: 'pico_punks',
    description: 'Generative character/avatar systems exploring procedural generation, identity, and pareidolia.',
    works: ['pico-punk-generator', 'pico-punk-generator-generator']
  },
  'pico_galaxies': {
    name: 'pico_galaxies',
    description: 'Looping gif project exploring spirals, recursion, and dynamic equilibria on Pico-8.',
    works: ['pico-galaxy-010']
  },
  screensavers: {
    name: 'Screensavers',
    description: 'Ambient generative pieces designed to run indefinitely.',
    works: ['visions', 'the-fall', 'petite-chute', 'deja-hue']
  },
  tweetcarts: {
    name: 'Tweetcarts',
    description: 'Code golf as art form—generative pieces constrained to 280 characters or less. Working within extreme limitations to create emergence from minimal code.',
    works: ['blue', 'ring-of-fire', 'emergence-iii']
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
    thumbnail: 'https://ipfs.io/ipfs/Qmbw5qKk7G1MdgiS3pd4FyRyw6g7qpv2SbSFJk46rM3sTP',
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
    thumbnail: 'https://ipfs.io/ipfs/QmY7npznSASiN61trocXBbYe43iRKKicx2ZtZgQZNJRjtA',
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
    thumbnail: 'https://ipfs.io/ipfs/QmPXPUhhbhniedCrn7U9ZM23CdmPG6tJucRuz1c8PAp7bu',
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
    thumbnail: 'https://ipfs.io/ipfs/QmNrhZHUaEqxhyLfqoq1mtHSipkWHeT31LNHb1QEbDHgnc',
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
    thumbnail: 'https://ipfs.io/ipfs/QmYdV76bXNtPTWBEbvJRECnZZP4cVjg4fnEH1jfsUsJpa8',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/vestiges/vestige_005',
    favorite: true,
    themes: ['vestiges', 'infohazard', 'entropy locking', 'pico-8', 'intentional crash', 'the hierophant', 'containment failure', 'neoretro', 'SCP aesthetics', 'generative', 'ambient', 'infinite']
  },
  'emergence-iii': {
    id: 'emergence-iii',
    title: 'emergence III [TTC S01T08]',
    series: 'tweetcarts',
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
    thumbnail: 'https://ipfs.io/ipfs/QmUmVKJyWMey27zjNs4MGnj7QCcy5V6BLEunJyZwsRsprX',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/tweetcarts/emergence_iii',
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
    thumbnail: 'https://ipfs.io/ipfs/QmVd79wPHiWA4ivJ1vxSBkFasfpUqs2QgjXXRdDjHZEyzd',
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
    thumbnail: 'https://ipfs.io/ipfs/QmVTEoPbJMfFQnTgQvxBFbyoAJ4amtYqnXSELa84NxYuJJ',
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
    thumbnail: 'https://ipfs.io/ipfs/QmW8hXat8yQ1PWx7qVfRtaa95e1b6G2YwPpvDvVvKvYmyr',
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
    thumbnail: 'https://ipfs.io/ipfs/QmWFgcwSZU1hW5bgfUBSRYk7aCu4U3taqaVoZnjdwCtown',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/entropy-locked/the_city_is_burning',
    favorite: true,
    themes: ['entropy locking', 'p5js', 'minimal', 'creative coding', 'neoretro', 'pixelart', 'landscape', 'city', 'fire', 'breadfond', 'diptych', 'fuck cars']
  },
  'entropy-generator': {
    id: 'entropy-generator',
    title: 'Entropy Generator',
    series: 'entropy-locked',
    year: 2021,
    platform: 'versum',
    description: 'The generator for the Entropy series. Coded in Lua on the TIC-80 Fantasy Computer. Uses seed-looping (entropy locking) to create feedback loops. Click/tap to change pseudorandom seeds. Refresh to restart and generate a new palette. Palettes generated via decay function applied to a high-visibility data visualization palette.',
    ipfs: 'https://ipfs.io/ipfs/QmafvZY8L8PXDJEfWaQwg8XXKC3odXRweTLN32PAygKdbE/',
    isGenerative: false,
    links: {
      objkt: 'https://objkt.com/tokens/versum_items/17224',
      'entropy series': 'https://objkt.com/tokens?tags=aebrer_entropy&sort=timestamp:asc'
    },
    provenance: 'ipfs://Qmbnhkbg3w6aXprsfmVCFSwuXwwpdenPS2GPkPAZLaKfct',
    thumbnail: 'https://ipfs.io/ipfs/QmUFt69akLcZTBZeVZ4994zdsFN5mZaVBbBfuSjusTqqHZ',
    sourceCode: 'https://github.com/aebrer/pico8_carts/blob/master/series/entropy-locked/entropy_generator.lua',
    favorite: true,
    themes: ['entropy locking', 'tic-80', 'tic80', 'generative', 'generator', 'interactive', 'pixelart', 'neoretro', 'lua', 'creative coding', '4bit', '4-bit', 'seed looping', 'feedback loops', 'palette generation', 'RGBMTL 2024']
  },
  'pico-punk-generator-generator': {
    id: 'pico-punk-generator-generator',
    title: 'pico_punk_generator_generator.p8',
    series: 'pico_punks',
    year: 2023,
    platform: 'fxhash',
    description: 'The terminus of pico_punks. A generator generator using fxparams—you choose colors and effect frequencies to create your own unique pico_punk generator. Then explore the infinite generative space interactively, building avatars layer by layer. What began as satire became identity.',
    ipfs: 'https://gateway.fxhash2.xyz/ipfs/QmdaEhotLYzPMuKXqbjpk6EzB5oLgUUic45o8i277foPfG/',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/project/pico_punk_generator_generator.p8',
      'first generator': 'https://objkt.com/asset/hicetnunc/439049'
    },
    provenance: 'ipfs://QmWwtD357wYmVhewCy1g5XhnpWSTMj8dcZMsm2sKLyrEr6',
    thumbnail: 'https://ipfs.io/ipfs/QmW2HhAb7BzkqQCHvBwioKVozXydtsFszGFWZ1LmW4xLf6',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/pico_punks/pico_punks_final_form',
    favorite: true,
    themes: ['pico_punks', 'pico-8', 'pfp', 'avatar', 'identity', 'pareidolia', 'interactive', 'generator generator', 'fxparams', 'neoretro', 'pixelart', 'lofi', 'entropy locking', 'irreversibility', 'noise', 'punks', 'aebrer_pfp']
  },
  'pico-galaxy-010': {
    id: 'pico-galaxy-010',
    title: 'pico_galaxy_010',
    series: 'pico_galaxies',
    year: 2021,
    platform: 'teia',
    description: 'Purple spiral commission for @bisdvrk. When things are feeling dark just remember that most people are compassionate, and together we are strong. A perfect looping gif where the spiral decohere and recohere at exactly the right moment.',
    ipfs: 'https://ipfs.io/ipfs/QmXQraiBtNg1ZN8JqKAXappS5L2BFLBevejfn1UwvHdNam',
    isGenerative: false,
    isImage: true,
    links: {
      teia: 'https://teia.art/objkt/182690',
      'pico-8 edu': 'https://www.pico-8-edu.com/?c=AHB4YQtiBP83H-8G2_N9dfT5h79B0x1xzTFneKBtz67bR2huf4Mqbq9J0zrI49sHkuKGg8rioDLwQ9S-whvsjLzAI0QjpVPLOnqAnfQJyrRZ2GnqdKaux9J0ponK4r5iI0pjewT3GCfOripm8qQbGJhpVqRCrh_4P07LbKfREudc9xDZxISOcBUtFVICTTcgJ7ywdV6uMxBEe8XgpE54XkIn-L-lRbQJ3kJQIB5TFxl1QuSUoA5fQ6BYhkifUPlkaXFsUO9IAtU0yTNkk9nS1laZFWFyaZWFU6NrnSZC_RZtEoSxYkqZnTmSNNWgHZrZgVBH2DuL3gmSNtMPclbnmw3fBMlGH8msx12L1VC9lCRLSRwlSSO2rJBSNHoIUWHZxjKBZYIlzya5KYoDq364bdVTyiwaGMgyzebMP4F-dzda-8q2FmtJHQkQRJUNgjV1RCnoaWWXXgK63Zgai2QgtvO6T8qFJpucHV1KEjFhfynAX9nK1oAAPEJ9hHxvqQtW5tyTx86eW0jLUtJk_8Jirh0opcJzqWmujMrRrY2yEgrHjgBFtDmSeF6WyVaFqX0nTG_Jh7BZXNFe6yaC0XIrWa8CZRRRl40lzy1lfTLQt4kt5KvDotO1p2d25ppNWYikvNKPo34K3DEWDuytLK2YJp2wlmaIwpsl6tlCeWSqCGJLBpaHK2RQijYozhQ-LeqZpaRt21KdQKBRhEQGRStUKFkraK5bCfSC1vXCfwR64f8fG6RJs7aQpjMrcTzTNJUHoirSIZdAoHHM0SQC4Yc4k0kU2dvPbu5t9mPKRlmzFitjjCpdL4bZxsZLSEMdOmt65kv1lLE2favAJS8zPS3nujNfTkzN75tgcVHQQc55dVdqR0Bn5VCNgOV2S49BfWA1DhaTUXm6YQ17VMLhEeSR2xEO---tDAaRNNlENtOwVIj6QBaOJqW6WefJ1aZKPDukLxMH_qfZrhOHY8tGltVBSbTvBHsnhwcGVGX2Eo0sZbsbNAiXtO2U7bG0uBTXhftYLsD421_0fvrCPHqBHBOsSOOZG4obfJYWMxOhejiEQt_hkgouO7FQJ8iF6N3Jlml96k3pikZGaozYNJ4uClctdoqhqWSw0yqnVpXroRoOXVrJ5HxkfyX2HDOGA6YDooHl-XxzJi3i8bRogyUqDs9AL8QRhaEVnLOgGLK8Pl9UUlRuyVflCMoDTDI9WkXjbvDAdhRNuUVhZHQkkAyPXjhTufAmAkP1wrDI2OCmz1QXllYyU_JZSMk3IZuMHDLQem1lZY9fg_Q0siTsHmNrqFKJFgsaGOyipBozPYU7LB9BJI2GlSquYoWOqqsu0EYRG6mPCPIiSIJUoHDNSnmqOYLBQapcxWPkbbsREHQ4tD6rhA9EcrWNS4ekyw7YihOrQ-53dTWI4wmxnuWFC6YS2_ZZacpR7YYVsAhHtlgUmsHBxkYyvNBqlJ1rBvfUbtNIly-2jBWPC5OcC6dBcSRjMBeu5BONfKpapV0F5KUdeod0eGTD-0h1FjrtumAldISyvBpldQj_BBtF4RiN8iw3AprbgXR4g0DWMvLOut7WaLuUC1uoHCnEEw5DtE6l4SfPuXVCn81Xg6dqCARTei-SUZLikg2nsv7Uxq99tXFqzmmNd3Uqa2u1wb2qGfCTZqpKrf56RgLeD5WAGVmSdLii0PzRyaeQRzre55LwNsBKjYMCmw==&g=w-w-w-w1HQHw-w2Xw-w3Xw-w2HQH',
      bisdvrk: 'https://teia.art/bisdvrk'
    },
    provenance: 'ipfs://QmZY9GgNs2WYyUUqeFFskn9FouSe3dTGnSXZLcaSb6MfMh',
    thumbnail: 'https://ipfs.io/ipfs/QmNrhZHUaEqxhyLfqoq1mtHSipkWHeT31LNHb1QEbDHgnc',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/pico_galaxies/pico_galaxy_010',
    favorite: true,
    themes: ['pico_galaxies', 'loop', 'gif', 'spiral', 'pico-8', 'codeart', 'neoretro', 'pixelart', 'purple', 'commission', 'decoherence', 'rotation', 'dither', 'collaboration']
  },
  'pico-punk-generator': {
    id: 'pico-punk-generator',
    title: 'pico_punk_generator.p8',
    series: 'pico_punks',
    year: 2021,
    platform: 'teia',
    description: 'The original pico_punks generator. Inspired by Max Capacity\'s dos_punks—procedural avatar generation using nothing but stacked Pico-8 characters. Interactive exploration of the generative space with wallet-based starting seeds. Features rare combinations including 1/1000 rainbow mode.',
    ipfs: 'https://ipfs.io/ipfs/Qmd7BMUZcPrUNab7VPY5renTqdzhqRN3UyfsiRuW4gUsLF/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/439049',
      objkt: 'https://objkt.com/asset/hicetnunc/439049'
    },
    provenance: 'ipfs://QmfVXYwtLubx4YrxgJrFm6ZTSL4QvvfQJGh9Gqz4bRgKKb',
    thumbnail: 'https://ipfs.io/ipfs/QmNrhZHUaEqxhyLfqoq1mtHSipkWHeT31LNHb1QEbDHgnc',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/pico_punks/pico_punk_generator',
    favorite: true,
    themes: ['pico_punks', 'pfp', 'avatar', 'generative', 'collectible', 'generator', 'pico-8', 'interactive', 'creative coding', 'pixelart', 'punks', 'pareidolia', 'procedural', 'text-based', 'neoretro', 'wallet seed']
  },
  'blue': {
    id: 'blue',
    title: 'BLUE',
    series: 'tweetcarts',
    year: 2021,
    platform: 'teia',
    description: 'Rain falling into a pool. A tweetcart exploring particle simulation and memory manipulation—pixels cascade downward, creating ripples of color within the circle. Press Circle Button (Z) to slow-mo. Part of a diptych with Ring of Fire.',
    ipfs: 'https://ipfs.io/ipfs/QmQZ2YLSmmvFkFSsYz4CbzBqyU4GuBxDA66hxJWA9Te3KN/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/390303',
      diptych: 'ring-of-fire'
    },
    provenance: 'ipfs://QmdULx1K168RU6MtNfJfgpystCjGLYcK8NAULUZCxc627h',
    thumbnail: 'https://ipfs.io/ipfs/QmNrhZHUaEqxhyLfqoq1mtHSipkWHeT31LNHb1QEbDHgnc',
    sourceCode: 'https://github.com/aebrer/pico8_carts/blob/master/series/tweetcarts/blue.p8',
    favorite: true,
    themes: ['tweetcart', 'pico-8', 'lua', 'interactive', 'generative', 'pixelart', 'opensource', 'codeart', 'loop', 'neoretro', 'constrained code', 'diptych', 'rain', 'water', 'particles', 'RGBMTL 2022']
  },
  'ring-of-fire': {
    id: 'ring-of-fire',
    title: 'Ring of Fire',
    series: 'tweetcarts',
    year: 2022,
    platform: 'teia',
    description: 'Flames rising from a ring. A tweetcart/tootcart exploring realistic fire simulation using entropy locking—with default seed 6 creating the intended effect. Click/tap to reseed and discover rare, bizarre outcomes. Part of a diptych with BLUE.',
    ipfs: 'https://ipfs.io/ipfs/bafybeiby6evmdoajih64js7qnjmqixgphx5xm2xfroozbyhydqjy6ql6hi/',
    isGenerative: false,
    links: {
      teia: 'https://teia.art/objkt/797976',
      diptych: 'blue'
    },
    provenance: 'ipfs://QmbxxbTsVsEcBftUUkHFnUsegXQMpmg2Xh649V4rxGQXMu',
    thumbnail: 'https://ipfs.io/ipfs/QmSGRydpJbNUMBTL4fjDvu6AZjeMGig1jtLr4rFLF2cJMm',
    sourceCode: 'https://github.com/aebrer/pico8_carts/blob/master/series/tweetcarts/ring_of_fire.p8',
    favorite: true,
    themes: ['tweetcart', 'tootcart', 'pico-8', 'fire', 'interactive', 'generative', 'generator', 'neoretro', 'pixelart', 'procedural', 'entropy locking', 'opensource', 'creative coding', 'CC0', 'diptych', 'RGBMTL 2022']
  },
  'petite-chute': {
    id: 'petite-chute',
    title: 'petite chute',
    series: 'screensavers',
    year: 2024,
    platform: 'objkt',
    description: 'A piece about color exploration and palettes. Just something soothing to stare at that makes you feel good. A 16x16 grid of pixels with background color cycling. Derived from THE FALL. Sometimes the color cycle perfectly loops—look out for that. Also surprisingly, thanks to entropy locking, it\'s possible to generate a rare black and white output (seen once out of thousands).',
    ipfs: 'https://ipfs.io/ipfs/QmViV7khUsodP81bwG3JUrq4eLaiKmAjhVzdzCt7okDD9W/',
    isGenerative: true,
    links: {
      objkt: 'https://objkt.com/tokens/KT1LNtgRnfyFgP85M9znLorh2anKSZAgBRrd/13',
      diptych: 'deja-hue'
    },
    provenance: 'ipfs://QmcdvwmvFUmRqX3yyJEoiTE4wy7uqT97FpqQDYPd2S1r6r',
    thumbnail: 'https://ipfs.io/ipfs/QmYLaDCTVptiuE4oAqS4b8r7Zk63P3RF9tQAvDzjHgDzgq',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/screensavers/petite_chute',
    favorite: true,
    themes: ['screensaver', 'ambient', 'colors', 'palettes', 'entropy locking', 'p5js', 'generative', 'lofi', 'soothing', 'pixels', 'animation', 'derivative', 'objkt4objkt4', 'CC0', 'interactive', 'diptych']
  },
  'the-fall': {
    id: 'the-fall',
    title: 'THE FALL',
    series: 'screensavers',
    year: 2024,
    platform: 'fxhash',
    description: 'waves upon waves upon waves. A single black pixel cascades and creates a landscape. Entropy locked, uniform randomness drifts into recursive patterns. Feedback creates cycles, cycles create cycles. Life is a balance of living equilibria.',
    ipfs: 'https://onchfs.fxhash2.xyz/a853685b51aa771329fca30f8e4063e476485ba3571acb4472456b4f182c194b/?cid=onchfs%3A%2F%2Fa853685b51aa771329fca30f8e4063e476485ba3571acb4472456b4f182c194b&fxhash=0xbc28123bc7730ae1d5c858931e48b7120604095758cb05e5db081e9ed856bd22&fxminter=0x7cb09983c9bde3fdce87f92ec2724c8cf8b296ef&fxiteration=1&fxcontext=standalone&fxchain=BASE&legacy=false',
    isGenerative: true,
    links: {
      fxhash: 'https://www.fxhash.xyz/project/the-fall'
    },
    provenance: 'ipfs://QmQFnmjSdwxCNt2CVAaNXXKEZgXP1q9hePcH3daiTZwFkP',
    thumbnail: 'https://ipfs.io/ipfs/QmTs2GDFnyaR8TiT9B6PrWHAfFG86b9xwNFmUHQZTyzZT7',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/screensavers/the_fall',
    favorite: true,
    themes: ['screensaver', 'ambient', 'entropy locking', 'p5js', 'generative', 'waves', 'landscape', 'cascade', 'feedback', 'loop', 'equilibrium', 'onchain', 'base', 'animated', 'lofi', 'noise', 'pixelart']
  },
  'deja-hue': {
    id: 'deja-hue',
    title: 'deja hue',
    series: 'screensavers',
    year: 2024,
    platform: 'manifold',
    description: 'A generative art screensaver using totally destroyed cellular automata to move pixels around. Entropy locking creates emergent patterns and soothing visuals with infinite subtle colorshifts and movements. ETH genesis piece (not counting one botched mint years ago). Files stored on Arweave for maximum longevity.',
    ipfs: 'https://arweave.net/QhoCCmNvCK3S1-VfnSZELc2vLsvAjQljZ3dZBBB_HsE/',
    isGenerative: true,
    links: {
      manifold: 'https://app.manifold.xyz/c/deja-hue',
      diptych: 'petite-chute'
    },
    provenance: 'https://arweave.net/Zc6ueb3GLbFhE0p2miNrTdd3Bxo_xW7ssenSpni8KsU',
    thumbnail: 'https://arweave.net/fI_Cn8BgJ1RLiZc2CTIhl36RsI4tOPH31Iv99ksF0ks',
    sourceCode: 'https://github.com/aebrer/pico8_carts/tree/master/series/screensavers/deja_roux',
    favorite: true,
    themes: ['screensaver', 'ambient', 'colors', 'cellular automata', 'entropy locking', 'p5js', 'generative', 'soothing', 'infinite', 'arweave', 'ETH', 'ETH genesis', 'interactive', 'diptych']
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
