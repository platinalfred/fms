	<div class="row">
		<div class="col-lg-8">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5><?php if(isset($_GET['grpLId'])){ ?>Group Loan <?php } else {?> Member <?php } ?> Loan <small><?php if(isset($_GET['grpLId'])):?>(Ref#<?php echo $_GET['grpLId'];?>) member accounts<?php else:?>accounts list<?php endif; ?></small> </h5>
					<?php 
					if(isset($_SESSION['loans_officer'])  || isset($_SESSION['admin'])){
						if(!isset($_GET['groupId']) && !isset($_GET['memberId'])){ ?>
						 <div class="pull-left" style="margin-left:10%;"><a href="groups.php" class="btn btn-sm btn-info" ><i class="fa fa-edit"></i> New Group Loan </a></div>
						 <?php 
						}
						 ?>
						 <div class="pull-right">
							<?php
							$loan_application_link = "#add_loan_account-modal"; //the href value of the anchor
							$anchor_text = "Add Individual Loan Account"; //the anchor text for display to the user
							if(isset($_GET['groupId'])&&!isset($_GET['grpLId']) && !isset($_GET['memberId'])){ //when viewing group loans
								$loan_application_link = "?groupId=". $_GET['groupId'] . "&task=loan.add";
								$anchor_text = "New group Loan";
							}
							if(isset($_GET['grpLId']) && !isset($_GET['groupId'])){
									$anchor_text = "Add Group Member Loan Account"; //the anchor text for display to the user
							}
							$data_toggle_text = "";
							if(!isset($_GET['groupId'])||isset($_GET['grpLId'])){ //when viewing loan accounts
								$data_toggle_text = "data-toggle=\"modal\"";
							}
							?>
							<a href="<?php echo $loan_application_link; ?>" class="btn btn-sm btn-info" <?php echo $data_toggle_text;?>><i class="fa fa-edit"></i> <?php echo $anchor_text; ?> </a>
						</div>
						<?php
					}
					?>
				</div>
				<div class="ibox-content m-b-sm border-bottom">
					<div class="row">
						<?php if(!(isset($_GET['view'])&&isset($_GET['groupId']))||isset($_GET['grpLId'])):?>
						<div class="col-md-4">
							<div class="form-group">
								<select id="loan_types" class="form-control">
								<?php
								if((isset($_SESSION['loans_officer'])&& $_SESSION['loans_officer'])||(isset($_SESSION['admin'])&& $_SESSION['admin'])){ ?>
								   <option value="1" <?php echo (isset($_GET['status'])&&$_GET['status']==1)?'selected':'';?>>Partial Application</option>
								   <?php } ?>
								<?php if((isset($_SESSION['admin'])&& $_SESSION['admin'])||(isset($_SESSION['branch_manager'])&&$_SESSION['branch_manager'])){ ?>
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
						<?php endif; ?>
						<?php if(!isset($_GET['grpLId'])):?>
						<div class="col-md-5">
							<div class="form-group">
								<div id="reportrange" style="background: #fff; cursor:pointer; padding: 5px 5px; border: 1px solid #ccc">
								  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
								  <span>December 30, 2016 - January 28, 2017</span> <b class="caret"></b>
								</div>
							</div>
						</div>
						<?php endif; ?>
					</div>
				</div>
				<div class="ibox-content">
					<div class="tab-content">
					<?php if(!(isset($_GET['view'])&&isset($_GET['groupId']))||isset($_GET['grpLId'])):?>
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
												$header_keys[$array_len-2] = "Amount Requested";
												$header_keys[$array_len-1] = "Date approved";
												$header_keys[$array_len] = "Amount Approved";
												$header_keys[$array_len+1] = "Payments Freq";
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
					<?php else: ?>
						<div id="tab-5" class="tab-pane active">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table id="groupLoans" class="table table-striped table-bordered dt-responsive nowrap">
										<thead>
											<tr>
												<?php 
												if(!isset($_GET['grpLId'])){$header_keys[] = "Group Loan Ref";}
												$header_keys[] = "Date applied";
												$header_keys[] = "Loan Product";
												$header_keys[] = "Max Possible Amount";
												$header_keys[] = "Amount Requested";
												$header_keys[] = "Members";
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
										<tfoot>
											<tr>
												<th>Total (UGX)</th>
												<th colspan="3">&nbsp;</th>
												<th>&nbsp;</th>
												<th colspan="2">&nbsp;</th>
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					<?php endif; ?>
					</div>
				</div>  
			</div>
		</div>
		<div class="col-lg-4" id="loan_account_details">
		<?php if(!(isset($_GET['view'])&&isset($_GET['groupId']))||isset($_GET['grpLId'])) :?>
			<div class="ibox " data-bind="with: account_details">
				<div class="ibox-title">
					<h5 >Account Details</h5>
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
									<span class="pull-right" data-bind="text: 'L'+parseInt(id).pad(11)"> Account No </span>
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
							<div class="row m-b-lg">
								<strong>Comments</strong>
								<p data-bind="text: comments"></p>
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
		<?php else: //End Loan account details section ?>
			<div class="ibox " data-bind="with: group_loan_account_details">
				<div class="ibox-title">
					<h5 data-bind="text:  'Group Loan Ref#'+' ('+ id + ')'"></h5>
				</div>
				<div class="ibox-content">
					<div>
						<div class="full-height-scroll">
							<ul class="list-group clear-list">
								<li class="list-group-item fist-item">
									<span class="pull-right" data-bind="text: productName">Loan Product </span>
									<strong>Loan Product</strong>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: maxAmount"> Product limit </span>
									<strong>Product limit</strong>
								</li>
								<li class="list-group-item">
									<span class="pull-right" data-bind="text: loanAmount"> Amount Borrowed </span>
									<strong>Amount Borrowed</strong>
								</li>
							</ul>
							<div class="row m-b-lg" data-bind="if: typeof(memberAccounts)!='undefined'">
								<div class="table-responsive">
									<table class="table table-condensed table-striped">
										<caption>Members</caption>
										<thead>
											<tr>
												<th>Names</th>
												<th>Amount Requested</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: memberAccounts">
											<tr>
												<td data-bind="text: memberNames"></td>
												<td data-bind="text: curr_format(parseFloat(requestedAmount))"></td>
											</tr>
										</tbody>
										<tfoot>
											<tr>
												<th>Total (UGX)</th>
												<th data-bind="text: curr_format(parseFloat(array_total($parent.memberAccounts(),1)))">&nbsp;</th>
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		<?php endif; //End Group Loan account details section ?>
		<?php if(!(isset($_GET['view'])&&isset($_GET['groupId']))||isset($_GET['grpLId'])) :?>
		<?php include_once("edit_loan_account_modal.php"); ?>
		<?php include_once("add_loan_account_modal.php"); ?>
		<?php include_once("make_payment_modal.php"); ?>
		<?php include_once("loan_approval_modal.php"); ?>
		<?php include_once("disburse_loan_modal.php"); //?>
		<?php endif; ?>
		</div>
	</div>	
