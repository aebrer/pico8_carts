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

let colors = [
redcol,
bluecol,
greencol,
pastelred,
pastelblue,
pastelgreen,
black,
white,
gold,
laven,
fusc,
navy,
peach,
pico_red,
pico_red_sec
]
let bgcol = [0,0,0,255]
let shapes = ["box", "sphere"]

// // monochrome (1-bit color)
// redcol = [190,18,80]
// bluecol = [190,18,80]
// greencol = [190,18,80]
// pastelred = [190,18,80]
// pastelblue = [190,18,80]
// pastelgreen = [190,18,80]

// if(fxrand()>1.0/69.0){
//   // // 2-bits
  // redcol = [255, 0, 77]
  // bluecol = [255, 0, 77]
  // greencol = [255, 0, 77]
  // pastelred = [190,18,80]
  // pastelblue = [190,18,80]
  // pastelgreen = [190,18,80]
// } else {
//   window.$fxhashFeatures["nice?"]="nice."
// }

let wth = 0;
let circ_diam = 1.39;
let persp;

let paused = false;
let color_buff = [0,0]
let shape_buff = [0,0,0]

function c_get() {
 let c = randomChoice(colors)
 color_buff.push(c)
 color_buff.shift()
 // console.log(color_buff)
 // console.log(allEqual(color_buff))
 while (allEqual(color_buff)) {
  c = randomChoice(colors)
  color_buff.push(c)
  color_buff.shift()
 }
 return(c)
}

function s_get() {
 let s = randomChoice(shapes)
 shape_buff.push(s)
 shape_buff.shift()
 // console.log(shape_buff)
 // console.log(allEqual(shape_buff))
 while (allEqual(shape_buff)) {
  s = randomChoice(shapes)
  shape_buff.push(s)
  shape_buff.shift()
 }
 return(s)
}

function setup() {
  fxrand = sfc32(...hashes)
  // wth = randomChoice(sfs)
  bgcol=c_get()
  // window.$fxhashFeatures["color subtraction"]=bgcol.toString()
  wth = 256
  aa = random_num(1,180)
  // aa = 130
  aa = 13.8
  cdf = random_num(0.7,0.85)
  cdf = 0.7622705889632925
  ai = random_num(0.3,0.6)
  ai = 0.3105786747531965
  seed_loop_rate = random_num(0.7,1)
  seed_loop_rate = 0.8702426065690816
  // window.$fxhashFeatures["Base Resolution"]=wth
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
  circ_diam = random_num(1.001,1.5)
  circ_diam = 1.39
  // persps = [4.25, 4.3, 4.35, 4.4, 4.45, 4.5, 4.55, 4.6, 5, 5.2, 5.8, 5.9]
  persp = 4.55
  window.$fxhashFeatures["frustum near plane length"]=persp

  // console.log([persp,bgcol, circ_diam,wth,cdf,ai, seed_loop_rate])
  console.table(window.$fxhashFeatures)

  // Array(6) [ (4) […], 1.39, 256, 0.7622705889632925, 0.3105786747531965, 0.8702426065690816 ]


}

// hashes = "01001010100101001011111111001010011100000000000101010100101001001111110100101"

