	
	<div id="deposit_account_details" class="row ">
		<div class="col-lg-6 pull-right hidden-print">
			<div class="col-lg-5 ">
				<button type="button" class="btn btn-sm btn-default">Excel</button>
				<button type="button" class="btn btn-sm btn-default">PDF</button>
				<button type="button" onClick="window.print();" class="btn btn-sm btn-default"><i class="fa fa-print"></i> Print</button>
			</div>
			<div class="col-lg-5 pull-right">
				<div class="form-group">
					<div id="reportrange" style="background: #fff; cursor:pointer; padding: 5px 10px; border: 1px solid #ccc">
					  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
					  <span>December 30, 2016 - January 28, 2017</span> <b class="caret"></b>
					</div>
				</div>
			</div>
			
		</div>
		<div class="clearboth"></div>
		<div class="ibox-content p-xl" data-bind="with: account_details">
			<div class="col-sm-12">
				<div class="row">
					<div class="col-sm-7">
								&nbsp;
					</div>
					<div class="col-sm-5 text-left">
						<div class="row"><div class="col-sm-7"><b>Period</b></div><div class="col-sm-5"data-bind="text: moment($parent.startDate(),'X').format('DD-MMM-YYYY') +' To '+moment($parent.endDate(),'X').format('DD-MMM-YYYY') "></div></div>
						<div class="clearboth"></div>
						<div class="row"><div class="col-sm-7"><b>Account No.</b></div><div class="col-sm-5" data-bind="text: (productName+'-'+id).replace(/\s/g,'')"></div></div>
						<div class="clearboth"></div>
						<div class="row"><div class="col-sm-7"><b>Current Balance</b></div><div class="col-sm-5" data-bind="text: curr_format(parseInt(sumUpAmount(statement,1))+parseInt(openingBalance)-parseInt(sumUpAmount(statement,2)))"></div></div>
						<div class="clearboth"></div>
						<div class="row"><div class="col-sm-7"><b>Opening Balance</b></div><div class="col-sm-5" data-bind="text: curr_format(parseInt(openingBalance))"></div></div>
						<div class="clearboth"></div>
						<div class="row"><div class="col-sm-7"><b>Opening Date</b></div><div class="col-sm-5" data-bind="text: moment(dateCreated,'X').format('DD-MMM-YYYY')"></div></div>
						<div class="clearboth"></div>
						<div class="row hidden-print" data-bind="if: interestRate>0"><div class="col-sm-7"><b>Interest Rate</b></div><div class="col-sm-5" data-bind="text: interestRate +'%'"></div></div>
						<div class="clearboth"></div>
						<div class="row hidden-print" data-bind="if: recomDepositAmount>0" ><div class="col-sm-7"><b>Recommended Deposit</b></div><div class="col-sm-5" data-bind="text: curr_format(parseInt(recomDepositAmount))"></div></div>
						<div class="clearboth"></div>
						<div class="row hidden-print" data-bind="if: maxWithdrawalAmount > 0" ><div class="col-sm-7"><b>Maximum Withdraw Limit</b></div><div class="col-sm-5" data-bind="text:curr_format(parseInt(maxWithdrawalAmount))"></div></div>
						<div class="clearboth"></div>
						<div class="row hidden-print" data-bind="if: termLength"><div class="col-sm-7"><b>Term Length Rate </b><sup data-toggle="tooltip" title="Period of time before which a client starts withdrawing from the account" data-placement="right"><i class="fa fa-question-circle"></i><sup></sup></sup></div><div class="col-sm-5" data-bind="text: termLength+' days'"></div></div>
					</div>
				
				</div>
				<div class="clearboth"></div>
				<div class="table-responsive m-t">
					<table class="table invoice-table">
						<thead>
							<tr>
								<th>Date</th>
								<th style="text-align:left;">Comment</th>
								<th>Cr</th>
								<th>Dr</th>
							</tr> 
						</thead>
						<tbody data-bind="foreach: statement">
							<tr>
								<td data-bind="text: moment(dateCreated, 'X').format('DD-MMM-YYYY')"></td>
								<td style="text-align:left;" data-bind="text: comment"></td>
								<td data-bind="text: ((transactionType==1)?curr_format(parseInt(amount)):'-')"></td>
								<td data-bind="text: ((transactionType==2)?curr_format(parseInt(amount)):'-')"></td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<th>Total (UGX)</th>
								<th>&nbsp;</th>
								<th style="text-align:right;" data-bind="text: curr_format(parseInt(sumUpAmount(statement,1)))">&nbsp;</th>
								<th style="text-align:right;" data-bind="text: curr_format(parseInt(sumUpAmount(statement,2)))">&nbsp;</th>
							</tr>
						</tfoot>
					</table>
				</div><!-- /table-responsive -->
			</div>
		</div>  
		<?php include_once("enter_deposit.php");?>
		<?php include_once("enter_withdraw.php");?>
	</div>