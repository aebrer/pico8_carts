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


const PIX_WIDTH = 512;
let wth, ww, wh;


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



function setup() {

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
  pg.strokeWeight(1);

}

function draw() {

  pg.loadPixels();

  rng_reset();

  for (let x = 0; x < wth; x += random_int(0,8)) {
    rng_reset(950);
  for (let y = 0; y < wth; y += random_int(0,8)) {
      rng_reset(950);
      const c = getColor(x-1, y-1);
      const c1 = c[0] + random_int(-1, 1) % 255;
      const c2 = c[1] + random_int(-1, 1) % 255;
      const c3 = c[2] + random_int(-1, 1) % 255;

      setColor(x, y, c1, c2, c3);
      pixel_circle(x, y, random_int(1,5), c1, c2, c3)
    }
  }

  pg.updatePixels();
  image(pg, 0, 0, ww, ww, 0, 0, wth, wth)

}

// ux
function keyTyped() {
if (key === 's') {
  save("sedimentary_city_redux.png")
}
}
