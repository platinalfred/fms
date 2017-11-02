<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Member extends Db {
	protected static $table_name  = "member";
	protected static $db_fields = array("id","personId","branch_id","memberType","comment", "addedBy","dateAdded", "active", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function findByPersonId($pno){
		$result = $this->getrec(self::$table_name, "personId=".$pno, "", "");
		return !empty($result) ? $result:false;
	}
	public function findMemberDetails($id){
		$result = $this->getrec("person p, member m", "m.id=".$id." AND m.personId=p.id", "", "");
		return !empty($result) ? $result:false;
	}
	public function findPersonId($id){
		$result = $this->getfrec(self::$table_name, "personId", "id=".$id, "", "");
		return !empty($result) ? $result['personId']: false;
	}
	public function findPersonNumber($id){
		$result = $this->getfrec("person", "person_number", "id=".$id, "", "");
		return !empty($result) ? $result['person_number']: false;
	}
	
	public function findNoOfMembers(){
		return $this->count(self::$table_name, "active=1");
	}
	public function findMemberIdByPersonIdNo($pno){
		$result = $this->getfrec(self::$table_name, "id", "personId=".$pno, "", "");
		return !empty($result) ? $result['id']:false;
	}
	public function findGender($g){
		if($g==0){
			return "Female";
		}elseif($g == 1){
			return "Male";
		}
		return false;
	}
	public function findBranch($br){
		$result = $this->getfrec("branch", "branch_name", "branch_id='$br'","","");
		return !empty($result) ? $result['branchName'] : false;
	}
	public function findMemberNames($p_id){
		$result = $this->getfrec("person", "firstname, lastname, othername", "id=".$p_id, "", "");
		return !empty($result) ? $result['firstname']." ".$result['othername']." ".$result['lastname'] : false;
	}
	public function personDetails($id){
		$results = $this->getrec(self::$table_name." mb, person p", "mb.id=".$id." AND mb.personId = p.id", "", "");
		return !empty($results) ? $results : false;
	}
	public function noOfMembers($where = 1){
		return $this->count("member", $where);
	}
	public function findMemberPersonNumber($id){
		$result = $this->getfrec(self::$table_name, "personId", "id=".$id, "", "");
		return !empty($result) ? $result['personId'] : false;
	}
	//list of the members for special kinds of select lists
	public function findPersonList($id){
		$table = self::$table_name. " JOIN `person` ON `member`.`personId` = `person`.`id`";
		$fields = "`person`.`id`, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, 1 `clientType`";
		$result_array = $this->getfrec($table, $fields, "person.id=".$id, "", "");
		return $result_array;
	}
	//list of the members for special kinds of select lists
	public function findSelectList($where = 1){
		$table = self::$table_name. " JOIN `person` ON `member`.`personId` = `person`.`id`";
		$fields = "`member`.`id`, CONCAT(`lastname`,' ',`firstname`,' ',`othername`) `clientNames`, 1 `clientType`";
		$result_array = $this->getfarray($table, $fields, $where, "", "");
		return $result_array;
	}
	public function findAll(){
		$result_array = $this->queryData("SELECT `member`.`id`, `member`.`personId`, CONCAT(`lastname`, ' ', `firstname`, ' ', `othername`) `memberNames`, `firstname`, `lastname`, `othername`, `phone`, `email`, `postal_address`,`person_number`, `id_number`, `person`.`comment`,`physical_address`, `dateofbirth`, `gender`, `date_registered`, `photograph`, `memberType`, `dateAdded`, `branch_id`, `addedBy` FROM `member` JOIN `person` ON `member`.`personId` = `person`.`id`");
		return !empty($result_array) ? $result_array : false;
	}
	public function findNamesByPersonNumber($pno){
		$result = $this->getrec(self::$table_name." st, person p", "p.firstname, p.lastname, p.othername", "p.personId=".$pno." AND p.id = st.personId", "", "");
		return !empty($result) ? $result['firstname']." ".$result['othername']." ".$result['lastname'] : false;
	}
	public function findNamesById($id){
		$result = $this->getrec(self::$table_name." st, person p", "p.first_name, p.last_name, p.other_names", "st.id='$id' AND p.id = st.personId", "", "");
		return !empty($result) ? $result['first_name']." ".$result['other_names']." ".$result['last_name'] : false;
	}
	
	public function addMember($data){
		$fields = array_slice(self::$db_fields, 1);
		return $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
	}
	public function updateMember($data){
		$fields =  array("comment","modifiedBy");
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	public function deActicateMember($data){
		if($this->update(self::$table_name, $data['field'], $data['value'], "id=".$data['primary'])){
			return true;
		}
		return false;
	}
	public function deleteMember($id){
		if($this->del(self::$table_name, "id=".$id)){
			return true;
		}else{
			return false;
		}
	}
	
}
?>