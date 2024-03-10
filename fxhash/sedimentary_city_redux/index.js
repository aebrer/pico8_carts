/*
This is sedimentary city redux. "sedimentary city" can be found here: https://www.fxhash.xyz/generative/13978


Controls:

s -> save a png of the image
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

function rng_reset(odds=999) {
  if (random_int(1, 1000) > odds) {
    $fx.rand.reset();
  }
}


let PIX_WIDTH = 32;
let wth, ww, wh;

let rfac=0, gfac=0, bfac=0;

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




function setup() {

  $fx.rand.reset();
  PIX_WIDTH = random_int(16, 32);

  rfac = random_int(5,50);
  gfac = random_int(5,50);
  bfac = random_int(5,50);

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
  pg.background(0);
  background(0);
  pg.strokeWeight(1);

}

function draw() {

  pg.loadPixels();

  rng_reset();

  for (let x = 0; x < wth; x += random_int(1,8)) {
    rng_reset(950);
  for (let y = 0; y < wth; y += random_int(1,8)) {
      rng_reset(990);
      const c = getColor(x+random_int(-1,1), y+random_int(-1,1));
      const c1 = c[0] + random_int(-rfac, rfac) % 255;
      const c2 = c[1] + random_int(-gfac, gfac) % 255;
      const c3 = c[2] + random_int(-bfac, bfac) % 255;

      if (random_int(0, 99) < 50) {
        setColor(x, y, c1, c2, c3);
      }
      if (random_int(0, 99) < 50) {
        pixel_circle(x, y, random_int(1,5), c1, c2, c3)
      }
      if (random_int(0, 99) < 50) {
        pixel_rect(x, y, random_int(0,8), random_int(0,8), c1, c2, c3)
      }
    }
  }


  pg.updatePixels();
  image(pg, ww/16, ww/16, ww*14/16, ww*14/16, 0, 0, wth, wth)

  if (fc > 30) {
    console.log('finished frame: ' + fc);
    finish_image();
  }

  fc += 1;

}

function finish_image() {
  console.log('finishing image');
  background(obtain_bg_color());
  image(pg, ww/16, ww/16, ww*14/16, ww*14/16, 0, 0, wth, wth)
  noLoop();
  $fx.preview();
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
  console.log(bg_color);
  return bg_color;
}



// ux
function keyTyped() {
if (key === 's') {
  save("sedimentary_city_redux.png")
}
if (key === 'n') {
  loop();
}
}

// on resize, reload the page
function windowResized() {
  window.location.reload();
}