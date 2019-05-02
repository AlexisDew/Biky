import flatpickr from 'flatpickr';
import { French } from "flatpickr/dist/l10n/fr.js"
import "flatpickr/dist/flatpickr.min.css"


const toggleDateInputs = function() {
  flatpickr.localize(flatpickr.l10ns.fr);

  const startDateInput = document.getElementById('booking_start_date');
  const endDateInput = document.getElementById('booking_end_date');

  if (startDateInput && endDateInput) {
    const unvailableDates = JSON.parse(document.querySelector('.widget-content').dataset.unavailable)

    flatpickr(startDateInput, {
      altInput: true,
      altFormat: "D j M Y",
      minDate: 'today',
      dateFormat: 'Y-m-d',
      disable: unvailableDates,
      // mode:'range',
      onChange: function(selectedDates, selectedDate) {
        let minDate = selectedDates[0];
        minDate.setDate(minDate.getDate());
        endDateCalendar.set('minDate', minDate);
      }
    });

    const endDateCalendar = flatpickr(endDateInput, {
      altInput: true,
      altFormat: "D j M Y",
      minDate: 'today',
      dateFormat: 'Y-m-d',
      disable: unvailableDates,
    });
  }
};

export { toggleDateInputs }
