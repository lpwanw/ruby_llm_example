import { Controller } from "@hotwired/stimulus"

// Manages active state highlighting in sidebar
export default class extends Controller {
  static targets = ["link"]
  static values = { activeClass: String }

  connect() {
    this.updateActiveState()
    this.boundUpdate = this.updateActiveState.bind(this)
    document.addEventListener("turbo:load", this.boundUpdate)
    document.addEventListener("turbo:frame-load", this.boundUpdate)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.boundUpdate)
    document.removeEventListener("turbo:frame-load", this.boundUpdate)
  }

  updateActiveState() {
    const currentPath = window.location.pathname
    const activeClasses = (this.activeClassValue || "bg-gray-700 text-white").split(" ")
    const inactiveClasses = ["text-gray-300", "hover:bg-gray-800", "hover:text-white"]

    this.linkTargets.forEach(link => {
      const href = link.getAttribute("href")
      const isActive = href === currentPath

      if (isActive) {
        link.classList.remove(...inactiveClasses)
        link.classList.add(...activeClasses)
      } else {
        link.classList.remove(...activeClasses)
        link.classList.add(...inactiveClasses)
      }
    })
  }
}
