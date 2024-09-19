import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = [ "source", "button" ]
  
  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value).then(() => {
      this.buttonTarget.textContent = "Copied!"
      setTimeout(() => {
        this.buttonTarget.textContent = "Copy Invitation Link"
      }, 2000)
    }).catch(err => {
      console.error('Failed to copy: ', err)
    })
  }
}
