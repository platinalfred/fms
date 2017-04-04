<?php
class Db{
	public $server;
	public $user;
	public $password;
	public $database;
	public $sessions = array();

	//Properties for Database Transactions
	public $foreignKeys;
	public $fields;
	public $table;
	public $primaryKey;
	public $connectedToKey;
	var $conn;

	public function __construct(){
	   $this->server = "localhost";
	   $this->user = "root";
	   $this->password = "";
	   $this->database = "loans";
	   //Connects to the database;
	   $this->connectDB();
	   
	}
	function connectDB(){
		$this->conn = new mysqli($this->server, $this->user, $this->password, $this->database);
		if ($this->conn->connect_errno) {
			echo "Error connection: %s\n".$this->conn->connect_error;
			exit();
		}
	}
	//returns a count of records according to the custom query passed to the function
	function countCustom($query){
		$res  = $this->conn->query($query);
		if($res){
			$q = $res->fetch_array();
			$cnt = $q{'cnt'};
			$res->close();
			return $cnt;
		}
	}
	function count($table, $where) {
		if ($where != "") 	$sel = "SELECT COUNT(*) AS cnt FROM ".$table." WHERE ".$where;
		else $sel = "SELECT COUNT(*) AS cnt FROM ".$table;
		$res  = $this->conn->query($sel);
		$q = $res->fetch_array();	
		$cnt = $q{'cnt'};
		$res->close();
		return $cnt;
	}
	//Query used by datatables to populate the table data
	//returns a count of records according to the custom query passed to the function
	function prepareStatement($query){
		$statement = $this->conn->prepare($query);
		if($statement === false) {
			trigger_error('Wrong SQL: ' . $query . ' Error: ' . $this->conn->errno . ' ' . $this->conn->error, E_USER_ERROR);
		}
		return $statement;
	}
	function bindParam($preparedStatement, $a_params){
		/* $preparedStatement->bind_param($data_type, $a_params);
		
		/* The problem

		$preparedStatement->bind_param() does not accept params array. So, how to bind params, if their number is variable, depending on user input in your application?

		A workaround is to use call_user_func_array to pass dynamically the params array.*/
		call_user_func_array(array($preparedStatement, 'bind_param'), $a_params);
	}
	function fetchResult($preparedStatement){
		$preparedStatement->execute();
		
		return $preparedStatement->get_result(); /* $statement->fetch_array(MYSQLI_ASSOC);*/
	}
	//returns a count of records according to the custom query passed to the function
	function getFilteredTotal(){
		return $this->conn->query('SELECT FOUND_ROWS()')->fetch_array();
	}
	function destroySessions(){
		if(!isset($_SESSION)) {
		  session_start();
		}
		foreach($this->sessions as $to_unset => $value){
			   unset($_SESSION[$to_unset]);
		}
		session_destroy();
		Redirect("index.php");
	}
	function setSessions($name, $value){
		if(!isset($_SESSION)) {
		 session_start();
		}
		return $_SESSION[$name] = $value;
	}
	function  getLogin($username, $password){
		if(!isset($_SESSION)) {
			session_start();
		}
		$to_add = array("id","username","access_level", "branch_number", "person_number");
		$password = md5($password);
		$results = $this->getfrec("staff", "id, username, access_level, branch_number, person_number", "username='$username' AND password='$password'", "", "");
		if(count($results) > 0){
		   $_SESSION['Logged'] = true;
		   foreach($results as $key => $value){
				if(!is_numeric($key)){
				   if(in_array($key, $to_add)){
					   $_SESSION[$key] =  $value;
				   }
			  }
		   }
		  $this->setSessions("user_id", $results['id']);
		}



		return $_SESSION;
	}
	function generateAddFields($fields = array(), $data = array()){
        $array = array();
        if((count($fields) <= 0) || (count($data) <= 0)) {
            return false;
        } else{
            foreach($fields as $field){
				if(array_key_exists($field, $data)){
					  $array[$field] = $data[$field];
				}else{
					$array[$field] = "";
				}
              
            }
            return $array;
        }
    }
	
