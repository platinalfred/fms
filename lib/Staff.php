<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Staff extends Db {
	protected static $table_name  = "staff";
	protected static $db_fields = array("id","personId","branch_id","position_id","username", "password","added_by","date_added");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findByPersonId($pno){
		$result = $this->getfrec(self::$table_name, "personId=".$pno, "");
		return !empty($result) ? $result:false;
	}
	public function findStaffDetails($id){
		$result = $this->getrec(self::$table_name." s, person p", "s.id=".$id." AND s.personId=p.id", "", "");
		return !empty($result) ? $result:false;
	}
	public function findAccessRoles($pid){
		$result_array = $this->getarray("staff_roles", "personId=".$pid, "","", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findPersonsPhoto($pno){
		$result = $this->getfrec("person", "photograph", "id=".$pno, "", "");
		return !empty($result) ? $result['photograph']:false;
	}
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	
	public function findNamesByPersonNumber($pno){
		$result = $this->getrec(self::$table_name." st, person p", "p.first_name, p.last_name, p.other_names", "st.personId='$pno' AND p.id = st.personId", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	public function findNamesById($id){
		$result = $this->getfrec(self::$table_name." st, person p", "p.first_name, p.last_name, p.other_names", "st.id=".$id." AND p.id = st.personId", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	public function addStaffAccessLevels($data){
		$fields = array("role_id", "personId");
		if($this->add("staff_roles", $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateStaffAccessLevels($data){
		$this->del('staff_roles', 'personId='.$data['personId']);
		$fields = array("role_id", "personId");
		if($this->add("staff_roles", $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function addStaff($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateStaff($data){
		$fields = array_slice(self::$db_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	public function updatePassword($data){
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, ["password2"], ["password2"=>password_hash($data['password'], PASSWORD_DEFAULT, ['cost' => 12])], "id=".$id)){
			return true;
		}
		return false;
	}
	public function deleteStaff($id){
		if($this->update(self::$table_name, array("status"), array("status"=>0), "id=".$id)){
			return true;
		}
		return false;
	}
	public function activateStaff($id){
		if($this->update(self::$table_name, array("status"), array("status"=>1), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>