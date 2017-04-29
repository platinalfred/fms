<?php 
$show_table_js = false;
$page_title = "Dashboard";
$daterangepicker = true;
include("includes/header.php"); 
?>

	<div id="page-wrapper" class="gray-bg">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top white-bg" role="navigation" style="margin-bottom: 0">
				<div class="navbar-header">
					<a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
					<form role="search" class="navbar-form-custom" action="#">
						<div class="form-group">
							<input type="text" placeholder="Search for something..." class="form-control" name="top-search" id="top-search">
							<!--input type="hidden" id="startDate" data-bind="value: startDate"/>
							<input type="hidden" id="endDate" data-bind="value: endDate"/-->
						</div>
					</form>
				</div>
				<ul class="nav navbar-top-links navbar-right">
					<li>
						<div id="reportrange" style="background: #fff; cursor:pointer; padding: 5px 10px; border: 1px solid #ccc">
						  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
						  <span>December 30, 2014 - January 28, 2015</span> <b class="caret"></b>
						</div>
					</li>
					<li class="dropdown">
						<a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
							<i class="fa fa-envelope"></i> <span class="label label-warning">16</span>
						</a>
						<ul class="dropdown-menu dropdown-messages">
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left">
										<img alt="image" class="img-circle" src="img/a7.jpg">
									</a>
									<div>
										<small class="pull-right">46h ago</small>
										<strong>Mike Loreipsum</strong> started following <strong>Monica Smith</strong>.
										<br>
										<small class="text-muted">3 days ago at 7:58 pm - 10.06.2014</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left">
										<img alt="image" class="img-circle" src="img/a4.jpg">
									</a>
									<div>
										<small class="pull-right text-navy">5h ago</small>
										<strong>Chris Johnatan Overtunk</strong> started following <strong>Monica Smith</strong>.
										<br>
										<small class="text-muted">Yesterday 1:21 pm - 11.06.2014</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left">
										<img alt="image" class="img-circle" src="img/profile.jpg">
									</a>
									<div>
										<small class="pull-right">23h ago</small>
										<strong>Monica Smith</strong> love <strong>Kim Smith</strong>.
										<br>
										<small class="text-muted">2 days ago at 2:30 am - 11.06.2014</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block">
									<a href="mailbox.html">
										<i class="fa fa-envelope"></i> <strong>Read All Messages</strong>
									</a>
								</div>
							</li>
						</ul>
					</li>
					<li class="dropdown">
						<a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
							<i class="fa fa-bell"></i> <span class="label label-primary">8</span>
						</a>
						<ul class="dropdown-menu dropdown-alerts">
							<li>
								<a href="mailbox.html">
									<div>
										<i class="fa fa-envelope fa-fw"></i> You have 16 messages
										<span class="pull-right text-muted small">4 minutes ago</span>
									</div>
								</a>
							</li>
							<li class="divider"></li>
							<li>
								<a href="profile.html">
									<div>
										<i class="fa fa-twitter fa-fw"></i> 3 New Followers
										<span class="pull-right text-muted small">12 minutes ago</span>
									</div>
								</a>
							</li>
							<li class="divider"></li>
							<li>
								<a href="grid_options.html">
									<div>
										<i class="fa fa-upload fa-fw"></i> Server Rebooted
										<span class="pull-right text-muted small">4 minutes ago</span>
									</div>
								</a>
							</li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block">
									<a href="notifications.html">
										<strong>See All Alerts</strong>
										<i class="fa fa-angle-right"></i>
									</a>
								</div>
							</li>
						</ul>
					</li>

					<li>
						<a href="login.html">
							<i class="fa fa-sign-out"></i> Log out
						</a>
					</li>
					<li>
						<a class="right-sidebar-toggle">
							<i class="fa fa-tasks"></i>
						</a>
					</li>
				</ul>

			</nav>
		</div>

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
<!-- default table
							<div class="row">
								<div class="col-sm-9 m-b-xs">
									<div data-toggle="buttons" class="btn-group">
										<label class="btn btn-sm btn-white">
											<input type="radio" id="option1" name="options"> Day </label>
										<label class="btn btn-sm btn-white active">
											<input type="radio" id="option2" name="options"> Week </label>
										<label class="btn btn-sm btn-white">
											<input type="radio" id="option3" name="options"> Month </label>
									</div>
								</div>
								<div class="col-sm-3">
									<div class="input-group">
										<input type="text" placeholder="Search" class="input-sm form-control"> <span class="input-group-btn">
									<button type="button" class="btn btn-sm btn-primary"> Go!</button> </span></div>
								</div>
							</div>
							<div class="table-responsive">
								<table class="table table-striped">
									<thead>
										<tr>
											<th>#</th>
											<th>Project </th>
											<th>Name </th>
											<th>Phone </th>
											<th>Company </th>
											<th>Completed </th>
											<th>Task</th>
											<th>Date</th>
											<th>Action</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>1</td>
											<td>Project <small>This is example of project</small></td>
											<td>Patrick Smith</td>
											<td>0800 051213</td>
											<td>Inceptos Hymenaeos Ltd</td>
											<td><span class="pie">0.52/1.561</span></td>
											<td>20%</td>
											<td>Jul 14, 2013</td>
											<td><a href="#"><i class="fa fa-check text-navy"></i></a></td>
										</tr>
										<tr>
											<td>2</td>
											<td>Alpha project</td>
											<td>Alice Jackson</td>
											<td>0500 780909</td>
											<td>Nec Euismod In Company</td>
											<td><span class="pie">6,9</span></td>
											<td>40%</td>
											<td>Jul 16, 2013</td>
											<td><a href="#"><i class="fa fa-check text-navy"></i></a></td>
										</tr>
									</tbody>
								</table>
							</div>

