	<?php 
		$needed_files = array("iCheck", "knockout", "daterangepicker", "moment", "dataTables");
		$page_title = "Savings Accounts";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
	?>
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>Savings Accounts <small>Deposits and withdraws</small></h5>
				  <div class="pull-right">
					<div><a href="#add_deposit_account" class="btn btn-sm btn-info" data-toggle="modal"><i class="fa fa-edit"></i>New Savings Account</a></div>
				  </div>
				</div>
				<div id="add_deposit_account" class="modal fade" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-body">
								<?php include_once("add_deposit_account.php");?>
							</div>
						</div>
					</div>
				</div>
				<div class="ibox-content">
					<table id="datatable-buttons" class="table table-striped table-bordered dt-responsive nowrap">
						<thead>
							<tr>
								<?php 
								$header_keys = array("Account No", "Client", "Account type","Open Date", "Deposits(UGX)", "Withdraws(UGX)");
								foreach($header_keys as $key){ ?>
									<th><?php echo $key; ?></th>
									<?php
								}
								?>
							</tr>
						</thead>
						<tbody>
						</tbody>
						<tfoot>
							<tr>
								<th colspan="4">Total (UGX)</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
							</tr>
						</tfoot>
					</table>
				</div>  
			</div>
		</div>
	</div>	
<?php 
 include("include/footer.php");
 ?>
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
				d.type = <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>; //loan_type for the datatable;
				d.start_date = <?php echo isset($_GET['s_dt'])?"'{$_GET['s_dt']}'":"moment().subtract(30, 'days').format('X')"; ?>;
				d.end_date = <?php echo isset($_GET['e_dt'])?"'{$_GET['e_dt']}'":"moment().format('X')"; ?>;
				}
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api(), cols = [4,5];
			$.each(cols, function(key, val){
				var total = api.column(val).data().sum();
				$(api.column(val).footer()).html( curr_format(total) );
			});
		  },columns:[ { data: 'id', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&depositAccountId='+full.id+'" title="View details">'+full.productName + '-'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'dateCreated',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'sumWithdrawn', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}},
				{ data: 'sumDeposited', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}}
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
<?php 
include("js/depositAccount.php");
 ?>