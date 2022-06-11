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

let wth;
let hgt;
let hc;
let ww;
let wh;
let x;
let y;
let col;
let shred_count;
let shred_lim;
let splay_n;
let water_n;
let pd=2;
let need_preview;
let bgc;
let initial_run=true;
window.$fxhashFeatures = {}

//fxhash features
let recursive_shred;
let hori_tear;
let vert_tear;
let c;
let calt;
let prim_col_dir;
let sec_col_dir;
let fullscreen;
let xfac;
let noaa;
let nostroke;


function setup() {
  
  x=-16;
  y=-16;
  need_preview=true;
  window.$fxhashFeatures = {}

  recursive_shred=false;
  hori_tear=false;
  vert_tear=false;
  prim_col_dir=false;
  sec_col_dir=false;
  fullscreen=false;
  xfac=8.5
  noaa=true

  fxrand = sfc32(...hashes)
  
  shred_count=0;
  shred_lim=random_int(280,300);
  splay_n=random_int(10,15);
  water_n=random_int(10,15);

  while (!(recursive_shred || hori_tear || vert_tear)){
    recursive_shred = random_int(0,100)>35
    hori_tear = random_int(0,100)>35
    vert_tear = random_int(0,100)>60
  }

  window.$fxhashFeatures["Recursive Shredding"] = recursive_shred
  window.$fxhashFeatures["Horizontal Tear"] = hori_tear
  window.$fxhashFeatures["Vertical Tear"] = vert_tear

  // tweak the palette for a bit of variation
  c = [random_int(0,360),100,100,1]
  calt = randomChoice([0,10,15,25,45,90,120,180,225,270])
  window.$fxhashFeatures["Primary Hue"] = c[0]
  window.$fxhashFeatures["Hue Offset"] = calt

  // color direction
  if (random_num(0,1)>.5){
    prim_col_dir=true
    window.$fxhashFeatures["Primary Color Direction"] = "Increasing"
    c[1]=25
    c[2]=50
  } else {
    window.$fxhashFeatures["Primary Color Direction"] = "Decreasing"
  }

    // color direction
  if (random_num(0,1)>.5){
    sec_col_dir=true
    window.$fxhashFeatures["Secondary Color Direction"] = "Same"
  } else {
    window.$fxhashFeatures["Secondary Color Direction"] = "Different"
  }

  window.$fxhashFeatures["Awareness of the Edge"] = "Maintained"
  if (random_num(0,1)>.9) {
    fullscreen=true
    window.$fxhashFeatures["Awareness of the Edge"] = "Violated"
  }
  
  if (initial_run) {
      let rnum=random_int(1,100)
      if (rnum>97){
        bgc=[random_int(0,360),random_int(0,100),random_int(0,100),random_num(0,1)]
        window.$fxhashFeatures["Background"]="Random"
      } else if (rnum>94) {
        bgc=[0,100,100,1]
        window.$fxhashFeatures["Background"]="White"
      } else if (rnum>91) {
        bgc=[0,0,0,1]
        window.$fxhashFeatures["Background"]="Black"
      } else {
        bgc=[0,0,0,0]
        window.$fxhashFeatures["Background"]="Transparent"
      }
  }

  if (random_num(0,1)>0.3) {
    nostroke=true
  } else {
    nostroke=false
  }
  window.$fxhashFeatures["Edges"] = nostroke

  if(isFxpreview){
    ww=1920
    wh=1080
    mycan = createCanvas(ww, wh);
  } else {
    ww=windowWidth
    wh=windowHeight
    mycan = createCanvas(ww, wh);
  }

  wth = 512
  hgt = wth * (wh/ww)
  hc=0
  pg = createGraphics(wth, hgt);
  pg.colorMode(HSL)

  pg.pixelDensity(1);
  pixelDensity(pd);
  blendMode(BLEND);
  noSmooth();
  pg.background(bgc);
  
  if (nostroke) {
    pg.noStroke()
  } else {
    pg.stroke(bgc)
  }

  pg.strokeWeight(wth/256)  

  console.table(window.$fxhashFeatures)

}



function draw() {
  background(bgc[0],bgc[1],bgc[2],0)
  if(hc>hgt+10){

    blendMode(DIFFERENCE)

    if(shred_count<shred_lim){
      image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)

      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)


      if (recursive_shred){
        //splay effect
        for (let i=0;i<splay_n;i++) {
          x=random_int(0,ww)
          y=random_int(0,wh)
          image(this, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),ww/32,wh/32, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),random_num(ww/32,ww/32),random_num(wh/32,wh/32))
        }
      }
      // splay_n*=0.99

      // // // water vfx
      if (hori_tear){
        for (let i=0;i<water_n;i++) {
          let y=random_int(0,wh)
          image(this, 0, y, ww, wh/1024, random_int(-5,5), y, ww, wh/1024)
        }
      }
      if (vert_tear) {
        // // // water vfx
        for (let i=0;i<water_n;i++) {
          let x=random_int(0,ww)
          image(this, x, 0, ww/1024, wh, x, random_int(-5,5), ww/1024, wh)
        }
      }

      shred_count+=1

      return
    } else {
      if(need_preview){
        fxpreview()
        need_preview=false
      }
      return
   }
  }

  x=wth/2
  if (fullscreen) {x=0;xfac=1}
  for (i=0;i<=wth/xfac;i++) {


   let col;
   if(random_num(0,1)>0.5){
     if (sec_col_dir){
       col = randomChoice(
          [c, [(c[0]+calt)%360, c[1], c[2], c[3]]]
        )
      } else {
        col = randomChoice(
          [c, [(c[0]+calt)%360, 100-c[1], 100-c[2], c[3]]]
        )
      }
     pg.fill(col)
    }
   x+=random_int(-10,10)
   y=hc+random_int(-1,1)
   x%=wth
   
   pg.ellipse(x, y, random_int(-5,5), random_int(-5,5))
   pg.rect(x, y, random_int(-5,5), random_int(-5,5))
   
  }
  image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)
  if (prim_col_dir) {
    c = [c[0],c[1]*random_num(1.0001,1.001),c[2]*random_num(1.0005,1.001),c[3]]
  } else {
    c = [c[0],c[1]*random_num(0.999,0.9999),c[2]*random_num(0.993,0.999),c[3]]
  }
  

  hc += random_int(1,6)
  return
}

function keyTyped() {
  if (key === 's') {
    save(mycan, "ELSRRFFGTS_DTB_.png")
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
  } else if (key === "t") {
    initial_run=false
    bgc=[0,0,0,0]
    setup()
  } else if (key === "w") {
    initial_run=false
    bgc=[0,100,100,1]
    setup()
  } else if (key === "b") {
    bgc=[0,0,0,1]
    initial_run=false
    setup()
  } else if (key === "r") {
    bgc=[random_int(0,360),random_int(0,100),random_int(0,100),random_num(0,1)]
    console.log(bgc)
    initial_run=false
    setup()
  } 
}

function windowResized() {
  setup()
}