import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = [ "startDateTime" ]

  connect() {
    console.log(this.startDateTimeTarget)
    flatpickr(this.startDateTimeTarget, {
      // Flatpickr options here
      mode: "multiple",
      minDate: "today",
      dateFormat: "Y-m-d",
      defaultDate: this.startDateTimeTarget.dataset.selectedDates?.split(",") || []
    });
  }
}
