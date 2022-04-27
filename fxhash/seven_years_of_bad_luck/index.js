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

//PGrahics object
let pg;
//Rotation angle
let aa = 0;
//field of vieew
let fov;
//Camera Z position
let cameraZ;
let sfs=[64,128,256,512]
let sf = 0.0
let cdf = 0.0
let ai = 0.0
let sch = 0
let seed_loop_rate = 0
let ww = 0
window.$fxhashFeatures = {}

// there are only six colors
let redcol = [228,26,28,255]
let bluecol = [55,126,184,255]
let greencol = [77,175,74,255]
let pastelred = [251,180,174,255]
let pastelblue = [179,205,227,255]
let pastelgreen = [204,235,197,255]

let wth = 0;
let circ_diam;

let paused = false;

function setup() {
  fxrand = sfc32(...hashes)
  wth = 512
  cdf = random_num(0.6,0.92)
  ai = random_num(0.1,3)
  sch = random_num(0.3,1)
  seed_loop_rate = random_num(0.05,1)
  seed_loop_rate=0.5
  // console.log([wth,cdf,ai,sch])
  window.$fxhashFeatures["Base Resolution"]=wth
  // console.table(window.$fxhashFeatures)

  if(isFxpreview){
    ww=2048
    createCanvas(2048, 2048);
  } else {
    ww=max(windowWidth, windowHeight)
    createCanvas(windowWidth, windowHeight);
  }
  
  pg = createGraphics(wth, wth, WEBGL);
  pg.pixelDensity(1);
  blendMode(DIFFERENCE);
  fov = PI / 2;
  cameraZ = wth;
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)
  circ_diam = 10000

}

function draw() {
  if(paused){return}
  blendMode(DIFFERENCE)
  if(random_num(0,1)>seed_loop_rate){fxrand = sfc32(...hashes)}
  background(0);
  pg.background(0);
  pg.camera(0, 0, cameraZ, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov, 1.0, 0.01, 1500);
 
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

  if(windowWidth>windowHeight){
    image(pg, 0, (windowHeight-windowWidth)/2, ww, ww, 0, 0, wth, wth);
  } else if (windowHeight>windowWidth) {
    image(pg, (windowWidth-windowHeight)/2, 0, ww, ww, 0, 0, wth, wth);
  } else {
    image(pg, 0, 0, ww, ww, 0, 0, wth, wth);
  }

  aa += ai
  circ_diam*=cdf

 if (circ_diam<=0.01) {
  finish()
  fxpreview()
  paused=true
 }

}

function finish() {

  //mirror
  blendMode(REPLACE)
  pg.fill([255,255,255,255])
  pg.rect(wth/2,0,wth/2,wth)
  blendMode(DIFFERENCE)
  if(windowWidth>windowHeight){
    image(pg, 0, (windowHeight-windowWidth)/2, ww, ww, 0, 0, wth, wth);
  } else if (windowHeight>windowWidth) {
    image(pg, (windowWidth-windowHeight)/2, 0, ww, ww, 0, 0, wth, wth);
  } else {
    image(pg, 0, 0, ww, ww, 0, 0, wth, wth);
  }
  copy(0,0,Math.floor(windowWidth/2),Math.floor(windowHeight), Math.floor(windowWidth/2), 0, Math.floor(windowWidth/2), windowHeight)

}
