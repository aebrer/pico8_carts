//thanks to anthonymg for sharing a p5.js template for pixel rendering with me :)
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

// thanks to 
//PGrahics object
let pg;
//Rotation angle
let aa = 0;
//field of vieew
let fov;
//Camera Z position
let cameraZ;
let sfs=[1,2,4,8,16]
let sf = 0.0
let cdf = 0.0
let ai = 0.0
let sch = 0
let seed_loop_rate = 0

// there are only six colors
let redcol = [228,26,28,255]
let bluecol = [55,126,184,255]
let greencol = [77,175,74,255]
let pastelred = [251,180,174,255]
let pastelblue = [179,205,227,255]
let pastelgreen = [204,235,197,255]

// // monochrome (1-bit color)
// redcol = [190,18,80]
// bluecol = [190,18,80]
// greencol = [190,18,80]
// pastelred = [190,18,80]
// pastelblue = [190,18,80]
// pastelgreen = [190,18,80]

// // 2-bits
redcol = [255, 0, 77]
bluecol = [255, 0, 77]
greencol = [255, 0, 77]
pastelred = [190,18,80]
pastelblue = [190,18,80]
pastelgreen = [190,18,80]


let wth = 0;
let circ_diam;

function setup() {
  sf = randomChoice(sfs)
  cdf = random_num(0.7,0.9)
  ai = random_num(0.1,3)
  sch = random_num(0.3,1)
  seed_loop_rate = random_num(0.05,1)
  console.log([sf,cdf,ai,sch])

  createCanvas(windowWidth, windowHeight);
  wth=max(windowHeight,windowWidth)/sf
  pg = createGraphics(wth, wth, WEBGL);
  blendMode(DIFFERENCE);
  fov = PI / 2;
  cameraZ = wth;
  noSmooth();
  pg.background(0);
  pg.strokeWeight(wth/64)
  circ_diam = 10000

}

function draw() {
  if(random_num(0,1)>seed_loop_rate){fxrand = sfc32(...hashes)}
  pg.background(0);
  pg.camera(aa, aa, cameraZ, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov, windowWidth/windowHeight, 0.01, 1500);
 
  pg.stroke(redcol)
  pg.fill(pastelred)
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(bluecol)
  pg.fill(pastelblue)
  pg.rotate(aa);
  pg.rotateX(aa);
  if (random_num(0,1)>sch) {
    pg.sphere(circ_diam);
  } else {
    pg.box(circ_diam)
  }
  pg.stroke(greencol)
  pg.fill(pastelgreen)
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  image(pg, 0, 0, windowWidth, windowHeight);

  aa += ai
  circ_diam*=cdf

 // if (circ_diam<=0.01) {
 //  draw=NaN
 // }

}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  circ_diam = 10000
}
