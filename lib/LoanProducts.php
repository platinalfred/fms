<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanProduct extends Db {
	protected static $products_table_name  = "loan_products";
	protected static $types_table_name  = "loan_product_type";
	
	protected static $products_table_fields = array("id", "productName", "description", "productType", "active", "availableTo", "defAmount", "minAmount", "maxAmount", "maxTranches", "defInterest", "minInterest", "maxInterest", "repaymentsFrequency", "repaymentsMadeEvery", "repaymentInstallments", "minRepaymentInstallments", "maxRepaymentInstallments", "daysOfYear", "intialAccountState", "defGracePeriod", "minGracePeriod", "maxGracePeriod", "minCollateralRequired", "minGuarantorsRequired", "defaultOffSet", "minOffSet", "maxOffSet", "penaltyApplicable", "taxRateSource", "taxCalculationMethod", "linkToLoanAccount", "createdBy", "dateCreated", "dateModified", "modifiedBy");
	protected static $types_table_fields = array("id", "typeName", "description", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$products_table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$products_table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findLoanProductTypes(){
		$result_array = $this->getarray(self::$types_table, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addLoanProduct($data){
		$fields = array_slice(self::$products_table_fields, 1);
		$result = $this->add(self::$products_table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanProduct($data){
		$fields = array_slice(self::$products_table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$products_table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteLoanProduct($id){
		$this->delete(self::$product_table_name, "id=".$id);
	}
	
	//Loan product types
	public function addLoanProductType($data){
		$fields = array_slice(self::$types_table_fields, 1);
		$result = $this->add(self::$types_table, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanProductType($data){
		
		$fields = array_slice(self::$types_table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$types_table, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
}
?>