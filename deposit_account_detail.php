	<div id="deposit_account_details" class="row" data-bind="with: account_details">
		<div class="col-lg-4">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>Savings Account details <small data-bind="text:  '('+ loanNo + ')'"></small></h5>
				  <div class="pull-right"><a href="#add_loan_account" class="btn btn-sm btn-info" data-toggle="modal"><i class="fa fa-edit"></i> New Loan Application</a>
				  </div>
				</div>
				<div class="ibox-content">
					<div class="table-responsive">
						<table class="table table-bordered">
							<tbody>
								<tr> <th>Loan Account No. </th> <td data-bind="text: loanNo"></td> </tr>
								<tr> <th>Requested Amount</th> <td data-bind="text: curr_format(requestedAmount))"></td> </tr>
								<tr> <th>Application Date </th> <td data-bind="text: moment(applicationDate,'X').format('DD, MMM YYYY')"></td> </tr>
								<tr> <th>Received by </th> <td data-bind="text: createdBy"></td> </tr>
								<tr> <th>Approved Amount</th> <td data-bind="text: curr_format(parseInt(amountApproved))"></td> </tr>
								<tr> <th>Comments</th> <td data-bind="text: comments"></td> </tr>
								<tr> <th>Date approved</th> <td data-bind="text: moment(approvalDate,'X').format('DD, MMM YYYY')"></td> </tr>
								<tr> <th>Approval Notes</th> <td data-bind="text: approvalNotes"></td> </tr>
								<tr> <th>Approved by</th> <td data-bind="text: approvedBy"></td> </tr>
								<tr> <th>Disbursed Amount</th> <td data-bind="text: curr_format(parseInt(disbursedAmount))"></td> </tr>
								<tr> <th>Date disbursed</th> <td data-bind="text: moment(disbursementDate,'X').format('DD, MMM YYYY')"></td> </tr>
								<tr> <th>Notes/Comments</th> <td data-bind="text: disbursementNotes"></td> </tr>
								<tr> <th>Interest Rate</th> <td data-bind="text: interestRate"></td> </tr>
								<tr> <th>Duration</th> <td data-bind="text: ((repaymentsFrequency)*parseInt(installments)) + ' ' + getDescription(4,repaymentsMadeEvery)"></td> </tr>
								<tr> <th>Penalty Rate</th> <td data-bind="text: penaltyRate"></td> </tr>
								<tr> <th>Linked to Deposit Account</th> <td data-bind="text: linkToDepositAccount"></td> </tr>
								<tr> <th>Penalty Tolerance Period</th> <td data-bind="text: penaltyTolerancePeriod"></td> </tr>
								<tr> <th>Penalty Rate Charged Per</th> <td data-bind="text: penaltyRateChargedPer"></td> </tr>
							</tbody>
						</table>
					</div>
				</div>  
			</div>
		</div>
		<div class="col-lg-8">
			<div class="ibox">
				<div class="ibox-title">
					<h5>Account Statement</h5>
				</div>
				<div class="ibox-content">
					<div class="table-responsive">
						<table class="table table-bordered">
							<thead>
								<tr><th>Ref.</th><th>Description</th><th>Amount</th></tr>
							</thead>
							<tbody>
								<tr> <td> </td> <td> </td> <td data-bind="text: loanNo"></td> </tr>
							</tbody>
							<tfoot>
								<tr>
									<th>Data</th><th data-bind="">10,000</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>