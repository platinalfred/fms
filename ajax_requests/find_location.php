<?php 
require_once("lib/Libraries.php");
$member = new Member();
//Function format is query, field name, field value, field display value, field id value
if(isset($_GET['country'])){
	$member->loadList("SELECT * FROM districts WHERE country_id=".$_GET['country'], "district", "id", "name", "district_select");
}elseif(isset($_GET['district'])){
	$member->loadList("SELECT * FROM counties WHERE district_id=".$_GET['district'], "county", "id", "name", "county_select");
}elseif(isset($_GET['county'])){
	$member->loadList("SELECT * FROM subcounty WHERE county_id=".$_GET['county'], "subcounty", "id", "name", "subcounty_select");
}elseif(isset($_GET['subcounty'])){
	$member->loadList("SELECT * FROM parish WHERE subcounty_id=".$_GET['subcounty'], "parish", "id", "name", "parish_select");
}elseif(isset($_GET['parish'])){
	$member->loadList("SELECT * FROM village WHERE parish_id=".$_GET['parish'], "village", "id", "name", "village_select");
}elseif(isset($_GET['village'])){
	$member->loadList("SELECT * FROM village", "village", "id", "name", "village_select");
}else{
	echo "No data found";
}