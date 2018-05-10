<?php 
require_once("lib/Libraries.php");
$shares = new Shares();
$subscription = new Subscription();
$person = new Person();
$data = array();
if(isset($_GET['id'])){
	$pid = $_GET['id']; //person id
	$data['relatives'] = $person->findPersonRelatives($pid);
	$data['employers'] = $person->findPersonEmploymentHistory($pid);
	$data['subscriptions'] = $subscription->findMemberSubscriptions($pid);	
	//$data['shares'] = $shares->findMemberShares($pid);
}
echo json_encode($data);