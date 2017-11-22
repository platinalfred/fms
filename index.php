<?php
session_start();
require_once("lib/Db.php");
$db = new Db();
$msg = "";
if(isset($_POST['logon'])){
	if($db->getLogin($_POST['username'], $_POST['password'])){ 
		if(isset($_SESSION['loans_officer'])){
			?>
			<script>
				window.location.href = "view_loans.php";
			</script>
			<?php
		}else{?>
			<script>
				window.location.href = "dashboard.php";
			</script>
			<?php
		}
	}else{
		$msg =  "Incorrect Username/Password."; 
	}
	
}
?>
<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Buladde Financial Services</title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
	<style>
	.ibox-content{
		border-top: 3px solid #A6CE39!important;
		background-color: #fff;
		border-right-color: #dfe8f1!important;
		border-bottom-color: #dfe8f1!important;
		border-left-color: #dfe8f1!important;
		border-radius: 3px;
		border-width: 1px;
		border-style: solid;
	}
	</style>
	
</head>

<body class="gray-bg">
    <div class="loginColumns animated fadeInDown">
        <div class="row">

            <div class="col-md-6">
                <h1 class="font-bold">Welcome to Buladde Financial Services</h1>
			
				<h2 class="medium-title">Introducing a Financial management System (FMS) Smartly designed — a simpler way to manage members and financial services .</h2>
				
            </div>
            <div class="col-md-6">
                <div class="ibox-content" style="">
					<div class="col-md-12 center_col"><img style="width:95%;" src="img/logo.png"></div>
					<h1 style="text-align:center;"><i class="fa fa-unlock-alt"></i>&nbsp;&nbsp;&nbsp; Login </h1>
                    <form class="m-t" role="form" id="login_form" method="post" action="">
						<?php
						
						if($msg != ""){ ?>
							<div class="alert alert-danger alert-dismissable">
                                <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                <?php echo $msg; ?>.
                            </div>
							<?php
						}
						?>
						<input type="hidden" name="logon" >
                        <div class="form-group">
                            <input type="text" name="username" class="form-control" placeholder="Username">
                        </div>
                        <div class="form-group">
                            <input type="password" name="password" class="form-control" placeholder="Password" >
                        </div>
                        <button type="submit" class="btn btn-primary block full-width m-b">Login</button>
						
                        <a href="#">
                            <small>&nbsp;</small>
                        </a>

                        <p class="text-muted text-center">
                            <small></small>
                        </p>
                        
                    </form>
                    <p class="m-t" style="text-align:right;">
                        <small>BFS  &copy; <?php echo date("Y"); ?> All rights reserved</small><!-- developed by <a href="www.connectsoftz.com" target="_blank"><img style="width:25%;" src="http://www.connectsoftz.com/images/logo.png"></a></small>-->
                    </p>
                </div>
            </div>
        </div>
        <hr/>
		
        <div class="row">
            <div class="col-md-6">
                Copyright Buladde Financial Services
            </div>
            <div class="col-md-6 text-right">
               <small>© 2017 <?php if(date("Y") != 2017 ){ echo "- ".date("Y"); } ?></small>
            </div>
        </div>
    </div>

</body>	
<script src="js/jquery-2.1.1.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/jquery.validate.min.js" type="text/javascript"></script> 
	<script>
	$("document").ready(function() {
		// Initialize form validation on the registration form.
		// It has the name attribute "registration"
		$("#login_form").validate({
			
			// Specify validation rules
			rules: {
			  // The key name on the left side is the name attribute
			  // of an input field. Validation rules are defined
			  // on the right side
			  username: "required",
			  password: "required",
			},
			// Specify validation error messages
			messages: {
			  username: "Please enter your user name ",
			  password: "Please enter your password",
			},
			// Make sure the form is submitted to the destination defined
			// in the "action" attribute of the form when valid
			submitHandler: function(form) {
				form.submit();
			}
		});
	});
	</script>
</html>
