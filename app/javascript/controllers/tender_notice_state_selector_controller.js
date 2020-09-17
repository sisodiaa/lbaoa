import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["noticeState"];

  connect() {
    this.activateTarget();
  }

  activateTarget() {
    this.noticeStateTargets.forEach(el => {
      if (el.dataset.pathname === window.location.pathname) {
        this.deactivateTarget();
        el.classList.add("active");
      }
    });
  }

  deactivateTarget() {
    this.noticeStateTargets.forEach(el => el.classList.remove("active"));
  }
}
