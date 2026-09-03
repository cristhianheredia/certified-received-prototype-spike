import { Controller } from "@hotwired/stimulus"

// Layer 2 (tooling). Drives the three review controls from
// SPEC-prototype-review-environment.md: device toggle (A), scenario selector (B),
// email/notification overlay (C). Deliberately has zero knowledge of product state —
// it only points an iframe at a URL and clones seeded <template> markup into a modal.
export default class extends Controller {
  static targets = [
    "frame", "mobileButton", "desktopButton",
    "mailButton", "badge", "overlay", "overlayPanel",
    "mailList", "mailReading", "mailReadingContent", "emailTemplate"
  ]
  static values = { mobileWidth: Number }

  connect() {
    this.setMobile()
  }

  // --- Control A: device toggle ---
  setMobile() {
    this.frameTarget.classList.remove("w-full", "max-w-3xl")
    this.frameTarget.classList.add("w-[390px]", "max-w-full")
    this._setActiveDeviceButton(this.mobileButtonTarget)
  }

  setDesktop() {
    this.frameTarget.classList.remove("w-[390px]")
    this.frameTarget.classList.add("w-full", "max-w-3xl")
    this._setActiveDeviceButton(this.desktopButtonTarget)
  }

  _setActiveDeviceButton(activeButton) {
    for (const button of [this.mobileButtonTarget, this.desktopButtonTarget]) {
      const isActive = button === activeButton
      button.classList.toggle("bg-tool-accent", isActive)
      button.classList.toggle("text-tool-surface", isActive)
    }
  }

  // --- Control B: scenario selector (URL-per-scenario, bookmarkable) ---
  selectScenario(event) {
    window.location = event.target.value
  }

  // --- Control C: email/notification overlay ---
  openMail() {
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
    this.backToList()
  }

  closeMail() {
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
  }

  closeMailOnBackdrop(event) {
    if (event.target === this.overlayTarget) this.closeMail()
  }

  openEmail(event) {
    const id = event.currentTarget.dataset.emailId
    const template = this.emailTemplateTargets.find((t) => t.dataset.emailId === id)
    if (!template) return

    this.mailReadingContentTarget.replaceChildren(template.content.cloneNode(true))
    this.mailListTarget.classList.add("hidden")
    this.mailReadingTarget.classList.remove("hidden")
  }

  backToList() {
    this.mailReadingTarget.classList.add("hidden")
    this.mailListTarget.classList.remove("hidden")
  }
}
