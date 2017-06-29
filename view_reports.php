<?php
$needed_files = array("daterangepicker","moment","dataTables","knockout"/*, "iCheck", "steps", "jasny", "datepicker"*/);
$page_title = "Reports";
include("include/header.php");
include("lib/Reports.php");?>
<div class="wrapper wrapper-content animated fadeInUp">
	<div id="reports">
		<div class="row">
			<div class="col-lg-12">
				<p>
					<a  href="?view=general" class="btn btn-sm btn-info"> <i class="fa fa-calculator"></i> Loans</a>
					<a  href="?view=savings_accs" class="btn btn-sm btn-info"> <i class="fa fa-dollar"></i> Savings</a>
					<a  href="?view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Income Statement</a>
					<!--a  href="?view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-calculator"></i> Ledger</a-->
					<a href="?view=subscriptions" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Subscriptions</span>  </a>
					<a href="?view=shares" class="btn btn-info btn-sm"><i class="fa fa-money"></i> <span class="nav-label">Shares</span>  </a>
				</p>
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