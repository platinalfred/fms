<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanAccount extends Db {
	protected static $table_name  = "loan_account";
	protected static $table_fields = array("id", "loanNo", "branch_id", "status", "loanProductId", "requestedAmount", "applicationDate", "disbursedAmount", "disbursementDate", "interestRate", "offSetPeriod", "gracePeriod", "repaymentsFrequency", "repaymentsMadeEvery", "installments", "penaltyCalculationMethodId", "penaltyTolerancePeriod", "penaltyRateChargedPer", "penaltyRate", "linkToDepositAccount", "comments", "createdBy", "dateCreated", "modifiedBy", "dateModified");
	
	protected static $member_sql = "SELECT `members`.`id` `clientId`, loanAccountId, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, 1 `clientType` FROM `member_loan_account` JOIN (SELECT `member`.`id`, `firstname`, `lastname`, `othername` FROM `member` JOIN `person` ON `member`.`personId`=`person`.`id`)`members` ON `memberId` = `members`.`id`";
	
	protected static $saccogroup_sql = "SELECT `saccogroup`.`id` `clientId`, `loanAccountId`, `groupName` `clientNames`, 2 as `clientType` FROM `group_loan_account` JOIN `saccogroup` ON `saccoGroupId` = `saccogroup`.`id`";
	
	
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll($where = 1){
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getApplications($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`clientNames`", "`clientId`", "`productName`", "`requestedAmount`", "`disbursedAmount`", "`applicationDate`", "`offSetPeriod`" , "`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`installments`" );
		
		$member_group_union_sql = " ".self::$member_sql. " UNION ". self::$saccogroup_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id`";
	
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function addLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteLoanAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>