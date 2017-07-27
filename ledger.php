<div class="row" >
	<div class="col-lg-12" >
	<div class="ibox" id="ledger_data">
		<?php if(!isset($_GET['id'])):?>
		<div class="ibox-title" style="border-top:none;">
			<h5>Statement of Comprehensive Income</h5>
			<div class="ibox-tools">
				<a class="collapse-link">
					<i class="fa fa-chevron-down"></i>
				</a>
			</div>
		</div>
		<?php endif;?>
		<div class="ibox-content collapse in">
			<div class="row" data-bind="with: ledger_data">
				<div class="col-lg-6">
					<div class="panel-body">
						<div class="panel-group" id="accordion">
							<div class="panel panel-default">
								<?php if(isset($_GET['id'])):?>
								<div class="panel-heading">
									<h5 class="panel-title">
										<a data-toggle="collapse" href="#collapseOne" aria-expanded="true">Personal <small>Account</small></a>
									</h5>
								</div>
								<?php endif;?>
								<div id="collapseOne" class="panel-collapse collapse in" aria-expanded="true" style="">
									<?php if(isset($_GET['id'])):?>
									<table id="ledger" class="table table-condensed">
										<thead>
											<tr>
												<?php 
												$header_keys = array("&nbsp;", "Dr", "Cr");
												foreach($header_keys as $key){ ?>
													<th><?php echo $key; ?></th>
													<?php 
												} ?>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Subscriptions</th><td></td><td><span data-bind="text: subscriptions?curr_format(parseInt(subscriptions)):0">0.0</span></td>
											</tr>
											<tr>
												<th>Shares</th><td></td><td><span data-bind="text: (shares?curr_format(parseInt(shares)):0)">0.0</span></td>
											</tr>
											<tr>
												<th>Account Opening Balances</th><td></td><td id="deposits"><span data-bind="text: curr_format(parseInt(opening_balances))">0.0</span></td>
											</tr>
											<tr>
												<th>Deposits</th><td></td><td><span data-bind="text: deposits?curr_format(parseInt(deposits)):0">0.0</span></td>
											</tr>
											<tr>
												<th>Withdraws</th><td><span data-bind="text: withdraws?curr_format(parseInt(withdraws)):0">0.0</span></td><td></td>
											</tr>
										</tbody>
									</table>
									<?php else:?>
									<table class="table table-hover table-condensed table-bordered">
										<thead>
											<tr>
												<th>REVENUES &amp; GAINS</th>
												<th>UGX</th>
											</tr>
										</thead>
										<tbody id="ledger">
											<!--
											<tr>
												<td>Miscellaneous Income</td><td><span data-bind="text: (shares?curr_format(parseInt(shares)):0)">0.0</span></td>
											</tr> -->
											<tr>
												<td>Income from other sources</td><td><span data-bind="text: (other_income_sources?curr_format(parseInt(other_income_sources)):0)">0.0</span></td>
											</tr>
											<tr>
												<td>Shares</td><td><span data-bind="text: (shares?curr_format(parseInt(shares)):0)">0.0</span></td>
											</tr>
											<tr>
												<td>Subscriptions</td><td><span data-bind="text: subscriptions?curr_format(parseInt(subscriptions)):0">0.0</span></td>
											</tr>
											<tr>
												<td>Loan Processing Fees</td><td><span data-bind="text: (loan_account_fees?curr_format(parseInt(loan_account_fees)):0)">0.0</span></td>
											</tr>
											<tr>
												<td>Loan Application Fees</td><td><span data-bind="text: (loan_account_fees?curr_format(parseInt(loan_account_fees)):0)">0.0</span></td>
											</tr>
											
											<tr>
												<td>Interest from Loans</td><td><span data-bind="text: curr_format((loan_payments?parseInt(loan_payments):0)-((disbursedLoan.loanAmount?parseInt(disbursedLoan.loanAmount):0)+(disbursedLoan.interestAmount?parseInt(disbursedLoan.interestAmount):0)))">0.0</span></td>
											</tr>
										</tbody>
										<tfoot>
											<tr>
												<th>Total Revenues &amp; Gains</th><td><strong><span data-bind="text: curr_format((subscriptions?parseInt(subscriptions):0)+(other_income_sources?parseInt(other_income_sources):0)+(shares?parseInt(shares):0)+((loan_payments?parseInt(loan_payments):0)-((disbursedLoan.loanAmount?parseInt(disbursedLoan.loanAmount):0)+(disbursedLoan.interestAmount?parseInt(disbursedLoan.interestAmount):0))))">0.0</span></strong></td>
											</tr>
										</tfoot>
									</table>
									<?php endif;?>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="panel-body">
						<div class="panel-group" id="accordion">
							<div class="panel panel-default">
								<?php if(isset($_GET['id'])):?>
								<div class="panel-heading">
									<h5 class="panel-title">
										<a data-toggle="collapse" href="#collapseThree" class="" aria-expanded="true">Loans <small>Account</small></a>
									</h5>
								</div>
								<?php endif;?>
								<div id="collapseThree" class="panel-collapse collapse in" aria-expanded="true" style="">
									<?php if(isset($_GET['id'])):?>
									<table class="table table-condensed">
										<thead>
											<tr>
												<?php 
												$header_keys = array("&nbsp;", "Dr", "Cr");
												foreach($header_keys as $key){ ?>
													<th><?php echo $key; ?></th>
													<?php 
												} ?>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Principle</th><td><span data-bind="text: curr_format(parseInt(disbursedLoan.loanAmount))">0.0</span></td><td></td>
											</tr>
											<tr>
												<th>Expected Interest</th><td><span data-bind="text: curr_format(parseInt(disbursedLoan.interestAmount))">0.0</span></td><td></td>
											</tr>
											<tr>
												<th>Loan Processing Fees</th><td></td><td><span data-bind="text: curr_format(parseInt(loan_account_fees))">0.0</span></td>
											</tr>
											<tr>
												<th>Loan Payments</th><td></td><td><span data-bind="text: curr_format(parseInt(loan_payments))">0.0</span></td>
											</tr>
										</tbody>
									</table>
									<?php else:?>
									<table class="table table-hover table-condensed table-bordered">
										<thead>
											<tr>
												<th>EXPENSES &amp; LOSSES</th>
												<th>UGX</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>Write off loans</td><td>0</td>
											</tr>
											<tr>
												<td>Other Expenses</td><td><span data-bind="text: expenses?curr_format(parseInt(expenses)):0">0.0</span></td>
											</tr>
											<tr>
												<th>Total Expenses &amp; Losses</th><td><strong><span data-bind="text: expenses?curr_format(parseInt(expenses)):0">0.0</span></strong></td>
											</tr>
										</tbody>
										<tfoot>
											<tr>
												<th>NET INCOME</th><td><strong><span data-bind="text: curr_format((subscriptions?parseInt(subscriptions):0)+(other_income_sources?parseInt(other_income_sources):0)+(shares?parseInt(shares):0)+((loan_payments?parseInt(loan_payments):0)-((disbursedLoan.loanAmount?parseInt(disbursedLoan.loanAmount):0)+(disbursedLoan.interestAmount?parseInt(disbursedLoan.interestAmount):0)))-(expenses?parseInt(expenses):0))">0.0</span></strong></td>
											</tr>
										</tfoot>
									</table>
									<?php endif;?>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>