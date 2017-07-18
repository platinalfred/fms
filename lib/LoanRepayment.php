<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanRepayment extends Db {
	protected static $table_name  = "loan_repayment";
	protected static $table_fields = array("id", "loanAccountId", "amount", "comments", "transactionDate", "receivedBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getPaidAmount($where1 = "1 ", $loanAccountIds){
		$where = $where1;
		$in_part_string = "";
		if(is_array($loanAccountIds)){
			foreach($loanAccountIds as $loanAccountId){
				$in_part_string .= $loanAccountId['loanAccountId'].",";
			}
			$where .= "AND `loanAccountId` IN (".substr($in_part_string, 0, -1).")";
		}
		else if(is_numeric($loanAccountIds)){
			$where = " AND loanAccountId=".$loanAccountIds;
		}
		
		$fields = "SUM(`amount`) `paidAmount`";
		$result_array = $this->getfrec(self::$table_name, $fields, $where, "", "");
		return !empty($result_array) ? $result_array['paidAmount'] : 0;
	}
	
	public function getTransactionHistory($accountId = false){
		$where = "";
		if($accountId){
			$where = "`loanAccountId` = ".$accountId;
		}
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addLoanRepayment($data){
		$result = $this->addSpecial(self::$table_name, $data);
		return $result;
	}
	
	public function updateLoanRepayment($data){
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteLoanRepayment($id){
		$this->del(self::$table_name, "id=".$id);
	}
}
?>