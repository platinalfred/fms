<script>
<?php $relationshipTypeObj = new RelationshipType();?>
	var relationships = <?php echo json_encode($relationshipTypeObj->findAll());?>;
	
	/*MEMBER EMPLOYMENT HISTORY KO*/
	var MemberEmployment = function() {
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
		self.member_employment = ko.observableArray([new MemberEmployment()]);
		self.addEmployment = function() { self.member_employment.push(new MemberEmployment()) };
		self.removeEmployment = function(relative) {
			self.member_employment.remove(relative);
		};
		//Keeps track of member relatives, observing any changes
		self.member_relatives = ko.observableArray([new MemberRelative()]);
		//Add a relative
		self.addRelative = function() { self.member_relatives.push(new MemberRelative()) };
		//remove relative
		self.removeRelative = function(relative) {
			self.member_relatives.remove(relative);
		};
		//reset the form
		self.resetForm = function() {
			self.member_relatives.removeAll();
			self.member_employment.removeAll();
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
	ko.applyBindings(memberModel, $("#form1")[0]);
	
$(document).ready(function(){
	var dTable;
	
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
						dTable.ajax.reload();
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
		var form =  $("form[name='registration']");
		var frmdata = form.serialize();
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added new record" ,"success");
					form[0].reset();
					$('input[type="radio"]').removeAttr('checked').iCheck('update');
					dTable.ajax.reload();
				}else{
					showStatusMessage(response, "fail");
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
  
  /* PICK DATA FOR DATA TABLE  */
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
					{ data: 'id', render: function ( data, type, full, meta ) {  return ' <a href="member_details.php?id='+data+'" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> View </a> ';}} <?php } ?> 
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
	
});
</script>