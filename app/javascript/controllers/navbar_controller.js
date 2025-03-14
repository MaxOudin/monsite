import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("navbar controller connected");
    
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.handleScroll)
    // Fermer le menu quand on clique en dehors
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll)
    document.removeEventListener('click', this.handleClickOutside)
  }

  toggleMenu(event) {
    event.stopPropagation() // Empêche la propagation du clic
    this.menuTarget.classList.toggle('active')
    document.body.classList.toggle('menu-open')
  }

  handleClickOutside(event) {
    // Si le menu est ouvert et qu'on clique en dehors du menu et du bouton
    if (this.menuTarget.classList.contains('active') &&
        !this.menuTarget.contains(event.target) &&
        !event.target.closest('.navbar-mobile-toggle')) {
      this.menuTarget.classList.remove('active')
      document.body.classList.remove('menu-open')
    }
  }

  handleScroll() {
    if (window.scrollY > 20) {
      this.element.classList.add('scrolled')
    } else {
      this.element.classList.remove('scrolled')
    }
  }

  // Fermer le menu quand on clique sur un lien
  closeMenu() {
    this.menuTarget.classList.remove('active')
    document.body.classList.remove('menu-open')
  }
}
