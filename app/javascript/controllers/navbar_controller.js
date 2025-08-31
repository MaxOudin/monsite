import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.handleScroll)
    this.handleScroll() // Initial call
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll)
  }

  toggleMenu() {
    this.menuTarget.classList.toggle('active')
    document.body.classList.toggle('menu-open')
  }

  closeMenu() {
    this.menuTarget.classList.remove('active')
    document.body.classList.remove('menu-open')
  }

  handleScroll() {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    
    if (scrollTop > 100) {
      this.element.classList.add('scrolled')
    } else {
      this.element.classList.remove('scrolled')
    }
  }
}
