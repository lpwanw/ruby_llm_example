import { Controller } from "@hotwired/stimulus"

// Handles chat message form submission and auto-resize
export default class extends Controller {
  static targets = ["input", "submit", "hint"]

  connect() {
    this.autoResize()
    this.toggleHint()
  }

  // Submit form on Enter (Shift+Enter for newline)
  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      if (this.inputTarget.value.trim() !== "") {
        this.element.requestSubmit()
      }
    }
  }

  // Auto-resize textarea based on content
  autoResize() {
    const input = this.inputTarget
    input.style.height = "auto"
    input.style.height = Math.min(input.scrollHeight, 200) + "px"
    this.toggleHint()
  }

  // Toggle hint visibility based on input content
  toggleHint() {
    if (!this.hasHintTarget) return
    const hasContent = this.inputTarget.value.length > 0
    this.hintTarget.classList.toggle("opacity-0", hasContent)
  }

  // Reset form after submission
  reset() {
    this.inputTarget.value = ""
    this.inputTarget.style.height = "auto"
    this.inputTarget.focus()
    this.toggleHint()
  }
}
