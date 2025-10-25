/*
the seed marche - EditART Version
(Working title: "just a bite")
Based on CORAL HUNTING engine

Minimal unit derivative: 420x420 → 8x8 characters
Reveals atomic behavior: character vocabulary generation + burn dynamics

Play on "marsh" (returning to coral theme), "march" (seed navigation),
and "marché" (market - exploring/trading seeds)

Features:
- Seed-specific character vocabularies via entropy-locked walk
- Deterministic seed march for infinite exploration
- WebGL-accelerated rendering with viewport tiling
*/

// Master character set - with bidirectional gradients for visual symmetry
const MASTER_CHARS = " ·∙•○●○•∙· ◘◙▪▫■□▫▪◙◘ ▬▀▄▌▐█▐▌▄▀▬ ░▒▓▒░ ╎╵╷│╷╵╎ ─┼├┤┴┬┐┌┘└┌┐┬┴┤├┼─ ╏╹╻┃━╋┣┫┻┳┓┏┛┗┏┓┳┻┫┣╋━┃╻╹╏ ╗╔╝╚╬╠╣╩╦║═║╦╩╣╠╬╚╝╔╗ ▁▂▃▅▆▇▊▋▍▎▏▕ ▕▏▎▍▋▊▇▆▅▃▂▁ ▞▚▞ ♠♣♥♦♥♣♠ ☺☻☺ ♂♀♂ ♪♫♪ ☼►◄▲▼↑↓→←↕←→↓↑▼▲◄►☼ ¿~°√∑√°~¿";

// Runtime character set - generated per seed via entropy-locked walk
let CHARS = MASTER_CHARS;

// RNG - seeded from editart
let rng;
let initialSeed;

// Define randomFull for sliderless mode (uses m0 as seed)
function randomFull() {
  return randomM0();
}

// Initialize RNG from editart
function initRNG() {
  // Get seed from randomFull() in sliderless mode
  initialSeed = randomFull();

  // Create RNG using same approach as editart (sfc32)
  const seedStr = randomSeedEditArt + initialSeed.toString();
  rng = getRNG(seedStr);
}

function getRNG(str) {
  const seed = cyrb128(str);
  return sfc32(seed[0], seed[1], seed[2], seed[3]);
}

function cyrb128(str) {
  let h1 = 1779033703,
      h2 = 3144134277,
      h3 = 1013904242,
      h4 = 2773480762;
  for (let i = 0, k; i < str.length; i++) {
    k = str.charCodeAt(i);
    h1 = h2 ^ Math.imul(h1 ^ k, 597399067);
    h2 = h3 ^ Math.imul(h2 ^ k, 2869860233);
    h3 = h4 ^ Math.imul(h3 ^ k, 951274213);
    h4 = h1 ^ Math.imul(h4 ^ k, 2716044179);
  }
  h1 = Math.imul(h3 ^ (h1 >>> 18), 597399067);
  h2 = Math.imul(h4 ^ (h2 >>> 22), 2869860233);
  h3 = Math.imul(h1 ^ (h3 >>> 17), 951274213);
  h4 = Math.imul(h2 ^ (h4 >>> 19), 2716044179);
  return [
    (h1 ^ h2 ^ h3 ^ h4) >>> 0,
    (h2 ^ h1) >>> 0,
    (h3 ^ h1) >>> 0,
    (h4 ^ h1) >>> 0,
  ];
}

function sfc32(a, b, c, d) {
  return function () {
    a >>>= 0;
    b >>>= 0;
    c >>>= 0;
    d >>>= 0;
    var t = (a + b) | 0;
    a = b ^ (b >>> 9);
    b = (c + (c << 3)) | 0;
    c = (c << 21) | (c >>> 11);
    d = (d + 1) | 0;
    t = (t + d) | 0;
    c = (c + t) | 0;
    return (t >>> 0) / 4294967296;
  };
}

// RNG helpers
function random_num(a, b) {
  return a + (b - a) * rng();
}

