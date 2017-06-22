	<?php 
		$needed_files = array("iCheck", "knockout", "daterangepicker", "moment", "dataTables", "datepicker");
		$page_title = "Loan Accounts";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
	?>
	<div class="row">
		<div class="col-lg-8">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>Loan Accounts <small>loans list</small></h5>
				  <div class="pull-right"><a href="#add_loan_account" class="btn btn-sm btn-info" data-toggle="modal"><i class="fa fa-edit"></i> New Loan Application</a>
					<!-- select id="loan_types" class="form-control">
					  <option>All loans</option>
					  <option value="1" <?php echo (isset($_GET['type'])&&$_GET['type']==1)?"selected":"";?>>Performing loans</option>
					  <option value="2" <?php echo (isset($_GET['type'])&&$_GET['type']==2)?"selected":"";?>> Non Performing</option>
					  <option value="3" <?php echo (isset($_GET['type'])&&$_GET['type']==3)?"selected":"";?>> Active loans</option>
					  <option value="4" <?php echo (isset($_GET['type'])&&$_GET['type']==4)?"selected":"";?>> Due loans</option>
					</select -->
				  </div>
				</div>
				<?php include_once("add_loan_account.php");?>
				<div class="ibox-content">
					<ul class="nav nav-tabs">
						<li><a data-toggle="tab" href="#tab-1"><i class="fa fa-list"></i> Applications</a></li>
						<li><a data-toggle="tab" href="#tab-2" class="text-danger"><i class="fa fa-times"></i> Rejected</a></li>
						<li class="active"><a data-toggle="tab" href="#tab-3"><i class="fa fa-check-circle-o"></i> Approved</a></li>
					</ul>
					<div class="tab-content">
						<div id="tab-1" class="tab-pane">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="applications" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys = array("Loan No", "Client", "Loan Product","Appn Date", "Amount Requested");
												if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&&$_SESSION['executive_board'])) array_push($header_keys,"Approval");
												foreach($header_keys as $key){ ?>
													<th><?php echo $key; ?></th>
													<?php
												}
												?>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<div id="tab-2" class="tab-pane">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="rejected" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys = array("Loan No", "Client", "Loan Product","Appn Date", "Amount Requested");
												foreach($header_keys as $key){ ?>
													<th><?php echo $key; ?></th>
													<?php
												}
												?>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<div id="tab-3" class="tab-pane active">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="approved" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys = array("Loan No", "Client", "Loan Product","Appn Date", "Duration", "Loan Amount", "Amount Paid", "Interest");
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
												<th colspan="5">Total (UGX)</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>  
			</div>
		</div>
		<div class="col-lg-4">
			<div class="ibox " data-bind="with: account_details">
				<div class="ibox-title">
					<h5 data-bind="text:  'Account Details'+' ('+ loanNo + ')'"></h5>
				</div>
				<div class="ibox-content">
					<div id="account_details">
						<div class="full-height-scroll">
							<ul class="list-group clear-list">
								<li class="list-group-item fist-item">
									<span class="pull-right" data-bind="text: clientNames"> Matovu Gideon </span>
									<strong>Client</strong>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: loanNo"> 0439374938 </span>
									<strong>Account No.</strong>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: productName"> Development </span>
									<strong>Loan Product</strong>
								</li>
								<li class="list-group-item" data-bind="">
								<!-- ko if: status==3-->
									<a class="btn btn-info btn-sm" href='#make_payment-modal' data-toggle="modal"><i class="fa fa-edit"></i> Make Payment </a>
								<!-- /ko -->
								<?php if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&&$_SESSION['executive_board'])):?>
								<!-- ko if: status==1-->
									<a class="btn btn-warning btn-sm" href='#approve_loan-modal' data-toggle="modal"><i class="fa fa-edit"></i> Approve Loan </a>
								<!-- /ko -->
								<?php endif;?>
								</li>
							</ul>
							<div class="row m-b-lg" data-bind="if: status==2">
								<strong>Comments</strong>
								<p data-bind="text: approvalNotes"></p>
							</div>
							<div class="row m-b-lg" data-bind="if: $parent.transactionHistory().length>0">
								<div class="table-responsive">
									<table class="table table-condensed table-striped">
										<caption>Transactions History</caption>
										<thead>
											<tr>
												<th>Transaction Date</th>
												<th>Type</th>
												<th>Notes</th>
												<th>Amount</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: $parent.transactionHistory">
											<tr>
												<td data-bind="text: moment(transactionDate, 'X').format('DD-MMM-YYYY')"></td>
												<td>payment</td>
												<td data-bind="text: comments"></td>
												<td data-bind="text: curr_format(parseInt(amount))"></td>
											</tr>
										</tbody>
										<tfoot>
											<th>Total (UGX)</th>
											<th>&nbsp;</th>
											<th>&nbsp;</th>
											<th data-bind="text: curr_format(parseInt(array_total($parent.transactionHistory(),2)))">&nbsp;</th>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<?php include_once("make_payment_modal.php");?>
		<?php include_once("loan_approval_modal.php");?>
	</div>	
