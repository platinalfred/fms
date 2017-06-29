<?php 
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout");
$page_title = "Members";
include("include/header.php"); 
require_once("lib/Libraries.php");
$member = new Member();
?>
	<div class="row">
		<?php include("add_member_modal.php"); ?>
		<div class="col-sm-8">
			<div class="ibox">
				<div class="ibox-content">
					<!--<span class="text-muted small pull-right">Last modification: <i class="fa fa-clock-o"></i> 2:10 pm - 12.06.2014</span>-->
					<h2>Members</h2>
					<?php 
					if(isset($_SESSION['admin']) || isset($_SESSION['loan_officer'])){ ?>
						<div class="col-sm-5 text-muted small pull-left" style="padding:10px;"> <a data-toggle="modal" href="#add_member" class="btn btn-primary btn-xs"> <i class="fa fa-plus"></i> Add new member</a></div> 
						<?php
					}
					?>
					<table class="table table-striped table-hover" id="member_table">
						<thead>
							<tr>
								<th>Id</th>
								<th>Person Number</th>
								<th>Name</th>
								<th>Phone</th>
								<th>Id Number</th>
								<th>Date of Birth</th>
								<?php 
								if(isset($_SESSION['admin']) || isset($_SESSION['loan_officer'])){ ?>
									<th>Details</th>
								<?php 
								}
								?>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
						<tfoot>
							<tr>
								<th>Id</th>
								<th>Person Number</th>
								<th>Name</th>
								<th>Phone</th>
								<th>Id Number</th>
								<th>Date of Birth</th>
								<?php 
								if(isset($_SESSION['admin']) || isset($_SESSION['loan_officer'])){ ?>
									<th>Details</th>
								<?php 
								}
								?>
							</tr>
						</tfoot>
					</table>
						
				</div>
			</div>
		</div>
		<div class="col-sm-4">
			<div class="ibox ">
				<div class="ibox-content">
					<div class="tab-content">
						<div id="member_details" class="tab-pane active">
							<div class="row m-b-lg" data-bind="with: member_details">
								<div class="col-lg-4 text-center">
									<h2 id="name"><span data-bind="text: firstname+' '+lastname+' '+othername">a a</span></h2>
									<div class="m-b-sm">
										<img alt="image" class="img-circle" id="photo" src="img/user.png" style="width: 62px">
									</div>
								</div>
								<div class="col-lg-8">
									<strong>
										<span class="pno"><span data-bind="text: person_number">BFS00000027</span></a>
									</strong>
									<p>
										<div class="col-lg-6">Phone</div>
										<div class="col-lg-6" class="phone"><span data-bind="text: phone">03890238029</span></div>
									</p>
									<p>
										<div class="col-lg-6">Date of Birth</div>
										<div class="col-lg-6" class="date_of_birth"><span data-bind="text: moment(dateofbirth,'YYYY-MM-DD').format('LL')">08/08/1988</span></div>
									</p>
									<p>
										<div class="col-lg-6">ID Number</div>
										<div class="col-lg-6" class="id_number"><span data-bind="text: id_number">B08891988</span></div>
									</p>
									<p>
										<div class="col-lg-6">Physical Address</div>
										<div class="col-lg-6" class="physical_address"><span data-bind="text: physical_address">Kampala</span></div>
									</p>
									<div class="clearboth"></div>
									<p>
										<div class="col-lg-6">Date Registered</div>
										<div class="col-lg-6" class="date_registered"><span data-bind="text: moment(date_registered,'YYYY-MM-DD').format('LL')">30 May, 2017<span data-bind="text: person_number"></div>
									</p>
								</div>
							</div>
							<div class="client-detail">
							<div class="full-height-scroll">
								<!--ko if: $root.member_relatives2().length>0 -->
									<h4>Relatives</h4>
									<div class="row" >
										<div class="col-lg-3 titles">Name</div>
										<div class="col-lg-3 titles" >Relationship</div>
										<div class="col-lg-3 titles">Phone</div>
										<div class="col-lg-2 titles" >Address</div>
									</div>
									<div data-bind='foreach: $root.member_relatives2'>
										<div class="row" >
											<div class="col-lg-4" data-bind="text: first_name + ', ' + last_name + ' ' + other_names" >Name</div>
											<div class="col-lg-2" data-bind="text: rel_type">Relationship</div>
											<div class="col-lg-3" data-bind="text: telephone"></div>
											<div class="col-lg-2" data-bind="text: address">Address</div>
										</div>
									</div>
								<!-- /ko -->
								<!--ko if: $root.member_employers2().length>0 -->
									<h4>Employment History</h4>
									
									<div class="row" >
										<div class="col-lg-4">Employer</div>
										<div class="col-lg-3" >Years of employment</div>
										<div class="col-lg-3" >Nature of employment</div>
										<div class="col-lg-2">Monthly Salary</div>
									</div>
								
									<div  data-bind='foreach: $root.member_employers2'>
										<div class="row" >
											<div class="col-lg-4" data-bind="text: employer" >Name</div>
											<div class="col-lg-3" data-bind="text: years_of_employment"></div>
											<div class="col-lg-3" data-bind="text: nature_of_employment"></div>
											<div class="col-lg-2" data-bind="text: monthlySalary"></div>
										</div>
									</div>
								<!-- /ko -->
								<div class="col-lg-12" data-bind="with: member_details">
									<strong>Comments</strong>
									<p class="comments"  data-bind="text:comment">
									</p>
								</div>
								<hr/>
								<!--
								<strong>Timeline activity</strong>
								<div id="vertical-timeline" class="vertical-container dark-timeline">
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-coffee"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>Conference on the sales results for the previous year.
											</p>
											<span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
										</div>
									</div>
									
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-briefcase"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>Many desktop publishing packages and web page editors now use Lorem.
											</p>
											<span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
										</div>
									</div>
								</div>-->
							</div>
							</div>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
	<?php 
 include("include/footer.php");
 include("js/members_js.php");
 ?>

