import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropzone", "input", "placeholder", "preview", "previewImage", "fileName", "fileSize"]

  click() {
    this.inputTarget.click()
  }

  dragover(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("border-violet-500", "bg-gray-800/50")
  }

  dragleave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-violet-500", "bg-gray-800/50")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-violet-500", "bg-gray-800/50")

    const files = event.dataTransfer.files
    if (files.length > 0) {
      this.inputTarget.files = files
      this.showPreview(files[0])
    }
  }

  inputTargetConnected() {
    this.inputTarget.addEventListener("change", () => {
      if (this.inputTarget.files.length > 0) {
        this.showPreview(this.inputTarget.files[0])
      }
    })
  }

  showPreview(file) {
    if (this.hasPlaceholderTarget) this.placeholderTarget.classList.add("hidden")
    if (this.hasPreviewTarget) this.previewTarget.classList.remove("hidden")

    if (this.hasFileNameTarget) this.fileNameTarget.textContent = file.name
    if (this.hasFileSizeTarget) this.fileSizeTarget.textContent = this.formatSize(file.size)

    if (file.type.startsWith("image/") && this.hasPreviewImageTarget) {
      const reader = new FileReader()
      reader.onload = (e) => { this.previewImageTarget.src = e.target.result }
      reader.readAsDataURL(file)
    }
  }

  formatSize(bytes) {
    if (bytes < 1024) return bytes + " o"
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " Ko"
    return (bytes / (1024 * 1024)).toFixed(1) + " Mo"
  }
}