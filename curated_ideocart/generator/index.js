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

// hashes = "oo3R2a4RtW9LuXp6VtjJgTszc5BFf2fHyUF8YLHqk4z6SmnYpaK"
fxrand = sfc32(...hashes)

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
// black,
white,
gold,
laven,
fusc,
navy,
// peach,
pico_red,
// pico_red_sec,
pico_red_green,
// pico_red_green_sec,
lakesky,
lakewater,
// night_pine,
// granite_sunset
]

let bright_cols = [
 redcol,
 bluecol,
 greencol,
 pastelgreen,
 pastelblue,
 pastelred,
 white,
 gold,
 granite_sunset,
]

let color_buff = [0,0,0]

function c_get(cols) {
 console.log(cols)
 let c = randomChoice(cols)
 color_buff.push(c)
 color_buff.shift()
 while (allEqual(color_buff)) {
  c = randomChoice(cols)
  color_buff.push(c)
  color_buff.shift()
 }
 return(c)
}


let skystroke = c_get(colors)
let skyfill = c_get(bright_cols)
let entfill = c_get(bright_cols)
let entstroke = c_get(colors)
let accent = c_get(colors)


let wth = 0;
let circ_diam = 100;
let persp;
let filename = ""
let paused = false;
let mycan;
let shred_count = 0;
let splay_n = 100
let shred_lim = 200;
let water_n = 32

let fin = false;

function preload() {
  tex = loadImage('textures/library_tv_4.png');
}

function setup() {
  
  fxrand = sfc32(...hashes)
  bgcol=c_get(colors)
  // wth = 128
  wth =  448
  hgt = 256
  aa=random_num(177,179)
  aa=random_num(1,180)
  filename+="_aa_"+aa.toString()

  ww=wth*2
  wh=hgt*2
  mycan = createCanvas(ww, wh);
  pg = createGraphics(wth, hgt, WEBGL);
  
  pg.pixelDensity(1);
  pixelDensity(5);
  blendMode(DIFFERENCE);
  fov = PI / 8;
  cameraZ = wth;
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)
  circ_diam = 1000
  persp = 1
}

function draw() {
  // seed looping
  // if(random_num(0,1)>0.9){fxrand = sfc32(...hashes)}



  if(fin){return}

  // overlay texture image
  image(tex,0,0, ww,wh, 0,0, wth*random_num(0.8,1.2),hgt*random_num(0.8,1.2))

  // stop render
  if(paused){
    if(shred_count<shred_lim){
      //splay effect
      for (let i=0;i<splay_n;i++) {
        let x=random_int(0,ww)
        let y=random_int(0,wh)
        let tx = random_int(0,wth)
        let ty = random_int(0,hgt)
        if(random_num(0,100)>100){
          image(tex, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),ww/32,wh/32, tx+random_num(-wth/32,wth/32),ty+random_num(-hgt/32,hgt/32),random_num(wth/32,wth/32),random_num(hgt/32,hgt/32))
        } else {
          image(this, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),ww/32,wh/32, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),random_num(ww/32,ww/32),random_num(wh/32,wh/32))
        }
      }

      // water vfx
      for (let i=0;i<water_n;i++) {
        let y=random_int(0,wh)
        image(this, 0, y, ww, wh/1024, random_int(-5,5), y, ww, wh/1024)
      }
      for (let i=0;i<water_n;i++) {
        let x=random_int(0,ww)
        image(this, x,0,ww/1024,wh, x,random_int(-5,5),ww/1024,wh)
      }
      shred_count+=1
    } else {
      
      // pg.strokeWeight(0.1)
      // for (i=1;i<15;i++){
      //   pg.stroke(entstroke)
      //   pg.fill(entfill)
      //   pg.rotate(0);
      //   pg.rotateX(15);
      //   pg.cone(1/i+random_int(1,3), 1/i+random_int(1,3))

      // }


      // draw entity again
      // image(pg, 0, 0, ww, ww, 0, 0, wth, wth);

      //shrink image
      let xs = ww/random_num(128,128)
      let ys = wh/random_num(128,128)
      image(this, 0,0,ww,ww, xs,ys,ww-xs*2,ww-ys*2);

      // // // mirror vfx
      // push()
      // scale(-1,1)
      // image(pg, 0,0,-ww,ww, 0,0,-wth,wth);
      // pop()

  // overlay texture image
  image(tex,0,0, ww,wh, 0,0, wth*random_num(0.8,1.2),hgt*random_num(0.8,1.2))


      fxpreview()
      // saveCanvas(filename.toString(),"png")
      // for (let i=0;i<10000;i++){
      //   console.log()
      // }
      // location.reload()
      fin=true
    } 
  }
  
  if (lc>=1){
    paused=true
    return
  }


  // background(night_pine);
  pg.background(bgcol);

  pg.camera(0, 0, 256, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov, 1.0, persp, 1500000);

  for (i=0;i<2;i++){
    pg.stroke(skystroke)
    pg.fill(skyfill)
    pg.rotate(aa);
    pg.rotateX(aa);
    pg.box(circ_diam)
    pg.cone(circ_diam,random_num(1,100))

  }
  
  for (i=0;i<10;i++){
    pg.stroke(accent)
    pg.fill(accent)
    pg.ellipsoid(50,50,30,2)
  }

  for (i=0;i<15;i++){
    pg.stroke(entstroke)
    pg.fill(entfill)
    pg.rotate(0);
    pg.rotateX(15);
    pg.cone(10/i+random_num(0.1,3),10/i+random_num(0.1,3))

  }

  image(tex, 0, 0, ww, wh, 0, 0, wth, hgt);
  
  // // mirror vfx
  push()
  scale(-1,1)
  image(pg, -ww,0,ww,wh, 0,0,wth,0);
  pop()

  aa *= 0.99
  circ_diam*=random_num(0.4,0.7)
  // circ_diam*=random_num(0.8,0.99)
  
  //shrink image
  let xs = ww/random_num(128,128)
  let ys = ww/random_num(128,128)
  image(this, 0,0,ww,ww, xs,ys,ww-xs*2,ww-ys*2);



 if (circ_diam<=8) {
  circ_diam=100
  aa=random_num(177,179)
  filename+="_aa_"+aa.toString()
  lc+=1
 }

 
}

