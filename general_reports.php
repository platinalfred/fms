			
			<div class="col-lg-12">
				<div class="ibox-content m-b-sm border-bottom">
					<div class="row">
						<div class="col-sm-4">
							<div class="form-group">
								<label class="control-label" for="product_name">Loan Product</label>
								<?php $person = new Person; $person->loadList("SELECT * FROM loan_products", "product_name", "id", "productName", "", "selected"); ?>
								
							</div>
						</div>
						<div class="col-sm-2">
							<div class="form-group">
								<label class="control-label" for="principle">Loan Amount</label>
								<input type="text" id="principle" name="loan" value="" placeholder="" class="form-control">
							</div>
						</div>
						<div class="col-sm-2">
							<div class="form-group">
								<label class="control-label" for="loan_status">Loan Status</label>
								<select name="status" id="status" class="form-control">
									<option></option>
									<option value="1" >Accepted</option>
									<option value="0" >Pending</option>
									<option value="2" >Disbursed</option>
									<option value="3">Rejected</option>
									<option value="4">Settled</option>
								</select>
							</div>
						</div>
						<div class="col-sm-4">
							<div class="form-group">
								<label class="control-label" for="status">More</label>
								<select name="status" id="status" class="form-control">
									<option ></option>
									<option value="1" >Outstanding Principal</option>
									<option value="0">Outstanding Interest</option>
									<option value="2">Outstanding loan balance</option>
								</select>
							</div>
						</div>
					</div>

				</div>
				<div class="ibox">
					<div class="ibox-title" style="border-top:none;">
						<h5>Loan Accounts</h5>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-down"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content collapse in">
						<div class="table-responsive">
							<table id="loan_report" class="table table-bordered">
								<thead>
									<tr>
										<?php 
										$header_keys = array("SNo.", "Member", "Amount", "No. of Installments", "Principle", "Interest", "Total Interest Expected", "Other", "Loan application fees", "No of installments paid", "Bal of installments", "Principal paid", "Interest paid", "Misc Income", "Outstanding Principal", "Outstanding Interest", "outstanding loan balance");
										foreach($header_keys as $key){ ?>
											<th><?php echo $key; ?></th>
											<?php 
										} ?>
									</tr>
								</thead>
								<tbody>
								</tbody>
								<tfoot>
								<?php 
									foreach($header_keys as $key){ ?>
										<th><?php echo ""; ?></th>
										<?php 
									}
								?>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>