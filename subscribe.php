
<div id="add_subscription" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-title">
								<h2>
									Subscribe
								</h2>
							</div>
							<div class="ibox-content">
								<form id="form" name="register_group" action="" method="post" class="wizard-big">
									<input name ="receivedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="memberId" type="hidden" value="<?php echo $member_data['id']; ?>">
									<input name ="datePaid" type="hidden" value="<?php echo time(); ?>">
									<input name ="tbl" type="hidden" value="add_subscription">
									<fieldset>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label >Subscription Amount<span class="required">*</span>
													</label>
													<input type="number" onkeyup = "return curr_format(this);" name="amount"  required="required" class="form-control">
												</div>
												<div class="form-group">
													<label  for="textarea">Subscription Year <span class="required">*</span>
													</label>
													<select class="form-control" name="subscriptionYear">
														<?php 
														for($i = 0; $i < 5; $i++){ 
															$year = date('Y', strtotime('+'.$i.' year'));
															if(!$subscription->isSubscribedForYear($member_data['id'], $year)){
																?>
																<option value="<?php echo $year; ?>" ><?php echo $year; ?> </option>
																<?php
															}
														}
														?>
													</select>
												
												</div>
												<div class="form-group">
													<label  for="telephone">Received By
													</label>
													<input type="text" disabled="disabled" name="addedBy"  value="<?php echo $member->findMemberNames($_SESSION['personId']); ?>" class="form-control">
													
												</div>
												
											</div>
										</div>

									</fieldset>
									<div class="form-group">
										<div class="col-sm-6 col-sm-offset-3">
											<button class="btn btn-primary save" type="submit">Submit</button>
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
<script>

</script>         