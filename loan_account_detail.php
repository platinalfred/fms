	<div id="loan_account_details">
		<div class="row" data-bind="with: account_details">
			<div class="col-lg-5">
				<div class="panel-body">
					<div class="panel-group" id="accordion">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h5 class="panel-title">
									<a data-toggle="collapse" href="#collapseTwo" class="" aria-expanded="true">Account details <small data-bind="text: '('+ loanNo + ')'"></small></a>
								</h5>
							</div>
							<div id="collapseTwo" class="panel-collapse collapse in" aria-expanded="true" style="">
								<div class="panel-body">
									<table class="table table-bordered">
										<tbody>
											<tr> <th>Loan Account No. </th> <td data-bind="text: loanNo"></td> </tr>
											<tr> <th>Requested Amount</th> <td data-bind="text: curr_format(parseInt(requestedAmount))"></td> </tr>
											<tr> <th>Application Date </th> <td data-bind="text: moment(applicationDate,'X').format('DD, MMM YYYY')"></td> </tr>
											<tr> <th>Received by </th> <td data-bind="text: createdBy"></td> </tr>
											<tr> <th>Interest Rate</th> <td data-bind="text: interestRate +'%'"></td> </tr>
											<tr> <th>Duration</th> <td data-bind="text: ((repaymentsFrequency)*parseInt(installments)) + ' ' + getDescription(4,repaymentsMadeEvery)"></td> </tr>
											<tr> <th>Comments</th> <td data-bind="text: comments"></td> </tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- ko if: status>1-->
						<div class="panel panel-default">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a data-toggle="collapse" href="#collapseOne" aria-expanded="false" class="collapsed">Approval</a>
								</h4>
							</div>
							<div id="collapseOne" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
								<div class="panel-body">
									<table class="table table-bordered">
										<tbody>
											<tr> <th>Approved Amount</th> <td data-bind="text: curr_format(parseInt(amountApproved))"></td> </tr>
											<tr> <th>Date approved</th> <td data-bind="text: moment(approvalDate,'X').format('DD, MMM YYYY')"></td> </tr>
											<tr> <th>Approval Notes</th> <td data-bind="text: approvalNotes"></td> </tr>
											<tr> <th>Approved by</th> <td data-bind="text: approvedBy"></td> </tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- /ko -->
						<!-- ko if: status>3-->
						<div class="panel panel-default">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a data-toggle="collapse" href="#collapseThree" class="collapsed" aria-expanded="false">Disbursement</a>
								</h4>
							</div>
							<div id="collapseThree" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
								<div class="panel-body">
									<table class="table table-bordered">
										<tbody>
											<tr> <th>Disbursed Amount</th> <td data-bind="text: curr_format(parseInt(disbursedAmount))"></td> </tr>
											<tr> <th>Date disbursed</th> <td data-bind="text: moment(disbursementDate,'X').format('DD, MMM YYYY')"></td> </tr>
											<tr> <th>Notes/Comments</th> <td data-bind="text: disbursementNotes"></td> </tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- /ko -->
						<div class="panel panel-default">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a data-toggle="collapse" href="#collapseFour" class="collapsed" aria-expanded="false">Penalties</a>
								</h4>
							</div>
							<div id="collapseFour" class="panel-collapse collapse" aria-expanded="false" style="height: 0px;">
								<table class="table table-bordered">
									<tbody>
										<tr> <th>Penalty Rate</th> <td data-bind="text: penaltyRate +'%'"></td> </tr>
										<tr> <th>Linked to Deposit Account</th> <td data-bind="text: (linkToDepositAccount==1)?'Yes':'No'"></td> </tr>
										<tr> <th>Penalty Tolerance Period</th> <td data-bind="text: penaltyTolerancePeriod + ' days'"></td> </tr>
										<tr> <th>Penalty Rate Charged Per</th> <td data-bind="text: penaltyRateChargedPer"></td> </tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-7">
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
				<div class="ibox">
					<div class="ibox-title">
						<h5>Account Statement</h5>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-up" style="color:#23C6C8;"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content">
						<div>
						</div>
						<div class="table-responsive">
							<table class="table table-condensed">
								<thead>
									<tr><th>Ref.</th><th>Date</th><th>Description</th><th>Cr</th><th>Dr</th></tr>
								</thead>
								<tbody data-bind="foreach: statement">
									<tr>
										<td data-bind="text: ref"> </td>
										<td data-bind="text: moment(transactionDate, 'X').format('DD, MMM YYYY')"> </td>
										<td data-bind="text: desc"> </td>
										<td data-bind="text: transactionType==1?curr_format(parseInt(amount)):'-'"> </td>
										<td data-bind="text: transactionType==2?curr_format(parseInt(amount)):'-'"></td>
									</tr>
								</tbody>
								<tfoot>
									<tr>
										<th>Total</th>
										<th colspan="2"></th>
										<th data-bind="text: curr_format(sumUpAmount(statement, 1))">10,000</th>
										<th data-bind="text: curr_format(sumUpAmount(statement, 2))">10,000</th>
									</tr>
								</tfoot>
							</table>
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