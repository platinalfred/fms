<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanProductFeen extends Db {
	protected static $table_name = "loan_product_feen";
	
	protected static $table_fields = array("id", "loanProductId", "loanProductFeeId", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findAllLPFDetails(){
		$table = self::$table_name. " JOIN `loan_product_fee` ON `loan_product_feen`.`loanProductFeeId` = `loan_product_fee`.`id`";
		$fields = "`loan_product_feen`.`id`, `feeName`, `loanProductId`, `amountCalculatedAs`, `requiredFee`, `amount`";
		$result_array = $this->getfarray($table, $fields, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addLoanProductFeen($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanProductFeen($data){
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->updateLoanProductFeen(self::$table_name, $table_fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function delete($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>