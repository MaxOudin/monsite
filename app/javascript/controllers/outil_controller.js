import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="outil"
export default class extends Controller {
  static targets = ["description"];

  connect() {
  }

  // Lorsque l'utilisateur clique sur la flèche, bascule entre display: none et display: block

  toggleDescription() {
    this.descriptionTargets.forEach((descriptionTarget) => {
      if (descriptionTarget === this.descriptionTarget) {
        // Si c'est l'élément actuel, basculez entre display: none et display: block
        descriptionTarget.style.display = (descriptionTarget.style.display === 'none') ? 'block' : 'none';
      }
    });
  }
}
