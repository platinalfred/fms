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
					
					<div class="col-sm-5 text-muted small pull-left" style="padding:10px;"> <a data-toggle="modal" href="#add_member" class="btn btn-primary btn-xs"> <i class="fa fa-plus"></i> Add new member</a></div>
					<div class="clear:both;"></div>
					<div class="input-group">
						<input type="text" placeholder="Search client " class="input form-control">
						<span class="input-group-btn">
							<button type="button" class="btn btn btn-primary"> <i class="fa fa-search"></i> Search Member</button>
						</span>
					</div>
					<div class="clients-list">
					<ul class="nav nav-tabs">
						<span class="pull-right small text-muted"><?php echo $member->findNoOfMembers(); ?> members</span>
						<li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-user"></i> Members</a></li>
					</ul>
					<div class="tab-content">
						<div id="tab-1" class="tab-pane active">
							<div class="full-height-scroll" style="margin-top:10px;">
								<!--<div class="table-responsive"> -->
									<table class="table table-striped table-hover" id="member_table">
										<thead>
											<tr>
												<th>Id</th>
												<th>Person Number</th>
												<th>Name</th>
												<th>Phone</th>
												<th>Id Number</th>
												<th>Date of Birth</th>
												<th>Details</th>
											</tr>
										</thead>
										<tbody>
											
										</tbody>
									</table>
								<!--</div>-->
							</div>
						</div>
						
					</div>

					</div>
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

								<strong>Relatives</strong>

								<ul class="list-group clear-list">
									<li class="list-group-item fist-item">
										<div class="col-lg-3">Name</div>
										<div class="col-lg-3" >Relationship</div>
										<div class="col-lg-3" >Address</div>
										<div class="col-lg-3">Phone</div>
									</li>
									
								</ul>
								<strong>Employment History</strong>
								<ul class="list-group clear-list">
									<li class="list-group-item fist-item">
										<div class="col-lg-3">Employer</div>
										<div class="col-lg-3" >Years of employment</div>
										<div class="col-lg-3" >Nature of employment</div>
										<div class="col-lg-3">Monthly Employment</div>
									</li>
									
								</ul>
								<strong>Comments</strong>
								<p class="comments">
									Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
									tempor incididunt ut labore et dolore magna aliqua.
								</p>
								<hr/>
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
								</div>
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

