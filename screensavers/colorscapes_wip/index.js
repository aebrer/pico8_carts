
/*
Controls:

F11 -> fullscreen mode (alternatively you should be able to do this from your browser menu)
s -> save a png of the image
1-8 -> set the pixel density and re-render (default is 2, higher means higher resolution final image; the preview image is generated with a value of 5, at 1080x1080px)

------------------

find my social links, projects, newsletter, roadmap, and more, at aebrer.xyz
or 
minted by tz1ZBMhTa7gxSpaeXoqyc6bTCrxEHfZYSpPt

license: CC0 -> go nuts; citations not required but definitely appreciated

*/



// Helper functions
const random_num = (a, b) => a + (b - a) * fxrand();
const random_int = (a, b) => Math.floor(random_num(a, b + 1));
const randomChoice = arr => arr[Math.floor(random_num(0, 1) * arr.length)];

// scale of the pixel canvas
const PIX_WIDTH = 512;
// Cache for possible colors
const MAX_CACHE_SIZE = 10000;
// Use a fixed-size array for colorCache
const colorCache = new Array(MAX_CACHE_SIZE);
const PIX_BATCH_SIZE = 256;
const random_pixels = new Array(PIX_BATCH_SIZE);

const get_new_hashes = () => {
  fxhash = "oo" + Array(49).fill(0).map(_ => alphabet[(Math.random() * alphabet.length) | 0]).join('');
  const b58dec = str => [...str].reduce((p, c) => p * alphabet.length + alphabet.indexOf(c) | 0, 0);
  const fxhashTrunc = fxhash.slice(2);
  const regex = new RegExp(".{" + ((fxhashTrunc.length / 4) | 0) + "}", 'g');
  const hashes = fxhashTrunc.match(regex).map(h => b58dec(h));
  return hashes;
};

const is_mobile = window.matchMedia("(any-hover: none)").matches;

fxrand = sfc32(...hashes);
window.$fxhashFeatures = {};

let pg, wth, hgt, hc, ww, wh, x, y, col, pd = 5, dd, initial_run = true, mycan, tx, c, calt, nostroke, loop_count = 0, locking_method, xdata, ydata, pixeldata, seed_freq;
// const ent_lock_methods = ["Random Chance", "Consistent by Frame Count", "None"];
// const ent_lock_methods = ["Random Chance"];
// const ent_lock_methods = ["None"];
const ent_lock_methods = ["Consistent by Frame Count"];

let possible_hue_transforms = [0, 0, 0, 0, 1, 2, randomChoice([5,10,45,180])];
const possible_saturation_transforms = [1, 2, 3, -1, -2, -3];
const possible_brightness_transforms = [1, 2, 3, 5, -1, -2, -3, -5];

// Define the neighbors array once outside of the function
const neighbors = new Array(8);

const get_hsb = (h, s, b) => `hsb(${h},${s}%,${b}%)`;

const get_all_pixels_by_state = state => {
  const good_pixels = [];
  for (let x = 0; x < wth; x++) {
    const pixels = pixeldata[x];
    for (let i = 0; i < pixels.length; i++) {
      if (pixels[i].state === state) {
        good_pixels.push(pixels[i]);
      }
    }
  }
  return good_pixels;
};

// This function will return the possible neighbor colors given a color
const get_possible_colors = col => {
  const h = hue(col);
  const s = saturation(col);
  const b = brightness(col);
  const key = `${h}-${s}-${b}`; // Use a simpler key

  if (colorCache[key]) {
    return colorCache[key];
  }

  const possible_colors = [];

  for (let i = 0; i < 5; i++) {
    // const hue = Math.floor((h + possible_hue_transforms[i] + 360) % 360);
    const hueget = Math.floor((h + randomChoice(possible_hue_transforms) + 360) % 360);
    // const saturation = Math.floor(Math.max(50, Math.min(100, s + possible_saturation_transforms[j])));
    const sat = Math.floor(Math.max(50, Math.min(100, s + randomChoice(possible_saturation_transforms))));
    // const brightness = Math.floor(Math.max(75, Math.min(100, b + possible_brightness_transforms[k])));
    const bright = Math.floor(Math.max(75, Math.min(100, b + randomChoice(possible_brightness_transforms))));
    possible_colors.push(color(get_hsb(hueget, sat, bright))); // Use get_hsb to convert HSB to RGB
  }

  // Limit the size of the cache
  if (Object.keys(colorCache).length >= MAX_CACHE_SIZE) {
    const oldestKey = Object.keys(colorCache)[0];
    delete colorCache[oldestKey];
  }

  colorCache[key] = possible_colors;
  return possible_colors;
};


