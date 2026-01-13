import { Controller } from "@hotwired/stimulus"

// Auto-scrolls chat container to bottom when new messages arrive or chat switches
// Controller lives inside turbo-frame, reconnects on every frame load
export default class extends Controller {
  connect() {
    // Scroll on connect (fires on initial load and every turbo-frame reload)
    this.scrollToBottom()
    setTimeout(() => this.scrollToBottom(), 50)
    setTimeout(() => this.scrollToBottom(), 150)

    this.observeMessages()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  // Scroll to bottom of container
  scrollToBottom() {
    const container = document.getElementById("chat-messages-container")
    if (!container) return
    container.scrollTop = container.scrollHeight
  }

  // Watch for new messages and auto-scroll
  observeMessages() {
    const messagesContainer = document.getElementById("messages")
    if (!messagesContainer) return

    this.observer = new MutationObserver(() => {
      const container = document.getElementById("chat-messages-container")
      if (!container) return

      const isNearBottom = container.scrollHeight - container.scrollTop - container.clientHeight < 150

      if (isNearBottom) {
        this.scrollToBottom()
      }
    })

    this.observer.observe(messagesContainer, {
      childList: true,
      subtree: true,
      characterData: true
    })
  }
}
