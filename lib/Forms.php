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
			case 'share_rate.edit';
				$this->editShareRate();
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
			case 'income_sources.add';
				$this->addIncomeSource();
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
		?>
						<div class="ibox float-e-margins" id="loan_account_details">
							<div class="ibox-title">
								<h5>New Group Loan Account <small>&nbsp;</small></h5>
								<div class="ibox-tools">
									<a data-dismiss="modal">
										<i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<form class="form-horizontal" id="newGroupLoanForm" actionx="lib/AddData.php" methodx="post">
								  <div class="form-group">
                                    <input type='hidden' name="origin" value="newGroupLoanAccount" />
                                    <input type='hidden' name="saccoGroupId" value="<?php echo isset($_GET['groupId'])?$_GET['groupId']:""; ?>" />
									<label class="control-label col-md-2">Please choose a product</label>
									<div class="col-md-4">
										<select class="form-control" id="loanProductId" name="loanProductId" data-bind='options: $root.loanProducts, optionsText: "productName", optionsCaption: "Select product...", optionsAfterRender: $root.setOptionValue("id"), value: $root.loanProduct' data-msg-required="Loan product is required" required></select>
									</div>
								  </div>
								  <div class="form-group">
									<div class="col-md-4 col-md-offset-2">
									  <button type="reset" class="btn btn-white">Cancel</button>
									  <button type="submit" class="btn btn-primary">Next</button>
									</div>
								  </div>
								</form>
							  </div>
						</div>
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
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Approved By
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['person_id']); ?>" class="form-control col-md-7 col-xs-12">
						  <input type="hidden" name="received_by"  value="<?php echo $_SESSION['person_id'] ; ?>" class="form-control col-md-7 col-xs-12">
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
	function editShareRate(){
		$member = new Member();
		$shares = new Shares();
		$share_rate = $shares->findShareRate();
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Manage Share Rate<small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_share_rate" value="add_share_rate">
					<input type="hidden" name="id" value="<?php echo $share_rate['id']; ?>">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="email">Share Amount<span class="required">*</span>
						</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="number"  name="amount"  value="<?php echo $share_rate['amount']; ?>" required="required" class="form-control col-md-7 col-xs-12">
						  </div>
					  </div>
					 
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Changed By
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['person_id']); ?>" class="form-control col-md-7 col-xs-12">
						  <input type="hidden" name="added_by"  value="<?php echo $_SESSION['person_id'] ; ?>" class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="ln_solid"></div>
					  <div class="form-group">
						<div class="col-md-6 col-md-offset-3">
						  <button id="send" type="button" class="btn btn-success loginbtn save_data">Save</button>
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
		$income_sources = new IncomeSource();
		$pno = $member->findMemberPersonNumber($_GET['member_id']);
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Member Shares <small></small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<?php 
				$rate = $shares->findShareRate();
				$src = $income_sources->findIncomeSourceByName("Shares");
				?>
				<input type="hidden" id="rate_amount" name="" value="100<?php echo $rate['amount']; ?>">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_share" value="add_share">
					<input type="hidden" name="person_id" value="<?php echo $pno; ?>">
					<input type="hidden" name="income_type" value="<?php echo $src['id']; ?>">
					<div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="amount">Number of Shares<span class="required">*</span>
						</label>
							<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="number"  name="no_of_shares" id="no_of_shares"  required="required" class="form-control col-md-7 col-xs-12">
						  </div>
					</div>
					<div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="paid_by">Share Amount
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="text"  id="share_amount" name="amount"  readonly="readonly" class="form-control col-md-7 col-xs-12">
							<p id="share_rate_amount"></p>
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="paid_by">Paid By<span class="required">*</span>
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<input type="text"  name="paid_by"  class="form-control col-md-7 col-xs-12">
						</div>
					  </div>
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="telephone">Approved By
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['person_id']); ?>" class="form-control col-md-7 col-xs-12">
						  <input type="hidden" name="received_by"  value="<?php echo $_SESSION['person_id'] ; ?>" class="form-control col-md-7 col-xs-12">
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
						<input type="hidden" name="person_id" value="<?php echo $pno; ?>">
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
							  <input type="text" id="added_by" value="<?php echo   $member->findMemberNames($_SESSION['person_id']); ?>"  readonly = "readonly" class="form-control col-md-7 col-xs-12">
							   <input type="hidden"  name="added_by" required="required"  value="<?php echo $_SESSION['person_id']; ?>" class="form-control col-md-7 col-xs-12">
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
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_id']);
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
					<input type="hidden" value="<?php echo $member_data['person_id']; ?>" name="person_id">
					<input type="hidden" value="add_deposit" name="add_deposit">
					<input type="hidden" value="<?php echo $_SESSION['branch_id']; ?>" name="branch_id">
				  <div class="item form-group">
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Account Number
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="number"  name="account_number"  value="<?php echo sprintf('%08d',$accounts->findAccountNoByPersonNumber($member_data['person_id'])); ?>" readonly = "readonly"  class="form-control col-md-7 col-xs-12">
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
					<label class="control-label col-md-3 col-sm-3 col-xs-12" for="approved_by">Received By <span class="required">*</span>
					</label>
					<div class="col-md-6 col-sm-6 col-xs-12">
					  <input type="text"  readonly = "readonly" value="<?php $logged_in_as = $accounts->findAccountNamesByPersonNumber($_SESSION['person_id']); echo $logged_in_as['firstname']." ".$logged_in_as['othername']." ".$logged_in_as['lastname']; ?>"  required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
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
		$account_names = $accounts->findAccountNamesByPersonNumber($member_data['person_id']);
		$account_balance = $accounts->findByAccountBalance($member_data['person_id']);
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
						<input type="hidden" value="<?php echo $member_data['person_id']; ?>" name="person_id">
						<input type="hidden" value="2" name="withdraw_cash">
						<input type="hidden" value="<?php echo $_SESSION['branch_id']; ?>" name="branch_number">
					  <div class="item form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12" for="name">Account Number
						</label>
						<div class="col-md-6 col-sm-6 col-xs-12">
						  <input type="number"  name="account_number"  value="<?php echo $accounts->findAccountNoByPersonNumber($member_data['person_id']); ?>" readonly = "readonly"  class="form-control col-md-7 col-xs-12">
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
						  <input type="text"  readonly = "readonly" value="<?php $logged_in_as = $accounts->findAccountNamesByPersonNumber($_SESSION['person_id']); echo $logged_in_as['firstname']." ".$logged_in_as['othername']." ".$logged_in_as['lastname']; ?>"  required="required" data-validate-length-range="8,20" class="form-control col-md-7 col-xs-12">
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
				<h2>Add Expense Type<small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_expense_type" value="access_level">
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
	function addIncomeSource(){
		?>
		<div class="row">
		  <div class="col-md-12 col-sm-12 col-xs-12">
			<div class="x_panel">
			  <div class="x_title">
				<h2>Add Income Source<small> </small></h2>
				<ul class="nav navbar-right panel_toolbox">
				  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			  </div>
			  <div class="x_content">
				<form class="form-horizontal form-label-left" novalidate>
					<input type="hidden" name="add_income_source" value="access_level">
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
