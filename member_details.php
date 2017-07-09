<?php
$needed_files = array("dataTables", "iCheck", "steps", "jasny","ladda", "moment", "knockout", "daterangepicker", "datepicker");

$page_title = "";
if(isset($_GET['savings_accs'])){
	$page_title = "Savings Account Details";
}elseif(isset($_GET['depAcId'])){
	$page_title = "Deposit Account Details";
}
include("include/header.php");
include("lib/Reports.php");
$member = new Member();
$shares = new Shares();
$person = new Person();
global $client;
$client  = array();
$member_data  = $member->findMemberDetails($_GET['id']);
$names =  $member_data['lastname']." ".$member_data['firstname']." ".$member_data['othername']; 
$data['relatives'] = $person->findPersonRelatives($member_data['id']);
$client['clientType'] = 1;
$client['clientNames'] = $names;
$client['id'] = $_GET['id'];
if(!$member_data){
	
	echo "<p>No member details found</p>";
	return;
}
$member_relatives = $person->findRelatives($member_data['personId']);
$member_employment_history = $person->findEmploymentHistory($member_data['personId']);
$member_business = $person->findMemberBusiness($member_data['personId']);
?>
<style>
p{
	margin: 0 0 3px;
}
</style>
<?php
 include("update_member_modal.php");?>
<div class="row">
	
	<div class="col-lg-12">
		<div class="wrapper wrapper-content animated fadeInUp">

			<div class="ibox">
				<div class="ibox-title">
					<h5><?php echo $names; ?> <small> - <?php echo $member->findPersonNumber($member_data['id']);?> </small></h5>
					<div class="ibox-tools">
						<a  data-toggle="modal" href="#update_member" class="btn btn-primary btn-sm"><i class="fa fa-pencil"></i> Edit </a>
						<a href="#" class="btn btn-danger btn-sm delete_member" style="color:#fff;"><i class="fa fa-trash"></i> Delete</a>
					</div>
				</div>
				<div class="ibox-content" style="padding-top:3px;">
					<div class="col-lg-12">
						<div class="ibox<?php if(isset($_GET['view'])):?> collapsed<?php endif;?>" style="margin-bottom:0px;     margin-top: 0px;">
							<div class="ibox-title" style="border-top:none;">
								<div class="col-lg-2">
									<h5>Member Details</h5>
									<div class="ibox-tools">
										<a class="collapse-link">
											<i class="fa fa-chevron-<?php if(isset($_GET['view'])):?>up<?php else:?>down<?php endif;?>" style="color:#23C6C8;"></i>
										</a>
									</div>
								</div>
							</div>
							<div class="ibox-content">
								<div class="row">
									<div class="col-lg-2">
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
														  <input type="hidden" id="p_no" name="id" value="<?php echo $member_data['personId']; ?>">
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
											<div class="col-md-3 col-sm-12 col-xs-12 form-group " >
												<p class="lead">Marital Status</p>
												<p class="p"><?php echo $member_data["marital_status"]; ?></p>
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
											<div class="col-md-12 col-sm-12 col-xs-12 details">
										<?php
										$member_deposit_account_obj = new MemberDepositAccount();
										$deposit_account_obj = new DepositAccount();
										$deposit_account_transaction_obj = new DepositAccountTransaction();
										$depositAccountIds = $member_deposit_account_obj->findSpecifics("`depositAccountId`", "`memberId`=".$member_data['id']);
										if($depositAccountIds){
											$initial_balances_sum = $deposit_account_obj->findSpecifics("COALESCE(SUM(`openingBalance`),0) `initial_balances`",$depositAccountIds);
											$deposits_sum = $deposit_account_transaction_obj->getMoneySum(1,$depositAccountIds);
											$withdraws_sum = $deposit_account_transaction_obj->getMoneySum(2,$depositAccountIds);
											
											$balance =  $deposits_sum - $withdraws_sum; 
											if($balance > 1){
												$minimum_amount = $initial_balances_sum['initial_balances'];
												$available = $balance - $minimum_amount;
											}else{
												$available = 0;
											} ?>
												<div class="col-md-5 col-sm-12 col-xs-12 ">
													<p class="p"><b>Savings (UGX): <?php   echo number_format($available,2,".",","); ?></b></p>
												</div>
										<?php }?>
										<?php
										$member_loan_account_obj = new MemberLoanAccount();
										$loan_account_obj = new LoanAccount();
										$loan_repayment_obj = new LoanRepayment();
										$loanAccountIds = $member_loan_account_obj->findSpecifics("`loanAccountId`", "`memberId`=".$member_data['id']);
										if($loanAccountIds){
											$loan_amounts = $loan_account_obj->getLoanAmounts($loanAccountIds[0]["loanAccountId"]);
											//$loan_penalties = $loan_account_obj->getAppliedPenalties($loanAccountIds);
											//$loan_fees = $loan_account_obj->getLeviedFees($loanAccountIds);
											
											$loan_amount =  $loan_amounts['disbursed'] + ($loan_amounts['disbursed']*$loan_amounts['interest']/100);
											$balances = 0;
											if($loan_amount > 1){
												$amount_paid = $loan_repayment_obj->getPaidAmount("`loanAccountId`=".$loanAccountIds[0]["loanAccountId"]);
												$balances = $loan_amount - $amount_paid['paidAmount'];
											} ?>
												<div class="col-md-5 col-sm-12 col-xs-12 ">
													<p class="p"><b>Unpaid Loan Balances (UGX): <?php  echo number_format($balances,2,".",",");  ?></b></p>
												</div>
										<?php }?>												
											</div>
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
  include("js/members_js.php");
  if(isset($_GET['view'])){
	  switch($_GET['view']){
		case 'loan_accs':
			include("js/loanAccount.php");
		break;
		case 'savings_accs':
			include("js/depositAccount.php");
		break;
		case 'ledger':
			include("js/ledger_js.php");
		break;
	  }
  }
?>