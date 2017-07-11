<script>
$(document).ready(function(){
	var dTable = new Object();
	var handleDataTableButtons = function() {
		/*Loans report */
	  	if ($("#loan_report").length) {
			  dTable['tblLoanReport'] = $('#loan_report').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"ajax_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  { origin: 'loan_report'}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  },{
				  "targets": [15],
				  "orderable": false,
				  "visible": false,
				  "searchable": false
			  }],
			  "footerCallback": function (tfoot, data, start, end, display ) {
				var api = this.api(), cols = [2,5,6,9,10,12];
				$.each(cols, function(key, val){
					var total = api.column(val).data().sum();
					$(api.column(val).footer()).html( curr_format(total) );
				});
				//outstanding principle
				var outstanding_principle = api.column(2).data().sum() - api.column(9).data().sum();
				$(api.column(11).footer()).html( curr_format( outstanding_principle ) );
				//outstanding interest
				var outstanding_interest = api.column(5).data().sum() - api.column(10).data().sum();
				$(api.column(12).footer()).html( curr_format( outstanding_interest ) );
				//total outstanding loan amount
				$(api.column(13).footer()).html( curr_format( outstanding_principle + outstanding_interest ) );
				//total miscellaneous income//
				
				var paid_amount = (api.column(15).data().sum());
				
				var loan_amount = (api.column(2).data().sum())+(api.column(5).data().sum());
				
				var misc_income = (paid_amount>loan_amount)?curr_format((paid_amount-loan_amount)):0;
				$(api.column(14).footer()).html( misc_income );
			  },
			  "autoWidth": false,
			  columns:[
				  { data: 'id'},
				  { data: 'clientNames'},
				  { data: 'disbursedAmount', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'principle', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'interest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'expInterest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'feesPaid', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'paidInstallments', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'balInstallments'},
				  { data: 'paidPrinciple', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'interestPaid', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'paidPrinciple', render: function ( data, type, full, meta ) {return data?curr_format(parseInt(full.disbursedAmount)-parseInt(data)):0;}},
				  { data: 'interestPaid', render: function ( data, type, full, meta ) {return data?curr_format(parseInt(full.expInterest)-(data?parseInt(data):0)):0;}},
				  { data: 'paidPrinciple', render: function ( data, type, full, meta ) {return data?curr_format((parseInt(full.disbursedAmount)-parseInt(data))+(parseInt(full.expInterest)-(full.interestPaid?parseInt(full.interestPaid):0))):0;}},
				  { data: 'amountPaid', render: function(data, type, full, meta) {
						var paid_amount = (data?parseInt(data):0);
						var loan_amount = (full.disbursedAmount?parseInt(full.disbursedAmount):0)+(full.expInterest?parseInt(full.expInterest):0);
						return (paid_amount>loan_amount)?curr_format((paid_amount-loan_amount)):0;
					  }
				  },
				  { data: 'amountPaid'}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
				{
				  extend: "excel",
				  className: "btn-sm"
				},
				{
				  extend: "pdfHtml5",
				  className: "btn-sm"
				},
				{
				  extend: "print",
				  className: "btn-sm"
				},
			  ]/* ,
			  responsive: true, */
			});
			//$("#datatable-buttons").DataTable();
		}
	};
	TableManageButtons = function() {
	  "use strict";
	  return {
		init: function() {
		  handleDataTableButtons();
		}
	  };
	}();
	
	TableManageButtons.init();
	
});
</script>