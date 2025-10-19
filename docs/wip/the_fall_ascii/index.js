/*
THE FALL (ASCII)

An ASCII art interpretation of THE FALL
Collaborative experiment between Drew Brereton and Claude

Controls:
p -> pause/unpause
s -> save (copies to clipboard)

Original concept by Drew Brereton (aebrer.xyz)
ASCII adaptation by Claude Code
*/

// Curated character palette - more visual, less boring letters
const CHARS = " ·∙•○●◘◙▪▫■□▬▀▄▌▐█░▒▓╎╵╷│─┼├┤┴┬┐┌┘└╏╹╻┃━╋┣┫┻┳┓┏┛┗╗╔╝╚╬╠╣╩╦║═╕╒╛╘╪╞╡╧╤╖╓╜╙╫╟╢╨╥▁▂▃▅▆▇▊▋▍▎▏▕▞▚♠♣♥♦☺☻♂♀♪♫☼►◄▲▼↑↓→←↕¿~°√∑";

// Simpler RNG using seed
class SeededRandom {
  constructor(seed = Date.now()) {
    this.seed = seed;
    this.m = 0x80000000; // 2^31
    this.a = 1103515245;
    this.c = 12345;
    this.state = seed;
  }

  next() {
    this.state = (this.a * this.state + this.c) % this.m;
    return this.state / (this.m - 1);
  }

  reset() {
    this.state = this.seed;
  }

  randInt(min, max) {
    return Math.floor(this.next() * (max - min + 1)) + min;
  }

  randFloat(min, max) {
    return min + (max - min) * this.next();
  }
}

// Global state
let rng;
let grid;
let width, height;
let entropy_lock_prob = 0.001; // 0.1% like the original
let rfac, gfac, bfac;
let dfacs = [];
let fc = 0;
let paused = false;
let bg_char_index = 0;
let baseFontSize = 10; // Base font size for the grid

// Performance tracking
let totalCalcTime = 0;
let totalRenderTime = 0;
let totalFrameTime = 0;

// Calculate grid size based on viewport aspect ratio
function calculateGridSize() {
  const aspectRatio = window.innerWidth / window.innerHeight;

  // Smaller grid for better performance
  height = 40;
  width = Math.floor(height * aspectRatio);
}

// Calculate scale to fill viewport
function calculateScale() {
  const canvas = document.querySelector('#canvas > span');

  // Set base font size
  canvas.style.fontSize = baseFontSize + 'px';
  canvas.style.lineHeight = '1';

  // Measure the natural size
  // Approximate character dimensions for monospace
  const charWidth = baseFontSize * 0.6;
  const charHeight = baseFontSize;

  const naturalWidth = width * charWidth;
  const naturalHeight = height * charHeight;

  // Calculate scale to fill viewport completely
  const scaleX = window.innerWidth / naturalWidth;
  const scaleY = window.innerHeight / naturalHeight;

  // Apply CSS transform (use both scales to fill completely)
  canvas.style.transform = `scale(${scaleX}, ${scaleY})`;
}

// Color to character mapping (RGB -> brightness -> char index)
function rgbToBrightness(r, g, b) {
  return (r * 0.299 + g * 0.587 + b * 0.114);
}

function brightnessToCharIndex(brightness) {
  // Map 0-255 brightness to 0-CHARS.length-1
  return Math.floor((brightness / 255) * (CHARS.length - 1));
}

function rgbToCharIndex(r, g, b) {
  const brightness = rgbToBrightness(r, g, b);
  return brightnessToCharIndex(brightness);
}

// Grid cell: stores RGB and char index
class Cell {
  constructor(r, g, b) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.cachedChar = null;
    this.cachedColor = null;
    this.updateChar();
  }

  updateChar() {
    this.charIndex = rgbToCharIndex(this.r, this.g, this.b);
    this.cachedChar = CHARS[this.charIndex];
    const ri = Math.floor(this.r);
    const gi = Math.floor(this.g);
    const bi = Math.floor(this.b);
    this.cachedColor = `rgb(${ri},${gi},${bi})`;
  }

  getChar() {
    return this.cachedChar;
  }

  getColorStyle() {
    return this.cachedColor;
  }
}

function getDfacs() {
  let xf2 = rng.randInt(0, 3);
  let xf1 = xf2 - rng.randInt(0, 3);
  let yf2 = rng.randInt(0, 3);
  let yf1 = yf2 - rng.randInt(0, 3);
  return [xf1, xf2, yf1, yf2];
}

function burnColor(r, g, b) {
  r = r * rng.randFloat(0.98, 1.00) - rfac;
  if (r < 0) r = 255 + r;

  g = g * rng.randFloat(0.98, 1.00) - gfac;
  if (g < 0) g = 255 + g;

  b = b * rng.randFloat(0.98, 1.00) - bfac;
  if (b < 0) b = 255 + b;

  return [r, g, b];
}

function rngReset() {
  if (rng.next() < entropy_lock_prob) {
    rng.reset();
  }
}

