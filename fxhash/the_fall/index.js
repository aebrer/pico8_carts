/*
Controls:

s -> save a png of the image
n -> next frame
------------------

find my social links, projects, newsletter, roadmap, and more, at aebrer.xyz
or 
minted by:
  eth: 0xD2b1DF574564F4da4775f8bDf79BDF29b42D8BD7
  tezos: tz1ZBMhTa7gxSpaeXoqyc6bTCrxEHfZYSpPt

license: CC0 -> go nuts; citations not required but definitely appreciated

*/

function random_num(a, b) {
  return a+(b-a)*$fx.rand()
}
function random_int(a, b) {
return Math.floor(random_num(a, b+1))
}

function randomChoice(arr) {
return arr[Math.floor(random_num(0,1) * arr.length)];
}

function rng_reset(odds=999999) {
  if (random_int(1, 1000000) > odds) {
    $fx.rand.reset();
  }

  if (seed_change_needed) {
    change_rng();
  }

}

let PIX_WIDTH = 32;
let wth, ww, wh;
let entropy_lock_x=950, entropy_lock_y=950;
let seed_change_needed=0;
let rfac=0, gfac=0, bfac=0;
let dfacs=[];

let fc=0;

function getColor(x, y) {
  const index = (y * wth + x) * 4;
  return [pg.pixels[index], pg.pixels[index + 1], pg.pixels[index + 2], pg.pixels[index + 3]]; // Return a RGBA array
}

function setColor(x, y, r, g, b) {
  const index = (y * wth + x) * 4;
  pg.pixels[index] = r;
  pg.pixels[index + 1] = g;
  pg.pixels[index + 2] = b;
}

function pixel_circle(x, y, rad, r, g, b) {
  for (let i = x - rad; i <= x + rad; i++) {
    for (let j = y - rad; j <= y + rad; j++) {
      if (dist(i, j, x, y) <= rad) {
        setColor(i, j, r, g, b);
      }
    }
  }
}

// function pixel_rect, x, y, xl, yl, r, g, b
function pixel_rect(x, y, xl, yl, r, g, b) {
  for (let i = x; i < x + xl; i++) {
    for (let j = y; j < y + yl; j++) {
      setColor(i, j, r, g, b);
    }
  }
}

// function burn_color(r, g, b) returns a descended color
function burn_color(r, g, b) {
  r = r * random_num(0.9, 1.00) - rfac;
  if (r < 0) {
    r = 255 + r;
  }
  g = g * random_num(0.9, 1.00) - gfac;
  if (g < 0) {
    g = 255 + g;
  }
  b = b * random_num(0.9, 1.00) - bfac;
  if (b < 0) {
    b = 255 + b;
  }

  return [r, g, b];
}

// change_rng
function change_rng() {
  // if we flood the rng with requests after resetting, it will change randomly
  // so assume the randomseed has just been reset
  for (let i = 0; i < 1000 * seed_change_needed; i++) {
    random_num(0,1000);
  }
}

function get_dfacs() {
  let xf1, xf2, yf1, yf2;
  xf2 = random_int(0, 3);
  xf1 = xf2 - random_int(0, 3);
  yf2 = random_int(0, 3);
  yf1 = yf2 - random_int(0, 3);
  return [xf1, xf2, yf1, yf2];
}


function setup() {

  $fx.rand.reset();
  if (seed_change_needed) {
    change_rng();
  }

  rfac = random_int(2,50);
  gfac = random_int(2,50);
  bfac = random_int(2,50);

  dfacs = get_dfacs();

  entropy_lock_x = max(random_int(500, 999), random_int(500, 999));
  entropy_lock_y = max(random_int(500, 999), random_int(500, 999));

  wth = PIX_WIDTH;
  if($fx.isPreview){
    ww=2048
    mycan = createCanvas(2048, 2048);
  } else {
    ww=min(windowWidth, windowHeight)
    mycan = createCanvas(ww, ww);
  }

  pg = createGraphics(wth, wth);
  pg.colorMode(HSL);
  pg.pixelDensity(1);
  pg.loadPixels();
  pixelDensity(1);
  noSmooth();
  pg.background(random_int(0,255));
  background(0);
  pg.strokeWeight(1);


  $fx.features({
    'pix_width': PIX_WIDTH,
    'entropy_lock_x': entropy_lock_x,
    'entropy_lock_y': entropy_lock_y
  })

  console.table($fx.getFeatures())

}

function draw() {

  pg.loadPixels();
  for (let i = 0; i < 100; i++) {
    const x = random_int(0, wth-1);
    const y = random_int(0, wth-1);
    // rng_reset(999005);
    const c = getColor(x+random_int(dfacs[0],dfacs[1]), y+random_int(dfacs[2],dfacs[3]));
    const c_new = burn_color(c[0], c[1], c[2]);
    const c1 = c_new[0];
    const c2 = c_new[1];
    const c3 = c_new[2];
    setColor(x, y, c1, c2, c3);

  }

  pg.updatePixels();
  image(pg, ww/16, ww/16, ww*14/16, ww*14/16, 0, 0, wth, wth)

  if (fc > 120) {
    console.log('finished frame: ' + fc);
    finish_image();
  }
  fc += 1;
}

function finish_image() {
  console.log('finishing image');
  let bg_color = obtain_bg_color();
  // if the bg color is white, we need to regenerate the image
  if (bg_color[0] == 255 && bg_color[1] == 255 && bg_color[2] == 255) {
  // if (true) {

    console.log('regenerating image');
    setup();
    fc = 0;
    seed_change_needed += 1;
  } else {
    background(bg_color);
    image(pg, ww/16, ww/16, ww*14/16, ww*14/16, 0, 0, wth, wth)
    noLoop();
    $fx.preview();
  }
}

function obtain_bg_color() {
  // first we loop over the pixels with an interval size 
  // and store the r,g,b values in arrays
  const interval = 8
  let bg_color = [0,0,0];
  let r_array = [];
  let g_array = [];
  let b_array = [];
  for (let x = 0; x < wth; x += interval) {
    for (let y = 0; y < wth; y += interval) {
      const c = getColor(x, y);
      r_array.push(c[0]);
      g_array.push(c[1]);
      b_array.push(c[2]);
    }
  }

  // now compute the average pixel color
  const avg_r = r_array.reduce((a,b) => a + b)/r_array.length;
  const avg_g = g_array.reduce((a,b) => a + b)/g_array.length;
  const avg_b = b_array.reduce((a,b) => a + b)/b_array.length;

  // now get the background color as the average pixel color
  bg_color = [avg_r, avg_g, avg_b];
  return bg_color;
}


// ux
function keyTyped() {
if (key === 's') {
  save("the_fall.png")
}
if (key === 'n') {
  loop();
}
}

// on resize, reload the page
function windowResized() {
  window.location.reload();
}