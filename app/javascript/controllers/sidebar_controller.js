import { Controller } from "@hotwired/stimulus"

// Toggles mobile sidebar visibility with backdrop overlay
export default class extends Controller {
  static targets = ["menu", "backdrop"]

  connect() {
    this.boundClose = this.close.bind(this)
    document.addEventListener("turbo:load", this.boundClose)
    document.addEventListener("turbo:frame-load", this.boundClose)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.boundClose)
    document.removeEventListener("turbo:frame-load", this.boundClose)
  }

  toggle() {
    const isOpen = !this.menuTarget.classList.contains("hidden")
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    // Show backdrop with fade
    this.backdropTarget.classList.remove("hidden")
    this.backdropTarget.classList.add("animate-backdrop-in")

    // Show sidebar with slide
    this.menuTarget.classList.remove("hidden", "animate-sidebar-out")
    this.menuTarget.classList.add("flex", "animate-sidebar-in")

    // Focus sidebar for accessibility
    this.menuTarget.focus()
    document.body.classList.add("overflow-hidden")
  }

  close() {
    if (this.menuTarget.classList.contains("hidden")) return

    // Only animate on mobile
    if (window.innerWidth >= 768) return

    // Animate out
    this.menuTarget.classList.remove("animate-sidebar-in")
    this.menuTarget.classList.add("animate-sidebar-out")
    this.backdropTarget.classList.add("opacity-0")

    // Hide after animation completes
    setTimeout(() => {
      this.menuTarget.classList.add("hidden")
      this.menuTarget.classList.remove("flex", "animate-sidebar-out")
      this.backdropTarget.classList.add("hidden")
      this.backdropTarget.classList.remove("opacity-0", "animate-backdrop-in")
      document.body.classList.remove("overflow-hidden")
    }, 200)
  }

  // Close when clicking outside (on backdrop)
  closeOnBackdrop(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }

  // Close on Escape key
  closeOnEscape(event) {
    if (event.key === "Escape" && !this.menuTarget.classList.contains("hidden")) {
      event.preventDefault()
      this.close()
    }
  }
}
