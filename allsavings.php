
<div class="col-lg-12">
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<div class="row">
				<div class="col-sm-12">
					<h5>Savings Accounts <small>Deposits and withdraws</small></h5>
				</div>
				<div class="col-sm-2">
					<div class="form-group">
						<select id="client_type" class="form-control">
							<option value="0" <?php echo isset($_GET['cat'])?(($_GET['cat']==1)?'selected':''):'selected';?>>Client Type</option>
						   <option value="1" <?php echo (isset($_GET['cat'])&&$_GET['cat']==2)?'selected':'';?>>Individual Loans</option>
							<option value="2" <?php echo (isset($_GET['cat'])&&$_GET['cat']==3)?'selected':'';?>>Group Loans</option>
						</select >
					</div>
				</div>
				<div class="col-sm-10">
				</div>
			</div>
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
