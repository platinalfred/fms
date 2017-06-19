<?php 
session_start();
require_once("Libraries.php");
if(isset($_POST['origin'])){
	$output = 0;
	$data = $_POST;
	switch($_POST['origin']){
		case "add_deposit":
			if(isset($data['depositAccountId'])){
				$depositAccountTransaction = new DepositAccountTransaction();
				$data['dateCreated'] = time();
				$data['transactionType'] = 1;
				$data['transactedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$output = $depositAccountTransaction->addDepositAccountTransaction($data);
			}
		break;
		case "add_withdraw":
			if(isset($data['depositAccountId'])){
				$depositAccount = new DepositAccountTransaction();
				$data['dateCreated'] = time();
				$data['transactionType'] = 2;
				$data['transactedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$output = $depositAccount->addDepositAccountTransaction($data);
			}
		break;
		case "deposit_product":
			$depositProduct = new DepositProduct();
			$data['dateCreated'] = time();
			$data['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			$output = $depositProduct->addDepositProduct($data);
		break;
		case "deposit_product_fee":
			$depositProductFee = new DepositProductFee();
			$productId = $data['productId'];
			foreach($data['feePostData'] as $feeDataItem){
				$feeDataItem['depositProductID'] = $productId;
				$feeDataItem['dateCreated'] = time();
				$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$feeDataItem['dateModified'] = time();
				$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$output = $depositProductFee->addDepositProductFee($feeDataItem);
			}
		break;
		case "loan_product":
			$loanProduct = new LoanProduct();
			$data['dateCreated'] = time();
			$data['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			unset($data['origin']);
			$output = $loanProductId = $loanProduct->addLoanProduct($data);
			
			if($loanProductId){
				//insert new loan product fees to the loan products table
				$productFees = array();
				if(isset($data['newLoanProductFees'])){
					$loanProductFee = new LoanProductFee();
					foreach($data['newLoanProductFees'] as $feeDataItem){
						$feeDataItem['dateCreated'] = time();
						$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$feeDataItem['dateModified'] = time();
						$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						/*  */
						$productFees[] = $loanProductFee->addLoanProductFee($feeDataItem);
					}
				}
				
				//then the actual fees assigned to this product
				if(isset($data['existingLoanProductFees'])){
					array_merge($productFees, $data['existingLoanProductFees']);
					$loanProductFeen = new LoanProductFeen();
					$loanProductFees = array();
					foreach($data['existingLoanProductFees'] as $productFeeDataItem){
						$loanProductFees['dateCreated'] = time();
						$loanProductFees['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$loanProductFees['dateModified'] = time();
						$loanProductFees['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$loanProductFees['loanProductId'] = $loanProductId;
						$loanProductFees['loanProductFeeId'] = $productFeeDataItem;
						$loanProductFeenId = $loanProductFeen->addLoanProductFeen($loanProductFees);
					}
				}
			}
			unset($data);
		break;
		case "deposit_account":
			$depositAccount = new DepositAccount();
			$data['dateCreated'] = time();
			$data['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			
			
			$output = $depositAccount->addDepositAccount($data);
			
			$data['depositAccountId'] = $output ;
			unset($data['openingBalance']);
			unset($data['termLength']);
			unset($data['interestRate']);
			
			if($data['clientType']==1){
				//create deposit account for member
				$data['member_id'] = $data['clientId'] ;
				unset($data['clientId']);
				$memberDepositAccount = new MemberDepositAccount();
				$memberDepositAccountId = $memberDepositAccount->addMemberDepositAccount($data);
			}else{
				//create deposit account for group
				$data['groupId'] = $data['clientId'] ;
				unset($data['clientId']);
				$saccoGroupDepositAccount = new SaccoGroupDepositAccount();
				$accoGroupDepositAccountId = $saccoGroupDepositAccount->addSaccoGroupDepositAccount($data);
			}
			
				
			if(isset($data['feePostData'])){
				if(!$data['feePostData'] == "false"){
					$feePostData = $data['feePostData'];
					unset($data['feePostData']);
					//insert account fees
					$depositAccountFee = new DepositAccountFee();
					foreach($feePostData as $feeDataItem){
						$feeDataItem['depositAccountID'] = $depositAccountId;
						$feeDataItem['dateCreated'] = time();
						$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$feeDataItem['dateModified'] = time();
						$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$output = $depositAccountFee->addDepositAccountFee($feeDataItem);
					}
				}
			}
		break;
		case "loan_account":
			$loanAccount = new LoanAccount();
			$db = new Db();
			
			$branchId = isset($_SESSION['branch_id'])?$_SESSION['branch_id']:1;
			$branch = $db->getfrec("branch","branch_name", "id=".$branchId,"", "");
			$branch_name = $branch['branch_name'];
			$initials = ($branch['branch_name'] != "")? strtoupper($branch['branch_name']) : strtoupper(substr($branch_name, 0, 3));
			$date = date("ymdis");
		 
			$data['loanNo'] = $initials."-".$date;
			$data['dateCreated'] = time();
			$data['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			$data['branchId'] = $branchId;
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			
			$output = $loanAccountId = $loanAccount->addLoanAccount($data);
			
			//send less data to reduce bandwidth usage
			$clientData['loanAccountId'] = $output ;
			$clientData['dateCreated'] = time();
			$clientData['dateModified'] = time();
			$clientData['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			$clientData['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			
			if((integer)$data['clientType']==1){
				//create loan account for member
				$clientData['member_id'] = $data['clientId'] ;
				$memberLoanAccount = new MemberLoanAccount();
				$memberLoanAccountId = $memberLoanAccount->addMemberLoanAccount($clientData);
				
				//then add the guarantors
				$guarantor = new Guarantor();
				
				if(isset($data['guarantors'])){
					if(!$data['guarantors'] == "false"){
						$guarantors = $data['guarantors'];
						unset($data['guarantors']);
						
						foreach($guarantors as $guarantorDataItem){
							$loanAccountGuarantor['loanAccountId'] = $loanAccountId;
							$loanAccountGuarantor['guarantorId'] = $guarantorDataItem['id'];
							$loanAccountGuarantor['dateCreated'] = time();
							$loanAccountGuarantor['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$loanAccountGuarantor['dateModified'] = time();
							$loanAccountGuarantor['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$output = $guarantor->addGuarantors($loanAccountGuarantor);
						}
						unset($loanAccountGuarantor);
					}
				}
			}else{
				//create loan account for group
				$clientData['saccoGroupId'] = $data['clientId'] ;
				$saccoGroupLoanAccount = new SaccoGroupLoanAccount();
				$accoGroupLoanAccountId = $saccoGroupLoanAccount->addSaccoGroupLoanAccount($clientData);
			}
			unset($clientData);
			
			//insert the account fees since we now have
			$loanAccountFee = new LoanAccountFee();
			
			if(isset($data['feePostData'])){
				if(!$data['feePostData'] == "false"){
					$feePostData = $data['feePostData'];
					foreach($feePostData as $feeDataItem){
						$loanAccountFeeItem['loanAccountId'] = $loanAccountId;
						$loanAccountFeeItem['loanProductFeenId'] = $feeDataItem['id'];
						$loanAccountFeeItem['feeAmount'] = ($feeDataItem['amountCalculatedAs'] == 2?(($feeDataItem['amount']/100)*$data['requestedAmount']):$feeDataItem['amount']);
						$loanAccountFeeItem['dateCreated'] = time();
						$loanAccountFeeItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$loanAccountFeeItem['dateModified'] = time();
						$loanAccountFeeItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$output = $loanAccountFee->addLoanAccountFee($loanAccountFeeItem);
					}
					unset($data['feePostData']);
				}
			}
			
			//insert the collateral items if any
			$loanCollateral = new LoanCollateral();
			
			if(isset($data['collateral'])){
				$collateralItems = $data['collateral'];
				foreach($collateralItems as $collateralItem){
					$collateralItem['loanAccountId'] = $loanAccountId;
					$collateralItem['dateCreated'] = time();
					$collateralItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
					$collateralItem['dateModified'] = time();
					$collateralItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
					$output = $loanCollateral->addLoanCollateral($collateralItem);
				}
				unset($data['collateral']);
			}
			
			unset($loanAccountFeeItem);
			unset($data);/*  */
		break;
		default: //the default scenario
		break;
	}
	echo $output;
}

if(isset($_POST['repayment_duration'])){
	$data = $_POST;
	$loan_repayment_duration = new LoanRepaymentDuration();
	 if($loan_repayment_duration->addLoanRepaymentDuration($data)){
		echo "success";
		return;
	}  
	return false;
}elseif(isset($_POST['add_income'])){
	$data = $_POST;
	$data['date_added'] = date("Y-m-d");
	$income = new Income();
	 if($income->addIncome($data)){
		echo "success";
		return;
	}  
	return false;
}elseif(isset($_POST['add_expense'])){
	$data = $_POST;
	$data['date_of_expense'] = date("Y-m-d");
	$expenses = new Expenses();
	 if($expenses->addExpense($data)){
		echo "success";
		return;
	}  
	return false;
}elseif(isset($_POST['addnok'])){
	$data = $_POST;
	$nok = new Nok();
	$data['date_added'] = date("Y-m-d");
	 if($nok->addNok($data)){
		echo "success";
		return;
	}  
	return false;
}elseif(isset($_POST['add_share_rate'])){
	$data = $_POST;
	$shares = new Shares();
	$data['date_added'] = date("Y-m-d");
	if($shares->addShareRate($data)){
		echo "success";
		return;
		
	}  
	return false;
}elseif(isset($_POST['add_share'])){
	$data = $_POST;
	$member = new Member();
	$shares = new Shares();
	$income = new Income();
	$data['date_paid'] = date("Y-m-d");
	if($shares->addShares($data)){
		$data['date_added'] = date("Y-m-d");
		$data['added_by'] = $data['received_by'];
		$data['description'] = "Shares bought by ".$member->findMemberNames($data['person_number'])." on ".$data['date_added'];
		if($income->addIncome($data)){
			//Record into the transaction table
			$data['transaction_type']  = 3;
			$data['branch_number']  = $_SESSION['income_type'];
			$data['transacted_by']  = $data['paid_by'];
			$data['transaction_date'] = $data['date_added'];
			$data['approved_by']= $data['received_by'];
			$data['comments'] = $data['description'] ;
			$trans_fields = array("transaction_type", "branch_number", "person_number", "amount", "amount_description", "transacted_by", "transaction_date", "approved_by", "comments");
			$shares->add("transaction", $trans_fields, $shares->generateAddFields($trans_fields, $data));
			echo "success";
			return;
		}
	}  
	return false;
}elseif(isset($_POST['add_subscription'])){
	$data = $_POST;
	$member = new Member();
	$subscription = new Subscription();
	$income = new Income();
	$data['date_paid'] = date("Y-m-d");
	 if($subscription->addSubscription($data)){
		$data['income_type'] = 1;
		$data['date_added'] = date("Y-m-d");
		$data['added_by'] = $data['received_by'];
		
		$data['description'] = "Annual subscription paid by ".$member->findMemberNames($data['person_number'])." for year ".$data['subscription_year'];
		if($income->addIncome($data)){
			echo "success";
			return;
		}
	}  
	return false;
}elseif(isset($_POST['add_deposit'])){
	$data = $_POST;
	$accounts = new Accounts();
	if($accounts->addDeposit($data)){
		echo "success";
		return;
	} 
	
	return false;
}elseif(isset($_POST['withdraw_cash'])){
	$data = $_POST;
	$accounts = new Accounts();
	if($accounts->addWithdraw($data)){
		echo "success";
		return;
	} 
	return false;
}elseif(isset($_POST['add_member'])){
	$data = $_POST;
	$member = new Member();
	$person = new Person();
	$accounts = new Accounts();
	$data['date_registered'] = date("Y-m-d");
	$data['date_added'] = date("Y-m-d");
	$data['photograph'] = "";
	$data['active']=1;
	$person_id = $person->addPerson($data);
	if($person_id){
		$data['person_number'] = $person_id;
		$member_id = $member->addMember($data);
		if($member_id){
			$act= sprintf('%08d', $person_id);
			$data['account_number'] =  $act;
			$data['balance'] = 0.00;
			$data['status'] = 1;
			$data['date_created'] = date("Y-m-d");
			$data['created_by'] = $data['added_by']; 
			if($accounts->addAccount($data)){
				echo $member_id;
				return;
			}
			
		}
	} 
	return "failed"; 
}elseif(isset($_POST['update_member'])){
	$data = $_POST;
	$staff_d = array();
	$member = new Member();
	$person = new Person();
	$accounts = new Accounts();
	$member_d = $data;
	$p['person_number'] = $member->findPersonNumber($data['id']);
	$member_d['person_number'] = $p['person_number']; 
	if($member->updateMember($member_d)){
		$data['id'] = $p['person_number']; 
		$data['dateofbirth'] = $member->formatSlashedDate($data['dateofbirth']);
		$person->updatePerson($data);
		echo "success";
		return;
	
	}

	return; 
}elseif(isset($_POST['add_staff'])){
	$data = $_POST;
	$staff = new Staff();
	$person = new Person();
	$accounts = new Accounts();
	$data['date_registered'] = date("Y-m-d");
	$data['date_added'] = date("Y-m-d");
	$data['photograph'] = "";
	$data['active']=1;
	$data['password'] = md5($data['password']);
	$person_id = $person->addPerson($data);
	if($person_id){
		$data['person_number'] = $person_id;
		if($staff->addStaff($data)){
			$data['account_number'] = substr(number_format(time() * rand(),0,'',''),0,10);
			$data['balance'] = 0.00;
			$data['status'] = 1;
			$data['date_created'] = date("Y-m-d");
			$data['created_added'] = $data['added_by']; 
			if($accounts->addAccount($data)){
				echo "success";
				return;
			}
		}
	}
	return; 
}elseif(isset($_POST['update_staff'])){
	$data = $_POST;
	$staff_d = array();
	$staff = new Staff();
	$person = new Person();
	$accounts = new Accounts();
	if(!$accounts->isValidMd5($data['password'])){
		$data['password'] = md5($data['password']);
	}
	$staff_d = $data;
	$p['person_number'] = $staff->findPersonNumber($data['id']);
	$staff_d['person_number'] = $p['person_number']; 
	if($staff->updateStaff($staff_d)){
		$data['id'] = $p['person_number']; 
		$data['dateofbirth'] = $staff->formatSlashedDate($data['dateofbirth']);
		$person->updatePerson($data);
		echo "success";
		return;
	
	}

	return; 
}elseif(isset($_POST['add_security_type'])){
	$security_type = new SecurityType();
	if($security_type->addSecurityType($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
		return;
	}
}elseif(isset($_POST['add_member_type'])){
	$member_type = new MemberType();
	if($member_type->addMemberType($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}elseif(isset($_POST['add_branch'])){
	$branch = new Branch();
	if($branch->addBranch($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}elseif(isset($_POST['add_loan_type'])){
	$loan_type = new LoanType();
	if($loan_type->addLoanType($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}
elseif(isset($_POST['add_access_level'])){
	$access_level = new AccessLevel();
	if($access_level->addAccessLevel($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}elseif(isset($_POST['add_expense_type'])){
	$expense_type = new ExpenseTypes();
	if($expense_type->addExpenseType($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}elseif(isset($_POST['add_income_source'])){
	$income_source = new IncomeSource();
	if($income_source->addIncomeSource($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}elseif(isset($_POST['loan_repayment'])){
	$loans = new Loans();
	if($loans->addLoanRepayment($_POST)){
		echo "success";
		return;
	}else{
		echo "failed";
	}
}

?>