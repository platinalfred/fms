<div id="make_payment-modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Loan payment <small>&nbsp;</small></h5>
								<div class="ibox-tools">
									<a data-dismiss="modal">
										<i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content" data-bind="with: account_details">
								<form class="form-horizontal" id="loanPaymentForm" data-bind="if: typeof(interest)!='undefined'">
								  <div class="form-group">
									<label class="control-label col-md-4">Account No.</label>
									<label class="col-md-8" data-bind="text: loanNo"></label>
								  </div>
								  <div class="form-group">
									<label class="control-label col-md-4">Required PayBack Amount</label>
									<label class="col-md-8" data-bind="text: 'UGX ' + curr_format(parseInt(((parseInt(interest)/getDescription(6, repaymentsMadeEvery))+parseInt(disbursedAmount))/installments))"></label>
								  </div>
								  <div class="form-group">
									<label class="control-label col-md-4" for="payment_amount">Amount paid<span class="required">*</span></label>
									<div class="col-md-8">
									  <input type="number"  id="payment_amount" name="amount" class="form-control col-md-7 col-xs-12" data-bind='textInput: $parent.payment_amount' data-msg-required="Amount is required" required>
									  <!--input type="number"  id="payment_amount" name="amount" class="form-control col-md-7 col-xs-12" data-bind='textInput: $parent.payment_amount, attr: {"data-rule-min":(parseInt((parseInt(interest)/parseInt(installments))+parseInt(disbursedAmount)/parseInt(installments))), "data-msg-min":"Amount is less than required minimum "+(parseInt((parseInt(interest)/parseInt(installments))+parseInt(disbursedAmount)/parseInt(installments)))}' data-msg-required="Amount is required" required -->
									</div>
								  </div>
								  <div class="form-group">
									<label class="control-label col-md-4"></label>
									<div class="col-md-8">
										<i><span data-bind="text: getWords($parent.payment_amount())+' Uganda shillings only'"></span></i>
									</div>
								  </div>
								  <div class="form-group">
									<label class="control-label col-md-4" for="textarea">Comment </label>
									<div class="col-md-8">
									  <textarea id="textarea"  name="comments" class="form-control" data-bind="value: $parent.comments"></textarea>
									</div>
								  </div>
								  <div class="form-group">
									<div class="col-md-8 col-md-offset-4">
									  <button type="reset" class="btn btn-white">Cancel</button>
									  <button type="submit" class="btn btn-primary" >Submit</button>
									  <!--button type="submit" class="btn btn-primary" data-bind="enable:$parent.payment_amount()>=(parseInt((parseInt(interest)/parseInt(installments))+parseInt(disbursedAmount)/parseInt(installments)))">Submit</button !-->
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