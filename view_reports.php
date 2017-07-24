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
					<a  href="?view=general" class="btn btn-info btn-sm"><i class="fa fa-calculator"></i> Loans</a>
					<div class="btn-group">
						<a href="?view=allsavings" class="btn btn-info btn-sm"><i class="fa fa-dollar"></i> Savings</a>
						
					</div>
					<a href="?view=expenses" class="btn btn-sm btn-info"> Expenses</a>
					
					
					<a href="?view=subscriptions" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Subscriptions</span>  </a>
					<a href="?view=shares" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Shares</span>  </a>
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
		case 'allsavings':
			include("js/savings_page_js.php");
		break;
		case 'expenses':
			include("js/expense_report.php");
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