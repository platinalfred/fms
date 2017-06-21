<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Guarantor extends Db {
	protected static $table_name  = "guarantor";
	protected static $db_fields = array("id", "memberId", "loanAccountId", "createdBy", "dateCreated", "modifiedBy", "dateModified");
	
	public function findById($id){
		$result = $this->getRecord(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findAll(){
		$result_array = $this->getRecords(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findGuarantors(){
		$result_array = $this->queryData("SELECT `member`.`id`, `phone`, `shares`, `savings`, CONCAT(`firstname`, ' ', `lastname`, ' ', `othername`) `memberNames` FROM `member` JOIN `person` ON `member`.`personId` = `person`.`id` JOIN (SELECT SUM(`amount`) savings, `personId` FROM `account_transaction` WHERE `transactionType`=1 GROUP BY `personId`) `client_savings` ON `member`.`personId` = `client_savings`.`personId` JOIN (SELECT SUM(`amount`) `shares`, `personId` FROM `shares` GROUP BY `personId`) `client_shares` ON `member`.`personId` = `client_shares`.`personId`");
		return !empty($result_array) ? $result_array : false;
	}
	public function getLoanGuarantors($loanAccountId){
		$fields = array( "`members`.`id`", "`phone`", "`shares`", "`savings`","`outstanding_loan`", "`memberNames`" );
		
		$members_sql = "(SELECT `member`.`id`, `phone`, CONCAT(`firstname`, ' ', `lastname`, ' ', `othername`) `memberNames` FROM `member` JOIN `person` ON `member`.`personId` = `person`.`id`) `members`";
		
		$savings_sql = "(SELECT SUM(`amount`) savings, `personId` FROM `account_transaction` WHERE `transactionType`=1 GROUP BY `personId`) `client_savings`";
		
		$shares_sql = "(SELECT SUM(`amount`) `shares`, `personId` FROM `shares` GROUP BY `personId`) `client_shares` ";
		
		$loan_balances_sql = "(SELECT `memberId`, SUM(COALESCE(`approvedAmount`,0)) `loanAmount`, SUM(COALESCE(`amount`,0)) `amountPaid` FROM `loan_account` JOIN `member_loan_account` ON `loan_account`.`id` = `member_loan_account`.`loanAccountId` LEFT JOIN `loan_repayment` ON `loan_account`.`id`=loan_repayment`.`loanAccountId` GROUP BY `memberId`) `loan_balances` ";
		
		$table = self::$table_name." JOIN ".$members_sql." ON `members`.`id` = ".(self::$table_name).".`memberId` LEFT JOIN ".$savings_sql." ON `client_savings`.`personId` = ".(self::$table_name).".`memberId` JOIN ".$shares_sql." ON ".(self::$table_name).".`memberId` = `client_shares`.`personId` JOIN ".$loan_balances_sql." ON ".(self::$table_name).".`memberId` = loan_balances`.`memberId`";
	
		$result_array = $this->getfarray($table, implode(",",$fields), "`loanAccountId`=".$loanAccountId, "`firstname`", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addGuarantors($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->addMultiple(self::$table_name, $fields, $data)){
			return true;
		}else{
			return false;
		}
	}
	public function deleteGuarantor($id){
		$this->delete(self::$table_name, "id=".$id);
	}
	public function updateGuarantor($data){
		$id = $data['id'];
		unset($data['origin']);
		unset($data['id']);
		if($this->updateSpecial(self::$table_name,$data, "id=".$id)){
			return true;
		}else{
			echo "Failed to update";
			return false;
		}
	}
}
?>