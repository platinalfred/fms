<?php 
require_once("lib/Libraries.php");
Class Reports{
	public function __construct($task){
	   $this->task = $task;
	  
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
			case 'nok';
				$this->viewNok();
			break;
			case 'mysavings';
				$this->viewMemberSaving();
			break;
			default:
				$this->personType();
			break;
			default:
				$this->defaultDisplay();
			break;
		}
	}
	public function defaultDisplay(){ ?>
		<div class="alert alert-warning">
			The information you are looking for is currently unavailable.
		</div>
		<?php
	}
	public function viewClientLoans(){ 
		?>
		<p>This is a test report</p>
		<?php	
	}
	public function clientTransactionHistory(){ 
		$accounts  = new Accounts();
		?>
		<div class="page-title" >
		  <div class="title_left" style="width:35%;">
			<h3>Transactions <small>your transactions</small></h3> 
		  </div>
		  <div class="title_right" style="width:55%;">
			<div class="col-md-12 col-sm-12 col-xs-12 form-group">
				<div id="reportrange" class="pull-left" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
				  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
				  <span>December 30, 2014 - January 28, 2015</span> <b class="caret"></b>
				</div>
				<span style="margin-top: 40px; margin-left:10px;">Select a transaction period</span>
			</div>
		  </div>
		</div>
		<div class="clearfix"></div>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_content">
				<div id="report_data" class="col-md-12 co">
				</div>
			  </div>
			</div>
		  </div>
		</div>
		<?php
	}
	public function memberLoans(){
		$member = new Member();
		$accounts = new Accounts();
		$loans = new Loans();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		$member_loans = $loans->findMemberLoans($member_data['person_number']); //->findAll();//
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><?php echo $account_names['firstname']." ".$account_names['lastname']; ?> <small> loans details</small></h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($member_loans){  ?>
							<div class="table-responsive">
							  <table class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									<th>
									  <input type="checkbox" id="check-all" class="flat">
									</th>
									<?php 
									$header_keys = array("Loan Number", "Loan Type", "Principal", "Interest", "Total PayBack","Loan Date","Duration", "Expected PayBack Date");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									<th class="column-title no-link last"><span class="nobr">Action</span>
									</th>
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($member_loans as $single){ 
										
										$interest = 0;
										if($single['interest_rate'] > 0){
											$interest = ($single['loan_amount'] * ($single['interest_rate']/100));
										}
										?>
										<tr class="even pointer <?php if($loans->isLoanAboutToExpire($single['id'], $single['repayment_duration'])){ echo "danger"; } ?>" >
											<td class="a-center ">
												<input type="checkbox" value="<?php echo $single['id']; ?>" class="flat" name="table_records">
											</td>
											<td class=""><?php echo $single['loan_number']; ?></td>
											<td class=""><?php echo $loans->findLoanType($single['loan_type']); ?> </td>
											<td class=""><?php echo $single['loan_amount']; ?> </td>
											<td class=""><?php  echo $interest; ?></td>
											<td class=" "><?php echo $single['loan_amount'] + $interest; ?></td>
											<td class="a-right a-right"><?php echo date("j F, Y", strtotime($single['loan_date'])); ?></td>
											<td class="a-right a-right"><?php $months = round((($single['loan_duration']>0)?($single['loan_duration']/30):0),1); echo $months; ?> month<?php echo $months==1?"":"s"; ?></td>
											<td class="a-right a-right"><?php echo date("F j, Y", strtotime($single['loan_end_date'])); ?></td>
											<td class=" last"><a href="#" class="btn btn-primary">View</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no loans subscribed by this member.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function subScriptions(){
		$member = new Member();
		$accounts = new Accounts();
		$subscription = new Subscription();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		$all_client_subscriptions = $subscription->findMemberSubscriptions($member_data['person_number']); 
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><?php echo $account_names['firstname']." ".$account_names['lastname']; ?> <small> Subscriptions </small></h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_client_subscriptions){  ?>
							<div class="table-responsive">
							  <table class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									
									<?php 
									$header_keys = array("Amount", "Year", "Date Subscribed");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_client_subscriptions as $single){ 
										?>
										<tr class="even pointer " >
											<td class=" "><?php echo $single['amount']; ?></td>
											<td class=" "><?php echo $single['subscription_year']; ?> </td>
											<td class="a-right a-right "><?php echo date("j F, Y", strtotime($single['date_paid'])); ?></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "This member has not yet subscribed, pleasee add subscription.";
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
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		$all_client_shares = $shares->findMemberShares($member_data['person_number']); 
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><?php echo $account_names['firstname']." ".$account_names['lastname']; ?> <small> Shares </small></h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_client_shares){  ?>
							<div class="table-responsive">
							  <table class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									
									<?php 
									$header_keys = array("Amount", "Date Paid");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_client_shares as $single){ 
										?>
										<tr class="even pointer " >
											<td class=" "><?php echo $single['amount']; ?></td>
											<td class="a-right a-right "><?php echo date("j F, Y", strtotime($single['date_paid'])); ?></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "This member has not yet subscribed, pleasee add subscription.";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function viewNok(){
		$member = new Member();
		$accounts = new Accounts();
		$nok = new Nok();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		$noks = $nok->findMemberNextOfKin($member_data['person_number']); 
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><?php echo $account_names['firstname']." ".$account_names['lastname']; ?> <small> Next of Kin </small></h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($noks){  ?>
							<div class="table-responsive">
							  <table class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									<th>
									  <input type="checkbox" id="check-all" class="flat">
									</th>
									<?php 
									$header_keys = array("Name", "Gender", "Relationship", "Status", "Phone","Address");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									<th class="column-title no-link last"><span class="nobr">Action</span>
									</th>
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($noks as $single){ 
										?>
										<tr class="even pointer " >
											<td class="a-center ">
												<input type="checkbox" value="<?php echo $single['id']; ?>" class="flat" name="table_records">
											</td>
											<td class=" "><?php echo $single['name']; ?></td>
											<td class=" "><?php echo $single['gender']; ?> </td>
											<td class=" "><?php  echo $single['relationship']; ?></td>
											<td class=" "><?php echo $single['marital_status']; ?></td>
											<td class="a-right a-right "><?php echo $single['phone']; ?></td>
											<td class="a-right a-right "><?php  echo $single['physical_address']; ?></td>
											<td class=" last"><a href="?member_id=<?php echo $_GET['member_id']; ?>&task=editnok&nok_id=<?php echo $single['id']; ?>" class="btn btn-success">Edit</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There is currently no Next of Kin added to this member.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function viewMemberSaving(){
		$member = new Member();
		$accounts = new Accounts();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		$all_member_deposits = $accounts->findMemberDeposits($member_data['person_number']); 
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2><?php echo $account_names['firstname']." ".$account_names['lastname']; ?> <small> My savings</small></h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_member_deposits){  ?>
							<div class="table-responsive">
							  <table class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									
									<?php 
									$header_keys = array("Amount", "Amount in Words", "Deposited By","Date Deposited");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_member_deposits as $single){ 
										
										?>
										<tr class="even pointer " >
											
											<td class=" "><?php echo $single['amount']; ?></td>
											<td class=" "><?php echo $single['amount_description']; ?> </td>
											<td class=" "><?php echo $single['transacted_by']; ?></td>
											<td class="a-right a-right "><?php echo date("j F, Y", strtotime($single['transaction_date'])); ?></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "There are current no deposits.";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
}