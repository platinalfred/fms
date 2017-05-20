<?php 
$show_table_js = false;
$page_title = "Dashboard";
$daterangepicker = true;
$needed_files = array();
//include("includes/file_includes_settings.php");
include("include/header.php"); 
?>
	<div class="wrapper wrapper-content" data-bind='with: dashboardData'>
		<div class="row">
			<div class="col-lg-4">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<span class="label label-primary pull-right">This period</span>
						<h5>Loans</h5>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-md-4">
								<h1 class="no-margins"><a href="view_loan_payments.php" title="Details" data-bind="text:figures.loan_portfolio">40,642</a></h1>
								<div class="font-bold text-navy"> <span data-bind="text: percents.loan_portfolio">44</span>% <i data-bind="css: { 'fa fa-level-down': percents.loan_portfolio < 1, 'fa fa-level-up': percents.loan_portfolio > 0}"></i> <small>Portfolio</small></div>
							</div>
							<div class="col-md-4">
								<h1 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text:figures.loan_payments">20,612</a></h1>
								<div class="font-bold text-navy"><span data-bind="text:percents.loan_payments">22</span>% <i data-bind="css: { 'fa fa-level-down': percents.loan_payments < 1, 'fa fa-level-up': percents.loan_payments > 0}"></i> <small>Payments</small></div>
							</div>
							<div class="col-md-4">
								<h1 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text:figures.loan_interest">20,612</a></h1>
								<div class="font-bold text-navy"><span data-bind="text:percents.loan_interest">22</span>% <i data-bind="css: { 'fa fa-level-down': percents.loan_interest < 1, 'fa fa-level-up': percents.loan_interest > 0}"></i> <small>Interest</small></div>
							</div>
						</div>

					</div>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>Loan Applications</h5>
						<!--div class="ibox-tools">
							<span class="label label-primary">Performances</span>
						</div-->
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-md-4">
								<h1 class="no-margins"><a href="view_loan_payments.php" title="Details" data-bind="text: figures.pending_loans">40,642</a></h1>
								<div class="font-bold text-navy"> <span data-bind="text: percents.pending_loans">44</span>% <i data-bind="css: { 'fa fa-level-down': percents.pending_loans < 1, 'fa fa-level-up': percents.pending_loans > 0}"></i> <small>Pending</small></div>
							</div>
							<div class="col-md-4">
								<h1 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text: figures.partial_loans">90,893</a></h1>
								<div class="font-bold text-navy"><span data-bind="text: percents.partial_loans">67</span>% <i data-bind="css: { 'fa fa-level-down': percents.pending_loans < 1, 'fa fa-level-up': percents.pending_loans > 0}"></i> <small>Partial</small></div>
							</div>
							<div class="col-md-4">
								<h1 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text: figures.approved_loans">206,12</a></h1>
								<div class="font-bold text-navy"><span data-bind="text: percents.approved_loans">22</span>% <i data-bind="css: { 'fa fa-level-down': percents.approved_loans < 1, 'fa fa-level-up': percents.approved_loans > 0}"></i> <small>Approved</small></div>
							</div>
						</div>
					</div>

				</div>
			</div>
			<div class="col-lg-2">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<!--span class="label label-success pull-right">Current</span-->
						<h5>Membership</h5>
					</div>
					<div class="ibox-content">
					<!--span data-bind='value: dashboard'></span-->
						<h1 class="no-margins"><a href="view_members.php" title="Details"><span data-bind='text: figures.no_members'>386,200</span></a></h1>
						<div class="stat-percent font-bold text-success"><span data-bind='text: percents.members_percent'>98</span>% <i data-bind="css: { 'fa fa-level-down': percents.members_percents < 1, 'fa fa-level-up': percents.members_percent > 0}"></i></div>
						<small>Total members</small>
					</div>
				</div>
			</div>
			<div class="col-lg-2">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<!--span class="label label-info pull-right">Annual</span-->
						<h5>Subscription</h5>
					</div>
					<div class="ibox-content">
						<h1 class="no-margins"><a href="view_subscriptions.php" title="Details" data-bind='text: figures.total_scptions'>80,800</a></h1>
						<div class="stat-percent font-bold text-info"><span data-bind='text: percents.scptions_percent'>20</span>% <i data-bind="css: { 'fa fa-level-down': percents.scptions_percent < 1, 'fa fa-level-up': percents.scptions_percent > 0}"></i></div>
						<small>Subscriptions</small>
					</div>
				</div>
			</div>

		</div>
		<div class="row">
			<div class="col-lg-8">
				<div class="ibox float-e-margins">
					<div class="ibox-content">
						<div>
							<span class="pull-right text-right">
								<small>Average value of sales for this : <strong>period</strong></small>
									<br/>
									Total product sales: 162,862
								</span>
							<h3 class="font-bold no-margins">
						Performance by Loan Products
					</h3>
							<small>Sales marketing.</small>
						</div>

						<div class="m-t-sm">

							<div class="row">
								<div class="col-md-8">
									<div>
										<canvas id="lineChart" height="114"></canvas>
									</div>
								</div>
								<div class="col-md-4">
									<ul class="stat-list m-t-lg">
										<li>
											<h2 class="no-margins">2,346</h2>
											<small>Total orders in period</small>
											<div class="progress progress-mini">
												<div class="progress-bar" style="width: 48%;"></div>
											</div>
										</li>
										<li>
											<h2 class="no-margins ">4,422</h2>
											<small>Orders in last month</small>
											<div class="progress progress-mini">
												<div class="progress-bar" style="width: 60%;"></div>
											</div>
										</li>
									</ul>
								</div>
							</div>

						</div>

						<div class="m-t-md">
							<small class="pull-right">
						<i class="fa fa-clock-o"> </i>
						Update on 16.07.2015
					</small>
							<small>
						<strong>Analysis of sales:</strong> The value has been changed over time, and last month reached a level over $50,000.
					</small>
						</div>

					</div>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<span class="label label-warning pull-right">Product revenue</span>
						<h5>Loan Products</h5>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-xs-4">
								<small class="stats-label">Pages / Visit</small>
								<h4>236 321.80</h4>
							</div>

							<div class="col-xs-4">
								<small class="stats-label">% New Visits</small>
								<h4>46.11%</h4>
							</div>
							<div class="col-xs-4">
								<small class="stats-label">Last week</small>
								<h4>432.021</h4>
							</div>
						</div>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-xs-4">
								<small class="stats-label">Pages / Visit</small>
								<h4>643 321.10</h4>
							</div>

							<div class="col-xs-4">
								<small class="stats-label">% New Visits</small>
								<h4>92.43%</h4>
							</div>
							<div class="col-xs-4">
								<small class="stats-label">Last week</small>
								<h4>564.554</h4>
							</div>
						</div>
					</div>
					<div class="ibox-content">
						<div class="row">
							<div class="col-xs-4">
								<small class="stats-label">Pages / Visit</small>
								<h4>436 547.20</h4>
							</div>

							<div class="col-xs-4">
								<small class="stats-label">% New Visits</small>
								<h4>150.23%</h4>
							</div>
							<div class="col-xs-4">
								<small class="stats-label">Last week</small>
								<h4>124.990</h4>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>

		<div class="row">

			<div class="col-lg-6">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>Expenses </h5>
						<span class="label label-primary">This period</span>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-up"></i>
							</a>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="#">Config option 1</a>
								</li>
								<li><a href="#">Config option 2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content">
						<div class="table-responsive">
							<table class="table table-striped">
								<thead>
									<tr>
										<th>#</th>
										<th>Description</th>
										<th>Amount</th>
										<th>Date</th>
									</tr>
								</thead>
								<tbody data-bind="foreach: tables.expenses">
									<tr>
										<td data-bind="text: id">1</td>
										<td data-bind="text: amountDescription"></td>
										<td data-bind="text: curr_format(amountUsed"></td>
										<td data-bind="text: moment(expenseDate).format('D MMMM, YYYY')"></td>
									</tr>
								</tbody>
								<tfoot data-bind="if: tables.expenses.length>0">
									<tr>
										<th scope='row'>Total</th>
										<th>&nbsp;</th>
										<th>&nbsp;</th>
										<th data-bind="text: curr_format(array_total(tables.expenses,2))"></th>
									</tr>
								</tfoot>
							</table>
						</div>

					</div>
				</div>
			</div>


			<div class="col-lg-6">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>Income </h5>
						<span class="label label-primary">This period</span>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-up"></i>
							</a>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="#">Config option 1</a>
								</li>
								<li><a href="#">Config option 2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content">
						<div class="table-responsive">
							<table class="table table-striped">
								<thead>
									<tr>
										<th>#</th>
										<th>Income type</th>
										<th>Amount</th>
										<th>Date</th>
									</tr>
								</thead>
								<tbody data-bind="foreach: tables.income">
									<tr>
										<td data-bind="text: id">1</td>
										<td data-bind="text: description"></td>
										<td data-bind="text: curr_format(amount)"></td>
										<td data-bind="text: moment(dateAdded).format('D MMMM, YYYY')"></td>
									</tr>
								</tbody>
								<tfoot data-bind="if: tables.income.length>0">
									<tr>
										<th scope='row'>Total</th>
										<th>&nbsp;</th>
										<th>&nbsp;</th>
										<th data-bind="text: curr_format(tables.income,2)"></th>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>

		</div>

	</div>
<?php 
include("include/footer.php"); 
?>