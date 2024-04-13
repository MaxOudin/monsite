import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="outil"
export default class extends Controller {
  static targets = ["description"];
  // Lorsque l'utilisateur clique sur la flèche, bascule entre display: none et display: block

  toggleDescription() {
    this.descriptionTargets.forEach((descriptionTarget) => {
      if (descriptionTarget === this.descriptionTarget) {
        descriptionTarget.closest('.tool-description-container').classList.toggle('visible');
      }
    });
  }

}
