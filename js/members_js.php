<script>
$(document).ready(function(){ 
	<?php 
	if(isset($_GET['id'])){ ?>
		$('.delete_member').click(function () {
			swal({
					title: "Are you sure you would like to delete this member?",
					text: "<?php echo $names; ?> will no longer be visible in the system!",
					type: "warning",
					showCancelButton: true,
					confirmButtonColor: "#DD6B55",
					confirmButtonText: "Yes, Delete!",
					cancelButtonText: "No, Thank you!",
					closeOnConfirm: false,
					closeOnCancel: false },
				function (isConfirm) {
					if (isConfirm) {
						swal("Deleted!", "Your imaginary file has been deleted.", "success");
					} else {
						swal("Cancelled", "Thank you, member will not be deleted :)", "error");
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
	function getWords(s){
		// American Numbering System
		var th = ['', 'Thousand', 'Million', 'Billion', 'Trillion'];

		var dg = ['Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];

		var tn = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];

		var tw = ['Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

		
		s = s.toString();
		s = s.replace(/[\, ]/g, '');
		if (s != parseFloat(s)) return 'not a number';
		var x = s.indexOf('.');
		if (x == -1) x = s.length;
		if (x > 15) return 'too big';
		var n = s.split('');
		var str = '';
		var sk = 0;
		for (var i = 0; i < x; i++) {
			if ((x - i) % 3 == 2) {
				if (n[i] == '1') {
					str += tn[Number(n[i + 1])] + ' ';
					i++;
					sk = 1;
				} else if (n[i] != 0) {
					str += tw[n[i] - 2] + ' ';
					sk = 1;
				}
			} else if (n[i] != 0) {
				str += dg[n[i]] + ' ';
				if ((x - i) % 3 == 0) str += 'hundred ';
				sk = 1;
			}
			if ((x - i) % 3 == 1) {
				if (sk) str += th[(x - i - 1) / 3] + ' ';
				sk = 0;
			}
		}
		if (x != s.length) {
			var y = s.length;
			str += 'point ';
			for (var i = x + 1; i < y; i++) str += dg[n[i]] + ' ';
		}
		return str.replace(/\s+/g, ' ');
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
<?php $relationshipTypeObj = new RelationshipType();
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
		self.member_employment = ko.observableArray(<?php if(!isset($_GET['id'])){ ?> [new MemberEmployment()]<?php } ?>);
		self.addEmployment = function() { self.member_employment.push(new MemberEmployment()) };
		self.removeEmployment = function(relative) {
			self.member_employment.remove(relative);
		};
		self.member_business = ko.observableArray(<?php if(!isset($_GET['id'])){ ?> [new MemberBusiness()]<?php } ?>);
		self.addBusinnes = function() { self.member_business.push(new MemberBusiness()) };
		self.removeBusiness = function(relative) {
			self.member_business.remove(relative);
		};
		//Keeps track of member relatives, observing any changes
		self.member_relatives = ko.observableArray(<?php if(!isset($_GET['id'])){ ?> [new MemberRelative()]<?php } ?> );
		//Add a relative
		self.addRelative = function() { self.member_relatives.push(new MemberRelative()) };
		//remove relative
		self.removeRelative = function(relative) {
			self.member_relatives.remove(relative);
		};
		<?php 
		if(isset($_GET['id'])){ 
			?>
			self.member_business2 = ko.observableArray(<?php echo json_encode($member_business);  ?>);
			
			self.removeBusiness2 = function(relative) {
				self.member_business2.remove(relative);
			};
			//Keeps track of member relatives, observing any changes
			self.member_relatives2 = ko.observableArray(<?php echo json_encode($member_relatives);  ?>);
			
			//remove relative
			self.removeRelative2 = function(relative) {
				self.member_relatives2.remove(relative);
			}
			self.member_employment2 = ko.observableArray(<?php echo json_encode($member_employment_history);  ?>);
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
	
$(document).ready(function(){
	<?php if(!isset($_GET['view'])):?>var dTable;<?php endif;?>
	
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
						<?php if(!isset($_GET['view'])):?>dTable.ajax.reload();<?php endif;?>
					}, 2000);
				}else{
					
					showStatusMessage(response, "fail");
				}
				
			}
		});

		return false;
	});
	
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
		
		var frmdata = new FormData($("form#form1")[0]);
		//var frmdata = form.serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			async: false,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added new record" ,"success");
					form[0].reset();
					$('input[type="radio"]').removeAttr('checked').iCheck('update');
					<?php if(!isset($_GET['view'])):?>dTable.ajax.reload();<?php endif;?>
				}else{
					showStatusMessage(response, "fail");
				}
				
			},
			cache: false,
			contentType: false,
			processData: false
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
	$("#subTable").DataTable({ dom: "lfrtipB" });
			  
  /* PICK DATA FOR DATA TABLE  */
  <?php if(!isset($_GET['view'])):?>
	var handleDataTableButtons = function() {
		  if ($("#member_table").length ) {
			  dTable = $('#member_table').DataTable({
			  dom: "lfrtipB",
				"processing": true,
			  "serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],
			  "ajax": {
				  "url":"find_members.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.page = 'view_members';
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
					{ data: 'person_number'},
					{ data: 'Name', render: function ( data, type, full, meta ) {return full.firstname + ' ' + full.othername + ' ' + full.lastname; }},
					{ data: 'phone'},
					{ data: 'id_number'},
					{ data: 'dateofbirth', render: function ( data, type, full, meta ) {return moment(data, "YYYY-MM-DD").format('LL');}}<?php 
					if(isset($_SESSION['admin']) || isset($_SESSION['loan_officer'])){ ?>,
					{ data: 'id', render: function ( data, type, full, meta ) {  return ' <a href="member_details.php?id='+data+'" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> more </a> ';}} <?php } ?> 
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
	
	$('.table tbody').on('click', 'tr ', function () {
		var data = dTable.row(this).data();
		memberTableModel.member_details(data);
		//ajax to retrieve other member details
		findMemberDetails(data.id);
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
	
	
});
</script>