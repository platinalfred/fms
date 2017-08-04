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
				$data['recievedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
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
			$data['createdBy'] = isset($_SESSION['user_id'])? $_SESSION['user_id'] : 1;
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id']) ? $_SESSION['user_id']:1;
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
			//$data['dateModified'] = time();
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
						//$feeDataItem['dateModified'] = time();
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
				
				$data['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
				
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
			$loan_account_obj = new LoanAccount();
			$data['dateModified'] = time();
			$data['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
			if(isset($data['id'])&&is_numeric($data['id'])){
				$loanAccountId = $data['id'];
				$loan_account_obj->updateLoanAccount($data);
				if((integer)$data['clientType']==1){
					if(isset($data['guarantors'])){
						if($data['guarantors'] !== "false"){
							$guarantor = new Guarantor();
							//lets first delete all the existing loan account guarantors
							$guarantor->deleteGuarantor($loanAccountId);
							//then add new ones
							foreach($data['guarantors'] as $guarantorDataItem){
								$guarantorDataItem['loanAccountId'] = $loanAccountId;
								$guarantorDataItem['dateCreated'] = time();
								$guarantorDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$guarantorDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$output = $guarantor->addGuarantors($guarantorDataItem);
							}
							unset($data['guarantors']);
						}
					}
					if(isset($data['clientBusinesses'])){
						if($data['clientBusinesses'] !== "false"){
							$person_obj = new Person();
							$member_obj = new Member();
							$member_details = $member_obj->findById($data['clientId']);
							$person_id = $member_details['personId'];
							//lets first delete all the existing businesss
							$person_obj->deleteBusiness($person_id);
							//then add the updated list
							foreach($data['clientBusinesses'] as $single){
								if($single['businessName']!='undefined'){
									$single['dateAdded'] = time();
									$single['personId'] = $person_id;
									$output = $person_obj->addPersonBusiness($single);
								}
							}
						}
						unset($data['clientBusinesses']);
					}
				}
				$loanAccountFee = new LoanAccountFee();
				if(isset($data['loanFees'])){
					if($data['loanFees'] !== "false"){
						//first delete all the existing loan account fees
						$loanAccountFee->deleteLoanAccountFee(loanAccountId);
						//then insert new ones afresh, these might include the old ones as well
						foreach($data['loanFees'] as $feeDataItem){
							$feeDataItem['loanAccountId'] = $loanAccountId;
							//$feeDataItem['feeAmount'] = ($feeDataItem['amountCalculatedAs'] == 2?(($feeDataItem['amount']/100)*$data['requestedAmount']):$feeDataItem['amount']);
							$feeDataItem['dateCreated'] = time();
							$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$feeDataItem['dateModified'] = time();
							$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$output = $loanAccountFee->addLoanAccountFee($feeDataItem );
						}
						unset($data['loanFees']);
					}
				}
				//insert the collateral items if any
				$loanCollateral = new LoanCollateral();
				
				if(isset($data['loanCollateral'])){
					//first delete all the existing loan account collateral
					$loanCollateral->deleteLoanCollateral(loanAccountId);
					//then insert new ones afresh, these might include the old ones as well
					foreach($data['loanCollateral'] as $collateralItem){
						if($collateralItem['itemName']!='undefined'){
							$collateralItem['loanAccountId'] = $loanAccountId;
							$collateralItem['dateCreated'] = time();
							$collateralItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$collateralItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
							$output = $loanCollateral->addLoanCollateral($collateralItem);
						}
					}
					unset($data['loanCollateral']);
				}
				unset($data);
			}else{
				$db = new Db();
				
				$branchId = isset($_SESSION['branch_id'])?$_SESSION['branch_id']:1;
				foreach($data['loanAccount'] as $key=>$loanAccount){
					//loop through all the accounts sent from the form
					
					//send less data to save memory
					$clientData['dateCreated'] = time();
					$clientData['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
					$clientData['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
					
					if((integer)$data['clientType']==2){
						//create loan account for group
						$clientData['saccoGroupId'] = $loanAccount['clientId'] ;
						$saccoGroupLoanAccount = new SaccoGroupLoanAccount();
						$saccoGroupLoanAccountId = $saccoGroupLoanAccount->addSaccoGroupLoanAccount($clientData);
						$loanAccount['groupLoanAccountId'] = $saccoGroupLoanAccountId;
						
					}
					unset($clientData);
					
					$date = date("ymdis");
					$loanAccount['loanNo'] = "L".$date;
					$loanAccount['loanProductId'] = $data['loanProductId'];
					$loanAccount['dateCreated'] = time();
					$applicationDate = DateTime::createFromFormat('d-m-Y', $data['applicationDate']);
					$loanAccount['applicationDate'] = $applicationDate->getTimestamp();
					$loanAccount['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
					$loanAccount['branchId'] = $branchId;
					
					$output = $loanAccountId = $loan_account_obj->addLoanAccount($loanAccount);
					
					if((integer)$data['clientType']==1){
						//create loan account for member
						$clientData['loanAccountId'] = $loanAccountId ;
						$clientData['memberId'] = $loanAccount['clientId'] ;
						$memberLoanAccount = new MemberLoanAccount();
						$memberLoanAccountId = $memberLoanAccount->addMemberLoanAccount($clientData);
					} /* */
					//then add the guarantors
					$guarantor = new Guarantor();
					
					if(isset($loanAccount['guarantors'])){
						if($loanAccount['guarantors'] !== "false"){
							$guarantor = new Guarantor();
							//lets first delete all the existing loan account guarantors
							$guarantor->deleteGuarantor($loanAccountId);
							//then add new ones
							foreach($loanAccount['guarantors'] as $guarantorDataItem){
								$guarantorDataItem['loanAccountId'] = $loanAccountId;
								$guarantorDataItem['dateCreated'] = time();
								$guarantorDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$guarantorDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$output = $guarantor->addGuarantors($guarantorDataItem);
							}
						}
					}
					if(isset($loanAccount['clientBusinesses'])){
						$person_obj = new Person();
						$member_obj = new Member();
						$member_details = $member_obj->findById($loanAccount['clientId']);
						$person_id = $member_details['personId'];
						
						foreach($loanAccount['clientBusinesses'] as $clientBusiness){
							if($clientBusiness['businessName']!='undefined'){
								$clientBusiness['dateAdded'] = time();
								$clientBusiness['personId'] = $person_id;
								$person_obj->addPersonBusiness($clientBusiness);
							}
						}
					}
					
					//insert the account fees since we now have
					$loanAccountFee = new LoanAccountFee();
					
					if(isset($loanAccount['loanFees'])){
						if($loanAccount['loanFees'] !== "false"){
							//then insert new ones afresh, these might include the old ones as well
							foreach($loanAccount['loanFees'] as $feeDataItem){
								$feeDataItem['loanAccountId'] = $loanAccountId;
								//$feeDataItem['feeAmount'] = ($feeDataItem['amountCalculatedAs'] == 2?(($feeDataItem['amount']/100)*$data['requestedAmount'][$key]):$feeDataItem['amount']);
								$feeDataItem['dateCreated'] = time();
								$feeDataItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$feeDataItem['dateModified'] = time();
								$feeDataItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$output = $loanAccountFee->addLoanAccountFee($feeDataItem );
							}
						}
					}
					//insert the collateral items if any
					$loanCollateral = new LoanCollateral();
					
					if(isset($loanAccount['loanCollateral'])){
						foreach($loanAccount['loanCollateral'] as $lc_key=>$collateralItem){
							if($collateralItem['itemName']!='undefined'){
								$file_name = '';
								//upload any file that came with this data
								if ($_FILES['loanAccount']['error'][$key]['loanCollateral'][$lc_key]['attachmentUrl'] == UPLOAD_ERR_OK) {
									$images = new SimpleImage();
									$allowedExts = array("gif", "jpeg", "jpg", "png", "JPG", "PNG", "GIF", "application/pdf");
									$extension = end(explode(".", $_FILES['loanAccount']["name"][$key]['loanCollateral'][$lc_key]['attachmentUrl']));
									if(($_FILES['loanAccount']["size"][$key]['loanCollateral'][$lc_key]['attachmentUrl'] < 200000000) && in_array($extension, $allowedExts)){ 							
										if($_FILES['loanAccount']['error'][$key]['loanCollateral'][$lc_key]['attachmentUrl'] > 0){
											$output =  "Return Code: " . $_FILES['loanAccount']['error'][$key]['loanCollateral'][$lc_key]['attachmentUrl'] . "<br>";
										}else{
											$files_dir = "./img/loanAccounts/".$loanAccount['loanNo']."/collateral/";
											$collateralItem['attachmentUrl'] = $files_dir.$_FILES['loanAccount']['name'][$key]['loanCollateral'][$lc_key]['attachmentUrl'];
											//$images->load($_FILES['loanAccount']['tmp_name'][$key]['loanCollateral'][$lc_key]['attachmentUrl']);
											//$images->resize(240, 120); 
											//$images->output($_FILES['loanAccount']["type"][$key]['loanCollateral'][$lc_key]['attachmentUrl']);
											
											if(!file_exists($files_dir)){
												mkdir($files_dir, 0777, true);
											}
											move_uploaded_file($_FILES['loanAccount']['tmp_name'][$key]['loanCollateral'][$lc_key]['attachmentUrl'], $collateralItem['attachmentUrl']);
												/*)if({ echo "File Upload Successful"
											}
											else{
												echo "File Upload Failure";
											} */
											//$images->save($collateralItem['attachmentUrl']);
										}
									} 
								} else {
									$output =  "Error: " . $_FILES['loanAccount']['error'][$key]['loanCollateral'][$lc_key]['attachmentUrl'] . "<br />";
								}	
								//insert the collateral
								$collateralItem['loanAccountId'] = $loanAccountId;
								$collateralItem['dateCreated'] = time();
								$collateralItem['createdBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$collateralItem['modifiedBy'] = isset($_SESSION['user_id'])?$_SESSION['user_id']:1;
								$output = $loanCollateral->addLoanCollateral($collateralItem);
							}
						}
					}
				}
				unset($data);//save resources, discard the data from the form
			}
		break;
		default: //the default scenario
		break;
	}
	echo $output;
}
?>