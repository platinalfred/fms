<script>
$(document).ready(function(){ 
	 $('.date').datepicker({
		todayBtn: "linked",
		keyboardNavigation: false,
		forceParse: false,
		calendarWeeks: true,
		autoclose: true
	});
	<?php 
	if(isset($_GET['memberId'])){ ?>
		$('.delete_member').click(function () {
			var id = $(this).attr("id");
			$.confirm({
				icon: 'fa fa-warning',
				title: 'Confirm!',
				 boxWidth: '30%',
				content: 'Are you sure you would like to delete this member?',
				typeAnimated: true,
				buttons: {
					Delete: {
						text: 'Delete',
						btnClass: 'btn-danger',
						action: function(){
							$.ajax({
								url: "delete.php?tbl=member&id="+id,
								type: 'GET',
								success: function (response) {
									if(response.trim() == "success"){
										showStatusMessage("Member has been deleted." ,"success");
										setTimeout(function(){
											window.location = "members.php";
										}, 2000);
									}else{
										showStatusMessage(response, "fail");
									}
									
								}
							});
						}
					},
					Cancel: function () {
						
					}
				}
			});
			
		});
	<?php
	}
	?>
	$('input.athousand_separator').keyup(function(event) {

	  // skip for arrow keys
	  if(event.which >= 37 && event.which <= 40){
	   event.preventDefault();
	  }

	  $(this).val(function(index, value) {
		  value = value.replace(/,/g,'');
		  return numberWithCommas(value);
	  });
	});

	function numberWithCommas(x) {
		var parts = x.toString().split(".");
		parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		return parts.join(".");
	}
	$("#no_of_shares").on('keyup change',function(){
		var currentInput  = parseInt($(this).val());
		var one_share_amount  = parseInt($("#rate_amount").val());
		var total_share_amount  = currentInput * one_share_amount;
		if(!isNaN(currentInput)){
			var words  = getWords(total_share_amount);
			if(currentInput != 1){
				s = "shares";
			}else{
				s = "share";
			}
			$("#share_amount").val(total_share_amount);
			$("#share_rate_amount").html("You are buying "+currentInput+" "+ s+ " which is equivalent to "+ words +" Uganda Shillings Only");
			
		}else{
			$("#share_rate_amount").html("");
			$("#share_amount").val("");
		}
		
	});
	$(".photo_upload").click(function(){
		var formData = new FormData($("form#photograph")[0]);
		$.ajax({
			url: "photo_upload.php",
			type: 'POST',
			data: formData,
			async: false,
			success: function (response) {
				if(response.trim() == "success"){
					showStatusMessage("Successfully uploaded member photo", "success");
					setTimeout(function(){
						window.location.reload(true);
					},2000)
					
				}else{
					showStatusMessage(response, "error");
				}
			},
			cache: false,
			contentType: false,
			processData: false
		});

		return false;
	});
});
<?php 
$relationshipTypeObj = new RelationshipType();
?>
	var relationships = <?php echo json_encode($relationshipTypeObj->findAll());?>;
	
	/*MEMBER EMPLOYMENT HISTORY KO*/
	var MemberEmployment = function() {
		var self = this;
	}
	var MemberBusiness = function() {
		var self = this;
	}
	/*MEMBER RELATIVE KO*/
	var MemberRelative = function() {
			var self = this;
			self.is_next_of_kin = ko.observable(0);
			self.first_name = ko.observable();
			self.last_name = ko.observable();
			self.other_names = ko.observable();
			self.relative_gender = ko.observable();
			self.relationship = ko.observable();
			self.telephone = ko.observable();
			self.address = ko.observable();
			self.address2 = ko.observable();
		};
	var Member = function() {
		var self = this;
		self.member_employment = ko.observableArray(<?php if(!isset($_GET['memberId'])){ ?> [new MemberEmployment()]<?php } ?>);
		self.addEmployment = function() { self.member_employment.push(new MemberEmployment()) };
		self.removeEmployment = function(relative) {
			self.member_employment.remove(relative);
		};
		self.member_business = ko.observableArray(<?php if(!isset($_GET['memberId'])){ ?> [new MemberBusiness()]<?php } ?>);
		self.addBusinnes = function() { self.member_business.push(new MemberBusiness()) };
		self.removeBusiness = function(business) {
			self.member_business.remove(business);
		};
		//Keeps track of member relatives, observing any changes
		self.member_relatives = ko.observableArray(<?php if(!isset($_GET['memberId'])){ ?> [new MemberRelative()]<?php } ?> );
		//Add a relative
		self.addRelative = function() { self.member_relatives.push(new MemberRelative()) };
		//remove relative
		self.removeRelative = function(relative) {
			self.member_relatives.remove(relative);
		};
		<?php 
		if(isset($_GET['memberId'])){ 
			?>
			self.member_business2 = ko.observableArray(<?php if($member_business){echo json_encode($member_business);}  ?>);
			
			self.removeBusiness2 = function(relative) {
				self.member_business2.remove(relative);
			};
			//Keeps track of member relatives, observing any changes
			self.member_relatives2 = ko.observableArray(<?php if($member_relatives){ echo json_encode($member_relatives); } ?>);
			
			//remove relative
			self.removeRelative2 = function(relative) {
				self.member_relatives2.remove(relative);
			}
			self.member_employment2 = ko.observableArray(<?php if($member_employment_history){ echo json_encode($member_employment_history); } ?>);
			self.removeEmployment2 = function(relative) {
				self.member_employment2.remove(relative);
			
			}; 
		<?php 
		}
		?>
		//reset the form
		self.resetForm = function() {
			self.member_relatives.removeAll();
			self.member_employment.removeAll();
			self.member_business.removeAll();
			$("#form1")[0].reset();
		};
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
	};
	
	var memberModel = new Member();
	ko.applyBindings(memberModel, $("#update_member, #add_member")[0]);
	