	function formatDate($date) {
		$mydate = explode('-', $date);
		$mymonth = "";
		$myday="";
		$myyear="";
		if (strlen($mydate[0]) == 1 ){
			$myday="0".$mydate[0];
		} else {
			$myday=$mydate[0];
		}
		if (strlen($mydate[1]) == 1 ){
			$mymonth="0".$mydate[1];
		} else{
			$mymonth = $mydate[1];
		}
		$myyear=$mydate[2];
		return ($myyear."-".$mymonth."-".$myday);
	}
	function formatSlashedDate($date) {
		$mydate = explode('/', $date);
		$mymonth = "";
		$myday="";
		$myyear="";
		if (strlen($mydate[0]) == 1 ){
			$myday="0".$mydate[0];
		} else {
			$myday=$mydate[0];
		}
		if (strlen($mydate[1]) == 1 ){
			$mymonth="0".$mydate[1];
		} else{
			$mymonth = $mydate[1];
		}
		$myyear=$mydate[2];
		return ($myyear."-".$mymonth."-".$myday);
	}
	function Password($password_length = 9){
        srand(make_seed());

        $alfa = "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        $token = "";
        for($i = 0; $i < $password_length; $i ++) {
          $token .= $alfa[rand(0, strlen($alfa))];
        }
        return md5($token);
    }
	function loadList($query, $name, $value_field,$display_field,$field_id="", $add_link = "", $roles = array(1, 2, 3, 4), $select = "single"){
       //  $result = mysql_query($query) or die(mysql_error());
		$results = $this->queryData($query);
		
		if($results){
			$count = count($results);
			if($count > 0){
                 ?>
				<select class="select2_single form-control" id="<?php echo $field_id; ?>"  name="<?php echo $name; ?>" name="country" tabindex="-1" select="<?php ($select == 'single')? 'single': $select;?>">
					<?php
					foreach($results as $result){ 
						?>
                        <option <?php if($result[$display_field] == "Uganda"){ ?> selected="selected" <?php } ?> value="<?php echo $result[$value_field]; ?>"><?php echo $result[$display_field]; ?></option>
						<?php
					}
					?>
                 </select>
                 <?php
             }else{
                echo "No Data found!";
                if(in_array(@$_SESSION['access_level'], $roles)){
                    ?>
                        <a href="<?php echo $add_link; ?>" >Add New</a>
                     <?php
                }else{
                    ?>
					<a href="#" >Request Administrator to Add</a>
					<?php
				}
             }
         }else{
			 echo "No ".$name." found!";
		 }
    }
	
