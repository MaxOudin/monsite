import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.boundHandleScroll = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.boundHandleScroll)
    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener('scroll', this.boundHandleScroll)
  }

  handleScroll() {
    if (window.scrollY > 300) {
      this.element.classList.remove('opacity-0', 'pointer-events-none', 'translate-y-2')
      this.element.classList.add('opacity-100', 'pointer-events-auto', 'translate-y-0')
    } else {
      this.element.classList.remove('opacity-100', 'pointer-events-auto', 'translate-y-0')
      this.element.classList.add('opacity-0', 'pointer-events-none', 'translate-y-2')
    }
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}
