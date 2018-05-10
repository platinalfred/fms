<?php 
session_start();
require_once("Libraries.php");
require_once("SimpleImage.php");

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
				$data['recievedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$output = $loanRepayment->addLoanRepayment($data);
			}
		break;
		case "approve_loan":
			if(isset($data['id'])){
				$loanAccount = new LoanAccount();
				$loan_account_approvals_obj = new LoanAccountApproval();
				unset($data['origin']);
				//branch manager cannot really approve the loan, but can give some comments when forwarding the loan
				//if(!isset($_SESSION['branch_manager'])){
					$data['approvalDate'] = time();
					$data['approvedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
					$output = $loanAccount->updateLoanAccount($data);
				//}
				$approval_data['loanAccountId'] = $data['id'];
				$approval_data['amountRecommended'] = $data['amountApproved'];
				$approval_data['justification'] = $data['approvalNotes'];
				//let's check if the status is -1 implies there is a request to revert to the previous status
				//so we gotta find the previous status, which was not the rejected status
				if($data['status'] == -1){
					$loan_account_approvals = $loan_account_approvals_obj->findAll("`loanAccountId`=".$approval_data['loanAccountId']);
					if($loan_account_approvals){
						foreach($loan_account_approvals as $key=>$loan_account_approval){
							//if rejected status (11), check the next one
							if($loan_account_approval['status'] != 11 && $key>0){
								$data['status'] == $loan_account_approval['status'];
								break; //stop the loop from here since we got the status which we wanted
							}
						}
					}
					//since we did not find an appropriate status from the for loop, then we are supposed to revert to rejected status (of the loan)
					if($data['status']==-1){$data['status'] = 11;}
				}
				$approval_data['status'] = $data['status'];
				$approval_data['dateCreated'] = time();
				$approval_data['staffId'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$approval_data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				
				$output = $loan_account_approvals_obj->addLoanAccountApproval($approval_data);
				
				unset($data, $approval_data); //clear the previous data
			}
		break;
		case "disburse_loan":
			if(isset($data['id'])){
				$loanAccount = new LoanAccount();
				unset($data['origin']);
				$data['disbursementDate'] = time();
				//$data['disbursedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$output = $loanAccount->updateLoanAccount($data);
			}
		break;
		case "add_deposit":
			if(isset($data['depositAccountId'])){
				$depositAccountTransaction = new DepositAccountTransaction();
				$data['dateCreated'] = time();
				$data['transactionType'] = 1;
				$data['transactedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$output = $depositAccountTransaction->addDepositAccountTransaction($data);
			}
		break;
		case "add_withdraw":
			if(isset($data['depositAccountId'])){
				$depositAccount = new DepositAccountTransaction();
				$data['dateCreated'] = time();
				$data['transactionType'] = 2;
				$data['transactedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$output = $depositAccount->addDepositAccountTransaction($data);
			}
		break;
		case "deposit_product":
			
			$depositProduct = new DepositProduct();
			$data['dateCreated'] = time();
			$data['createdBy'] = isset($_SESSION['staffId'])? $_SESSION['staffId'] : 1;
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId']:1;
			$output = $depositProduct->addDepositProduct($data);
			if(is_numeric($output)){
				//insert the product fees afterwards
				$depositProductFee = new DepositProductFee();
				$productId = $output;
				if(isset($data['feePostData'])&&!empty($data['feePostData'])){
					foreach($data['feePostData'] as $feeDataItem){
						$feeDataItem['depositProductID'] = $productId;
						$feeDataItem['dateCreated'] = time();
						$feeDataItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
						$feeDataItem['dateModified'] = time();
						$feeDataItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
						$output = $depositProductFee->addDepositProductFee($feeDataItem);
					}
				}
			}
			
		break;
		case "loan_product":
			$loanProduct = new LoanProduct();
			$data['dateCreated'] = time();
			$data['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			unset($data['origin']);
			$output = $loanProductId = $loanProduct->addLoanProduct($data);
			
			if($loanProductId){
				//insert new loan product fees to the loan products table
				$productFees = $new_existing_product_fees = array();
				if(isset($data['newLoanProductFees'])){
					$loanProductFee = new LoanProductFee();
					foreach($data['newLoanProductFees'] as $feeDataItem){
						$feeDataItem['dateCreated'] = time();
						$feeDataItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
						$feeDataItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
						$productFees[] = $loanProductFee->addLoanProductFee($feeDataItem);
					}
					$new_existing_product_fees = $productFees;
				}
				//then the actual fees assigned to this product
				if(isset($data['existingLoanProductFees'])){
					if(!empty($productFees)){
						$new_existing_product_fees =  array_merge($productFees, $data['existingLoanProductFees']);
					}
					else{
						$new_existing_product_fees = $data['existingLoanProductFees'];
					}
				}
				if(!empty($new_existing_product_fees)){
					$loanProductFeen = new LoanProductFeen();
					$loanProductFees = array();
					foreach($new_existing_product_fees as $productFeeDataItem){
						$loanProductFees['dateCreated'] = time();
						$loanProductFees['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
						$loanProductFees['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
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
			$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			if(isset($data['id'])&&is_numeric($data['id'])){
				$output = $depositAccount->updateDepositAccount($data);
				
				$data['depositAccountId'] = $data['id'];
				//make a deposit transaction into the client's account
				/* 	$depositAccountTransaction = new DepositAccountTransaction();
					$data['transactionType'] = 1;
					$data['transactedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
					$output = $depositAccountTransaction->addDepositAccountTransaction($data);
				 */
				
				unset($data['id'],$data['openingBalance'],$data['termLength'],$data['transactionType'],$data['transactedBy'],$data['interestRate']);
					
				if(isset($data['feePostData'])){
					if($data['feePostData'] != "false"){
						$depositAccountFee = new DepositAccountFee();
						//lets first remove all the fees since there's been an adjustment
						$depositAccountFee->del($data['depositAccountId']);
						$feePostData = $data['feePostData'];
						unset($data['feePostData']);
						//insert account fees
						foreach($feePostData as $feeDataItem){
							$feeDataItem['depositAccountId'] = $data['depositAccountId'];
							$feeDataItem['dateCreated'] = time();
							$feeDataItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$feeDataItem['dateModified'] = time();
							$feeDataItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$output = $depositAccountFee->addDepositAccountFee($feeDataItem);
						}
					}
				}
			}
			else{
				$data['dateModified'] = time();
				$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				$data['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
				
				$data['depositAccountId'] = $output = $depositAccount->addDepositAccount($data);
				$depositAccount->updateAccountNo($output);
				//echo $data['depositAccountId'];
				
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
					$data['saccoGroupId'] = $data['clientId'] ;
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
							$feeDataItem['depositAccountId'] = $data['depositAccountId'];
							$feeDataItem['depositProductFeeId'] = $feeDataItem['id'];
							unset($feeDataItem['id']);
							$feeDataItem['dateCreated'] = time();
							$feeDataItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$feeDataItem['dateModified'] = time();
							$feeDataItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$output = $depositAccountFee->addDepositAccountFee($feeDataItem);
						}
					}
				}
			}
			
		break;
		case "newGroupLoanAccount":
			//create loan account for group
			unset($data['origin']);
			$data['dateCreated'] = time();
			$data['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			$data['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			$saccoGroupLoanAccount = new SaccoGroupLoanAccount();
			$output = $saccoGroupLoanAccountId = $saccoGroupLoanAccount->addSaccoGroupLoanAccount($data);
			if(is_numeric($saccoGroupLoanAccountId))
				header("content: ../group_details.php?groupId={$data['saccoGroupId']}&grpLoanRef=$saccoGroupLoanAccountId");
			unset($data);
		break;
		case "loan_account":
			$loan_account_obj = new LoanAccount();
			$loanAccount = $data['loanAccount'];
			
			$loanAccount['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			$loanAccountId = 0;
			
			$date = date("ymdis");
			$loanAccount['loanNo'] = "L".$date;
			$applicationDate = DateTime::createFromFormat('d-m-Y', $data['applicationDate']);
			$loanAccount['applicationDate'] = $applicationDate->getTimestamp();
			$loanAccount['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
			
			//if the id is among the post variables, then we are supposed to update the loan account record
			if(isset($loanAccount['id'])&&is_numeric($loanAccount['id'])){
				if($loanAccount['status']==11){$loanAccount['status'] == 1;}
				$loan_account_obj->updateLoanAccount($loanAccount);
				
				//first delete all the existing loan account collateral
				$loan_collateral_obj = new LoanCollateral();
				$directory = "../img/loanAccounts/".$loanAccount['loanNo']."/collateral/";
				$loan_collateral_obj->deleteLoanCollateral($loanAccount['id']);
				foreach(glob("{$directory}/*") as $file)
				{
					if(is_file($file)) {
						unlink($file);
					}
				}
				rmdir($directory);
			}else{
				$loanAccount['dateCreated'] = time();
				$loanAccount['branch_id'] = isset($_SESSION['branch_id'])?$_SESSION['branch_id']:1;
				$output .= $loanAccountId = $loan_account_obj->addLoanAccount($loanAccount);
			}
			if( $loanAccountId > 0 ){ //perform the updating only when the loan account exists
				//then add the guarantors					
				if(isset($loanAccount['guarantors'])){
					if($loanAccount['guarantors'] !== "false"){
						$guarantor = new Guarantor();
						//lets first delete all the existing loan account guarantors
						$guarantor->deleteGuarantor($loanAccountId);
						//then add new ones
						foreach($loanAccount['guarantors'] as $guarantorDataItem){
							$guarantorDataItem['loanAccountId'] = $loanAccountId;
							$guarantorDataItem['dateCreated'] = time();
							$guarantorDataItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$guarantorDataItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$output .= $guarantor->addGuarantors($guarantorDataItem);
						}
					}
				}
				if(isset($loanAccount['clientBusinesses'])){
					$person_obj = new Person();
					$member_obj = new Member();
					$member_details = $member_obj->findById($loanAccount['memberId']);
					$person_id = $member_details['personId'];
					//lets first delete all the existing businesss
					$person_obj->deleteBusiness($person_id);
					
					foreach($loanAccount['clientBusinesses'] as $clientBusiness){
						if($clientBusiness['businessName']!='undefined'){
							$clientBusiness['dateAdded'] = time();
							$clientBusiness['personId'] = $person_id;
							$person_obj->addPersonBusiness($clientBusiness);
						}
					}
				}
				
				//insert the account fees since we now have
				if(isset($loanAccount['loanFees'])){
					if($loanAccount['loanFees'] !== "false"){
						$loan_account_fee_obj = new LoanAccountFee();
						$loan_account_fee_obj->deleteLoanAccountFee($loanAccountId);
						//then insert new ones afresh, these might include the old ones as well
						foreach($loanAccount['loanFees'] as $feeDataItem){
							$feeDataItem['loanAccountId'] = $loanAccountId;
							//$feeDataItem['feeAmount'] = ($feeDataItem['amountCalculatedAs'] == 2?(($feeDataItem['amount']/100)*$data['requestedAmount']):$feeDataItem['amount']);
							$feeDataItem['dateCreated'] = time();
							$feeDataItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$feeDataItem['dateModified'] = time();
							$feeDataItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$output .= $loan_account_fee_obj->addLoanAccountFee($feeDataItem );
						}
					}
				}
				if(isset($loanAccount['loanCollateral'])){
					$loan_collateral_obj = new LoanCollateral();
					foreach($loanAccount['loanCollateral'] as $lc_key=>$collateralItem){
						if($collateralItem['itemName']!='undefined'){
							//upload any file that came with this data
							if ($_FILES['loanAccount']['error']['loanCollateral'][$lc_key]['attachmentUrl'] == UPLOAD_ERR_OK) {
								$allowedExts = array("gif", "jpeg", "jpg", "png", "JPG", "PNG", "GIF", "pdf", "doc", "docx");
								$extension = end(explode(".", $_FILES['loanAccount']["name"]['loanCollateral'][$lc_key]['attachmentUrl']));
								if(($_FILES['loanAccount']["size"]['loanCollateral'][$lc_key]['attachmentUrl'] < 200000000) && in_array($extension, $allowedExts)){ 							
									if($_FILES['loanAccount']['error']['loanCollateral'][$lc_key]['attachmentUrl'] > 0){
										$output .=  "Return Code: " . $_FILES['loanAccount']['error']['loanCollateral'][$lc_key]['attachmentUrl'] . "<br>";
									}else{
										$files_dir = "../img/loanAccounts/".$loanAccount['loanNo']."/collateral/";
										$collateralItem['attachmentUrl'] = substr($files_dir,3).$_FILES['loanAccount']['name']['loanCollateral'][$lc_key]['attachmentUrl'];
										//$images->load($_FILES['loanAccount']['tmp_name']['loanCollateral'][$lc_key]['attachmentUrl']);
										//$images->resize(240, 120); 
										//$images->output($_FILES['loanAccount']["type"]['loanCollateral'][$lc_key]['attachmentUrl']);
										
										if(!file_exists($files_dir)){
											mkdir($files_dir, 0777, true);
										}
										move_uploaded_file($_FILES['loanAccount']['tmp_name']['loanCollateral'][$lc_key]['attachmentUrl'], "../".$collateralItem['attachmentUrl']);
										//$images->save($collateralItem['attachmentUrl']);
									}
								} 
							} 	
							//insert the collateral
							$collateralItem['loanAccountId'] = $loanAccountId;
							$collateralItem['dateCreated'] = time();
							$collateralItem['createdBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$collateralItem['modifiedBy'] = isset($_SESSION['staffId'])?$_SESSION['staffId']:1;
							$output .= $loan_collateral_obj->addLoanCollateral($collateralItem);
						}
					}
				}
			}
			unset($data, $loan_account_obj);//save resources, discard the data from the form
		break;
		default: //the default scenario
		break;
	}
	echo $output;
}
?>