<!-- Datatables -->
<script>
var dTable = new Object();
var client_type = 0;
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
			  "url":"ajax_requests/server_processing.php",
			  "type": "POST",
			  "data":  function(d){
					d.page = 'deposit_accounts';
					<?php if(isset($client)):?> d.clientId=<?php echo $client['id'];?>; <?php endif;?>
					d.clientType = client_type; //client type;
					d.start_date = startDate;
					d.end_date = endDate;
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
				$(api.column(6).footer()).html(curr_format(actual_balance));
		  },columns:[ { data: 'id', render: function ( data, type, full, meta ) {
			  var page = "";
			  if(full.clientType==1){
				  page = "member_details.php?memberId=";
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
	<?php if(isset($_GET['view'])&&$_GET['view']=='allsavings'):?>
		$('#client_type').change(function(){handleDateRangePicker(startDate,endDate);});
	<?php endif;?>
});
<?php if(isset($_GET['view'])&&$_GET['view']=='allsavings'):?>
	 function handleDateRangePicker(start_date, end_date){
		 startDate = start_date;
		 endDate = end_date;
		client_type = parseInt($('#client_type').val());
		dTable.ajax.reload();
	 }
<?php endif;?>
 
</script>
