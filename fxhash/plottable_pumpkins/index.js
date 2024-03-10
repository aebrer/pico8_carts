/*
Notes: 
This was made in a single evening as a fun halloween project, for a date night with my wife. Enjoy it for what it is lol.
Also, I made a lot of use of chatgpt to generate some of this code, because the results were too hilarious not to use. As
a result, the comments are mostly okay but sometimes flatout wrong. Sorry about that, but again, this is a fun lazy project,
not a serious one.


Controls:

s -> save an svg of the image
------------------

find my social links, projects, newsletter, roadmap, and more, at aebrer.xyz
or 
minted by tz1ZBMhTa7gxSpaeXoqyc6bTCrxEHfZYSpPt

license: CC0 -> go nuts; citations not required but definitely appreciated

*/


function random_num(a, b) {
  return a+(b-a)*$fx.rand()
}
function random_int(a, b) {
return Math.floor(random_num(a, b+1))
}

function randomChoice(arr) {
return arr[Math.floor(random_num(0,1) * arr.length)];
}



let aspect = 1.0
let ww;
let wh;
let px = 0;
let py = 0;
let col;
let pd=3;
let dd;
let mindist


let initial_run=true;

let mycan;

function setup() {

mindist = Math.min(windowWidth, windowHeight)

ww = mindist
wh = mindist

mycan = createCanvas(ww, wh, SVG);

// blendMode(DIFFERENCE);
noSmooth();

// since this is one layer, we will draw the pumpkin here, once
let pumpkinOrange = color(255, 102, 0);
let black = color(0, 0, 0);
let cut_color = color(255, 255, 255);
background(pumpkinOrange)
noFill();
stroke(black);
strokeWeight(10);
// draw the pumpkin outline, as an ellipse centered in the middle of the canvas
let pumpkin_w = ww*random_num(0.5,0.9)
let pumpkin_h = wh*0.6
let pumpkin_x = ww/2
let pumpkin_y = wh/random_num(1.7,2.0)
ellipse(pumpkin_x, pumpkin_y, pumpkin_w, pumpkin_h);


// // Define the number of lines (between 4 and 5 for example)
// let numLines = 4; // Adjust the range

// let spacing = pumpkin_w / (numLines - 1); // Calculate the spacing

// for (let i = -numLines / 2; i <= numLines / 2; i++) {
//   // Calculate `middleX` based on the current line index
//   let middleX;
//   let startX, endX;
//   let startY = pumpkin_y - pumpkin_h / 1.95;
//   let endY = pumpkin_y + pumpkin_h / 2;
  
//   if (i < 0) { // Draw from left to right
//     middleX = pumpkin_x - pumpkin_w / 1.5 - i * 5; // Push farther out from the center
//     startX = pumpkin_x - i * 15; // Adjust as needed
//     endX = pumpkin_x - i * 20; // Adjust as needed
//   } else { // Draw from right to left
//     middleX = pumpkin_x + pumpkin_w / 1.5 - i * 5; // Push farther out from the center
//     startX = pumpkin_x + i * 15; // Adjust as needed
//     endX = pumpkin_x + i * 20; // Adjust as needed
//     startY += 20; // Shift the top point to the right
//     endY -= 20; // Shift the bottom point to the right
//   }

//   // Define the other points for the curve
//   let middleY = pumpkin_y;

//   // Draw the curved line with the adjusted points
//   stroke(0); // Black outline
//   strokeWeight(3); // Line thickness
//   noFill(); // No fill for the curve
//   bezier(startX, startY, startX, startY + 50, middleX, middleY, endX, endY);
// }




pop()
// now we draw the stem, at the top of the pumpkin as calculated
let stem_w = pumpkin_w*0.05
let stem_h = pumpkin_h*0.2
let stem_x = pumpkin_x + 15 
let stem_y = pumpkin_y - pumpkin_h/2 - stem_h/2
rectMode(CENTER)
// rotate the stem a bit
rotate(random_num(0.05,0.15))

// set fill to pumpkin orange
fill(pumpkinOrange)
rect(stem_x, stem_y, stem_w, stem_h);

push()

pop()
// Eye shape parameters for the left eye
// x will be between pumpkin_x and pumpkin_x + pumpkin_w
// y will be between pumpkin_y and pumpkin_y + pumpkin_h
let x = pumpkin_x - (pumpkin_w / random_num(5,10)); // Adjust the x-coordinate for the left eye
let y = pumpkin_y - (pumpkin_h / random_num(3,7)); // Adjust the y-coordinate for the left eye
let radius = pumpkin_w / 20; // Adjust the size as needed
let numVertices = random_int(3, 6); // Randomly choose 3 to 6 vertices

// Draw the left eye shape with black fill and white outline
fill(black); // Black fill
stroke(cut_color); // White outline
strokeWeight(5); // Outline thickness

beginShape();
for (let i = 0; i < numVertices; i++) {
  let angle = TWO_PI / numVertices * i;
  let spikeLength = random_num(0.5, 1) * radius; // Randomize spike length
  let spikeX = x + cos(angle) * (radius + spikeLength);
  let spikeY = y + sin(angle) * (radius + spikeLength);
  vertex(spikeX, spikeY);
}
endShape(CLOSE);

// Eye shape parameters for the right eye
let rightEyeX = pumpkin_x + (pumpkin_w / random_num(3,7)); // Adjust the x-coordinate for the right eye
let rightEyeY = pumpkin_y - (pumpkin_h / random_num(3,7)); // Adjust the y-coordinate for the right eye

// Draw the right eye shape with black fill and white outline
fill(0); // Black fill
stroke(255); // White outline
strokeWeight(5); // Outline thickness

beginShape();
for (let i = 0; i < numVertices; i++) {
  let angle = TWO_PI / numVertices * i;
  let spikeLength = random_num(0.5, 1) * radius; // Randomize spike length
  let spikeX = rightEyeX + cos(angle) * (radius + spikeLength);
  let spikeY = rightEyeY + sin(angle) * (radius + spikeLength);
  vertex(spikeX, spikeY);
}
endShape(CLOSE);
push()

pop()
// Mouth shape parameters
let eye_dist = rightEyeX - x
let mouthX = pumpkin_x + random_num(-eye_dist/2,eye_dist/2); // Move the mouth to the right
let mouthY = pumpkin_y + pumpkin_h / 10; // Move the mouth up
let mouthWidth = pumpkin_w/random_num(3,5); // Make it more narrow
let mouthHeight = pumpkin_h/random_int(25,40); // Make it more vertically narrow
numVertices = random_int(8,16); // Number of vertices to create the mouth

// Draw the mouth shape with black fill and white outline
fill(black); // Black fill
stroke(cut_color); // White outline
strokeWeight(5); // Outline thickness

beginShape();
for (let i = 0; i <= numVertices; i++) { // Include one more vertex to close the loop
  // Calculate the angle for vertex positioning
  let angle = map(i, 0, numVertices, -PI/6, PI + PI/6); // Adjust angle range for a curved top
  
  // Adjust the radius for apparently no real reason
  let radius = mouthWidth / 2 + sin(angle) * mouthHeight;

  // Calculate vertex position
  let vertexX = mouthX + cos(angle) * radius;
  let vertexY = mouthY + sin(angle) * radius;

  vertex(vertexX, vertexY);
}
endShape(CLOSE);
push()

// // now we scale if needed
// mindist = Math.min(windowWidth, windowHeight)
// // render the graphics buffer to the display canvas
// image(mycan, 0, 0, ww, wh, 0, 0, mindist, mindist)

}

function draw() {}

// ux
function keyTyped() {
if (key === 's') {
  save("plottable_pumpkins.svg")
}
}
