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
			  }],
			  "footerCallback": function (tfoot, data, start, end, display ) {
				var api = this.api(), cols = [2,6,7,8,11,12,13,14,15, 16];
				$.each(cols, function(key, val){
					var total = api.column(val).data().sum();
					$(api.column(val).footer()).html( curr_format(total) );
				});
			  },
			  "autoWidth": false,
			  columns:[
				  { data: 'id'},
				  { data: 'clientNames'},
				  { data: 'disbursedAmount', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'installments'},
				  { data: 'principle', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'interest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'expInterest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'principle', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'feesPaid', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'paidInstallments', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'balInstallments'},
				  { data: 'paidPrinciple', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'interestPaid', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'interestPaid', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'paidPrinciple', render: function ( data, type, full, meta ) {return data?curr_format(parseInt(full.principle)-parseInt(data)):0;}},
				  { data: 'interestPaid', render: function ( data, type, full, meta ) {return data?curr_format(parseInt(full.exp_interest)-parseInt(data)):0;}},
				  { data: 'paidPrinciple', render: function ( data, type, full, meta ) {return data?curr_format((parseInt(full.principle)-parseInt(data))+(parseInt(full.exp_interest)-parseInt(data))):0;}}
					
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
			  ],
			  responsive: true,
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