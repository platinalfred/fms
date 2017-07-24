			
			<div class="col-lg-12">
		
				<div class="ibox">
					<div class="ibox-title" style="border-top:none;">
						<div class="row">
							<div class="col-sm-2">
								<div class="form-group">
									<select id="loan_type" class="form-control">
										<option value="1" <?php echo isset($_GET['cat'])?(($_GET['cat']==1)?'selected':''):'selected';?>>All </option>
									   <option value="2" <?php echo (isset($_GET['cat'])&&$_GET['cat']==2)?'selected':'';?>>Individual Loans</option>
										<option value="3" <?php echo (isset($_GET['cat'])&&$_GET['cat']==3)?'selected':'';?>>Group Loans</option>
									</select >
								</div>
							</div>
							<div class="col-sm-3">
									<select id="loan_category" class="form-control">
										<option value="1" <?php echo isset($_GET['cat'])?(($_GET['cat']==1)?'selected':''):'selected';?>>All loans</option>
										<option value="4" <?php echo (isset($_GET['cat'])&&$_GET['cat']==4)?'selected':'';?>>Active Loans</option>
										<option value="5" <?php echo (isset($_GET['cat'])&&$_GET['cat']==5)?'selected':'';?>>Performing Loans</option>
										<option value="6" <?php echo (isset($_GET['cat'])&&$_GET['cat']==6)?'selected':'';?>>Non Performing Loans</option>
										<option value="7" <?php echo (isset($_GET['cat'])&&$_GET['cat']==7)?'selected':'';?>>Due Loans</option>
									</select >
							</div>
							<div class="col-sm-7">
							</div>
						</div>

					</div>
					<div class="ibox-content collapse in">
						<div class="table-responsive">
							<table id="loan_report" class="table table-bordered">
								<thead>
									<tr>
										<?php 
										$header_keys = array("SNo.", "Member", "Amount", "Principle", "Interest", "Total Interest Expected", "Loan application fees", "No of installments paid", "Bal of installments", "Principal paid", "Interest paid", "Outstanding Principal", "Outstanding Interest", "outstanding loan balance", "Misc Income", "Amount paid");
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