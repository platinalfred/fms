<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositAccount extends Db {
	protected static $table_name  = "deposit_account";
	protected static $table_fields = array("id", "depositProductId", "recomDepositAmount", "maxWithdrawalAmount", "interestRate", "openingBalance", "termLength", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function addDepositAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositAccount($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>