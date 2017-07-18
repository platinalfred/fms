<div id="add_income" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 800px !important;">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							
							<div class="ibox-content">
								<form id="form" name="receive_income" class="wizard-big">
									<input name ="addedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="dateAdded" type="hidden" value="<?php echo time(); ?>">
									<input name ="tbl" type="hidden" value="add_income">
										
									<h1>Add Income Details</h1>
									<fieldset>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Income Source <span class="req">*</span></label>
													<?php $person->loadList("SELECT * FROM income_sources", "incomeSource", "id", "name"); ?>
													
												</div>
												
												<div class="form-group">
													<label>Amount Used </label><label class="req">*</label>
													<input  name="amount" type="text" class="athousand_separator form-control required">
												</div>
												<div class="form-group">
													<label>Description</label>
													<textarea  name="description" class="form-control "></textarea>
												</div>
											</div>
										</div>

									</fieldset>
									<div class="form-group">
										<div class="col-sm-6 col-sm-offset-3">
											<button class="btn btn-primary" type="submit">Submit</button>
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

            