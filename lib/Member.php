<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Member extends Db {
	protected static $table_name  = "member";
	protected static $db_fields = array("id","person_id","branch_id","member_type","comments", "added_by","date_added", "active");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function findByPersonIdNo($pno){
		$result = $this->getrec(self::$table_name, "person_id=".$pno, "", "");
		return !empty($result) ? $result:false;
	}
	public function findPersonNumber($id){
		$result = $this->getfrec(self::$table_name, "person_id", "id=".$id, "", "");
		return !empty($result) ? $result['person_id']: false;
	}
	public function findMemberIdByPersonIdNo($pno){
		$result = $this->getfrec(self::$table_name, "id", "person_id=".$pno, "", "");
		return !empty($result) ? $result['id']:false;
	}
	public function findGender($g){
		if($g=="F"){
			return "Female";
		}elseif($g == "M"){
			return "Male";
		}
		return false;
	}
	public function findBranch($br){
		$result = $this->getfrec("branch", "branch_name", "branch_number='$br'","","");
		return !empty($result) ? $result['branch_name'] : false;
	}
	public function findMemberNames($p_id){
		$result = $this->getfrec("person", "firstname, lastname, othername", "id=".$pno, "", "");
		return !empty($result) ? $result['firstname']." ".$result['othername']." ".$result['lastname'] : false;
	}
	public function personDetails($id){
		$results = $this->getrec(self::$table_name." mb, person p", "mb.id=".$id." AND mb.person_id = p.id", "", "");
		return !empty($results) ? $results : false;
	}
	public function noOfMembers($where = 1){
		return $this->count("member", $where);
	}
	public function findMemberPersonNumber($id){
		$result = $this->getfrec(self::$table_name, "person_id", "id=".$id, "", "");
		return !empty($result) ? $result['person_id'] : false;
	}
	public function findAll(){
		$result_array = $this->queryData("SELECT `member`.`id`, `member`.`person_id`, `firstname`, `lastname`, `othername`, `phone`, `email`, `postal_address`, `physical_address`, `dateofbirth`, `gender`, `date_registered`, `photograph`, `member_type`, `date_added`, `branch_number`, `added_by` FROM `member` JOIN `person` ON `member`.`person_id` = `person`.`id`");
		return !empty($result_array) ? $result_array : false;
	}
	public function findGuarantors($person_no){
		$result_array = $this->queryData("SELECT `member`.`person_id`, `phone`, `shares`, `savings`, CONCAT(`firstname`, ' ', `lastname`, ' ', `othername`) `member_names` FROM `member` JOIN `person` ON `member`.`person_id` = `person`.`id` JOIN (SELECT SUM(`amount`) savings, `person_id` FROM `transaction` WHERE `transaction_type`=1 GROUP BY `person_id`) `client_savings` ON `member`.`person_id` = `client_savings`.`person_id` JOIN (SELECT SUM(`amount`) `shares`, `person_id` FROM `shares` GROUP BY `person_id`) `client_shares` ON `member`.`person_id` = `client_shares`.`person_id` WHERE `member`.`id` <> {$_GET['member_id']}");
		return !empty($result_array) ? $result_array : false;
	}
	public function findNamesByPersonNumber($pno){
		$result = $this->getrec(self::$table_name." st, person p", "p.firstname, p.lastname, p.othername", "p.person_id=".$pno." AND p.id = st.person_id", "", "");
		return !empty($result) ? $result['firstname']." ".$result['othername']." ".$result['lastname'] : false;
	}
	public function findNamesById($id){
		$result = $this->getrec(self::$table_name." st, person p", "p.first_name, p.last_name, p.other_names", "st.id='$id' AND p.person_id = st.person_id", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	
	public function addMember($data){
		$fields = array("person_id","branch_number","member_type","comment", "added_by","date_added");
		$ins_id = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		if($ins_id){
			return $ins_id;
		}
		return false;
	}
	public function updateMember($data){
		$fields = array("comment");
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	public function deActicateMember($data){
		if($this->update_single(self::$table_name, $data['field'], $data['value'], "id=".$data['primary'])){
			return true;
		}
		return false;
	}
	public function deleteMember($id){
		if($this->update_single(self::$table_name, "active", 0, "id=".$id)){
			return true;
		}else{
			return false;
		}
	}
	
}
?>