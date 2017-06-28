	<div id="ledger" class="row">
		<div class="row" data-bind="with: ledger_data">
			<div class="col-lg-4">
				<div class="panel-body">
					<div class="panel-group" id="accordion">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h5 class="panel-title">
									<a data-toggle="collapse" href="#collapseOne" class="" aria-expanded="true">Personal <small>Account</small></a>
								</h5>
							</div>
							<div id="collapseOne" class="panel-collapse collapse in" aria-expanded="true" style="">
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
											<th>Subscriptions</th><td></td><td><span data-bind="text: curr_format(parseInt(subscriptions))">0.0</span></td>
										</tr>
										<tr>
											<th>Shares</th><td></td><td id="shares"><span data-bind="text: (shares?curr_format(parseInt(shares)):0)">0.0</span></td>
										</tr>
										<tr>
											<th>Account Opening Balances</th><td></td><td id="deposits"><span data-bind="text: curr_format(parseInt(opening_balances))">0.0</span></td>
										</tr>
										<tr>
											<th>Deposits</th><td></td><td><span data-bind="text: curr_format(parseInt(deposits))">0.0</span></td>
										</tr>
										<tr>
											<th>Withdraws</th><td><span data-bind="text: curr_format(parseInt(withdraws))">0.0</span></td><td></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="panel-body">
					<div class="panel-group" id="accordion">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h5 class="panel-title">
									<a data-toggle="collapse" href="#collapseTwo" class="" aria-expanded="true">Income Account</a>
								</h5>
							</div>
							<div id="collapseTwo" class="panel-collapse collapse in" aria-expanded="true" style="">
								<table id="income_account" class="table table-hover">
									<thead>
										<tr>
											<?php
											foreach($header_keys as $key){ ?>
												<th><?php echo $key; ?></th>
												<?php 
											} ?>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>Subscription</th><td></td><td><span data-bind="text: curr_format(parseInt(subscriptions))">0.0</span></td>
										</tr>
										<tr>
											<th>Deposits</th><td><span data-bind="text: curr_format(parseInt(deposits))">0.0</span></td><td></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="panel-body">
					<div class="panel-group" id="accordion">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h5 class="panel-title">
									<a data-toggle="collapse" href="#collapseThree" class="" aria-expanded="true">Loans Account</a>
								</h5>
							</div>
							<div id="collapseThree" class="panel-collapse collapse in" aria-expanded="true" style="">
								<table id="loans_account" class="table table-hover">
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
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>