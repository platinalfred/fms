<?php 
session_start();
require_once("lib/Libraries.php");
$sacco_group = new SaccoGroup();
$sacco_group_details = $sacco_group->findById($_GET['id']);
?>
<div class="col-lg-12">
	<div class="ibox">
		<div class="ibox-title">
			<h2>
				Update Member Group
			</h2>
		</div>
		<div class="ibox-content">
			<form id="form" name="update_group" class="wizard-big">
				<input name ="createdBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
				<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
				<input name ="id" type="hidden" value="<?php echo $_GET['id']; ?>">
				<input name ="dateCreated" type="hidden" value="<?php echo time(); ?>">
				<input name ="tbl" type="hidden" value="update_group">
					
				<h1>Group Details</h1>
				<fieldset>
					<div class="row">
						<div class="col-lg-8">
							<div class="form-group">
								<label>Group Name *</label>
								<input  name="groupName" value="<?php echo $sacco_group_details['groupName']; ?>" type="text" class="form-control required">
							</div>
							<div class="form-group">
								<label>Group Description</label>
								<textarea  name="description" class="form-control "><?php echo $sacco_group_details['description']; ?> </textarea>
							</div>
						</div>
					</div>

				</fieldset>
				<h1>Group members</h1>
				<!--ko with: GroupMember -->
					<fieldset>
						<p>
							Attach members to this group
						</p>
						<div class="row">
							<div class="form-group">
								<div class="table-responsive">
									<table  class="table table-striped table-condensed table-hover">
										<thead>
											<tr>
												<th>Member</th>
												<th>&nbsp;</th>
											</tr>
										</thead>
										<tbody data-bind='foreach: $root.group_members'>
											<tr>
												<td>
													<select data-bind='attr:{name:"members["+$index()+"][memberId]"}, options: $root.sacco_members, optionsText: "memberNames", optionsCaption: "Select member...", optionsAfterRender: $root.setOptionValue("id")' class="form-control"> </select>
												</td>
												
												<td>
													<span title="Remove item" class="btn text-danger" data-bind='click: $root.removeMember'><i class="fa fa-minus"></i></span>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="col-sm-3">
								<a data-bind='click: $root.addMember' class="btn btn-info btn-sm"><i class="fa fa-plus"></i> Add another member</a></div>
							</div>
						</div>
					</fieldset>
				<!-- /ko -->
				<div class="form-group">
					<div class="col-sm-6 col-sm-offset-3">
						<button class="btn btn-primary" type="submit">Update</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<script>
$(document).ready(function(){
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
	$("form[name='update_group']").validate({
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
			var form =  $("form[name='update_group']");
			var frmdata = form.serialize();
			$.ajax({
				url: "save_data.php",
				type: 'POST',
				data: frmdata,
				success: function (response) {
					if($.trim(response) == "success"){
						showStatusMessage("Successfully added new record" ,"success");
						form[0].reset();
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
	groupModel.sacco_members(data.customers);
}
var groupModel = new Group();
groupModel.findMembers();
//ko.applyBindings(groupModel, $("#form")[0]);
</script>