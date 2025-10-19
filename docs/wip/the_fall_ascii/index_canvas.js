/*
THE FALL (ASCII) - Canvas Version

Canvas-based rendering for better performance
*/

// Character set
const CHARS = " ·∙•○●◘◙▪▫■□▬▀▄▌▐█░▒▓╎╵╷│─┼├┤┴┬┐┌┘└╏╹╻┃━╋┣┫┻┳┓┏┛┗╗╔╝╚╬╠╣╩╦║═╕╒╛╘╪╞╡╧╤╖╓╜╙╫╟╢╨╥▁▂▃▅▆▇▊▋▍▎▏▕▞▚♠♣♥♦☺☻♂♀♪♫☼►◄▲▼↑↓→←↕¿~°√∑";

// RNG
class SeededRandom {
  constructor(seed = Date.now()) {
    this.seed = seed;
    this.m = 0x80000000;
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
let width = 80;
let height = 40;
let entropy_lock_prob = 0.001;
let rfac, gfac, bfac;
let dfacs = [];
let fc = 0;
let paused = false;

// Canvas
let canvas, ctx;
let charWidth, charHeight;
let fontSize = 12;
let scale = 0; // 0 = auto

// Color/char mapping
function rgbToBrightness(r, g, b) {
  return (r * 0.299 + g * 0.587 + b * 0.114);
}

function brightnessToCharIndex(brightness) {
  return Math.floor((brightness / 255) * (CHARS.length - 1));
}

function rgbToCharIndex(r, g, b) {
  const brightness = rgbToBrightness(r, g, b);
  return brightnessToCharIndex(brightness);
}

// Grid cell
class Cell {
  constructor(r, g, b) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.updateChar();
  }

  updateChar() {
    this.charIndex = rgbToCharIndex(this.r, this.g, this.b);
  }

  getChar() {
    return CHARS[this.charIndex];
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

function calculateScale() {
  const gridWidth = charWidth * width;
  const gridHeight = charHeight * height;

  if (scale === 0) {
    // Auto scale to fit viewport
    const scaleX = window.innerWidth / gridWidth;
    const scaleY = window.innerHeight / gridHeight;
    return Math.min(scaleX, scaleY);
  }
  return scale;
}

function resizeCanvas() {
  const gridWidth = charWidth * width;
  const gridHeight = charHeight * height;
  const currentScale = calculateScale();

  canvas.style.width = (gridWidth * currentScale) + 'px';
  canvas.style.height = (gridHeight * currentScale) + 'px';
}

function setup() {
  canvas = document.querySelector('canvas');
  ctx = canvas.getContext('2d');

  // Measure character size
  ctx.font = `${fontSize}px "Courier New", monospace`;
  const metrics = ctx.measureText('M');
  charWidth = metrics.width;
  charHeight = fontSize;

  // Set canvas size
  canvas.width = charWidth * width;
  canvas.height = charHeight * height;

  // Setup rendering context
  ctx.font = `${fontSize}px "Courier New", monospace`;
  ctx.textBaseline = 'top';

  // Scale canvas
  resizeCanvas();

  // Initialize RNG
  const seed = Math.floor(Math.random() * 1000000);
  rng = new SeededRandom(seed);

  // Random background color
  const bg_r = rng.randInt(0, 255);
  const bg_g = rng.randInt(0, 255);
  const bg_b = rng.randInt(0, 255);

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

  console.log('THE FALL (ASCII) - Canvas');
  console.log('Grid:', width, 'x', height);
  console.log('Seed:', seed);
}

function draw() {
  if (paused) return;

  rngReset();

  // Process pixels
  const iterations = Math.floor(width * height * 0.1);

  for (let i = 0; i < iterations; i++) {
    const x = rng.randInt(0, width - 1);
    const y = rng.randInt(0, height - 1);

    let x_new = x + rng.randInt(dfacs[0], dfacs[1]);
    if (x_new < 0) x_new = width - 1 + x_new;
    else if (x_new >= width) x_new = 0 + (x_new - width);

    let y_new = y + rng.randInt(dfacs[2], dfacs[3]);
    if (y_new < 0) y_new = height - 1 + y_new;
    else if (y_new >= height) y_new = 0 + (y_new - height);

    const neighbor = grid[y_new][x_new];
    const [r, g, b] = burnColor(neighbor.r, neighbor.g, neighbor.b);

    grid[y][x].r = r;
    grid[y][x].g = g;
    grid[y][x].b = b;
    grid[y][x].updateChar();
  }

  // Render
  render();

  fc++;
}

// Reusable color cache to reduce string allocations
const colorCache = new Map();
function getColorString(r, g, b) {
  const key = (r << 16) | (g << 8) | b;
  let color = colorCache.get(key);
  if (!color) {
    color = `rgb(${r},${g},${b})`;
    colorCache.set(key, color);
    // Limit cache size to prevent memory leak
    if (colorCache.size > 10000) {
      const firstKey = colorCache.keys().next().value;
      colorCache.delete(firstKey);
    }
  }
  return color;
}

function render() {
  // Clear canvas
  ctx.fillStyle = '#000';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Draw all characters
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const cell = grid[y][x];
      const r = Math.floor(cell.r);
      const g = Math.floor(cell.g);
      const b = Math.floor(cell.b);

      ctx.fillStyle = getColorString(r, g, b);
      ctx.fillText(cell.getChar(), x * charWidth, y * charHeight);
    }
  }
}

// Controls
const infoEl = document.getElementById('info');

document.addEventListener('keyup', (e) => {
  if (e.key === 'i') {
    infoEl.classList.toggle('show');
  } else if (e.key === 'p') {
    paused = !paused;
  } else if (e.key === 's') {
    // Save canvas as image
    const link = document.createElement('a');
    link.download = 'the_fall_ascii.png';
    link.href = canvas.toDataURL();
    link.click();
  } else if (e.key === 'ArrowUp') {
    scale = scale === 0 ? 1 : scale + 0.5;
    resizeCanvas();
  } else if (e.key === 'ArrowDown') {
    scale = Math.max(0.5, scale === 0 ? calculateScale() - 0.5 : scale - 0.5);
    resizeCanvas();
  } else if (e.key === '0') {
    scale = 0; // Auto
    resizeCanvas();
  }
});

// Animation loop with FPS cap
let lastFrameTime = 0;
const targetFPS = 60; // Cap at 60fps for stability
const targetFrameTime = 1000 / targetFPS;

function animate(currentTime) {
  const elapsed = currentTime - lastFrameTime;

  if (elapsed >= targetFrameTime) {
    draw();
    lastFrameTime = currentTime - (elapsed % targetFrameTime);
  }

  requestAnimationFrame(animate);
}

// Start
setup();
requestAnimationFrame(animate);
