<?php
$needed_files = array("dataTables"/*, "iCheck", "steps", "jasny", "moment", "knockout", "datepicker"*/);
$page_title = "Reports";
include("include/header.php");?>
<div class="wrapper wrapper-content animated fadeInUp">
	<div id="reports">
		<div class="row">
			<div class="col-lg-12">
				<p>
					<a  href="reports.php" class="btn btn-sm btn-info" class="btn btn-info btn-sm"> <i class="fa fa-money"></i> Loans</a>
					<a  href="?id=2&view=savings" class="btn btn-sm btn-info" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Savings</a>
					<a  href="?id=3&view=income_stmt" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Income Statement</a>
					<a  href="?id=4&view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-calculator"></i> Ledger</a>
				</p>
			</div>
		</div>
		<div class="row" data-bind="with: account_details">
			<div class="col-lg-12">
				<div class="ibox">
					<div class="ibox-title" style="border-top:none;">
						<h5>Loan Accounts</h5>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-down"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content collapse in">
						<div class="table-responsive">
							<table id="loan_report" class="table table-bordered data">
								<thead>
									<tr>
										<?php 
										$header_keys = array("SNo.", "Member", "Amount", "No. of Installments", "Principle", "Interest", "Total Interest Expected", "Other", "Loan application fees", "No of installments paid", "Bal of installments", "Principal paid", "Interest paid", "Misc Income", "Outstanding Principal", "Outstanding Interest", "outstanding loan balance");
										foreach($header_keys as $key){ ?>
											<th><?php echo $key; ?></th>
											<?php 
										} ?>
									</tr>
								</thead>
								<tbody>
								</tbody>
								<tfoot>
								<?php 
									foreach($header_keys as $key){ ?>
										<th><?php echo ""; ?></th>
										<?php 
									}
								?>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<?php
 include("include/footer.php");
 include("js/reports_js.inc");//
?>