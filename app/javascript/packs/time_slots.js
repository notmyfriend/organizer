import M from 'materialize-css'

let currentDate = new Date();

let optionsFromDate = {
	minDate: currentDate,
	defaultDate: currentDate,
	setDefaultDate: true,
	autoClose: true,
	onSelect: function(el) {
		const ell = new Date(el);
		const setMM = ell.getDate();
		const setM = new Date(ell.setDate(setMM));
		setMinDateTo(setM);
	}
};

let optionsToDate = {
	minDate: currentDate,
    defaultDate: currentDate,
	setDefaultDate: true,
	autoClose: true,
};

let setMinDateTo = function(vad) {
	let instance = M.Datepicker.getInstance($("#to-date"));
	instance.options.minDate = vad;

	if (new Date(instance) < vad) {
		instance.setDate(vad);
		$("#to-date").val(instance.toString());
	}
};


let optionsFromTime = {
    twelveHour: false,
};

let optionsToTime = {
    twelveHour: false,
};

let correctTime = function() {
	let time = $(this).val() + ':00';
	let fromDate = $("#from-date").val();
	let date = new Date(fromDate + ' ' + time);
	let min = date.getMinutes();

	if (min % 10 == 0 || min % 10 == 5 ){
		return;
	} else if (min % 10 < 5) {
		date.setMinutes(min + (5 - (min % 5)));
	} else{
		date.setMinutes(min + (10 - (min % 10)));
	}
	
	if (this.id == 'to-time'){
		let fromTime = $('#from-time').val() + ':00';
		if (fromTime >= time){
			date = new Date(fromDate + ' ' + fromTime);
			date.setMinutes(date.getMinutes() + 5);
		}
	}
	$(this).val(date.toLocaleTimeString().slice(0, -3));
};

$('.timepicker').on('change', correctTime);



$(function() {
	$("#from-date").datepicker(optionsFromDate);
	$("#to-date").datepicker(optionsToDate);

    $("#from-time").timepicker(optionsFromTime);
	$("#to-time").timepicker(optionsToTime);
    
});

