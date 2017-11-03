
<div id="add_shares" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-title">
								<h2>
									Buy Share
								</h2>
							</div>
							<div class="ibox-content">
								<form id="form" name="register_group" action="" method="post" class="wizard-big">
									<?php 
									$shares = new Shares();
									$rate = $shares->findShareRate();
									?>
									<input name ="recordedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="memberId" type="hidden" value="<?php echo $_GET['memberId']; ?>">
									<input name ="datePaid" type="hidden" value="<?php echo time(); ?>">
									<input name ="share_rate" type="hidden" value="<?php echo $rate['id']; ?>">
									<input type="hidden" id="rate_amount" name="" value="<?php echo $rate['amount']; ?>">
									<input name ="tbl" type="hidden" value="add_share">
									<fieldset>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label  for="amount">Number of Shares<span class="required">*</span></label>
													<input type="number"  name="noShares" id="no_of_shares"  required="required" class="form-control">
												</div>
												<div class="form-group">
													<label  for="paid_by">Share Amount</label>
													<input type="text"  id="share_amount" name="amount"  readonly="readonly" class="form-control">
														<p id="share_rate_amount"></p>
												</div>
												<div class="form-group">
													<label  for="paid_by">Paid By<span class="required">*</span>
													</label>
													<input type="text"  name="paid_by"  class="form-control">
												</div>
												<div class="form-group">
													<label  for="telephone">Received By
													</label>
													<input type="text" disabled="disabled" name="received_by"  value="<?php echo $member->findMemberNames($_SESSION['personId']); ?>" class="form-control">
													
												</div>
												
											</div>
										</div>

									</fieldset>
									<div class="form-group">
										<div class="col-sm-6 col-sm-offset-3">
											<button class="btn btn-primary add_share" type="submit">Submit</button>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>      