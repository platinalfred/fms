<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Locations extends Db {
	protected static $tbl_country  = "country";
	protected static $tbl_district  = "districts";
	protected static $tbl_county  = "counties";
	protected static $tbl_subcounty  = "subcounty";
	protected static $tbl_parish  = "parish";
	protected static $tbl_village  = "village";
	
	public function findCountry($id){
		$result = $this->getfrec(self::$tbl_country, "name","id=".$id, "", "");
		return !empty($result) ? $result['name']:false;
	}
	public function findDistrict($id){
		$result = $this->getfrec(self::$tbl_district,"name", "id=".$id, "", "");
		return !empty($result) ? $result['name']:false;
	}
	public function findCounty($id){
		$result = $this->getfrec(self::$tbl_county,"name", "id=".$id, "", "");
		return !empty($result) ? $result['name']:false;
	}
	public function findSubcounty($id){
		$result = $this->getfrec(self::$tbl_subcounty, "name", "id=".$id, "", "");
		return !empty($result) ? $result['name']:false;
	}
	public function findParish($id){
		$result = $this->getfrec(self::$tbl_parish,"name", "id=".$id, "", "");
		return !empty($result) ? $result['name']:false;
	}
	public function findVillage($id){
		$result = $this->getfrec(self::$tbl_village,"name","id=".$id, "", "");
		return !empty($result) ? $result['name']:false;
	}
	
	public function addCountry($data){
		$fields = array("name");
		return $this->add(self::$tbl_country, $fields, $this->generateAddFields($fields, $data));
			
	}
	public function addDistrict($data){
		$fields = array("name", "country_id");
		return $this->add(self::$tbl_country, $fields, $this->generateAddFields($fields, $data));
			
	}
	public function addCounty($data){
		$fields = array("name", "district_id");
		return $this->add(self::$tbl_country, $fields, $this->generateAddFields($fields, $data));
			
	}
	public function addSubCounty($data){
		$fields = array("name", "count_id");
		return $this->add(self::$tbl_country, $fields, $this->generateAddFields($fields, $data));
			
	}
	public function addParish($data){
		$fields = array("name", "parish_id");
		return $this->add(self::$tbl_country, $fields, $this->generateAddFields($fields, $data));
			
	}
	public function addVillage($data){
		$fields = array("name", "village_id");
		return $this->add(self::$tbl_country, $fields, $this->generateAddFields($fields, $data));
			
	}
	
}
?>