function random_int(a, b) {
  return Math.floor(random_num(a, b + 1));
}

function rngReset() {
  // Reset to initial seed
  const seedStr = randomSeedEditArt + initialSeed.toString();
  rng = getRNG(seedStr);
}

// Global state
let grid;
let width, height;
let renderScale = 1; // Pixel-perfect integer scale for rendering
let entropy_lock_prob = 0.001;
let rfac, gfac, bfac;
let dfacs = [];
let bg_r, bg_g, bg_b;

// WebGL
let canvas, gl;
let program;
let posBuffer, texBuffer, charBuffer, colorBuffer;
let texture;
let fontData;

// Animation
let animationId = null;
let lastFrameTime = 0;
const targetFPS = 30;
const targetFrameTime = 1000 / targetFPS;
let paused = false;

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
  let xf2 = random_int(0, 3);
  let xf1 = xf2 - random_int(0, 3);
  let yf2 = random_int(0, 3);
  let yf1 = yf2 - random_int(0, 3);

  if (xf2 - xf1 < 2) {
    xf1 = Math.max(-3, xf1 - 1);
    xf2 = Math.min(3, xf2 + 1);
  }
  if (yf2 - yf1 < 2) {
    yf1 = Math.max(-3, yf1 - 1);
    yf2 = Math.min(3, yf2 + 1);
  }

  return [xf1, xf2, yf1, yf2];
}

function burnColor(r, g, b) {
  r = r * random_num(0.98, 1.00) - rfac;
  if (r < 0) r = 255 + r;

  g = g * random_num(0.98, 1.00) - gfac;
  if (g < 0) g = 255 + g;

  b = b * random_num(0.98, 1.00) - bfac;
  if (b < 0) b = 255 + b;

  return [r, g, b];
}

function entropyLock(odds = 999003) {
  if (random_int(1, 1000000) > odds) {
    rngReset();
  }
}

// Build custom character set via random walk through master palette
function buildCharSet() {
  const len = MASTER_CHARS.length;
  let result = '';
  let pos = random_int(0, len - 1);

  for (let i = 0; i < len; i++) {
    result += MASTER_CHARS[pos];
    const step = random_int(-1, 1);
    pos = (pos + step + len) % len;
  }

  const trimmed = result.trim();
  if (trimmed.length === 0) {
    return MASTER_CHARS;
  }

  return result;
}

// Initialize seed-based parameters
function initSeedParams() {
  // Build custom character set via entropy-locked walk
  CHARS = buildCharSet();

  // Random background color
  bg_r = random_int(0, 255);
  bg_g = random_int(0, 255);
  bg_b = random_int(0, 255);

  // Color burn factors
  rfac = random_num(0.5, 5);
  gfac = random_num(0.5, 5);
  bfac = random_num(0.5, 5);

  // Movement factors
  dfacs = getDfacs();

  console.log('=== just a bite ===');
  console.log('SEED:', initialSeed);
  console.log('Custom charset:', CHARS);
  console.log('RGB burn factors:', rfac, gfac, bfac);
  console.log('Movement factors (dfacs):', dfacs);
}

// WebGL shader compilation
function compileShader(gl, source, type) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error('Shader compile error:', gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);
    return null;
  }

  return shader;
}

function createProgram(gl, vertSource, fragSource) {
  const vertShader = compileShader(gl, vertSource, gl.VERTEX_SHADER);
  const fragShader = compileShader(gl, fragSource, gl.FRAGMENT_SHADER);

  const program = gl.createProgram();
  gl.attachShader(program, vertShader);
  gl.attachShader(program, fragShader);
  gl.linkProgram(program);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error('Program link error:', gl.getProgramInfoLog(program));
    return null;
  }

  return program;
}

