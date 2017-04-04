<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Deposits extends Db {
	protected static $table_name  = "deposits";
	protected static $db_fields = array("id", "account_number", "deposit_type","amount", "particulars", "depositor_name","deposit_date", "deposited_by");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findByAccountNumber($accno){
		$result = $this->getarray(self::$table_name, "account_number='$accno'", "");
		return !empty($result) ? $result:false;
	}
	
	public function findAllDeposits(){
		$result_array = $this->getarray(self::$table_name, "","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findAccountCredit($accno){
		$result = $this->getfrec(self::$table_name, "credit", "account_number='$accno'", "");
		return !empty($result) ? $result['credit']:false;
	}
	public function findDateDeposited($id){
		$result = $this->getfrec(self::$table_name, "deposit_date", "id='$ud'", "");
		return !empty($result) ? $result['deposit_date']:false;
	}
	public function findDepositor($id){
		$result = $this->getfrec(self::$table_name, "deposited_by", "id='$id'", "");
		return !empty($result) ? $result['created_by']:false;
	}
	
	public function addDeposit($data){
		$fields = array_slice(1, self::$db_fields);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateDeposit($data){
		$fields = array_slice(1, self::$db_fields);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>