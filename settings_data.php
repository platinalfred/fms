<?php 
require_once("lib/Libraries.php");
$output = array();
if(isset($_POST['tbl'])){
	switch($_POST['tbl']){
		case "address_type":
			$address_type = new AddressType();
			$output['data'] = $address_type->findAll();
		break;
		case "expense_type":
			$expense_type = new ExpenseTypes();
			$output['data'] = $expense_type->findAll();
		break;
		case "marital_status":
			$marital_status = new MaritalStatus();
			$output['data'] = $marital_status->findAll();
		break;
		case "person_type":
			$person_type = new PersonType();
			$output['data'] = $person_type->findAll();
		break;
		case "account_type":
			$account_type = new AccountType();
			$output['data'] = $account_type->findAll();
		break;
		case "branch":
			$branch = new Branch();
			$output['data'] = $branch->findAll();
		break;
		case "access_level":
			$access_level = new AccessLevel();
			$output['data'] = $access_level->findAll();
		break;
		case "income_sources":
			$income_source = new IncomeSource();
			$output['data'] = $income_source->findAll();
		break;
		case "individual_types":
			$individual_type = new IndividualType();
			$output['data'] = $individual_type->findAll();
		break;
		case "loan_types":
			$loan_type = new LoanType();
			$output['data'] = $loan_type->findAll();
		break;
		case "penalty_calculations":
			$penalty_calculation = new PenaltyCalculationMethod();
			$output['data'] = $penalty_calculation->findAll();
		break;
		case "loan_product_penalties":
			$loan_product_penalties = new LoanProductsPenalties();
			$output['data'] = $loan_product_penalties->findLoanProductPenalties();
		break;
		case "relationship_types":
			$relation_type = new RelationshipType();
			$output['data'] = $relation_type->findAll();
		break;
		case "loan_repayment_durations":
			$loan_repayment_duration = new LoanRepaymentDuration();
			$output['data'] = $loan_repayment_duration->findAll();
		break;
		case "positions":
			$positions = new Position();
			$output['data'] = $positions->findPositionDetails();
		break;
		case "id_card_types":
			$id_card_type = new IdCardType();
			$output['data'] = $id_card_type->findAll();
		break;
		case "loan_product_types":
			$loan_product_type = new LoanProductType();
			$output['data'] = $loan_product_type->findAll();
		break;
		case "loan_product":
			$loan_product = new LoanProduct();
			$output['data'] = $loan_product->findAll();
		break;
		case "deposit_product":
			$deposit_product = new DepositProduct();
			$output['data'] = $deposit_product->findAll();
		break;
		case "security_types":
			$security_type = new SecurityType();
			$output['data'] = $security_type->findAll();
		break;
		default:
			echo "No data found!"; 
		break;
	}
	echo json_encode($output);
}
?>