	function numberToWords($number) {
		$hyphen      = '-';
		$conjunction = ' and ';
		$separator   = ', ';
		$negative    = 'negative ';
		$decimal     = ' point ';
		$dictionary  = array(
			0                   => 'zero',
			1                   => 'one',
			2                   => 'two',
			3                   => 'three',
			4                   => 'four',
			5                   => 'five',
			6                   => 'six',
			7                   => 'seven',
			8                   => 'eight',
			9                   => 'nine',
			10                  => 'ten',
			11                  => 'eleven',
			12                  => 'twelve',
			13                  => 'thirteen',
			14                  => 'fourteen',
			15                  => 'fifteen',
			16                  => 'sixteen',
			17                  => 'seventeen',
			18                  => 'eighteen',
			19                  => 'nineteen',
			20                  => 'twenty',
			30                  => 'thirty',
			40                  => 'fourty',
			50                  => 'fifty',
			60                  => 'sixty',
			70                  => 'seventy',
			80                  => 'eighty',
			90                  => 'ninety',
			100                 => 'hundred',
			1000                => 'thousand',
			1000000             => 'million',
			1000000000          => 'billion',
			1000000000000       => 'trillion',
			1000000000000000    => 'quadrillion',
			1000000000000000000 => 'quintillion'
		);
		if (!is_numeric($number)) {
			return false;
		}

		if (($number >= 0 && (int) $number < 0) || (int) $number < 0 - PHP_INT_MAX) {
			// overflow
			trigger_error(
				'Out of Range Numbers: This function only accepts numbers between - ' . PHP_INT_MAX . ' and ' . PHP_INT_MAX,
				E_USER_WARNING
			);
			return false;
		}

		if ($number < 0) {
			return $negative . self::numberToWords(abs($number));
		}

		$string = $fraction = null;

		if (strpos($number, '.') !== false) {
			list($number, $fraction) = explode('.', $number);
		}

		switch (true) {
			case $number < 21:
				$string = $dictionary[$number];
				break;
			case $number < 100:
				$tens   = ((int) ($number / 10)) * 10;
				$units  = $number % 10;
				$string = $dictionary[$tens];
				if ($units) {
					$string .= $hyphen . $dictionary[$units];
				}
				break;
			case $number < 1000:
				$hundreds  = $number / 100;
				$remainder = $number % 100;
				$string = $dictionary[$hundreds] . ' ' . $dictionary[100];
				if ($remainder) {
					$string .= $conjunction . self::numberToWords($remainder);
				}
				break;
			default:
				$baseUnit = pow(1000, floor(log($number, 1000)));
				$numBaseUnits = (int) ($number / $baseUnit);
				$remainder = $number % $baseUnit;
				$string = self::numberToWords($numBaseUnits) . ' ' . $dictionary[$baseUnit];
				if ($remainder) {
					$string .= $remainder < 100 ? $conjunction : $separator;
					$string .= self::numberToWords($remainder);
				}
				break;
		}

		if (null !== $fraction && is_numeric($fraction)) {
			$string .= $decimal;
			$words = array();
			foreach (str_split((string) $fraction) as $number) {
				$words[] = $dictionary[$number];
			}
			$string .= implode(' ', $words);
		}

		return $string;
	}
	function Username($firstname, $lastname, $othernames = ""){
		$first_letter = substr($firstname , 0, (1 - strlen($firstname)));
		$second_letter = ($othernames != "") ? substr($othernames , 0, (1 - strlen($othernames))) : "";

		$username = ($second_letter != "")? $second_letter.".".$first_letter.$lastname : $first_letter.$lastname;

		return strtolower($username);
	}
	function getAge($date) { // Y-m-d format
		return intval(substr(date('Ymd') - date('Ymd', strtotime($date)), 0, -4));
	}

	function formatShillings($amount){
		return number_format($amount, 2,".",",");
	}

	//Functions Used to Compute
	function Balance($expected, $payment){
		return ($expected - $payment);
	}

	function Expected($interest, $balance){
		return ($balance + (($interest/100)*$balance));
	}
	function Interest($amount, $rate){
		return (($rate/100)*$amount);
	}
	
	
	function getDateDiff($start_date, $end_date, $return = "days"){
		$start_date = strtotime($start_date);
		$end_date = strtotime($end_date);

		//Set all Dates Before Todays to Today's date
		if($start_date > $end_date){
			$start_date = $end_date;
		}
		$diff = abs($start_date - $end_date );
		$years = floor($diff / (365*60*60*24));
		$months = floor(($diff - $years * 365*60*60*24) / (30*60*60*24));
		$days = floor(($diff - $years * 365*60*60*24 - $months*30*60*60*24)/ (60*60*24));
		if($return == "days"){
			$return = $days;
		}else if($return == "years"){
			$return = $years;
		} else{
			$return = $months;
		}
		return $return;
		//printf("%d years, %d months, %d days\n", $years, $months, $days);
	}
	
	
	
	function setStatus($expected, $principle){
		if($expected > 0){
		   $status = "We Owe Client UGX. ".formatShillings($expected);
	   }else if(($expected < 0) && ($principle != 0)){
			$status = "Active Loan";
	   }else if(($expected == 0) && ($principle == 0)){
		   $status = "No Loan Obtained";
	   }else if($expected == 0){
			$status = "Cleared Loan";
		}
		return $status;
	}
	
