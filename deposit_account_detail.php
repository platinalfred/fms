	<div id="deposit_account_details" class="row">
		<div class="row" data-bind="with: account_details">
			<div class="col-lg-5">
				<div class="panel-body">
					<div class="panel-group" id="accordion">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h5 class="panel-title">
									<a data-toggle="collapse" href="#collapseTwo" class="" aria-expanded="true">Account details <small data-bind="text: (productName+'-'+id).replace(/\s/g,'')"></small></a>
								</h5>
							</div>
							<div id="collapseTwo" class="panel-collapse collapse in" aria-expanded="true" style="">
								<div class="panel-body">
									<table class="table table-bordered">
										<tbody>
											<tr> <th>Account No. </th> <td data-bind="text: (productName+'-'+id).replace(/\s/g,'')"></td> </tr>
											<tr> <th>Opening Balance</th> <td data-bind="text: curr_format(parseInt(openingBalance))"></td> </tr>
											<tr> <th>Opening Date </th> <td data-bind="text: moment(dateCreated,'X').format('DD, MMM YYYY')"></td> </tr>
											<tr data-bind="if: interestRate>0"> <th>Interest Rate</th> <td data-bind="text: interestRate +'%'"></td> </tr>
											<tr data-bind="if: recomDepositAmount>0"> <th>Recommended Deposit</th> <td data-bind="text: interestRate +'%'"></td> </tr>
											<tr data-bind="if: maxWithdrawalAmount>0"> <th>Withdrawal limit</th> <td data-bind="text: curr_format(parseInt((maxWithdrawalAmount))"></td> </tr>
											<tr data-bind="if: termLength"> <th>Term Length</th> <td data-bind="text: termLength"></td> </tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-7">
				<div class="col-md-6"></div>
				<?php 
				if(!isset($_SESSION['accountant'])){ ?>
					<div class="col-md-6"><a class="btn btn-primary btn-sm" href='#enter_deposit' data-toggle="modal"><i class="fa fa-edit"></i> Enter Deposit </a><a data-bind="attr: {href:((sumUpAmount(statement,1)-sumUpAmount(statement,2))>0?'#enter_withdraw':undefined)}" class="btn btn-warning btn-sm" data-toggle="modal"><i class="fa fa-edit"></i> Withdraw Cash </a></div>
				<?php 
				}else{
					
				}
				?>
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
									<tr>
										<th>Ref</th>
										<th>Date</th>
										<th>Dr</th>
										<th>Cr</th>
									</tr>
								</thead>
								<tbody data-bind="foreach: statement">
									<tr>
										<td data-bind="text: id"></td>
										<td data-bind="text: moment(dateCreated, 'X').format('DD-MMM-YYYY')"></td>
										<td data-bind="text: ((transactionType==1)?curr_format(parseInt(amount)):'-')"></td>
										<td data-bind="text: ((transactionType==2)?curr_format(parseInt(amount)):'-')"></td>
									</tr>
								</tbody>
								<tfoot>
									<tr>
										<th>Total (UGX)</th>
										<th>&nbsp;</th>
										<th data-bind="text: curr_format(parseInt(sumUpAmount(statement,1)))">&nbsp;</th>
										<th data-bind="text: curr_format(parseInt(sumUpAmount(statement,2)))">&nbsp;</th>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<?php include_once("enter_deposit.php");?>
		<?php include_once("enter_withdraw.php");?>
	</div>