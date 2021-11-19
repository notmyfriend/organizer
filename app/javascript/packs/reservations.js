import M from 'materialize-css'

$(function() {
  
    let elems = document.querySelectorAll('.datepicker');

    let minDate = new Date();
    let maxDate = new Date(minDate.getFullYear(), minDate.getMonth() + 3, 0);

    let options = {
      minDate: minDate,
      maxDate: maxDate,
      defaultDate: minDate,
      setDefaultDate: true,
      autoClose: true,
    };
    $(".datepicker").datepicker(options);
  });
