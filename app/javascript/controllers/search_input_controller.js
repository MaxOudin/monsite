import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    placeholderMobile: String,
    placeholderDesktop: String
  }

  static targets = ["input"]

  connect() {
    this.updatePlaceholder()
    this.boundUpdatePlaceholder = this.updatePlaceholder.bind(this)
    window.addEventListener('resize', this.handleResize.bind(this))
  }

  disconnect() {
    if (this.resizeTimer) {
      clearTimeout(this.resizeTimer)
    }
    window.removeEventListener('resize', this.boundUpdatePlaceholder)
  }

  handleResize() {
    clearTimeout(this.resizeTimer)
    this.resizeTimer = setTimeout(() => this.updatePlaceholder(), 100)
  }

  updatePlaceholder() {
    if (!this.hasInputTarget) return

    const isMobile = window.innerWidth < 640 // sm breakpoint
    this.inputTarget.placeholder = isMobile 
      ? this.placeholderMobileValue 
      : this.placeholderDesktopValue
  }
}

