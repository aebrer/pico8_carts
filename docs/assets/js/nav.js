// Shared navigation component
// This gets loaded on every page so we only need to update nav in one place

function renderNav(context = 'root') {
  // context can be: 'root', 'series', 'works'
  // This determines relative paths (../ for nested pages)
  const prefix = context === 'root' ? '' : '../';

  const nav = `
    <h1 class="site-title">Drew Brereton <span style="color: var(--link-hover);">(aebrer)</span></h1>
    <nav>
      <a href="${prefix}index.html">Home</a>
      <a href="${prefix}series/ideocart.html">Ideocart</a>
      <a href="${prefix}series/vestiges.html">Vestiges</a>
      <a href="${prefix}series/emergence.html">Emergence</a>
      <a href="${prefix}series/three-body-problem.html">Three Body Problem</a>
      <a href="${prefix}series/entropy-locked.html">Entropy-Locked</a>
      <a href="${prefix}series/pico-punks.html">Pico Punks</a>
      <a href="${prefix}series/pico-galaxies.html">Pico Galaxies</a>
      <a href="${prefix}series/screensavers.html">Screensavers</a>
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
