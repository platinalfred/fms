	//Date range picker
	var cb = function(start, end, label) {
		$('#reportrange span').html(start.format('D MMMM, YYYY') + ' - ' + end.format('D MMMM, YYYY'));
	};
   var optionSet1 = {
          startDate: moment().subtract(30, 'days'),
          endDate: moment(),
          minDate: '01/01/2012',
          maxDate: '12/31/2020',
          dateLimit: {
            months: 18
          },
          showDropdowns: true,
          showWeekNumbers: true,
          timePicker: false,
          timePickerIncrement: 1,
          timePicker12Hour: true,
          ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
            'Last 30 Days': [moment().subtract(30, 'days'), moment()],
            //'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
            'Full Records': [moment().subtract(1.5, 'year').startOf('month'), moment()]
          },
          opens: 'right',
          buttonClasses: ['btn btn-default'],
          applyClass: 'btn-small btn-primary',
          cancelClass: 'btn-small',
          format: 'DD/MM/YYYY',
          separator: ' to ',
          locale: {
            applyLabel: 'Submit',
            cancelLabel: 'Clear',
            fromLabel: 'From',
            toLabel: 'To',
            customRangeLabel: 'Custom',
            daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            firstDay: 1
          }
    };
		$('#reportrange span').html(moment().subtract(30, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
		
		$('#reportrange').daterangepicker(optionSet1, cb);
		
		$('#reportrange').on('show.daterangepicker', function() {
			//console.log("show event fired");
		});
		$('#reportrange').on('hide.daterangepicker', function() {
		//console.log("hide event fired");
		});
		$('#reportrange').on('apply.daterangepicker', function(ev, picker) {
				//when at the dashboard page
				dashModel.startDate(picker.startDate.format('X'));
				dashModel.endDate(picker.endDate.format('X'));
				dashModel.updateData();
		});
		$('#reportrange').on('cancel.daterangepicker', function(ev, picker) {
			console.log("cancel event fired");
		});
		$('#options1').click(function() {
			$('#reportrange').data('daterangepicker').setOptions(optionSet1, cb);
		});
		$('#options2').click(function() {
		$('#reportrange').data('daterangepicker').setOptions(optionSet2, cb);
		});
		$('#destroy').click(function() {
		$('#reportrange').data('daterangepicker').remove();
		});