-->
		<div class="footer">
			<div>
				<strong>Copyright</strong> Buladde Fincial Services &copy; 2017 <?php if(date("Y") != 2017 ){ echo "- ".date("Y"); } ?>
			</div>
		</div>

	</div>
</div>

    <!-- Mainly scripts -->
    <script src="js/jquery-2.1.1.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Flot -->
    <script src="js/plugins/flot/jquery.flot.js"></script>
    <script src="js/plugins/flot/jquery.flot.tooltip.min.js"></script>
    <script src="js/plugins/flot/jquery.flot.spline.js"></script>
    <script src="js/plugins/flot/jquery.flot.resize.js"></script>
    <script src="js/plugins/flot/jquery.flot.pie.js"></script>
    <script src="js/plugins/flot/jquery.flot.symbol.js"></script>
    <script src="js/plugins/flot/curvedLines.js"></script>

    <!-- Peity -->
    <script src="js/plugins/peity/jquery.peity.min.js"></script>
    <script src="js/demo/peity-demo.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="js/inspinia.js"></script>
    <script src="js/plugins/pace/pace.min.js"></script>

    <!-- jQuery UI -->
    <script src="js/plugins/jquery-ui/jquery-ui.min.js"></script>

    <!-- Jvectormap -->
    <script src="js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
    <script src="js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

    <!-- Sparkline -->
    <script src="js/plugins/sparkline/jquery.sparkline.min.js"></script>

    <!-- Sparkline demo data  -->
    <script src="js/demo/sparkline-demo.js"></script>

    <!-- ChartJS-->
    <script src="js/plugins/chartJs/Chart.min.js"></script>
	<?php 
	include("js/dash.php");
	?>

    <script>
        $(document).ready(function() {

            var lineData = {
                labels: ["January", "February", "March", "April", "May", "June", "July"],
                datasets: [{
                    label: "Example dataset",
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,1)",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(220,220,220,1)",
                    data: [65, 59, 40, 51, 36, 25, 40]
                }, {
                    label: "Example dataset",
                    fillColor: "rgba(26,179,148,0.5)",
                    strokeColor: "rgba(26,179,148,0.7)",
                    pointColor: "rgba(26,179,148,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(26,179,148,1)",
                    data: [48, 48, 60, 39, 56, 37, 30]
                }]
            };

            var lineOptions = {
                scaleShowGridLines: true,
                scaleGridLineColor: "rgba(0,0,0,.05)",
                scaleGridLineWidth: 1,
                bezierCurve: true,
                bezierCurveTension: 0.4,
                pointDot: true,
                pointDotRadius: 4,
                pointDotStrokeWidth: 1,
                pointHitDetectionRadius: 20,
                datasetStroke: true,
                datasetStrokeWidth: 2,
                datasetFill: true,
                responsive: true,
            };

            var ctx = document.getElementById("lineChart").getContext("2d");
            var myNewChart = new Chart(ctx).Line(lineData, lineOptions);

        });
    </script>
</body>

</html>