/*
THE FALL (ASCII) - WebGL Version

GPU-accelerated rendering for maximum smoothness
*/

// Character set - with bidirectional gradients for visual symmetry
const CHARS = " ·∙•○●○•∙· ◘◙▪▫■□▫▪◙◘ ▬▀▄▌▐█▐▌▄▀▬ ░▒▓▒░ ╎╵╷│╷╵╎ ─┼├┤┴┬┐┌┘└┌┐┬┴┤├┼─ ╏╹╻┃━╋┣┫┻┳┓┏┛┗┏┓┳┻┫┣╋━┃╻╹╏ ╗╔╝╚╬╠╣╩╦║═║╦╩╣╠╬╚╝╔╗ ▁▂▃▅▆▇▊▋▍▎▏▕ ▕▏▎▍▋▊▇▆▅▃▂▁ ▞▚▞ ♠♣♥♦♥♣♠ ☺☻☺ ♂♀♂ ♪♫♪ ☼►◄▲▼↑↓→←↕←→↓↑▼▲◄►☼ ¿~°√∑√°~¿";

// RNG helpers (using fxhash)
function random_num(a, b) {
  return a + (b - a) * $fx.rand();
}

function random_int(a, b) {
  return Math.floor(random_num(a, b + 1));
}

// Global state
let grid;
let width, height;
let entropy_lock_prob = 0.001; // 0.1% - checked per pixel iteration now
let rfac, gfac, bfac;
let dfacs = [];
let fc = 0;
let paused = false;

// WebGL
let canvas, gl;
let program;
let posBuffer, texBuffer, charBuffer, colorBuffer;
let texture;

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

  // Ensure some variation in movement (avoid degenerate cases)
  // If x range is too small, expand it
  if (xf2 - xf1 < 2) {
    xf1 = Math.max(-3, xf1 - 1);
    xf2 = Math.min(3, xf2 + 1);
  }
  // If y range is too small, expand it
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

function rngReset(odds = 999003) {
  // Original logic: if random_int(1, 1000000) > odds, reset
  // Higher odds = less frequent resets
  if (random_int(1, 1000000) > odds) {
    $fx.rand.reset();
  }
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
  const fontSize = 32; // Higher res for sharper rendering
  const charWidth = Math.ceil(fontSize * 0.6);
  const charHeight = fontSize;

  // Calculate atlas size
  const charsPerRow = 16;
  const numRows = Math.ceil(CHARS.length / charsPerRow);
  const atlasWidth = charWidth * charsPerRow;
  const atlasHeight = charHeight * numRows;

  // Create canvas to draw font
  const fontCanvas = document.createElement('canvas');
  fontCanvas.width = atlasWidth;
  fontCanvas.height = atlasHeight;
  const ctx = fontCanvas.getContext('2d');

  ctx.fillStyle = '#000';
  ctx.fillRect(0, 0, atlasWidth, atlasHeight);
  ctx.fillStyle = '#fff';
  ctx.font = `${fontSize}px "Courier New", monospace`;
  ctx.textBaseline = 'top';

  // Draw each character
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  for (let i = 0; i < CHARS.length; i++) {
    const x = (i % charsPerRow) * charWidth + charWidth / 2;
    const y = Math.floor(i / charsPerRow) * charHeight + charHeight / 2;
    ctx.fillText(CHARS[i], x, y);
  }

  // Create WebGL texture
  const texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, fontCanvas);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

  return { texture, charWidth, charHeight, charsPerRow, atlasWidth, atlasHeight };
}

// Background color (persists across resizes)
let bg_r, bg_g, bg_b;