	function getFieldRecord($table, $field, $where, $ordby) {
        if ($where != "")     $sel = "SELECT ".$field." FROM ".$table." WHERE ".$where;
        else $sel = "SELECT ".$field." FROM ".$table;
        if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
        $sele = mysql_query($sel);
        $res = mysql_fetch_array($sele);
        mysql_free_result($sele);
        return $res;
    }
	function countRecords($table, $where) {
		if ($where != "") 	$sel = "SELECT COUNT(*) AS cnt FROM ".$table." WHERE ".$where;
		else $sel = "SELECT COUNT(*) AS cnt FROM ".$table;
		$res = $this->conn->query($sel);	
		if($res){
			$q = $res->fetch_array();
			$cnt = $q{'cnt'};
			$res->close();
			return $cnt;
		}
		return false;
	}
	public function sanitizeAttributes($unescaped_values) {
		$clean_attributes = array();
		// sanitize the values before submitting
		// Note: does not alter the actual value of each attribute
		foreach($unescaped_values as $key => $value){
			$clean_attributes[$key] = $this->escape_value($value);
		}
	  return $clean_attributes;
	}
	public function escape_value( $value ) {
		 // PHP v4.3.0 or higher
			// undo any magic quote effects so mysqli_real_escape_string can do the work
		 $value = stripslashes( $value ); 
		$value = mysqli_real_escape_string($this->conn, $value);
		
		//echo $value;
		return $value;
	}
	function add($table, $fields, $values){
		$values = $this->sanitizeAttributes($values);
		$fi = implode(",", $fields);
		$va = "";
		for ($i = 0; $i < count($fields); $i++) {
			if (substr($values{$fields[$i]}, 0, 1) == "!") $va = $va.substr($values{$fields[$i]}, 1, strlen($values{$fields[$i]}) - 1);
			else $va = $va."'".$values{$fields[$i]}."'";
			if ($i < (count($fields) - 1)) $va = $va.",";
		}
		$ins = "INSERT INTO ".$table. " (".$fi.") VALUES (".$va.")";
		//echo $ins;
		$inse = $this->conn->query($ins);
		if($inse){
			return mysqli_insert_id($this->conn);
		}
		return false;
	}
	function addMultiple($table, $fields, $values){
		$fi = implode(",", $fields);
		
		$ins = "INSERT INTO ".$table. " (".$fi.") VALUES ".implode(',', $values);
		//echo $ins;
		$inse = $this->conn->query($ins);
		if($inse){
			return true;
		}
		return false;
	}
	function numberFormat($no){  
		$format_number = number_format($no, 2, '.', ',');
		return $format_number;
	}
	function update_single($table, $field, $value, $where) {
		$value = $this->escape_value($value);
		$upd = "UPDATE ".$table. " SET ".$field." = '".$value."' WHERE ".$where;
		return $this->conn->query($upd);
	}
	function update($table, $fields, $values, $where){
		$va = "";
		$values = $this->sanitizeAttributes($values);
		for ($i = 0; $i < count($fields); $i++) {
			if (substr($values{$fields[$i]}, 0, 1) == "!") $va = $va.$fields[$i]." = ".substr($values{$fields[$i]}, 1, strlen($values{$fields[$i]}) - 1);
			else $va = $va.$fields[$i]." = '".$values{$fields[$i]}."'";
			if ($i < (count($fields) - 1)) $va = $va.",";
		}
		$upd = "UPDATE ".$table. " SET ".$va." WHERE ".$where;
		
		if($this->conn->query($upd)){
			return true;
		}else {
			return false;
		}
		
	}
	function getrec($table, $where, $ordby, $limit) {
		if ($where != "") 	$sel = "SELECT * FROM ".$table." WHERE ".$where;
		else $sel = "SELECT * FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		
		$q = $this->conn->query($sel);
		if($q){
			$res = $q->fetch_array();
			$q->close();
			return $res;
		}
		return false;
	}
	function getfrec($table, $field, $where, $ordby, $limit) {
		if ($where != "") 	$sel = "SELECT ".$field." FROM ".$table." WHERE ".$where;
		else $sel = "SELECT ".$field." FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;	
		//echo $sel;
		$q = $this->conn->query($sel);
		if($q){
			$res = $q->fetch_array();
			$q->close();
			return $res;
		}else{
			return false;
		}
		
	}//end getfrec
	
