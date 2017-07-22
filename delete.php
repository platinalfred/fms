<?php
require_once("lib/Db.php");
$db = new Db();
print_r($_GET);
if(isset($_GET['tbl'])){
	$msg = "Item could not be deleted.Please try again";
	switch($_GET['tbl']){
		case "staff":
			require_once("lib/Staff.php");
			$staff = new Staff();
			if($staff->deleteStaff($_GET['id'])){
				$msg =  "Successfully deleted this staff from the system.";
			}
		break;
		case "member":
			require_once("lib/Member.php");
			$member = new Member();
			if($member->deleteMember($_GET['id'])){
				echo "Successfully deleted this member from the system";
			}
		break;
		case "account_type":
			if($db->turnOff("accounttype", "id=".$_GET['id'])){
				$msg =  "successfully deleted the account type";
			}
		break;
		case "marital_status":
			if($db->turnOff("marital_status", "id=".$_GET['id'])){
				$msg =  "successfully deleted the marital status";
			}
		break;
		case "expensetypes":
			if($db->turnOff("expensetypes", "id=".$_GET['id'])){
				echo "success";
			}
		break;
		case "securitytypes":
			if($db->turnOff("securitytype", "id=".$_GET['id'])){
				echo "success";
			}
		break;
		case "branch":
			if($db->turnOff("branch", "id=".$_GET['id'])){
				echo "success";
			}
		break;
		case "income_sources":
			if($db->turnOff("income_sources", "id=".$_GET['id'])){
				echo "success";
			}
		break;
		case "loan_types":
			if($db->turnOff("loan_type", "id=".$_GET['id'])){
				echo "success";
			}
		break;
		case "access_level":
			if($db->turnOff("accesslevel", "id=".$_GET['id'])){
				echo "success";
			}
		break;
		case "penalty_calculation_method":
		break;
		case "loan_products_penalty":
		break;
		case "repaymentduration":
		break;
		case "position":
		break;
		case "id_card_types":
		break;
		case "loan_product_types":
		break;
		case "relationship_type":
		break;
		case "person_type":
			
		break;
		/*case "":
		break;
		case "":
		break;
		case "":
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