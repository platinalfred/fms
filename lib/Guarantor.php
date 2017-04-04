<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Guarantor extends Db {
	protected static $table_name  = "guarantor";
	protected static $db_fields = array("id", "person_number", "loan_number");
	
	public function findById($id){
		$result = $this->getRecord(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findAll(){
		$result_array = $this->getRecords(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function addGuarantors($data){
		if($this->addMultiple(self::$table_name, array("person_number", "loan_number"), $data)){
			return true;
		}else{
			return false;
		}
	}
	public function deleteGuarantor($id){
		$this->delete(self::$table_name, "id=".$id);
	}
	public function updateGuarantor($data){
		if($this->update(self::$table_name,array("person_number", "loan_number", "branch_id","loan_type", "loan_date", "loan_amount","loan_amount_word", "interest_rate", "expected_payback", "daily_default_amount", "approved_by", "repayment_duration", "comments"), array("person_number"=>$data['person_number'], "loan_number"=>$data['loan_number']), "id=".$data['id'])){
			return true;
		}else{
			echo "Failed to update";
			return false;
		}
	}
	
}
?>