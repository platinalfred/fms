<?php
/*

*/
$needed_files = array("daterangepicker","moment","dataTables","knockout"/*, "iCheck", "steps", "jasny", "datepicker"*/);
$page_title = "Reports";
include("include/header.php");
include("lib/Reports.php");
?>
<div class="wrapper wrapper-content animated fadeInUp">
	<div id="reports">
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox-content">
					<a  href="?view=general" class="btn btn-sm btn-info"> <i class="fa fa-calculator"></i> Loan Accounts</a>
					<div class="btn-group">
						<button data-toggle="dropdown" class="btn btn-info btn-sm dropdown-toggle"><i class="fa fa-calculator"></i> Loan Reports <span class="caret"></span></button>
						<ul class="dropdown-menu">
							<li><a href="#">Individual loans</a></li>
							<li><a href="#">Group Loans</a></li>
							<li><a href="#">Active Loans</a></li>
							<li><a href="#">None Performing Loans</a></li>
							<li><a href="#">Individual savings</a></li>
							<li><a href="#">Group savings</a></li>
							<li><a href="#">Group available balances report</a></li>
							<li><a href="#">Group daily transactions report</a></li>
							<li><a href="#">Group periodical transactions report</a></li>
							<li><a href="#">Income report</a></li>
							<li><a href="#">Expenses report</a></li>
							<li><a href="#">Withdrawals</a></li>
							<li><a href="#">Contribution group report</a></li>
							<li><a href="#">Log reports</a></li>
						</ul>
					</div>
					<a  href="?view=savings_accs" class="btn btn-sm btn-info"> <i class="fa fa-dollar"></i> Savings</a>
					<a  href="?view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Income Statement</a>
					<a href="?view=subscriptions" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Subscriptions</span>  </a>
					<a href="?view=shares" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Shares</span>  </a>
					<a href="?view=members" class="btn btn-info btn-sm"><i class="fa fa-group"></i> <span class="nav-label">Members</span>  </a>
					<a href="?view=groups" class="btn btn-info btn-sm"><i class="fa fa-group"></i> <span class="nav-label">Groups</span>  </a>
					
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