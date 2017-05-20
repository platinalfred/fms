<?php
require_once('lib/Libraries.php');
$output = "";
if(isset($_POST['tbl'])){
	switch($_POST['tbl']){
		case "person_type":
			$person_type = new PersonType();
			if($person_type->addPersonType($_POST)){
				$output = "success";
			}else{
				$output ="Person type could not be added";
			}
		break;
		case "marital_status":
			$marital_status = new MaritalStatus();
			if($marital_status->addMaritalStatus($_POST)){
				$output = "success";
			}else{
				$output ="Marital Status could not be added";
			}
		break;
		case "add_member":
			$member = new Member();
			if($person_type->addMember($_POST)){
				$output = "success";
			}else{
				$output ="Member could not be added";
			}
		break;
		case "account_type":
			$account_type = new AccountType();
			if($account_type->addAccountType($_POST)){
				$output = "success";
			}else{
				$output ="Account type could not be added";
			}
		break;
		case "branch":
			$branch = new Branch();
			if($branch->addBranch($_POST)){
				$output = "success";
			}else{
				$output ="Branch type could not be added";
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
			if($income_source->addIncomeSource($_POST)){
				$output = "success";
			}else{
				$output ="Income source could not be added";
			}
		break;
		case "individual_type":
			$individual_type = new IndividualType();
			if($individual_type->addIndividualType($_POST)){
				$output = "success";
			}else{
				$output ="Individual type could not be added";
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
			if($relation_type->addRelationshipType($_POST)){
				$output = "success";
			}else{
				$output ="Relationship type could not be added";
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
			if($security_type->addSecurityType($_POST)){
				$output = "success";
			}else{
				$output ="Security type could not be added";
			}
		break;
		case "position":
			$position = new Position();
			if($position->addPosition($_POST)){
				$output = "success";
			}else{
				$output ="Position could not be added";
			}
		break;
		case "id_card_type":
			$id_card_type = new IdCardType();
			if($id_card_type->addIdCardType($_POST)){
				$output = "success";
			}else{
				$output ="Id Card Type could not be added";
			}
		break;
		case "loan_product_type":
			$loan_product_type = new LoanProductType();
			if($loan_product_type->addLoanProductType($_POST)){
				$output = "success";
			}else{
				$output ="Loan Product Type could not be added";
			}
		break;
		case "address_type":
			$address_type = new AddressType();
			 if($address_type->addIdAdressType($_POST)){
				$output = "success";
			 }
		break;
		default:
			echo "No data submited!";
		break;
	}
	echo $output;
}
?>