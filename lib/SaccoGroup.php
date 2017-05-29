<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class SaccoGroup extends Db {
	protected static $table_name  = "saccogroup";
	protected static $table_fields = array("id", "groupName", "description", "dateCreated", "createdBy", "dateModified", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	//select the list of groups for display on the form select
	public function findSelectList(){
		$fields = "`id`, `groupName` `clientNames`, 2 as `clientType`";
		$result_array = $this->getfarray(self::$table_name, $fields, "", "", "");
		return $result_array;
	}
	
	
	public function addSaccoGroup($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		return $result;
	}
	
	public function updateSaccoGroup($data){
		
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
	public function deleteSaccoGroup($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>