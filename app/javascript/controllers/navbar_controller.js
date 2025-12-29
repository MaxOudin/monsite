import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Fermer le menu si on clique en dehors
    document.addEventListener('click', this.handleOutsideClick.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleOutsideClick.bind(this))
  }

  toggleMenu() {
    const isOpen = this.menuTarget.classList.contains('max-h-screen')
    
    if (isOpen) {
      this.closeMenu()
    } else {
      this.openMenu()
    }
  }

  openMenu() {
    this.menuTarget.classList.remove('max-h-0')
    this.menuTarget.classList.add('max-h-screen')
  }

  closeMenu() {
    this.menuTarget.classList.remove('max-h-screen')
    this.menuTarget.classList.add('max-h-0')
  }

  handleOutsideClick(event) {
    if (this.menuTarget.classList.contains('max-h-screen') && 
        !this.element.contains(event.target)) {
      this.closeMenu()
    }
  }
}
