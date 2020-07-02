document.addEventListener('turbolinks:load', () => {
  [
    '.trix-button--icon-decrease-nesting-level',
    '.trix-button--icon-increase-nesting-level',
    '.trix-button-group--file-tools',
    '.trix-button--icon-code'
  ].forEach((query) => {
    const el = document.querySelector(query);
    el && el.remove();
  })
})
