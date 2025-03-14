import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.handleScroll)
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll)
  }

  toggleMenu() {
    this.menuTarget.classList.toggle('active')
    document.body.classList.toggle('menu-open')
  }

  handleScroll() {
    if (window.scrollY > 20) {
      this.element.classList.add('scrolled')
    } else {
      this.element.classList.remove('scrolled')
    }
  }
}
