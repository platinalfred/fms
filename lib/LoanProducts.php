<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanProduct extends Db {
	protected static $table_name  = "loan_products";
	protected static $db_fields = array("id", "name", "payback_days", "description");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
}
?>