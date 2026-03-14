import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "uploadPhase", "processingPhase", "resultPhase", "errorPhase",
    "processingImage", "scanLine", "overlay",
    "compareContainer", "resultImage", "originalImage", "originalClip", "slider",
    "downloadLink", "errorMessage"
  ]

  connect() {
    this.comparing = false
    this.boundCompare = this.moveCompare.bind(this)
    this.boundStopCompare = this.stopCompare.bind(this)
  }

  async process() {
    const input = this.element.querySelector('input[type="file"]')
    if (!input || !input.files.length) {
      alert("Veuillez sélectionner une image.")
      return
    }

    const file = input.files[0]

    // Read original for preview
    const originalUrl = await this.readFile(file)

    // Show processing phase
    this.showPhase("processing")
    this.processingImageTarget.src = originalUrl

    // Submit to server
    try {
      const formData = new FormData()
      formData.append("file", file)

      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

      const response = await fetch(this.postUrl, {
        method: "POST",
        headers: { "X-CSRF-Token": csrfToken, "Accept": "image/png" },
        body: formData
      })

      if (!response.ok) {
        const text = await response.text()
        throw new Error(text.includes("indisponible") ? "Service de détourage indisponible." : `Erreur ${response.status}`)
      }

      const blob = await response.blob()
      const resultUrl = URL.createObjectURL(blob)

      // Show result with before/after
      this.originalImageTarget.src = originalUrl
      this.resultImageTarget.src = resultUrl
      this.downloadLinkTarget.href = resultUrl
      this.downloadLinkTarget.download = file.name.replace(/\.[^.]+$/, "") + "-nobg.png"

      // Small delay for dramatic reveal
      await this.sleep(400)
      this.showPhase("result")

    } catch (error) {
      this.errorMessageTarget.textContent = error.message
      this.showPhase("error")
    }
  }

  get postUrl() {
    return "/tools/remove_bg"
  }

  // Before/After slider
  startCompare(event) {
    event.preventDefault()
    this.comparing = true
    document.addEventListener("mousemove", this.boundCompare)
    document.addEventListener("mouseup", this.boundStopCompare)
    document.addEventListener("touchmove", this.boundCompare)
    document.addEventListener("touchend", this.boundStopCompare)
    this.moveCompare(event)
  }

  moveCompare(event) {
    if (!this.comparing) return
    const rect = this.compareContainerTarget.getBoundingClientRect()
    const clientX = event.touches ? event.touches[0].clientX : event.clientX
    let x = (clientX - rect.left) / rect.width
    x = Math.max(0, Math.min(1, x))
    const pct = x * 100
    this.originalClipTarget.style.clipPath = `inset(0 ${100 - pct}% 0 0)`
    this.sliderTarget.style.left = `${pct}%`
  }

  stopCompare() {
    this.comparing = false
    document.removeEventListener("mousemove", this.boundCompare)
    document.removeEventListener("mouseup", this.boundStopCompare)
    document.removeEventListener("touchmove", this.boundCompare)
    document.removeEventListener("touchend", this.boundStopCompare)
  }

  reset() {
    this.showPhase("upload")
    const input = this.element.querySelector('input[type="file"]')
    if (input) input.value = ""
    // Reset upload zone preview
    const placeholder = this.element.querySelector('[data-upload-target="placeholder"]')
    const preview = this.element.querySelector('[data-upload-target="preview"]')
    if (placeholder) placeholder.classList.remove("hidden")
    if (preview) preview.classList.add("hidden")
  }

  showPhase(phase) {
    this.uploadPhaseTarget.classList.toggle("hidden", phase !== "upload")
    this.processingPhaseTarget.classList.toggle("hidden", phase !== "processing")
    this.resultPhaseTarget.classList.toggle("hidden", phase !== "result")
    this.errorPhaseTarget.classList.toggle("hidden", phase !== "error")
  }

  readFile(file) {
    return new Promise((resolve) => {
      const reader = new FileReader()
      reader.onload = (e) => resolve(e.target.result)
      reader.readAsDataURL(file)
    })
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
}
