<script>
$(document).ready(function(){
	
	var dTable;
	$('#staffTable').on('click', 'tr .edit', function () {
		var id = $(this).attr("id")
		 $('#DescModal').removeData('bs.modal');
        $('#DescModal').modal({remote: 'edit_staff.php?id=' + id });
        $('#DescModal').modal('show');
		$('#DescModal').on('hidden.bs.modal', function () {
			dTable.ajax.reload();
		});
    });
	$(".save").click(function(){
		var frmdata = $(this).closest("form").serialize();
		$.ajax({
			url: "ajax_requests/save_data.php",
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
			minlength: 7
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
		enableDisableButton(form, true);
		var form =  $("form[name='registration']");
		var frmdata = form.serialize();
		$.ajax({
			url: "ajax_requests/save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					showStatusMessage("Successfully added new record" ,"success");
					form[0].reset();
					$('input[type="checkbox"]').removeAttr('checked').iCheck('update');
					dTable.ajax.reload();
				}else{
					showStatusMessage(response, "fail");
				}
				enableDisableButton(form, false);
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
		var post_data = new Object();
		  if ($("#staffTable").length ) {
			  dTable = $('#staffTable').DataTable({
			  dom: "lfrtipB",
				"processing": true,
			  "serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],
			  "ajax": {
				  "url":"ajax_requests/find_data.php",
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
					{ data: 'id', render: function ( data, type, full, meta ) {return "  "+data; }},
					{ data: 'person_number'},
					{ data: 'username'},
					{ data: 'name'},
					{ data: 'Names', render: function ( data, type, full, meta ) {return full.firstname + ' ' + full.othername + ' ' + full.lastname; }},
					{ data: 'phone'},
					{ data: 'id_number'},
					{ data: 'dateofbirth', render: function ( data, type, full, meta ) {return moment(data, "YYYY-MM-DD").format('LL');}},
					{ data: 'status', render: function ( data, type, full, meta ) { if(data==1){return "<span class='label label-primary'>Active</span>"; }else{return "<span class='label label-danger activate' id="+ full.id +" style='cursor:pointer;'>Inactive</span>";} }},
					{ data: 'id', render: function ( data, type, full, meta ) {  return '<a  id='+data +' class="btn btn-white btn-sm edit"><i class="fa fa-pencil"></i> Edit </a> <a class="btn btn-sm btn-danger delete" id='+data +'><i class="fa fa-trash"></i> </a>';}}
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5, 6,7,8]
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
						columns: [ 0, 1, 2,3,4,5, 6,7,8]
					}
				},
				{
				  extend: "pdfHtml5",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5, 6,7,8]
					}
				},
				{
				  extend: "print",
				  className: "btn-sm",
				  exportOptions: {
						columns: [ 0, 1, 2,3,4,5, 6,7,8]
					}
				},
			  ],/* ,
			  responsive: {
				details: {
					display: $.fn.dataTable.Responsive.display.modal( {
						header: function ( row ) {							
							var data = row.data();
							return 'Showing details for '+data.firstname+' '+data.lastname;
						}
					} ),
					renderer: $.fn.dataTable.Responsive.renderer.tableAll( {
						tableClass: 'table'
					} )
				}
			}, */
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
	$('.table tbody').on('click', 'tr .activate', function () {
		var id = $(this).attr("id");
		$.confirm({
			icon: 'fa fa-warning',
			title: 'Confirm!',
			 boxWidth: '30%',
			content: 'Are you sure you would like to activate this staff?',
			typeAnimated: true,
			buttons: {
				Delete: {
					text: 'Activate',
					btnClass: 'btn-info',
					action: function(){
						$.ajax({ // create an AJAX call...
							url: "ajax_requests/delete.php?id="+id+"&tbl=staff&status=activate", // the file to call
							success: function(response) { // on success..
								if(response != "fail"){
									showStatusMessage("Staff has been activated.", "success");
									setTimeout(function(){
										dTable.ajax.reload();
									}, 1000);
								}else{
									showStatusMessage(response, "warning");
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
	$('.table tbody').on('click', 'tr .delete', function () {
		var id = $(this).attr("id");
		$.confirm({
			icon: 'fa fa-warning',
			title: 'Confirm!',
			 boxWidth: '30%',
			content: 'Are you sure you would like to delete this staff?',
			typeAnimated: true,
			buttons: {
				Delete: {
					text: 'Delete',
					btnClass: 'btn-danger',
					action: function(){
						$.ajax({ // create an AJAX call...
							url: "ajax_requests/delete.php?id="+id+"&tbl=staff", // the file to call
							success: function(response) { // on success..
								if(response != "fail"){
									showStatusMessage("Staff has been deleted.", "success");
									setTimeout(function(){
										dTable.ajax.reload();
									}, 1000);
								}else{
									showStatusMessage(response, "warning");
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
});
</script>