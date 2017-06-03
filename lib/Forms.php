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
			case 'editnok';
				$this->editNextOfKin();
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
			<input type="hidden" name="add_loan" value="add_loan" >
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
							$db->loadList("SELECT * FROM loan_type", "loan_type", "id","name","loan_type");
							?>
						</div>
					  </div>					
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="branch_id">Awarding Branch<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						<input type="hidden" value="<?php echo $_SESSION['branch_number']; ?>" name="branch_number">
						  <input type="text" id="branch_number" name=""  readonly = "readonly"  value="<?php echo  $branch['branch_name']; ?>" class="form-control col-md-7 col-xs-12">
						</div>
					  </div>					
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="branch_id">Guarantors<span class="required">*</span>
						</label>
						<div class="col-md-2 col-sm-2 col-xs-12">
						<span class="btn btn-primary" data-toggle="modal" data-target=".guarantors-modal"><i class="fa fa-plus"></i>/<i class="fa fa-minus"></i> Guarantors</span>
						</div>
						<div class="col-md-4 col-sm-4 col-xs-12" data-bind="foreach: selectedGuarantors">
							<span class='btn' data-bind='with: guarantor'>
								<i data-bind='text: member_names' > </i>
							</span>
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
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="loan_duration">Loan Duration <span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<select name="loan_duration" id="loan_duration" class="form-control col-md-7 col-xs-12">
								<option>Please select </option>
								<option value="7"> 1 week</option>
								<option value="30">1 month</option>
						   <?php for($i=2; $i<25;$i++){?>}
								<option value="<?php echo ($i*30);?>"> <?php echo $i; ?> months</option>
							<?php }?>
							</select>
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="loan_end_date">Loan End Date <span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<input  type="hidden" id="loan_end_date"  name="loan_end_date">
						  <input  type="text" id="loan_end_date1" readonly name="" class="form-control  col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="daily_default">Daily Charge Upon Default (%) 	</label>
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
									<div class="col-md-1 col-sm-1 col-xs-12"><button data-dismiss="modal" data-bind='enable: totalSavings()>0' class="btn btn-info btn-sm"><i class="fa fa-check"></i>Submit</button></div>
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
		$pno = $member->findMemberPersonNumber($_GET['id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="ibox">
				<div class="ibox-title">
					<h2>Add Subscription <small></small></h2>
					<ul class="nav navbar-right panel_toolbox">
					  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
					</ul>
					<div class="clearfix"></div>
				</div>
				<div class="ibox-content">
					<form class="form-horizontal form-label-left" novalidate>
						<input type="hidden" name="tbl" value="subscription">
						<input type="hidden" name="person_id" value="<?php echo $pno; ?>">
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
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Received By
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['id']); ?>" class="form-control col-md-7 col-xs-12">
							  <input type="hidden" name="received_by"  value="<?php echo $_SESSION['id'] ; ?>" class="form-control col-md-7 col-xs-12">
							</div>
						  </div>
						  <div class="ln_solid"></div>
						  <div class="form-group">
							<div class="col-md-6 col-md-offset-3">
							  <button id="send" type="button" class="btn btn-primary loginbtn save">Add Subscription</button>
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
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="ibox">
				<div class="ibox-title">
					<h2 class="center">Add Shares <small> bought by this member</small></h2>
					<ul class="nav navbar-right panel_toolbox">
					  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
					</ul>
					<div class="clearfix"></div>
				</div>
				<div class="ibox-content">
					<form class="form-horizontal form-label-left" novalidate>
						<input type="hidden" name="tbl" value="shares">
						<input type="hidden" name="person_id" value="<?php echo $_GET['id']; ?>">
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
							  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['id']); ?>" class="form-control col-md-7 col-xs-12">
							  <input type="hidden" name="received_by"  value="<?php echo $_SESSION['id'] ; ?>" class="form-control col-md-7 col-xs-12">
							</div>
						  </div>
						  <div class="ln_solid"></div>
						  <div class="form-group">
							<div class="col-md-6 col-md-offset-3">
							  <button id="send" type="button" class="btn btn-primary loginbtn save_data">Add Shares</button>
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
	function editNextOfKin(){
		$nok = new Nok();
		$member = new Member();
		$nok_data = $nok->findById($_GET['nok_id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Next of Kin (NOK)<small> Edit form</small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
					<form class="form-horizontal form-label-left" novalidate>
						<input type="hidden" name="editnok" value="editnok">
						<input type="hidden" name="id" value="<?php echo $nok_data['id']; ?>">
						<input type="hidden" value="<?php echo $nok_data['person_number']; ?>" name="person_number" >
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Name <span class="required">*</span>
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <input id="name" class="form-control col-md-7 col-xs-12" value="<?php echo $nok_data['name']; ?>" data-validate-length-range="6" data-validate-words="2" name="name" placeholder="both name(s) e.g Platin Alfred Mugasa" required="required" type="text">
							</div>
						</div>
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="relationship">Relationship</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<select class="form-control" name="relationship">
									<option <?php if($nok_data['relationship'] == "Husband"){ echo "selected"; } ?> value="Husband">Husband</option>
									<option <?php if($nok_data['relationship'] == "Wife"){ echo "selected"; } ?> value="Wife" >Wife</option>
									<option <?php if($nok_data['relationship'] == "Father"){ echo "selected"; } ?> value="Father">Father</option>
									<option <?php if($nok_data['relationship'] == "Mother"){ echo "selected"; } ?> value="Mother">Mother</option>
									<option <?php if($nok_data['relationship'] == "Uncle"){ echo "selected"; } ?> value="Uncle">Uncle</option>
									<option <?php if($nok_data['relationship'] == "Auntie"){ echo "selected"; } ?> value="Auntie">Auntie</option>
									<option <?php if($nok_data['relationship'] == "Brother"){ echo "selected"; } ?> value="Brother">Brother</option>
									<option <?php if($nok_data['relationship'] == "Sister"){ echo "selected"; } ?> value="Sister">Sister</option>
								</select>
							</div>
						</div>
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="gender">Gender<span class="required">*</span>
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <div class="col-md-6 col-sm-6 col-xs-12">
									Male: <input type="radio" <?php if($nok_data['gender'] == "Male"){ echo "selected"; } ?> class="flat" name="gender" id="genderM" value="Male" checked=""  /> Female:
									<input type="radio" <?php if($nok_data['gender'] == "Female"){ echo "selected"; } ?> class="flat" name="gender" id="genderF" value="Female" />
								</div>
							</div>
						 </div>	
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="marital">Marital Status</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<select class="form-control" name="marital_status">
									<option value="single" <?php if($nok_data['marital_status'] == "single"){ echo "selected"; } ?> >Single</option>
									<option value="married" <?php if($nok_data['marital_status'] == "married"){ echo "selected"; } ?> >Maried</option>
									<option value="divorced" <?php if($nok_data['marital_status'] == "divorced"){ echo "selected"; } ?>>Divorced</option>
								</select>
							</div>
						  </div>	
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="phone">Telephone<span class="required">*</span></label>
							<div class="col-md-6 col-sm-6 col-xs-12">
								<input type="text"  name="phone" value="<?php echo $nok_data['phone']; ?>"  data-inputmask="'mask' : '9999 999-999'" required="required" data-validate-minmax="10,100" class="form-control col-md-7 col-xs-12">
							</div>
						  </div>
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="physical_address">Physical Address<span class="required">*</span>
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <textarea id="physical_address" required="required" name="physical_address" class="form-control col-md-7 col-xs-12"><?php echo $nok_data['physical_address']; ?></textarea>
							</div>
						  </div>
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="postal_address">Postal address
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							  <textarea id="postal_address"  name="postal_address" class="form-control col-md-7 col-xs-12"><?php echo $nok_data['postal_address']; ?></textarea>
							</div>
						  </div>
						  <div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12" for="added_by">Added By 
							</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							 
							   
							   <input type="text" id="added_by" value="<?php echo $member->findMemberNames($nok_data['added_by']);  ?>"  readonly = "readonly" class="form-control col-md-7 col-xs-12">
							   <input type="hidden"  name="added_by" required="required"  value="<?php echo $nok_data['added_by']; ?>" class="form-control col-md-7 col-xs-12">
							</div>
						  </div>
						  <div class="ln_solid"></div>
						  <div class="form-group">
							<div class="col-md-6 col-md-offset-3">
							  <button id="send" type="button" class="btn btn-success loginbtn save_data">Update</button>
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
		$accounts = new Accounts();
		$member = new Member();
		$member_data  = $member->findMemberDetails($_GET['id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="ibox">
			  <div class="ibox-title">
				<h2>Deposit on <small> <b><?php echo $member_data ['firstname']." ".$member_data['othername']." ".$member_data['lastname']; ?> a/c</small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="ibox-content">
				<form class="form-horizontal form-label-left"  action="" method="" novalidate>
					<input type="hidden" value="account" name="tbl">
					<input type="hidden" value="<?php echo $member_data['personId']; ?>" name="person_id">
					<input type="hidden" value="tbl" name="deposit">
					<input type="hidden" value="<?php echo $_SESSION['branch_id']; ?>" name="branch_id">
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Account Number
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="number"  name="account_number"  value="<?php echo sprintf('%08d',$accounts->findAccountNumberByPersonNumber($member_data['id']));?>" readonly = "readonly"  class="form-control col-md-7 col-xs-12">
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
					  <input type="text"  readonly = "readonly" value="<?php $logged_in_as = $accounts->findAccountNamesByPersonNumber($_SESSION['id']); echo $logged_in_as['firstname']." ".$logged_in_as['othername']." ".$logged_in_as['lastname']; ?>"  required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
					  <input type="hidden" id="approved_by" name="approved_by" value="<?php echo $_SESSION['id']; ?>">
					</div>
				  </div>
				 <input type="hidden" name="transaction_type" value="deposit">
				  <div class="ln_solid"></div>
				  <div class="form-group">
					<div class="col-md-6 col-md-offset-3">
					  <button type="button" class="btn btn-primary">Cancel</button>
					  <button id="send" type="button" class="btn btn-primary loginbtn save_data">Deposit</button>
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
		
		$accounts = new Accounts();
		$member = new Member();
		$member_data  = $member->findMemberDetails($_GET['id']);
		$minimum_amount = $accounts->findMinimumBalance();
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['personId']);
		$account_balance = $accounts->findByAccountBalance($member_data['personId']);
		$max_withdraw = $account_balance - $minimum_amount;
		
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="ibox">
			  <div class="ibox-title">
				<h2>Withdraw From <small> <b><?php echo ucfirst($account_names['firstname'])." ".ucfirst($account_names['othername'])." ".ucfirst($account_names['lastname']); ?> A/C</b></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			 <div class="ibox-content">
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
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>All form elements <small>With custom checbox and radion elements.</small></h5>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-up"></i>
							</a>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#">
								<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
								<li><a href="#">Config option 1</a>
								</li>
								<li><a href="#">Config option 2</a>
								</li>
							</ul>
							<a class="close-link">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content">
						<form method="get" class="form-horizontal">
							<div class="form-group"><label class="col-sm-2 control-label">Normal</label>

								<div class="col-sm-10"><input type="text" class="form-control"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Help text</label>
								<div class="col-sm-10"><input type="text" class="form-control"> <span class="help-block m-b-none">A block of help text that breaks onto a new line and may extend beyond one line.</span>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Password</label>

								<div class="col-sm-10"><input type="password" class="form-control" name="password"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Placeholder</label>

								<div class="col-sm-10"><input type="text" placeholder="placeholder" class="form-control"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-lg-2 control-label">Disabled</label>

								<div class="col-lg-10"><input type="text" disabled="" placeholder="Disabled input here..." class="form-control"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-lg-2 control-label">Static control</label>

								<div class="col-lg-10"><p class="form-control-static">email@example.com</p></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Checkboxes and radios <br/>
								<small class="text-navy">Normal Bootstrap elements</small></label>

								<div class="col-sm-10">
									<div><label> <input type="checkbox" value=""> Option one is this and that&mdash;be sure to include why it's great </label></div>
									<div><label> <input type="radio" checked="" value="option1" id="optionsRadios1" name="optionsRadios"> Option one is this and that&mdash;be sure to
										include why it's great </label></div>
									<div><label> <input type="radio" value="option2" id="optionsRadios2" name="optionsRadios"> Option two can be something else and selecting it will
										deselect option one </label></div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Inline checkboxes</label>

								<div class="col-sm-10"><label class="checkbox-inline"> <input type="checkbox" value="option1" id="inlineCheckbox1"> a </label> <label class="checkbox-inline">
									<input type="checkbox" value="option2" id="inlineCheckbox2"> b </label> <label class="checkbox-inline">
									<input type="checkbox" value="option3" id="inlineCheckbox3"> c </label></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Checkboxes &amp; radios <br/><small class="text-navy">Custom elements</small></label>

								<div class="col-sm-10">
									<div class="i-checks"><label> <input type="checkbox" value=""> <i></i> Option one </label></div>
									<div class="i-checks"><label> <input type="checkbox" value="" checked=""> <i></i> Option two checked </label></div>
									<div class="i-checks"><label> <input type="checkbox" value="" disabled="" checked=""> <i></i> Option three checked and disabled </label></div>
									<div class="i-checks"><label> <input type="checkbox" value="" disabled=""> <i></i> Option four disabled </label></div>
									<div class="i-checks"><label> <input type="radio" value="option1" name="a"> <i></i> Option one </label></div>
									<div class="i-checks"><label> <input type="radio" checked="" value="option2" name="a"> <i></i> Option two checked </label></div>
									<div class="i-checks"><label> <input type="radio" disabled="" checked="" value="option2"> <i></i> Option three checked and disabled </label></div>
									<div class="i-checks"><label> <input type="radio" disabled="" name="a"> <i></i> Option four disabled </label></div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Inline checkboxes</label>

								<div class="col-sm-10"><label class="checkbox-inline i-checks"> <input type="checkbox" value="option1">a </label>
									<label class="checkbox-inline i-checks"> <input type="checkbox" value="option2"> b </label>
									<label class="checkbox-inline i-checks"> <input type="checkbox" value="option3"> c </label></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Select</label>

								<div class="col-sm-10"><select class="form-control m-b" name="account">
									<option>option 1</option>
									<option>option 2</option>
									<option>option 3</option>
									<option>option 4</option>
								</select>

									<div class="col-lg-4 m-l-n"><select class="form-control" multiple="">
										<option>option 1</option>
										<option>option 2</option>
										<option>option 3</option>
										<option>option 4</option>
									</select></div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group has-success"><label class="col-sm-2 control-label">Input with success</label>

								<div class="col-sm-10"><input type="text" class="form-control"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group has-warning"><label class="col-sm-2 control-label">Input with warning</label>

								<div class="col-sm-10"><input type="text" class="form-control"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group has-error"><label class="col-sm-2 control-label">Input with error</label>

								<div class="col-sm-10"><input type="text" class="form-control"></div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Control sizing</label>

								<div class="col-sm-10"><input type="text" placeholder=".input-lg" class="form-control input-lg m-b">
									<input type="text" placeholder="Default input" class="form-control m-b"> <input type="text" placeholder=".input-sm" class="form-control input-sm">
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Column sizing</label>

								<div class="col-sm-10">
									<div class="row">
										<div class="col-md-2"><input type="text" placeholder=".col-md-2" class="form-control"></div>
										<div class="col-md-3"><input type="text" placeholder=".col-md-3" class="form-control"></div>
										<div class="col-md-4"><input type="text" placeholder=".col-md-4" class="form-control"></div>
									</div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Input groups</label>

								<div class="col-sm-10">
									<div class="input-group m-b"><span class="input-group-addon">@</span> <input type="text" placeholder="Username" class="form-control"></div>
									<div class="input-group m-b"><input type="text" class="form-control"> <span class="input-group-addon">.00</span></div>
									<div class="input-group m-b"><span class="input-group-addon">$</span> <input type="text" class="form-control"> <span class="input-group-addon">.00</span></div>
									<div class="input-group m-b"><span class="input-group-addon"> <input type="checkbox"> </span> <input type="text" class="form-control"></div>
									<div class="input-group"><span class="input-group-addon"> <input type="radio"> </span> <input type="text" class="form-control"></div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Button addons</label>

								<div class="col-sm-10">
									<div class="input-group m-b"><span class="input-group-btn">
										<button type="button" class="btn btn-primary">Go!</button> </span> <input type="text" class="form-control">
									</div>
									<div class="input-group"><input type="text" class="form-control"> <span class="input-group-btn"> <button type="button" class="btn btn-primary">Go!
									</button> </span></div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">With dropdowns</label>

								<div class="col-sm-10">
									<div class="input-group m-b">
										<div class="input-group-btn">
											<button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button">Action <span class="caret"></span></button>
											<ul class="dropdown-menu">
												<li><a href="#">Action</a></li>
												<li><a href="#">Another action</a></li>
												<li><a href="#">Something else here</a></li>
												<li class="divider"></li>
												<li><a href="#">Separated link</a></li>
											</ul>
										</div>
										 <input type="text" class="form-control"></div>
									<div class="input-group"><input type="text" class="form-control">

										<div class="input-group-btn">
											<button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button">Action <span class="caret"></span></button>
											<ul class="dropdown-menu pull-right">
												<li><a href="#">Action</a></li>
												<li><a href="#">Another action</a></li>
												<li><a href="#">Something else here</a></li>
												<li class="divider"></li>
												<li><a href="#">Separated link</a></li>
											</ul>
										</div>
										</div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group"><label class="col-sm-2 control-label">Segmented</label>

								<div class="col-sm-10">
									<div class="input-group m-b">
										<div class="input-group-btn">
											<button tabindex="-1" class="btn btn-white" type="button">Action</button>
											<button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><span class="caret"></span></button>
											<ul class="dropdown-menu">
												<li><a href="#">Action</a></li>
												<li><a href="#">Another action</a></li>
												<li><a href="#">Something else here</a></li>
												<li class="divider"></li>
												<li><a href="#">Separated link</a></li>
											</ul>
										</div>
										<input type="text" class="form-control"></div>
									<div class="input-group"><input type="text" class="form-control">

										<div class="input-group-btn">
											<button tabindex="-1" class="btn btn-white" type="button">Action</button>
											<button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><span class="caret"></span></button>
											<ul class="dropdown-menu pull-right">
												<li><a href="#">Action</a></li>
												<li><a href="#">Another action</a></li>
												<li><a href="#">Something else here</a></li>
												<li class="divider"></li>
												<li><a href="#">Separated link</a></li>
											</ul>
										</div>
										</div>
								</div>
							</div>
							<div class="hr-line-dashed"></div>
							<div class="form-group">
								<div class="col-sm-4 col-sm-offset-2">
									<button class="btn btn-white" type="submit">Cancel</button>
									<button class="btn btn-primary" type="submit">Save changes</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
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
								<option value="7"> 1 Week</option>
								<option value="30">1 Month</option>
						   <?php for($i=2; $i<25;$i++){?>}
								<option value="<?php echo ($i*30);?>"> <?php echo $i; ?> months</option>
							<?php }?>
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
}?>
