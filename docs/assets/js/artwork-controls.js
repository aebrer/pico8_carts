// Shared artwork controls for display pages
// Automatically renders controls and handles artwork loading

let artworkLoaded = false;
let currentIframe = null;
let currentPlatform = 'fxhash'; // 'fxhash' or 'editart'

function loadArtwork(isGenerative, baseIpfsUrl, isImage = false, platform = 'fxhash') {
  if (artworkLoaded) return;

  currentPlatform = platform;
  const display = document.getElementById('artwork-display');

  let url = baseIpfsUrl;

  if (isGenerative) {
    if (platform === 'editart') {
      // EditART: just add sliderLess=true
      url = baseIpfsUrl.includes('?')
        ? `${baseIpfsUrl}&sliderLess=true`
        : `${baseIpfsUrl}?sliderLess=true`;
    } else {
      // fxhash: use fxhash and fxiteration parameters
      const hash = generateFxHash();
      const iteration = Math.floor(Math.random() * 1000);

      if (baseIpfsUrl.includes('?')) {
        const urlObj = new URL(baseIpfsUrl);
        urlObj.searchParams.set('fxhash', hash);
        urlObj.searchParams.set('fxiteration', iteration);
        url = urlObj.toString();
      } else {
        url = `${baseIpfsUrl}?fxhash=${hash}`;
      }
    }
  }

  if (isImage) {
    display.innerHTML = `<img src="${url}" alt="Artwork" style="width: 100%; height: 100%; object-fit: contain;">`;
    artworkLoaded = true;
    renderArtworkControls(isGenerative, baseIpfsUrl, platform);
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
    renderArtworkControls(isGenerative, baseIpfsUrl, platform);
  }
}

function renderArtworkControls(isGenerative, baseIpfsUrl, platform) {
  const controlsContainer = document.getElementById('artwork-controls');
  if (!controlsContainer) return;

  controlsContainer.innerHTML = '';

  if (isGenerative) {
    const randomBtn = document.createElement('button');
    randomBtn.className = 'btn';
    randomBtn.textContent = 'Randomize';
    randomBtn.onclick = () => randomizeArtwork(isGenerative, baseIpfsUrl, platform);
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

function randomizeArtwork(isGenerative, baseIpfsUrl, platform) {
  if (!isGenerative || !currentIframe) return;

  if (platform === 'editart') {
    // EditART: just reload the iframe (uses randomFull() internally)
    currentIframe.src = currentIframe.src;
  } else {
    // fxhash: generate new hash and iteration
    const hash = generateFxHash();
    const iteration = Math.floor(Math.random() * 1000);

    if (baseIpfsUrl.includes('?')) {
      const url = new URL(baseIpfsUrl);
      url.searchParams.set('fxhash', hash);
      url.searchParams.set('fxiteration', iteration);
      currentIframe.src = url.toString();
    } else {
      currentIframe.src = `${baseIpfsUrl}?fxhash=${hash}`;
    }
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
