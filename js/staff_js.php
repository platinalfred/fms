<script>


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
					dTable.ajax.reload();
				}else{
					showStatusMessage(response, "fail");
				}
				
			}
		});
    }
  });
	
	var Member = function(){
		var self = this;
		self.member_details = ko.observable();
		self.member_relatives = ko.observableArray();
		self.member_employers = ko.observableArray();
	}
	var memberModel = new Member();
  
  /* PICK DATA FOR DATA TABLE  */
	var handleDataTableButtons = function() {
		  if ($("#staffTable").length ) {
			  dTable = $('#staffTable').DataTable({
			  dom: "lfrtipB",
				"processing": true,
			  "serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],
			  "ajax": {
				  "url":"find_staff.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.page = 'view_staff';
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
					{ data: 'dateofbirth', render: function ( data, type, full, meta ) {return moment(data, "YYYY-MM-DD").format('LL');}},
					{ data: 'id', render: function ( data, type, full, meta ) {  return '<a href="member_details.php?id='+data+'" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> View </a> ';}}
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
			  responsive: true,
			   "initComplete": function(settings, json) {
					ko.applyBindings(memberModel, $("#member_details")[0]);
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
		//console.log(data);
		memberModel.member_details(data);
		//ajax to retrieve other member details
		//memberModel.member_employers(data.member_employers);
		//memberModel.member_relatives(data.member_relatives);
	});
	
});
</script>