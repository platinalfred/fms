<?php 
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment");
$page_title = "Members";
include("include/header.php"); 
require_once("lib/Libraries.php");
$member = new Member();
?>
	<div class="row">
		<?php include("add_member_modal.php"); ?>
		<div class="col-sm-8">
			<div class="ibox">
				<div class="ibox-content">
					<span class="text-muted small pull-right">Last modification: <i class="fa fa-clock-o"></i> 2:10 pm - 12.06.2014</span>
					<h2>Members & Member Groups</h2>
					
					<div class="col-sm-5 text-muted small pull-left" style="padding:10px;"><a data-toggle="modal" class="btn btn-primary" href="#add_member"><i class="fa fa-plus"></i> Add Member</a></div>
					<div class="clear:both;"></div>
					<div class="input-group">
						<input type="text" placeholder="Search client " class="input form-control">
						<span class="input-group-btn">
							<button type="button" class="btn btn btn-primary"> <i class="fa fa-search"></i> Search Member</button>
						</span>
					</div>
					<div class="clients-list">
					<ul class="nav nav-tabs">
						<span class="pull-right small text-muted">1406 Elements</span>
						<li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-user"></i> Members</a></li>
					</ul>
					<div class="tab-content">
						<div id="tab-1" class="tab-pane active">
							<div class="full-height-scroll" style="margin-top:10px;">
								<div class="table-responsive">
									<table class="table table-striped table-hover" id="member_table">
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
		</div>
		<div class="col-sm-4">
			<div class="ibox ">
				<div class="ibox-content">
					<div class="tab-content">
						<div id="contact-1" class="tab-pane active">
							<div class="row m-b-lg">
								<div class="col-lg-4 text-center">
									<h2>Nicki Smith</h2>

									<div class="m-b-sm">
										<img alt="image" class="img-circle" src="img/a2.jpg"
											 style="width: 62px">
									</div>
								</div>
								<div class="col-lg-8">
									<strong>
										About me
									</strong>

									<p>
										Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
										tempor incididunt ut labore et dolore magna aliqua.
									</p>
									<button type="button" class="btn btn-primary btn-sm btn-block"><i
											class="fa fa-envelope"></i> Send Message
									</button>
								</div>
							</div>
							<div class="client-detail">
							<div class="full-height-scroll">

								<strong>Last activity</strong>

								<ul class="list-group clear-list">
									<li class="list-group-item fist-item">
										<span class="pull-right"> 09:00 pm </span>
										Please contact me
									</li>
									<li class="list-group-item">
										<span class="pull-right"> 10:16 am </span>
										Sign a contract
									</li>
									<li class="list-group-item">
										<span class="pull-right"> 08:22 pm </span>
										Open new shop
									</li>
									<li class="list-group-item">
										<span class="pull-right"> 11:06 pm </span>
										Call back to Sylvia
									</li>
									<li class="list-group-item">
										<span class="pull-right"> 12:00 am </span>
										Write a letter to Sandra
									</li>
								</ul>
								<strong>Notes</strong>
								<p>
									Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
									tempor incididunt ut labore et dolore magna aliqua.
								</p>
								<hr/>
								<strong>Timeline activity</strong>
								<div id="vertical-timeline" class="vertical-container dark-timeline">
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-coffee"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>Conference on the sales results for the previous year.
											</p>
											<span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-briefcase"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>Many desktop publishing packages and web page editors now use Lorem.
											</p>
											<span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-bolt"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>There are many variations of passages of Lorem Ipsum available.
											</p>
											<span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon navy-bg">
											<i class="fa fa-warning"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>The generated Lorem Ipsum is therefore.
											</p>
											<span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-coffee"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>Conference on the sales results for the previous year.
											</p>
											<span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon gray-bg">
											<i class="fa fa-briefcase"></i>
										</div>
										<div class="vertical-timeline-content">
											<p>Many desktop publishing packages and web page editors now use Lorem.
											</p>
											<span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
										</div>
									</div>
								</div>
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
function RemoveRougeChar(convertString){
    
    
    if(convertString.substring(0,1) == ","){
        
        return convertString.substring(1, convertString.length)            
        
    }
    return convertString;
    
}

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
	$("#monthlySalary").keyup(function(event){
		  // skip for arrow keys
		  if(event.which >= 37 && event.which <= 40){
			  event.preventDefault();
		  }
		  var input = $(this);
		  var num = input.val().replace(/,/gi, "").split("").reverse().join("");
		  
		  var num2 = RemoveRougeChar(num.replace(/(.{3})/g,"$1,").split("").reverse().join(""));
		  
		  console.log(num2);
		  // the following line has been simplified. Revision history contains original.
		  input.val(num2);
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
  $('.table tbody').on('click', 'tr', function () {
		$(this).attr("id");
		
	});
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
					{ data: 'dateofbirth', render: function ( data, type, full, meta ) {return moment(data).format('LL');}}
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
		
});
</script>
