<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanProduct extends Db {
	protected static $table_name  = "loan_products";
	
	protected static $table_fields = array("`loan_products`.`id`", "productName", "`loan_products`.`description`", "productType", "`loan_products`.active`", "availableTo", "defAmount", "minAmount", "maxAmount", "maxTranches", "defInterest", "minInterest", "maxInterest", "repaymentsFrequency", "repaymentsMadeEvery", "defRepaymentInstallments", "minRepaymentInstallments", "maxRepaymentInstallments", "daysOfYear", "initialAccountState", "defGracePeriod", "minGracePeriod", "maxGracePeriod", "minCollateral", "minGuarantors", "defOffSet", "minOffSet", "maxOffSet", "penaltyCalculationMethodId", "penaltyTolerancePeriod", "penaltyRateChargedPer", "defPenaltyRate", "minPenaltyRate", "maxPenaltyRate", "taxRateSource", "taxCalculationMethod", "linkToDepositAccount", "`loan_products`.`createdBy`", "`loan_products`.`dateCreated`",  "`loan_products`.`modifiedBy`");
	
	//"penaltyApplicable", 
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll($where = ""){
		$fields = self::$table_fields;
		array_push($fields, "`typeName`");
		$table2 = " LEFT JOIN `loan_product_type` ON `loan_product_type`.`id` = `loan_products`.`productType` ";
		$result_array = $this->getfarray(self::$table_name.$table2, implode(",",$fields), $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getDtData(){
		$fields = "`loan_products`.`id`,`productName`,`loan_products`.`description`,`typeName`";
		$table2 = " LEFT JOIN `loan_product_type` ON `loan_product_type`.`id` = `loan_products`.`productType` ";
		$result_array = $this->getfarray(self::$table_name.$table2, $fields, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getGroupLoanProduct($grpLId = 1){
		$fields = "`group_loan_account`.`id`, `loanProductId`, `saccoGroupId`";
		
		$result_array = $this->getfrec("`group_loan_account`", $fields, "id=".$grpLId, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addLoanProduct($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanProduct($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteLoanProduct($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>