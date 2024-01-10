
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
// const ent_lock_methods = ["Random Chance", "Consistent by Frame Count"];
const ent_lock_methods = ["None"];


const get_hsb = (h, s, b) => `hsb(${h},${s}%,${b}%)`;

const get_random_pixel_by_state = state => randomChoice(get_all_pixels_by_state(state));

const get_all_pixels_by_state = state => {
  let good_pixels = [];
  for (let x = 0; x < wth; x++) {
    let pixels = pixeldata[x];
    good_pixels = [...good_pixels, ...pixels.filter(pixel => pixel.state === state)];
  }
  return good_pixels;
};
// This function will return the possible neighbor colors given a color
const get_possible_colors = col => {
  const h = hue(col);
  const s = saturation(col);
  const b = brightness(col);

  const possible_hue_transforms = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, randomChoice([0, 0, 180])];
  const possible_hues = possible_hue_transforms.map(x => Math.floor((h + x + 360) % 360));

  let possible_saturation_transforms = [1, 2, 3];
  possible_saturation_transforms = possible_saturation_transforms.concat(possible_saturation_transforms.map(x => -x));
  const possible_saturations = possible_saturation_transforms.map(x => Math.floor(Math.max(0, Math.min(100, s + x))));

  let possible_brightness_transforms = [1, 2, 3, 5, 10];
  possible_brightness_transforms = possible_brightness_transforms.concat(possible_brightness_transforms.map(x => -x));
  const possible_brightnesses = possible_brightness_transforms.map(x => Math.floor(Math.max(0, Math.min(100, b + x))));

  const possible_colors = possible_hues.map(hue => possible_saturations.map(saturation => possible_brightnesses.map(brightness => color(get_hsb(hue, saturation, brightness))))).flat(2);

  return possible_colors;
};

// This function will set the color of a given pixel
const set_pixel_color = (x, y, col) => {
  pixeldata[x][y].color = col;
  pixeldata[x][y].state = "settled";
  pg.set(x, y, col);

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

  wth = 32;
  window.$fxhashFeatures["Pixel Width"] = wth;
  hgt = Math.ceil(wth * (wh / ww));
  hc = -wth;
  pg = createGraphics(wth, hgt);
  pg.colorMode(HSL);

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
  for (let i = 0; i < 3; i++) {
    hues.push((hues[0] + randomChoice([5, 10, 15, 0, 0, 0, 0, 0, 0, 0, 0, 45, 45, 45, 120, 120, 180, 180, 180, 180, 270, 270])) % 360);
  }

  let num_hues = [...new Set(hues)].length;
  window.$fxhashFeatures["Number of Seed Hues"] = num_hues;

  pixeldata = Array.from({ length: wth }, (_, i) => Array.from({ length: hgt }, (_, j) => ({ x: i, y: j, state: "unseen", colors: [], color: color(get_hsb(calt, 0, 0)) })));

  console.table(window.$fxhashFeatures);
};

const renew_pixels = () => {
  pixeldata.forEach(row => row.forEach(pixel => {
    pixel.state = "unseen";
    pixel.colors = [randomChoice(pixel.colors)];
  }));

  hashes = get_new_hashes();
  fxrand = sfc32(...hashes);
  locking_method = randomChoice(ent_lock_methods);
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
  // if there are no waiting pixels, get a random unseen pixel
  if (waiting_pixels.length === 0 || (frameCount%seed_freq==0 & frameCount<100)) {
  // if (waiting_pixels.length === 0) {

    console.log("no waiting pixels, seeding")
    let random_pixel = get_random_pixel_by_state("unseen")
    // set the random pixel to a random color
    set_pixel_color(random_pixel.x, random_pixel.y, color(get_hsb(randomChoice(hues), random_int(75,100), random_int(75,100))))
  } else {
    // if there are waiting pixels, get a random waiting pixel
    let random_pixel = randomChoice(waiting_pixels)
    // get a random color from the pixel's possible colors
    // let random_color = randomChoice(random_pixel.colors)
    let random_color = randomChoice(random_pixel.colors)
    // console.debug(random_color)
    // set the pixel to the random color
    set_pixel_color(random_pixel.x, random_pixel.y, random_color)
  }

  // if all pixels are settled, stop rendering
  if (get_all_pixels_by_state("settled").length === wth * hgt) {
    loop_count+=1;
    if(loop_count==2){fxpreview();}
    renew_pixels();
}

  // now update the graphics object with the new pixel values
  pg.updatePixels();
  // render the graphics buffer to the display canvas
  image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)

  blendMode(DIFFERENCE);
  for (let i=0;i<64;i++) {
    x=random_int(0,ww)
    y=random_int(0,wh)
    a=random_num(-ww/2,ww/2)
    b=random_num(-wh/2,wh/2)
    c=random_num(ww/8,ww/8)
    d=random_num(wh/8,wh/8)
    choices=[a,b,c,d]
    if(random_int(1,1000)>950){image(mycan, x+randomChoice(choices),y+randomChoice(choices),ww/8,wh/8, x+randomChoice(choices),y+randomChoice(choices),randomChoice(choices),randomChoice(choices))}
  }
  blendMode(BLEND);

  return
}

function keyTyped() {
  const actions = {
    's': () => save(mycan, "export_.png"),
    '1': () => { pd = 1; setup(); },
    '2': () => { pd = 2; setup(); },
    '3': () => { pd = 3; setup(); },
    '4': () => { pd = 4; setup(); },
    '5': () => { pd = 5; setup(); },
    '6': () => { pd = 6; setup(); },
    '7': () => { pd = 7; setup(); },
    '8': () => { pd = 8; setup(); },
  };

  if (actions[key]) {
    actions[key]();
  }
}
