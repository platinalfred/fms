<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanProductType extends Db {
	protected static $table_name  = "loan_product_type";
	protected static $db_fields = array("id", "description", "dateCreated","dateModified", "createdBy", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function addLoanProductType($data){
		$fields = array_slice(1, self::$db_fields);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateLoanProductType($data){
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