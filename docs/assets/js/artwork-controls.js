// Shared artwork controls for display pages
// Automatically renders controls and handles artwork loading

let artworkLoaded = false;
let currentIframe = null;

// IPFS gateway fallback list - tries in order if one fails
const IPFS_GATEWAYS = [
  'https://ipfs.io',
  'https://cloudflare-ipfs.com',
  'https://gateway.pinata.cloud',
  'https://dweb.link',
  'https://4everland.io'
];

let currentGatewayIndex = 0;
let loadTimeout = null;

// Helper function to swap IPFS gateway in a URL
function swapIpfsGateway(url, newGateway) {
  // Replace any IPFS gateway with the new one
  for (const gateway of IPFS_GATEWAYS) {
    if (url.includes(gateway)) {
      return url.replace(gateway, newGateway);
    }
  }
  return url;
}

// Try next IPFS gateway if current one fails
function tryNextGateway(isGenerative, baseIpfsUrl, isImage) {
  currentGatewayIndex++;

  if (currentGatewayIndex >= IPFS_GATEWAYS.length) {
    // All gateways failed - show error
    const display = document.getElementById('artwork-display');
    display.innerHTML = `
      <div style="padding: 20px; text-align: center;">
        <p style="color: var(--link-hover); margin-bottom: 10px;">⚠️ Unable to load artwork</p>
        <p style="font-size: 14px;">IPFS gateways are temporarily unavailable or blocked in your region.</p>
        <p style="font-size: 14px; margin-top: 10px;">Try:</p>
        <ul style="font-size: 14px; text-align: left; max-width: 400px; margin: 10px auto;">
          <li>Refreshing the page in a few minutes</li>
          <li>Using a VPN if IPFS is blocked in your region</li>
          <li>Viewing on the original platform (see links below)</li>
        </ul>
      </div>
    `;
    return;
  }

  // Try loading with next gateway
  const newGateway = IPFS_GATEWAYS[currentGatewayIndex];
  const newUrl = swapIpfsGateway(baseIpfsUrl, newGateway);

  console.log(`Trying fallback gateway ${currentGatewayIndex + 1}/${IPFS_GATEWAYS.length}: ${newGateway}`);

  artworkLoaded = false;
  loadArtwork(isGenerative, newUrl, isImage);
}

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
    const img = new Image();

    // Set timeout for image loading
    loadTimeout = setTimeout(() => {
      console.log('Image load timeout, trying next gateway...');
      tryNextGateway(isGenerative, baseIpfsUrl, isImage);
    }, 10000); // 10 second timeout

    img.onload = () => {
      clearTimeout(loadTimeout);
      display.innerHTML = `<img src="${url}" alt="Artwork" style="width: 100%; height: 100%; object-fit: contain;">`;
      artworkLoaded = true;
      renderArtworkControls(isGenerative, baseIpfsUrl);
    };

    img.onerror = () => {
      clearTimeout(loadTimeout);
      console.log('Image load error, trying next gateway...');
      tryNextGateway(isGenerative, baseIpfsUrl, isImage);
    };

    img.src = url;
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

    currentIframe = document.getElementById('artwork-iframe');
    artworkLoaded = true;
    renderArtworkControls(isGenerative, baseIpfsUrl);

    // Note: We don't use fallback for iframes because:
    // 1. CORS/sandbox prevents reliable error detection
    // 2. Most IPFS gateways work for the fxhash/onchfs content
    // 3. Users can use the platform links if iframe fails
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
