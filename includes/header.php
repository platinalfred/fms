<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Buladde Financial Services<?php echo isset($page_title)?(" - ".$page_title):"";?></title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.css" rel="stylesheet">

    <!-- Morris -->
    <link href="css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">

    <link href="css/animate.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
	<?php if($daterangepicker):?>
		<!-- bootstrap-daterangepicker -->
		<link href="css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
	<?php endif;?>
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
						  <li><a href="settings.php"><i class="fa fa-gear"></i> Settings <span class="fa arrow"></span></a>
							<ul class="nav nav-second-level collapse">
							  <li><a href="#">Security Types</a></li>
								<li><a href="#">Member Types</a></li>
								<li><a href="#">Person Types</a></li>
								<li><a href="#">Account Type</a></li>
								<li><a href="#">Branches</a></li>
								<li><a href="deposit_product.php">Deposit Products</a></li>
								<li><a href="loan_product.php">Loan Products</a></li>
							</ul>
						  </li>
						</ul>
					</div>
                    
                </ul>

            </div>
        </nav>