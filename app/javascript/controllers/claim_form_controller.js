import { Controller } from "@hotwired/stimulus"

// Product-layer controller. "Type-it-not-click-it" per SPEC-prototype-review-environment.md §5:
// the field accepts anything and doesn't validate — this only swaps in the acknowledged state.
export default class extends Controller {
  static targets = ["pending", "success"]

  submit(event) {
    event.preventDefault()
    this.pendingTarget.classList.add("hidden")
    this.successTarget.classList.remove("hidden")
  }
}
