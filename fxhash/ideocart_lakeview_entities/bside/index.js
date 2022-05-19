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
let splay_n = 5000
let water_n = 15
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
// redcol,
// bluecol,
// greencol,
// pastelred,
// pastelblue,
// pastelgreen,
// black,
// white,
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
  // wth = 128
  wth = 256
  aa=random_num(177,179)
  aa=random_num(1,180)
  filename+="_aa_"+aa.toString()
  cdf = 0.7622705889632925
  cdf = 0.9

  if(isFxpreview){
    ww=2048
    let mycan = createCanvas(2048, 2048);
  } else {
    ww=min(windowWidth, windowHeight)
    let mycan = createCanvas(ww, ww);
  }
  
  pg = createGraphics(wth, wth, WEBGL);
  pg.pixelDensity(1);
  blendMode(DIFFERENCE);
  fov = PI / 8;
  cameraZ = wth;
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)
  circ_diam = 1000
  persp = 1
}

// hashes = "oo3R2a4RtW9LuXp6VtjJgTszc5BFf2fHyUF8YLHqk4z6SmnYpaK"

function draw() {
  // seed looping
  // fxrand = sfc32(...hashes)

  // stop render
  if(paused){

    // if (random_num(0,1)>0.99){
    //   fxrand = sfc32(...hashes)
    // }
    //     //splay effect
    // for (let i=0;i<splay_n;i++) {
    //   // let x=random_int(ww*0.4,ww*0.6)
    //   let y=random_int(0,ww)
    //   let x=random_int(ww*0.15,ww*0.65)

    //   image(pg, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32)+(windowHeight-windowWidth)/2,ww/32,ww/32, x*(wth/ww)+random_num(-wth/32,wth/32),(y+(windowHeight-windowWidth)/2)*(wth/ww)+random_num(-wth/32,wth/32),random_num(wth/32,wth/20),random_num(wth/32,wth/20))
    // }

    return
  }
  
  if (lc>=1){
    paused=true

    // square
    //splay effect
    for (let i=0;i<splay_n;i++) {
      let x=random_int(0,ww)
      let y=random_int(0,ww)
      image(this, x+random_num(-ww/32,ww/32),max(y+random_num(-ww/32,ww/32),ww/2),ww/32,ww/32, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),random_num(ww/32,ww/32),random_num(ww/32,ww/32))
    }
    

    // water vfx
    for (let i=0;i<water_n;i++) {
      let y=random_int(0,ww)
      let x=random_int(0,ww)

      image(pg, 0, y, ww, 1, 0*(wth/ww)+random_int(-5,5), y*(wth/ww), wth, 1)
    }
    
    push()
    scale(1,-1)
    // image(this, 0, 45*ww/112, ww, -ww);
    image(this, 0, 22*ww/112, ww, -ww);

    pop()

    fxpreview()
    // saveCanvas(filename.toString(),"png")
    // for (let i=0;i<10000;i++){
    //   console.log()
    // }
    // location.reload()
    return
  }


  background(night_pine);
  pg.background(black);

  pg.camera(0, 0, 500, 0, 0, 0, 0, 1, 0);
  pg.perspective(fov, 1.0, persp, 1500000);

  for (i=0;i<2;i++){
    // pg.stroke(pico_red_sec)
    // pg.fill(pico_red)
    pg.stroke(randomChoice(colors))
    pg.fill(pico_red)
    pg.rotate(aa);
    pg.rotateX(aa);
    pg.box(circ_diam)
    pg.cone(circ_diam,random_num(1,100))

  }
  
  for (i=0;i<10;i++){
    pg.stroke(black)
    pg.fill(black)
    pg.ellipsoid(50,50,30,2)
  }

  for (i=0;i<15;i++){
    pg.stroke(pico_red)
    pg.fill(randomChoice(colors))
    pg.rotate(0);
    pg.rotateX(15);
    pg.cone(10/i+random_num(0.1,3),10/i+random_num(0.1,3))
  }



  image(pg, 0, 0, ww, ww, 0, 0, wth, wth);

  // //splay effect
  // for (let i=0;i<splay_n;i++) {
  //   let x=random_int(0,ww)
  //   let y=random_int(0,ww)
  //   image(pg, x+random_num(-ww/32,ww/32),y+random_num(-ww/32,ww/32),ww/32,ww/32, x*(wth/ww)+random_num(-wth/32,wth/32),y*(wth/ww)+random_num(-wth/32,wth/32),random_num(wth/32,wth/20),random_num(wth/32,wth/20))
  // }
  
  // mirror vfx
  push()
  scale(1,-1)
  image(pg, 0, -ww, ww, ww, 0, 0, 0, wth);
  pop()

  // water vfx
  for (let i=0;i<water_n;i++) {
    // let y=random_int(45*ww/112,ww)
    let y=random_int(ww/2,ww)

    let x=random_int(0,ww)

    image(pg, 0, y, ww, 1, 0*(wth/ww)+random_int(-5,5), y*(wth/ww), wth, 1)
  }
  // // drip water vfx
  // for (let i=0;i<water_n;i++) {
  //   let x=random_int(0,ww)
  //   image(pg, x, 0, 1, 45*ww/112, x*(wth/ww), random_int(-5,5), 1, wth)
  // }
  



  aa *= 0.99
  // circ_diam*=cdf
  // circ_diam*=random_num(0.7,0.999)
  circ_diam*=random_num(0.3,0.6)


 if (circ_diam<=8) {
  circ_diam=1000
  // aa=random_num(1,180)
  aa=random_num(177,179)
  filename+="_aa_"+aa.toString()
  lc+=1
 }

 
}

// function mouseClicked() {
//   location.reload()
// }