function draw() {
  if(paused){return}
  // colorMode(RGB,0/circ_diam)
  if(random_num(0,1)>seed_loop_rate){fxrand = sfc32(...hashes)}
  // background(255);
  // pg.background(255);
  background(bgcol);
  pg.background(bgcol);

  pg.camera(0, 0, 50, 0, 0, 0, 0, 1, 0);
  // pg.perspective(fov*0.005, 1.0, 9, 1500000);
  pg.perspective(fov*0.5, 1.0, persp, 1500000);

  pg.stroke(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.noFill()
  noFill()
  // pg.ellipsoid(10,random_num(1.0,circ_diam),random_num(1.0,circ_diam));
  // pg.ellipsoid(random_num(1.0,circ_diam),10,random_num(1.0,circ_diam));
  // pg.ellipsoid(random_num(1.0,circ_diam),random_num(1.0,circ_diam),10);
  // if (lc<=1){
    // pg.camera(5, 0, 0, 0, 0, 0, 0, 1, 0);
    // pg.ellipsoid(0,random_num(1.0,circ_diam),10);
    // pg.camera(-5, 0, 0, 0, 0, 0, 0, 1, 0);
  // }

  // pg.camera(0,-5,500)
  pg.ellipsoid(100,0,100);
  // pg.camera(0,5,500)

  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.cone(circ_diam,5)



  
  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)


  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  pg.stroke(c_get())
  pg.fill(c_get())
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.box(circ_diam)

  // pg.stroke([0,0,0])
  // pg.fill([0,0,0])
  // pg.rotate(aa);
  // pg.rotateX(aa);
  // pg.box(circ_diam)


  if(windowWidth>windowHeight){
    image(pg, 0, (windowHeight-windowWidth)/2, ww, ww/2, 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    // image(pg, 0, 0, ww, ww, 0, 0, wth, wth/3+(wth/3));
    // image(pg, 0, 0, ww, ww, 0, 0, wth, wth/3+(wth/3));
    // image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/8), ww/8, ww/32, 0, 0, wth/8, wth/4+(wth/3));
    for(let i=8;i>=0;i--) {
      // image(pg, 0, -ww-(windowHeight-windowWidth)/2, ww, ww, 0, 0, wth, wth/3+(wth/3));
      // image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/4), ww, ww/3, 0, 0, wth, wth/3+(wth/3));
      image(pg, 0, -ww-(windowHeight-windowWidth)/2, ww, ww*i, 0, 0, wth, wth/4);
      // image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/8), ww, ww+300, 0, 0, wth, wth/3+(wth/3));
      // image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/8), ww, ww+500, 0, 0, wth, wth/3+(wth/3));
      // image(pg, 0, -ww-(windowHeight-windowWidth)/2-(ww/8), ww, ww+700, 0, 0, wth, wth/3+(wth/3));

    }
    // image(pg, 0, (ww/8), ww, ww/3, 0, 0, wth, wth/3+(wth/3));
    pop()
  } else if (windowHeight>windowWidth) {
    image(pg, -(windowHeight-windowWidth)/2, 0, ww, ww/2+(ww/4), 0, 0, wth, wth/2+wth/3);
    //(-(windowHeight-windowWidth)/2)-(windowWidth-windowHeight)/2
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, -(windowHeight-windowWidth)/2, (-(windowHeight-windowWidth)/2)-ww - (windowWidth-windowHeight)/2 - (ww/4), ww, ww/2, 0, 0, wth, wth/2+(wth/3));
    pop()
  } else {
    image(pg, 0, 0, ww, ww/2+(ww/4), 0, 0, wth, wth/2+(wth/3));
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww, ww, ww/2-(ww/4), 0, 0, wth, wth/2+(wth/3));
    pop()
  }

  aa *= 0.9
  circ_diam*=cdf

 if (circ_diam<=1) {
  // mirror()
  // fxpreview()
  // paused=true
  circ_diam=100
  aa=random_num(1,180)
  lc+=1
 }

 if (lc>=2){
  paused=true
  fxpreview()
 //  saveCanvas(aa.toString(),"png")
 //  for (let i=0;i<1000;i++){
 //    console.log()
 //  }
 //  location.reload()
 }

}

function mouseClicked() {
  location.reload()
}


function mirror(){
    if(windowWidth>windowHeight){
    push()
    scale(-1,1)
    image(pg, -ww, (windowHeight-windowWidth)/2, ww/2, ww, 0, 0, wth/2, wth);
    pop()
  } else if (windowHeight>windowWidth) {
    push()
    scale(-1,1)
    image(pg, -ww - (windowWidth-windowHeight)/2, 0, ww/2, ww, 0, 0, wth/2, wth);
    pop()
  } else {
    push()
    scale(-1,1)
    image(pg, -ww, 0, ww/2, ww, 0, 0, wth/2, wth);
    pop()
  }
}

function splay(n){
  // revisiting this later 
  for (let i=0;i<n;i++) {
    let x=random_int(ww*0.2,ww*0.8)
    let y=random_int(ww*0.2,ww*0.8)
    copy(x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),ww/32,ww/32, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),random_num(ww/32,ww/20),random_num(ww/32,ww/20))
  }
}