//$(document).ready(function(){
	<?php if(!isset($_GET['view'])):?>var dTable;
	  <?php endif;?>
	/* PICK DATA FOR DATA TABLE  */
  <?php if(!isset($_GET['view'])):?>
	
	var handleDataTableButtons = function() {
			
		  if ($("#member_table").length ) {
			  dTable = $('#member_table').DataTable({
			  dom: "lfrtipB",
				"processing": true,
			  "serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'desc' ]],
			  "ajax": {
				  "url":"find_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.page = 'view_members';
						d.start_date = startDate;
						d.end_date = endDate;
					}
			  },"columnDefs": [ {
				  "targets": [0],
				  "orderable": true,
				  "searchable": false
			  }],
			  columns:[  
					{ data: 'id'},
					/* { data: 'person_number'}, */
					{ data: 'Name', render: function ( data, type, full, meta ) {return full.lastname + ' ' + full.othername + ' ' + full.firstname ; }},
					{ data: 'phone'},
					{ data: 'id_number'},
					{ data: 'dateofbirth', render: function ( data, type, full, meta ) {return moment(data, "YYYY-MM-DD").format('LL');}},
					{ data: 'dateAdded', render: function ( data, type, full, meta ) {return moment(data, "X").format('DD-MMM-YYYY'); }}<?php 
					if(!isset($_SESSION['loan_officer'])){ ?>,
					{ data: 'id', render: function ( data, type, full, meta ) {  return '  <a href="member_details.php?memberId='+data+'" class="btn btn-warning btn-sm"><i class="fa fa-list"></i> Details</a> ';}} <?php } ?> 
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5]
					}
				},
				/* {
				  extend: "csv",
				  className: "btn-sm"
				}, */
				{
				  extend: "excel",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5]
					}
				},
				{
				  extend: "pdfHtml5",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5]
					}
				},
				{
				  extend: "print",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5]
					}
				},
			  ],
			  
			   "initComplete": function(settings, json) {
					ko.applyBindings(memberTableModel, $("#member_details")[0]);
					$(".table tbody>tr:first").trigger('click');
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
	
	$(".save").click(function(){
		var frmdata = $(this).closest("form").serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added new record" ,"success");
					setTimeout(function(){
						memberModel.resetForm();
						<?php if(!isset($_GET['view'])):?>
							dTable.ajax.reload();
						
						<?php endif;?>
					}, 2000);
				}else{
					
					showStatusMessage(response, "fail");
				}
				
			}
		});

		return false;
	});
	$(".subscribe").click(function(){
		var frmdata = $(this).closest("form").serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added subscription" ,"success");
					setTimeout(function(){
						window.location="";
					}, 2000);
				}else{
					
					showStatusMessage(response, "fail");
				}
				
			}
		});

		return false;
	});
	$(".add_share").click(function(){
		var frmdata = $(this).closest("form").serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added subscription" ,"success");
					setTimeout(function(){
						window.location="";
					}, 2000);
				}else{
					
					showStatusMessage(response, "fail");
				}
				
			}
		});

		return false;
	});
// It has the name attribute "registration"
  $("form[name='registration']").validate({
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
		enableDisableButton(form, true);
		var frmdata = new FormData($(form)[0]);
		//var frmdata = form.serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			async: false,
			cache: false,
			contentType: false,
			processData: false,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added new record" ,"success");
					$("form#form1")[0].reset();
					$('input[type="radio"]').removeAttr('checked').iCheck('update');
					  <?php 
					  if(!isset($_GET['view'])):?>
						dTable.ajax.reload();	
						<?php endif;?>
					enableDisableButton(form, false);	
				}else{
					showStatusMessage(response, "fail");
					enableDisableButton(form, false);
				}
				
			}
		});
    }
  });
	
	var MemberTable = function(){
		var self = this;
		self.member_details = ko.observable();
		self.member_relatives2 = ko.observableArray();
		self.member_employers2 = ko.observableArray();
	}
	var memberTableModel = new MemberTable();
	
	if($("#subTable").length > 0){
		$("#subTable").DataTable();
	}
	
			  
  
	$('.table tbody').on('click', 'tr ', function () {
		var data = dTable.row(this).data();
		memberTableModel.member_details(data);
		//ajax to retrieve other member details
		if(data){
			findMemberDetails(data.personId);
		}
	});
	
	function findMemberDetails(id){
		$.ajax({
			url: "find_more_member_details.php?id="+id,
			type: 'GET',
			dataType: 'json',
			success: function (data) {
				if(data.relatives != "false"){
					memberTableModel.member_relatives2(data.relatives);
				}
				if(data.employers != "false"){
					memberTableModel.member_employers2(data.employers);
				}
				
			}
		});
	}
	<?php endif;?>
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
	
	
//});
function handleDateRangePicker(start_date, end_date){
	startDate = start_date;
	endDate = end_date;
	dTable.ajax.reload();
 }
</script>
