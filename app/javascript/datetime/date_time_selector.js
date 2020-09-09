import flatpickr from "flatpickr";
require("flatpickr/dist/flatpickr.css");

document.addEventListener("turbolinks:load", () => {
  flatpickr("[data-behavior='flatpickr']", {
    enableTime: true,
    time_24hr: true,
    altInput: true,
    altFormat: "F j, Y H:i",
    dateFormat: "Y-m-d H:i"
  });
});
