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
let ww;
let wh;
let x=-16;
let y=-16;
let col;
let lc=0;
let c;
let num_col=16;
let shred_count;
let shred_lim;
let splay_n;
let water_n;

function setup() {
  
  fxrand = sfc32(...hashes)
  
  shred_count=0;
  shred_lim=random_int(280,300);
  splay_n=random_int(10,15);
  water_n=random_int(10,15);


  // tweak the palette for a bit of variation
  c = [random_int(0,360),100,100,1]


  wth = 512
  hgt = 0.5625 * wth
  if(isFxpreview){
    ww=1920
    wh=1080
    mycan = createCanvas(ww, wh);
  } else {
    ww=windowWidth
    wh=0.5625*ww
    mycan = createCanvas(ww, wh);
  }

  pg = createGraphics(wth, hgt, WEBGL);
  pg.colorMode(HSL)

  pg.pixelDensity(1);
  pixelDensity(1);
  // blendMode(DIFFERENCE);
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)  

  pg.camera(wth/2, hgt/2, wth/2, wth/2, hgt/2, 0, 0,1,0);

}

let hc=-10
function draw() {
  if(hc>hgt+10){

    blendMode(DIFFERENCE)

    if(shred_count<shred_lim){
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)

      //splay effect
      for (let i=0;i<splay_n;i++) {
        x=random_int(0,ww)
        y=random_int(0,wh)
        image(this, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),ww/32,wh/32, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),random_num(ww/32,ww/32),random_num(wh/32,wh/32))
      }
      // splay_n*=0.99

      // // water vfx
      for (let i=0;i<water_n;i++) {
        let y=random_int(0,ww)
        image(this, 0, y, ww, ww/1024, random_int(-5,5), y, ww, ww/1024)
      }
      // for (let i=0;i<water_n/23;i++) {
      //   let x=random_int(0,ww)
      //   image(this, x,0,ww/1024,ww, x,random_int(-5,5),ww/1024,ww)
      // }
      shred_count+=1
    } else {
      fxpreview()
      return
   }
  }
  x=-wth/10
  for (i=0;i<=wth/8.5;i++) {
   pg.noStroke()
   pg.fill(c)
   x+=random_num(2,10)
   y=hc+random_num(0.05,0.1)
   x%=wth+wth/10
   
   pg.ellipse(x, y, random_num(1,5), random_num(1,5))
   pg.rect(x, y, random_num(1,5), random_num(1,5))
   

  }
  image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)
  c = [c[0],c[1]*random_num(0.99,0.999),c[2]*random_num(0.99,0.999),c[3]]

  hc += random_num(1,2)
}

