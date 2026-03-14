import { Controller } from "@hotwired/stimulus"

// Met à jour l'affichage de la valeur d'un range input (ex: qualité JPG/WebP)
// Usage: data-controller="quality-range" avec data-quality-range-target="input" et "output"
export default class extends Controller {
  static targets = ["input", "output"]

  connect() {
    this.updateOutput()
  }

  updateOutput() {
    if (this.hasInputTarget && this.hasOutputTarget) {
      this.outputTarget.textContent = this.inputTarget.value
    }
  }
}
