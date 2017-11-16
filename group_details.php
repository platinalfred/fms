<?php
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout", "select2", "daterangepicker", "datepicker");
$page_title = "Group Details";
include("include/header.php");
include("lib/Reports.php");
$sacco_group = new SaccoGroup();
global $client;
$client  = array();
$group_data  = $sacco_group->findById($_GET['groupId']);
$names =  $group_data['groupName']; 
$data['group_members'] = $sacco_group->findGroupMembers($group_data['id']);
$client['clientType'] = 2;
$client['clientNames'] = $names;
$client['id'] = $_GET['groupId'];
if(!$group_data){
	echo "<p>No group details found</p>";
	return;
}
$client['clientType'] = 2;
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
						<a id="<?php echo $_GET['groupId']; ?>" class="btn btn-danger btn-sm delete_me" style="color:#fff;"><i class="fa fa-trash"></i> Delete</a>
					</div>
				</div>
				<div class="ibox-content" style="padding-top:3px;">
					<div class="col-lg-12">
						<div class="ibox<?php if(isset($_GET['view'])||isset($_GET['task'])):?> collapsed<?php endif;?>" style="margin-bottom:0px;     margin-top: 0px;">
							<div class="ibox-title" style="border-top:none;">
								<div class="col-lg-3">
									<h5>Group Members (<?php echo count($data['group_members']); ?>)</h5>
									<div class="ibox-tools">
										<a class="collapse-link">
											<i class="fa fa-chevron-<?php if(isset($_GET['view'])):?>up<?php else:?>down<?php endif;?>" style="color:#23C6C8;"></i>
										</a>
									</div>
								</div>
							</div>
							<div class="ibox-content">
								<div class="row">
									<div class="col-md-12 col-sm-12 col-xs-12 " >
										<?php
										//print_r($data['group_members']);
										if($data['group_members']){ ?>
											<div class="col-md-12 col-sm-12 col-xs-12" style="padding-top:10px;">
												<div class="col-lg-3"><b>Name</b>
												</div>
												<div class="col-lg-3"><b>Person Number</b>
												</div>
												<div class="col-lg-3"><b>Phone</b></div>
												<div class="col-lg-3"><b>Id Number</b></div>
											</div>
											<?php	
											foreach($data['group_members'] as $single){ ?>
												<div class="col-md-12 col-sm-12 col-xs-12" style="padding-top:10px;">
													<div class="col-lg-3">
														<a href="member_details.php?id=<?php echo $single['memberId']; ?>"><?php echo $single['memberNames']; ?></a>
													</div>
													<div class="col-lg-3"><?php echo $single['person_number']; ?>
													</div>
													<div class="col-lg-3"><?php echo $single['phone']; ?>
													</div>
													<div class="col-lg-3"><?php echo $single['id_number']; ?>
													</div>
												</div>
												<?php												
											}
										}
										?>
										
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="clearboth"></div>
					<div class="col-md-12 col-sm-12 col-xs-12 " style="border-top:1px solid #09A; padding-top:10px;">
						<p>
							<a  href="?groupId=<?php echo  $_GET['groupId']; ?>&view=loan_accs" class="btn btn-sm btn-info" class="btn btn-info btn-sm"> <i class="fa fa-money"></i> Loan Accounts</a>
							<a  href="?groupId=<?php echo  $_GET['groupId']; ?>&view=savings_accs" class="btn btn-info btn-sm"> <i class="fa fa-dollar"></i> Saving Accounts</a>
							<a  href="?groupId=<?php echo  $_GET['groupId']; ?>&view=ledger" class="btn btn-info btn-sm"> <i class="fa fa-calculator"></i> Ledger</a>
                        </p>
					</div>
					<div class="clearboth"></div>
					<?php 
					if(isset($_GET['task'])){
						include('lib/Forms.php');
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
			$include_file = "js/loanAccount.php";
			if(isset($_GET['groupId'])&&!isset($_GET['grpLId'])){
				$include_file = "js/groupLoanAccs.php";
			}
			include($include_file);
		break;
		case 'savings_accs':
			include("js/depositAccount.php");
		break;
	  }
  }
  if(isset($_GET['task'])){
	  switch($_GET['task']){
		case 'loan.add':
			include("js/loanAccount.php");
		break;
	  }
  }
?>