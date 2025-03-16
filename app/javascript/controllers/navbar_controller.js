import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggleMenu() {
    this.menuTarget.classList.toggle('active')
  }

  closeMenu() {
    this.menuTarget.classList.remove('active')
  }
}
