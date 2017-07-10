<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositAccountTransaction extends Db {
	protected static $table_name  = "deposit_account_transaction";
	protected static $table_fields = array("id", "depositAccountId", "amount", "comment", "transactionType", "dateCreated", "transactedBy",  "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getTransactionHistory($accountId = false){
		$where = "";
		if($accountId){
			$where = "`depositAccountId` = ".$accountId;
		}
		$result_array = $this->getarray(self::$table_name, $where, "dateModified DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getMoneySum($transactionType, $depositAccountIds = false){
		$where = "`transactionType`=".$transactionType;
		$in_part_string = "";
		if($depositAccountIds){
			foreach($depositAccountIds as $depositAccount){
				$in_part_string .= $depositAccount['depositAccountId'].",";
			}
			$where .= " AND `depositAccountId` IN (".substr($in_part_string, 0, -1).")";
		}
		$field = "COALESCE(SUM(`amount`),0) `money_sum`";
		$result = $this->getfrec(self::$table_name, $field, $where, "", "");
		return !empty($result) ? $result['money_sum'] :0;
	}
	
	public function addDepositAccountTransaction($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositAccountTransaction($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositAccountTransaction($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>