// Create font texture atlas
function createFontTexture(gl) {
  const fontSize = 64; // Higher resolution to reduce aliasing
  const charWidth = Math.ceil(fontSize * 0.6);
  const charHeight = fontSize;

  const charsPerRow = 16;
  const numRows = Math.ceil(CHARS.length / charsPerRow);
  const atlasWidth = charWidth * charsPerRow;
  const atlasHeight = charHeight * numRows;

  const fontCanvas = document.createElement('canvas');
  fontCanvas.width = atlasWidth;
  fontCanvas.height = atlasHeight;
  const ctx = fontCanvas.getContext('2d', {
    alpha: true,
    willReadFrequently: false
  });

  // Try to disable font smoothing (browser-dependent)
  ctx.imageSmoothingEnabled = false;
  ctx.webkitImageSmoothingEnabled = false;
  ctx.mozImageSmoothingEnabled = false;
  ctx.msImageSmoothingEnabled = false;

  ctx.fillStyle = '#000';
  ctx.fillRect(0, 0, atlasWidth, atlasHeight);
  ctx.fillStyle = '#fff';
  ctx.font = `${fontSize}px "Iosevka", monospace`;
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';

  for (let i = 0; i < CHARS.length; i++) {
    const x = (i % charsPerRow) * charWidth + charWidth / 2;
    const y = Math.floor(i / charsPerRow) * charHeight + charHeight / 2;
    ctx.fillText(CHARS[i], x, y);
  }

  const texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, fontCanvas);
  // Use NEAREST for crisp pixel-perfect rendering
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

  // Debug: log font rendering info
  console.log('Font texture created:', {
    fontSize,
    charWidth,
    charHeight,
    atlasSize: `${atlasWidth}x${atlasHeight}`,
    numChars: CHARS.length,
    fontUsed: ctx.font
  });

  return { texture, charWidth, charHeight, charsPerRow, atlasWidth, atlasHeight };
}

// Track how many tiles to render
let tilesX = 1;
let tilesY = 1;

function resizeCanvas() {
  // Minimal grid - "just a bite" (8x8 characters, like petite chute's 8x8 pixels)
  width = 8;
  height = 8;

  // Square character cells for square pixels when scaled
  const charWidth = 12;
  const charHeight = 12;

  // Calculate pixel-perfect integer scale that fits at least once
  const baseWidth = width * charWidth;
  const baseHeight = height * charHeight;
  const maxScaleX = Math.floor(window.innerWidth / baseWidth);
  const maxScaleY = Math.floor(window.innerHeight / baseHeight);
  renderScale = Math.max(1, Math.min(maxScaleX, maxScaleY));

  // Calculate how many tiles we need to fill the viewport
  const tileWidth = baseWidth * renderScale;
  const tileHeight = baseHeight * renderScale;
  tilesX = Math.ceil(window.innerWidth / tileWidth);
  tilesY = Math.ceil(window.innerHeight / tileHeight);

  // Render full tiled canvas
  const displayWidth = tileWidth * tilesX;
  const displayHeight = tileHeight * tilesY;

  canvas.width = displayWidth;
  canvas.height = displayHeight;
  canvas.style.width = displayWidth + 'px';
  canvas.style.height = displayHeight + 'px';

  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.uniform2f(gl.getUniformLocation(program, 'u_resolution'), canvas.width, canvas.height);

  // Initialize grid with background color
  grid = [];
  for (let y = 0; y < height; y++) {
    grid[y] = [];
    for (let x = 0; x < width; x++) {
      grid[y][x] = new Cell(bg_r, bg_g, bg_b);
    }
  }

  console.log('Grid size:', width, 'x', height, '| Tiles:', tilesX, 'x', tilesY, '| Canvas:', canvas.width, 'x', canvas.height);
}

