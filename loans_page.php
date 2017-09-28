	<div class="row">
		<div class="col-lg-8">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>Loan Accounts <small>loans list</small></h5>
					<?php 
					if(isset($_SESSION['loans_officer']) || isset($_SESSION['accountant']) || isset($_SESSION['admin'])){ ?>
						 <div class="pull-right">
							<a href="#add_loan_account-modal" class="btn btn-sm btn-info" data-toggle="modal"><i class="fa fa-edit"></i> New Loan Application</a>
						</div>
						<?php
					}
					?>
				</div>
				<div class="ibox-content m-b-sm border-bottom">
					<div class="row">
						<div class="col-sm-4">
							<div class="form-group">
								<label class="control-label" for="product_name">Loans</label>
								<select id="loan_types" class="form-control">
								<?php
								if((isset($_SESSION['loans_officer'])&& $_SESSION['loans_officer'])||(isset($_SESSION['admin'])&& $_SESSION['admin'])){ ?>
								   <option value="1" <?php echo (isset($_GET['status'])&&$_GET['status']==1)?'selected':'';?>>Partial Application</option>
								   <?php } ?>
								<?php if((isset($_SESSION['access_levels'])&& $_SESSION['access_levels'])||(isset($_SESSION['admin'])&& $_SESSION['admin'])||(isset($_SESSION['branch_manager'])&&$_SESSION['branch_manager'])){ ?>
								   <option value="2" <?php echo (isset($_GET['status'])&&$_GET['status']==2)?'selected':'';?>>Complete Application</option>
								   <?php } ?>
								<?php
								if(isset($_SESSION['access_levels'])&& !in_array(7, $_SESSION['access_levels'])){ ?>
									<option value="3" <?php echo (isset($_GET['status'])&&$_GET['status']==3)?'selected':'';?>>Pending</option>
								<?php } ?>
								    <option value="4" <?php echo (isset($_GET['status'])&&$_GET['status']==4)?'selected':'';?>>Approved</option>
								    <option value="5" <?php echo isset($_GET['status'])?(($_GET['status']==5)?'selected':''):'';?>>Active</option>
									<option value="6" <?php echo (isset($_GET['status'])&&$_GET['status']==6)?'selected':'';?>>Active/In Arrears</option>
									<option value="11" <?php echo (isset($_GET['status'])&&$_GET['status']==11)?'selected':'';?>>Closed/Rejected</option>
									<option value="12" <?php echo (isset($_GET['status'])&&$_GET['status']==12)?'selected':'';?>>Closed/Withdrawn</option>
									<?php
								if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&& $_SESSION['executive_board'])):?>
									<option value="13" <?php echo (isset($_GET['status'])&&$_GET['status']==13)?'selected':'';?>>Closed/Paid Off</option>
									<!--option value="14" <?php echo (isset($_GET['status'])&&$_GET['status']==14)?'selected':'';?>>Closed/Rescheduled</option-->
									<option value="15" <?php echo (isset($_GET['status'])&&$_GET['status']==15)?'selected':'';?>>Closed/Written Off</option>
									<!--option value="16" <?php echo (isset($_GET['status'])&&$_GET['status']==16)?'selected':'';?>>Closed/Refinanced</option-->
								<?php endif;?>
								</select >
							</div>
						</div>
						<div class="col-sm-5">
							<div class="form-group">
								<label class="control-label" for="principle">Select Period</label>
								<div id="reportrange" style="background: #fff; cursor:pointer; padding: 5px 10px; border: 1px solid #ccc">
								  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
								  <span>December 30, 2016 - January 28, 2017</span> <b class="caret"></b>
								</div>
							</div>
						</div>
						<div class="col-sm-2" style="padding-top:2%;">
							<!-- a  class="btn btn-sm btn-success" style="vertical-align:middle;" ><i class="fa fa-folder-open-o"></i> Show results</a-->
						</div>
					</div>

				</div>
				<div class="ibox-content">
					
					<div class="tab-content">
						<div id="tab-1" class="tab-pane">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="applications" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												$header_keys[] = "Loan No";
												$header_keys[] = "Client";
												if(!isset($_GET['groupId'])){$header_keys[] = "Group";}
												if(!isset($_GET['grpLId'])){$header_keys[] = "Group Loan Ref";}
												$header_keys[] = "Loan Product";
												$header_keys[] = "Appn Date";
												$header_keys[] = "Amount Requested";
												$header_keys[] = "Action";
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
												$array_len = count($header_keys);
												$header_keys[$array_len-1] = "Payments Freq";
												$header_keys[$array_len] = "Amount Approved";
												foreach($header_keys as $key=>$value){ ?>
													<th><?php echo $value; ?></th>
													<?php
												}
												?>
											</tr>
										</thead>
										<tbody>
										</tbody>
										<tfoot>
											<tr>
												<?php foreach($header_keys as $key=>$value){ ?>
												<th><?php echo ($key==0?("Total (UGX)"):""); ?></th>
												<?php } ?>
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
												$header_keys = array("Loan No", "Client", "Group", "Loan Product","Date Disbursed", "Loan Amount", "Installments", "Duration", "Interest Rate", "Principle", "Interest", "Total Installment", "Total Interest Expected", "Principle & Interest", "Amount Paid");
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
												<th colspan="3">&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
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
									<span class="pull-right" data-bind="text: clientNames"> Names </span>
									<strong>Client</strong>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: loanNo"> Account No </span>
									<strong>Account No.</strong>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: productName"> Loan Product </span>
									<strong>Loan Product</strong>
								</li>
								<li class="list-group-item">
									<?php include_once('loan_actions_section.php')?>
								</li>
							</ul>
							<div class="row m-b-lg" data-bind="if: status==2">
								<strong>Comments</strong>
								<p data-bind="text: approvalNotes"></p>
							</div>
							<div class="row m-b-lg" data-bind="if: typeof(transactionHistory)!='undefined'">
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
										<tbody data-bind="foreach: transactionHistory">
											<tr>
												<td data-bind="text: moment(transactionDate, 'X').format('DD-MMM-YYYY')"></td>
												<td>payment</td>
												<td data-bind="text: comments"></td>
												<td data-bind="text: curr_format(parseFloat(amount))"></td>
											</tr>
										</tbody>
										<tfoot>
											<tr>
												<th>Total (UGX)</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th data-bind="text: curr_format(parseFloat(array_total($parent.transactionHistory(),4)))">&nbsp;</th>
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		<?php include_once("edit_loan_account_modal.php"); ?>
		<?php include_once("add_loan_account_modal.php"); ?>
		<?php include_once("make_payment_modal.php"); ?>
		<?php include_once("loan_approval_modal.php"); ?>
		<?php include_once("disburse_loan_modal.php"); ?>
		</div>
	</div>	
