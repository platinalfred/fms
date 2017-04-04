<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Staff extends Db {
	protected static $table_name  = "staff";
	protected static $db_fields = array("id","person_number","branch_number","position_id","username", "password", "access_level", "added_by","date_added");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findByPersonNumber($pno){
		$result = $this->getfrec(self::$table_name, "person_number='$pno'", "");
		return !empty($result) ? $result:false;
	}
	public function findPersonsPhoto($pno){
		$result = $this->getfrec("person", "photograph", "id=".$pno, "", "");
		return !empty($result) ? $result['photograph']:false;
	}
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findNamesByPersonNumber($pno){
		$result = $this->getrec(self::$table_name." st, person p", "p.first_name, p.last_name, p.other_names", "st.person_number='$pno' AND p.person_number = st.person_number", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	public function findNamesById($id){
		$result = $this->getfrec(self::$table_name." st, person p", "p.first_name, p.last_name, p.other_names", "st.id=".$id." AND p.person_number = st.person_number", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	
	public function addStaff($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateStaff($data){
		$fields = array_slice(1, self::$db_fields);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>