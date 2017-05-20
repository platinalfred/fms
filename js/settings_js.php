<script>
$(document).ready(function(){

/* ====  COMMON FUNCTIONS ==== */
	
	deleteDataTableRowData();
	saveData();
	//This is an object that will hold data table names acrross the settings insterface
	var dTable = new Object();
	//With this one function all settings will be sent to save_data.php for saving
	
	//Functions being used in more than one instances / places
		/* Delete whenever a Delete Button has been clicked */
	 function deleteDataTableRowData(){
		$('.table tbody').on('click', 'tr .delete_me', function () {
			var confirmation = confirm("Are sure you would like to delete this item?");
			if(confirmation){
				var tbl;
				var id;
				var d_id = $(this).attr("id")
				var arr = d_id.split("-");
				id = arr[0];//This is the row id
				tbl = arr[1]; //This is the table to delete from 
				var dttbl = arr[2];//Table to reload
				 $.ajax({ // create an AJAX call...
					url: "delete.php?id="+id+"&tbl="+tbl, // the file to call
					success: function(response) { // on success..
						showStatusMessage(response, "success");
						setTimeout(function(){
							var dt = dTable[dttbl];
							dt.ajax.reload();
						}, 300);
					}			
				}); 
			}
		});
	}
	/* Save function called when various buttons with .save are clicked */
	function saveData(){
		$(".save").click(function(){
			var fmid = $(this).closest("form");
			var frmdata = fmid.serialize();
			var tbl_id = fmid.attr("id");
			$.ajax({
				url: "save_data.php",
				type: 'POST',
				data: frmdata,
				success: function (response) {
					if($.trim(response) == "success"){
						fmid[0].reset();
						showStatusMessage("Successfully added new record" ,"success");
						setTimeout(function(){
							var dt = dTable[tbl_id];
							dt.ajax.reload();
						}, 2000);
					}else{//"Action not successful"
						showStatusMessage(response, "failed");
					}
					
				}
			});

			return false;
		});
	}
	/*Thousands separator and creates a price format into an input */
	$('#minimum_balance, #minAmount, #maxAmount, #defmount').priceFormat({
		thousandsSeparator: '.'
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
/* ====  END COMMON FUNCTIONS ==== */
	
	$('#person_types tbody').on('click', 'tr', function () {
		row(this ).data();
        alert( 'You clicked on '+data[0]+'\'s row' );
    } );
	
	var handleDataTableButtons = function() {
		/* -- Person Type Data Table --- */
			if ($("#person_types").length) {
			  dTable['personTypeTable'] = $('#person_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  /*"serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],*/
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'person_type';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'description'},//, render: function ( data, type, full, meta ) {return full.firstname + ' ' + full.othername + ' ' + full.lastname;}
					//{ data: 'date_added', render: function ( data, type, full, meta ) {return moment(data).format('LL');}},
					
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_person_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-person_type-personTypeTable" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
	  /*-- End Person Type--*/
	  /*-- --*/
		if ($("#account_types").length) {
			  dTable['tblAccountType'] = $('#account_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  /*"serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],*/
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'account_type';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'title'},
					{ data: 'minimum_balance'},
					{ data: 'description'},
					
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-account_type-tblAccountType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
	/*End --Account Type */
	/*Branches */
	  	if ($("#branches_tbl").length) {
			  dTable['tblbranch'] = $('#branches_tbl').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  /*"serverSide": true,
			  "deferRender": true,
			  "order": [[ 1, 'asc' ]],*/
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'branch';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'branch_name'},
					{ data: 'office_phone'},
					{ data: 'email_address'},
					{ data: 'physical_address'},
					{ data: 'postal_address'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-branch-tblbranch" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*End Branches- --*/
		/*ACCESS LEVEL */
	  	if ($("#access_levels").length) {
			  dTable['tblAccessLevel'] = $('#access_levels').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'access_level';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-access_level-tblbranch" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*End Access Level- --*/
		/*INCOME SOURCES  */
	  	if ($("#income_sources").length) {
			  dTable['tblIncomeSource'] = $('#income_sources').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'income_sources';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-income_sources-tblbranch" onclick="editClick(this)"  class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END INCOME SOURCES - --*/
		/*individual types  */
	  	if ($("#individual_types").length) {
			  dTable['tblIndividualType'] = $('#individual_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'individual_types';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-individual_types-tblIndividualType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END individual_types - --*/
		/*LOAN types  */
	  	if ($("#loan_types").length) {
			  dTable['tblLoanType'] = $('#loan_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'loan_types';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-loan_types-tblLoanType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END individual_types - --*/
		/*penalty_calculations  */
	  	if ($("#penalty_calculations").length) {
			  dTable['tblPenaltyCalculation'] = $('#penalty_calculations').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'penalty_calculations';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'methodDescription'},
						{ data: 'dateCreated'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_penalty_calculation" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-penalty_calculation_method-tblPenaltyCalculation" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END penalty_calculations - --*/
		if ($("#loan_product_penalties").length) {
			  dTable['tblLoanProductPenalty'] = $('#loan_product_penalties').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'loan_product_penalties';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'description'},
						{ data: 'penalty'},
						{ data: 'penaltyChargedAs'},
						{ data: 'penaltyTolerancePeriod'},
						{ data: 'defaultAmount'},
						{ data: 'minAmount'},
						{ data: 'maxAmount'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-loan_products_penalty-tblLoanProductPenalty" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END Product PENALTY - --*/
	
		/*Loan repaymentduratio  */
	  	if ($("#loan_repayment_durations").length) {
			  dTable['tblRepaymentDuration'] = $('#loan_repayment_durations').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'loan_repayment_durations';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'no_of_days'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-repaymentduration-tblRepaymentDuration" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END loan repayment - --*/
		/*Position */
	  	if ($("#positions").length) {
			  dTable['tblPosition'] = $('#positions').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'positions';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
					{ data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-position-tblPosition" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END Position- --*/
		/*Position */
	  	if ($("#id_card_types").length) {
			  dTable['tblCardType'] = $('#id_card_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'id_card_types';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'id_type'},
			  { data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-id_card_types-tblCardType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END Position- --*/
		/*Loan Product Types */
	  	if ($("#loan_product_types").length) {
			  dTable['tblLoanProductType'] = $('#loan_product_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'loan_product_types';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'title'},
			  { data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-loan_product_types-tblLoanProductType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END Loan Product Types- --*/
		/* Security Type */
		if ($("#security_types").length) {
			  dTable['tblSecurityType'] = $('#security_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'security_types';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
			  { data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-security_types-tblSecurityType"  class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		

		/*END Sec Types- --*/
		/* Relationship Type */
		if ($("#relationship_types").length) {
			  dTable['tblRelationType'] = $('#relationship_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'relationship_types';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'rel_type'},
			  { data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_account_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-relationship_type-tblRelationType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*END relationship Types- --*/
		/* Address Type */
		if ($("#adress_types").length) {
			  dTable['tblAddressType'] = $('#adress_types').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'address_type';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'address_type'},
			  { data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edi_address_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-address_types-tblAddressType" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*End Address Types- --*/
		/* Address Type */
		if ($("#marital-status").length) {
			  dTable['tblMaritalStatus'] = $('#marital-status').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"settings_data.php",
				  "type": "JSON",
				  "type": "POST",
				  "data":  function(d){
						d.tbl = 'marital_status';
						//d.start_date = getStartDate();
						//d.end_date = getEndDate();
					}
			  },"columnDefs": [ {
				  "targets": [2],
				  "orderable": false,
				  "searchable": false
			  }/* , {
				  "targets": [0],
				  "orderable": false
			  } */],
			  "autoWidth": false,
			  columns:[ { data: 'name'},
			  { data: 'description'},
					{ data: 'id', render: function ( data, type, full, meta ) {return '<a data-toggle="modal" href="#edit_marital_status" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="'+data+'-marital_status-tblMaritalStatus" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}
					
					] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm"
				},
				{
				  extend: "csv",
				  className: "btn-sm"
				},
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
		/*End Address Types- --*/
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