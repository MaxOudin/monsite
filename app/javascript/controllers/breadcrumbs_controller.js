import { Controller } from "@hotwired/stimulus"

// Contrôleur Stimulus pour gérer les interactions avec le fil d'ariane
// Usage: data-controller="breadcrumbs"
export default class extends Controller {
  static targets = ["link"]

  connect() {
    // Initialisation si nécessaire
    this.trackNavigation()
  }

  // Action : copier l'URL de la page actuelle
  // Usage: data-action="click->breadcrumbs#copyCurrentUrl"
  copyCurrentUrl(event) {
    event.preventDefault()
    const url = window.location.href

    navigator.clipboard.writeText(url).then(() => {
      this.showCopyFeedback(event.currentTarget)
    }).catch(err => {
      console.error('Erreur lors de la copie:', err)
    })
  }

  // Affiche un feedback visuel après la copie
  showCopyFeedback(element) {
    const originalText = element.textContent
    element.textContent = "✓ Copié !"
    element.classList.add("text-green-600")

    setTimeout(() => {
      element.textContent = originalText
      element.classList.remove("text-green-600")
    }, 2000)
  }

  // Track les clics sur les breadcrumbs (pour analytics)
  trackNavigation() {
    this.linkTargets.forEach((link, index) => {
      link.addEventListener("click", () => {
        this.sendAnalytics("breadcrumb_click", {
          position: index + 1,
          label: link.textContent.trim(),
          url: link.href
        })
      })
    })
  }

  sendAnalytics(eventName, data) {
    // Matomo Tag Manager
    // if (window._mtm) {
    //   window._mtm.push({
    //     event: eventName,
    //     ...data
    //   })
    // }

    // console.log('[Analytics]', eventName, data)
  }
}