	function getfrecgrouped($table, $field, $where, $groupby, $limit) {
		if ($where != "") 	$sel = "SELECT ".$field." FROM ".$table." WHERE ".$where;
		else $sel = "SELECT ".$field." FROM ".$table;
		if ($groupby != "") $sel = $sel." GROUP BY ".$groupby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		//echo $sel;
		$q = $this->conn->query($sel);
		if($q){
			$res = $q->fetch_array();
			$q->close();
			return $res;
		}
		return false;
	}//end getfrec
	function getmax($table, $field, $where, $ordby, $limit) {
		if ($where != "") 	$sel = "SELECT max(".$field.") FROM ".$table." WHERE ".$where;
		else $sel = "SELECT max(".$field.") FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		$q = $this->conn->query($sel);
		if($q){
			$res = $q->fetch_array();
			$q->close();
			return $res['max('.$field.')'];
		}
		return false;
	  
	}//end getmax
	function getmin($table, $field, $where, $ordby, $limit) {
		if ($where != "") 	$sel = "SELECT min(".$field.") FROM ".$table." WHERE ".$where;
		else $sel = "SELECT min(".$field.") FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		$q = $this->conn->query($sel);
		if($q){
			$res = $q->fetch_array();
			$q->close();
			return $res['min('.$field.')'];
		}
		return false;
	  
	}//end getmax
	function getarray($table, $where, $ordby, $limit) {
		$res = array();
		$i = 0;
		if ($where != "") 	$sel = "SELECT * FROM ".$table." WHERE ".$where;
		else $sel = "SELECT * FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		
		$q = $this->conn->query($sel);
		if($q){
			$res = $this->buildOut($q);
			$q->close();
			return $res;
		}
		return false;
	}
	function getfarray($table, $se, $where, $ordby, $limit) {
		if ($where != "") 	$sel = "SELECT ".$se." FROM ".$table." WHERE ".$where;
		else $sel = "SELECT ".$se." FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		//echo $sel;
		$q = $this->conn->query($sel);
		if($q){
			$res = $this->buildOut($q);
			$q->close();
			return $res;
		}
	}
	function getarrayunique($table, $where, $ordby, $limit) {
		$out = array();
		$i = 0;
		if ($where != "") 	$sel = "SELECT *  FROM ".$table." WHERE ".$where;
		else $sel = "SELECT DISTINCT FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		$q = $this->conn->query($sel);
		if($q){
			$res = $this->buildOut($q);
			$q->close();
			return $res;
		}
		return false;
	}
	function getfarrayunique($table, $field, $where, $ordby, $limit){
		$out = array();
		$i = 0;
		if ($where != "") 	$sel = "SELECT DISTINCT ". $field . " FROM ".$table." WHERE ".$where;
		else $sel = "SELECT  DISTINCT ". $field . " FROM ".$table;
		if ($ordby != "") $sel = $sel." ORDER BY ".$ordby;
		if ($limit != "") $sel = $sel." LIMIT ".$limit;
		
		$q = $this->conn->query($sel);
		if($q){
			$res = $this->buildOut($q);
			ini_set("memory_limit","500M");
			$q->close();
			return $res;
		}
		return false;
	}
	function queryData($query){
		$q = $this->conn->query($query);
		if($q){
			$res = $this->buildOut($q);
			$q->close();
			return $res;
		}
		return false;
	}
	function buildOut($res){
		$out = array();
		while ($row = $res->fetch_array()){
			$out[] = $row;
		}
		return $out;
	}
	//GENERAL FUNCTIONS FROM A DECENT DB CLASS
	public function query($sql) {
		$this->last_query = $sql;
		$result = $this->conn->query($sql);
		return $result;
	}
	function del($table, $where) {
		$del = "DELETE FROM ".$table." WHERE ".$where; 
		return $this->conn->query($del);
	}
	// "database-neutral" methods
	public function fetch_array($result_set) {
		return mysqli_fetch_array($result_set);
	}

	public function num_rows($result_set) {
		return mysqli_num_rows($result_set);
	}
	/*Common Functions */
		function combineNames($data){
			return $data['firstname']." ".$data['lastname']." ".$data['othername'];
		}
		function findBranch($bid){
			$result = $this->getfrec("branch", "branch_name", "id=".$bid, "", "");
			return !empty($result) ? $result['branch_name']:false;
		}
		function findBranchByBranchNo($bid){
			$result = $this->getfrec("branch", "branch_name", "branch_number='".$bid."'", "", "");
			return !empty($result) ? $result['branch_name']:false;
		}
		function findGenger($id){
			$result = $this->getfrec("gender", "name", "id=".$id, "", "");
			return !empty($result) ? $result['name']:false;
		}
		function findAge($dob){
			$diff = (date('Y') - date('Y',strtotime($dob)));
			return $diff;
		}
	/**/
}
?>
	