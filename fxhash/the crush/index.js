// Entropy-Locked Recursive Glitch Textures

/*
Controls:

F11 -> fullscreen mode (alternatively you should be able to do this from your browser menu)
s -> save a png of the image
1-8 -> set the pixel density and re-render (default is 2, higher means higher resolution final image; the preview image is generated with a value of 5, at 1080x1080px)
m -> toggle mobile/compatibility mode and re-render
w -> re-render with a white background
b -> re-render with a black background
t -> re-render with a transparent background
r -> re-render with a random background

------------------

Everything in this sketch is primarily driven by the use of uniform random noise. Entropy locking refers to a technique used to limit the sampling space of this random noise, artificially constraining it to a restricted set of still totally random values, in an unpredictable way. Specifically, these two lines are used for this in this sketch:

```
if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
```

Basically, if a certain random condition is met (3/1000 odds), the pseudorandom number generator will have its seed reset. The combination of the bog standard technique of controlling randomness via resetting the random seed, and the decision to do it at random, in a way controlled by the random seed, creates interesting recursive structures in the "entropy-space" of the sketch. Sometimes these will be extremely short loops, sometimes they remain unstable and never repeat. Sometimes, they get trapped in a loop, only for something to change in the drawing, reaching some mysterious threshold of difference that causes a new random number to be generated, breaking free from the temporary loop and becoming "more random" again. 

More recursion and self-reference is included throughout the sketch. A recursive "shredding" process is used to render small samples of the image back onto itself, either smaller or larger. A similar technique is used to create the horizontal or vertical "tears" that slice up the screen. These create feed-forward loops where pixel information stored on the screen is used to generate the next change to the image. When the pixel density is high enough (controllable via buttons 1-8 on the keyboard), immense and complicated structures arise in the minute details. An almost fractal-like pattern arises due to the intersection of the recursive nature of these feed-forward loops, and the recursive nature of the seed-loops created by entropy locking. Additionally, the textures are allowed to propagate in an interesting way, due to the use of transparent backgrounds.

Similarly, the color and positioning of the underlying pixelart is also controlled strictly through randomization and self-reference.

The image is rendered in the flat 2D engine, rather than WEBGL, because the weird pixel artifacts it creates (especially at ultra-high resolution) are very satisfying to me visually, even though I don't yet fully understand them.


I HIGHLY encourage you to increase the pixel density, and export an ultra-high render of your output, if you have a PC capable of it.



Thanks for reading :)
find my social links, projects, newsletter, roadmap, and more, at aebrer.xyz
or 
minted on Teia.art by tz1ZBMhTa7gxSpaeXoqyc6bTCrxEHfZYSpPt

license: CC0 -> go nuts; citations not required but definitely appreciated

*/


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


// will decide on mobile mode unless there is a pointer device with hover capability attached
let is_mobile = window.matchMedia("(any-hover: none)").matches

// hashes = "hriirieiririiiritiififiviviifj"
// if(hashes==="debug"){hashes=random_num(0,1000000)}
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
let dd;
let bgc;
let initial_run=true;
window.$fxhashFeatures = {}

let mycan;
let tx;

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

  if(isFxpreview){
    ww=1080
    wh=1080
    is_mobile=false
    pd=5
  } else {
    ww=windowWidth
    wh=windowHeight
  }

  mycan = createCanvas(ww, wh);

  wth = 512
  hgt = Math.ceil(wth * (wh/ww))
  hc=0
  pg = createGraphics(wth, hgt);
  pg.colorMode(HSL)

  dd=displayDensity()
  let df = Math.ceil(dd * pd * 0.5)
  if(is_mobile){df/=3}
  console.log([dd,pd,df,ww,wh,wth,hgt])
  pixelDensity(df);
  blendMode(BLEND);
  noSmooth();
  pg.background(bgc);
  
  if (nostroke) {
    pg.noStroke()
  } else {
    pg.stroke(bgc)
  }

  pg.strokeWeight(1)  

  console.table(window.$fxhashFeatures)
  loop();

}


function draw() {

  background(bgc[0],bgc[1],bgc[2],0)
  if(hc>hgt+10){

    blendMode(DIFFERENCE)

    if(shred_count<shred_lim){

      let x;
      let y;

      // load the pixelart image every frame
      image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)

      // entropy locking
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)


      if (recursive_shred){
        for (let i=0;i<splay_n;i++) {
          x=random_int(0,ww)
          y=random_int(0,wh)
          
          if (is_mobile) {
            // compatibility mode
            blend(Math.ceil(x+random_num(-ww/32,ww/32)),Math.ceil(y+random_num(-wh/32,wh/32)),Math.ceil(random_num(ww/32,ww/32)),Math.ceil(random_num(wh/32,wh/32)), Math.ceil(x+random_num(-ww/32,ww/32)),Math.ceil(y+random_num(-wh/32,wh/32)),Math.ceil(ww/32),Math.ceil(wh/32), DIFFERENCE)
          } else {
            // some sort of hack
            image(mycan, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),ww/32,wh/32, x+random_num(-ww/32,ww/32),y+random_num(-wh/32,wh/32),random_num(ww/32,ww/32),random_num(wh/32,wh/32))
          }
        }
      }

      // tearing effect
      if (hori_tear){
        for (let i=0;i<water_n;i++) {
          y=random_int(0,wh)

          if(is_mobile) {  //mobile device
            blend(0, y, ww, Math.ceil(max(wh/1024,dd)), random_int(-5,5), y, ww, Math.ceil(max(wh/1024,dd)),DIFFERENCE)
          } else {
            image(mycan, 0, y, ww, max(wh/1024,dd), random_int(-5,5), y, ww, max(wh/1024,dd))
          }
        }
      }
      if (vert_tear) {
        // // // water vfx
        for (let i=0;i<water_n;i++) {
          x=random_int(0,ww)

          if (is_mobile) {
            blend(x, 0, Math.ceil(max(ww/1024,dd)), wh, x, random_int(-5,5), Math.ceil(max(ww/1024,dd)), wh, DIFFERENCE)
          } else {
            image(mycan, x, 0, max(ww/1024,dd), wh, x, random_int(-5,5), max(ww/1024,dd), wh)
          }
        }
      }

      shred_count+=1
      tx="Rendering Shredding: " + Math.round(shred_count/(shred_lim)*100) + " % done"
      document.getElementById('log').innerText = tx;

      return
    } else {
      // done rendering fully
      tx=""
      document.getElementById('log').innerText = tx;
      fxpreview()
      noLoop()
      return
   }
  } else {

    // initial pixelart rendering 

    x=wth/2
    if (fullscreen) {x=wth/8;xfac=1}
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
    if(frameCount%10==0)image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)

    tx="Rendering Initial Pixelart: " + Math.round(hc/(hgt+10)*100) + " % done"
    document.getElementById('log').innerText = tx;

    // more layers of randomization, susceptible to entropy locking
    if (prim_col_dir) {
      c = [c[0],c[1]*random_num(1.0001,1.001),c[2]*random_num(1.0005,1.001),c[3]]
    } else {
      c = [c[0],c[1]*random_num(0.999,0.9999),c[2]*random_num(0.993,0.999),c[3]]
    }
    
    hc += random_int(1,7)
    return
  }

}


// ux
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
  } else if (key === "m") {
    is_mobile=!is_mobile
    initial_run=false
    setup()
  } 
}


// I now think it is a bad idea to do this... creates a bad experience on mobile
// function windowResized() {
//   setup()
// }
