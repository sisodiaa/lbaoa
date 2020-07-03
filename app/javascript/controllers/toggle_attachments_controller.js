import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["message", "attachments"];

  toggleAttachments(event) {
    event.preventDefault();
    this.attachmentsTarget.classList.toggle("post__attachments--display");
  }

  toggleMessage(event) {
    event.preventDefault();
    this.message = this.messageTarget.innerHTML.trim();
    this.messageTarget.innerHTML = this.message;
  }

  get message() {
    return this.action === "Show"
      ? `Hide ${this.count} ${this.thing}`
      : `Show ${this.count} ${this.thing}`;
  }

  set message(str) {
    [this.action, this.count, this.thing] = str.split(" ");
  }
}
