import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["heading"]

  connect() {
    this.adjustTextSize()
    // Réajuster lors du redimensionnement de la fenêtre
    window.addEventListener('resize', this.adjustTextSize.bind(this))
  }

  disconnect() {
    window.removeEventListener('resize', this.adjustTextSize.bind(this))
  }

  adjustTextSize() {
    const heading = this.headingTarget
    const container = heading.parentElement
    const containerWidth = container.offsetWidth
    const textLength = heading.textContent.length

    // Réinitialiser d'abord
    heading.style.fontSize = ''

    // Si le texte est très long, ajuster la taille
    if (textLength > 50) {
      const baseFontSize = parseInt(window.getComputedStyle(heading).fontSize)
      const adjustmentFactor = Math.min(1, 50 / textLength)
      const newSize = Math.max(baseFontSize * adjustmentFactor, 18) // Minimum 18px

      heading.style.fontSize = `${newSize}px`
    }

    // Vérifier si le texte déborde encore après l'ajustement
    if (heading.scrollWidth > containerWidth) {
      const ratio = containerWidth / heading.scrollWidth
      const currentSize = parseInt(window.getComputedStyle(heading).fontSize)
      const newSize = Math.max(currentSize * ratio * 0.95, 18) // 5% de marge, minimum 18px

      heading.style.fontSize = `${newSize}px`
    }
  }
}
