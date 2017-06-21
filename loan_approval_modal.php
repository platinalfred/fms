<div id="approve_loan-modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Loan account approval <small>&nbsp;</small></h5>
								<div class="ibox-tools">
									<a data-dismiss="modal">
										<i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<form class="form-horizontal" id="loanAccountApprovalForm">
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4">Account No.</label>
									<label class="col-md-8" data-bind="text: loanNo"></label>
								  </div>
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4">Amount requested</label>
									<label class="col-md-8" data-bind="text: 'UGX ' + curr_format(parseInt(requestedAmount))"></label>
								  </div>			
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4" for="amountApproved">Amount approved<span class="required">*</span></label>
									<div class="col-md-8">
									  <input type="number"  id="amountApproved" name="amountApproved" class="form-control col-md-7 col-xs-12" data-bind='value: $parent.amountApproved, attr: {"data-rule-max":requestedAmount, "data-msg-max":"Amount cannot be greater than requested amount"}' data-msg-required="Enter approved amount" required>
									</div>
								  </div>
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4"></label>
									<div class="col-md-8">
										<i><span data-bind="text: getWords($parent.amountApproved())+' Uganda shillings only'"></span></i>
									</div>
								  </div>
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4" for="textarea">Justification </label>
									<div class="col-md-8">
									  <textarea id="approvalNotes"  name="approvalNotes" class="form-control" data-bind="value: $parent.approvalNotes"></textarea>
									</div>
								  </div>
								  <div class="form-group">
									<div class="col-md-8 col-md-offset-4">
									  <button type="reset" class="btn btn-white">Cancel</button>
									  <button type="submit" class="btn btn-primary">Submit</button>
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