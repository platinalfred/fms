<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositProduct extends Db {
	protected static $product_table  = "deposit_product";
	protected static $fee_table  = "deposit_product_fee";
	protected static $types_table  = "deposit_product_type";
	protected static $product_table_fields = array("id", "productName", "productType", "availableTo", "recommededDepositAmount", "maxWithdrawalAmount", "defaultInterestRate", "minInterestRate", "maxInterestRate", "perNoOfDays", "accountBalForCalcInterest", "whenInterestIsPaid", "daysInYear", "applyWHTonInterest", "defaultOpeningBal", "minOpeningBal", "maxOpeningBal", "defaultTermLength", "minTermLength", "maxTermLength", "termTimeUnit", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	protected static $types_table_fields = array("id", "typeName", "description", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	protected static $fee_table_fields = array("id", "feeName", "amount", "chargeTrigger", "depositProductID", "dateApplicationMethod", "createdBy", "dateCreated", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$product_table, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$product_table, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findDepositProductTypes(){
		$result_array = $this->getarray(self::$types_table, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addDepositProduct($data){
		$fields = array_slice(self::$product_table_fields, 1);
		$result = $this->add(self::$product_table, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositProduct($data){
		$fields = array_slice(self::$product_table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$product_table, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositProduct($id){
		$this->delete(self::$product_table, "id=".$id);
	}
	
	//Deposit product types
	public function addDepositProductType($data){
		$fields = array_slice(self::$types_table_fields, 1);
		$result = $this->add(self::$types_table, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositProductType($data){
		
		$fields = array_slice(self::$types_table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$types_table, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function addDepositProductFee($data){
		$fields = array_slice(self::$fee_table_fields, 1);
		/* 
		This would apply in a case where we expect all the table fields
		if($this->addMultiple(self::$fee_table, $fields, $data)){
			return true;
		}else{
			return false;
		} */
		$result = $this->add(self::$fee_table, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositProductFee($data){
		$fields = array_slice(1, self::$fee_table_fields);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$fee_table, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositProductFee($id){
		$this->delete(self::$fee_table, "id=".$id);
	}
}
?>