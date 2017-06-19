<?php 
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout");
$page_title = "Members";
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
					<div class="col-sm-5 text-muted small pull-left" style="padding:10px;"><a data-toggle="modal" class="btn btn-primary" href="#add_group"><i class="fa fa-plus"></i> Add Group</a></div>
					<div class="clear:both;"></div>
					<div class="input-group">
						<input type="text" placeholder="Search client " class="input form-control">
						<span class="input-group-btn">
							<button type="button" class="btn btn btn-primary"> <i class="fa fa-search"></i> Search Group</button>
						</span>
					</div>
					<div class="clients-list">
						<div class="tab-content">
							<div class="full-height-scroll">
								<div class="table-responsive">
									<table class="table table-striped table-hover" id="groupTable">
										<thead>
											<tr>
												<th>Id</th>
												<th>Group Name</th>
												<th>Description</th>
												<?php 
												if(isset($_SESSION['admin']) || isset($_SESSION['loan_officer'])){ ?>
													<th>Edit/Delete</th>
												<?php 
												}
												?>
											</tr>
										</thead>
										<tbody>
											
										</tbody>
									</table>
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
 ?>
<script>
$(document).ready(function(){
	
	/* PICK DATA FOR DATA TABLE  */
	var  dTable;
	var handleDataTableButtons = function() {
		  if ($("#groupTable").length ) {
			  dTable = $('#groupTable').DataTable({
			  dom: "lfrtipB",
				"processing": true,
			  "serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],
			  "ajax": {
				  "url":"find_groups.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.page = 'view_group';
					}
			  },"columnDefs": [ {
				  "targets": [0],
				  "orderable": false,
				  "searchable": false
			  } , {
				  "targets": [0],
				  "orderable": false
			  }],
			  columns:[  
					{ data: 'id'},
					{ data: 'groupName'},
					{ data: 'description'}<?php 
					if(isset($_SESSION['admin']) || isset($_SESSION['loan_officer'])){ ?>,
					{ data: 'id', render: function ( data, type, full, meta ) {  return ' <a id="'+data+'" class="btn btn-white btn-sm edit_group"><i class="fa fa-pencil"></i> Edit </a> ';}} <?php } ?> 
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				/* {
				  extend: "csv",
				  className: "btn-sm"
				}, */
				{
				  extend: "excel",
				  className: "btn-sm"
				},
				{
				  extend: "pdfHtml5",
				  className: "btn-sm"
				},
				{
				  extend: "print",
				  className: "btn-sm"
				},
			  ],
			  
			   "initComplete": function(settings, json) {
				   
					$(".table tbody>tr:first").trigger('click');
					ko.applyBindings(groupModel);
			  }
			});
			//$("#datatable-buttons").DataTable();
		}

	};
	TableManageButtons = function() {
	  "use strict";
	  return {
		init: function() {
		  handleDataTableButtons();
		}
	  };
	}();

	TableManageButtons.init();
	$('#groupTable').on('click', 'tr .edit_group', function () {
		var id = $(this).attr("id")
		 $('#DescModal').removeData('bs.modal');
        $('#DescModal').modal({remote: 'edit_group.php?id=' + id });
        $('#DescModal').modal('show');
	})
	$('.table tbody').on('click', 'tr ', function () {
		var data = dTable.row(this).data();
		console.log(data);
		groupModel.group_details(data);
		//ajax to retrieve other member details
		findGroupDetails(data.id);
	});
	function findGroupDetails(id){
		$.ajax({
			url: "find_group_details.php?id="+id,
			type: 'GET',
			dataType: 'json',
			success: function (data) {
				if(data.group_members != "false"){
					groupModel.all_group_members(data.group_members);
				}
				
				
			}
		});
	}
	function showStatusMessage(message='', display_type='success'){
		new PNotify({
			  title: "Alert",
			  text: message,
			  type: display_type,
			  styling: 'bootstrap3',
			  sound: true,
			  hide:true,
			  buttons: {
				closer_hover: false,
			},
			confirm: {
				confirm: true,
				buttons: [{
					text: 'Ok',
					addClass: 'btn-primary',
					click: function(notice) {
						notice.remove();
					}
				},
				null]
			},
			animate: {
				animate: true,
				in_class: 'zoomInLeft',
				out_class: 'zoomOutRight'
			},
			  nonblock: {
				  nonblock: true
			  }
			  
		  });
		
	}
	// It has the name attribute "registration"
	$("form[name='register_group']").validate({
		// Specify validation rules
		rules: {
		  // The key name on the left side is the name attribute
		  // of an input field. Validation rules are defined
		  // on the right side
		  groupName: "required"
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		  
		},
		// Specify validation error messages
		messages: {
		  groupName: "Please give this group a name",
		},
		// Make sure the form is submitted to the destination defined
		// in the "action" attribute of the form when valid
		submitHandler: function(form, event) {
			event.preventDefault();
			var form =  $("form[name='register_group']");
			var frmdata = form.serialize();
			$.ajax({
				url: "save_data.php",
				type: 'POST',
				data: frmdata,
				success: function (response) {
					if($.trim(response) == "success"){
						showStatusMessage("Successfully added new record" ,"success");
						form[0].reset();
						dTable.ajax.reload();
						groupModel.group_members(null);
					}else{
						showStatusMessage(response, "fail");
					}
					
				}
			});
		}
	  });
});
	 
var GroupMember = function() {
	var self = this;
}
var Group = function() {
	var self = this;
	self.sacco_members = ko.observableArray();
	self.group_details = ko.observableArray();
	self.all_group_members = ko.observableArray();
	self.group_members = ko.observableArray([new GroupMember()]);
	self.addMember = function() { self.group_members.push(new GroupMember()) };
	self.removeMember = function(selected_member) {
		self.group_members.remove(selected_member);
	};
	//Operations
	//set options value afterwards
	self.setOptionValue = function(propId) {
		return function (option, item) {
			if (item === undefined) {
				option.value = "";
			} else {
				option.value = item[propId];
			}
		}
	};
	//Retrieve page data from the server
	self.findMembers = function() { 
		$.ajax({
			url: "all_members.php",
			type: 'POST',
			data:{group:"view_members"},
			dataType: 'json',
			success: function (data) {
				groupModel.sacco_members(data.customers);			
			}
		});
	};
}
var groupModel = new Group();
groupModel.findMembers();
//ko.applyBindings(groupModel, $("#form")[0]);

</script>