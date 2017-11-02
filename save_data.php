<?php
require_once('lib/Libraries.php');
require_once("lib/SimpleImage.php");
$images = new SimpleImage();
$output = "";
if(isset($_POST['tbl'])){
	switch($_POST['tbl']){
		case "add_subscription":
			$data = $_POST;
			$subscribe = new Subscription();
			if($subscribe->addSubscription($data)){
				$output = "success";
			}else{ 
				$output = "Member subscription could not be added. Please try again or contact admin for assistance!";
			}
		break;
		case "add_share":
			$data = $_POST;
			$shares = new Shares();
			if($shares->addShares($data)){
				$output = "success";
			}else{ 
				$output = "Member Share could not be added. Please try again or contact admin for assistance!";
			}
		break;
		case "share_rate":
			$data = $_POST;
			$shares = new Shares();
			if($shares->addShareRate($data)){
				$output = "success";
			}else{ 
				$output = "Share rate could not be added. Please try again or contact admin for assistance!";
			}
		break;
		case "add_group":
			$data = $_POST;
			$sacco_group = new SaccoGroup();
			$group_id = $sacco_group->addSaccoGroup($data);
			if($group_id){
				$data['groupId'] = $group_id;
				if(!empty($data['members'])){
					foreach($data['members'] as $single){
						$data['memberId'] = $single['memberId'];
						$sacco_group->addSaccoGroupMembers($data);
					}
				}
				$output = "success";
			}else{ 
				$output = "Group details could not be added. Please try again or contact admin for assistance!";
			} 
		break;
		case "update_group":
			$data = $_POST;
			$sacco_group = new SaccoGroup();
			if($sacco_group->updateSaccoGroup($data)){
				if(!empty($data['members'])){
					foreach($data['members'] as $single){
						$data['memberId'] = $single['memberId'];
						$sacco_group->addSaccoGroupMembers($data);
					}
				}
				$output = "success";
			}else{ 
				$output = "Group details could not be added. Please try again or contact admin for assistance!";
			}
		break;
		//UPDATE STAFF
		case "update_staff":
			$data = $_POST;
			$staff = new Staff();
			$person = new Person();
			$data['id'] = $data['personId'];
			$data['dateofbirth'] = date("Y-m-d", strtotime($data['dateofbirth']));
			if($person->updatePerson($data)){
				if(!empty($data['access_levels'])){
					foreach($_POST['access_levels'] as $single){
						$data['role_id'] = $single;
						$staff->updateStaffAccessLevels($data);
					}
				}
				$data['id'] = $_POST['member_id'];
				if(!$staff->isValidMd5($data['password'])){
					$data['password'] = md5($data['password']);
				}
				if($staff->updateStaff($data)){
					$output = "success";
				}
			}else{ 
				$output = "Staff details could not be updated. Please try again!";
			} 
		break;
		//ADD STAFF
		case "add_staff":
			$data = $_POST;
			$staff = new Staff();
			$person = new Person();
			$data['dateofbirth'] = date("Y-m-d", strtotime($data['dateofbirth']));
			$data['date_added'] = date("Y-m-d");
			$data['photograph'] = "";
			$data['active']=1;
			$person_id = $person->addPerson($data);
			if($person_id){
				$data['personId'] = $person_id;
				$person->updateStaffNumber($person_id);
				if(!empty($_POST['access_levels'])){
					foreach($_POST['access_levels'] as $single){
						$data['role_id'] = $single;
						$staff->addStaffAccessLevels($data);
					}
				}
				$data['password'] = md5($data['password']);
				if($staff->addStaff($data)){
					$output = "success";
				}
			}else{ 
				$output = "Staff details could not be added. Please try again!";
			}  
		break;
		case "add_member":
			$data = $_POST;
			$member = new Member();
			$person = new Person();
			$data['date_registered'] = date("Y-m-d");
			$data['dateofbirth'] = date("Y-m-d", strtotime($data['dateofbirth']));
			$data['dateAdded'] = time();
			$data['photograph'] = "";
			$data['active']=1;
		
			$person_id = $person->addPerson($data);
			if($person_id){
				$data['personId'] = $person_id;
				$person->updatePersonNumber($person_id);
				$data["personId"] = $person_id;
				$data['branchId'] = $data['branch_id'];
				$data['addedBy'] = $data['modifiedBy'];
				//$data['dateAdded'] = $data['date_registered'];
				
				if(!empty($data['relative'])){
					foreach($data['relative'] as $single){
						$single['personId'] = $person_id;
						$person->addRelative($single);
					} 	 
				}
				if(!empty($data['employment'])){
					foreach($data['employment'] as $single){
						$single['personId'] = $person_id;
						$person->addPersonEmployment($single);
					} 	 
				}
				if(!empty($data['business'])){
					foreach($data['business'] as $single){
						$single['dateAdded'] = $data['dateAdded'];
						$single['addedBy'] = $data['addedBy'];
						$single['personId'] = $person_id;
						$person->addPersonBusiness($single);
					} 	 
				}
				 
				if($member->addMember($data)){
					$output = "success";
				} 
				if ($_FILES['id_specimen']['error'] > 0) {
					$output =  "Error: " . $_FILES['id_specimen']['error'] . "<br />";
				} else {
					$allowedExts = array("gif", "jpeg", "jpg", "png", "JPG", "PNG", "GIF", "application/pdf");
					$extension = end(explode(".", $_FILES["id_specimen"]["name"]));
					if(($_FILES["id_specimen"]["size"] < 200000000) && in_array($extension, $allowedExts)){ 							
						if($_FILES["id_specimen"]["error"] > 0){
							$output =  "Return Code: " . $_FILES["id_specimen"]["error"] . "<br>";
						}else{
							$normal = 'img/ids/'.$_FILES['id_specimen']['name'];
							if(file_exists($normal)){
								$data['id_specimen'] = $normal;
								$data['id'] = $person_id;
								if($person->updateSpecimen($data)){					
									 $output =  'success';
								}else{
									$output =  "Oooooops!! there was an error! ";
								}
							}else{		
								$data['id_specimen'] = $normal;
								$data['id'] = $person_id;
								$images->load($_FILES['id_specimen']['tmp_name']);
								$images->resize(131, 120); 
								$images->output($_FILES["id_specimen"]["type"]);
								$images->save('img/ids/'.$_FILES['id_specimen']['name']);
								if($person->updateSpecimen($data)){					
									 $output =  'success';
								}else{
									$output =  "Oooooops!! there was an error! ";
								}
								
							}
						}
					} 
					
				}
			}else{ 
				$output = "Member details could not be added. Please try again!";
			} 
		break;
		case "update_member":
			$data = $_POST;
			$member = new Member();
			$person = new Person();
			
			if(empty($_FILES["id_specimen"]["tmp_name"])){
				$data['id_specimen'] = @$data["existing_specimen"];	
			}
			if($person->updatePerson($data)){
				if(!empty($data['relative'])){
					$person->deleteRelatives($data['personId']);
					foreach($data['relative'] as $single){
						$single['personId'] = $data['personId'];
						$person->addRelative($single);
					} 	 
				}
				if(!empty($data['employment'])){
					$person->deleteEmployment($data['personId']);
					foreach($data['employment'] as $single){
						$single['dateCreated'] = time();
						$single['createdBy'] = $data['modifiedBy'];
						$single['personId'] = $data['personId'];
						$single['modifiedBy'] = $data['modifiedBy'];
						$person->addPersonEmployment($single);
					} 	 
				}
				if(!empty($data['business'])){
					$person->deleteBusiness($data['personId']);
					foreach($data['business'] as $single){
						$single['dateAdded'] = time();
						$single['addedBy'] = $data['modifiedBy'];
						$single['personId'] = $data['personId'];
						$person->addPersonBusiness($single);
					} 	 
				}
				if($member->updateMember($data)){
					$output = "success";
				} 
				if(!empty($_FILES["id_specimen"]["tmp_name"])) {
					if ($_FILES['id_specimen']['error'] > 0) {
						$output =  "Error: " . $_FILES['id_specimen']['error'] . "<br />";
					} else {
						$allowedExts = array("gif", "jpeg", "jpg", "png", "JPG", "PNG", "GIF", "application/pdf");
						$extension = end(explode(".", $_FILES["id_specimen"]["name"]));
						if(($_FILES["id_specimen"]["size"] < 200000000) && in_array($extension, $allowedExts)){ 							
							if($_FILES["id_specimen"]["error"] > 0){
								$output =  "Return Code: " . $_FILES["id_specimen"]["error"] . "<br>";
							}else{
								$normal = 'img/ids/'.$_FILES['id_specimen']['name'];
								if(file_exists($normal)){
									$data['id_specimen'] = $normal;
									$data['id'] = $data['personId'];
									if($person->updateSpecimen($data)){					
										 $output =  'success';
									}else{
										$output =  "Oooooops!! there was an error! ";
									}
								}else{		
									$data['id_specimen'] = $normal;
									$data['id'] = $data['personId'];
									$images->load($_FILES['id_specimen']['tmp_name']);
									$images->resize(131, 120); 
									$images->output($_FILES["id_specimen"]["type"]);
									$images->save('img/ids/'.$_FILES['id_specimen']['name']);
									if($person->updateSpecimen($data)){					
										 $output =  'success';
									}else{
										$output =  "Oooooops!! there was an error! ";
									}
									
								}
							}
						} 
						
					}
				}
			}else{ 
				$output = "Member details could not be updated. Please try again!";
			}  
		break;
		case "subscription":
			$data = $_POST;
			$member = new Member();
			$subscription = new Subscription();
			$income = new Income();
			$data['date_paid'] = date("Y-m-d");
			 if($subscription->addSubscription($data)){
				echo "success";
			}  
		break;
		case "add_income":
			$data = $_POST;
			$income = new Income();
			 if($income->addIncome($data)){
				echo "success";
			}  
		break;
		case "shares":
			$data = $_POST;
			$member = new Member();
			$shares = new Shares();
			$income = new Income();
			$data['date_paid'] = date("Y-m-d");
			if($shares->addShares($data)){
				echo "success";
			} 
		break;
		
		case "person_type":
			$person_type = new PersonType();
			if(isset($_POST['id']) && $_POST['id'] != ""){
				if($person_type->updatePersonType($_POST)){
					$output = "success";
				}else{
					$output ="Person type could not be updated";
				}
			}else{
				if($person_type->addPersonType($_POST)){
					$output = "success";
				}else{
					$output ="Person type could not be added";
				}
			}
		break;
		case "marital_status":
			$marital_status = new MaritalStatus();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($marital_status->updateMaritalStatus($data)){
					$output = "success";
				}else{
					$output ="Marital Status could not be updated";
				}
			}else{
				if($marital_status->addMaritalStatus($data)){
					$output = "success";
				}else{
					$output ="Marital Status could not be added";
				}
			}
		break;
		
		case "account_type":
			$account_type = new AccountType();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($account_type->updateAccountType($data)){
					$output = "success";
				}else{
					$output ="Account type could not be updated";
				}
			}else{
				if($account_type->addAccountType($data)){
					$output = "success";
				}else{
					$output ="Account type could not be added";
				}
			}
		break;
		case "branch":
			$branch = new Branch();
			$data  = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($branch->updateBranch($data )){
					$output = "success";
				}else{
					$output ="Branch type could not be updated";
				}
			}else{
				if($branch->addBranch($data )){
					$output = "success";
				}else{
					$output ="Branch type could not be added";
				}
			}
		break;
		case "access_level":
			$access_level = new AccessLevel();
			if($access_level->addAccessLevel($_POST)){
				$output = "success";
			}else{
				$output ="AccessLevel type could not be added";
			}
		break;
		case "income_source":
			$income_source = new IncomeSource();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($income_source->updatIncomeSource($data)){
					$output = "success";
				}else{
					echo "Could not update income source";
				}
			}else{
				if($income_source->addIncomeSource($data)){
					$output = "success";
				}else{
					$output ="Income source could not be added";
				}
			}
		break;
		case "individual_type":
			$individual_type = new IndividualType();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($individual_type->updateIndividualType($data)){
					$output = "success";
				}else{
					$output ="Individual type could not be updated.";
				}
			}else{
				if($individual_type->addIndividualType($data)){
					$output = "success";
				}else{
					$output ="Individual type could not be added";
				}
			}
		break;
		case "loan_type":
			$loan_type = new LoanType();
			if($loan_type->addLoanType($_POST)){
				$output = "success";
			}else{
				$output ="Loan type could not be added";
			}
		break;
		case "penality_calculation":
			$penality_calculation = new PenaltyCalculationMethod();
			if($penality_calculation->addPenaltyCalculationMethod($_POST)){
				$output = "success";
			}else{
				$output ="Penality calculation could not be added";
			}
		break;
		case "loan_product_penalty":
			$loan_product_penalty = new LoanProductsPenalties();
			if($loan_product_penalty->addLoanProductPenalty($_POST)){
				$output = "success";
			}else{
				$output ="Loan product penalty could not be added";
			}
		break;
		case "relation_type":
			$relation_type = new RelationshipType();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($relation_type->updateRelationshipType($data)){
					$output = "success";
				}else{
					$output ="Relationship type could not be updated";
				}
			}else{
				if($relation_type->addRelationshipType($data)){
					$output = "success";
				}else{
					$output ="Relationship type could not be added";
				}
			}
		break;
		case "repayment_duration":
			$repayment_duration = new LoanRepaymentDuration();
			if($repayment_duration->addLoanRepaymentDuration($_POST)){
				$output = "success";
			}else{
				$output ="Loan repayment duration could not be added";
			}
		break;
		case "security_type":
			$security_type = new SecurityType();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($security_type->updateSecurityType($data)){
					$output = "success";
				}else{
					$output ="Security type could not be updated";
				}
			}else{	
				if($security_type->addSecurityType($data)){
					$output = "success";
				}else{
					$output ="Security type could not be added";
				}
			}
		break;
		case "position":
			$position = new Position();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($position->updatePosition($data)){
					$output = "success";
				}else{
					$output ="Position could not be updated";
				}
			}else{
				if($position->addPosition($_POST)){
					$output = "success";
				}else{
					$output ="Position could not be added";
				}
			}
		break;
		case "id_card_type":
			$id_card_type = new IdCardType();
			$data  = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($id_card_type->updateIdCardType($data)){
					$output = "success";
				}else{
					$output ="Id Card Type could not be updated";
				}
			}else{
				if($id_card_type->addIdCardType($data)){
					$output = "success";
				}else{
					$output ="Id Card Type could not be added";
				}
			}
		break;
		case "loan_product_type":
			$data = $_POST;
			$loan_product_type = new LoanProductType();
			if(isset($data['id']) && $data['id'] != ""){
				if($loan_product_type->updateProductType($data)){
					$output = "success";
				}else{
					echo "Could not update loan product type";
				}
			}else{
				if($loan_product_type->addLoanProductType($data)){
					$output = "success";
				}else{
					$output ="Loan Product Type could not be added";
				}
			}
			
		break;
		case "address_type":
			$address_type = new AddressType();
			 if($address_type->addIdAdressType($_POST)){
				$output = "success";
			 }
		break;
		case "expense_type":
			$expense_types = new ExpenseTypes();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($expense_types->updateExpenseType($data)){
					$output = "success";
				}else{
					echo "Could not update an expense type";
				}
			}else{
				if($expense_types->addExpenseType($data)){
					$output = "success";
				}else{
					echo "Could not add an expense type";
				}
					
			}
		break;
		case "add_expense":
			$expenses = new Expenses();
			$data = $_POST;
			if(isset($data['id']) && $data['id'] != ""){
				if($expenses->updateExpense($data)){
					$output = "updated";
				}else{
					echo "Could not update an expense";
				}
			}else{
				if($expenses->addExpense($data)){
					$output = "success";
				}else{
					echo "Could not add an expense";
				}
					
			}
		break;
		default:
			echo "No data submited!";
		break;
	}
	echo $output;
}
?>