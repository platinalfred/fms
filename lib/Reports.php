<?php 
require_once("lib/Libraries.php");
Class Reports{
	public function __construct($task, $data=false){
	   $this->task = $task;
	   $this->data = $data;
	  
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
				$this->viewSavingsAccs($this->data);
			break;
			case 'loan_accs';
				$this->clientLoan($this->data);
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

	public function clientLoan($client){
		include_once('./loans_page.php');
	}
	public function viewSavingsAccs($client){
		include_once('./savings_page.php');
	}
	public function ledger(){ 
		$loan = new Loans();
		$expense = new Expenses();
		$member = new Member();
		$accounts = new Accounts();
		$dashboard = new Dashboard();
		//This will prevent data tables js from showing on every page for speed increase
		$show_table_js = true;
		
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_id']);
		?>
		<div class="page-title" >
		  <div class="col-md-5">
			<h2>Ledger Accounts <small> <?php echo $account_names['firstname']." ".$account_names['lastname']; ?></small></h2>
		  </div>
		  <div class="col-md-7">
			<div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
			  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
			  <span>November 20, 2016 - December 19, 2016</span> <b class="caret"></b>
			</div>
		  </div>
		</div>
		<div class="clearfix"></div>
		<div class="row">
            <div class="col-md-4 col-sm-4 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Personal <small>Account</small></h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
                    <table id="ledger" class="table table-hover">
						<thead>
							<tr>
								<?php 
								$header_keys = array("&nbsp;", "Dr", "Cr");
								foreach($header_keys as $key){ ?>
									<th><?php echo $key; ?></th>
									<?php 
								} ?>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Subscription</th><td></td><td id="subscriptions">0.0</td>
							</tr>
							<tr>
								<th>Shares</th><td></td><td id="shares">0.0</td>
							</tr>
							<tr>
								<th>Deposits</th><td></td><td id="deposits">0.0</td>
							</tr>
							<tr>
								<th>Withdraws</th><td id="withdraws">0.0</td><td></td>
							</tr>
						</tbody>
                    </table>
                  </div>
                </div>
              </div>
            <div class="col-md-4 col-sm-4 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Income <small>Account</small></h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
                    <table id="income_account" class="table table-hover">
						<thead>
							<tr>
								<?php
								foreach($header_keys as $key){ ?>
									<th><?php echo $key; ?></th>
									<?php 
								} ?>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Subscription</th><td></td><td id="subscriptionss">0.0</td>
							</tr>
							<tr>
								<th>Deposits</th><td id="depositss">0.0</td><td></td>
							</tr>
							<!--tr>
								<th>Expenses</th><td></td><td id="expenses">0.0</td>
							</tr-->
						</tbody>
                    </table>
                  </div>
                </div>
              </div>
			  
            <div class="col-md-4 col-sm-4 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Loans <small>Account</small></h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                      </li>
                      <li><a class="close-link"><i class="fa fa-close"></i></a>
                      </li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
                    <table id="loans_account" class="table table-hover">
						<thead>
							<tr>
								<?php 
								$header_keys = array("&nbsp;", "Dr", "Cr");
								foreach($header_keys as $key){ ?>
									<th><?php echo $key; ?></th>
									<?php 
								} ?>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Principle + Expected Interest</th><td id="expected_payback">0</td><td></td>
							</tr>
							<tr>
								<th>Amount Paid</th><td></td><td id="amount_paid">0</td>
							</tr>
						</tbody>
                    </table>
                  </div>
                </div>
              </div>
		</div>
		<?php
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
				<div class="ibox-tools">
					<a data-toggle="modal" class="btn btn-sm btn-primary" href="#add_subscription"><i class="fa fa-plus"></i> Subscribe</a>
				</div>
				<div class="clearfix"></div>
				<span class="label-warning"><?php echo @$msg; ?></span>
			  </div>

			  <div class="ibox-content">
					<?php 
					if($all_client_subscriptions){  ?>
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
								?>
							</tbody>
							<tfoot>
								<tr class="headings">
									<th colspan="2">Total</th>
									<th><?php echo number_format($subscription_sum,2,".",","); ?></th>
								</tr>
							</tfoot>
						  </table>
						</div>
					<?php 
					}else{
						echo "This member has not yet subscribed, please add subscription.";
					}
					?>
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
					<div class="ibox-tools">
						<a data-toggle="modal" class="btn btn-sm btn-primary" href="#add_shares"><i class="fa fa-plus"></i> Buy Share</a>
					</div>
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