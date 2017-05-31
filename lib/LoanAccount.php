<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanAccount extends Db {
	protected static $table_name  = "loan_account";
	protected static $table_fields = array("id", "loanProductId", "status", "branchId", "requestedAmount", "applicationDate", "disbursedAmount", "disbursementDate", "interestRate", "offSetPeriod", "gracePeriod", "repaymentsFrequency", "repaymentsMadeEvery", "installments", "penaltyCalculationMethodId", "penaltyTolerancePeriod", "penaltyRateChargedPer", "penaltyRate", "linkToDepositAccount", "comments", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function addLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteLoanAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>