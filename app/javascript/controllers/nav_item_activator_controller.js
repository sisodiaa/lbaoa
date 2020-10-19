import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["navItem", "item"];

  initialize() {
    this.activateNavItem();
  }

  activateNavItem() {
    this.navItemTargets.forEach(el => {
      if (el.dataset.navItem === this.itemTarget.dataset.item) {
        el.classList.add("active");
      }
    });
  }
}
