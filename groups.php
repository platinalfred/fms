<?php 
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout", "select2");
$page_title = "Groups";
include("include/header.php"); 
require_once("lib/Libraries.php");
$member = new Member();
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
		<?php include("add_groups.php"); ?>
		<div class="col-sm-8">
			<div class="ibox">
				<div class="ibox-content">
					<h2>Member Groups</h2>
					<?php 
					//if(isset($_SESSION['accountant']) || isset($_SESSION['admin'])){  ?>
					<div class="col-sm-12 text-muted small pull-left" style="padding:10px;"><a data-toggle="modal" class="btn btn-sm btn-primary" href="#add_group"><i class="fa fa-plus"></i> Add Group</a></div>
					<?php 
					//}
					?>
					<div class="clear:both;"></div>
					<table class="table table-striped table-hover" id="groupTable">
						<thead>
							<tr>
								<th>Id</th>
								<th>Group Name</th>
								<th>Description</th>
								<?php 
							//	if(isset($_SESSION['accountant']) || isset($_SESSION['admin'])){  ?>
									<th>Edit/Delete</th>
								<?php 
								//}
								?>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="col-sm-4">
			<div class="ibox ">
				<div class="ibox-content">
					<div class="tab-content">
						<div id="company-3" class="tab-pane active" data-bind="with: group_details">
							<div class="m-b-lg">
								<h2 data-bind="text:groupName"></h2>
							</div>
							<div class="client-detail">
								<div class="full-height-scroll" >
									<strong>Group Members</strong>
									<ul class="list-group clear-list" data-bind="foreach: $root.all_group_members">
										<li class="list-group-item fist-item" data-bind="text:memberNames">
										</li>
									</ul>
									<strong>Notes</strong>
									<p data-bind="text:description">
									</p>
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
 include("js/group_js.php");
 
 ?>