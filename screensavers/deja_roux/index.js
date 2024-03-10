
/*
Controls at bottom or in description online.
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
let PIX_WIDTH = 32;
// Cache for possible colors
const MAX_CACHE_SIZE = 10000;
// Use a fixed-size array for colorCache
let colorCache = new Array(MAX_CACHE_SIZE);
let PIX_BATCH_SIZE = Math.floor(PIX_WIDTH / 2);

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

let pg, wth, hgt, hc, ww, wh, x, y, col, hues, pd = 5, dd, initial_run = true, mycan, tx, c, calt, nostroke, loop_count = 0, locking_method, xdata, ydata, pixeldata, seed_freq;
// const ent_lock_methods = ["Random Chance", "Consistent by Frame Count", "None"];
const ent_lock_methods = ["Random Chance"];
// const ent_lock_methods = ["None"];
// const ent_lock_methods = ["Consistent by Frame Count"];

let init_hue_limiter = random_int(0, 360);
// const init_hue_limiter = 16;
// console.log("init_hue_limiter: ", init_hue_limiter);
let possible_hue_transforms = [0,0,1,1,-1,-1,2,-2,3,-3];
// let possible_hue_transforms = [-1,-1,-2,-3];
const possible_saturation_transforms = [1, 2, 3, -1, -2, -3];
const possible_brightness_transforms = [1, 2, 3, 5, -1, -2];

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
    
    
    let hueget = h + randomChoice(possible_hue_transforms);
    if (hueget < init_hue_limiter-69) {hueget = init_hue_limiter-69}
    if (hueget > init_hue_limiter+69) {hueget = init_hue_limiter+69}
    if (hueget < 1) {hueget = 360 + hueget}
    if (hueget > 360) {hueget = hueget - 360}
    // sanitization
    hueget = Math.floor(hueget);

    const sat = Math.floor(Math.max(69, Math.min(100, s + randomChoice(possible_saturation_transforms))));
    const bright = Math.floor(Math.min(69, Math.max(98, b + randomChoice(possible_brightness_transforms))));

    const newcolor = get_hsb(hueget, sat, bright);
    const col = color(newcolor);
    // // log them both
    // console.log("col: ", col)
    // console.log("newcolor: ", newcolor)

    possible_colors.push(col); // Use get_hsb to convert HSB to RGB
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

    if (locking_method == "Random Chance") {
      if (random_int(1,1000)>500){fxrand=sfc32(...hashes)}
    }

    // // if pixel is settled, shouldn't be here, that's a bug
    if (pixel.state === "settled") {
      // console.log("pixel is settled, shouldn't be here")
      return
    }
    
    let col = color(get_hsb(randomChoice(hues), random_int(75,100), random_int(75,100)));
    
    if (pixel.state !== "unseen" && pixel.colors.length > 0) {
      col = randomChoice(pixel.colors)
    }

    // // check if the col is not white
    if (brightness(col) > 99) {
      // console.log("white pixel")
      pixel.state = "settled";
      return
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
  // console.log(pg.pixels.length);
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

  pixeldata = Array.from({ length: wth }, (_, i) => Array.from({ length: hgt }, (_, j) => ({ x: i, y: j, state: "unseen", colors: [], color: color(get_hsb(calt, 0, 0)) })));

  renew_pixels();

};

const renew_pixels = () => {
  hashes = get_new_hashes();
  fxrand = sfc32(...hashes);
  locking_method = randomChoice(ent_lock_methods);
  // possible_hue_transforms = [];
  // limit possible_hue_transforms to 2
  // if (possible_hue_transforms.length >= 2) {
  //   possible_hue_transforms.shift();
  // }
  // possible_hue_transforms.push(possible_hue_transforms[0] + random_int(0,1));

  // console.log("hue genotype: ", possible_hue_transforms);
  // pg.clear()
  // clear()


  hues = Array.from({ length: 1 }, () => random_int(0, 360));

  if (loop_count > 0) {
    // get all settled pixels
    const settled_pixels = get_all_pixels_by_state("settled")
    // choose one at random
    const random_pixel = randomChoice(settled_pixels)
    // while it's a black pixel, choose another one
    while (brightness(random_pixel.color) < 1) {
      random_pixel = randomChoice(settled_pixels)
    }

    // get possible colors for that pixel
    const new_cols = get_possible_colors(random_pixel.color)
    // get just the hues from these colors
    for (let i = 0; i < new_cols.length; i++) {
      const new_col = new_cols[i]
      // console.log("new_col: ", new_col)
      hues[i] = hue(new_col)
      // console.log("hues[i]: ", hues[i])
    } 
  }

  // console.log("hues: ", hues)

  pixeldata.forEach(row => row.forEach(pixel => {
    pixel.state = "unseen";
    pixel.colors = [];
  }));


  colorCache = new Array(MAX_CACHE_SIZE);

};


function draw() {
  
  // entropy locking

  if (locking_method == "Random Chance") {
    if (random_int(1,1000)>400){fxrand=sfc32(...hashes)}
  } else if (locking_method == "Consistent by Frame Count") {
    if(frameCount%5==0){fxrand=sfc32(...hashes)}
  } 

  // // call fxpreview when the drawing is finished, and stop rendering
  // if(loop_count>16){fxpreview();noLoop();}

  // load the pixels from the graphics object
  pg.loadPixels();


  // // get all the waiting pixels
  let waiting_pixels = get_all_pixels_by_state("waiting")
  let unseen_pixels = get_all_pixels_by_state("unseen")

  // // if there are no waiting pixels, get a random unseen pixel
  // if (waiting_pixels.length === 0 || (frameCount%seed_freq==0 & frameCount<100)) {
  //     random_pixels[0] = randomChoice(unseen_pixels);
  // } else {
  //     for (let i = 0; i < PIX_BATCH_SIZE; i++) {
  //       random_pixels[i] = waiting_pixels[i % waiting_pixels.length];
  //     }
  // }


  for (let i = 0; i < PIX_BATCH_SIZE; i++) {
    // random_pixels[i] = 
    // 50:50 chance of getting a waiting pixel or an unseen pixel
    if ((waiting_pixels.length === 0) && unseen_pixels.length > 0){
      let new_pixel = randomChoice(unseen_pixels);
      new_pixel.state = "waiting";
      // set the color to a random color via get_possible_colors
      new_pixel.colors = get_possible_colors(new_pixel.color);
      random_pixels[i] = new_pixel;
      
    } else {
      random_pixels[i] = randomChoice(waiting_pixels);
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
  // window.location.reload();
  setup();
}

// if the user presses s, save a png of the image
// if the user presses f, toggle fullscreen
// if the user presses p, toggle pause

function keyPressed() {
  if (key == 's' || key == 'S') saveCanvas(mycan, 'dejahue', 'png');
  if (key == 'f' || key == 'F') fullscreen(!fullscreen());
  if (key == 'p' || key == 'P') noLoop();
  if (key == 'r' || key == 'R') setup();
  if (key == 'u' || key == 'U') loop();
  if (key == 'b' || key == 'B') {PIX_WIDTH = Math.floor(PIX_WIDTH * 2); PIX_BATCH_SIZE=PIX_WIDTH;setup();}
  if (key == 'n' || key == 'N') {PIX_WIDTH = Math.floor(PIX_WIDTH / 2); PIX_BATCH_SIZE=PIX_WIDTH;setup();}
  if (key == 'c' || key == 'C') {init_hue_limiter = random_int(0, 360);setup();}
}

function checkLoop() {
  if (this.checked()) {
    loop();
  } else {
    noLoop();
  }
}