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
  fxhash = "oo" + Array(49).fill(0).map(_=>alphabet[(Math.random()*alphabet.length)|0]).join('')
  b58dec = str=>[...str].reduce((p,c)=>p*alphabet.length+alphabet.indexOf(c)|0, 0)
  fxhashTrunc = fxhash.slice(2)
  regex = new RegExp(".{" + ((fxhashTrunc.length/4)|0) + "}", 'g')
  hashes = fxhashTrunc.match(regex).map(h => b58dec(h))
  return hashes
}


// will decide on mobile mode unless there is a pointer device with hover capability attached
let is_mobile = window.matchMedia("(any-hover: none)").matches

// hashes = "aebrerandrewbrereton"
// if(hashes==="debug"){hashes=random_num(0,1000000)}
fxrand = sfc32(...hashes)
window.$fxhashFeatures = {}

//PGrahics object
let pg;
let aspect = 0.71
let wth;
let hgt;
let max_pdim;
let hc;
let ww;
let wh;
let max_wdim;
let px = 0;
let py = 0;
let col;
let pd=3;
let dd;
let df;

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

let base_color = [0, 0, 0]

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

  mycan = createCanvas(ww, wh);

  wth = 64
  hgt = wth
  window.$fxhashFeatures["Pixel Width"] = wth

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

  locking_method = randomChoice(["Random Chance"])
  window.$fxhashFeatures["Entropy Locking Method"] = locking_method
  console.table(window.$fxhashFeatures)

  base_color = [random_int(0, 360), random_int(0, 360), random_int(0, 360)]


}

function draw() {

  // entropy locking
  if (locking_method == "Random Chance") {
    if (random_int(1,1000)>800 && frameCount>600){fxrand=sfc32(...hashes)}
  } else if (locking_method == "Consistent by Frame Count") {
    if(frameCount%5==0){fxrand=sfc32(...hashes);pg.clear()}
  } else if (locking_method == "None") {
    if(frameCount%5==0){pg.clear()}
  }
  // // call fxpreview when the drawing is finished, and stop rendering
  // if(loop_count>16){fxpreview();noLoop();}

  // console.log(pg.pixels)
  for (let i=0;i<Math.ceil((wth+hgt)/5);i++){

    // load the pixels from the graphics object
    pg.loadPixels();
    // change which pixel we are updating
    px += random_int(-2,2)
    px = (px+wth)%wth
    py += random_int(-2,2)
    py = (py+hgt)%hgt

    // push px and py to the pixel_buffer
    pixel_buffer.push([px, py])

    // if pixel_buffer longer than 500, pop the oldest value
    if (pixel_buffer.length > (wth*hgt)) {
      pixel_buffer.shift()
    }

    // get the number of unique values in pixel_buffer, check if less than X
    seed_check = new Set(pixel_buffer.map(JSON.stringify)).size < (wth*hgt)/2
    // get a new random seed
    if (seed_check) {
      hashes = get_new_hashes()
    }


    // get the color values from a random neighbor, including self
    const px2 = (px+random_int(-1,1)+wth)%wth
    const py2 = (py+random_int(-1,1)+hgt)%hgt


    const col = pg.get(px2,py2)
    const [r2, g2, b2] = [red(col), green(col), blue(col)]; // get colors

    let r = (r2+random_int(0,rfac)+255)%255
    let g = (g2+random_int(0,gfac)+255)%255
    let b = (b2+random_int(0,bfac)+255)%255
    
    // if the right mouse button is pressed, set the color to the base color
    if ((mouseIsPressed && mouseButton == RIGHT) || frameCount < 600) {
      r = (base_color[0]+random_int(0,rfac)+255)%255
      g = (base_color[1]+random_int(0,gfac)+255)%255
      b = (base_color[2]+random_int(0,bfac)+255)%255    
    } else if (mouseIsPressed && mouseButton == LEFT) {
      r = (base_color[0]+random_int(0,rfac)+255)%255
      g = (base_color[1]+random_int(0,gfac)+255)%255
      b = (base_color[2]+random_int(0,bfac)+255)%255
      hashes = get_new_hashes()
    }
    pg.set(px, py, color(r, g, b));
    // now update the graphics object with the new pixel values
    pg.updatePixels();
  }
  
  // render the graphics buffer to the display canvas
  if (ww>wh) {
    image(
      pg,
      0,0,ww,wh,
      0,0,wth,wh*wth/ww
    )
  } else if (ww<wh) {
    image(
      pg,
      0,0,ww,wh,
      0,0,ww*hgt/wh,hgt
    )
  } else {
    image(pg,0,0,ww,wh,0,0,wth,wth)

  }

  loop_count += 1
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
