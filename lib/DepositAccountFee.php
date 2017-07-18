<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DepositAccountFee extends Db {
	protected static $table_name  = "deposit_account_fee";
	protected static $table_fields = array("id", "depositProductFeeId", "depositAccountId", "amount", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function addDepositAccountFee($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function getSum($where1 = "1 ", $depositAccountIds = false){
		$where = $where1;
		$in_part_string = "";
		if($depositAccountIds){
			foreach($depositAccountIds as $depositAccount){
				$in_part_string .= $depositAccount['depositAccountId'].",";
			}
			$where .= " AND `depositAccountId` IN (".substr($in_part_string, 0, -1).")";
		}
		$field = "COALESCE(SUM(`amount`),0) `feeSum`";
		$result = $this->getfrec(self::$table_name, $field, $where, "", "");
		return !empty($result) ? $result['feeSum'] : 0;
	}
	
	public function updateDepositAccountFee($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteDepositAccountFee($depositAccountId){
		$this->del(self::$table_name, "depositAccountId=".$depositAccountId);
	}
}
?>