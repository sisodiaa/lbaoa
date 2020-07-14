import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["error", "attribute"];

  connect() {
    this.displayValidationError();
  }

  displayValidationError() {
    // Iterate over elements having information on error
    this.errorTargets.forEach(element => {
      // Store value of model attribute associated with the error
      this.errorAttribute = element.dataset.errorAttribute;

      // Store references to nodes containing error messages as an iterable
      this.messageNodes = Array.from(element.children);

      // Add is-invalid class to highlillght the field
      this.formField.classList.add("is-invalid");

      // Iterate over each error message and assign them to textContent of
      // each node clonded from the template
      this.errorMessages.forEach(this.addErrorMessage.bind(this));
    });
  }

  // Returns the field in the form associated with the attribute having errror
  get formField() {
    return this.attributeTargets.find(element => {
      return element.dataset.formAttribute === this.errorAttribute;
    });
  }

  get template() {
    return document.querySelector("#invalidFeedback");
  }

  // Create a list of error messages
  get errorMessages() {
    // Creating array of Nodes since Nodes themselves are not itearable
    return this.messageNodes.map(node => {
      return `${this.errorAttribute.snakecase_to_sentence().titleize()} ${
        node.dataset.errorMessage
      }`;
    });
  }

  // Assign error message to node cloned from the template
  addErrorMessage(errorMessage) {
    const clone = this.template.content.cloneNode(true);
    const div = clone.querySelector("div");
    div.textContent = errorMessage;
    this.formField.after(clone);
  }
}