function setupWebGL() {
  canvas = document.createElement('canvas');
  canvas.id = 'artCanvas';
  document.body.appendChild(canvas);

  gl = canvas.getContext('webgl');

  if (!gl) {
    console.error('WebGL not supported');
    return false;
  }

  const vertSource = `
    attribute vec2 a_position;
    attribute vec2 a_texCoord;
    attribute float a_char;
    attribute vec3 a_color;

    varying vec2 v_texCoord;
    varying vec3 v_color;

    uniform vec2 u_resolution;
    uniform vec2 u_charSize;
    uniform float u_charsPerRow;
    uniform vec2 u_atlasSize;

    void main() {
      vec2 clipSpace = (a_position / u_resolution) * 2.0 - 1.0;
      clipSpace.y *= -1.0;
      gl_Position = vec4(clipSpace, 0, 1);

      float charX = mod(a_char, u_charsPerRow);
      float charY = floor(a_char / u_charsPerRow);
      vec2 charOffset = vec2(charX * u_charSize.x, charY * u_charSize.y) / u_atlasSize;
      vec2 charSize = u_charSize / u_atlasSize;

      v_texCoord = charOffset + a_texCoord * charSize;
      v_color = a_color;
    }
  `;

  const fragSource = `
    precision mediump float;

    varying vec2 v_texCoord;
    varying vec3 v_color;

    uniform sampler2D u_texture;

    void main() {
      vec4 texColor = texture2D(u_texture, v_texCoord);
      float intensity = max(texColor.r, max(texColor.g, texColor.b));
      if (intensity < 0.1) discard;
      gl_FragColor = vec4(v_color * intensity, 1.0);
    }
  `;

  program = createProgram(gl, vertSource, fragSource);
  gl.useProgram(program);

  posBuffer = gl.createBuffer();
  texBuffer = gl.createBuffer();
  charBuffer = gl.createBuffer();
  colorBuffer = gl.createBuffer();

  fontData = createFontTexture(gl);
  texture = fontData.texture;

  gl.uniform2f(gl.getUniformLocation(program, 'u_charSize'), fontData.charWidth, fontData.charHeight);
  gl.uniform1f(gl.getUniformLocation(program, 'u_charsPerRow'), fontData.charsPerRow);
  gl.uniform2f(gl.getUniformLocation(program, 'u_atlasSize'), fontData.atlasWidth, fontData.atlasHeight);
  gl.uniform1i(gl.getUniformLocation(program, 'u_texture'), 0);

  return true;
}

function updateFrame() {
  if (paused) return;

  entropyLock(990003);

  const totalCells = width * height;
  const iterations = Math.floor(totalCells * 0.27);

  for (let i = 0; i < iterations; i++) {
    const x = random_int(0, width - 1);
    const y = random_int(0, height - 1);

    let x_new = x + random_int(dfacs[0], dfacs[1]);
    while (x_new < 0) x_new += width;
    while (x_new >= width) x_new -= width;

    let y_new = y + random_int(dfacs[2], dfacs[3]);
    while (y_new < 0) y_new += height;
    while (y_new >= height) y_new -= height;

    const neighbor = grid[y_new][x_new];
    const [r, g, b] = burnColor(neighbor.r, neighbor.g, neighbor.b);

    grid[y][x].r = r;
    grid[y][x].g = g;
    grid[y][x].b = b;
    grid[y][x].updateChar();
  }

  render();
}

