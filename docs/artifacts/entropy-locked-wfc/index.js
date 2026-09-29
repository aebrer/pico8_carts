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

// hashes = "hriirieiririiiritiififiviviifj"
// if(hashes==="debug"){hashes=random_num(0,1000000)}
fxrand = sfc32(...hashes)
window.$fxhashFeatures = {}

//PGrahics object
let pg;

let wth;
let hgt;
let hc;
let ww;
let wh;
let x;
let y;
let col;
let pd=5;
let dd;

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
let pixeldata;
let seed_freq;


// function get hsb color string
function get_hsb(h, s, b) {
  return "hsb(" + h + "," + s + "%," + b + "%)";
}


// this function will return a random pixel from the given state
function get_random_pixel_by_state(state) {
  let good_pixels = get_all_pixels_by_state(state)
  return randomChoice(good_pixels)
}


// this function will return x,y coords of ALL pixels of a given state
function get_all_pixels_by_state(state) {
  let good_pixels = []
  // for each x position get the list of pixels
  for (let x=0; x<wth; x++) {
    let pixels = pixeldata[x]
    // for each pixel in the list of pixels, if the pixel state matches the given state, add it to the good_pixels array
    pixels.forEach(pixel => {
      if (pixel.state === state) {
        good_pixels.push(pixel)
      }
    })
  }
  return good_pixels
}

// this function will return the possible neighbor colors given a color
function get_possible_colors(col) {
  // get the hue, saturation, and brightness of the color
  let h = hue(col)
  let s = saturation(col)
  let b = brightness(col)

  let possible_colors = []
  // hue transformations modulo 360
  let possible_hue_transforms = [1,2,3,5,10]
  // let possible_hue_transforms = [0]
  // add a negative version for each hue transformation
  // possible_hue_transforms = possible_hue_transforms.concat(possible_hue_transforms.map(x => -x))
  // for each hue transformation, add the transformed hue to the possible_hues
  let possible_hues = possible_hue_transforms.map(x => Math.floor((h+x+360)%360))


  // hue transformations modulo 100
  let possible_saturation_transforms = [1,2,3]
  // let possible_saturation_transforms = [0]
  // add a negative version for each hue transformation
  possible_saturation_transforms = possible_saturation_transforms.concat(possible_saturation_transforms.map(x => -x))
  // for each saturation transformation, add the transformed saturation to the possible_saturations, min 0, max 100
  let possible_saturations = possible_saturation_transforms.map(x => Math.floor(Math.max(0, Math.min(100, s+x))))

  // brightness transformations modulo 100
  let possible_brightness_transforms = [1,2,3]
  // let possible_brightness_transforms = [0]
  // add a negative version for each brightness transformation
  possible_brightness_transforms = possible_brightness_transforms.concat(possible_brightness_transforms.map(x => -x))
  // for each brightness transformation, add the transformed brightness to the possible_brightnesss, min 0, max 100
  let possible_brightnesses = possible_brightness_transforms.map(x => Math.floor(Math.max(0, Math.min(100, b+x))))

  // for each possible hue, saturation, and brightness, create a color and add it to the possible_colors array
  possible_hues.forEach(hue => {
    possible_saturations.forEach(saturation => {
      possible_brightnesses.forEach(brightness => {
        possible_colors.push(color(get_hsb(hue, saturation, brightness)))
      })
    })
  })

  // return the possible colors
  return possible_colors
}


// this function will set the color of a given pixel
function set_pixel_color(x, y, col) {

  // set the pixel's color
  pixeldata[x][y].color = col
  // set the pixel's state to settled
  pixeldata[x][y].state = "settled"

  // update the pixels on the graphics object
  pg.set(x,y,col)

  // calculate the x and y coordinates of the pixel's neighbors using vectorized math
  let neighbors = [
    [(x-1+wth)%wth, y], 
    [(x+1+wth)%wth, y], 
    [x, (y-1+hgt)%hgt], 
    [x, (y+1+hgt)%hgt], 
    [(x+1+wth)%wth, (y+1+hgt)%hgt], 
    [(x-1+wth)%wth, (y-1+hgt)%hgt], 
    [(x+1+wth)%wth, (y-1+hgt)%hgt], 
    [(x-1+wth)%wth, (y+1+hgt)%hgt]
  ]
  // for each neighbor, check if it is in bounds
  for (let i = 0; i < neighbors.length; i++) {
    let neighbor = neighbors[i]
    if (pixeldata[neighbor[0]][neighbor[1]].state != "settled") {
      // if the neighbor is not settled, add to it's possible colors based on this pixels color
      pixeldata[neighbor[0]][neighbor[1]].colors.push(...get_possible_colors(col))
      // // drop duplicates
      // pixeldata[neighbor[0]][neighbor[1]].colors = [...new Set(pixeldata[neighbor[0]][neighbor[1]].colors)]
      // set the neighbor's state to waiting
      pixeldata[neighbor[0]][neighbor[1]].state = "waiting"
    }
  }


}


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

  wth = random_int(16,64)
  window.$fxhashFeatures["Pixel Width"] = wth
  // wth = 32
  hgt = Math.ceil(wth * (wh/ww))
  hc=-wth
  pg = createGraphics(wth, hgt);
  pg.colorMode(HSL)

  dd=displayDensity()
  let df = Math.ceil(dd * pd * 0.5)
  if(is_mobile){df/=3}
  pixelDensity(df);
  // blendMode(DIFFERENCE);
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)  

  // get a seed frequency, higher is fewer seeds

  let seed_freq = random_int(5, 100)
  // window.$fxhashFeatures["seed_freq"] = seed_freq

  locking_method = randomChoice(["Random Chance", "Consistent by Frame Count", "None"])
  window.$fxhashFeatures["Entropy Locking Method"] = locking_method


  // pixeldata
  // each pixel is an object with, x,y, state (unseen, waiting, settled), and possible colors (an array which will be updated later)
  // there are wth by hgt pixels
  // we will specifically select pixels based on their state at various times, so it needs to be effecient
  // we will also need to be able to select a random pixel from a given state

  // initialize pixeldata array with correct dimensions and all pixels in unseen state
  pixeldata = new Array(wth)
  for (let i = 0; i < wth; i++) {
    pixeldata[i] = new Array(hgt)
    for (let j = 0; j < hgt; j++) {
      pixeldata[i][j] = {x: i, y: j, state: "unseen", colors: [], color: color(get_hsb(calt,0,0))}
    }
  }

  console.table(window.$fxhashFeatures)
}


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
    set_pixel_color(random_pixel.x, random_pixel.y, color(get_hsb(random_int(0,359), random_int(75,100), random_int(75,100))))
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
  if (get_all_pixels_by_state("settled").length === wth * hgt) {noLoop();fxpreview();}

  // now update the graphics object with the new pixel values
  pg.updatePixels();
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