function setup() {
  // Calculate grid size based on viewport aspect ratio
  calculateGridSize();

  // Calculate scale to fill viewport
  calculateScale();

  // Initialize RNG with random seed
  const seed = Math.floor(Math.random() * 1000000);
  rng = new SeededRandom(seed);

  // Random background color
  const bg_r = rng.randInt(0, 255);
  const bg_g = rng.randInt(0, 255);
  const bg_b = rng.randInt(0, 255);
  bg_char_index = rgbToCharIndex(bg_r, bg_g, bg_b);

  // Color burn factors
  rfac = rng.randFloat(0.5, 5);
  gfac = rng.randFloat(0.5, 5);
  bfac = rng.randFloat(0.5, 5);

  // Movement factors
  dfacs = getDfacs();

  // Initialize grid
  grid = [];
  for (let y = 0; y < height; y++) {
    grid[y] = [];
    for (let x = 0; x < width; x++) {
      grid[y][x] = new Cell(bg_r, bg_g, bg_b);
    }
  }

  console.log('THE FALL (ASCII)');
  console.log('Seed:', seed);
  console.log('RGB factors:', rfac, gfac, bfac);
  console.log('Movement:', dfacs);
}

function draw() {
  if (paused) return;

  const drawStart = performance.now();

  rngReset();

  // Process pixels (much smaller iteration count for ASCII)
  const iterations = Math.floor(width * height * 0.1);
  const calcStart = performance.now();

  for (let i = 0; i < iterations; i++) {
    const x = rng.randInt(0, width - 1);
    const y = rng.randInt(0, height - 1);

    // Get neighbor position
    let x_new = x + rng.randInt(dfacs[0], dfacs[1]);
    if (x_new < 0) x_new = width - 1 + x_new;
    else if (x_new >= width) x_new = 0 + (x_new - width);

    let y_new = y + rng.randInt(dfacs[2], dfacs[3]);
    if (y_new < 0) y_new = height - 1 + y_new;
    else if (y_new >= height) y_new = 0 + (y_new - height);

    // Get color from neighbor
    const neighbor = grid[y_new][x_new];
    const [r, g, b] = burnColor(neighbor.r, neighbor.g, neighbor.b);

    // Update current cell
    grid[y][x].r = r;
    grid[y][x].g = g;
    grid[y][x].b = b;
    grid[y][x].updateChar();
  }

  const calcTime = performance.now() - calcStart;

  // Render to canvas
  const renderStart = performance.now();
  render();
  const renderTime = performance.now() - renderStart;

  const totalTime = performance.now() - drawStart;

  // Track cumulative time
  totalCalcTime += calcTime;
  totalRenderTime += renderTime;
  totalFrameTime += totalTime;

  // Performance logging disabled for smoother performance
  // if (fc % 60 === 0 && fc > 0) {
  //   const avgCalc = totalCalcTime / fc;
  //   const avgRender = totalRenderTime / fc;
  //   const avgFrame = totalFrameTime / fc;
  //   console.log(`Frame ${fc}: current calc=${calcTime.toFixed(1)}ms render=${renderTime.toFixed(1)}ms total=${totalTime.toFixed(1)}ms | avg calc=${avgCalc.toFixed(1)}ms render=${avgRender.toFixed(1)}ms total=${avgFrame.toFixed(1)}ms`);
  // }

  fc++;
}

// Pre-create DOM structure once
let renderInitialized = false;
let cellElements = [];
let canvasElement = null;

function initRender() {
  canvasElement = document.querySelector('#canvas > span');

  for (let y = 0; y < height; y++) {
    cellElements[y] = [];
    for (let x = 0; x < width; x++) {
      const span = document.createElement('span');
      span._cachedColor = null; // Cache color to avoid DOM reads
      span._cachedChar = null;  // Cache char too
      cellElements[y][x] = span;
      canvasElement.appendChild(span);
    }
    canvasElement.appendChild(document.createTextNode('\n'));
  }

  renderInitialized = true;
}

function render() {
  if (!renderInitialized) {
    initRender();
  }

  // Update cells - cache values in element to avoid DOM reads
  for (let y = 0; y < height; y++) {
    const rowElements = cellElements[y];
    const rowCells = grid[y];

    for (let x = 0; x < width; x++) {
      const cell = rowCells[x];
      const elem = rowElements[x];

      const newChar = cell.cachedChar;
      const newColor = cell.cachedColor;

      // Only update if changed (compare against cached JS values)
      if (elem._cachedChar !== newChar) {
        elem.textContent = newChar;
        elem._cachedChar = newChar;
      }
      if (elem._cachedColor !== newColor) {
        elem.style.color = newColor;
        elem._cachedColor = newColor;
      }
    }
  }
}

// Controls
document.addEventListener('keydown', (e) => {
  if (e.key === 'p') {
    paused = !paused;
    console.log(paused ? 'Paused' : 'Unpaused');
  }
  if (e.key === 's') {
    // Save to clipboard
    let output = '';
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        output += grid[y][x].getChar();
      }
      output += '\n';
    }
    navigator.clipboard.writeText(output).then(() => {
      console.log('Copied to clipboard!');
    });
  }
});

// Animation loop - max fps
function animate() {
  draw();
  requestAnimationFrame(animate);
}

// Start
setup();
animate();
