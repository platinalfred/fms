<?php
require_once("lib/Db.php");
$db = new Db();

if(isset($_GET['tbl'])){
	$msg = "Could not delete item";
	switch($_GET['tbl']){
		case "staff":
			require_once("lib/Staff.php");
			$staff = new Staff();
			if(isset($_GET['status']) && $_GET['status'] == "activate"){
				if($staff->activateStaff($_GET['id'])){
					$msg =  "Successfully activated staff.";
				}
			}else{
				if($staff->deleteStaff($_GET['id'])){
					$msg =  "Successfully deleted staff from the system.";
				}
			}
		break;
		case "member":
			require_once("lib/Member.php");
			$member = new Member();
			if($member->deleteMember($_GET['id'])){
				$msg =  "Success";
			}
		break;
		case "account_type":
			if($db->turnOff("accounttype", "id=".$_GET['id'])){
				$msg =  "Successfully deleted the account type";
			}
		break;
		case "marital_status":
			if($db->turnOff("marital_status", "id=".$_GET['id'])){
				$msg =  "Successfully deleted";
			}
		break;
		case "expense_types":
			if($db->turnOff("expensetypes", "id=".$_GET['id'])){
				$msg =  "Success";
			}
		break;
		case "securitytypes":
			if($db->turnOff("securitytype", "id=".$_GET['id'])){
				$msg =  "Success";
			}
		break;
		case "branch":
			if($db->turnOff("branch", "id=".$_GET['id'])){
				$msg =  "Success";
			}
		break;
		case "income_sources":
			if($db->turnOff("income_sources", "id=".$_GET['id'])){
				 $msg = "Success";
			}
		break;
		case "loan_types":
			if($db->turnOff("loan_type", "id=".$_GET['id'])){
				$msg = "Success";
			}
		break;
		case "access_level":
			if($db->turnOff("accesslevel", "id=".$_GET['id'])){
				$msg =  "Success";
			}
		break;
		case "saccogroup":
			if($db->turnOff("saccogroup", "id=".$_GET['id'])){
				$msg = "Success";
			}
		break;
		case "individual_types":
			if($db->turnOff("individual_type", "id=".$_GET['id'])){
				$msg = "Success";
			}
		break;
		case "expense":
			if($db->turnOff("expense", "id=".$_GET['id'])){
				$msg = "Success";
			}
		break;
		case "repaymentduration":
		break;
		case "position":
			if($db->turnOff("position", "id=".$_GET['id'])){
				$msg = "Success";
			}
		break;
		case "id_card_types":
			if($db->turnOff("id_card_types", "id=".$_GET['id'])){
				$msg = "Success";
			}
		break;
		case "loan_product_types":
			
		break;
		case "relationship_type":
			if($db->turnOff("relationship_type", "id=".$_GET['id'])){
				$msg = "success";
			}
		break;
		case "person_type":
			if($db->turnOff("persontype", "id=".$_GET['id'])){
				$msg = "success";
			}
		break;
		case "security_types":
			if($db->turnOff("securitytype", "id=".$_GET['id'])){
				$msg = "success";
			}
		break;
		
		/*case "":
		break; */
		default:
			$msg =  "No data submited!";
		break;
	}
	echo $msg;
}else{
	echo "No data was submitted.please try again!";
}

?>