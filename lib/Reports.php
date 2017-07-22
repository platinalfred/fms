<?php 
require_once("lib/Libraries.php");
Class Reports{
	public function __construct($task, $item_view=1, $data=false){
	   $this->task = $task;
	   $this->data = $data;
	   $this->item_view = $item_view;
	  
	   $this->displayOption();
	   
	}
	public function displayOption(){
		switch($this->task){
			case 'client_trasaction_history';
				$this->clientTransactionHistory();
			break;
			case 'client_loans';
				$this->memberLoans();
			break;
			case 'mysubscriptions';
				$this->subScriptions();
			break;
			case 'myshares';
				$this->viewMemberShares();
			break;
			case 'savings_accs';
				$this->viewSavingsAccs($this->data, $this->item_view);
			break;
			case 'loan_accs';
				$this->clientLoan($this->data, $this->item_view);
			break;
			case 'ledger';
				$this->ledger($this->data);
			break;
			case 'general';
				$this->viewGeneral($this->data);
			break;
			case 'individual';
				$this->viewIndividual($this->data);
			break;
			case 'subscriptions';
				$this->generalSubsriptions();
			break;
			case 'shares';
				$this->generalShares();
			break;
			default:
				$this->defaultDisplay();
			break;
		}
	}
	public function defaultDisplay(){ 
		
		?>
		<p>This is a test report</p>
		<?php	
	}

	public function clientLoan($client, $loanAccount){
		if(empty($loanAccount)){
			include_once('./loans_page.php');
		}
		else{
			//$loanAccountId = $loanAccount['loanId']);
			include_once('./loan_account_detail.php');
		}
	}
	public function viewSavingsAccs($client, $depositAccount){
		
		if(empty($depositAccount)){
			include_once('./savings_page.php');
		}else{
			//$depositAccountId = $depositAccount['loanId']);
			include_once('./deposit_account_detail.php');
		}
	}
	public function viewGeneral(){
		include_once('./general_reports.php');
	}public function viewIndividual(){
		include_once('./individual_reports.php');
	}
	public function generalSubsriptions(){
		include_once('./general_subscriptions.php');
	}
	public function generalShares(){
		include_once('./general_shares.php');
	}
	public function ledger(){ 
		include_once('./ledger.php');
	}
	

	public function subScriptions(){
		$member = new Member();
		$accounts = new Accounts();
		$subscription = new Subscription();
		if(isset($_POST['tbl']) && $_POST['tbl'] == "add_subscription"){
			if($subscription->addSubscription($_POST)){
				$msg = "Subscription Successful added"; ?>
				<script>
				setTimeout(function(){
					document.getElementsByClassName("label-warning").innerHTML = "";
				}, 3000);
				</script>
				<?php
			}else{
				$msg = "Failed to add subscrition";
				?>
				<script>
				setTimeout(function(){
					document.getElementsByClassName("label-warning").innerHTML = "";
				}, 3000);
				</script>
				<?php
			}
		}
	
		$member_data = $member->findById($_GET['id']);
		$all_client_subscriptions = $subscription->findMemberSubscriptions($_GET['id']); 
		include("subscribe.php"); ?>
		 <div class="row">
			<div class="ibox">
			  <div class="ibox-title">
				<h2> <small>Subscriptions </small></h2>
				<?php
				if(isset($_SESSION['accountant'])){ ?>
					<div class="ibox-tools">
						<a data-toggle="modal" class="btn btn-sm btn-primary" href="#add_subscription"><i class="fa fa-plus"></i> Subscribe</a>
					</div>
					<?php 
				}
				?>
				<div class="clearfix"></div>
				<span class="label-warning"><?php echo @$msg; ?></span>
			  </div>
			  <div class="ibox-content">
					
					<div class="table-responsive">
					  <table id="subTable" class="table table-striped">
						<thead>
							<tr class="headings">
								<?php 
								$header_keys = array("Date Subscribed", "Year", "Amount");
								foreach($header_keys as $key){ ?>
									<th><?php echo $key; ?></th>
									<?php
								}
								?>
							</tr>
						</thead>

						<tbody>
							<?php
							if($all_client_subscriptions){
								$subscription_sum = 0;
								foreach($all_client_subscriptions as $single){ 
									?>
									<tr class="even pointer " >
										<td class="a-right a-right "><?php echo date("j F, Y",$single['datePaid']); ?></td>
										<td class=" "><?php echo $single['subscriptionYear']; ?> </td>
										<td class=" "><?php $subscription_sum += $single['amount']; echo number_format($single['amount'],2,".",","); ?></td>
									</tr>
									<?php
								}
							}
							?>
						</tbody>
						<tfoot>
							<tr class="headings">
								<th colspan="2">Total</th>
								<th><?php if($all_client_subscriptions){ echo number_format($subscription_sum,2,".",","); }else{ echo 0; }?></th>
							</tr>
						</tfoot>
					  </table>
					</div>
					
                  </div>
				</div>
		  </div>
		  
		<?php
	}
	public function viewMemberShares(){
		$member = new Member();
		$accounts = new Accounts();
		$shares = new Shares();
		if(isset($_POST['tbl']) && $_POST['tbl'] == "add_share"){
			if($shares->addShares($_POST)){
				$msg = "Shares details successful added"; ?>
				<script>
				setTimeout(function(){
					document.getElementsByClassName("label-warning").innerHTML = "";
				}, 3000);
				</script>
				<?php
			}else{
				$msg = "Failed to add shares";
				?>
				<script>
				setTimeout(function(){
					document.getElementsByClassName("label-warning").innerHTML = "";
				}, 3000);
				</script>
				<?php
			}
		}
		$member_data = $member->findById($_GET['id']);
		$all_client_shares = $shares->findMemberShares($member_data['id']); 
		include("add_share.php");
		?>
		 <div class="row">
		 
                <div class="ibox">
                  <div class="ibox-title">
                    <h2><small>Shares </small></h2>
					<?php
					
					if(isset($_SESSION['accountant'])){ print_r($_SESSION);?>
						<div class="ibox-tools">
							<a data-toggle="modal" class="btn btn-sm btn-primary" href="#add_shares"><i class="fa fa-plus"></i> Buy Share</a>
						</div>
					<?php 
					}
					?>
                    <div class="clearfix"></div>
					<span class="label-warning"><?php echo @$msg; ?></span>
                  </div>

                  <div class="ibox-content">
						<?php 
						if($all_client_shares){  ?>
							<div class="table-responsive">
							  <table class="table table-striped jambo_table">
								<thead>
								  <tr class="headings">
																		
									<?php 
									$header_keys = array("Purchase Date","Number of Shares",  "Amount Paid");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
								  </tr>
								  
								</thead>
								<tbody>
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
								</tbody>
								</tfoot>
									<tr>
										<th colspan="1">Total Shares</th>
										<th class="a-right"><?php echo $no; ?></th>
										<th class="a-right " colspan="2"><?php echo number_format($shares_sum,0,".",","); ?></th>
									</tr>
								</tfoot>
							  </table>
							</div>
						<?php 
						}else{
							echo "This member has not yet bought shares, please add shares.";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}

}