<?php
/*

*/
$needed_files = array("headerdaterangepicker","daterangepicker","moment","dataTables","knockout"/*, "iCheck", "steps", "jasny", "datepicker"*/);

if(isset($_GET['view'])){
	$page_title = "Individual Loan Accounts";
	switch($_GET['view']){
		case 'general':
			$page_title = "General Loan Accounts Reports";
		break;
		case 'individual':
			$page_title = "Individual Loan Accounts Reports";
		break;
		case 'subscriptions':
			$page_title = "General Members Subscriptions";
		break; 
		default:
			$page_title = "Reports";
		break;
	}
}
include("include/header.php");
include("lib/Reports.php");
?>
<div class="wrapper wrapper-content animated fadeInUp">
	<div id="reports">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox-content">
					<a  href="?view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Income Statement</a>
					<div class="btn-group">
						<button data-toggle="dropdown" class="btn btn-info btn-sm dropdown-toggle"><i class="fa fa-calculator"></i> Loan Reports <span class="caret"></span></button>
						<ul class="dropdown-menu">
							<li><a href="?view=general">General Loans Report</a></li>
							<li><a href="?view=individual">Individual loans</a></li>
							<li><a href="#">Group Loans</a></li>
							<li><a href="#">Active Loans</a></li>
							<li><a href="#">None Performing Loans</a></li>
							<li><a href="#">Due Loans</a></li>
						</ul>
					</div>
					<div class="btn-group">
						<button data-toggle="dropdown" class="btn btn-info btn-sm dropdown-toggle"><i class="fa fa-dollar"></i> Savings Reports <span class="caret"></span></button>
						<ul class="dropdown-menu">
							<li><a href="#">General savings accounts</a></li>
							<li><a href="#">Individual savings accounts</a></li>
							<li><a href="#">Group savings accounts</a></li>
						</ul>
					</div>
					<a href="#" class="btn btn-sm btn-info"> Expenses report</a>
					
					
					<a href="?view=subscriptions" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Subscriptions</span>  </a>
					<a href="?view=shares" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Shares</span>  </a>
					<a href="?view=members" class="btn btn-info btn-sm"><i class="fa fa-group"></i> <span class="nav-label">Members</span>  </a>
					<a href="?view=groups" class="btn btn-info btn-sm"><i class="fa fa-group"></i> <span class="nav-label">Groups</span>  </a>
					<a href="#" class="btn btn-info btn-sm">Log reports</a>
				</div>
				
			</div>
		</div>
		<div class="row">
			<div class="clearboth"></div>
			<?php 
			if(isset($_GET['view'])){
				$view = $_GET['view'];
				$reports = new Reports($view);
			}
			?>
		</div>
	</div>
</div>
<?php
 include("include/footer.php");
  if(isset($_GET['view'])){
	  switch($_GET['view']){
		case 'savings':
			include("js/savings_js.php");
		break;
		case 'general':
			include("js/reports_js.inc");
		break;
		case 'ledger':
			include("js/ledger_js.php");
		break;
		case 'subscriptions':
			include("js/subscriptions_js.inc");
		break;
		case 'shares':
			include("js/shares_js.inc");
		break;
	  }
  }
?>