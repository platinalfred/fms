<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class AddressType extends Db {
	protected static $table_name  = "address_type";
	protected static $db_fields = array("id", "address_type", "description");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "", "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findIdAdressType($id){
		$result = $this->getfrec(self::$table_name, "address_type", "id=".$id, "", "");
		return !empty($result) ? $result['address_type'] : false;
	}
	public function addIdAdressType($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateIdAdressType($data){
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