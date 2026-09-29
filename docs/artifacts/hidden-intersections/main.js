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


// hashes = [1827309,10928374,128374]
// fxrand = sfc32(...hashes)


let W, H;
let orient = "portrait"





let margin = (W+H)/6;
const steps = [2,4,8,16,32,64,128];

let colors = [];


let shred_count = 0
let shred_lim=0
let water_n=randomChoice([1,2,4,8,16]);
let wh = H
let ww = W
let mycan
let pd=2;
let dd;
let df;
let need_screenshot = false

function setup(){
    console.log( "fxhash: ", fxhash );
    

    // if don't need a screenshot, get a random canvas size
    if(!need_screenshot){
        orient = randomChoice( ["portrait", "portrait", "portrait", "landscape", "landscape", "square"] );
        console.log( 'orient', orient );
        switch( orient ){
            case "portrait":
                W = 2100;
                H = 2970;
                break;
            case "landscape":
                W = 2970;
                H = 2100;
                break;
            case "square":
                W = 2970;
                H = 2970;
                break;
        }
        ww=W 
        wh=H
    }

    windowResized();

    // seed
    fxrand = sfc32(...hashes)

    margin = (W+H)/randomChoice([2,4,8,16]);
    colors = [];
    colors.push(["4d0838","f3722c","f8961e","f9844a","f9c74f","90be6d","43aa8b","4d908e","577590","277da1"])
    colors.push(["001219","005f73","0a9396","94d2bd","e9d8a6","ee9b00","ca6702","bb3e03","ae2012","9b2226"])
    colors.push(["0c0f0a","ff206e","fbff12","41ead4","ffffff"])
    colors.push(["3a3335","d81e5b","f0544f","fdf0d5","c6d8d3"])
    colors.push(["25231f","796d66","8e6e53","c69c72","433e3f"])
    colors.push(["001219","005f73","0a9396","94d2bd","e9d8a6","ee9b00","ca6702","bb3e03","ae2012","9b2226"])
    colors.push(["2e3532","7e9181","c7cedb","a0aab2","94849b","faf33e","7b0828"])
    colors = randomChoice(colors)


    dd=displayDensity()
    console.log(dd)
    df = Math.ceil(dd * pd * 0.5)

    if(isFxpreview){
        df*=2
    }

    mycan = createCanvas(W, H);
    mycan.parent("main");

    shred_count=0;
    shred_lim=random_int(15,45);
    water_n=1;


    console.log([dd,pd,df,ww,wh])
    pixelDensity(df);
    background("#"+colors[0]);
    blendMode(BLEND);
    noSmooth();
    printGrid();

}

function draw(){
    noSmooth();
    blendMode(randomChoice([BLEND,BLEND,OVERLAY]))
    if(shred_count<shred_lim || shred_count==0){


      let x;
      let y;
      let shw;

      // entropy locking
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)
      if (random_int(1,1000)>997)fxrand=sfc32(...hashes)

        // tearing effect
        for (let i=0;i<water_n;i++) {
          y=fxrand()*wh
          shw=wh/randomChoice([8,16,64,32,128,256])
          image(mycan, 0, y, ww, shw, 0, y, ww, shw)
          
        }
      
        // // // water vfx
        for (let i=0;i<water_n;i++) {
          x=fxrand()*ww
          shw=ww/randomChoice([8,16,64,32,128,256])
          image(mycan, x, 0, shw, wh, x, 0, shw, wh)
        }

      shred_count+=1

      return
    } else {
      // done rendering fully
      fxpreview()
      if(need_screenshot){
        save(mycan, "genuary2023-4_protozoo_aebrer.png")
        need_screenshot=false
      }
      return
    }

}

function rad2deg( rad ){
    return rad * 180 / Math.PI;
}

function deg2rad( deg ){
    return deg * Math.PI / 180;
}

function printGrid(){
    rotate( deg2rad(90 - fxrand() * 180) );
    // Rows
    let lastX = -margin;
    while( lastX < W+margin ){
        let step = steps[ Math.floor(fxrand() * steps.length) ];
        let numReps = randomChoice([10,20,30,100,200]) / step; //2 + Math.floor( fxrand()*10 );
        let x;
        stroke( "#" + colors[ Math.floor(fxrand()*colors.length) ]);
        for(let j = 0; j < numReps; j++){
            x = lastX + j*step;
            if( x > W+margin){
                break;
            }
            line(x, -margin, x, H+margin);
        }
        lastX = x;
    }
    // Columns
    let lastY = -margin;
    inbound = true;
    while( lastY < H+margin ){
        let step = steps[ Math.floor(fxrand() * steps.length) ];
        let numReps = randomChoice([10,20,30,100,200]) / step; //2 + Math.floor( fxrand()*10 );
        let y;
        stroke( "#" + colors[ Math.floor(fxrand()*colors.length) ]);
        for(let j = 0; j < numReps; j++){
            y = lastY + j*step;
            if( y > H+margin){
                break;
            }
            line(-margin, y, W+margin, y);
        }
        lastY = y;
    }
}

// ux
function keyTyped() {
  if (key === 'w') {
    W=2560
    H=1440
    ww=W
    wh=H
    clear()
    shred_count=0
    need_screenshot=true
    setup()
  } else if (key === "s") {
    need_screenshot=true
  }
}

function windowResized() {  
  let scale = Math.min(
    window.innerWidth / W,    
    window.innerHeight / H
  );
  let $el = document.querySelector("#defaultCanvas0");
  $el.style.transform = "" + "scale(" + scale + ")";
};