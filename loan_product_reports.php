			
			<div class="col-lg-12">
		
				<div class="ibox">
					<div class="ibox-content collapse in">
						<div class="table-responsive">
							<table id="loan_product_report" class="table table-bordered">
								<thead>
									<tr>
										<?php 
										$header_keys = array("Product", "Amount Disbursed", "Interest", "Amount Paid", "Balance");
										foreach($header_keys as $key){ ?>
											<th><?php echo $key; ?></th>
											<?php 
										} ?>
									</tr>
								</thead>
								<tbody>
									
								</tbody>
								<tfoot>
									<tr>
								<?php 
									foreach($header_keys as $key){ ?>
										<th><?php echo ""; ?></th>
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