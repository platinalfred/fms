<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');//
class Person extends Db {
	protected static $table_name  = "person";
	protected static $db_fields = array("id","person_number","person_type","id_specimen", "title","marital_status", "firstname", "lastname", "othername","gender", "dateofbirth", "phone", "phone2", "email","district","county","subcounty","parish","village","id_type", "id_number","physical_address","postal_address", "occupation", "photograph", "comment", "date_registered", "registered_by", "children_no", "dependants_no");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function updatePersonNumber($id){
		$pno = "BFS". sprintf('%08d',$id);
		if($this->update(self::$table_name, array("person_number"), array("person_number"=>$pno), "id=".$id)){
			return true;
		}
		return false;
	}
	public function findRelatives($id){
		$result = $this->getarray("person_relative", "personId=".$id, "", "");
		return !empty($result) ? $result : false;
	}
	public function findEmploymentHistory($id){
		$result = $this->getarray("person_employment", "personId=".$id, "", "");
		return !empty($result) ? $result : false;
	}
	public function findMemberBusiness($id){
		$result = $this->getarray("person_business", "personId=".$id, "", "");
		return !empty($result) ? $result : false;
	}
	public function updateStaffNumber($id){
		$pno = "SBFS". sprintf('%08d',$id);
		if($this->update(self::$table_name, array("person_number"), array("person_number"=>$pno), "id=".$id)){
			return true;
		}
		return false;
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
	
	public function findPersonEmploymentHistory($id){
		$result_array = $this->getarray("person_employment", "personId=".$id,"", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findPersonRelatives($id){
		$result_array = $this->queryData("SELECT * FROM person_relative p JOIN relationship_type r ON p.relationship=r.id WHERE p.personId=".$id);
		return !empty($result_array) ? $result_array : false;
	}
	public function findPersonsPosition($pid){
		$result = $this->getfrec("staff as st, position as p", "p.name", "st.personId='$pid' AND st.position_id = p.id", "", "");
		return !empty($result) ? $result['name'] : false;
	}
	public function findNamesByPersonNumber($pno){
		$result = $this->getfrec(self::$table_name, "firstname, lastname, othername", "person_number='$pno'", "", "");
		return !empty($result) ? $result['firstname']." ".$result['othername']." ".$result['lastname'] : false;
	}
	public function findNamesById($id){
		$result = $this->getfrec(self::$table_name, "firstname, lastname, othername", "id=".$id, "", "");
		return !empty($result) ? $result['firstname']." ".$result['othername']." ".$result['lastname'] : false;
	}
	
	public function updateImage($data){
		if($this->update(self::$table_name, array('photograph'), array('photograph'=>$data['photograph']), "id=".$data['id'])){
			return true;
		}else{
			return false;
		}
	}
	public function updateSpecimen($data){
		if($this->update(self::$table_name, array('id_specimen'), array('id_specimen'=>$data['id_specimen']), "id=".$data['id'])){
			return true;
		}else{
			return false;
		}
	}
	
	public function addPerson($data){
		
		$fields = array_slice(self::$db_fields, 1);
		return $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data)); 
			
	}

	public function addPersonEmployment($data){
		$fields = array("personId", "employer", "years_of_employment", "nature_of_employment", "monthlySalary");
		return $this->add("person_employment", $fields, $this->generateAddFields($fields, $data)); 
			
	}
	
	public function deleteEmployment($pid){
		$this->del("person_employment", "personId=".$pid);
	}
	public function addPersonBusiness($data){
		$fields = array("personId", "businessName", "natureOfBusiness", "businessLocation", "numberOfEmployees", "businessWorth", "ursbNumber", "dateAdded", "addedBy");
		
		return $this->add("person_business", $fields, $this->generateAddFields($fields, $data)); 
			
	}
	public function deleteBusiness($pid){
		$this->del("person_business", "personId=".$pid);
	}
	public function deleteRelatives($pid){
		$this->del("person_relative", "personId=".$pid);
	}
	public function addRelative($data){
		$fields = array("personId",  "is_next_of_kin", "first_name", "last_name", "other_names", "telephone", "relative_gender", "relationship", "address", "address2");
		return $this->add("person_relative", $fields, $this->generateAddFields($fields, $data)); 
			
	}
	public function updatePerson($data){
		$fields = array("id_specimen", "title","marital_status", "firstname", "lastname", "othername","gender", "dateofbirth", "phone", "email","district","county","subcounty","parish","village","id_type", "id_number","physical_address","postal_address", "occupation", "comment",  "children_no", "dependants_no", "modifiedBy");
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$data['personId'])){
			return true;
		}
		return false;
	}
	
}
?>