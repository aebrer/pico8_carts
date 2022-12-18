// Entropy Locked Wave Function Collapse

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


//thanks @Yazid for these two helper functions
function random_num(a, b) {
    return a+(b-a)*fxrand()
  }
function random_int(a, b) {
  return Math.floor(random_num(a, b+1))
}


function randomChoice(arr) {
  return arr[Math.floor(random_num(0,1) * arr.length)];
}

function get_new_hashes() {
  console.log("old hashes: ", hashes)
  // for each element in hashes, increase it's value by 1
  hashes = hashes.map(h => h+1)
  console.log("new hashes: ", hashes)
  return hashes
}

// will decide on mobile mode unless there is a pointer device with hover capability attached
let is_mobile = window.matchMedia("(any-hover: none)").matches

// hashes = "hriirieiririiiritiififiviviifj"
// if(hashes==="debug"){hashes=random_num(0,1000000)}
fxrand = sfc32(...hashes)
window.$fxhashFeatures = {}

//PGrahics object
let pg;
let aspect = 0.71
let wth;
let hgt;
let hc;
let ww;
let wh;
let px = 0;
let py = 0;
let col;
let pd=3;
let dd;
let df;
let dx;
let dy;
let steps = [1,2,3,4,5,-1,-2,-3,-4,-5]

let rfac = 0;
let gfac = 0;
let bfac = 0;

let initial_run=true;

let mycan;
let tx;

//fxhash features
let c;
let calt;
let nostroke;
let loop_count=0;
let locking_method;

let xdata;
let ydata;
let seed_freq;

let pixel_buffer = [];
let buffer_full = false;
let seed_check_frame = 0;


function setup() {
  

  fxrand = sfc32(...hashes)
  

  if(isFxpreview){
    ww=1080
    wh=1080
    is_mobile=false
    pd=5
  } else {
    ww=windowWidth
    wh=windowHeight
  }

  ww = 1065
  wh = 1500

  // shrink dimensions to fit the full image in the display dynamically
  if(windowHeight<wh){
    wh=windowHeight
    ww = wh*aspect
  }


  mycan = createCanvas(ww, wh);

  wth = 32
  window.$fxhashFeatures["Pixel Width"] = wth
  // wth = 32
  hgt = Math.ceil(wth / 0.71)
  hc=-wth
  pg = createGraphics(wth, hgt);
  // pg.colorMode(HSL)

  dd=displayDensity()
  df = Math.ceil(dd * pd * 0.5)
  if(is_mobile){df/=3}
  pixelDensity(df);
  df = pixelDensity();
  // blendMode(DIFFERENCE);
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)  

  rfac = random_int(10, 25) * randomChoice([1, -1])
  gfac = random_int(10, 25) * randomChoice([1, -1])
  bfac = random_int(10, 25) * randomChoice([1, -1])
  // if rfac==gfac==bfac, then we need to change one of them
  while (rfac == gfac && gfac == bfac) {
    rfac = random_int(10, 25) * randomChoice([1, -1])
    gfac = random_int(10, 25) * randomChoice([1, -1])
    bfac = random_int(10, 25) * randomChoice([1, -1])
  }

  dx = randomChoice(steps)
  dy = randomChoice(steps)

  locking_method = randomChoice(["every"])
  window.$fxhashFeatures["Entropy Locking Method"] = locking_method
  console.table(window.$fxhashFeatures)
}


function draw() {
  
  // entropy locking
  if (locking_method == "Random Chance") {
    if (random_int(1,1000)>900){fxrand=sfc32(...hashes)}
  } else if (locking_method == "Consistent by Frame Count") {
    if(frameCount%5==0){fxrand=sfc32(...hashes);pg.clear()}
  } else if (locking_method == "None") {
    if(frameCount%5==0){pg.clear()}
  } else if (locking_method == "every") {
    fxrand=sfc32(...hashes)
  }
  // // call fxpreview when the drawing is finished, and stop rendering
  // if(loop_count>16){fxpreview();noLoop();}

  // console.log(pg.pixels)
  for (let i=0;i<Math.ceil((wth+hgt)/5);i++){

    // load the pixels from the graphics object
    pg.loadPixels();
    // change which pixel we are updating
    px += dx
    px = (px+wth)%wth
    py += dy
    py = (py+hgt)%hgt

    px = Math.floor(px)
    py = Math.floor(py)

    // push px and py to the pixel_buffer
    pixel_buffer.push([px, py])

    // if pixel_buffer longer than ?, pop the oldest value
    if (pixel_buffer.length > (wth*hgt*4)) {
      pixel_buffer.shift()
      buffer_full = true
    }

    // get the number of unique values in pixel_buffer, check if less than X
    seed_check = new Set(pixel_buffer.map(JSON.stringify)).size < (wth*hgt) && buffer_full
    // get a new random seed
    if (seed_check && frameCount - seed_check_frame > 300) {
      console.log("getting new hash")
      fxrand = sfc32(...hashes) // need to make sure to reseed right before getting the new hash
      hashes = get_new_hashes()
      seed_check_frame = frameCount
    }

    // spiral logic
    if (random_int(1,1000)>900){
      dx = randomChoice(steps)
    } else {
      dx *= 0.99
    }

    if (random_int(1,1000)>900){
      dy = randomChoice(steps)
    } else {
      dy *= 0.99
    }

    // get the color values from a random neighbor, including self
    const px2 = (px+random_int(-1,0)+wth)%wth
    const py2 = (py+random_int(-1,0)+hgt)%hgt

    // console.debug(px, py, px2, py2)

    // const i2 = (py2 * wth + px2) * df * 4;
    // const i = 4 * (py * wth + px);
    // const i2 = 4 * (py2 * wth + px2);

    // console.debug("px,py,i",px,py,i)
    // console.debug("px2,py2,i2",px2,py2,i2)
    // console.debug("pg.pixels[i]",pg.pixels[i])

    // let r2 = pg.pixels[i2]
    // let g2 = pg.pixels[i2 + 1]
    // let b2 = pg.pixels[i2 + 2]

    const col = pg.get(px2,py2)
    const [r2, g2, b2] = [red(col), green(col), blue(col)]; // get colors

    // log r2, g2, b2 to debug
    // console.debug(`px2: ${px2}, py2: ${py2}, r2: ${r2}, g2: ${g2}, b2: ${b2}`)

    const r = (r2+random_int(0,rfac)+255)%255
    const g = (g2+random_int(0,gfac)+255)%255
    const b = (b2+random_int(0,bfac)+255)%255
    // console.debug(`r: ${r}, g: ${g}, b: ${b}`)
    
    // // set the pixel color
    // pg.pixels[i] = r;
    // pg.pixels[i + 1] = g;
    // pg.pixels[i + 2] = b;

    pg.set(px, py, color(r, g, b));
    // now update the graphics object with the new pixel values
    pg.updatePixels();
  }
  
  // render the graphics buffer to the display canvas
  image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)

  return
}

// ux
function keyTyped() {
  if (key === 's') {
    save(mycan, "export_.png")
  } else if (key === "1") {
    pd=1
    setup()
  } else if (key === "2") {
    pd=2
    setup()
  } else if (key === "3") {
    pd=3
    setup()
  } else if (key === "4") {
    pd=4
    setup()
  } else if (key === "5") {
    pd=5
    setup()
  } else if (key === "6") {
    pd=6
    setup()
  } else if (key === "7") {
    pd=7
    setup()
  } else if (key === "8") {
    pd=8
    setup()
  } 
}
