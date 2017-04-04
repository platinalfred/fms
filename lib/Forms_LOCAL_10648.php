<?php 
require_once("lib/Libraries.php");
Class Forms{
	public function __construct($task){
	   $this->task = $task;
	   $this->displayOption();
	}
	
	public function displayOption(){
		switch($this->task){
			case 'default.add';
				$this->defaultDisplay();
			break;
			case 'loan.add';
				$this->addLoan();
			break;
			case 'subscription.add';
				$this->addSubscription();
			break;
			case 'shares.add';
				$this->addShares();
			break;
			
			case 'security.add';
				$this->addSecurity();
			break;
			case 'repayment.add';
				$this->LoanRepayment();
			break;
			case 'nok.add';
				$this->nextOfKin();
			break;
			case 'deposit.add';
				$this->depositToAccount();
			break;
			case 'withdraw.add';
				$this->withdrawFromAccount();
			break;
			
			case 'security_type.add';
				$this->addSecurityType();
			break;
			case 'member_type.add';
				$this->addMemberType();
			break;
			case 'branch.add';
				$this->addBranch();
			break;
			case 'loan_type.add';
				$this->addLoanType();
			break;
			case 'loan_repayment_durarion.add';
				$this->addLoanRepaymentDuration();
			break;
			
			case 'access_level.add';
				$this->addAccessLevel();
			break;
			case 'expensetype.add';
				$this->addExpenseType();
			break;
			default:
				$this->defaultDisplay();
			break;
		}
	}
	function defaultDisplay(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
				<div class="x_panel">
					<div class="x_title">
						<h2>Default content<small>choose another action or please seek assistance</small></h2>
						<ul class="nav navbar-right panel_toolbox">
						  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
						</ul>
						<div class="clearfix"></div>
					  </div>
					<div class="x_content">
						<h2>The contents your looking for can not be found</h2>
					</div>
				</div>
			</div>
		</div>
	
		<?php
	}	
	function addLoan(){
		$db = new Db();
		$bno = $_SESSION['branch_number'];
		 $branch = $db->getfrec("branch","branch_name", "branch_number='BR00001'","", "");
		 $branch_name = $branch['branch_name'];
		$initials = ($branch['branch_name'] != "")? strtoupper($branch['branch_name']) : strtoupper(substr($branch_name, 0, 3));
         $date = date("ymdis");
         $loan_number =  $initials."-".$date; 
		?>
		
		<form class="form-horizontal form-label-left" novalidate>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Loan Information <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				 <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="loan_number">Loan Number <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input id="loan_number" value="<?php echo $loan_number;?>" class="form-control col-md-7 col-xs-12"  name="loan_number" placeholder="<?php echo $loan_number; ?>"  readonly = "readonly" type="text">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">Loan Type <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<?php
						$db->loadList("Select * from loan_type", "loan_type", "id","name","loan_type");
						?>
					</div>
				  </div>					
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="branch_id">Awarding Branch<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text" id="branch_number" name="branch_number"  readonly = "readonly"  value="<?php echo $_SESSION['branch_number']; ?>" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>					
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="branch_id">Guarantors<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					<span class="btn btn-primary" data-toggle="modal" data-target=".guarantors-modal">Guarantors <i class="fa fa-plus"></i></span>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="loan_amount">Loan Amount <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="number" id="loan_amount" name="loan_amount"  maxlength="128" required="required" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="item form-group" >
					<label class="control-label col-md-3 col-sm-3 col-xs-12"  for="loan_amount_word">Amount In Words</label>
					<div class="col-md-6 col-sm-6 col-xs-12" id="number_words">
					  
					</div>
					<input type="hidden" id="loan_amount_word" type="hidden" name="loan_amount_word"  class="form-control col-md-7 col-xs-12">
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="interest_rate">Loan Interest Rate(%) <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input  type="number" id="interest_rate"  name="interest_rate" required="required" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="item form-group" >
					<label class="control-label col-md-3 col-sm-3 col-xs-12"  for="expected_payback">Expected Payback Amount</label>
					<div class="col-md-6 col-sm-6 col-xs-12" id="expected_payback">
					  
					</div>
					<input  type="hidden" id="expected_payback2"  name="expected_payback" required="required">
					<input  type="hidden" id="add_loan"  name="add_loan" value="">
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="repayment_duration">Repayment Duration <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <?php
						$db->loadList("Select * from repaymentduration", "repayment_duration", "id","name","repayment_duration");
						?>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="daily_default">Daily Charge Upon Default 	</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input id="daily_default_amount" type="number" name="daily_default_amount"  class="optional form-control col-md-7 col-xs-12">
					</div>
				  </div>				  
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="comments">Comments 
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="comments" required="required" name="comments" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="	approved_by">Approved By <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<?php  $d = $db->getfrec("person", "firstname, lastname",  "id = ".$_SESSION['person_number'], "", ""); 
						echo $d['firstname']. " ".$d['lastname']; ; ?>
					  <input type="hidden" id="approved_by" value="<?php echo $_SESSION['id']; ?>" readonly = "readonly" name="approved_by" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary cancel">Cancel</button>
					  <button type="button" class="btn btn-success loginbtn save_data">Submit</button>
					</div>
				  </div>
			  </div>
			</div>
		  </div>
		</div>
		
		<div class="clearfix"></div>
		 <div class="modal fade guarantors-modal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog modal-lg">
			  <div class="modal-content">

				<div class="modal-header">
				  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
				  </button>
				  <h4 class="modal-title" id="myModalLabel">Guarantors</h4>
				</div>
				<div class="modal-body">
							<script>
							<?php $member = new Member(); $member_details = $member->findById($_GET['member_id']);?>
								var memberList = <?php $members = $member->findGuarantors($member_details['person_number']); echo json_encode($members);?>;
								function get_total_members(){
									var max_size = 5;
									if(memberList.length < max_size) { max_size = memberList.length; }
									return max_size;
								}
							</script>
							<input  type="hidden"  name="person_number" value="<?php echo $member_details['person_number'];?>" required="required">
							<div class="col-md-12 col-sm-12 col-xs-12">
								<table  class="table table-striped table-condensed table-hover">
									<thead>
										<tr>
											<th>Member</th>
											<th class='contact'>Phone</th>
											<th>Shares</th>
											<th>Savings</th>
											<th>&nbsp;</th>
										</tr>
									</thead>
									<tbody data-bind='foreach: selectedGuarantors'>
										<tr>
											<td>
												<select data-bind='options: memberList, optionsText: "member_names", optionsCaption: "Select guarantor...", value: guarantor' class="form-control"> </select>
											</td>
											<td class='phone' data-bind='with: guarantor'>
												<span data-bind='text: phone' > </span>
											</td>
											<td class='shares' data-bind='with: guarantor'>
												<span data-bind='text: shares'> </span>
											</td>
											<td class='savings' data-bind='with: guarantor'>
												<span data-bind='text: savings'> </span>
												<input name = "guarantor[]" data-bind='value: person_number' type="hidden" required="required"/>
											</td>
											<td>
												<a href='#' data-bind='click: $parent.removeGuarantor' title="Remove"><span class="fa fa-times danger"></span></a>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="col-md-3 col-sm-3 col-xs-12"><button data-bind='click: addGuarantor, enable: selectedGuarantors().length < get_total_members()' class="btn btn-info btn-sm"><i class="fa fa-plus"></i>Add Guarantor</button></div>
								<div class="col-md-2 col-sm-2 col-xs-12"></div>
								<div class="col-md-3 col-sm-3 col-xs-12">Total shares: <span data-bind='text: totalShares()'> </span></div>
								<div class="col-md-3 col-sm-3 col-xs-12">Total savings: <span data-bind='text: totalSavings()'> </span></div>
								<!--div class="col-md-1 col-sm-1 col-xs-12"><button data-bind='click: save, enable: selectedGuarantors().length>0' class="btn btn-info btn-sm"><i class="fa fa-check"></i>Submit</button></div-->
							</div>
						  </div>  
						  <div class="ln_solid"></div>
						<div class="clearfix"></div>
						
					</div>
					
				</div>
			</div>
		
		</div>
		</form>	
		<div class="clearfix"></div>
		<?php
	}
	function addSecurity(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Security <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Security Type <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <select class="form-control" name="member_type">
						<option value="1" >Development</option>
						<option value="2">Member</option>
					  </select>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">Loan Number <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <select class="form-control" name="member_type">
						<option value="1" >Development</option>
						<option value="2">Member</option>
					  </select>
					</div>
				  </div>					
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">Name<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="email" id="email2" name="confirm_email" data-validate-linked="email" required="required" readonly = "readonly"  value="<?php echo $_SESSION['branch_number']; ?>" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Description <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="textarea" required="required" name="textarea" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Comments <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="textarea" required="required" name="textarea" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Approved By <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="tel" id="telephone" readonly = "readonly" name="phone" required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="submit" class="btn btn-primary">Cancel</button>
					  <button id="send" type="submit" class="btn btn-success loginbtn">Submit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function addSubscription(){
		$member = new Member();
		$subscription = new Subscription();
		$pno = $member->findMemberPersonNumber($_GET['member_id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Subscription <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_subscription" value="add_subscription">
					<input type="hidden" name="person_number" value="<?php echo $pno; ?>">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">Subscription Amount<span class="required">*</span>
						</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="number"  name="amount"  required="required" class="form-control col-md-7 col-xs-12">
						  </div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Subscription Year <span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<select class="form-control" name="subscription_year">
								<?php 
								for($i = 0; $i < 5; $i++){ 
									$year = date('Y', strtotime('+'.$i.' year'));
									if(!$subscription->isSubscribedForYear($pno, $year)){
										?>
										<option value="<?php echo $year; ?>" ><?php echo $year; ?> </option>
										<?php
									}
								}
								?>
							  </select>
						</div>
					  </div>
					  
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Paid By <span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="text"  name="paid_by"  class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Approved By
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['person_number']); ?>" class="form-control col-md-7 col-xs-12">
						  <input type="hidden" name="received_by"  value="<?php echo $_SESSION['person_number'] ; ?>" class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Add Subscription</button>
						</div>
					  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function addShares(){
		$member = new Member();
		$shares = new Shares();
		$pno = $member->findMemberPersonNumber($_GET['member_id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Manage Shares <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_share" value="add_share">
					<input type="hidden" name="person_number" value="<?php echo $pno; ?>">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="amount">Amount<span class="required">*</span>
						</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="number"  name="amount"  required="required" class="form-control col-md-7 col-xs-12">
						  </div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="paid_by">Paid By <span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="text"  name="paid_by"  class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Approved By
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['person_number']); ?>" class="form-control col-md-7 col-xs-12">
						  <input type="hidden" name="received_by"  value="<?php echo $_SESSION['person_number'] ; ?>" class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Add Shares</button>
						</div>
					  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function LoanRepayment(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add new Payement <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Loan Being Repaid<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <select class="form-control" name="member_type">
						<option value="1" >Development</option>
						<option value="2">Member</option>
					  </select>
					</div>
				  </div>
				 					
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">Amount<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="money"  name="amount" data-validate-linked="email" required="required" readonly = "readonly"  class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Justification <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="textarea" required="required" name="textarea" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Added By <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="tel" id="telephone" readonly = "readonly" name="phone" required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="submit" class="btn btn-primary">Cancel</button>
					  <button id="send" type="submit" class="btn btn-success loginbtn">Submit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function nextOfKin(){
		$member = new Member();
		$shares = new Shares();
		$pno = $member->findMemberPersonNumber($_GET['member_id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Next of Kin (NOK)<small> Add form</small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
					<form class="form-horizontal form-label-left" novalidate>
						<input type="hidden" name="addnok" value="addnok">
						<input type="hidden" name="person_number" value="<?php echo $pno; ?>">
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name <span class="required">*</span>
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <input id="name" class="form-control col-md-7 col-xs-12" data-validate-length-range="6" data-validate-words="2" name="name" placeholder="both name(s) e.g Platin Alfred Mugasa" required="required" type="text">
							</div>
						</div>
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="relationship">Relationship</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<select class="form-control" name="relationship">
									<option value="Husband">Husband</option>
									<option value="Wife" >Wife</option>
									<option value="Father">Father</option>
									<option value="Mother">Mother</option>
									<option value="Uncle">Uncle</option>
									<option value="Auntie">Auntie</option>
									<option value="Brother">Brother</option>
									<option value="Sister">Sister</option>
								</select>
							</div>
						</div>
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="gender">Gender<span class="required">*</span>
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <div class="col-md-6 col-sm-6 col-xs-12">
									Male: <input type="radio" class="flat" name="gender" id="genderM" value="Male" checked=""  /> Female:
									<input type="radio" class="flat" name="gender" id="genderF" value="Female" />
								</div>
							</div>
						 </div>	
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="marital">Marital Status</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<select class="form-control" name="marital_status">
									<option value="single" >Single</option>
									<option value="married">Maried</option>
									<option value="divorced">Divorced</option>
								</select>
							</div>
						  </div>	
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">Telephone<span class="required">*</span></label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<input type="text"  name="phone"  data-inputmask="'mask' : '9999 999-999'" required="required" data-validate-minmax="10,100" class="form-control col-md-7 col-xs-12">
							</div>
						  </div>
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="physical_address">Physical Address<span class="required">*</span>
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <textarea id="physical_address" required="required" name="physical_address" class="form-control col-md-7 col-xs-12"></textarea>
							</div>
						  </div>
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="postal_address">Postal address
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <textarea id="postal_address"  name="postal_address" class="form-control col-md-7 col-xs-12"></textarea>
							</div>
						  </div>
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="added_by">Added By 
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <input type="text" id="added_by" value="<?php echo   $member->findMemberNames($_SESSION['person_number']); ?>"  readonly = "readonly" class="form-control col-md-7 col-xs-12">
							   <input type="hidden"  name="added_by" required="required"  value="<?php echo $_SESSION['person_number']; ?>" class="form-control col-md-7 col-xs-12">
							</div>
						  </div>
						  <div class="ln_solid"></div>
						  <div class="form-group">
							<div class="col-md-6 col-md-offset-3">
							  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
							</div>
						  </div>
					</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function depositToAccount(){
		if(!isset($_GET['member_id'])){
			header("view_members.php");
		}
		$accounts = new Accounts();
		$member = new Member();
		$member_data = $member->findById($_GET['member_id']);
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Deposit to <small> <b><?php echo $account_names['firstname']." ".$account_names['othername']." ".$account_names['lastname']; ?> a/c</b></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left"  action="" method="" novalidate>
					<input type="hidden" value="<?php echo $member_data['person_number']; ?>" name="person_number">
					<input type="hidden" value="add_deposit" name="add_deposit">
					<input type="hidden" value="<?php echo $_SESSION['branch_number']; ?>" name="branch_number">
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Account Number
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="number"  name="account_number"  value="<?php echo $accounts->findAccountNoByPersonNumber($member_data['person_number']); ?>" readonly = "readonly"  class="form-control col-md-7 col-xs-12">
					</div>
				  </div>			
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="amount">Amount<span class="required">*</span></label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="number"  id="deposit_amount" name="amount"  required="required" class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="amount">Amount Description<span class="required">*</span></label>
					<div class="col-md-6 col-sm-6 col-xs-12"  id="amount_description">
					  
					</div>
					<input type="hidden"  class="amount_description" name="amount_description"  class="form-control col-md-7 col-xs-12">
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="transacted_by">Deposited By<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  name="transacted_by"  required="required"   class="form-control col-md-7 col-xs-12">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Comment </label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="textarea"  name="comments" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="approved_by">Approved By <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  readonly = "readonly" value="<?php $logged_in_as = $accounts->findAccountNamesByPersonNumber($_SESSION['person_number']); echo $logged_in_as['firstname']." ".$logged_in_as['othername']." ".$logged_in_as['lastname']; ?>"  required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
					  <input type="hidden" id="approved_by" name="approved_by" value="<?php echo $_SESSION['id']; ?>">
					</div>
				  </div>
				 <input type="hidden" name="transaction_type" value="deposit">
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary">Cancel</button>
					  <button id="send" type="button" class="btn btn-success loginbtn save_data">Deposit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
		<div class="clearfix"></div>
		<?php
	}
	function withdrawFromAccount(){
		if(!isset($_GET['member_id'])){
			header("view_members.php");
		}
		$accounts = new Accounts();
		$member = new Member();
		
		$member_data = $member->findById($_GET['member_id']);
		$minimum_amount = $accounts->findMinimumBalance();
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_number']);
		$account_balance = $accounts->findByAccountBalance($member_data['person_number']);
		$max_withdraw = $account_balance - $minimum_amount;
		
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Withdraw From <small> <b><?php echo ucfirst($account_names['firstname'])." ".ucfirst($account_names['othername'])." ".ucfirst($account_names['lastname']); ?> A/C</b></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<?php 
				if($max_withdraw < 5000){ ?>
					<h4>Your account is insufficient, you can not withdraw less than the minimum balance of <?php echo $accounts->numberFormat($minimum_amount); ?>, your current balance is <?php echo $accounts->numberFormat($account_balance); ?> </h4>
					<?php
				}else{
					?>
					<form class="form-horizontal form-label-left"  action="" method="" novalidate>
						<input type="hidden" value="<?php echo $member_data['person_number']; ?>" name="person_number">
						<input type="hidden" value="2" name="withdraw_cash">
						<input type="hidden" value="<?php echo $_SESSION['branch_number']; ?>" name="branch_number">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Account Number
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="number"  name="account_number"  value="<?php echo $accounts->findAccountNoByPersonNumber($member_data['person_number']); ?>" readonly = "readonly"  class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Maximum Withdraw Amount</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<?php 
								echo $accounts->numberFormat($max_withdraw)." (".$member->numberToWords($max_withdraw).") "; ?>
							</div>
					  </div>					  
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="withdraw_amount">Amount<span class="required">*</span></label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="number"  id="withdraw_amount" name="amount"  max="<?php echo (int)$max_withdraw; ?>"  required="required" class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="amount">Amount Description<span class="required">*</span></label>
						<div class="col-md-6 col-sm-6 col-xs-12"  id="amount_description">
						  
						</div>
						<input type="hidden"  class="amount_description" name="amount_description"  class="form-control col-md-7 col-xs-12">
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="transacted_by">Withdrawn By<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  name="transacted_by"  required="required"   class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="textarea">Comment </label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <textarea id="textarea"  name="comments" class="form-control col-md-7 col-xs-12"></textarea>
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="approved_by">Approved By <span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  readonly = "readonly" value="<?php $logged_in_as = $accounts->findAccountNamesByPersonNumber($_SESSION['person_number']); echo $logged_in_as['firstname']." ".$logged_in_as['othername']." ".$logged_in_as['lastname']; ?>"  required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
						  <input type="hidden" id="approved_by" name="approved_by" value="<?php echo $_SESSION['id']; ?>">
						</div>
					  </div>
					 <input type="hidden" name="transaction_type" value="deposit">
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Withdraw</button>
						</div>
					  </div>
					</form>
					<?php 
				}
				?>
			  </div>
			</div>
		  </div>
		</div>
		<div class="clearfix"></div>
		<?php
	}
	function addSecurityType(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Security Type <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left"  novalidate>
					<input name="add_security_type" type="hidden" value="add_security_type">
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  name="name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">Description </label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="description" name="description" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary">Cancel</button>
					  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function addMemberType(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Member Type <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_member_type" value='member_type'>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  name="name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">Description </label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="description" name="description" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary">Cancel</button>
					  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function addBranch(){
		 $this->branch = new Branch();
		 
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Branch <small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_branch" value="add_branch">
					<div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="branch_number">Branch Number
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text" readonly="readonly" value="<?php echo $this->branch->createNewBranchNumber(); ?>" name="branch_number"   class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="branch_name">Name<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  name="branch_name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="office_phone">Office Phone<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  name="office_phone" data-inputmask="'mask': '999-999-999'" required="required"   class="form-control col-md-7 col-xs-12 required_f">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email_address">Email Address
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  name="email_address"    class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					   <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="postal_address">Postal Address
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <textarea id="postal_address" name="postal_address" class="form-control col-md-7 col-xs-12"></textarea>
						</div>
					  </div>
					 <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="physical_address">Physical Address
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <textarea id="physical_address" name="physical_address" class="form-control col-md-7 col-xs-12"></textarea>
						</div>
					  </div>
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button type="button" class="btn btn-primary cancel">Cancel</button>
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
						</div>
					  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function addLoanType(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Loan Type <small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_loan_type" value="loan_type">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  name="name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">Description </label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <textarea id="textarea" name="description" class="form-control col-md-7 col-xs-12"></textarea>
						</div>
					  </div>
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button type="button" class="btn btn-primary cancel">Cancel</button>
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
						</div>
					  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
		<?php
	}
	function addAccessLevel(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Access Level <small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_access_level" value="access_level">
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  name="name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">Description </label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="textarea" name="description" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary cancel">Cancel</button>
					  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
	<?php 
	}
	function addExpenseType(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Access Level <small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_access_level" value="access_level">
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name<span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  name="name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
					</div>
				  </div>
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">Description </label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <textarea id="textarea" name="description" class="form-control col-md-7 col-xs-12"></textarea>
					</div>
				  </div>
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary cancel">Cancel</button>
					  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
					</div>
				  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
	<?php 
	}
	function addLoanRepaymentDuration(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Loan Repayment Duration <small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="repayment_duration" value="repayment_duration">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text"  name="name"  required="required"   class="form-control col-md-7 col-xs-12 required_f">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Loan Period(Days)<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						   <select class="form-control" name="payback_days">
								<option value="7"> One Week (7 days)</option>
								<option value="30">One Month (30 days)</option>
								<option value="365">1 Year (365 days)</option>
								<option value="730">2 years (365 days)</option>
								<option value="1825">5 years (365 days)</option>
								<option value="3650">10 years (365 days)</option>
								<?php 
								for($i=1000; $i >2 ;  $i--){ ?>
									<option value="<?php echo $i; ?>"><?php echo $i; ?> days</option>
									<?php
								}
								?>
								
							</select>
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="description">Description </label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <textarea id="textarea" name="description" class="form-control col-md-7 col-xs-12"></textarea>
						</div>
					  </div>
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Submit</button>
						</div>
					  </div>
				</form>
			  </div>
			</div>
		  </div>
		</div>
			
		 <div class="clearfix"></div>
	<?php 
	}
}
	?>