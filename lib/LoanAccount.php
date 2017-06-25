<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanAccount extends Db {
	protected static $table_name  = "loan_account";
	protected static $table_fields = array("id", "loanNo", "branch_id", "status", "loanProductId", "requestedAmount", "applicationDate", "disbursedAmount", "disbursementDate", "interestRate", "offSetPeriod", "gracePeriod", "repaymentsFrequency", "repaymentsMadeEvery", "installments", "penaltyCalculationMethodId", "penaltyTolerancePeriod", "penaltyRateChargedPer", "penaltyRate", "linkToDepositAccount", "comments", "createdBy", "dateCreated", "modifiedBy", "dateModified");
	
	protected static $member_sql = "SELECT `members`.`id` `clientId`, loanAccountId, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, 1 `clientType` FROM `member_loan_account` JOIN (SELECT `member`.`id`, `firstname`, `lastname`, `othername` FROM `member` JOIN `person` ON `member`.`personId`=`person`.`id`)`members` ON `memberId` = `members`.`id`";
	
	protected static $saccogroup_sql = "SELECT `saccogroup`.`id` `clientId`, `loanAccountId`, `groupName` `clientNames`, 2 as `clientType` FROM `group_loan_account` JOIN `saccogroup` ON `saccoGroupId` = `saccogroup`.`id`";
	protected static $loan_payments_sql = "SELECT `loanAccountId`, COALESCE(SUM(amount),0) `amountPaid` FROM `loan_repayment` GROUP BY `loanAccountId`";
	
	
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll($where = 1){
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getLoanAmounts($where = ""){
			$in_part_string = "";
			$where_clause = "";
		if(is_array($where)){
			foreach($where as $depositAccount){
				$in_part_string .= $depositAccount['loanAccountId'].",";
			}
			$where_clause .= " AND `id` IN (".substr($in_part_string, 0, -1).")";
		}
		$fields = "COALESCE(SUM(`amountApproved`),0) `approved`, COALESCE(SUM(`disbursedAmount`),0) `disbursed`, COALESCE(SUM(`interestRate`),0) `interest`";
		$result_array = $this->getfrec(self::$table_name, $fields, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getApplications($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`clientNames`", "`clientId`", "`clientType`", "`productName`", "`requestedAmount`", "`disbursedAmount`", "`amountApproved`", "`applicationDate`", "`offSetPeriod`" , "`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`status`" , "`approvalNotes`" , "`installments`" );
		
		$member_group_union_sql = self::$member_sql. " UNION ". self::$saccogroup_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id`";
	
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getApprovedLoans($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`clientNames`", "`clientType`", "`clientId`", "`productName`", "`requestedAmount`", "`disbursedAmount`", "`applicationDate`", "`offSetPeriod`", "`amountApproved`" , "`approvalNotes`" ,"`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`installments`" , "`amountPaid`" , " `disbursedAmount`*(`interestRate`/100) `interest`" );
		
		$member_group_union_sql = self::$member_sql. " UNION ". self::$saccogroup_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN (". self::$loan_payments_sql. ") `loan_payments` ON `loan_account`.`id` = `loan_payments`.`loanAccountId`";
	
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
		return $this->updateSpecial(self::$table_name, $data, "id=".$id);
	}
	
	public function deleteLoanAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>