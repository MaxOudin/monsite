import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown-menu"
export default class extends Controller {
  static targets = ["menu"];

  connect() {
  }

  toggleDropdown() {
    console.log("toggleDropdown");
    this.menuTarget.classList.toggle("visible");
  }
}
