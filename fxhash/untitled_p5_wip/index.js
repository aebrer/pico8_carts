// untitled WIP

/*
Controls:

F11 -> fullscreen mode (alternatively you should be able to do this from your browser menu)
s -> save a png of the image
1-8 -> set the pixel density and re-render (default is 2, higher means higher resolution final image; the preview image is generated with a value of 5, at 1080x1080px)
m -> toggle mobile/compatibility mode and re-render

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
let pd=5;
let dd;
let bgc;
let initial_run=true;
window.$fxhashFeatures = {}

let mycan;
let tx;

//fxhash features
let c;
let calt;
let prim_col_dir;
let sec_col_dir;
let noaa;
let nostroke;
let loop_count=0;

function setup() {
  
  x=-16;
  y=-16;
  need_preview=true;
  window.$fxhashFeatures = {}

  prim_col_dir=false;
  sec_col_dir=false;
  noaa=true

  fxrand = sfc32(...hashes)
  

  // tweak the palette for a bit of variation
  c = [random_int(0,360),random_num(25,100),100,1]
  calt = randomChoice([0,10,15,25,45,90,120,180,225,270])

  // color direction
  if (random_num(0,1)>.5){
    prim_col_dir=true
    // c[1]=25
    // c[2]=50
  }

    // color direction
  if (random_num(0,1)>.5){
    sec_col_dir=true
    window.$fxhashFeatures["Secondary Color Direction"] = "Same"
  } else {
    window.$fxhashFeatures["Secondary Color Direction"] = "Different"
  }
  
  if (initial_run) {

    bgc=[random_int(0,360),random_int(0,100),random_int(0,100),random_num(0,1)]
    //bgc=[0,0,0,1]
      
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

  wth = 256
  hgt = Math.ceil(wth * (wh/ww))
  hc=-wth
  pg = createGraphics(wth, hgt, WEBGL);
  pg.colorMode(HSL)

  dd=displayDensity()
  let df = Math.ceil(dd * pd * 0.5)
  //if(is_mobile){df/=3}
  console.log([dd,pd,df,ww,wh,wth,hgt])
  pixelDensity(df);
  blendMode(DIFFERENCE);
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
  
  // entropy locking
  // if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
  // if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
  if(frameCount%5==0){fxrand=sfc32(...hashes);pg.clear()}


  if(hc>hgt+10){
    hc = -wth
    loop_count += 1

    fxhash = "oo" + Array(49).fill(0).map(_=>alphabet[(Math.random()*alphabet.length)|0]).join('')
    b58dec = str=>[...str].reduce((p,c)=>p*alphabet.length+alphabet.indexOf(c)|0, 0)
    fxhashTrunc = fxhash.slice(2)
    regex = new RegExp(".{" + ((fxhashTrunc.length/4)|0) + "}", 'g')
    hashes = fxhashTrunc.match(regex).map(h => b58dec(h))
    console.log(hashes)
    // blendMode(randomChoice([DIFFERENCE, BLEND]))
    prim_col_dir = !prim_col_dir
    sec_col_dir = !sec_col_dir
  }

  if(loop_count>15){fxpreview()}

  // initial pixelart rendering 

  x=0
  for (i=-wth-(wth/10);i<=2*wth+(wth+10);i++) {

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
     pg.stroke(col)
    }
   x+=random_int(-10,10)
   y=hc+random_int(-1,1)
   x%=wth
   
   // pg.ellipse(x, y, random_int(-5,5), random_int(-5,5))
   pg.rect(x, y, random_int(-1,1)*randomChoice([0,0.5,1,1,2,5]), random_int(-5,5)*randomChoice([0,0.5,1,1,2,5]))
   pg.rect(x, y, random_int(-5,5)*randomChoice([0,0.5,1,1,2,5]), random_int(-1,1)*randomChoice([0,0.5,1,1,2,5]))

   
  }
  image(pg, 0, 0, ww, wh, 0, 0, wth, hgt)

  // tx="Rendering Initial Pixelart: " + Math.round(hc/(hgt+10)*100) + " % done"
  // document.getElementById('log').innerText = tx;

  // more layers of randomization, susceptible to entropy locking
  if (prim_col_dir) {
    c = [c[0],c[1]*random_num(1.0001,1.001),c[2]*random_num(1.0005,1.001),c[3]]
  } else {
    c = [c[0],c[1]*random_num(0.999,0.9999),c[2]*random_num(0.995,0.999),c[3]]
  }
  
  hc += random_int(1,7)
  return
}



// ux
function keyTyped() {
  if (key === 's') {
    save(mycan, "export_.png")
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
  } 
}


// I now think it is a bad idea to do this... creates a bad experience on mobile
// function windowResized() {
//   setup()
// }
