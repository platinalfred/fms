<?php 
//Hide given files and will be displayed on appropriate pages by giving true values to the variables below
$show_i_check = false; //shows or hides css/js for i-check radio/checbox elements

?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Buladde Financial Services</title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.css" rel="stylesheet">

    <!-- Morris -->
    <link href="css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">

    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
	
	<?php 
	if($show_i_check){ ?>
		<link href="css/plugins/iCheck/custom.css" rel="stylesheet">
		<?php 
	}
	?>
</head>

<body>
    <div id="wrapper">
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="sidebar-collapse">
                <ul class="nav metismenu" id="side-menu">
                    <li class="nav-header">
                        <div class="dropdown profile-element"> <span>
                            <img alt="image" class="img-circle" style="width:48px;" src="img/user.png" />
                             </span>
                            <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear"> <span class="block m-t-xs"> <strong class="font-bold">Platin Mugasa</strong>
                             </span> <span class="text-muted text-xs block">Art Director <b class="caret"></b></span> </span>
                            </a>
                            <ul class="dropdown-menu animated fadeInRight m-t-xs">
                                <li><a href="profile.html">Profile</a></li>
                                <li><a href="contacts.html">Contacts</a></li>
                                <li><a href="mailbox.html">Mailbox</a></li>
                                <li class="divider"></li>
                                <li><a href="login.html">Logout</a></li>
                            </ul>
                        </div> <!--
                        <div class="logo-element">
                            IN+
                        </div> -->
                    </li>
                    <li class="active">
                        <a href="dashboard.php"><i class="fa fa-th-large"></i> <span class="nav-label">Dashboards</span> 
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">Reports</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level collapse">
                            <li><a href="graph_flot.html">Flot Charts</a></li>
                        </ul>
                    </li>
                    <li><a href="members.php"><i class="fa fa-users"></i> <span class="nav-label">Members</span> <span class="label label-info pull-right">62</span></a></li>
					<li><a href="members.php"><i class="fa fa-users"></i> <span class="nav-label">Staff</span></a></li>
                    <li>
                        <a href="#"><i class="fa fa-suitcase"></i> <span class="nav-label">Expenses</span></a>
                        <ul class="nav nav-second-level collapse">
                            <li><a href="contacts.html">Contacts</a></li>
                           
                        </ul>
                    </li>
                   
					<div class="menu_section">
						<h3 style="padding-left:11%;">More</h3>
						
						<ul class="nav side-menu">
						  <li><a href="settings.php"><i class="fa fa-gear"></i> Administration <span class="fa arrow"></span></a>
							<ul class="nav nav-second-level collapse">
							  <li><a href="settings.php">Settings</a></li>
								<li><a href="#">Users</a></li>
							</ul>
						  </li>
						</ul>
					</div>
                    
                </ul>

            </div>
        </nav>
		<div id="page-wrapper" class="gray-bg">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
					<div class="navbar-header">
						<a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
						<form role="search" class="navbar-form-custom" action="http://webapplayers.com/inspinia_admin-v2.5/search_results.html">
							<div class="form-group">
								<input type="text" placeholder="Search for something..." class="form-control" name="top-search" id="top-search">
							</div>
						</form>
					</div>
					<ul class="nav navbar-top-links navbar-right">
						<li>
							<span class="m-r-sm text-muted welcome-message">Welcome Buladde Financial services FMS.</span>
						</li>
						<li class="dropdown">
							<a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
								<i class="fa fa-envelope"></i> <span class="label label-warning">16</span>
							</a>
							<ul class="dropdown-menu dropdown-messages">
								<li>
									<div class="dropdown-messages-box">
										<a href="profile.html" class="pull-left">
											<img alt="image" class="img-circle" src="img/a7.jpg">
										</a>
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
										<a href="profile.html" class="pull-left">
											<img alt="image" class="img-circle" src="img/a4.jpg">
										</a>
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
										<a href="profile.html" class="pull-left">
											<img alt="image" class="img-circle" src="img/profile.jpg">
										</a>
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

						<li>
							<a href="login.html">
								<i class="fa fa-sign-out"></i> Log out
							</a>
						</li>
					</ul>

				</nav>
			</div>
			<!--<div class="row wrapper border-bottom white-bg page-heading">
				<div class="col-lg-10">
					<h2>Settings</h2>
					<ol class="breadcrumb">
						<li>
							<a href="index-2.html">Home</a>
						</li>
						
						<li class="active">
							<strong>Settings</strong>
						</li>
					</ol>
				</div>
				<div class="col-lg-2">

				</div>
			</div> -->