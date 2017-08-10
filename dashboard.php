<?php
/*
	include specific plugin files that you need on a page by  adding the names as below in the array
	dataTables, ChartJs,iCheck,daterangepicker,clockpicker,colorpicker,datapicker,easypiechart,fullcalendar,idle-timer,morris, nouslider, summernote,validate,wow,video,touchspin,Sparkline,Flot, Peity, Jvectormap, touchspin, select2, daterangepicker, clockpicker, ionRangeSlider, datapicker, nouslider, jasny, switchery, cropper, colorpicker, steps, dropzone, bootstrap-markdown
*/
$needed_files = array("headerdaterangepicker", "daterangepicker", "iCheck", "jasny", "knockout", "moment", "highcharts");

$page_title = "Dashboard";
include("include/header.php"); 
?>

		<div data-bind='with: dashboardData'>
			<div class="row">
				<div class="col-lg-4">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<span class="label label-primary pull-right">This period</span>
							<h5>Loans</h5>
						</div>
						<div class="ibox-content">
							<div class="row">
								<div class="col-md-3">
									<small>Portfolio</small>
									<h3 class="no-margins"><a title="Total disbursed loan amount" data-bind="text:curr_format(parseInt(figures.loan_portfolio)), attr:{href:'view_loans.php?status=4&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">40,642</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: percents.loan_portfolio">44</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.loan_portfolio < 1, 'fa-level-up': percents.loan_portfolio > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Interest</small>
									<h3 class="no-margins"><a title="Total disbursed loan amount" data-bind="text:curr_format(parseInt(figures.loan_interest)), attr:{href:'view_loans.php?status=4&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">40,642</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: percents.loan_interest">44</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.loan_interest < 1, 'fa-level-up': percents.loan_interest > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Penalties</small>
									<h3 class="no-margins"><a title="Amount paid in penalties" data-bind="text:curr_format(parseInt(figures.loan_penalty)), attr:{href:'view_loans.php?status=4&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">40,642</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: curr_format(parseInt(percents.loan_penalty))">44</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.loan_penalty < 1, 'fa-level-up': percents.loan_penalty > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Payments</small>
									<h3 class="no-margins"><a title="Amount that has been paid off the total portfolio" data-bind="text:curr_format(parseInt(figures.loan_payments)), attr:{href:'view_loans.php?status=4&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">20,612</a></h3>
									<div class="font-bold text-navy"><span data-bind="text:percents.loan_payments">22</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.loan_payments < 1, 'fa-level-up': percents.loan_payments > 0}"></i> </div>
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
								<div class="col-md-3">
									<small>Pending</small>
									<h3 class="no-margins"><a title="Loans pending approval" data-bind="text: curr_format(parseInt(figures.pending_loans)), attr:{href:'view_loans.php?status=1&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: percents.pending_loans">0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.pending_loans < 1, 'fa-level-up': percents.pending_loans > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Rejected</small>
									<h3 class="no-margins"><a title="Loans that have been rejected" data-bind="text: curr_format(parseInt(figures.rejected_loans)), attr:{href:'view_loans.php?status=2&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-navy"><span data-bind="text: percents.rejected_loans">0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.rejected_loans < 1, 'fa-level-up': percents.rejected_loans > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Approved</small>
									<h3 class="no-margins"><a title="Loans that have been approved" data-bind="text: curr_format(parseInt(figures.approved_loans)), attr:{href:'view_loans.php?status=3&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-navy"><span data-bind="text: percents.approved_loans">0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.approved_loans < 1, 'fa-level-up': percents.approved_loans > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Disbursed</small>
									<h3 class="no-margins"><a title="Loans that have been disbursed" data-bind="text: curr_format(parseInt(figures.disbursed_loans)), attr:{href:'view_loans.php?status=4&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-navy"><span data-bind="text: percents.disbursed_loans">0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.disbursed_loans < 1, 'fa-level-up': percents.disbursed_loans > 0}"></i> </div>
								</div>
							</div>
						</div>

					</div>
				</div>
				<div class="col-lg-4">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>Income</h5>
							<!--div class="ibox-tools">
								<span class="label label-primary">Performances</span>
							</div-->
						</div>
						<div class="ibox-content">
							<div class="row">
								<div class="col-md-3">
									<small>Savings</small>
									<h3 class="no-margins"><a title="Total members savings" data-bind="text:curr_format(parseInt(figures.savings)), attr:{href:'view_savings.php?startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-navy"><span data-bind="text:percents.savings">0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.savings < 1, 'fa-level-up': percents.savings > 0}"></i> </div>
								</div>
								<div class="col-md-3">
									<small>Subscription</small>
									<h3 class="no-margins"><a title="The number of subscriptions by members in a specified period" data-bind="text: curr_format(parseInt(figures.total_scptions)), attr:{href:'view_reports.php?view=subscriptions&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">00</a></h3>
									<div class="font-bold text-info"><span data-bind='text: percents.scptions_percent'>0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.scptions_percent < 1, 'fa-level-up': percents.scptions_percent > 0}"></i></div>
								</div>
								<div class="col-md-3">
									<small>Shares</small>
									<h3 class="no-margins"><a title="The number of shares bought by members in a specified period" data-bind="text: curr_format(parseInt(figures.total_shares)), attr:{href:'view_reports.php?view=shares&startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-info"><span data-bind='text: percents.scptions_percent'>0</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.scptions_percent < 1, 'fa-level-up': percents.scptions_percent > 0}"></i></div>
								</div>
								<div class="col-md-3">
									<small>Members</small>
									<h3 class="no-margins"><a title="The number of members registered in a specificied period" data-bind="text: figures.members, attr:{href:'members.php?startdate='+$root.startDate()+'&enddate='+$root.endDate()}">0</a></h3>
									<div class="font-bold text-success"><span data-bind='text: percents.members'>0</span>% <i data-bind="css: { fa:1, 'fa-level-down': percents.members < 1, 'fa-level-up': percents.members > 0 }"></i></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-6">
					<div class="ibox float-e-margins">
						<div class="ibox-content">
							<div class="m-t-sm">
								<div class="row">
									<div id="lineChart" style="max-height:300px; height:300px; max-width:600px; margin: 0 auto"></div>
								</div>

							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="ibox float-e-margins">
						<div class="ibox-content">
								<div style="max-height:300px; height:300px; max-width:600px; margin: 0 auto" id="pieChart"></div>
						</div>
					</div>
				</div>

			</div>
			<div class="row">
				<div class="col-lg-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>Expenses</h5> <span class="label label-primary">Recent 10</span>
							<div class="ibox-tools">
								<a class="collapse-link">
									<i class="fa fa-chevron-up"></i>
								</a>
								
								<a class="close-link">
									<i class="fa fa-times"></i>
								</a>
							</div>
						</div>
						<div class="ibox-content">
							<div>
								<div class="table-responsive">
									<table class="table table-striped">
										<thead>
											<tr>
												<th>#</th>
												<th>Date</th>
												<th>Description</th>
												<th>Amount</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: tables.expenses">
											<tr>
												<td data-bind="text: id">1</td>
												<td data-bind="text: moment(expenseDate,'X').format('DD MMMM, YYYY')"></td>
												<td data-bind="text: amountDescription"></td>
												<td data-bind="text: curr_format(parseInt(amountUsed))"></td>
											</tr>
										</tbody>
										<tfoot data-bind="if: tables.expenses">
											<tr>
												<th scope='row'>Total</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th data-bind="text: curr_format(array_total(tables.expenses,2))"></th>
											</tr>
										</tfoot>
									</table>
									<p data-bind="if: tables.expenses" class="pull-right"><a data-bind="attr: { href: 'view_reports.php?view=expenses&start_date='+$parent.startDate()+'&amp;end_date='+$parent.endDate()}" class="btn btn-info" title="View all expenses">View all...</a></p>
								</div>

							</div>
						</div>
					</div>
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>Income From Other Sources</h5><span class="label label-primary">Recent 10</span>
							<div class="ibox-tools">
								<a class="collapse-link">
									<i class="fa fa-chevron-up"></i>
								</a>
								
								<a class="close-link">
									<i class="fa fa-times"></i>
								</a>
							</div>
						</div>
						<div class="ibox-content no-padding">
							<div>
								<div class="table-responsive">
									<table class="table table-striped">
										<thead>
											<tr>
												<th>#</th>
												<th>Source</th>
												<th>Amount</th>
												<th>Date Received</th>
												<th>Description</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: tables.income">
											<tr>
												<td data-bind="text: id">1</td>
												<td data-bind="text: source"></td>
												<td data-bind="text: curr_format(parseInt(amount))"></td>
												<td data-bind="text: moment(dateAdded,'X').format('DD MMMM, YYYY')"></td>
												<td data-bind="text: description"></td>
											</tr>
										</tbody>
										<tfoot data-bind="if: tables.income">
											<tr>
												<th scope='row'>Total</th>
												<th>&nbsp;</th>
												<th data-bind="text: curr_format(array_total(tables.income,2))"></th>
											</tr>
										</tfoot>
									</table>
									<p data-bind="if: tables.income" class="pull-right"><a data-bind="attr: { href: 'miscellanous_income.php?start_date='+$parent.startDate()+'&amp;end_date='+$parent.endDate()}" class="btn btn-info" title="View all income">View all...</a></p>
								</div>

							</div>
						
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="ibox float-e-margins ">
						<div class="ibox-title">
							<h5>Loan Products Revenue</h5> <span class="label label-primary">Top 10</span>
							<div class="ibox-tools">
								<a class="collapse-link">
									<i class="fa fa-chevron-up"></i>
								</a>
								
								<a class="close-link">
									<i class="fa fa-times"></i>
								</a>
							</div>
						</div>
						<div class="ibox-content">
							<div>
								<div class="table-responsive">
									<table class="table table-striped">
										<thead>
											<tr>
												<th>Product</th>
												<th>Amount Disbursed</th>
												<th>Interest</th>
												<th>Amount Paid</th>
												<th>Balance</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: tables.loan_products">
											<tr>
												<td data-bind="text: productName">1</td>
												<td data-bind="text: curr_format(parseInt(loan_amount))"></td>
												<td data-bind="text: curr_format(parseInt(interest))"></td>
												<td data-bind="text: curr_format(parseInt(paidAmount))"></td>
												<td data-bind="text: curr_format(parseInt(loan_amount)+parseInt(interest)-parseInt(paidAmount))"></td>
											</tr>
										</tbody>
										<tfoot data-bind="if: tables.loan_products">
											<tr>
												<th scope='row'>Total</th>
												<th data-bind="text: curr_format(array_total(tables.loan_products,1))"></th>
												<th data-bind="text: curr_format(array_total(tables.loan_products,2))"></th>
												<th data-bind="text: curr_format(array_total(tables.loan_products,3))"></th>
												<th data-bind="text: curr_format(array_total(tables.loan_products,1)+array_total(tables.loan_products,2)-array_total(tables.loan_products,3))"></th>
											</tr>
										</tfoot>
									</table>
									<p data-bind="if: tables.loan_products" class="pull-right"><a data-bind="attr: { href: 'view_reports.php?view=loanproducts&amp;start_date='+$parent.startDate()+'&amp;end_date='+$parent.endDate()}" class="btn btn-info" title="View all loans">View all...</a></p>
								</div>
							</div>
						</div>
					</div>
					<div class="ibox float-e-margins ">
						<div class="ibox-title">
							<h5>Member Savings </h5><span class="label label-primary">Recent 10</span>
							<div class="ibox-tools">
								<a class="collapse-link">
									<i class="fa fa-chevron-up"></i>
								</a>
								
								<a class="close-link">
									<i class="fa fa-times"></i>
								</a>
							</div>
						</div>
						<div class="ibox-content no-padding">
							<div>
								<div class="table-responsive">
									<table class="table table-striped">
										<thead>
											<tr>
												<th>#</th>
												<th>Client Name</th>
												<th>Savings Product</th>
												<th>Sum Deposited</th>
												<th>Sum Withdrawn</th>
												<th>Account Balance</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: tables.savings">
											<tr>
												<td data-bind="text: id">1</td>
												<td data-bind="text: clientNames"></td>
												<td data-bind="text: productName"></td>
												<td data-bind="text: curr_format(parseInt(sumDeposited))"></td>
												<td data-bind="text: curr_format(parseInt(sumWithdrawn))"></td>
												<td data-bind="text: curr_format(parseInt(sumDeposited) -(parseInt(sumWithdrawn)))"></td>
												
											</tr>
										</tbody>
										<tfoot data-bind="if: tables.savings">
											<tr>
												<th scope='row'>Total</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th data-bind="text: curr_format(array_total(tables.savings,5))"></th>
												<th data-bind="text: curr_format(array_total(tables.savings,7))"></th>
												<th data-bind="text: curr_format(array_total(tables.savings,5) - array_total(tables.savings,7))"></th>
											</tr>
										</tfoot>
									</table>
									<p data-bind="if: tables.savings" class="pull-right"><a data-bind="attr: { href: 'view_reports.php?view=allsavings&start_date='+$parent.startDate()+'&amp;end_date='+$parent.endDate()}" class="btn btn-info" title="View all savings">View all...</a></p>
								</div>

							</div>
						
						</div>
					</div>
				</div>
			</div>
		</div>
<?php
include("include/footer.php"); 
include("js/dash.php");
?>