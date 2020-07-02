document.addEventListener("turbolinks:load", () => {
  const trixEditor = document.querySelector("trix-editor");
  trixEditor &&
    delete trixEditor.dataset.directUploadUrl &&
    delete trixEditor.dataset.blobUrlTemplate &&
    trixEditor.addEventListener("trix-file-accept", event => {
      event.preventDefault();
    });
});
