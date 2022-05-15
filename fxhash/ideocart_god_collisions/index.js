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

function allEqual(arr) {
  return new Set(arr).size == 1;
}

//PGrahics object
let pg;
//Rotation angle
let aa = 0;
//field of vieew
let fov;
//loop counter
let lc = 0;
//Camera Z position
let cameraZ;
let sfs=[64,128,256,512]
let sf = 0.0
let cdf = 0.0
let ai = 0.0
let sch = 0
let seed_loop_rate = 0
let ww = 0
let splay_n = 0
window.$fxhashFeatures = {}

let redcol = [228,26,28,255]
let bluecol = [55,126,184,255]
let greencol = [77,175,74,255]
let pastelred = [251,180,174,255]
let pastelblue = [179,205,227,255]
let pastelgreen = [204,235,197,255]
let black = [0,0,0,255]
let white = [255,255,255,255]
let gold = [230,171,2,255]
let laven = [117,112,179,255]
let fusc = [240,2,127,255]
let navy = [56,108,176,255]
let peach = [253,192,134,255]
let pico_red = [255,0,77,255]
let pico_red_sec = [190,18,80,255]

let night_pine = [6,18,5,255]
let granite_sunset = [255, 203, 164, 255]

let colors = [
// redcol,
bluecol,
greencol,
// pastelred,
// pastelblue,
// pastelgreen,
black,
// white,
// gold,
// laven,
// fusc,
// navy,
// peach,
// pico_red,
// pico_red_sec
]
let bgcol = [0,0,0,255]

let wth = 0;
let circ_diam = 100;
let persp;
let filename = ""
let paused = false;
let color_buff = [0,0]

function c_get() {
 let c = randomChoice(colors)
 color_buff.push(c)
 color_buff.shift()
 while (allEqual(color_buff)) {
  c = randomChoice(colors)
  color_buff.push(c)
  color_buff.shift()
 }
 return(c)
}


function setup() {
  fxrand = sfc32(...hashes)
  bgcol=c_get()
  wth = 256
  aa=random_num(177,179)
  filename+="_aa_"+aa.toString()
  cdf = 0.7622705889632925
  cdf = 0.99


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
  pg.strokeWeight(2)
  circ_diam = 100
  persp = 40
}

// hashes = "oo3R2a4RtW9LuXp6VtjJgTszc5BFf2fHyUF8YLHqk4z6SmnYpaK"

function draw() {
  if(paused){return}
  // pg.noErase()
  background(night_pine);
  pg.background(black);

  

  pg.camera(0, 0, 50, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov*0.5, 1.0, persp, 1500000);

  pg.stroke(pico_red)
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.noFill()
  noFill()
  pg.ellipsoid(100,0,100,50);
  pg.fill(pico_red_sec)
  pg.rotate(aa);
  pg.rotateX(aa);



  for (i=0;i<8;i++){
    pg.stroke(night_pine)
    pg.fill(night_pine)
    pg.rotate(aa);
    pg.rotateX(aa);
    pg.box(circ_diam)
  }



  if(windowWidth>windowHeight){
    image(pg, 0, (windowHeight-windowWidth)/2, ww, ww/2+(ww/8), 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/8), ww, ww, 0, 0, wth, wth/3+(wth/3));
    pop()
  } else if (windowHeight>windowWidth) {
    image(pg, -(windowHeight-windowWidth)/2, 0, ww, ww/2+(ww/8), 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, -(windowHeight-windowWidth)/2, (-(windowHeight-windowWidth)/2)-ww - (windowWidth-windowHeight)/2 - (ww/8), ww, ww, 0, 0, wth, wth/3+(wth/3));
    pop()
  } else {
    image(pg, 0, 0, ww, ww/2+(ww/8), 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww-(ww/8), ww, ww, 0, 0, 0, 2*wth/3);
    pop()
  }

  // pg.erase()

  for (i=0;i<2;i++){
    pg.stroke(black)
    pg.fill(granite_sunset)
    pg.rotate(aa);
    pg.rotateX(aa);
    pg.box(circ_diam)
  }

  for (i=0;i<8;i++){
    pg.stroke(bluecol)
    pg.fill(pico_red_sec)
    pg.rotate(15);
    pg.rotateX(15);
    pg.box(12)
  }


  if(windowWidth>windowHeight){
    image(pg, 0, (windowHeight-windowWidth)/2, ww, ww/2+(ww/8), 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/8), ww, ww, 0, 0, wth, wth/3+(wth/3));
    pop()
  } else if (windowHeight>windowWidth) {
    image(pg, -(windowHeight-windowWidth)/2, 0, ww, ww/2+(ww/8), 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, -(windowHeight-windowWidth)/2, (-(windowHeight-windowWidth)/2)-ww - (windowWidth-windowHeight)/2 - (ww/8), ww, ww, 0, 0, wth, wth/3+(wth/3));
    pop()
  } else {
    image(pg, 0, 0, ww, ww/2+(ww/8), 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww-(ww/8), ww, ww, 0, 0, 0, 2*wth/3);
    pop()
  }

  aa *= 0.9
  circ_diam*=cdf

 if (circ_diam<=50) {
  circ_diam=139
  aa=random_num(1,180)
  // aa=random_num(177,179)
  filename+="_aa_"+aa.toString()
  lc+=1
 }

 if (lc>=1){
  paused=true
  fxpreview()
  // saveCanvas(filename.toString(),"png")
  // for (let i=0;i<10000;i++){
  //   console.log()
  // }
  // location.reload()
 }

}

// function mouseClicked() {
//   location.reload()
// }

function splay(n){
  // revisiting this later 
  for (let i=0;i<n;i++) {
    let x=random_int(ww*0.2,ww*0.8)
    let y=random_int(ww*0.2,ww*0.8)
    copy(x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),ww/32,ww/32, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),random_num(ww/32,ww/20),random_num(ww/32,ww/20))
  }
}
