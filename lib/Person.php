<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Person extends Db {
	protected static $table_name  = "person";
	protected static $db_fields = array("id","person_number","person_type","title","firstname", "lastname", "othername","gender", "dateofbirth", "phone", "email","country","district","county","subcounty","parish","village","id_type", "id_number","physical_address","postal_address", "occupation", "photograph", "comment", "date_registered", "registered_by");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	
	public function personNumber($id){
		$result = $this->getfrec(self::$table_name, "person_number", "id=".$id, "", "");
		return !empty($result) ? $result['person_number'] : false;
	}
	public function findByPersonNumber($pno){
		$pno = $this->escape_value($pno);
		$result = $this->getrec(self::$table_name, "person_number='$pno'", "", "");
		return !empty($result) ? $result:false;
	}
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findNamesByPersonNumber($pno){
		$result = $this->getfrec(self::$table_name, "first_name, last_name, other_names", "person_number='$pno'", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	public function findNamesById($id){
		$result = $this->getfrec(self::$table_name, "first_name, last_name, other_names", "id=".$id, "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	
	public function updateImage($data){
		if($this->update(self::$table_name, array('photograph'), array('photograph'=>$data['photograph']), "id=".$data['id'])){
			return true;
		}else{
			return false;
		}
	}
	public function addPerson($data){
		$fields = array("person_number","person_type","title","firstname", "lastname", "othername","gender", "dateofbirth", "phone", "email","country","district","county","subcounty","parish","village","id_type", "id_number","physical_address","postal_address", "occupation", "photograph", "comment", "date_registered", "registered_by");
		$data['dateofbirth'] = $this->formatSlashedDate($data['dateofbirth']);
		return $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
			
	}
	public function updatePerson($data){
		$fields = array_slice(self::$db_fields,1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>