import { Controller } from "@hotwired/stimulus"

// Global keyboard shortcuts for chat application
export default class extends Controller {
  connect() {
    this.boundHandler = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandler)
  }

  handleKeydown(event) {
    // Ignore if user is typing in an input/textarea
    const target = event.target
    if (target.tagName === "INPUT" || target.tagName === "TEXTAREA" || target.isContentEditable) {
      return
    }

    // Cmd/Ctrl + K: New chat
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.createNewChat()
    }
  }

  createNewChat() {
    // Submit new chat form via click
    const form = document.querySelector("[data-new-chat-form]")
    if (form) {
      form.click()
    }
  }
}
