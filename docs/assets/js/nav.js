// Shared navigation component
// This gets loaded on every page so we only need to update nav in one place

function renderNav(context = 'root') {
  // context can be: 'root', 'series', 'works'
  // This determines relative paths (../ for nested pages)
  const prefix = context === 'root' ? '' : '../';

  // Generate series links dynamically from SERIES data
  // SERIES is loaded from data.js which must be included before nav.js
  let seriesLinks = '';
  if (typeof SERIES !== 'undefined') {
    seriesLinks = Object.entries(SERIES)
      .map(([id, series]) => `<a href="${prefix}series/${id}.html">${series.name}</a>`)
      .join('\n      ');
  }

  const nav = `
    <h1 class="site-title">Drew Brereton <span style="color: var(--link-hover);">(aebrer)</span></h1>
    <nav>
      <a href="${prefix}index.html">Home</a>
      <a href="${prefix}themes.html">Themes</a>
      ${seriesLinks}
      <a href="${prefix}faq.html">FAQ</a>
      <a href="${prefix}index.html#contact">Contact</a>
      <img src="${prefix}aebrer_pfp.png" alt="aebrer" class="avatar">
    </nav>
  `;

  return nav;
}

// Auto-render on page load if header element exists
document.addEventListener('DOMContentLoaded', function() {
  const header = document.querySelector('header');
  if (header && header.hasAttribute('data-nav-context')) {
    const context = header.getAttribute('data-nav-context');
    header.innerHTML = renderNav(context);
  }
});
