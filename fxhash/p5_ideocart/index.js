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

let colors = [redcol,bluecol,greencol,pastelred,pastelblue,pastelgreen,[0,0,0,255]]

// // monochrome (1-bit color)
// redcol = [190,18,80]
// bluecol = [190,18,80]
// greencol = [190,18,80]
// pastelred = [190,18,80]
// pastelblue = [190,18,80]
// pastelgreen = [190,18,80]

// if(fxrand()>1.0/69.0){
//   // // 2-bits
//   redcol = [255, 0, 77]
//   bluecol = [255, 0, 77]
//   greencol = [255, 0, 77]
//   pastelred = [190,18,80]
//   pastelblue = [190,18,80]
//   pastelgreen = [190,18,80]
// } else {
//   window.$fxhashFeatures["nice?"]="nice."
// }

let wth = 0;
let circ_diam;

let paused = false;

function setup() {
  fxrand = sfc32(...hashes)
  // wth = randomChoice(sfs)
  wth = 512
  cdf = random_num(0.7,0.92)
  ai = random_num(0.3,0.9)
  sch = random_num(0.7,0.99)
  seed_loop_rate = random_num(0.7,1)
  console.log([wth,cdf,ai,sch, seed_loop_rate])
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
  circ_diam = 2

}

function draw() {
  if(paused){return}
  // colorMode(RGB,0/circ_diam)
  if(random_num(0,1)>seed_loop_rate){fxrand = sfc32(...hashes)}
  background(0);
  pg.background(0);
  pg.camera(aa, 0, cameraZ, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov*0.005, 1.0, 9, 1500000);
 
  pg.stroke(randomChoice(colors))
  pg.fill(randomChoice(colors))
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(randomChoice(colors))
  pg.fill(randomChoice(colors))
  pg.rotate(aa);
  pg.rotateX(aa);
  
  if (random_num(0,1)>sch && circ_diam<=1.7) {
    pg.sphere(circ_diam);
  } else {
    pg.box(circ_diam)
  }

  pg.stroke(randomChoice(colors))
  pg.fill(randomChoice(colors))
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke([0,0,0])
  pg.fill([0,0,0])
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)


  if(windowWidth>windowHeight){
    image(pg, 0, (windowHeight-windowWidth)/2, ww/2, ww, 0, 0, wth/2, wth);
    push()
    scale(-1,1)
    image(pg, -ww, (windowHeight-windowWidth)/2, ww/2, ww, 0, 0, wth/2, wth);
    pop()
  } else if (windowHeight>windowWidth) {
    image(pg, (windowWidth-windowHeight)/2, 0, ww/2, ww, 0, 0, wth/2, wth);
    push()
    scale(-1,1)
    image(pg, -ww - (windowWidth-windowHeight)/2, 0, ww/2, ww, 0, 0, wth/2, wth);
    pop()
  } else {
    image(pg, 0, 0, ww/2, ww, 0, 0, wth/2, wth);
    // for (let i=0;i<100;i++) {
    //   let x=random_int(ww*0.2,ww*0.8)
    //   let y=random_int(ww*0.2,ww*0.8)
    //   copy(pg, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),ww/32,ww/32, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),random_num(ww/32,ww/20),random_num(ww/32,ww/20))
    // }
    push()
    scale(-1,1)
    image(pg, -ww, 0, ww/2, ww, 0, 0, wth/2, wth);
    pop()
  }

  aa += ai
  circ_diam*=cdf

 if (circ_diam<=1) {
  fxpreview()
  paused=true
 }

}