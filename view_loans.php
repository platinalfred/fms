	<?php 
		$needed_files = array("iCheck", "knockout", "daterangepicker", "moment", "dataTables");
		$page_title = "Loan Accounts";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
	?>
			<div class="row" id="deposit_account_form">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Loan Accounts <small>loans list</small></h5>
						  <div class="pull-right">
							<select id="loan_types" class="form-control">
							  <option>All loans</option>
							  <option value="1" <?php echo (isset($_GET['type'])&&$_GET['type']==1)?"selected":"";?>>Performing loans</option>
							  <option value="2" <?php echo (isset($_GET['type'])&&$_GET['type']==2)?"selected":"";?>> Non Performing</option>
							  <option value="3" <?php echo (isset($_GET['type'])&&$_GET['type']==3)?"selected":"";?>> Active loans</option>
							  <option value="4" <?php echo (isset($_GET['type'])&&$_GET['type']==4)?"selected":"";?>> Due loans</option>
							</select>
						  </div>
                        </div>
                        <div class="ibox-content">
							<table id="datatable-buttons" class="table table-striped table-bordered dt-responsive nowrap">
								<thead>
									<tr>
										<?php 
										$header_keys = array("Loan No", "Client", "Loan Product","Appn. Date", "Requested Amount");
										foreach($header_keys as $key){ ?>
											<th><?php echo $key; ?></th>
											<?php
										}
										?>
									</tr>
								</thead>
								<tbody>
								</tbody>
								<tfoot>
									<tr>
										<th colspan="4">Total (UGX)</th>
										<!--th>&nbsp;</th>
										<th>&nbsp;</th>
										<th>&nbsp;</th>
										<th>&nbsp;</th-->
										<th>&nbsp;</th>
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
<!-- Datatables -->
<script>
	$(document).ready(function() {
	var handleDataTableButtons = function() {
	  if ($("#datatable-buttons").length) {
		dTable = $('#datatable-buttons').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "processing": true,
		  "serverSide": true,
		  "deferRender": true,
		  "ajax": {
			  "url":"server_processing.php",
			  "type": "POST",
			  "data":  function(d){
				d.page = 'view_loans';
				d.type = <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>; //loan_type for the datatable;
				d.start_date = <?php echo isset($_GET['s_dt'])?"'{$_GET['s_dt']}'":"moment().subtract(30, 'days').format('YYYY-MM-DD')"; ?>;
				d.end_date = <?php echo isset($_GET['e_dt'])?"'{$_GET['e_dt']}'":"moment().format('YYYY-MM-DD')"; ?>;
				}
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api(), cols = [4];
			$.each(cols, function(key, val){
				var total = api.column(val).data().sum();
				$(api.column(val).footer()).html( curr_format(total) );
			});
		  },columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.client_id+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}
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
		  responsive: true/*, */
		  
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