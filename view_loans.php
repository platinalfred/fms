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
				<div id="add_loan_account" class="modal fade" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-body">
								<?php include_once("add_loan_account.php");?>
							</div>
						</div>
					</div>
				</div>
				<div class="ibox-content">
					<ul class="nav nav-tabs">
						<li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-list"></i> Applications</a></li>
						<li><a data-toggle="tab" href="#tab-2"><i class="fa fa-clock-o"></i> Pending</a></li>
						<li><a data-toggle="tab" href="#tab-3"><i class="fa fa-check-circle-o"></i> Approved</a></li>
					</ul>
					<div class="tab-content">
						<div id="tab-1" class="tab-pane active">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="applications" class="table table-striped table-bordered dt-responsive nowrap">
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
						<div id="tab-2" class="tab-pane">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="pending" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys = array("Loan No", "Client", "Loan Product","Appn Date", "Amount Requested", "Approved Amount");
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
						<div id="tab-3" class="tab-pane">
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
												<!--th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th-->
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
					<h5 data-bind="text:  'Account Details'+' ('+(productName+'-'+id).replace(/\s/g,'') + ')'"></h5>
				</div>
				<div class="ibox-content">
					<div id="account_details">
						<div class="full-height-scroll">
							<strong>Details</strong>
							<ul class="list-group clear-list">
								<li class="list-group-item fist-item">
									<span class="pull-right" data-bind="text: clientNames"> Matovu Gideon </span>
									Client Names
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: (productName+'-'+id).replace(/\s/g,'')"> 0439374938 </span>
									Account No.
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: productName"> Development </span>
									Loan Product
								</li>
								<li class="list-group-item">
									<a class="btn btn-primary btn-sm" href='#make_payment' data-toggle="modal"><i class="fa fa-edit"></i> Make Payment </a>
								</li>
							</ul>
						<div class="row m-b-lg">
							<div class="hr-line-dashed"></div>
							<div class="col-md-6"></div>
							<div class="col-md-6"></div>
						</div>
						<div class="row m-b-lg" data-bind="if: $parent.transactionHistory().length>0">
							<div class="table-responsive">
								<table class="table table-condensed table-striped">
									<caption>Transactions History</caption>
									<thead>
										<tr>
											<th>Date</th>
											<th>TransNo</th>
											<th>Deposit</th>
											<th>Withdraw</th>
										</tr>
									</thead>
									<tbody data-bind="foreach: $parent.transactionHistory">
										<tr>
											<td data-bind="text: moment(dateCreated, 'X').format('DD-MMM-YYYY')"></td>
											<td data-bind="text: id"></td>
											<td data-bind="text: description"></td>
											<td data-bind="text: ((transactionType==2)?curr_format(parseInt(amount)):'-')"></td>
										</tr>
									</tbody>
									<tfoot>
										<th>Total (UGX)</th>
										<th>&nbsp;</th>
										<th data-bind="text: curr_format(parseInt(sumUpAmount($parent.transactionHistory(),1)))">&nbsp;</th>
										<th data-bind="text: curr_format(parseInt(sumUpAmount($parent.transactionHistory(),2)))">&nbsp;</th>
									</tfoot>
								</table>
							</div>
						</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="make_payment" class="modal fade" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-body">
						<?php include_once("enter_deposit.php");?>
					</div>
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
	  if ($("#applications").length) {
		dTable['applications'] = $('#applications').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "ajax": {
			  "url":"ajax_data.php",
			  "type": "POST",
			  "data":  {origin :'loan_applications'}
		  },columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
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
		//$("#datatable-buttons").DataTable();
	  }
	  if ($("#pending").length) {
		dTable['pending'] = $('#pending').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "ajax": {
			  "url":"ajax_data.php",
			  "type": "POST",
			  "data":  {origin : 'pending_approval', type : <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>}
		  },
		  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
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
</script>
<?php
 require_once("js/loanAccount.php");
 ?>