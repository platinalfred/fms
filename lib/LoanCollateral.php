<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanCollateral extends Db {
	protected static $table_name  = "loan_collateral";
	protected static $table_fields = array("id", "loanAccountId", "itemName", "description", "itemValue", "attachmentUrl", "dateCreated", "createdBy", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll($where = ""){
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function addLoanCollateral($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanCollateral($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteLoanCollateral($loanAccountId){
		$this->del(self::$table_name, "loanAccountId=".$loanAccountId);
	}
}
?>