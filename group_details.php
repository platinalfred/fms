<?php
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout", "daterangepicker", "datepicker");
$page_title = "Group Details";
include("include/header.php");
include("lib/Reports.php");
$sacco_group = new SaccoGroup();
global $client;
$client  = array();
$group_data  = $sacco_group->findById($_GET['id']);
$names =  $group_data['groupName']; 
$data['group_members'] = $sacco_group->findGroupMembers($group_data['id']);
$client['clientType'] = 2;
$client['clientNames'] = $names;
$client['id'] = $_GET['id'];
if(!$group_data){
	echo "<p>No group details found</p>";
	return;
}
?>
<style>
p{
	margin: 0 0 3px;
}
</style>
<?php include("edit_group.php");?>
<div class="row">
	
	<div class="col-lg-12">
		<div class="wrapper wrapper-content animated fadeInUp">

			<div class="ibox">
				<div class="ibox-title">
					<h5>Group - <?php echo $names; ?> </h5>
					<div class="ibox-tools">
						<a  data-toggle="modal" href="#edit_group" class="btn btn-primary btn-sm"><i class="fa fa-pencil"></i> Edit </a>
						<a href="#" class="btn btn-danger btn-sm delete_me" style="color:#fff;"><i class="fa fa-trash"></i> Delete</a>
					</div>
				</div>
				<div class="ibox-content" style="padding-top:3px;">
					<div class="col-lg-12">
						<div class="ibox<?php if(isset($_GET['view'])):?> collapsed<?php endif;?>" style="margin-bottom:0px;     margin-top: 0px;">
							<div class="ibox-title" style="border-top:none;">
								<div class="col-lg-2">
									<h5>Group Members</h5>
									<div class="ibox-tools">
										<a class="collapse-link">
											<i class="fa fa-chevron-<?php if(isset($_GET['view'])):?>up<?php else:?>down<?php endif;?>" style="color:#23C6C8;"></i>
										</a>
									</div>
								</div>
							</div>
							<div class="ibox-content">
								<div class="row">
									<div class="col-md-12 col-sm-12 col-xs-12 " data-bind='foreach: $root.group_members'>
										<div class="col-md-12 col-sm-12 col-xs-12 details" data-bind='text:memberNames'></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="clearboth"></div>
					<div class="col-md-12 col-sm-12 col-xs-12 " style="border-top:1px solid #09A; padding-top:10px;">
						<p>
							<a  href="?id=<?php echo  $_GET['id']; ?>&view=loan_accs" class="btn btn-sm btn-info" class="btn btn-info btn-sm"> <i class="fa fa-money"></i> Loan Accounts</a>
							<a  href="?id=<?php echo  $_GET['id']; ?>&view=savings_accs" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Saving Accounts</a>
							<a  href="?id=<?php echo  $_GET['id']; ?>&view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-calculator"></i> Ledger</a>
                        </p>
					</div>
					<div class="clearboth"></div>
					<?php 
					if(isset($_GET['task'])){
						$task = $_GET['task']; 
						$forms = new Forms($task);
					}elseif(isset($_GET['view'])){
						$view = $_GET['view'];
						$item_view = array();
						if(isset($_GET['loanId'])){
							$item_view['loanId'] = $_GET['loanId'];
						}
						if(isset($_GET['depAcId'])){
							$item_view['depAcId'] = $_GET['depAcId'];
						}
						$reports = new Reports($view, $item_view, $client);
					}
					?>
				</div>
			</div>
		</div>
	</div>
</div>
<?php
 include("include/footer.php");
  include("js/group_js.php");
  if(isset($_GET['view'])){
	  switch($_GET['view']){
		case 'loan_accs':
			include("js/loanAccount.php");
		break;
		case 'savings_accs':
			include("js/depositAccount.php");
		break;
	  }
  }
?>