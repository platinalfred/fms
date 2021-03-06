<div id="enter_deposit" class="modal fade" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Enter Deposit <small>Savings</small></h5>
								<div class="ibox-tools">
									<a data-dismiss="modal">
										<i class="fa fa-times req"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<form class="form-horizontal" id="enterDepositForm">
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4">Account No.
									</label>
									<label class="col-md-8" data-bind="text: account_no">
									</label>
								  </div>			
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4" for="amount">Amount<span class="required">*</span></label>
									<div class="col-md-8">
									  <input type="number"  id="deposit_amount" name="amount" class="form-control col-md-7 col-xs-12 athousand_separator" data-bind='textInput: $parent.deposit_amount, attr: {"data-rule-min":(parseFloat(recomDepositAmount)>0?recomDepositAmount:null), "data-msg-min":"Amount is less than recommended "+recomDepositAmount' data-msg-required="Amount is required" required>
									</div>
								  </div>
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4" for="amount">Amount Description<span class="required">*</span></label>
									<div class="col-md-8">
										<i><span data-bind="text: getWords($parent.deposit_amount())"></span>Uganda Shillings Only</i>
									</div>
								  </div>
								  <div class="form-group" data-bind="with: account_details">
									<label class="control-label col-md-4" for="textarea">Deposited By </label>
									<div class="col-md-8">
									  <textarea id="textarea"  name="comments" class="form-control" data-bind="value: $parent.comments"></textarea>
									</div>
								  </div>
								  <div class="form-group">
									<div class="col-md-8 col-md-offset-4 ">
									  <button type="submit" class="btn btn-primary pull-right ladda" data-style="contract">Deposit</button>
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