<?php
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout");
$page_title = "Member Details";
include("include/header.php");
require_once("lib/Forms.php");
require_once("lib/Reports.php");
$member = new Member();
$accounts = new Accounts();
$shares = new Shares();
$client  = array();
$member_data  = $member->findMemberDetails($_GET['id']);
$names =  $member_data['firstname']." ". $member_data['lastname']." ".$member_data['othername']; 
$data['relatives'] = $person->findPersonRelatives($member_data['id']);
$client['clientType'] = 1;
$client['clientNames'] = $names;
$client['id'] = $_GET['id'];
if(!$member_data){
	echo "<p>No member details found</p>";
	return;
}
?>
<style>
p{
	margin: 0 0 3px;
}
</style>
<div id="add_loan_account" class="modal fade" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-body">
				<?php include_once("add_loan_account.php");?>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="wrapper wrapper-content animated fadeInUp">

			<div class="ibox">
				<div class="ibox-title">
					<h5><?php echo $names; ?> <small> - <?php echo $member->findPersonNumber($member_data['id']);?> </small></h5>
					<div class="ibox-tools">
						<a href="#" class="btn btn-primary btn-sm"><i class="fa fa-pencil"></i> Edit </a>
						<a href="#" class="btn btn-danger btn-sm" style="color:#fff;"><i class="fa fa-trash"></i> Delete</a>
					</div>
				</div>
				<div class="ibox-content">
					<div class="col-md-2 col-sm-12 col-xs-12">
						<h2> A/C - <?php echo sprintf('%08d',$accounts->findAccountNumberByPersonNumber($member_data['id']));?></h2>
						<?php  
						if($member_data['photograph'] !="" && file_exists($member_data['photograph'])){?> 
							<img style="width:100%; height:100%;" height="100%" src="<?php echo $member_data['photograph']; ?>" > <a  href="" type="button"  data-toggle="modal" data-target=".add_photo"><i class="fa fa-edit"></i> Change photo</a>
							<?php 
						}else{?>
							<img style="width:100%;"  src="img/user.png" > <a  href="" type="button"  data-toggle="modal" data-target=".add_photo">
							<i class="fa fa-edit"></i> Add a photo</a><?php 
						} ?>
						<div class="modal fade add_photo" tabindex="-1" role="dialog" aria-hidden="true">
							<div class="modal-dialog modal-sm">
							  <div class="modal-content">
									<form method="post" action="photo_upload.php" id="photograph">
										<div class="modal-header">
										  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span>
										  </button>
										  <h4 class="modal-title" id="myModalLabel2">Add member photograph</h4>
										</div>
										<div class="modal-body">
											<input type="hidden" name="photo_upload" >
										  <input type="hidden" id="p_no" name="person_number" value="<?php echo $member_data['person_id']; ?>">
										  <input id="myFileInput" type="file" name="photograph" accept="image/*;capture=camera">
										</div>
										<div class="modal-footer">
										  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										  <button type="submit" class="btn btn-info photo_upload">Upload a Photo</button>
										</div>
									</form>
									
							  </div>
							</div>
						</div>
					</div>
					<div class="col-md-10 col-sm-12 col-xs-12 ">
						<div class="col-md-12 col-sm-12 col-xs-12 details">
							<div class="col-md-3 col-sm-12 col-xs-12 ">
								<p class="lead">Phone</p>
								<p class="p"><?php echo $member_data["phone"]; ?></p>
							</div>
							<div class="col-md-3 col-sm-12 col-xs-12">
								<p class="lead">Email Address</p>
								<p class="p"><?php echo $member_data["email"]; ?></p>
							</div>
							<div class="col-md-3 col-sm-12 col-xs-12">
								<p class="lead" >Physical  Address</p>
								<p class="p"><?php echo $member_data["physical_address"]; ?></p>
							</div>
							<div class="col-md-3 col-sm-12 col-xs-12 ">
								<p class="lead">Postal Address</p>
								<p class="p"><?php echo $member_data["postal_address"]; ?></p>
							</div>
							
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12 details">
							<div class="col-md-3 col-sm-12 col-xs-12 form-group " >
								<p class="lead" style="">ID Number</p>
								<p class="p"><?php  echo $member_data['id_number']; ?></p>
							</div>
							<div class="col-md-3 col-sm-12 col-xs-12 form-group " >
								<p class="lead">Gender</p>
								<p class="p"><?php echo $member->findGender($member_data["gender"]); ?></p>
							</div>
							<?php
							$all_client_shares = $shares->findMemberShares($member_data['id']); 
							if($all_client_shares){
								?>
								<div class="col-md-5 col-sm-12 col-xs-12 form-group ">
									<p class="lead" >My Shares</p>
									<p class="p">
										<?php
										$shares_sum = 0;
										$no = 0;
										foreach($all_client_shares as $single){ 
											?>
											<tr class="even pointer " >
												<td><?php echo date("j F, Y", $single['datePaid']); ?></td>
												<td><?php  echo $single['noShares']; ?></td>
												<td><?php $shares_sum += $single['amount']; echo number_format($single['amount'],0,".",","); ?></td>
											</tr>
											<?php
											$no = $no+$single['noShares'];
										}
										?>
									</p>
								</div>
								<?php 
							}
							?>
						</div>
						<?php
						$balance =  $accounts->findByAccountBalance($member_data['id']); 
						if($balance > 1){
							$minimum_amount = $accounts->findMinimumBalance();
							$available = $balance - $minimum_amount;
						}else{
							$available = 0;
						} ?>
						
						<div class="col-md-12 col-sm-12 col-xs-12 details">
							<div class="col-md-5 col-sm-12 col-xs-12 ">
								<p class="p"><b>Actual balance: <?php  echo number_format($balance,2,".",",");  ?> UGX</b></p>
							</div>
							<div class="col-md-5 col-sm-12 col-xs-12 ">
								<p class="p"><b>Available Balance: <?php   echo number_format($available,2,".",","); ?> UGX</b></p>
							</div>
							
						</div>
					</div>
					<div class="clearboth"></div>
					<div class="col-md-12 col-sm-12 col-xs-12 " style="border-top:1px solid #09A; padding-top:10px;">
						<p>
							<a  href="#add_loan_account" class="btn btn-sm btn-info" data-toggle="modal" class="btn btn-info btn-sm"> <i class="fa fa-plus"></i> Apply for a loan</a>
							<a  href="?id=<?php echo  $_GET['id']; ?>&view=mysubscriptions" class="btn btn-info btn-sm"> <i class="fa fa-money"></i> Subscriptions</a>
							<?php 
							if($member_data['memberType'] == 1){ ?>
								<a  href="?id=<?php echo  $_GET['id']; ?>&view=myshares" class="btn btn-info btn-sm"> <i class="fa fa-money"></i> Shares</a>
								<?php
							}
							?>
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
						$reports = new Reports($view);
					}
					?>
				</div>
			
				
				
			</div>
		</div>
	</div>
</div>
<?php
 include("include/footer.php");
  include("js/members_js.php");
?>