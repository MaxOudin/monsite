import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "form"]
  static values = {
    minLength: Number,
    maxLength: Number,
    delay: { type: Number, default: 200 },
    lastQuery: { type: String, default: "" }
  }

  connect() {
    this.enforceMaxLength()
    const query = this.currentQuery()
    if (query.length >= this.minLengthValue) this.lastQueryValue = query
  }

  disconnect() {
    this.clearTimer()
  }

  search() {
    this.enforceMaxLength()
    this.clearTimer()
    this.timer = setTimeout(() => this.submit(), this.delayValue)
  }

  clear(event) {
    event.preventDefault()
    this.clearTimer()
    this.inputTarget.value = ""
    this.inputTarget.focus()
    this.submit()
  }

  submit() {
    const query = this.currentQuery()

    if (query.length > 0 && query.length < this.minLengthValue) {
      if (this.lastQueryValue === "") return

      this.visit("")
      return
    }

    this.visit(query)
  }

  visit(query) {
    if (query === this.lastQueryValue) return

    const isFirstSearch = this.lastQueryValue === "" && query !== ""
    this.formTarget.dataset.turboAction = isFirstSearch ? "advance" : "replace"
    this.lastQueryValue = query

    if (query === "") {
      this.submitWithoutQuery()
      return
    }

    this.formTarget.requestSubmit()
  }

  submitWithoutQuery() {
    const input = this.inputTarget
    const name = input.getAttribute("name")
    input.removeAttribute("name")
    this.formTarget.requestSubmit()
    if (name) input.setAttribute("name", name)
  }

  currentQuery() {
    return this.inputTarget.value.trim()
  }

  enforceMaxLength() {
    const value = this.inputTarget.value
    if (value.length <= this.maxLengthValue) return

    this.inputTarget.value = value.slice(0, this.maxLengthValue)
  }

  clearTimer() {
    if (this.timer) clearTimeout(this.timer)
  }
}
