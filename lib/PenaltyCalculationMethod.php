<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class PenaltyCalculationMethod extends Db {
	protected static $table_name  = "penalty_calculation_method";
	protected static $db_fields = array("id", "methodDescription","dateCreated","dateModified", "createdBy", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
		
	}
	public function addPenaltyCalculationMethod($data){
		$fields = array_slice(self::$db_fields,1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updatePenaltyCalculationMethod($data){
		$fields = array_slice(self::$db_fields,1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>