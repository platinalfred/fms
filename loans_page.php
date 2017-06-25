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
				<div class="ibox-content">
					<ul class="nav nav-tabs">
						<li><a data-toggle="tab" href="#tab-1"><i class="fa fa-list"></i> Applications</a></li>
						<li><a data-toggle="tab" href="#tab-2" class="text-danger"><i class="fa fa-times"></i> Rejected</a></li>
						<li><a data-toggle="tab" href="#tab-3"><i class="fa fa-check-circle-o"></i> Approved</a></li>
						<li class="active"><a data-toggle="tab" href="#tab-4"><i class="fa fa-check-circle-o"></i> Disbursed</a></li>
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
						<div id="tab-3" class="tab-pane">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="approved" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys = array("Loan No", "Client", "Loan Product","Appn Date", "Duration", "Requested Amount", "Amount Approved");
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
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
						<div id="tab-4" class="tab-pane active">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="disbursed" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys = array("Loan No", "Client", "Loan Product","Date Disbursed", "Duration", "Loan Amount", "Amount Paid", "Interest");
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
		<div class="col-lg-4" id="loan_account_details">
			<div class="ibox " data-bind="with: account_details">
				<div class="ibox-title">
					<h5 data-bind="text:  'Account Details'+' ('+ loanNo + ')'"></h5>
				</div>
				<div class="ibox-content">
					<div>
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
								<li class="list-group-item">
								<!-- ko if: status==4-->
									<a class="btn btn-info btn-sm" href='#make_payment-modal' data-toggle="modal"><i class="fa fa-edit"></i> Make Payment </a>
								<!-- /ko -->
								<!-- ko if: status==3 -->
									<a class="btn btn-warning btn-sm" href='#disburse_loan-modal' data-toggle="modal"><i class="fa fa-money"></i> Disburse Loan </a>
								<!-- /ko -->
								<?php if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&&$_SESSION['executive_board'])):?>
								<!-- ko if: status==1 -->
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
											<tr>
												<th>Total (UGX)</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th data-bind="text: curr_format(parseInt(array_total($parent.transactionHistory(),2)))">&nbsp;</th>
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		<?php include_once("add_loan_account_modal.php");?>
		<?php include_once("make_payment_modal.php");?>
		<?php include_once("loan_approval_modal.php");?>
		<?php include_once("disburse_loan_modal.php");?>
		</div>
	</div>	
