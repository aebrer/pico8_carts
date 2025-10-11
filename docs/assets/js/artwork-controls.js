// Shared artwork controls for display pages
// Automatically renders controls and handles artwork loading

let artworkLoaded = false;
let currentIframe = null;

function loadArtwork(isGenerative, baseIpfsUrl) {
  if (artworkLoaded) return;

  const display = document.getElementById('artwork-display');
  const hash = isGenerative ? generateFxHash() : '';
  const url = isGenerative ? `${baseIpfsUrl}?fxhash=${hash}` : baseIpfsUrl;

  display.innerHTML = `
    <iframe
      id="artwork-iframe"
      src="${url}"
      sandbox="allow-scripts allow-downloads"
      scrolling="no"
      style="border: none; width: 100%; height: 100%;">
    </iframe>
  `;

  artworkLoaded = true;
  currentIframe = document.getElementById('artwork-iframe');

  // Render controls after iframe is loaded
  renderArtworkControls(isGenerative, baseIpfsUrl);
}

function renderArtworkControls(isGenerative, baseIpfsUrl) {
  const controlsContainer = document.getElementById('artwork-controls');
  if (!controlsContainer) return;

  controlsContainer.innerHTML = '';

  if (isGenerative) {
    const randomBtn = document.createElement('button');
    randomBtn.className = 'btn';
    randomBtn.textContent = 'Randomize';
    randomBtn.onclick = () => randomizeArtwork(isGenerative, baseIpfsUrl);
    controlsContainer.appendChild(randomBtn);
  }

  const fullscreenBtn = document.createElement('button');
  fullscreenBtn.className = 'btn';
  fullscreenBtn.textContent = 'Fullscreen';
  fullscreenBtn.onclick = fullscreenArtwork;
  controlsContainer.appendChild(fullscreenBtn);
}

function randomizeArtwork(isGenerative, baseIpfsUrl) {
  if (!isGenerative || !currentIframe) return;
  const hash = generateFxHash();
  currentIframe.src = `${baseIpfsUrl}?fxhash=${hash}`;
}

function fullscreenArtwork() {
  if (!currentIframe) return;

  // Listen for fullscreen change to reload artwork
  const reloadOnFullscreen = () => {
    // Reload on both entering and exiting fullscreen
    currentIframe.src = currentIframe.src;
  };

  document.addEventListener('fullscreenchange', reloadOnFullscreen);
  document.addEventListener('webkitfullscreenchange', reloadOnFullscreen);
  document.addEventListener('msfullscreenchange', reloadOnFullscreen);

  // Remove listeners after exiting fullscreen
  const cleanupListeners = () => {
    if (!document.fullscreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {
      document.removeEventListener('fullscreenchange', reloadOnFullscreen);
      document.removeEventListener('webkitfullscreenchange', reloadOnFullscreen);
      document.removeEventListener('msfullscreenchange', reloadOnFullscreen);
      document.removeEventListener('fullscreenchange', cleanupListeners);
      document.removeEventListener('webkitfullscreenchange', cleanupListeners);
      document.removeEventListener('msfullscreenchange', cleanupListeners);
    }
  };

  document.addEventListener('fullscreenchange', cleanupListeners);
  document.addEventListener('webkitfullscreenchange', cleanupListeners);
  document.addEventListener('msfullscreenchange', cleanupListeners);

  // Request fullscreen
  if (currentIframe.requestFullscreen) {
    currentIframe.requestFullscreen();
  } else if (currentIframe.webkitRequestFullscreen) {
    currentIframe.webkitRequestFullscreen();
  } else if (currentIframe.msRequestFullscreen) {
    currentIframe.msRequestFullscreen();
  }
}