function render() {
  const charW = 12 * renderScale;
  const charH = 12 * renderScale;
  const totalTiles = tilesX * tilesY;
  const cellsPerTile = width * height;
  const numCells = totalTiles * cellsPerTile;

  const positions = new Float32Array(numCells * 12);
  const texCoords = new Float32Array(numCells * 12);
  const chars = new Float32Array(numCells * 6);
  const colors = new Float32Array(numCells * 18);

  let posIdx = 0;
  let texIdx = 0;
  let charIdx = 0;
  let colorIdx = 0;

  const tileWidth = width * charW;
  const tileHeight = height * charH;

  // Render each tile
  for (let tileY = 0; tileY < tilesY; tileY++) {
    for (let tileX = 0; tileX < tilesX; tileX++) {
      const offsetX = tileX * tileWidth;
      const offsetY = tileY * tileHeight;

      // Render 8x8 grid for this tile
      for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
          const cell = grid[y][x];
          const px = offsetX + x * charW;
          const py = offsetY + y * charH;

          const r = cell.r / 255;
          const g = cell.g / 255;
          const b = cell.b / 255;
          const charIndex = cell.charIndex;

          // Two triangles
          positions[posIdx++] = px;
          positions[posIdx++] = py;
          positions[posIdx++] = px + charW;
          positions[posIdx++] = py;
          positions[posIdx++] = px;
          positions[posIdx++] = py + charH;

          positions[posIdx++] = px;
          positions[posIdx++] = py + charH;
          positions[posIdx++] = px + charW;
          positions[posIdx++] = py;
          positions[posIdx++] = px + charW;
          positions[posIdx++] = py + charH;

          // Texture coordinates
          texCoords[texIdx++] = 0;
          texCoords[texIdx++] = 0;
          texCoords[texIdx++] = 1;
          texCoords[texIdx++] = 0;
          texCoords[texIdx++] = 0;
          texCoords[texIdx++] = 1;

          texCoords[texIdx++] = 0;
          texCoords[texIdx++] = 1;
          texCoords[texIdx++] = 1;
          texCoords[texIdx++] = 0;
          texCoords[texIdx++] = 1;
          texCoords[texIdx++] = 1;

          for (let i = 0; i < 6; i++) {
            chars[charIdx++] = charIndex;
          }

          for (let i = 0; i < 6; i++) {
            colors[colorIdx++] = r;
            colors[colorIdx++] = g;
            colors[colorIdx++] = b;
          }
        }
      }
    }
  }

  gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, positions, gl.DYNAMIC_DRAW);
  const posLoc = gl.getAttribLocation(program, 'a_position');
  gl.enableVertexAttribArray(posLoc);
  gl.vertexAttribPointer(posLoc, 2, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, texBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, texCoords, gl.STATIC_DRAW);
  const texLoc = gl.getAttribLocation(program, 'a_texCoord');
  gl.enableVertexAttribArray(texLoc);
  gl.vertexAttribPointer(texLoc, 2, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, charBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, chars, gl.DYNAMIC_DRAW);
  const charLoc = gl.getAttribLocation(program, 'a_char');
  gl.enableVertexAttribArray(charLoc);
  gl.vertexAttribPointer(charLoc, 1, gl.FLOAT, false, 0, 0);

  gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, colors, gl.DYNAMIC_DRAW);
  const colorLoc = gl.getAttribLocation(program, 'a_color');
  gl.enableVertexAttribArray(colorLoc);
  gl.vertexAttribPointer(colorLoc, 3, gl.FLOAT, false, 0, 0);

  gl.clearColor(0, 0, 0, 1);
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.enable(gl.BLEND);
  gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
  gl.drawArrays(gl.TRIANGLES, 0, numCells * 6);
}

function animate(currentTime) {
  const elapsed = currentTime - lastFrameTime;

  if (elapsed >= targetFrameTime) {
    updateFrame();
    lastFrameTime = currentTime - (elapsed % targetFrameTime);
  }

  animationId = requestAnimationFrame(animate);
}

