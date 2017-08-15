<?php 
session_start();
require_once("lib/Libraries.php"); 
$person = new Person();
if(!isset($_SESSION['Logged'])){
	header("Location:logout.php");
}
?>
<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<link rel="apple-touch-icon" sizes="57x57" href="img/fav.png">
	<link rel="icon" type="image/png" sizes="16x16" href="img/fav.png">
    <title>BFS <?php echo isset($page_title)?(" - ".$page_title): "";?></title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.css" rel="stylesheet">
	<link rel="stylesheet" href="css/jquery-confirm.min.css">
    <link href="css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
    <!-- Toastr style -->
    <link href="css/plugins/toastr/toastr.min.css" rel="stylesheet">

    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
	 <link href="css/general.css" rel="stylesheet">
		<?php
	if(in_array("dataTables", $needed_files)){
		?>
		<link href="css/plugins/dataTables/datatables.min.css" rel="stylesheet">
		<!--<link href="css/plugins/dataTables/jquery.dataTables.css" rel="stylesheet">-->
		<link href="css/plugins/dataTables/buttons.dataTables.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("iCheck", $needed_files)){ ?>
		<link href="css/plugins/iCheck/custom.css" rel="stylesheet">
		<?php 
	}
	if(in_array("daterangepicker", $needed_files)){ ?>
		<!-- bootstrap-daterangepicker -->
		<link href="css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
	<?php 
	} 
	if(in_array("ladda", $needed_files)){ ?>
	 <!-- Ladda style -->
		<link href="css/plugins/ladda/ladda-themeless.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("Morris", $needed_files)){  ?>
		<!-- Morris -->
		<link href="css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("c3", $needed_files)){ ?>
		<link href="css/plugins/c3/c3.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("chosen", $needed_files)){ ?>
		<link href="css/plugins/chosen/chosen.css" rel="stylesheet">
	<?php 
	}
	if(in_array("colorpicker", $needed_files)){ ?>
    <link href="css/plugins/colorpicker/bootstrap-colorpicker.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("cropper", $needed_files)){ ?>
    <link href="css/plugins/cropper/cropper.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("switchery", $needed_files)){ ?>
		<link href="css/plugins/switchery/switchery.css" rel="stylesheet">
	<?php 
	}
	if(in_array("jasny", $needed_files)){ ?>
		<link href="css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("nouslider", $needed_files)){ ?>
		<link href="css/plugins/nouslider/jquery.nouislider.css" rel="stylesheet">
	<?php 
	}
	if(in_array("datepicker", $needed_files)){ ?>
		<link href="css/plugins/datapicker/datepicker3.css" rel="stylesheet">
	<?php 
	}
	if(in_array("ionRangeSlider", $needed_files)){ ?>
		<link href="css/plugins/ionRangeSlider/ion.rangeSlider.css" rel="stylesheet">
		<link href="css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">
	<?php 
	}
	if(in_array("clockpicker", $needed_files)){ ?>
		<link href="css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
	<?php 
	}
	if(in_array("select2", $needed_files)){ ?>
		<link href="css/plugins/select2/select2.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("touchspin", $needed_files)){ ?>
		<link href="css/plugins/touchspin/jquery.bootstrap-touchspin.min.css" rel="stylesheet">
	<?php 
	}
	if(in_array("steps", $needed_files)){ ?>
		<link href="css/plugins/steps/jquery.steps.css" rel="stylesheet">
	<?php 
	}
	if(in_array("dropzone", $needed_files)){ ?>
		<link href="css/plugins/dropzone/basic.css" rel="stylesheet">
		<link href="css/plugins/dropzone/dropzone.css" rel="stylesheet">
	<?php 
	}
	if(in_array("summernote", $needed_files)){ ?>
		<link href="css/plugins/summernote/summernote.css" rel="stylesheet">
		<link href="css/plugins/summernote/summernote-bs3.css" rel="stylesheet">
	<?php 
	}
	if(in_array("bootstrap-markdown", $needed_files)){ ?>
		<link href="css/plugins/bootstrap-markdown/bootstrap-markdown.min.css" rel="stylesheet">
	<?php 
	}
	?>
	
	 <!-- Sweet Alert -->
    <link href="css/plugins/sweetalert/sweetalert.css" rel="stylesheet">

	<link href="js/plugins/pnotify/dist/pnotify.css" rel="stylesheet">
	<link href="js/plugins/pnotify/dist/pnotify.buttons.css" rel="stylesheet">
	<link href="js/plugins/pnotify/dist/pnotify.nonblock.css" rel="stylesheet">
	
