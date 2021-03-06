<?php 
session_start();
require_once("lib/Libraries.php"); 
$staff = new Staff();
$staff_data = $staff->findStaffDetails($_GET['id']);
if($staff_data){
	$access_roles = $staff->findAccessRoles($staff_data['personId']);
}else{
	?>
	<h2>There was no staff selected</h2>
	<?php
	exit();
}

?>
 <link href="css/general.css" rel="stylesheet">
<div class="ibox">
	<div class="ibox-title">
		<p>
			<h2><b>Edit staff details</b></h2>
		</p>
		<div class="ibox-tools">
			<a class="collapse-link">
				<i class="fa fa-chevron-up"></i>
			</a>
			<a class="" >
				<i class="fa fa-times lg" data-dismiss="modal" style="color:red;"></i>
			</a>
		</div>
	</div>
	<div class="ibox-content">
		
		
			
		<form id="edit_staff" action="" method="post" name="edit_staff"  class="wizard-big">
			<input type="hidden" name="member_id" value="<?php echo $_GET['id'];?>">
			<input type="hidden" name="modified_by" value="<?php echo $_SESSION['staffId'];?>">
			<input type="hidden" name="person_number" value="<?php echo $staff_data['person_number'];?>">
			<input type="hidden" name="person_type" value="<?php echo $staff_data['person_type'];?>">
			<input type="hidden" name="date_registered" value="<?php echo $staff_data['date_registered'];?>">
			<input type="hidden" name="registered_by" value="<?php echo $staff_data['registered_by'];?>">
			<input type="hidden" name="added_by" value="<?php echo $staff_data['added_by'];?>">
			<input type="hidden" name="date_added" value="<?php echo $staff_data['date_added'];?>">
			
			<input type="hidden" name="personId" value="<?php echo $staff_data['personId'];?>">
			<input type="hidden" name="tbl" value="update_staff">
			<h1>User and Login Information</h1>
			<fieldset>
				<div class="row">
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-sm-3 control-label no_padding">Title</label>
							<div class="col-sm-8">
								<select class="form-control m-b" name="title" required>
									<option <?php if($staff_data['title'] == "Mr"){ echo "selected"; } ?> value="Mr" >Mr.</option>
									<option <?php if($staff_data['title'] == "Mrs"){ echo "selected"; } ?> value="Mrs">Mrs.</option>
									<option value="Dr" <?php if($staff_data['title'] == "Dr"){ echo "selected"; } ?>>Dr.</option>
									<option value="Prof" <?php if($staff_data['title'] == "Prof"){ echo "selected"; } ?>>Prof.</option>
									<option value="Eng" <?php if($staff_data['title'] == "Prof"){ echo "selected"; } ?>>Eng.</option>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-6" style="margin-bottom:11px;">
						<div class="form-group">
							<label class="col-sm-3 control-label no_padding">Branch</label>
							<div class="col-sm-8">
								<select class="form-control m-b" name="branch_id" required >
									<option value="">Please select</option>
									<?php 
									$branch = new Branch();
									$branches = $branch->findAll();
									if($branches){
										foreach($branches as $single){ ?>
											<option value="<?php echo $single['id']; ?>" <?php if($staff_data['branch_id'] == $single['id']){ echo "selected"; } ?> ><?php echo $single['branch_name']; ?></option>
											<?php
										}
									}
									?>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-8 bottom_pad" >
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">User Name <span class="req">*</span></label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<input id="username" name="username" value="<?php echo $staff_data['username']; ?>" placeholder="user name" type="text" class="form-control" required>
							</div>
						</div>
					</div>
					
					<div class="col-lg-9 bottom_pad" >
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-12 col-xs-12 no_padding">Password <span class="req">*</span></label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<input id="password" name="password" type="password" value="<?php echo $staff_data['password']; ?>"  class="form-control" required>
							</div>
						</div>
					</div>
					<div class="col-lg-9 bottom_pad" >
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Confirm Password <span class="req">*</span></label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<input id="password" name="password2" value="<?php echo $staff_data['password']; ?>" type="password" class="form-control" required>
							</div>
						</div>
					</div>
					
					<div class="col-lg-4">
						<div class="col-sm-12">&nbsp;</div>
						<div class="form-group">
							<label class="col-sm-3 control-label no_padding">Position</label>
							<div class="col-sm-9">
								<select class="form-control m-b" name="position_id" required>
									<option value="">Please select</option>
									<?php 
									$position = new Position();
									$positions = $position->findAll();
									if($positions){
										foreach($positions as $single){ ?>
											<option value="<?php echo $single['id']; ?>" <?php if($staff_data['position_id'] == $single['id']){ echo "selected"; } ?>><?php echo $single['name']; ?></option>
											<?php
										}
									}
									?>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">Access Level<br/><small class="text-navy">Staff rights will be limited to the access level(s) you assign.</small></label>
							<div class="col-sm-8">
								<?php 
								$access_level = new AccessLevel();
								$access_levels = $access_level->findAll();
								if($access_levels){
									foreach($access_levels as $single){ ?>
										<div class="i-checks"><label> <input <?php if($access_roles){ foreach($access_roles as $role){  if($role['role_id'] == $single['id']){ echo  "checked"; } }  } ?> name="access_levels[]" type="checkbox" value="<?php echo $single['id']; ?>"> <i></i> <?php echo $single['name']; ?></label></div>
										<?php
									}
								}
								?>
							</div>
						</div>
					</div>
					
					<div class="col-lg-8">
						<div class="col-sm-12">&nbsp;</div>
							<div class="col-sm-12 no_padding">
							<div class="form-group">
								<div class="col-sm-3 no_padding">
									<label style=""class="">Name <span class="req">*</span></label>
								</div>
								<div class="col-sm-9">
									<input type="text" class="form-control" value="<?php echo $staff_data['firstname']; ?>" name="firstname" data-msg-require="Please enter name" placeholder="First Name" required/>
									<span class="input-group-btn" style="width:2px;"></span>
									<input type="text" class="form-control" value="<?php echo $staff_data['lastname']; ?>" name="lastname" placeholder="Last Name" required />
									<span class="input-group-btn" style="width:2px;"></span>
									<input type="text" class="form-control" value="<?php echo $staff_data['othername']; ?>" name="othername"  placeholder="Other Name" />
								</div>
							</div>
						</div>
						<div class="col-sm-12 no_padding" style="margin-top:8px;margin-bottom:8px;">
							<div class="form-group">
								<div class="col-sm-3 no_padding"><label class="col-lg-12" >Gender</label></div>
								<div class="col-sm-9">
									<label > <input name="gender" <?php if($staff_data['gender'] == "M"){ echo "checked"; } ?> class="i-checks" type="radio" value="M" >Male</label>
									<label > <input name="gender" <?php if($staff_data['gender'] == "F"){ echo "checked"; } ?> class="i-checks" type="radio" value="F" > Female</label>
								</div>
							</div>											
								
						</div>
						<div class="col-sm-12 no_padding">
							<div class="form-group">
								<label class="col-sm-3 control-label no_padding" >Date of Birth <span class="req">*</span></label>
								<div class="col-sm-9">
									<input id="dateofbirth" value="<?php echo date("d/m/Y", strtotime($staff_data['dateofbirth'])); ?>" name="dateofbirth" type="text" data-mask="99/99/9999" class="form-control" >
									<span class="help-block">(dd/mm/yyyy)</span>
								</div>
							</div>
						</div>
					</div>
				</div>

			</fieldset>
			<h1>Identification  Information</h1>
			<fieldset>
				<div class="row">
					<div class="col-lg-6">
						<div class="item form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding" for="id_type">ID Type <span class="required">*</span>
							</label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<select class="form-control m-b" name="id_type" required >
									<option>Please select</option>
									<?php 
									$idcardtype = new IdCardType();
									$all_id_cardtype = $idcardtype->findAll();
									if($all_id_cardtype){
										foreach($all_id_cardtype as $single){ ?>
											<option value="<?php echo $single['id']; ?>" <?php if($staff_data['id_type'] == $single['id']){ echo "selected"; } ?>><?php echo $single['id_type']; ?></option>
											<?php
										}
									}
									?>
								</select>
							</div>
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Id Number <span class="req">*</span></label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<input id="id_number" name="id_number" value="<?php echo $staff_data['id_number']; ?>" type="text" class="form-control" required>
							</div>
						</div>
					</div>
					
					<div class="col-lg-12">&nbsp;</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label >Email </label>
							<input id="email" name="email" type="email" value="<?php echo $staff_data['email']; ?>" class="form-control ">
							
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label>Telephone <span class="req">*</span></label>
							<input id="phone" type="text" class="form-control" data-mask="(999) 999-9999" value="<?php echo $staff_data['phone']; ?>" placeholder="" name="phone"required ><span class="help-block">(073) 000-0000</span>
						</div>
					</div>
				</div>
			</fieldset>
			<h1>Residential  Information</h1>
			<fieldset>
				<div class="row">
					<div class="col-lg-3">
						<div class="form-group">
							<label>Physical Address <span class="req">*</span></label>
							<input id="physical_address" name="physical_address" type="text" value="<?php echo $staff_data['physical_address']; ?>" class="form-control" required>
						</div>
					</div>
					<div class="col-lg-3">
						<div class="form-group">
							<label>Postal Address</label>
							<input id="postal_address" name="postal_address" type="text" value="<?php echo $staff_data['postal_address']; ?>" class="form-control ">
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label>District </label>
							<input id="" name="district" type="text" value="<?php echo $staff_data['district']; ?>" class="form-control">
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label>County </label>
							<input id="" name="county" type="text" value="<?php echo $staff_data['county']; ?>" class="form-control">
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label>Sub County </label>
							<input id="" name="subcounty" type="text" value="<?php echo $staff_data['subcounty']; ?>" class="form-control">
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label>Parish </label>
							<input id="" name="parish" type="text" value="<?php echo $staff_data['parish']; ?>" class="form-control">
						</div>
					</div>
					<div class="col-lg-6">
						<label class="control-label">Village</label>
						<input id="" name="village" type="text" value="<?php echo $staff_data['village']; ?>" class="form-control">
					</div>
				</div>
			</fieldset>
			
			<fieldset>
				<div class="col-lg-12 form-group">
				<label>Comment</label>
				<textarea name="comment" class="form-control " rows="5"><?php echo $staff_data['comment']; ?></textarea>
				</div>
				
				<div class="col-lg-12 form-group">
					<span class="alert-danger" id="accept_msg"></span>
					<div class="col-lg-1"><input id="acceptTerms" name="acceptTerms" data-msg-require="Accept" type="checkbox" class="i-checks" required> </div>
					<div class="col-lg-10">	<label for="acceptTerms">I accept that all the above staff details are correct.</label></div>
				</div>
				
				
				<div class="col-lg-4 form-group">
					<button class="btn btn-xm btn-primary" type="submit">Update Staff</button>
				</div>
			</fieldset>
		</form>
	</div>
