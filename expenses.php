<?php 
$needed_files = array("headerdaterangepicker","daterangepicker", "dataTables", "iCheck", "steps", "jasny", "moment", "knockout");
$page_title = "Expenses";
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
		<?php include("add_expense.php"); ?>
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<h2>Expenses</h2>
					<?php 
					if(isset($_SESSION['admin']) || isset($_SESSION['accountant'])){ ?>
					<div class="col-sm-12 col-lg-12 text-muted small pull-left" style="padding:10px;"><a data-toggle="modal" class="btn btn-sm btn-primary" href="#add_expense"><i class="fa fa-plus"></i> Add Expense</a></div> <?php } ?>
					<div class="clear:both;"></div>
					
					<table class="table table-striped table-hover" id="expenses">
						<thead>
							<tr>
								<th>Expense Name</th>
								<th>Expense Type</th>
								<th>Amount Used</th>
								<th>Amount Description</th>
								<th>Expense By</th>
								<th>Expense Date</th>
								<?php 
								if(isset($_SESSION['admin']) || isset($_SESSION['branch_manager'])){ ?>
									<th>Edit/Delete </th>
								<?php 
								} ?>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
						<tfoot>
							<tr>
								<th>&nbsp;Total (UGX)</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<?php
								if(isset($_SESSION['admin']) || isset($_SESSION['branch_manager'])){ ?>
									<th>&nbsp;</th>
								<?php 
								} 
								?>
							</tr>
						</tfoot>
					</table>
								
				</div>
			</div>
		</div>
	</div>
	<?php 
	
 include("include/footer.php");
 ?>
<script>
$(document).ready(function(){
	
	var  dTable;
	var handleDataTableButtons = function() {
		if ($("#expenses").length ) {
			dTable = $('#expenses').DataTable({
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
						d.page = 'view_expenses';
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
					{ data: 'expenseName'},
					{ data: 'expensetype'},
					{ data: 'amountUsed', render:function(data, type, full, meta ){ return curr_format(parseInt(data)); }},
					{ data: 'amountDescription'}, 
					{ data: 'staff_names'} , 
					{ data: 'expenseDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD MMM, YYYY');}} <?php if(isset($_SESSION['admin']) || isset($_SESSION['branch_manager'])){ ?>,
					{ data: 'id',  render: function ( data, type, full, meta ) { return  '<a id="'+data+'-expenses-expense" data-toggle="modal" href="#add_expense" class="btn  btn-info btn-sm edit_me"><i class="fa fa-edit"></i> Update </a> <a class="btn btn-sm btn-danger delete_me" id='+data +'><i class="fa fa-trash"></i> </a>'; }} <?php } ?> 
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
				}
				],

				"initComplete": function(settings, json) {
					/* ko.applyBindings(memberTableModel, $("#member_details")[0]);
					$(".table tbody>tr:first").trigger('click'); */
				},
				  "footerCallback": function (tfoot, data, start, end, display ) {
					var api = this.api(), cols = [2];
					$.each(cols, function(key, val){
						var total = api.column(val).data().sum();
						$(api.column(val).footer()).html( curr_format(total) );
					});
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
	/* Editing   */
		$('#expenses').on('click', 'tr .edit_me', function () {
			//id="'+data+'-person_type-personTypeTable" 
			var tbl, id , frm, dt;
			var d_id = $(this).attr("id");
			var arr = d_id.split("-");
			id = arr[0]; //The  row id 
			tbl = arr[1]; // The table , 
			frm = arr[2]; //The form id
			dt = dTable;
			
			var row = $(this).parent().parent(); 
			edit_data(dt.row(row).data(), frm);
			
		});
	$('#expenses').on('click', 'tr .delete_me', function () {
		var id = $(this).attr("id");
		$.confirm({
			icon: 'fa fa-warning',
			title: 'Confirm!',
			 boxWidth: '30%',
			content: 'Are you sure you would like to delete this expense?',
			typeAnimated: true,
			buttons: {
				Delete: {
					text: 'Delete',
					btnClass: 'btn-danger',
					action: function(){
						
						$.ajax({
							url: "ajax_requests/delete.php?tbl=expense&id="+id,
							type: 'GET',
							success: function (response) {
								if($.trim(response) == "success"){
									showStatusMessage("Expense successfully deleted." ,"success");
									setTimeout(function(){
										dTable.ajax.reload();
										return true;
									}, 4000);
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
	/*$('#expenses').on('click', 'tr .edit_expense', function () {
		var id = $(this).attr("id")
		 $('#DescModal').removeData('bs.modal');
        $('#DescModal').modal({remote: 'edit_group.php?id=' + id });
        $('#DescModal').modal('show');
	});*/
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
	$("form[name='register_expense']").validate({
		// Specify validation rules
		rules: {
		  // The key name on the left side is the name attribute
		  // of an input field. Validation rules are defined
		  // on the right side
		  expenseName: "required",
		  amountUsed: "required"
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		  
		},
		// Specify validation error messages
		messages: {
		  amountUsed: "Please give the expense amount.",
		  expenseName: "Please give a name to this expense",
		},
		// Make sure the form is submitted to the destination defined
		// in the "action" attribute of the form when valid
		submitHandler: function(form, event) {
			event.preventDefault();
			var form =  $("form[name='register_expense']");
			var frmdata = form.serialize();
			$.ajax({
				url: "ajax_requests/save_data.php",
				type: 'POST',
				data: frmdata,
				success: function (response) {
					if($.trim(response) == "success"){
						showStatusMessage("Expense successfully saved." ,"success");
						form[0].reset();
						dTable.ajax.reload();
					}else if($.trim(response) == "updated"){
						showStatusMessage("Expense successfully updated." ,"success");
						dTable.ajax.reload();
						setTimeout(function(){
							$('#add_expense').modal('toggle');
						},3000);
					}else{
						showStatusMessage(response, "fail");
					}
					
				}
			});
		}
	});
})	
</script>