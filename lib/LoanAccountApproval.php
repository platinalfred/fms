<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanAccountApproval extends Db {
	protected static $table_name  = "loan_account_approval";
	protected static $table_fields = array("id", "loanAccountId", "amountRecommended", "justification", "status", "staffId", "dateCreated", "modifiedBy", "dateModified");
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function findAll($where = 1){
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function getLoanAccountApprovals($where = 1){
		$fields =( "`amountRecommended`,`justification`,`status`,`dateCreated`, `staffNames`" );
		
		$table = self::$table_name." JOIN (SELECT `staff`.`id`,CONCAT(`lastname`,' ',`othername`,' ',`firstname`)`staffNames` FROM `staff` JOIN `person` ON `staff`.`personId`=`person`.`id` ) `staff_details` ON `loan_account_approval`.`staffId`=`staff_details`.`id`";
	
		$result_array = $this->getfarray($table, $fields, $where, "`dateCreated`", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function addLoanAccountApproval($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->addSpecial(self::$table_name, $data);
		return $result;
	}
	
	public function updateLoanAccountApproval($data){
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		return $this->updateSpecial(self::$table_name, $data, "id=".$id);
	}
	
	public function deleteLoanAccountApproval($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>