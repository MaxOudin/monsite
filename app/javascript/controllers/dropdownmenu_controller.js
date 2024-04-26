import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    document.addEventListener('click', this.closeDropdown.bind(this));
  }

  toggleDropdown() {
    this.menuTarget.classList.toggle("visible");
  }

  closeDropdown(event) {
    if (!this.menuTarget.contains(event.target) && !this.element.contains(event.target)) {
      this.menuTarget.classList.remove("visible");
    }
  }
}
