<?php 
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout");
$page_title = "Members";
include("include/header.php"); 
require_once("lib/Libraries.php");
$staff = new Staff();
$staff
?>
<div class="modal fade" id="DescModal" role="dialog">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-body">
				 
			</div>
			
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
	<div class="row">
		<?php include("add_staff_modal.php"); ?>
		<div class="col-sm-11">
			<div class="ibox">
				<div class="ibox-content">
					<!--<span class="text-muted small pull-right">Last modification: <i class="fa fa-clock-o"></i> 2:10 pm - 12.06.2014</span>-->
					<h2><b>STAFF</b></h2>
					
					<div class="col-sm-5 text-muted small pull-left" style="padding:10px;"> <a data-toggle="modal" href="#add_staff" class="btn btn-primary btn-xs"> <i class="fa fa-plus"></i> Add new Staff</a></div>
					<div class="clear:both;"></div>
					<div class="input-group">
						<input type="text" placeholder="Search client " class="input form-control">
						<span class="input-group-btn">
							<button type="button" class="btn btn btn-primary"> <i class="fa fa-search"></i> Search Staff</button>
						</span>
					</div>
					<div class="clients-list">
					<ul class="nav nav-tabs">
						<li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-user"></i> Staff</a></li>
					</ul>
					<div class="tab-content">
						<div id="tab-1" class="tab-pane active">
							<div class="full-height-scroll" style="margin-top:10px;">
								<!--<div class="table-responsive"> -->
									<table class="table table-striped table-hover" id="staffTable">
										<thead>
											<tr>
												<th>Id</th>
												<th>Staff Number</th>
												<th>User Name</th>
												<th>Position</th>
												<th>Name</th>
												<th>Phone</th>
												<th>Id Number</th>
												<th>Date of Birth</th>
												<th>Edit</th>
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
		
	</div>
	<?php 
 include("include/footer.php");
 include("js/staff_js.php");
 ?>

