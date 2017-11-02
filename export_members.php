<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Import CSV</title>
</head>

<body>
<?php 
require_once("lib/Member.php");
require_once("lib/Person.php");
require_once("lib/Subscription.php");
require_once("lib/Subscription.php");
require_once("lib/Shares.php");
$member = new Member();
$person = new Person();
$shares = new Shares();
$subscribe = new Subscription();

if(isset($_POST['submit'])){
	set_time_limit(892801);
     $filename=$_POST['filename'];

     $handle = fopen("$filename", "r");
     while (($data = fgetcsv($handle, 90048576, ",")) !== FALSE){
		 
		$data = $member->sanitizeAttributes($data);
		if($data[1] != ""){
			if (preg_match('/[\'^£$%&*()}{@#~?><>,|=_+¬-]/', $data[2])){
				continue;
			}else{
				if(($data[3] != "" || $data[4] != "") && $data[1] != "" ){
					$exp_date = explode("/",  $data[1]);
					$date_d = $exp_date[2]."-".$exp_date[1]."-".$exp_date[0];
					$add['date_registered'] = $date_d; //date("Y-m-d", strtotime($data[1]));
					$add['dateAdded'] =  strtotime($date_d);
					$add['addedBy'] = 1;
					$add['modifiedBy'] =  1;
					$name = explode(" ",  $data[2]);
					$add['firstname'] = $name[1];
					$add['lastname'] = $name[0];				
					if(count($name) >  2){
						$add['othername'] = $name[2]; 
					}
					
					$add['photograph'] = "";
					$add['branch_id'] = 1;
					$add['branchId'] = 1;
					$add['active']=1;
					$add['person_type']=1;
					if($data[4] !=""){
						$add['memberType']=1;
					}
					
					$add['comment']="This data was exported from an excel";
					$person_id = $person->addPerson($add);
					if($person_id){
						$add['personId'] = $person_id;
						$person->updatePersonNumber($person_id);
						$add["personId"] = $person_id;
						$member_id = $member->addMember($add);
						$add['memberId'] = $member_id;
						if($data[3] != ""){
							$add['amount'] = $data[3];
							
							$add['receipt_no'] = $data[0];
							$add['subscriptionYear'] = $exp_date[2];
							$add['datePaid'] = $date_d;
							$subscribe->addSubscription($add);
						}
						if(!empty($data[4])){
							$add['noShares'] = $data[5];
							$add['amount'] = $data[4];
							$add['recordedBy'] = 1;
							$add['paid_by'] = 1;
							$shares->addShares($add);
						}
						
					} 
				}		 
			}	
			//echo "mma". $a++;
		}   
		
	}
	/* $import= "INSERT into  members(InvoiceID, InvoiceType, CustID, dtInvoice, OrigDocID, dtDue, cySaleOnly) values('$data[0]','$data[1]','$data[2]','$data[3]','$data[4]','$data[5]','$data[6]')";		
       mysql_query($import) or die(mysql_error());
     }
     fclose($handle); */
     print "Import done";
}else{
	print "<form action='' method='post'>";

	print "Type file name to import:<br>";

	print "<input type='text' name='filename' size='20'><br>";

	print "<input type='submit' name='submit' value='submit'></form>";
	}
   
   ?>
</body>
</html>