<?php 
 include("include/footer.php");
 ?>
<!-- Datatables -->
<script>
	var user_props = <?php echo json_encode($_SESSION); ?>;
	var dTable = new Object();
	$(document).ready(function() {
	var handleDataTableButtons = function() {
	  if ($("#applications").length) {
		dTable['applications'] = $('#applications').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "ajax": {
			  "url":"ajax_data.php",
			  "type": "POST",
			  "data":  {origin :'loan_applications'}
		  },
		  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}} 
				<?php if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&&$_SESSION['executive_board'])){?>,
				{ data: 'id', render: function ( data, type, full, meta ) {
					var authorized =  false;
					if(user_props['branch_credit']&&parseInt(full.requestedAmount)<1000001){
						authorized = true;
					}
					if(user_props['management_credit']&&parseInt(full.requestedAmount)>1000000&&parseInt(full.requestedAmount)<5000001){
						authorized = true;
					}
					if(user_props['executive_board']&&parseInt(full.requestedAmount)>5000000){
						authorized = true;
					}
					return authorized?'<a href="#approve_loan-modal" class="btn  btn-warning btn-sm edit_me" data-toggle="modal"><i class="fa fa-edit"></i> Approve </a>':'';}}
				<?php }?>
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
	  if ($("#rejected").length) {
		dTable['rejected'] = $('#rejected').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "ajax": {
			  "url":"ajax_data.php",
			  "type": "POST",
			  "data":  {origin : 'rejected', type : <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>}
		  },
		  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}
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
	  if ($("#approved").length) {
		dTable['approved'] = $('#approved').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "processing": true,
		  "serverSide": true,
		  "deferRender": true,
		  "ajax": {
			  "url":"server_processing.php",
			  "type": "POST",
			  "data":  function(d){
				d.page = 'loan_accounts';
				d.type = <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>; //loan_type for the datatable;
				d.start_date = <?php echo isset($_GET['s_dt'])?"'{$_GET['s_dt']}'":"moment().subtract(30, 'days').format('X')"; ?>;
				d.end_date = <?php echo isset($_GET['e_dt'])?"'{$_GET['e_dt']}'":"moment().format('X')"; ?>;
				}
		  },
		  "initComplete": function(settings, json) {
				$(".table#approved tbody>tr:first").trigger('click');
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api(), cols = [5,6,7];
			$.each(cols, function(key, val){
				var total = api.column(val).data().sum();
				$(api.column(val).footer()).html( curr_format(total) );
			});
		  },columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'repaymentsMadeEvery', render: function ( data, type, full, meta ) {return ((full.repaymentsFrequency)*parseInt(full.repaymentsFrequency)) + ' ' + getDescription(4,data);}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
				{ data: 'amountPaid', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
				{ data: 'interest', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}
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
	  
	$('.table tbody').on('click', 'tr .delete_me', function () {
		var confirmation = confirm("Are sure you would like to delete this loan application?");
		if(confirmation){
			var tbl;
			var id;
			var d_id = $(this).attr("id")
			var arr = d_id.split("-");
			id = arr[0];//This is the row id
			tbl = arr[1]; //This is the table to delete from 
			 $.ajax({ // create an AJAX call...
				type: 'POST',
				url: "delete.php",
				data: {id:id, tbl:tbl}, // the file to call
				success: function(response) { // on success..
					showStatusMessage(response, "success");
					setTimeout(function(){
						dTable['applications'].ajax.reload();
					}, 300);
				}			
			}); 
		}
	});
	$('.table#applications tbody').on('click', 'tr .edit_me', function () {
		var row = $(this).closest("tr[role=row]");
		if(row.length == 0){
			row = $(this).closest("tr").prev();
		}
		loanAccountModel.getLoanAccountDetails();
		edit_data(dTable['applications'].row(row).data(), "loanAccountApprovalForm"); 
	});

	$('.table tbody').on('click', 'tr[role=row]', function () {
		var tbl = $(this).parent().parent();
		var dt = dTable[$(tbl).attr("id")];
		var data = dt.row(this).data();
		loanAccountModel.account_details(data);
		loanAccountModel.amountApproved(parseInt(data.requestedAmount));
		//ajax to retrieve transactions history//
		getTransactionHistory(data.id);
	});
	
	 function getTransactionHistory(loanAccountId){
		 $.ajax({
			url: "ajax_data.php",
			data: {id:loanAccountId, origin:'loan_account_transactions'},
			type: 'POST',
			dataType: 'json',
			success: function (response) {
				loanAccountModel.transactionHistory(response);			
			}
		});
	 }
</script>
<?php
 require_once("js/loanAccount.php");
 ?>