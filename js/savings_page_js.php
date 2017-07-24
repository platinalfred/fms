<!-- Datatables -->
<script>
var dTable = new Object();
$(document).ready(function() {
	var handleDataTableButtons = function() {
	  if ($("#datatable-buttons").length) {
		dTable = $('#datatable-buttons').DataTable({
		  dom: "Bfrtip",
		  "order": [ [1, 'asc' ]],
		  "processing": true,
		  "serverSide": true,
		  "deferRender": true,
		  "ajax": {
			  "url":"server_processing.php",
			  "type": "POST",
			  "data":  function(d){
					d.page = 'deposit_accounts';
					<?php if(isset($client)):?> d.clientId=<?php echo $client['id'];?>; <?php endif;?>
					d.type = <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>; //loan_type for the datatable;
					d.start_date = <?php echo isset($_GET['s_dt'])?"'{$_GET['s_dt']}'":"moment().subtract(30, 'days').format('X')"; ?>;
					d.end_date = <?php echo isset($_GET['e_dt'])?"'{$_GET['e_dt']}'":"moment().format('X')"; ?>;
				}
		  },
		   "initComplete": function(settings, json) {
				$(".table tbody>tr:first").trigger('click');
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api(), cols = [4,5];
			$.each(cols, function(key, val){
				var total = api.column(val).data().sum();
				$(api.column(val).footer()).html( curr_format(total) );
			});
				//total miscellaneous income//
				
				var actual_balance = (api.column(4).data().sum())-(api.column(5).data().sum());
				
				//var misc_income = (paid_amount>loan_amount)?curr_format((paid_amount-loan_amount)):0;
				$(api.column(6).footer()).html(actual_balance);
		  },columns:[ { data: 'id', render: function ( data, type, full, meta ) {
			  var page = "";
			  if(full.clientType==1){
				  page = "member_details.php?id=";
			  }
			  if(full.clientType==2){
				  page = "group_details.php?id=";
			  }
			  return '<a href="'+page+full.clientId+'&view=savings_accs&depAcId='+data+'" title="View details">'+(full.productName + '-'+data).replace(/\s/g,'')+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'dateCreated',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'sumDeposited', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}},
				{ data: 'sumWithdrawn', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}},
				{ data: 'sumDeposited', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?(parseInt(data)-((full.sumWithdrawn)?parseInt(full.sumWithdrawn):0)):0));}}
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
		  responsive: true/*, */
		  
		});
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