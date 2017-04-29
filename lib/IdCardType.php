<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class IdCardType extends Db {
	protected static $table_name  = "id_card_types";
	protected static $db_fields = array("id", "id_type");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findLoanType($id){
		$result = $this->getfrec(self::$table_name, "id_type", "id=".$id, "", "");
		return !empty($result) ? $result['id_type'] : false;
	}
	public function addLoanType($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateLoanStatus($data){
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