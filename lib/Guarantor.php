<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Guarantor extends Db {
	protected static $table_name  = "guarantor";
	protected static $table_fields = array("id", "memberId", "loanAccountId", "createdBy", "dateCreated", "modifiedBy", "dateModified");
		
	protected static $members_sql = "(SELECT `member`.`id`, `phone`, CONCAT(`firstname`, ' ', `lastname`, ' ', `othername`) `memberNames` FROM `member` JOIN `person` ON `member`.`personId` = `person`.`id`) `members`";
	
	protected static $deposits_sql = "(SELECT `memberId`, SUM(COALESCE(`amount`,0)) `deposit_sum` FROM `deposit_account` JOIN `member_deposit_account` ON `deposit_account`.`id` = `member_deposit_account`.`depositAccountId` JOIN `deposit_account_transaction` ON `deposit_account`.`id` = `deposit_account_transaction`.`id` WHERE `deposit_account_transaction`.`transactionType`=1 GROUP BY `memberId`) `deposits`";
	
	protected static $withdraws_sql = "(SELECT `memberId`, SUM(COALESCE(`amount`,0)) `withdraws_sum` FROM `deposit_account` JOIN `member_deposit_account` ON `deposit_account`.`id` = `member_deposit_account`.`depositAccountId` JOIN `deposit_account_transaction` ON `deposit_account`.`id` = `deposit_account_transaction`.`id` WHERE `deposit_account_transaction`.`transactionType`=2 GROUP BY `memberId`) `withdraws`";
	
	protected static $shares_sql = "(SELECT COALESCE(SUM(`amount`),0) `shares`, `memberId` FROM `shares` GROUP BY `memberId`) `client_shares` ";
	
	protected static $loan_balances_sql = "(SELECT `memberId`, COALESCE(SUM(`amountApproved`),0) `loanAmount`, SUM(COALESCE(`amount`,0)) `amountPaid` FROM `loan_account` JOIN `member_loan_account` ON `loan_account`.`id` = `member_loan_account`.`loanAccountId` LEFT JOIN `loan_repayment` ON `loan_account`.`id`=`loan_repayment`.`loanAccountId` GROUP BY `memberId`) `loan_balances` ";
	
	public function findById($id){
		$result = $this->getRecord(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findAll(){
		$result_array = $this->getRecords(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findGuarantors(){
		$result_array = $this->queryData("SELECT `member`.`id`, `phone`, `shares`, COALESCE((`deposit_sum`-`withdraws_sum`),0) `savings`, CONCAT(`firstname`, ' ', `lastname`, ' ', `othername`) `memberNames` FROM `member` JOIN `person` ON `member`.`personId` = `person`.`id` LEFT JOIN (SELECT SUM(`amount`) savings, `memberId` FROM `account_transaction` WHERE `transactionType`=1 GROUP BY `memberId`) `client_savings` ON `member`.`id` = `client_savings`.`memberId` JOIN (SELECT SUM(`amount`) `shares`, `memberId` FROM `shares` GROUP BY `memberId`) `client_shares` ON `member`.`id` = `client_shares`.`memberId`");
		return !empty($result_array) ? $result_array : false;
	}
	public function getLoanGuarantors($filter = ""){
		$fields = array( "`members`.`id`", "`phone`", "`shares`", "COALESCE((`deposit_sum`-`withdraws_sum`),0) `savings`","COALESCE((`loanAmount`-`amountPaid`),0) `outstanding_loan`", "`memberNames`" );
		
		$table = self::$table_name." JOIN ".(self::$members_sql)." ON `members`.`id` = ".(self::$table_name).".`memberId` LEFT JOIN ".(self::$deposits_sql)." ON `deposits`.`memberId` = ".(self::$table_name).".`memberId` LEFT JOIN ".(self::$withdraws_sql)." ON `withdraws`.`memberId` = ".(self::$table_name).".`memberId` LEFT JOIN ".(self::$shares_sql)." ON ".(self::$table_name).".`memberId` = `client_shares`.`memberId` LEFT JOIN ".(self::$loan_balances_sql)." ON ".(self::$table_name).".`memberId` = `loan_balances`.`memberId`";
		
		$where = $table = "";
		if(is_numeric($filter)){
			$where = "`loanAccountId`=".$filter;
		}
		else{
			$table = (self::$members_sql)." LEFT JOIN ".(self::$deposits_sql)." ON `members`.`id` = `deposits`.`memberId` LEFT JOIN ".(self::$withdraws_sql)." ON `members`.`id` = `deposits`.`memberId` LEFT JOIN ".(self::$shares_sql)." ON `members`.`id` = `client_shares`.`memberId` LEFT JOIN ".(self::$loan_balances_sql)." ON `members`.`id` = `loan_balances`.`memberId`";
			$where = $filter;
		}
		
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`memberNames`", "");
		return $result_array;
	}
	
	public function addGuarantor($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function addGuarantors($data){
		$fields = array_slice(self::$table_fields, 1);
		if($this->addMultiple(self::$table_name, $fields, $data)){
			return true;
		}else{
			return false;
		}
	}
	public function deleteGuarantor($loanAccountId){
		$this->del(self::$table_name, "loanAccountId=".$loanAccountId);
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