</head>
<body>

    <div id="wrapper">

        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="sidebar-collapse">
                <ul class="nav metismenu" id="side-menu">
                    <li class="nav-header">
                        <div class="dropdown profile-element"> <span><img alt="image" class="img-circle" style="width:48px;" src="img/user.png" /></span>
                            <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear"> <span class="block m-t-xs"> <strong class="font-bold"><?php echo $person->findNamesById($_SESSION['personId']); ?></strong>
                             </span> <span class="text-muted text-xs block"><?php echo $person->findPersonsPosition($_SESSION['personId']); ?><b class="caret"></b></span> </span>
                            </a>
                            <ul class="dropdown-menu animated fadeInRight m-t-xs">
                                <li><a href="">Profile</a></li>
                                <li class="divider"></li>
                                <li><a href="logout.php">Logout</a></li>
                            </ul>
                        </div>
                        <div class="logo-element">
                            BFS+
                        </div>
                    </li>
					<?php 
					if(!isset($_SESSION['loans_officer'])){ ?>
						<li>
							<a href="dashboard.php"><i class="fa fa-th-large"></i> <span class="nav-label">Dashboard</span></a>
						</li>
						
						<li >
							<a href="view_reports.php?view=ledger"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Reports</span><span class="fa arrow-right"></span></a>
						   
						</li>
						<?php 
					}
					?>				
					<li>
						<a href="view_loans.php"><i class="fa fa-calculator"></i> <span class="nav-label">Loans</span>  </a>
					</li>
					<?php 
					if(!isset($_SESSION['executive_board']) && !isset($_SESSION['branch_credit'])&& !isset($_SESSION['management_credit'])){
						
						if(!isset($_SESSION['loans_officer'])){ ?>
							<li>
								<a href="view_savings.php"><i class="fa fa-dollar"></i> <span class="nav-label">Savings Accounts</span>  </a>
							</li>
							<li>
								<a href="miscellanous_income.php"><i class="fa fa-dollar"></i> <span class="nav-label">Other Income</span>  </a>
							</li>
							<li>
								<a href="members.php"><i class="fa fa-group"></i> <span class="nav-label">Members</span>  </a>
							</li>
							<li>
								<a href="groups.php"><i class="fa fa-group"></i> <span class="nav-label">Groups</span>  </a>
							</li>
							<li>
								<a href="expenses.php"><i class="fa fa-flask"></i> <span class="nav-label">Expenses</span></a>
							</li>
							<?php 
						}
					}
					if(isset($_SESSION['admin'])){ ?>
						<div class="menu_section">
							<h3 style="padding-left:11%;">More</h3>
							<ul class="nav side-menu">
								<li>
									<a href="staff.php"><i class="fa fa-group"></i> <span class="nav-label">Manage staff</span>  </a>
								</li>
								<li class="">
									<a href="settings.php"><i class="fa fa-cogs"></i> <span class="nav-label">Settings</span></a>
								</li>
							</ul>
						</div>
					<?php 
					}
					?>
                </ul>

            </div>
        </nav>

        <div id="page-wrapper" class="gray-bg">
            <div class="row border-bottom">
                <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                    <div class="navbar-header" style="width:60%;"> 
                        <a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
                        <form role="search" class="navbar-form-custom" action="" style="width:90%;">
                            <div class="form-group" >
                                <input type="text" placeholder="<?php echo $page_title; ?>" class="form-control" name="top-search" style="font-weight:600;font-size:20px;" id="top-search">
                            </div>
                        </form>
                    </div>
                    <ul class="nav navbar-top-links navbar-right">
						<?php 
						if(in_array("headerdaterangepicker", $needed_files)){ ?>
                        <li>
							<div id="reportrange" style="background: #fff; cursor:pointer; padding: 5px 10px; border: 1px solid #ccc">
							  <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
							  <span>December 30, 2016 - January 28, 2017</span> <b class="caret"></b>
							</div>
                        </li>
						<?php 
						} 
						if(!isset($_SESSION['loans_officer'])){ ?>
                        <!--
						<li class="dropdown">
                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                <i class="fa fa-envelope"></i> <span class="label label-warning">16</span>
                            </a>
                            <ul class="dropdown-menu dropdown-messages">
                                <li>
                                    <div class="dropdown-messages-box">
                                        
                                        <div class="media-body">
                                            <small class="pull-right">46h ago</small>
                                            <strong>Mike Loreipsum</strong> started following <strong>Monica Smith</strong>.
                                            <br>
                                            <small class="text-muted">3 days ago at 7:58 pm - 10.06.2014</small>
                                        </div>
                                    </div>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <div class="dropdown-messages-box">
                                        
                                        <div class="media-body ">
                                            <small class="pull-right text-navy">5h ago</small>
                                            <strong>Chris Johnatan Overtunk</strong> started following <strong>Monica Smith</strong>.
                                            <br>
                                            <small class="text-muted">Yesterday 1:21 pm - 11.06.2014</small>
                                        </div>
                                    </div>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <div class="dropdown-messages-box">
                                        
                                        <div class="media-body ">
                                            <small class="pull-right">23h ago</small>
                                            <strong>Monica Smith</strong> love <strong>Kim Smith</strong>.
                                            <br>
                                            <small class="text-muted">2 days ago at 2:30 am - 11.06.2014</small>
                                        </div>
                                    </div>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <div class="text-center link-block">
                                        <a href="mailbox.html">
                                            <i class="fa fa-envelope"></i> <strong>Read All Messages</strong>
                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                <i class="fa fa-bell"></i> <span class="label label-primary">8</span>
                            </a>
                            <ul class="dropdown-menu dropdown-alerts">
                                <li>
                                    <a href="mailbox.html">
                                        <div>
                                            <i class="fa fa-envelope fa-fw"></i> You have 16 messages
                                            <span class="pull-right text-muted small">4 minutes ago</span>
                                        </div>
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <a href="profile.html">
                                        <div>
                                            <i class="fa fa-twitter fa-fw"></i> 3 New Followers
                                            <span class="pull-right text-muted small">12 minutes ago</span>
                                        </div>
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <a href="grid_options.html">
                                        <div>
                                            <i class="fa fa-upload fa-fw"></i> Server Rebooted
                                            <span class="pull-right text-muted small">4 minutes ago</span>
                                        </div>
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <div class="text-center link-block">
                                        <a href="notifications.html">
                                            <strong>See All Alerts</strong>
                                            <i class="fa fa-angle-right"></i>
                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </li>
						-->
						<?php 
						}
						?>
                        <li>
                            <a href="logout.php">
                                <i class="fa fa-sign-out"></i> Log out
                            </a>
                        </li>
                    </ul>
                </nav>
				
            </div>
			<div class="wrapper wrapper-content animated fadeInRight">
				