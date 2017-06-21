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
			case 'client_loan';
				$this->clientLoan();
			break;
			case 'expensetypes';
				$this->expenseTypes();
			break;
			case 'securitytypes';
				$this->securityTypes();
			break;
			case 'membertypes';
				$this->memberTypes();
			break;
			case 'incomesources';
				$this->incomeSource();
			break;
			case '';
				$this->memberTypes();
			break;
			case 'branches';
				$this->branches();
			break;
			case 'loantypes';
				$this->loanTypes();
			break;
			case 'ledger';
				$this->ledger();
			break;
			case '';
				$this->branches();
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
	public function memberLoans(){
		$member = new Member();
		$accounts = new Accounts();
		$loans = new Loans();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_id']);
		$member_loans = $loans->findMemberLoans("`person_id`=".$member_data['person_id']); //->findAll();//
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
							  <table id="datatable-buttons" class="table table-striped jambo_table">
								<thead>
								  <tr class="headings">
									<?php 
									$header_keys = array("Loan Number", "Date", /* "Duration", */ "End Date", "Principal", "Interest", "Total Amount", "Days Defaulted", "Penalties", "Amount Paid", "Balance", "Loan Type");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
								  </tr>
								</thead>

								<tbody>
									<?php
									$loan_sum = $expected_payback_sum = $default_amount_sum = $amount_paid_sum = $interest_sum = $balance_sum = 0;
									foreach($member_loans as $single){ 
										
										$interest = 0;
										if($single['interest_rate'] > 0){
											$interest = ($single['loan_amount'] * ($single['interest_rate']/100));
										}
										?>
										<tr class="even pointer
										<?php if($loans->isLoanAboutToExpire($single['id'], $single['repayment_duration'])){ echo "danger"; } ?>
										
										" >
											<td class=""><a href="?member_id=<?php echo $_GET['member_id'];?>&view=client_loan&lid=<?php echo $single['id'];?>"><?php echo $single['loan_number']; ?></a></td>
											<td class="a-right a-right"><?php echo date("j F, Y", strtotime($single['loan_date'])); ?></td>
											<!--td class="a-right a-right"><?php $months = round((($single['loan_duration']>0)?($single['loan_duration']/30):0),1); echo $months; ?> month<?php echo $months==1?"":"s"; ?></td-->
											<td class="a-right a-right"><?php echo date("F j, Y", strtotime($single['loan_end_date'])); ?></td>
											<td class=""><?php $loan_sum += $single['loan_amount']; echo number_format($single['loan_amount'],2,".",","); ?> </td>
											<td class=""><?php $interest_sum += $interest; echo number_format($interest,2,".",","); ?></td>
											<td class=" "><?php $expected_payback_sum += $expected_payback = $single['loan_amount'] + $interest; echo number_format($expected_payback,2,".",","); ?></td>
											<td><?php ; echo number_format($single['def_days']); ?></td>
											<td class=" "><?php $default_amount_sum += $default_amount=($single['expected_payback']*$single['def_days']*$single['daily_default_amount']/100); echo number_format($default_amount,2,".",","); ?></td>
											<td class=" "><?php $amount_paid_sum += $single['amount_paid']; echo number_format($single['amount_paid'],2,".",","); ?></td>
											<td class=" "><?php $balance_sum += $balance = $expected_payback + $default_amount - $single['amount_paid']; echo number_format($balance,2,".",","); ?></td>
											<td class=""><?php echo $loans->findLoanType($single['loan_type']); ?> </td>
										</tr>
										<?php
									}
									?>
								</tbody>
								<tfoot>
										<tr>
											<th colspan="3">Total (UGX)</th>
											<th><?php echo number_format($loan_sum,2,".",","); ?> </th>
											<th><?php echo number_format($interest_sum,2,".",","); ?></th>
											<th><?php echo number_format($expected_payback_sum,2,".",","); ?></th>
											<th>&nbsp;</th>
											<th><?php echo number_format($default_amount_sum,2,".",","); ?></th>
											<th><?php echo number_format($amount_paid_sum,2,".",","); ?></th>
											<th><?php echo number_format($balance_sum,2,".",","); ?></th>
											<th>&nbsp;</th>
										</tr>
								</tfoot>
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
	public function memberTypes(){
		$member_type = new MemberType();
		$all_member_types = $member_type->findAll();
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Member Types </h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_member_types){  ?>
							<div class="table-responsive">
							  <table id="datatable-buttons" class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									<th>
									  <input type="checkbox" id="check-all" class="flat">
									</th>
									<?php 
									$header_keys = array("Name", "Description");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									</th>
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_member_types as $single){ 
										?>
										<tr class="even pointer" >
											
											<td class=""><a href="?member_id=<?php echo $_GET['member_id'];?>&view=client_loan&lid=<?php echo $single['id'];?>"><?php echo $single['name']; ?></a></td>
											<td class=""><?php echo $single['description']; ?> </td>
											<td class="a-right a-right"><a class="btn btn-primary"><i class="fa fa-edit"></i> Edit</a><a class="btn btn-danger"><i class="fa fa-delete"> Delete</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no Member Types.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function branches(){
		$branch = new Branch();
		$branches = $branch->findAll();
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Branches </h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($branches){  ?>
							<div class="table-responsive">
							  <table id="datatable-buttons" class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									
									<?php 
									$header_keys = array("Branch Number", "Name", "Phone", "Email", "Address");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									</th>
									<th >
									  <a class="antoo" style="color:#fff; font-weight:500;">Actions <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($branches as $single){ 
										?>
										<tr class="even pointer" >
											<td class=""><?php echo $single['branch_number']; ?></td>
											<td class=""><?php echo $single['branch_name']; ?> </td>
											<td class=""><?php echo $single['office_phone']; ?> </td>
											<td class=""><?php echo $single['email_address']; ?> </td>
											<td class=""><?php echo $single['postal_address']; ?> </td>
											<td class="a-right a-right"><a class="btn btn-primary"><i class="fa fa-edit"></i> Edit</a><a class="btn btn-danger"><i class="fa fa-delete"> Delete</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no Branches.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function securityTypes(){
		$security_type = new SecurityType();
		$all_security_types = $security_type->findAll();
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Security Types </h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_security_types){  ?>
							<div class="table-responsive">
							  <table id="datatable-buttons" class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									<th>
									  <input type="checkbox" id="check-all" class="flat">
									</th>
									<?php 
									$header_keys = array("Name", "Description");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									</th>
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_security_types as $single){ 
										?>
										<tr class="even pointer" >
											
											<td class=""><?php echo $single['name']; ?></td>
											<td class=""><?php echo $single['description']; ?> </td>
											<td class="a-right a-right"><a class="btn btn-primary"><i class="fa fa-edit"></i> Edit</a><a class="btn btn-danger delete" id="<?php echo $single['id']; ?>_securitytypes"><i class="fa fa-delete"> Delete</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no Security Types.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function loanTypes(){
		$loan_type = new LoanType();
		$all_loan_types = $loan_type->findAll();
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Loan Types </h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_loan_types){  ?>
							<div class="table-responsive">
							  <table id="datatable-buttons" class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									
									<?php 
									$header_keys = array("Name", "Description");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									<th>Actions
									</th>
									
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_loan_types as $single){ 
										?>
										<tr class="even pointer" >
											
											<td class=""><?php echo $single['name']; ?></td>
											<td class=""><?php echo $single['description']; ?> </td>
											<td class="a-right a-right"><a class="btn btn-primary"><i class="fa fa-edit"></i> Edit</a><a class="btn btn-danger delete" id="<?php echo $single['id']; ?>_loantypes"><i class="fa fa-delete"> Delete</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no Security Types.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function incomeSource(){
		$income_source = new IncomeSource();
		$all_income_sources = $income_source->findAll();
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Income Sources  </h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_income_sources){  ?>
							<div class="table-responsive">
							  <table id="datatable-buttons" class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									<th>
									  <input type="checkbox" id="check-all" class="flat">
									</th>
									<?php 
									$header_keys = array("Name", "Description");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									</th>
									<th class="bulk-actions" colspan="7">
									  <a class="antoo" style="color:#fff; font-weight:500;">Bulk Actions ( <span class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_income_sources as $single){ 
										?>
										<tr class="even pointer" >
											
											<td class=""><?php echo $single['name']; ?></td>
											<td class=""><?php echo $single['description']; ?> </td>
											<td class="a-right a-right"><a class="btn btn-primary"><i class="fa fa-edit"></i> Edit</a><a class="btn btn-danger delete" id="<?php echo $single['id']; ?>_incomesources" ><i class="fa fa-delete"> Delete</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no Income Sources.</p>";
						}
						?>
                  </div>
                </div>
              </div>
           
		<?php
	}
	public function expenseTypes(){
		$expensetypes = new ExpenseTypes();
		$all_expenses = $expensetypes->findAll();
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Expense Types </h2>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<?php 
						if($all_expenses){  ?>
							<div class="table-responsive">
							  <table id="datatable-buttons" class="table table-striped jambo_table bulk_action">
								<thead>
								  <tr class="headings">
									
									<?php 
									$header_keys = array("Name", "Description");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									
									</th>
									<th>Actions
									</th>
								  </tr>
								</thead>

								<tbody>
									<?php 
									foreach($all_expenses as $single){ 
										?>
										<tr class="even pointer" >
											
											<td class=""><?php echo $single['name']; ?></td>
											<td class=""><?php echo $single['description']; ?> </td>
											<td class="a-right a-right"><a class="btn btn-primary"><i class="fa fa-edit"></i> Edit</a><a class="btn btn-danger delete" id="<?php echo $single['id']; ?>_expensetypes"><i class="fa fa-delete"> Delete</a></td>
										</tr>
										<?php
									}
									?>
								</tbody>
							  </table>
							</div>
						<?php 
						}else{
							echo "<p>There currently no Expense Types.</p>";
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
		if(isset($_POST['tbl']) && $_POST['tbl'] == "add_subscription"){
			if($subscription->addSubscription($_POST)){
				$msg = "Subscription Successful added";
			}else{
				$msg = "Failed to add subscrition";
			}
		}
	
		$member_data = $member->findById($_GET['id']);
		$all_client_subscriptions = $subscription->findMemberSubscriptions($member_data['id']); 
		
		include("subscribe.php"); ?>
		 <div class="row">
			<div class="ibox">
			  <div class="ibox-title">
				<h2> <small>My Subscriptions </small></h2>
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
									<th class=" "><?php echo number_format($subscription_sum,2,".",","); ?></th>
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
		$member_data = $member->findById($_GET['id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['personId']);
		$all_client_shares = $shares->findMemberShares($member_data['personId']); 
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
											<td><?php echo date("j F, Y", strtotime($single['date_paid'])); ?></td>
											<td><?php  echo $single['no_of_shares']; ?></td>
											<td><?php $shares_sum += $single['amount']; echo number_format($single['amount'],0,".",","); ?></td>
										</tr>
										<?php
										$no = $no+$single['no_of_shares'];
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
	public function viewNok(){
		$member = new Member();
		$accounts = new Accounts();
		$nok = new Nok();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_id']);
		$noks = $nok->findMemberNextOfKin($member_data['person_id']); 
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
									$header_keys = array("Name", "Gender", "Relationship", "Status", "Phone","Address","Edit");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
									<th class="column-title no-link last"><span class="nobr">Action</span>
									</th>
								  </tr>
								  <tr>
									<th class="bulk-actions" colspan="8">
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
											<td class=" last"><a href="?member_id=<?php echo $_GET['member_id']; ?>&edit=nok&nok_id=<?php echo $single['id']; ?>" class="btn btn-success">Edit</a></td>
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
		
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_id']);
		?>
		 <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
					  <div class="col-md-6">
						<h2><?php echo $account_names['firstname']." ".$account_names['lastname']; ?> <small> Personal Account</small></h2>
					  </div>
					  <div class="col-md-6">
						<div id="reportrange" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
						  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
						  <span>November 20, 2016 - December 19, 2016</span> <b class="caret"></b>
						</div>
					  </div>
                    <div class="clearfix"></div>
                  </div>

                  <div class="x_content">
						<div class="table-responsive">
						  <table id="savings_table" class="table table-striped dt-responsive jambo_table bulk">
							<thead>
								<tr>
									<?php 
									$header_keys = array("Date", "Deposit", "Withdraw", "Balance");
									foreach($header_keys as $key){ ?>
										<th><?php echo $key; ?></th>
										<?php
									}
									?>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
								<tr>
									<th class="right_remove">Bal c/f </th>
									<th class="right_remove left_remove"></th>
									<th class="right_remove left_remove"></th>
									<th class="right_remove left_remove"></th>
								</tr>
							</tfoot>
						  </table>
						</div>
                  </div>
                </div>
              </div>
           
		<?php
	}
}