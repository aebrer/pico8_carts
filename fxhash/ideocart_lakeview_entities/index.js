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
let pico_red_green = [0,255,77,255]
let pico_red_sec = [190,18,80,255]
let pico_red_green_sec = [19,180,80,255]
let lakewater = [80,19,180,255]
let lakesky = [30,80,230,255]


let night_pine = [6,18,5,255]
let granite_sunset = [255, 203, 164, 255]

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
pico_red_sec,
pico_red_green,
pico_red_green_sec,
lakesky,
lakewater,
night_pine,
granite_sunset
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
  wth = 128
  aa=random_num(177,179)
  aa=random_num(1,180)
  filename+="_aa_"+aa.toString()
  cdf = 0.7622705889632925
  cdf = 0.9

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
  fov = PI / 8;
  cameraZ = wth;
  noSmooth();
  pg.background(0);
  pg.strokeWeight(2)
  circ_diam = 100
  persp = 12
}

// hashes = "oo3R2a4RtW9LuXp6VtjJgTszc5BFf2fHyUF8YLHqk4z6SmnYpaK"

function draw() {
  if(paused){return}
  background(night_pine);
  pg.background(black);

  pg.camera(0, 0, 250, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov, 1.0, persp, 1500000);

  pg.stroke(pico_red)
  pg.rotate(aa);
  pg.rotateX(aa);
  pg.noFill()
  noFill()
  pg.ellipsoid(100,500,100,50);
  pg.fill(pastelgreen)
  pg.rotate(aa);
  pg.rotateX(aa);


  for (i=0;i<2;i++){
    pg.stroke(lakesky)
    pg.fill(lakewater)
    pg.rotate(aa);
    pg.rotateX(aa);
    pg.box(circ_diam)
  }
  
  for (i=0;i<10;i++){
    pg.stroke(black)
    pg.fill(black)
    pg.ellipsoid(50,50,30,2)
  }

  for (i=0;i<5;i++){

    pg.stroke(pico_red)
    pg.fill(randomChoice(colors))
    pg.rotate(0);
    pg.rotateX(15);
    pg.box(10/i+random_num(0.1,3))
  }

  if(windowWidth>windowHeight){

    image(pg, 0, (windowHeight-windowWidth)/2, ww, ww, 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww-(windowHeight-windowWidth)/2, ww, ww, 0, 0, wth, wth/3+(wth/3));
    pop()

    water_vfx(50,45*ww/112+(windowHeight-windowWidth)/2,ww)


  } else if (windowHeight>windowWidth) {

    image(pg, -(windowHeight-windowWidth)/2, 0, ww, ww, 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, -(windowHeight-windowWidth)/2, -ww, ww, ww, 0, 0, wth, wth/3+(wth/3));
    pop()

    water_vfx(50,45*ww/112,ww)

  } else {

    image(pg, 0, 0, ww, ww, 0, 0, wth, wth);
    splay(splay_n)
    push()
    scale(1,-1)
    image(pg, 0, -ww, ww, ww, 0, 0, 0, 2*wth/3);
    pop()
    water_vfx(50,45*ww/112,ww)

  }

  aa *= 0.99
  circ_diam*=cdf

 if (circ_diam<=8) {
  circ_diam=100
  // aa=random_num(1,180)
  aa=random_num(177,179)
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
    let x=random_int(0,ww)
    let y=random_int(0,ww)
    copy(x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),ww/32,ww/32, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),random_num(ww/32,ww/20),random_num(ww/32,ww/20))
  }
}


function water_vfx(n,y1,y2){
  for (let i=0;i<n;i++) {
    let y=random_int(y1,y2)
    copy(
      0,
      y,
      ww,
      1, 
      random_int(-5,5),
      y,
      ww,
      1
      )
  }
}
