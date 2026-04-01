import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "scrollProgress"]

  connect() {
    document.addEventListener('click', this.handleOutsideClick.bind(this))
    this._scrollHandler = this.updateScrollProgress.bind(this)
    window.addEventListener('scroll', this._scrollHandler, { passive: true })
  }

  disconnect() {
    document.removeEventListener('click', this.handleOutsideClick.bind(this))
    window.removeEventListener('scroll', this._scrollHandler)
  }

  updateScrollProgress() {
    const scrollTop = window.scrollY
    const docHeight = document.documentElement.scrollHeight - window.innerHeight
    const progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0
    this.scrollProgressTarget.style.width = `${progress}%`
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
