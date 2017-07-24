
<div class="col-lg-12">
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5>Savings Accounts <small>Deposits and withdraws</small></h5>
			
		</div>
		<div class="ibox-content">
			<div class="table-responsive">
				<table id="datatable-buttons" class="table table-striped table-bordered dt-responsive nowrap">
					<thead>
						<tr>
							<?php 
							$header_keys = array("Account No", "Client", "Account type","Open Date", "Deposits(UGX)", "Withdraws(UGX)", "Actual Balance(UGX)"/* , "Action" */);
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
							<th>&nbsp;</th>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
						</tr>
					</tfoot>
				</table>
			</div>  
		</div>  
	</div>
</div>
