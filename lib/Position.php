<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Position extends Db {
	protected static $table_name  = "position";
	protected static $db_fields = array("id", "name", "access_level", "description");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "active=1", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findPositionDetails(){
		$result_array = $this->getfarray(self::$table_name." p, accesslevel a", "p.id, p.name,p.description, a.name as access_level, a.name as access_level_id", "p.access_level = a.id AND p.active=1 ",  "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findPositionName($id){
		$result = $this->getfrec(self::$table_name, "name", "id=".$id, "", "");
		return !empty($result) ? $result['name'] : false;
	}
	public function addPosition($data){
		$fields =array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updatePosition($data){
		$fields = array_slice(self::$db_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
}
?>