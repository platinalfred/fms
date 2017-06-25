<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class SaccoGroupLoanAccount extends Db {
	protected static $table_name  = "group_loan_account";
	protected static $table_fields = array("id", "saccoGroupId", "loanAccountId", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findSpecifics($fields, $where = ""){ //pick out data for specific fields
		$result_array = $this->getfarray(self::$table_name, $fields, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addSaccoGroupLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateSaccoGroupLoanAccount($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteSaccoGroupLoanAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>