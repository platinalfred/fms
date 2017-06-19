<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class SaccoGroup extends Db {
	protected static $table_name  = "saccogroup";
	protected static $table_fields = array("id", "groupName", "description", "dateCreated", "createdBy",  "modifiedBy");
	protected static $group_member_fields = array("id", "groupId", "memberId", "dateCreated", "createdBy",  "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
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
	public function findGroupMembers($id){
		$group_members = "(SELECT `memberId` FROM `group_members` WHERE `groupId` = $id)";
		$member_persons = "(SELECT `personId` FROM `member` WHERE `id` IN ($group_members))";
		$group_members_details = "SELECT CONCAT(`lastname`, ' ', `firstname`, ' ', `othername`) `memberNames` FROM `person` WHERE `id` IN ($member_persons)";
		return $this->queryData($group_members_details);
	}
	
	
	public function addSaccoGroup($data){
		$fields = array_slice(self::$table_fields, 1);
		return $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
	}
	public function addSaccoGroupMembers($data){
		$fields = array_slice(self::$group_member_fields, 1);
		return $this->add("group_members", $fields, $this->generateAddFields($fields, $data));
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