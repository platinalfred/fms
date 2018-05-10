<?php

require_once("../lib/Libraries.php");
$output = array();
if (isset($_POST['tbl'])) {
    switch ($_POST['tbl']) {
        case "tblAddressType":
            $address_type_obj = new AddressType();
            $output['data'] = $address_type_obj->findAll();
            break;
        case "tblExpenseType":
            $expense_type_obj = new ExpenseTypes();
            $output['data'] = $expense_type_obj->findAll();
            break;
        case "tblMaritalStatus":
            $marital_status_obj = new MaritalStatus();
            $output['data'] = $marital_status_obj->findAll();
            break;
        case "tblPersonType":
            $person_type_obj = new PersonType();
            $output['data'] = $person_type_obj->findAll();
            break;
        case "tblAccountType":
            $account_type_obj = new AccountType();
            $output['data'] = $account_type_obj->findAll();
            break;
        case "tblBranch":
            $branch_obj = new Branch();
            $output['data'] = $branch_obj->findAll();
            break;
        case "tblAccessLevel":
            $access_level_obj = new AccessLevel();
            $output['data'] = $access_level_obj->findAll();
            break;
        case "tblIncomeSource":
            $income_source_obj = new IncomeSource();
            $output['data'] = $income_source_obj->findAll();
            break;
        case "tblIndividualType":
            $individual_type_obj = new IndividualType();
            $output['data'] = $individual_type_obj->findAll();
            break;
        case "tblLoanType":
            $loan_type_obj = new LoanType();
            $output['data'] = $loan_type_obj->findAll();
            break;
        case "tblPenaltyCalculationMethod":
            $penalty_calculation_method_obj = new PenaltyCalculationMethod();
            $output['data'] = $penalty_calculation_method_obj->findAll();
            break;
        case "tblLoanProductPenalty":
            $loan_product_penalty_obj = new LoanProductsPenalties();
            $output['data'] = $loan_product_penalty_obj->findLoanProductPenalties();
            break;
        case "tblRelationshipType":
            $relationship_type = new RelationshipType();
            $output['data'] = $relationship_type->findAll();
            break;
        case "loan_repayment_durations":
            $loan_repayment_duration = new LoanRepaymentDuration();
            $output['data'] = $loan_repayment_duration->findAll();
            break;
        case "tblPosition":
            $position_obj = new Position();
            $output['data'] = $position_obj->findPositionDetails();
            break;
        case "tblIdCardType":
            $id_card_type_obj = new IdCardType();
            $output['data'] = $id_card_type_obj->findAll();
            break;
        case "tblLoanProductType":
            $loan_product_type_obj = new LoanProductType();
            $output['data'] = $loan_product_type_obj->findAll();
            break;
        case "tblLoanProduct":
            $loan_product = new LoanProduct();
            $output['data'] = $loan_product->findAll();
            break;
        case "tblLoanProductFee":
            $loanProductFee = new LoanProductFee();
            $output['data'] = $loanProductFee->findAll();
            break;
        case "tblDepositProduct":
            $deposit_product = new DepositProduct();
            $output['data'] = $deposit_product->findAll();
            break;
        case "tblDepositProductFee":
            $deposit_product_fee_obj = new DepositProductFee();
            $output['data'] = $deposit_product_fee_obj->findAll();
            break;
        case "tblSecurityType":
            $security_type_obj = new SecurityType();
            $output['data'] = $security_type_obj->findAll();
            break;
        default:
            echo "No data found!";
            break;
    }
    echo json_encode($output);
}