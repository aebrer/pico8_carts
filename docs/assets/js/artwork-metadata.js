// Shared artwork metadata rendering
// Automatically renders themes and other metadata from data.js

function renderArtworkMetadata(workId) {
  const work = WORKS[workId];
  if (!work) {
    console.error(`Work not found: ${workId}`);
    return;
  }

  // Render themes
  const themesContainer = document.getElementById('artwork-themes');
  if (themesContainer && work.themes) {
    themesContainer.innerHTML = work.themes.map(theme =>
      `<a href="../themes.html?theme=${encodeURIComponent(theme)}" class="theme-tag">${theme}</a>`
    ).join('\n              ');
  }

  // Render platform links
  const linksContainer = document.getElementById('artwork-links');
  if (linksContainer && work.links) {
    let linksHTML = '';

    // Platform links
    if (work.links.fxhash) {
      linksHTML += `<a href="${work.links.fxhash}" target="_blank">View on fxhash</a>\n            `;
    }
    if (work.links.teia) {
      linksHTML += `<a href="${work.links.teia}" target="_blank">View on Teia</a>\n            `;
    }
    if (work.links.objkt) {
      linksHTML += `<a href="${work.links.objkt}" target="_blank">View on Objkt</a>\n            `;
    }
    if (work.links.versum) {
      linksHTML += `<a href="${work.links.versum}" target="_blank">View on Versum</a>\n            `;
    }
    if (work.links.manifold) {
      linksHTML += `<a href="${work.links.manifold}" target="_blank">View on Manifold</a>\n            `;
    }
    if (work.links.editart) {
      linksHTML += `<a href="${work.links.editart}" target="_blank">View on EditART</a>\n            `;
    }

    // Provenance link
    if (work.provenance) {
      // Label the record by what it actually is, and point at our archival copy where
      // we hold one. The canonical identifier stays in data.js either way.
      const scheme = work.provenance.split('://')[0];
      const LOCAL_MIRRORED = { ipfs: 'Provenance (IPFS Metadata)', onchfs: 'Provenance (On-Chain Metadata)' };
      const provenanceUrl = LOCAL_MIRRORED[scheme]
        ? `/artifacts/provenance/${work.id}.json`
        : work.provenance;
      const provenanceLabel = LOCAL_MIRRORED[scheme]
        || (work.provenance.includes('arweave.net') ? 'Provenance (Arweave Metadata)'
                                                    : 'Provenance (On-Chain Metadata)');
      linksHTML += `<a href="${provenanceUrl}" target="_blank">${provenanceLabel}</a>\n            `;
    }

    // Source code link (always include)
    if (work.sourceCode) {
      linksHTML += `<a href="${work.sourceCode}" target="_blank">View Source Code</a>`;
    } else {
      // Fallback to auto-generated path
      const seriesPath = SERIES[work.series]?.name.toLowerCase().replace(/\s+/g, '-') || work.series;
      const workPath = work.title.toLowerCase().replace(/\s+/g, '-');
      linksHTML += `<a href="https://github.com/aebrer/pico8_carts/tree/master/series/${seriesPath}/${workPath}" target="_blank">View Source Code</a>`;
    }

    linksContainer.innerHTML = linksHTML;
  }
}

// Auto-render on page load if work-id is set
document.addEventListener('DOMContentLoaded', function() {
  const workIdMeta = document.querySelector('meta[name="work-id"]');
  if (workIdMeta) {
    const workId = workIdMeta.content;
    renderArtworkMetadata(workId);
  }
});
