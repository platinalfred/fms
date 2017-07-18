<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositAccount extends Db {
	protected static $table_name  = "deposit_account";
	protected static $table_fields = array("id", "depositProductId", "recomDepositAmount", "maxWithdrawalAmount", "interestRate", "openingBalance", "termLength", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	
	public function findAllDetailsById($id){
		$fields = array( "`deposit_account`.`id`", "`productName`", "`deposit_account`.`recomDepositAmount`", "`deposit_account`.`maxWithdrawalAmount`", "`interestRate`", "`deposit_account`.`openingBalance`", "`termLength`", "`deposit_account`.`dateCreated`", "`deposit_account`.`createdBy`");
		
		$table = self::$table_name." JOIN `deposit_product` ON `deposit_account`.`depositProductId` = `deposit_product`.`id`";
		
		$result = $this->getfrec($table, implode(",",$fields), "`deposit_account`.`id`=".$id, "", "");
		return $result;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function getSumOfFields($where1 = "1 ", $depositAccountIds = false){
		$fields = array( "COALESCE(SUM(`openingBalance`),0) `openingBalances`");
		$where = $where1;
		$in_part_string = "";
		if($depositAccountIds){
			if(is_array($depositAccountIds)){
				foreach($depositAccountIds as $depositAccountId){
					$in_part_string .= $depositAccountId['depositAccountId'].",";
				}
				$where .= " AND `id` IN (".substr($in_part_string, 0, -1).")";
			}
		}
		$result_array = $this->getfrec(self::$table_name, implode(",",$fields), $where, "", "");
		return $result_array['openingBalances'];
	}
	
	public function findSpecifics($fields, $where = ""){ //pick out data for specific fields
			$in_part_string = "";
			$where_clause = "";
		if(is_array($where)){
			foreach($where as $depositAccount){
				$in_part_string .= $depositAccount['depositAccountId'].",";
			}
			$where_clause .= " AND `id` IN (".substr($in_part_string, 0, -1).")";
		}
		$result_array = $this->getfrec(self::$table_name, $fields, $where_clause, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function getTransactionHistory($accountId = false){
		$where = "";
		if(!$accountId){
			$where = "`depositAccountId` = ".$accountId;
		}
		$result_array = $this->getfrec(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function addDepositAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateDepositAccount($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>