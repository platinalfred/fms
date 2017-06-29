<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Subscription extends Db {
	protected static $table_name  = "subscription";
	protected static $db_fields = array("id", "amount", "memberId", "subscriptionYear", "receivedBy", "datePaid", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findGeneralSubscriptions(){
		$resultt = $this->getfarray(self::$table_name."s, memebers.m, person p", "CONCAT(p.firstname,' ',p.lastname,' ',p.othername) as member_names, s.amount, .s.subscriptionYear, s.datePaid", "s.memberId = m.memberId AND m.personId=p.id", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findMemberSubscriptions($pno){
		$result_array = $this->getarray(self::$table_name, "memberId=".$pno, "", "");
		
		return !empty($result_array) ? $result_array : false;
	}
	public function findSubscriptionAmount($where = ""){
		$result = $this->getfrec(self::$table_name, "amount", $where, "", "");
		return !empty($result) ? $result['amount'] : 0;
	}
	public function findSubscriptionAmountForYear($year){
		$result = $this->getfrec(self::$table_name, "amount", "year=".$id, "", "");
		return !empty($result) ? $result['amount'] : 0;
	}
	public function isSubscribedForYear($pno, $year){
		$result = $this->getrec(self::$table_name, "subscriptionYear=".$year." AND memberId=".$pno, "", "");
		if($result > 0){
			return true;
		}
		return false;
	}
	public function addSubscription($data){
		$fields = array_slice(self::$db_fields, 1);
		$data['amount'] = $this->stripCommasOnNumber($data['amount']);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateMemberType($data){
		$fields = array_slice(1, self::$db_fields);
		$id = $data['id'];
		unset($data['id']);
		$data['amount'] = $this->stripCommasOnNumber($data['amount']);
		
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
}
?>