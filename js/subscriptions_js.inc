<script>
$(document).ready(function(){
	var dTable = new Object();
	var handleDataTableButtons = function() {
		/*Loans report */
	  	if ($("#general_subscription").length) {
			  dTable['tblLoanReport'] = $('#general_subscription').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"ajax_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  { origin: 'general_subscription'}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }],
			  "footerCallback": function (tfoot, data, start, end, display ) {
				  var api = this.api();
				$(api.column(1).footer()).html( curr_format( api.column(1).data().sum() ) );
			  } ,/* */
			  "autoWidth": false,
			  columns:[
				  { data: 'member_names'},
				  { data: 'amount', render: function(data, type, full, meta) {return curr_format(parseInt(data)); }},
				  { data: 'subscriptionYear'},
				  { data: 'datePaid', render: function(data, type, full, meta) {return moment(data, 'X').format('DD-MMM-YYYY'); }}
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