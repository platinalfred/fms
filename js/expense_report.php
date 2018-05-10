<script>
$(document).ready(function(){
	var  dTable;
	var handleDataTableButtons = function() {
		if ($("#expenses").length ) {
			dTable = $('#expenses').DataTable({
				dom: "lfrtipB",
				"processing": true,
				"serverSide": true,
				"deferRender": true,
				"order": [[ 1, 'asc' ]],
				"ajax": {
				  "url":"ajax_requests/find_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.page = 'view_expenses';
					}
				},"columnDefs": [ {
				  "targets": [0],
				  "orderable": false,
				  "searchable": false
				} , {
				  "targets": [0],
				  "orderable": false
				}],
				columns:[  
					{ data: 'expenseName'},
					{ data: 'amountUsed', render:function(data, type, full, meta ){ return curr_format(parseInt(data)); }},
					{ data: 'amountDescription'}, 
					{ data: 'staff_names'} , 
					{ data: 'expenseDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD MMM, YYYY');}} 
					] ,
				buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				/* {
				  extend: "csv",
				  className: "btn-sm"
				}, */
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

				"initComplete": function(settings, json) {
					/* ko.applyBindings(memberTableModel, $("#member_details")[0]);
					$(".table tbody>tr:first").trigger('click'); */
				},
				  "footerCallback": function (tfoot, data, start, end, display ) {
					var api = this.api(), cols = [1];
					$.each(cols, function(key, val){
						var total = api.column(val).data().sum();
						$(api.column(val).footer()).html( curr_format(total) );
					});
				  }
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