// Initialize once - RNG state and color/movement factors
function initRNG(newSeed = false) {
  // For 'r' key (new seed), modify the hash with timestamp
  if (newSeed) {
    const timestamp = Date.now();
    // Modify the internal RNG state by mixing in timestamp
    $fx.rand.reset();
    // Burn some random numbers based on timestamp to get different state
    for (let i = 0; i < (timestamp % 1000); i++) {
      $fx.rand();
    }
  } else {
    $fx.rand.reset();
  }

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

  console.log('THE FALL (ASCII) - WebGL' + (newSeed ? ' (new seed)' : ''));
  console.log('RGB burn factors:', rfac, gfac, bfac);
  console.log('Movement factors (dfacs):', dfacs);
}

// Recalculate grid when viewport changes
function resizeCanvas() {
  // Calculate grid size based on viewport aspect ratio
  const charWidth = 8;
  const charHeight = 12;
  const aspectRatio = window.innerWidth / window.innerHeight;

  // Larger grid since WebGL can handle it
  height = 120;
  width = Math.floor(height * aspectRatio);

  // Set canvas size to match grid exactly
  canvas.width = width * charWidth;
  canvas.height = height * charHeight;

  // Scale to fill viewport completely (stretch to fit both dimensions)
  canvas.style.width = window.innerWidth + 'px';
  canvas.style.height = window.innerHeight + 'px';

  gl.viewport(0, 0, canvas.width, canvas.height);

  // Update resolution uniform
  gl.uniform2f(gl.getUniformLocation(program, 'u_resolution'), canvas.width, canvas.height);

  // Initialize grid with background color
  grid = [];
  for (let y = 0; y < height; y++) {
    grid[y] = [];
    for (let x = 0; x < width; x++) {
      grid[y][x] = new Cell(bg_r, bg_g, bg_b);
    }
  }

  console.log('Grid resized:', width, 'x', height);
}

