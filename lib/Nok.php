<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Nok extends Db {
	protected static $table_name  = "nextofkin";
	protected static $db_fields = array("id", "name","person_number",  "relationship",  "gender", "marital_status", "phone", "physical_address", "postal_address", "added_by", "date_added");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findMemberNextOfKin($pno){
		$result_array = $this->getarray(self::$table_name, "person_number=".$pno, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findSubscriptionAmount($id){
		$result = $this->getfrec(self::$table_name, "amount", "id=".$id, "", "");
		return !empty($result) ? $result['amount'] : false;
	}
	public function findSubscriptionAmountForYear($year){
		$result = $this->getfrec(self::$table_name, "amount", "year=".$id, "", "");
		return !empty($result) ? $result['amount'] : false;
	}
	public function isSubscribedForYear($pno, $year){
		$result = $this->getrec(self::$table_name, "subscription_year=".$year." AND person_number=".$pno, "", "");
		if($result > 0){
			return true;
		}
		return false;
	}
	public function addNok($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateNok($data){
		$fields = array("name","person_number",  "relationship",  "gender", "marital_status", "phone", "physical_address", "postal_address", "added_by");
		
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$data['id'])){
			return true;
		}
		return false;
	}
}
?>