// This function will set the color of a batch of pixels
const set_pixel_colors = (pixels) => {
  pixels.forEach(pixel => {
    
    let col = color(get_hsb(randomChoice(hues), random_int(75,100), random_int(75,100)));
    
    if (pixel.state === "unseen") {
      // do nothing
    } else {
      col = randomChoice(pixel.colors)
    }
  
    let x = pixel.x
    let y = pixel.y
    pixeldata[x][y].color = col;
    pixeldata[x][y].state = "settled";

    const idx = (x + y * wth) * 4; // Calculate the index in the pixels array
    pg.pixels[idx] = red(col); // Set the red channel
    pg.pixels[idx + 1] = green(col); // Set the green channel
    pg.pixels[idx + 2] = blue(col); // Set the blue channel
    pg.pixels[idx + 3] = alpha(col); // Set the alpha channel

    const neighbors = [
      [(x - 1 + wth) % wth, y],
      [(x + 1 + wth) % wth, y],
      [x, (y - 1 + hgt) % hgt],
      [x, (y + 1 + hgt) % hgt],
      [(x + 1 + wth) % wth, (y + 1 + hgt) % hgt],
      [(x - 1 + wth) % wth, (y - 1 + hgt) % hgt],
      [(x + 1 + wth) % wth, (y - 1 + hgt) % hgt],
      [(x - 1 + wth) % wth, (y + 1 + hgt) % hgt]
    ];

    neighbors.forEach(([nx, ny]) => {
      if (pixeldata[nx][ny].state != "settled") {
        pixeldata[nx][ny].colors.push(...get_possible_colors(col));
        pixeldata[nx][ny].state = "waiting";
      }
    });
  });
};


function setup() {
  fxrand = sfc32(...hashes);

  if (isFxpreview) {
    ww = 1080;
    wh = 1080;
    is_mobile = false;
    pd = 5;
  } else {
    ww = windowWidth;
    wh = windowHeight;
  }

  mycan = createCanvas(ww, wh);

  wth = PIX_WIDTH;
  window.$fxhashFeatures["Pixel Width"] = wth;
  hgt = Math.ceil(wth * (wh / ww));
  hc = -wth;
  pg = createGraphics(wth, hgt);
  pg.colorMode(HSL);
  pg.pixelDensity(1);
  pg.loadPixels();
  console.log(pg.pixels.length);
  // pg.pixels = new Uint32Array(wth * hgt);

  dd = displayDensity();
  let df = Math.ceil(dd * pd * 0.5);
  if (is_mobile) { df /= 3; }
  pixelDensity(df);
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1);

  let seed_freq = random_int(5, 100);

  locking_method = randomChoice(ent_lock_methods);

  hues = [random_int(0, 360)];
  for (let i = 0; i < 30; i++) {
    hues.push((hues[0] + randomChoice([5, 10, 15, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 120, 120, 180, 180, 180, 180, 270, 270])) % 360);
  }

  let num_hues = [...new Set(hues)].length;
  window.$fxhashFeatures["Number of Seed Hues"] = num_hues;

  pixeldata = Array.from({ length: wth }, (_, i) => Array.from({ length: hgt }, (_, j) => ({ x: i, y: j, state: "unseen", colors: [], color: color(get_hsb(calt, 0, 0)) })));

  console.table(window.$fxhashFeatures);
};

const renew_pixels = () => {
  hashes = get_new_hashes();
  fxrand = sfc32(...hashes);
  locking_method = randomChoice(ent_lock_methods);
  possible_hue_transforms = [0, 0, 0, 0, 1, 2, randomChoice([5,10,45,180])];
  pixeldata.forEach(row => row.forEach(pixel => {
    pixel.state = "unseen";
    pixel.colors = [randomChoice(pixel.colors)];
  }));
};


function draw() {
  
  // entropy locking

  if (locking_method == "Random Chance") {
    if (random_int(1,1000)>800){fxrand=sfc32(...hashes);pg.clear()}
  } else if (locking_method == "Consistent by Frame Count") {
    if(frameCount%5==0){fxrand=sfc32(...hashes);pg.clear()}
  } else if (locking_method == "None") {
    if(frameCount%5==0){pg.clear()}
  }

  // // call fxpreview when the drawing is finished, and stop rendering
  // if(loop_count>16){fxpreview();noLoop();}

  // load the pixels from the graphics object
  pg.loadPixels();


  // get all the waiting pixels
  let waiting_pixels = get_all_pixels_by_state("waiting")
  let unseen_pixels = get_all_pixels_by_state("unseen")
  // if there are no waiting pixels, get a random unseen pixel
  if (waiting_pixels.length === 0 || (frameCount%seed_freq==0 & frameCount<100)) {
  // if (waiting_pixels.length === 0) {

    console.log("no waiting pixels, seeding")
    // get PIXEL_BATCH_SIZE random pixels
    // for (let i = 0; i < PIX_BATCH_SIZE; i++) {
      random_pixels[0] = randomChoice(unseen_pixels);
    // }
  } else {
    if (waiting_pixels.length < PIX_BATCH_SIZE) {
      for (let i = 0; i < PIX_BATCH_SIZE; i++) {
        random_pixels[i] = waiting_pixels[i % waiting_pixels.length];      }
    } else {
      for (let i = 0; i < PIX_BATCH_SIZE; i++) {
        random_pixels[i] = randomChoice(waiting_pixels);
      }
    }
  }
  set_pixel_colors(random_pixels)
  // if all pixels are settled, stop rendering
  if (get_all_pixels_by_state("settled").length === wth * hgt) {
    loop_count+=1;
    renew_pixels();
  }

  // now update the graphics object with the new pixel values
  pg.updatePixels();
  // render the graphics buffer to the display canvas
  image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)
  // // and mirror image
  // push();
  // translate(ww, 0);
  // scale(-1, 1);
  // image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)
  // pop();


  return
}

// on resize, reload the page
function windowResized() {
  window.location.reload();
}