</div>
 <!-- iCheck -->
<script src="js/plugins/iCheck/icheck.min.js"></script>
<script>
	$(document).ready(function () {
	
		$('.i-checks').iCheck({
			checkboxClass: 'icheckbox_square-green',
			radioClass: 'iradio_square-green',
		})
		
		function hideStatusMessageGeneral(){
			document.getElementById('notice_message_general').style.display = 'none'; 
			document.getElementById("notice_general").innerHTML= '';
		}
		function showStatusMessageGeneral(msg, type){
			if(type=="fail"){
				$("#notice_message_general").addClass("alert-danger");
			}else{
				$("#notice_message_general").addClass("alert-success");
			}
			if(msg){
				document.getElementById("notice_general").innerHTML = msg ;
			}else{
				document.getElementById("notice_general").innerHTML ='Processing ';
			}
			document.getElementById("notice_message_general").style.display = 'block';
		}
	});
</script>
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
  $("form[name='edit_staff']").validate({
    // Specify validation rules
    rules: {
      // The key name on the left side is the name attribute
      // of an input field. Validation rules are defined
      // on the right side
      firstname: "required",
      lastname: "required",
      /* email: {
        required: true,
        // Specify that email should be validated
        // by the built-in "email" rule
        email: true
      }, */
      password: {
        required: true,
        minlength: 5
      },
		password2: {
			equalTo: "#password"
		}
	  
    },
	errorPlacement: function(error, element) {
      if (element.attr("type") == "radio" || element.attr("type") == "checkbox") {
         $("#accept_msg").html("Please acknowledge all the details above are correct.");
       }else{
			error.insertAfter(element);
	   }
    },
    // Specify validation error messages
    messages: {
      firstname: "Please enter your firstname",
      lastname: "Please enter your lastname",
      password: {
        required: "Please provide a password",
        minlength: "Your password must be at least 5 characters long"
      },
	  
      email: "Please enter a valid email address" 
    },
    // Make sure the form is submitted to the destination defined
    // in the "action" attribute of the form when valid
    submitHandler: function(form, event) {
		event.preventDefault();
		var form =  $("form[name='edit_staff']");
		var frmdata = form.serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully updated staff record" ,"success");
					form[0].reset();
					$('input[type="checkbox"]').removeAttr('checked').iCheck('update');
					//dTable.ajax.reload();
					var oTable = $('#staffTable').dataTable();
					oTable.ajax.reload();
				}else{
					showStatusMessage(response, "fail");
				}
				
			}
		});
    }
  });
	
});
</script>