// EditART entry point - called on slider change and resize
async function drawArt() {
  // Stop any existing animation
  if (animationId) {
    cancelAnimationFrame(animationId);
  }

  // Ensure Iosevka font is loaded before creating texture
  try {
    await document.fonts.load('64px "Iosevka"');
    const fontLoaded = document.fonts.check('64px "Iosevka"');
    console.log('Iosevka font loaded:', fontLoaded);
    if (!fontLoaded) {
      console.warn('Font check failed - Iosevka may not be available');
    }
  } catch (e) {
    console.warn('Font loading failed, falling back to system monospace:', e);
  }

  // Initialize RNG from editart
  initRNG();

  // Generate seed-based parameters
  initSeedParams();

  // Setup WebGL if not already done
  if (!gl) {
    if (!setupWebGL()) {
      return;
    }
  } else {
    // Update font texture with new CHARS
    if (texture) {
      gl.deleteTexture(texture);
    }
    fontData = createFontTexture(gl);
    texture = fontData.texture;
    gl.uniform2f(gl.getUniformLocation(program, 'u_charSize'), fontData.charWidth, fontData.charHeight);
    gl.uniform1f(gl.getUniformLocation(program, 'u_charsPerRow'), fontData.charsPerRow);
    gl.uniform2f(gl.getUniformLocation(program, 'u_atlasSize'), fontData.atlasWidth, fontData.atlasHeight);
  }

  // Size canvas and create grid
  resizeCanvas();

  // Mobile tap to advance seed (like 'r' key)
  let touchStartTime = 0;
  canvas.addEventListener('touchstart', (e) => {
    touchStartTime = Date.now();
  });

  canvas.addEventListener('touchend', (e) => {
    const touchDuration = Date.now() - touchStartTime;
    // Only trigger on quick taps (not long presses or drags)
    if (touchDuration < 300) {
      e.preventDefault();
      // Generate next seed deterministically (same as 'r' key)
      const seedMarchRNG = getRNG(randomSeedEditArt + 'march_' + initialSeed.toString());
      const newSeed = seedMarchRNG();
      console.log('SEED:', initialSeed, '→', newSeed, '(tap)');
      changeSeed(newSeed);
    }
  });

  // Start animation
  lastFrameTime = performance.now();
  animate(lastFrameTime);

  // Trigger preview after a few frames have rendered
  setTimeout(() => {
    triggerPreview();
  }, 100);
}

// Controls
const infoEl = document.getElementById('info');

// Helper function to change seed and reinitialize
function changeSeed(newSeed) {
  // Stop animation and reinitialize with new seed
  if (animationId) {
    cancelAnimationFrame(animationId);
  }

  // Override initialSeed
  initialSeed = newSeed;
  const seedStr = randomSeedEditArt + initialSeed.toString();
  rng = getRNG(seedStr);

  // Regenerate everything
  initSeedParams();

  // Update font texture with new CHARS
  if (texture) {
    gl.deleteTexture(texture);
  }
  fontData = createFontTexture(gl);
  texture = fontData.texture;
  gl.uniform2f(gl.getUniformLocation(program, 'u_charSize'), fontData.charWidth, fontData.charHeight);
  gl.uniform1f(gl.getUniformLocation(program, 'u_charsPerRow'), fontData.charsPerRow);
  gl.uniform2f(gl.getUniformLocation(program, 'u_atlasSize'), fontData.atlasWidth, fontData.atlasHeight);

  // Reset grid
  resizeCanvas();

  // Restart animation
  lastFrameTime = performance.now();
  paused = false;
  animate(lastFrameTime);
}

document.addEventListener('keyup', (e) => {
  if (e.key === 'i') {
    infoEl.classList.toggle('show');
  } else if (e.key === 'p') {
    paused = !paused;
    console.log(paused ? 'Paused' : 'Resumed');
  } else if (e.key === 'f') {
    // Toggle fullscreen
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen();
    } else {
      document.exitFullscreen();
    }
  } else if (e.key === 'r') {
    // Generate next seed deterministically from current seed
    // Create a temporary RNG from current seed to get the next one
    const seedMarchRNG = getRNG(randomSeedEditArt + 'march_' + initialSeed.toString());
    const newSeed = seedMarchRNG();
    console.log('SEED:', initialSeed, '→', newSeed);
    changeSeed(newSeed);
  } else if (e.key === 'ArrowRight') {
    // Increment seed by fixed amount
    const newSeed = (initialSeed + 0.01) % 1.0;
    console.log('SEED:', initialSeed, '→', newSeed, '(+0.01)');
    changeSeed(newSeed);
  } else if (e.key === 'ArrowLeft') {
    // Decrement seed by fixed amount
    const newSeed = (initialSeed - 0.01 + 1.0) % 1.0;
    console.log('SEED:', initialSeed, '→', newSeed, '(-0.01)');
    changeSeed(newSeed);
  }
});