function setup() {
  canvas = document.querySelector('canvas');
  gl = canvas.getContext('webgl');

  if (!gl) {
    console.error('WebGL not supported');
    return;
  }

  // Create shaders
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
      // Convert pixel coords to clip space
      vec2 clipSpace = (a_position / u_resolution) * 2.0 - 1.0;
      clipSpace.y *= -1.0;
      gl_Position = vec4(clipSpace, 0, 1);

      // Calculate texture coordinates for this character
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
      // Use the white from the font texture as alpha
      float intensity = max(texColor.r, max(texColor.g, texColor.b));
      if (intensity < 0.1) discard;
      gl_FragColor = vec4(v_color * intensity, 1.0);
    }
  `;

  program = createProgram(gl, vertSource, fragSource);
  gl.useProgram(program);

  // Create font texture
  const fontData = createFontTexture(gl);
  texture = fontData.texture;

  // Set uniforms (resolution will be updated in resizeCanvas)
  gl.uniform2f(gl.getUniformLocation(program, 'u_charSize'), fontData.charWidth, fontData.charHeight);
  gl.uniform1f(gl.getUniformLocation(program, 'u_charsPerRow'), fontData.charsPerRow);
  gl.uniform2f(gl.getUniformLocation(program, 'u_atlasSize'), fontData.atlasWidth, fontData.atlasHeight);
  gl.uniform1i(gl.getUniformLocation(program, 'u_texture'), 0);

  // Create buffers
  posBuffer = gl.createBuffer();
  texBuffer = gl.createBuffer();
  charBuffer = gl.createBuffer();
  colorBuffer = gl.createBuffer();

  // Initialize RNG and factors (once)
  initRNG();

  // Size the canvas and create grid
  resizeCanvas();

  // Mobile tap to reset (like 'r' key)
  let touchStartTime = 0;
  canvas.addEventListener('touchstart', (e) => {
    console.log('Touch start');
    touchStartTime = Date.now();
  });

  canvas.addEventListener('touchend', (e) => {
    console.log('Touch end');
    const touchDuration = Date.now() - touchStartTime;
    console.log('Touch duration:', touchDuration);
    // Only trigger on quick taps (not long presses or drags)
    if (touchDuration < 300) {
      console.log('Reloading!');
      e.preventDefault();
      window.location.reload();
    }
  });
}

function draw() {
  if (paused) return;

  // Check for entropy lock once per frame (like original)
  rngReset(999003);

  // Process pixels - scale iterations based on grid size to maintain consistent movement speed
  // On widescreen (307x120 = 36,840 cells), 10k iterations ≈ 0.27 per cell
  const totalCells = width * height;
  const iterations = Math.floor(totalCells * 0.27);

  for (let i = 0; i < iterations; i++) {
    const x = random_int(0, width - 1);
    const y = random_int(0, height - 1);

    let x_new = x + random_int(dfacs[0], dfacs[1]);
    // Simple wrap-around (since dfacs are small [-3,3], this should be fine)
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

  // Render
  render();

  fc++;
}

function render() {
  const charW = 8;
  const charH = 12;
  const numCells = width * height;

  // Build vertex data
  const positions = new Float32Array(numCells * 12); // 6 vertices * 2 coords
  const texCoords = new Float32Array(numCells * 12);
  const chars = new Float32Array(numCells * 6);
  const colors = new Float32Array(numCells * 18); // 6 vertices * 3 colors

  let posIdx = 0;
  let texIdx = 0;
  let charIdx = 0;
  let colorIdx = 0;

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const cell = grid[y][x];
      const px = x * charW;
      const py = y * charH;

      const r = cell.r / 255;
      const g = cell.g / 255;
      const b = cell.b / 255;
      const charIndex = cell.charIndex;

      // Two triangles per character
      // Triangle 1
      positions[posIdx++] = px;
      positions[posIdx++] = py;
      positions[posIdx++] = px + charW;
      positions[posIdx++] = py;
      positions[posIdx++] = px;
      positions[posIdx++] = py + charH;

      // Triangle 2
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

      // Character index (same for all 6 vertices)
      for (let i = 0; i < 6; i++) {
        chars[charIdx++] = charIndex;
      }

      // Colors (same for all 6 vertices)
      for (let i = 0; i < 6; i++) {
        colors[colorIdx++] = r;
        colors[colorIdx++] = g;
        colors[colorIdx++] = b;
      }
    }
  }

  // Upload to GPU
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

  // Draw
  gl.clearColor(0, 0, 0, 1);
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.enable(gl.BLEND);
  gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
  gl.drawArrays(gl.TRIANGLES, 0, numCells * 6);
}

// Controls
const infoEl = document.getElementById('info');

document.addEventListener('keyup', (e) => {
  if (e.key === 'i') {
    infoEl.classList.toggle('show');
  } else if (e.key === 'p') {
    paused = !paused;
  } else if (e.key === 's') {
    const link = document.createElement('a');
    link.download = 'the_fall_ascii.png';
    link.href = canvas.toDataURL();
    link.click();
  } else if (e.key === 'f') {
    // Toggle fullscreen (grid will be recalculated on fullscreenchange event)
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen();
    } else {
      document.exitFullscreen();
    }
  } else if (e.key === 'r') {
    // Reset with new seed (without reloading - stays in fullscreen)
    // Generates different seed by burning timestamp-based number of RNG calls
    initRNG(true);
    resizeCanvas();
  }
});

// Animation loop with FPS cap
let lastFrameTime = 0;
const targetFPS = 30; // Cap at 30fps to see patterns
const targetFrameTime = 1000 / targetFPS;

function animate(currentTime) {
  const elapsed = currentTime - lastFrameTime;

  if (elapsed >= targetFrameTime) {
    draw();
    lastFrameTime = currentTime - (elapsed % targetFrameTime);
  }

  requestAnimationFrame(animate);
}

// Handle fullscreen and resize by recalculating grid (no reload needed)
document.addEventListener('fullscreenchange', () => {
  resizeCanvas();
});

window.addEventListener('resize', () => {
  resizeCanvas();
});

// Start
setup();
requestAnimationFrame(animate);
