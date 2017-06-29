<?php
/*
	include specific plugin files that you need on a page by  adding the names as below in the array
	dataTables, ChartJs,iCheck,daterangepicker,clockpicker,colorpicker,datapicker,easypiechart,fullcalendar,idle-timer,morris, nouslider, summernote,validate,wow,video,touchspin,Sparkline,Flot, Peity, Jvectormap, touchspin, select2, daterangepicker, clockpicker, ionRangeSlider, datapicker, nouslider, jasny, switchery, cropper, colorpicker, steps, dropzone, bootstrap-markdown
*/
$needed_files = array("daterangepicker", "iCheck", "jasny", "knockout", "moment", "highcharts");

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
								<div class="col-md-4">
									<small>Portfolio</small>
									<h3 class="no-margins"><a href="view_loan_payments.php" title="Details" data-bind="text:figures.loan_portfolio">40,642</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: percents.loan_portfolio">44</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.loan_portfolio < 1, 'fa-level-up': percents.loan_portfolio > 0}"></i> </div>
								</div>
								<div class="col-md-4">
									<small>Penalties</small>
									<h3 class="no-margins"><a href="view_loan_payments.php" title="Details" data-bind="text:figures.loan_portfolio">40,642</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: percents.penalties">44</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.penalties < 1, 'fa-level-up': percents.penalties > 0}"></i> </div>
								</div>
								<div class="col-md-4">
									<small>Payments</small>
									<h3 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text:figures.loan_payments">20,612</a></h3>
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
								<div class="col-md-4">
									<small>Pending</small>
									<h3 class="no-margins"><a href="view_loan_payments.php" title="Details" data-bind="text: figures.pending_loans">40,642</a></h3>
									<div class="font-bold text-navy"> <span data-bind="text: percents.pending_loans">44</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.pending_loans < 1, 'fa-level-up': percents.pending_loans > 0}"></i> </div>
								</div>
								<div class="col-md-4">
									<small>Partial</small>
									<h3 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text: figures.partial_loans">90,893</a></h3>
									<div class="font-bold text-navy"><span data-bind="text: percents.partial_loans">67</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.pending_loans < 1, 'fa-level-up': percents.pending_loans > 0}"></i> </div>
								</div>
								<div class="col-md-4">
									<small>Approved</small>
									<h3 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text: figures.approved_loans">206,12</a></h3>
									<div class="font-bold text-navy"><span data-bind="text: percents.approved_loans">22</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.approved_loans < 1, 'fa-level-up': percents.approved_loans > 0}"></i> </div>
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
								<div class="col-md-4">
									<small>Savings</small>
									<h3 class="no-margins"><a href="view_loans.php?type=4" title="Details" data-bind="text:figures.savings">20,612</a></h3>
									<div class="font-bold text-navy"><span data-bind="text:percents.savings">22</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.savings < 1, 'fa-level-up': percents.savings > 0}"></i> </div>
								</div>
								<div class="col-md-4">
									<small>Members</small>
									<h3 class="no-margins"><a href="view_members.php" title="Details"><span data-bind='text: figures.members'>386,200</span></a></h3>
									<div class="font-bold text-success"><span data-bind='text: percents.members'>98</span>% <i data-bind="css: { fa:1, 'fa-level-down': percents.members < 1, 'fa-level-up': percents.members > 0 }"></i></div>
								</div>
								<div class="col-md-4">
									<small>Subscription</small>
									<h3 class="no-margins"><a href="view_subscriptions.php" title="Details" data-bind='text: figures.total_scptions'>80,800</a></h3>
									<div class="font-bold text-info"><span data-bind='text: percents.scptions_percent'>20</span>% <i data-bind="css: {  fa:1, 'fa-level-down': percents.scptions_percent < 1, 'fa-level-up': percents.scptions_percent > 0}"></i></div>
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
							<div>
								<h3 class="font-bold no-margins">Performance of Loan Products</h3>
								<small>Product Sales</small>
							</div>
							<div class="m-t-sm">

								<div class="row">
									<div id="lineChart"></div>
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
							<h5>Expenses </h5>
							<span class="label label-primary">Top 10</span>
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
											<th>Date</th>
											<th>Description</th>
											<th>Amount</th>
										</tr>
									</thead>
									<tbody data-bind="foreach: tables.expenses">
										<tr>
											<td data-bind="text: id">1</td>
											<td data-bind="text: moment(expenseDate).format('D MMMM, YYYY')"></td>
											<td data-bind="text: amountDescription"></td>
											<td data-bind="text: curr_format(amountUsed)"></td>
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
								<p data-bind="if: tables.expenses" class="pull-right"><a data-bind="attr: { href: 'view_expenses.php?start_date='+$parent.startDate()+'&end_date='+$parent.endDate()}" class="btn btn-info" title="View all expenses">View all...</a></p>
							</div>

						</div>
					</div>
				</div>


				<div class="col-lg-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<span class="label label-warning pull-right">Product revenue</span>
							<h5>Loan Products</h5>
						</div>
						<div class="ibox-content">
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
								<p data-bind="if: tables.loan_products" class="pull-right"><a data-bind="attr: { href: 'view_loans.php?start_date='+$parent.startDate()+'&end_date='+$parent.endDate()}" class="btn btn-info" title="View all loans">View all...</a></p>
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