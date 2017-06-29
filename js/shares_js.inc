<script>
$(document).ready(function(){
	var dTable = new Object();
	var handleDataTableButtons = function() {
		/*Loans report */
	  	if ($("#general_shares").length) {
			  dTable['tblLoanReport'] = $('#general_shares').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"ajax_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  { origin: 'general_shares'}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }],
			  /* "footerCallback": function (tfoot, data, start, end, display ) {
				var api = this.api(), cols = [2,6,7,8,11,12,13,14,15, 16];
				$.each(cols, function(key, val){
					var total = api.column(val).data().sum();
					$(api.column(val).footer()).html( curr_format(total) );
				});
			  } ,*/
			  "autoWidth": false,
			  columns:[
				  { data: 'member_names'},
				  { data: 'amount', render: function(data, type, full, meta) {return curr_format(parseInt(data)); }},
				  { data: 'total_shares', render: function(data, type, full, meta) {return curr_format(parseInt(data)); }}
				  /* ,
				  { data: 'datePaid', render: function(data, type, full, meta) {return moment(data, 'X').format('DD-MMM-YYYY'); }} */
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