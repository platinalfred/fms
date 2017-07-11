	<div class="row">
		<div class="col-lg-8">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>Savings Accounts <small>Deposits and withdraws</small></h5>
				  <div class="pull-right">
					<div><a href="#add_deposit_account" class="btn btn-sm btn-info" data-toggle="modal"><i class="fa fa-edit"></i>New Savings Account</a></div>
				  </div>
				</div>
				<div class="ibox-content">
					<div class="table-responsive">
						<table id="datatable-buttons" class="table table-striped table-bordered dt-responsive nowrap">
							<thead>
								<tr>
									<?php 
									$header_keys = array("Account No", "Client", "Account type","Open Date", "Deposits(UGX)", "Withdraws(UGX)"/* , "Action" */);
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
		<div class="col-lg-4" id="deposit_account_details">
			<div class="ibox " data-bind="with: account_details">
				<div class="ibox-title">
					<h5 data-bind="text:  'Account Details'+' ('+(productName+'-'+id).replace(/\s/g,'') + ')'"></h5>
				</div>
				<div class="ibox-content">
					<div class="tab-content">
						<div id="account_details" class="tab-pane active">
							<ul class="list-group clear-list">
								<li class="list-group-item fist-item">
									<span class="pull-right" data-bind="text: clientNames"> Matovu Gideon </span>
									<label>Client Names</label>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: (productName+'-'+id).replace(/\s/g,'')"> 0439374938 </span>
									<label>Account No.</label>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: productName"> Savings</span>
									<label>Savings Product</label>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: curr_format(parseInt((sumDeposited-sumWithdrawn)))"> balance</span>
									<label>Account Balance</label>
								</li>
							</ul>
							<?php 
							if(isset($_SESSION['accountant'])){ ?>
								<div class="row m-b-lg">
									<div class="hr-line-dashed"></div>
									
										<div class="col-md-6"><a class="btn btn-primary btn-sm" href='#enter_deposit' data-toggle="modal"><i class="fa fa-edit"></i> Enter Deposit </a></div>
										<div class="col-md-6"><a data-bind="attr: {href:((sumDeposited-sumWithdrawn)>0?'#enter_withdraw':undefined)}" class="btn btn-warning btn-sm" data-toggle="modal"><i class="fa fa-edit"></i> Withdraw Cash </a></div>
									
								</div>
							<?php
							}
							?>
							<div class="row m-b-lg" data-bind="if: $parent.transactionHistory().length>0">
								<div class="table-responsive">
									<table class="table table-condensed table-striped">
										<caption>Recent Transactions</caption>
										<thead>
											<tr>
												<th>Date</th>
												<!--<th>TransNo</th>-->
												<th>Deposit</th>
												<th>Withdraw</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: $parent.transactionHistory">
											<tr>
												<td data-bind="text: moment(dateCreated, 'X').format('DD-MMM-YYYY')"></td>
												<!--<td data-bind="text: id"></td>-->
												<td data-bind="text: ((transactionType==1)?curr_format(parseInt(amount)):'-')"></td>
												<td data-bind="text: ((transactionType==2)?curr_format(parseInt(amount)):'-')"></td>
											</tr>
										</tbody><!--
										<tfoot>
											<tr>
												<th>Total (UGX)</th>
												<th>&nbsp;</th>
												<th data-bind="text: curr_format(parseInt(sumUpAmount($parent.transactionHistory(),1)))">&nbsp;</th>
												<th data-bind="text: curr_format(parseInt(sumUpAmount($parent.transactionHistory(),2)))">&nbsp;</th>
											</tr>
										</tfoot>-->
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<?php include_once("add_deposit_account_modal.php");?>
			<?php include_once("enter_deposit.php");?>
			<?php include_once("enter_withdraw.php");?>
		</div>
	</div>	
