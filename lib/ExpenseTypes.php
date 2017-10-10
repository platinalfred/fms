<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class ExpenseTypes extends Db {
	protected static $table_name  = "expensetypes";
	protected static $db_fields = array("id", "name", "description");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "active=1", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findExpenseType($id){
		$result = $this->getfrec(self::$table_name, "name", "id=".$id, "", "");
		return !empty($result) ? $result['name'] : false;
	}
	public function addExpenseType($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateExpenseType($data){
		$fields = array_slice(self::$db_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
}
?>