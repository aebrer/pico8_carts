// Shared artwork controls for display pages
// Automatically renders controls and handles artwork loading

let artworkLoaded = false;
let currentIframe = null;

function loadArtwork(isGenerative, baseIpfsUrl, isImage = false) {
  if (artworkLoaded) return;

  const display = document.getElementById('artwork-display');
  const hash = isGenerative ? generateFxHash() : '';
  const iteration = isGenerative ? Math.floor(Math.random() * 1000) : 0;

  let url = baseIpfsUrl;
  if (isGenerative) {
    if (baseIpfsUrl.includes('?')) {
      // URL already has query parameters - update fxhash and fxiteration
      const urlObj = new URL(baseIpfsUrl);
      urlObj.searchParams.set('fxhash', hash);
      urlObj.searchParams.set('fxiteration', iteration);
      url = urlObj.toString();
    } else {
      // Simple case: no existing parameters
      url = `${baseIpfsUrl}?fxhash=${hash}`;
    }
  }

  if (isImage) {
    display.innerHTML = `<img src="${url}" alt="Artwork" style="width: 100%; height: 100%; object-fit: contain;">`;
    artworkLoaded = true;
    renderArtworkControls(isGenerative, baseIpfsUrl);
  } else {
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
    renderArtworkControls(isGenerative, baseIpfsUrl);
  }
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

  // iOS Safari doesn't support Fullscreen API on iframes
  const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;

  if (isIOS) {
    const openBtn = document.createElement('button');
    openBtn.className = 'btn';
    openBtn.textContent = 'Open in new tab';
    openBtn.onclick = () => {
      if (currentIframe) {
        window.open(currentIframe.src, '_blank');
      }
    };
    controlsContainer.appendChild(openBtn);
  } else {
    const fullscreenBtn = document.createElement('button');
    fullscreenBtn.className = 'btn';
    fullscreenBtn.textContent = 'Fullscreen';
    fullscreenBtn.onclick = fullscreenArtwork;
    controlsContainer.appendChild(fullscreenBtn);
  }
}

function randomizeArtwork(isGenerative, baseIpfsUrl) {
  if (!isGenerative || !currentIframe) return;
  const hash = generateFxHash();
  const iteration = Math.floor(Math.random() * 1000);

  // Check if URL already has query parameters
  if (baseIpfsUrl.includes('?')) {
    // Parse URL and update fxhash and fxiteration parameters
    const url = new URL(baseIpfsUrl);
    url.searchParams.set('fxhash', hash);
    url.searchParams.set('fxiteration', iteration);
    currentIframe.src = url.toString();
  } else {
    // Simple case: no existing parameters
    currentIframe.src = `${baseIpfsUrl}?fxhash=${hash}`;
  }
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
