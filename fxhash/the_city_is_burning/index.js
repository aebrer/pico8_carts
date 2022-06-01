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
let ww;


let c1 = [0,0,0,255]
let c2 = [10,0,2,255]
let c3 = [20,0,5,255]
let c4 = [30,0,10,255]
let c5 = [50,0,15,255]
let c6 = [80,0,20,255]
let c7 = [128,0,38,255]
let c8 = [189,0,38,255]
let c9 = [227,26,28,255]
let c10 = [252,78,42,255]
let c11 = [253,141,60,255]
let c12 = [254,178,76,255]
let c13 = [254,217,118,255]
let c14 = [255,237,160,255]
let c15 = [255,255,204,255]
let c16 = [16,16,16,255]

colors = [
 c1,
 c2,
 c3,
 c4,
 c5,
 c6,
 c7,
 c8,
 c9,
 c10,
 c12,
 c13,
 c14,
 c15,
 c16
]

let wth;
let x=-16;
let y=-16;
let c=0;
let col;
let lc=0;

function setup() {
  
  fxrand = sfc32(...hashes)
  

  // tweak the palette for a bit of variation
  let cfac = random_num(0,360)
  for (i=0;i<15;i++) {
   let cfr = random_num(0.95,1.05)
   let cfg = random_num(0.95,1.05)
   let cfb = random_num(0.95,1.05)

   color_facs=[cfr,cfg,cfb]
   color_b = [random_num(-10,10),random_num(-10,10),random_num(-10,10)]

   for (j=0;j<3;j++) {
    colors[i][j] = max(colors[i][j]*color_facs[j]+color_b[j], 0)
   }
 }

console.table(colors)

  wth = 256
  if(isFxpreview){
    ww=2048
    mycan = createCanvas(2048, 2048);
  } else {
    ww=min(windowWidth, windowHeight)
    mycan = createCanvas(ww, ww);
  }

  pg = createGraphics(wth, wth, WEBGL);
  // pg.colorMode(HSL)
  pg.pixelDensity(1);
  // blendMode(DIFFERENCE);
  noSmooth();
  pg.background(0);
  pg.strokeWeight(1)  

  pg.camera(64, 128, 244, 128, 128, 0, 0,1,0);

}

function draw() {
  if(lc>3000){
    fxpreview()
    return
  }
  if(c>=13.8){pg.camera(128, 128, 244, 128, 128, 0, 0,1,0);}
  // if(c>14){fxrand = sfc32(...hashes)}
  for (i=0;i<30;i++) {
   col = colors[Math.floor(c)]
   pg.noStroke()
   pg.fill(col)
   x+=random_num(2,10)
   y+=random_num(0.05,0.1)
   c+=random_num(0,0.01)
   x%=350
   y%=272
   c%=15
   if(c<=12){pg.ellipse(x, y, random_num(-12*c/2,12*c/2), random_num(-12*c/2,12*c/2));}
   if(c>13){pg.rect(x, y, random_num(-12*c/8,12*c/4), random_num(-12*c/8,12*c/4));}
   image(pg, 0, 0, ww, ww, 0, 0, wth, wth);
   lc+=1
  }
}

