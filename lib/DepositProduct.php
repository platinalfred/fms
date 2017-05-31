<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositProduct extends Db {
	protected static $table_name  = "deposit_product";
	protected static $table_fields = array("id", "productName", "description", "productType", "availableTo", "recommededDepositAmount", "maxWithdrawalAmount", "defaultInterestRate", "minInterestRate", "maxInterestRate", "perNoOfDays", "accountBalForCalcInterest", "whenInterestIsPaid", "daysInYear", "applyWHTonInterest", "defaultOpeningBal", "minOpeningBal", "maxOpeningBal", "defaultTermLength", "minTermLength", "maxTermLength", "termTimeUnit", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getDtData(){
		$fields = "`deposit_product`.`id`,`productName`,`deposit_product`.`description`,`typeName`";
		$table2 = " JOIN `deposit_product_type` ON `deposit_product_type`.`id` = `deposit_product`.`productType`";
		$result_array = $this->getfarray(self::$table_name.$table2, $fields, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function addDepositProduct($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositProduct($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositProduct($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>