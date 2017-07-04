<?php 
session_start();
require_once("Libraries.php");
if(isset($_POST['origin'])){
	$output = 0;
	$data = $_POST;
	switch($_POST['origin']){
		case "make_loan_payment":
			if(isset($data['loanAccountId'])){
				unset($data['origin']);
				$loanRepayment = new LoanRepayment();
				$data['transactionDate'] = time();
				$data['dateModified'] = time();
				$data['receivedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$output = $loanRepayment->addLoanRepayment($data);
			}
		break;
		case "approve_loan":
			if(isset($data['id'])){
				$loanAccount = new LoanAccount();
				unset($data['origin']);
				$data['approvalDate'] = time();
				$data['approvedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$output = $loanAccount->updateLoanAccount($data);
			}
		break;
		case "disburse_loan":
			if(isset($data['id'])){
				$loanAccount = new LoanAccount();
				unset($data['origin']);
				$data['disbursementDate'] = time();
				//$data['disbursedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$output = $loanAccount->updateLoanAccount($data);
			}
		break;
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
			if(is_numeric($output)){
				//insert the product fees afterwards
				$depositProductFee = new DepositProductFee();
				$productId = $output;
				if(isset($data['feePostData'])&&!empty($data['feePostData'])){
					foreach($data['feePostData'] as $feeDataItem){
						$feeDataItem['depositProductID'] = $productId;
						$feeDataItem['dateCreated'] = time();
						$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$feeDataItem['dateModified'] = time();
						$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
						$output = $depositProductFee->addDepositProductFee($feeDataItem);
					}
				}
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
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			
			if(isset($data['id'])&&is_numeric($data['id'])){
				$output = $depositAccount->updateDepositAccount($data);
				
				$data['depositAccountId'] = $data['id'];
				unset($data['id'],$data['openingBalance'],$data['termLength'],$data['interestRate']);
					
				if(isset($data['feePostData'])){
					if($data['feePostData'] != "false"){
						$depositAccountFee = new DepositAccountFee();
						//lets first remove all the fees since there's been an adjustment
						$depositAccountFee->del($data['depositAccountId']);
						$feePostData = $data['feePostData'];
						unset($data['feePostData']);
						//insert account fees
						foreach($feePostData as $feeDataItem){
							$feeDataItem['depositAccountID'] = $data['depositAccountId'];
							$feeDataItem['dateCreated'] = time();
							$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$feeDataItem['dateModified'] = time();
							$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$output = $depositAccountFee->addDepositAccountFee($feeDataItem);
						}
					}
				}
			}
			else{
				$data['dateModified'] = time();
				$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				
				
				$output = $depositAccount->addDepositAccount($data);
				
				$data['depositAccountId'] = $output ;
				unset($data['openingBalance']);
				unset($data['termLength']);
				unset($data['interestRate']);
				
				if($data['clientType']==1){
					//create deposit account for member
					$data['memberId'] = $data['clientId'] ;
					unset($data['clientId']);
					$memberDepositAccount = new MemberDepositAccount();
					$memberDepositAccountId = $memberDepositAccount->addMemberDepositAccount($data);
				}else{
					//create deposit account for group
					$data['groupId'] = $data['clientId'] ;
					unset($data['clientId']);
					$saccoGroupDepositAccount = new SaccoGroupDepositAccount();
					$saccoGroupDepositAccountId = $saccoGroupDepositAccount->addSaccoGroupDepositAccount($data);
				}					
				if(isset($data['feePostData'])){
					if($data['feePostData'] != "false"){
						$feePostData = $data['feePostData'];
						unset($data['feePostData']);
						//insert account fees
						$depositAccountFee = new DepositAccountFee();
						foreach($feePostData as $feeDataItem){
							$feeDataItem['depositAccountID'] = $data['depositAccountId'];
							$feeDataItem['dateCreated'] = time();
							$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$feeDataItem['dateModified'] = time();
							$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$output = $depositAccountFee->addDepositAccountFee($feeDataItem);
						}
					}
				}
			}
			
		break;
		case "loan_account":
			$loanAccount = new LoanAccount();
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			if(isset($data['id'])&&is_numeric($data['id'])){
				$loanAccountId = $data['id'];
				$loanAccount->updateLoanAccount($data);
				if((integer)$data['clientType']==1){
					$guarantor = new Guarantor();
					if(isset($data['guarantors'])){
						if($data['guarantors'] !== "false"){
							//lets first delete all the existing loan account guarantors
							$guarantor->deleteGuarantor($loanAccountId);
							//then add new ones
							$guarantors = $data['guarantors'];
							unset($data['guarantors']);
							foreach($guarantors as $guarantorDataItem){
								$loanAccountGuarantor['loanAccountId'] = $loanAccountId;
								$loanAccountGuarantor['memberId'] = $guarantorDataItem['guarantor'];
								$loanAccountGuarantor['dateCreated'] = time();
								$loanAccountGuarantor['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								//$loanAccountGuarantor['dateModified'] = time();
								$loanAccountGuarantor['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$output = $guarantor->addGuarantors($loanAccountGuarantor);
							}
							unset($loanAccountGuarantor);
						}
					}
				}
				$loanAccountFee = new LoanAccountFee();
				if(isset($data['feePostData'])){
					if($data['feePostData'] !== "false"){
						//first delete all the existing loan account fees
						$loanAccountFee->deleteLoanAccountFee(loanAccountId);
						//then insert new ones afresh, these might include the old ones as well
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
					//first delete all the existing loan account collateral
					$loanCollateral->deleteLoanCollateral(loanAccountId);
					//then insert new ones afresh, these might include the old ones as well
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
				unset($loanAccountFeeItem,$data);/*  */
			}
			else{
				$db = new Db();
				
				$branchId = isset($_SESSION['branch_id'])?$_SESSION['branch_id']:1;
				$branch = $db->getfrec("branch","branch_name", "id=".$branchId,"", "");
				$branch_name = $branch['branch_name'];
				$initials = ($branch['branch_name'] != "")? strtoupper($branch['branch_name']) : strtoupper(substr($branch_name, 0, 3));
				$date = date("ymdis");
			 
				$data['loanNo'] = "L".$date;
				$data['dateCreated'] = time();
				$data['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$data['branchId'] = $branchId;
				
				$output = $loanAccountId = $loanAccount->addLoanAccount($data);
				
				//send less data to reduce bandwidth usage
				$clientData['loanAccountId'] = $loanAccountId ;
				$clientData['dateCreated'] = time();
				$clientData['dateModified'] = time();
				$clientData['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				$clientData['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				
				if((integer)$data['clientType']==1){
					//create loan account for member
					$clientData['memberId'] = $data['clientId'] ;
					$memberLoanAccount = new MemberLoanAccount();
					$memberLoanAccountId = $memberLoanAccount->addMemberLoanAccount($clientData);
					
					//then add the guarantors
					$guarantor = new Guarantor();
					
					if(isset($data['guarantors'])){
						if($data['guarantors'] !== "false"){
							$guarantors = $data['guarantors'];
							unset($data['guarantors']);
							
							foreach($guarantors as $guarantorDataItem){
								$loanAccountGuarantor['loanAccountId'] = $loanAccountId;
								$loanAccountGuarantor['memberId'] = $guarantorDataItem['id'];
								$loanAccountGuarantor['dateCreated'] = time();
								$loanAccountGuarantor['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								//$loanAccountGuarantor['dateModified'] = time();
								$loanAccountGuarantor['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$output = $guarantor->addGuarantor($loanAccountGuarantor);
							}
							unset($loanAccountGuarantor);
						}
					}
				}else{
					//create loan account for group
					$clientData['saccoGroupId'] = $data['clientId'] ;
					$saccoGroupLoanAccount = new SaccoGroupLoanAccount();
					$output = $saccoGroupLoanAccountId = $saccoGroupLoanAccount->addSaccoGroupLoanAccount($clientData);
				}
				unset($clientData);
				
				//insert the account fees since we now have
				$loanAccountFee = new LoanAccountFee();
				
				if(isset($data['feePostData'])){
					if($data['feePostData'] !== "false"){
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
						if($collateralItem['itemName']!='undefined'){
							$collateralItem['loanAccountId'] = $loanAccountId;
							$collateralItem['dateCreated'] = time();
							$collateralItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$collateralItem['dateModified'] = time();
							$collateralItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$output = $loanCollateral->addLoanCollateral($collateralItem);
						}
					}
					unset($data['collateral']);
				}
				unset($loanAccountFeeItem,$data);/*  */
			}
		break;
		default: //the default scenario
		break;
	}
	echo $output;
}
?>