<div id="enter_withdraw" class="modal fade" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Withdraw cash<small> from savings account</small></h5>
								<div class="ibox-tools">
									<a data-dismiss="modal">
										<i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<form class="form-horizontal form-label-left" id="enterWithdrawForm">
									  <div class="form-group" data-bind="with: account_details">
										<label class="control-label col-md-4" for="name">Account No.
										</label>
										<label class="col-md-8" data-bind="text: (productName+ '-' + id).replace(/\s/g,'')">
										</label>
									  </div>	
									  <div class="form-group" data-bind="with: account_details">
										<label class="control-label col-md-4" for="name">Withdraw limit
										</label>
										<label class="col-md-8" data-bind="text: 'UGX '+curr_format(maxWithdrawalAmount)">
										</label>
									  </div>			
									  <div class="form-group" data-bind="with: account_details">
										<label class="control-label col-md-4" for="amount">Amount<span class="required">*</span></label>
										<div class="col-md-8">
										  <input type="number"  id="deposit_amount" name="amount"  required class="form-control col-md-7 col-xs-12" data-bind='value: $parent.deposit_amount, attr: {"data-rule-max": (parseFloat(maxWithdrawalAmount)>0?maxWithdrawalAmount:null), "data-msg-max":"Amount is more than maximum allowed "+maxWithdrawalAmount}' data-msg-required="Amount is required">
										</div>
									  </div>
									  <div class="form-group" data-bind="with: account_details">
										<label class="control-label col-md-4" for="amount">Amount Description<span class="required">*</span></label>
										<div class="col-md-8">
											<i><span data-bind="text: getWords($parent.deposit_amount())"></span></i>
										</div>
									  </div>
									  <div class="form-group" data-bind="with: account_details">
										<label class="control-label col-md-4" for="textarea">Comment </label>
										<div class="col-md-8">
										  <textarea id="textarea"  name="comments" class="form-control" data-bind="value: $parent.comments"></textarea>
										</div>
									  </div>
									  <div class="ln_solid"></div>
									  <div class="form-group">
										<div class="col-md-8 col-md-offset-4">
										  <button type="button" class="btn btn-white">Cancel</button>
										  <button type="button" class="btn btn-primary">Withdraw</button>
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