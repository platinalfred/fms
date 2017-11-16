<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositProduct extends Db {
	protected static $table_name  = "deposit_product";
	protected static $table_fields = array("`deposit_product`.`id`", "productName", "`deposit_product`.`description`", "productType", "availableTo", "recommededDepositAmount", "maxWithdrawalAmount", "defaultInterestRate", "minInterestRate", "maxInterestRate", "perNoOfDays", "accountBalForCalcInterest", "whenInterestIsPaid", "daysInYear", "applyWHTonInterest", "defaultOpeningBal", "minOpeningBal", "maxOpeningBal", "defaultTermLength", "minTermLength", "maxTermLength", "termTimeUnit", "`deposit_product`.`dateCreated`", "`deposit_product`.`createdBy`", "`deposit_product`.`dateModified`", "`deposit_product`.`modifiedBy`");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll($where = ""){
		$fields = self::$table_fields;
		array_push($fields, "`typeName`");
		$table2 = " JOIN `deposit_product_type` ON `deposit_product_type`.`id` = `deposit_product`.`productType`";
		$result_array = $this->getfarray(self::$table_name.$table2, implode(",",$fields), $where, "", "");
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