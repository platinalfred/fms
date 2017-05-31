	<?php 
		$needed_files = array("iCheck", "knockout", "chosen" /* */);
		$page_title = "New Deposit Account";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
	?>
			<div class="row" id="deposit_account_form">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>New Deposit Account <small>Create new Account</small></h5>
                        </div>
                        <div class="ibox-content">
                            <form id="depAccountForm" class="form-horizontal">
                                <div class="form-group">
								<?php if(!isset($client)):?>
                                    <div class="col-sm-6">
										<label class="control-label">Customer/Member Group</label>
											<select data-placeholder="Select customer/member group..." class="form-control chosen-select" data-bind='options: customers, optionsText: "clientNames", optionsCaption: "Select customer/member group...", optionsAfterRender: setOptionValue("id"), value: client' data-msg-required="Client name is required" required>
											</select>
									</div>
								<?php endif;?>
                                    <div class="col-sm-6" data-bind='with: client'>
										<label class="control-label">Product</label>
										<select class="form-control" id="depositProduct" name="depositProduct" data-bind='options: $root.filteredDepositProducts, optionsText: "productName", optionsCaption: "Select product...", optionsAfterRender: $root.setOptionValue("id"), value: $root.depositProduct' data-msg-required="Deposit product is required" required>
										</select>
										<div data-bind="with: $root.depositProduct"><span class="help-block m-b-none"><small data-bind="text: description">Product description goes here.</small></span></div>
                                    </div>
                                </div>
								<div data-bind="with: depositProduct">
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-md-2 control-label">Interest Rate</label>
										<div class="col-md-3">
											<input type="number" class="form-control input-sm" name="interestRate" id="interestRate" data-bind="value: $root.interestRate" data-msg-minimum="Rate is lower than " data-msg-maximum="Rate is higher than "/>
											<div>
												<label class="col-sm-4" data-bind="visible: parseInt(minInterestRate)>0">Min</label>
												<label class="col-sm-2" data-bind="visible: parseInt(minInterestRate)>0, text: minInterestRate"></label>
												<label class="col-sm-4" data-bind="visible: parseInt(maxInterestRate)>0">Max</label>
												<label class="col-sm-2" data-bind="visible: parseInt(maxInterestRate)>0, text: maxInterestRate"></label>
											</div>
										</div>
										
										<div class="col-md-2"><label>Per 
										<span data-bind="text: perNoOfDays"></span> days </label></div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-md-2 control-label">Opening Balance</label>
										<div class="col-md-3">
											<input type="number" class="form-control input-sm" name="openingBal" id="openingBal" data-min="5000" data-max="20000" data-bind='value: $root.openingBal'><!-- attr: {"data-min":""},  -->
											<div>
												<label class="col-sm-4" data-bind="visible: parseInt(minOpeningBal)>0">Min</label>
												<label class="col-sm-2" data-bind="visible: parseInt(minOpeningBal)>0, text: minOpeningBal"></label>
												<label class="col-sm-4" data-bind="visible: parseInt(maxOpeningBal)>0">Max</label>
												<label class="col-sm-2" data-bind="visible: parseInt(maxOpeningBal)>0, text: maxOpeningBal"></label>
											</div>
										</div>
										<div class="col-md-7"> </div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group">
										<label class="col-md-2 control-label">Term Length <sup data-toggle="tooltip" title="Period of time before which a client can start withdrawing from the account" data-placement="right"><i class="fa fa-question-circle"></i><sup></label>
										<div class="col-md-3">
											<input type="number" class="form-control input-sm" name="termLength" id="termLength" data-bind="value: $root.termLength"/>
											<div>
												<label class="col-sm-4" data-bind="visible: parseInt(minTermLength)>0">Min</label>
												<label class="col-sm-2" data-bind="visible: parseInt(minTermLength)>0, text: minTermLength"></label>
												<label class="col-sm-4" data-bind="visible: parseInt(maxTermLength)>0">Max</label>
												<label class="col-sm-2" data-bind="visible: parseInt(maxTermLength)>0, text: maxTermLength"></label>
											</div>
										</div>
										<label class="col-md-1" data-bind='text: $root.getDescription(4, termTimeUnit)'></label>
										<div class="col-md-6"></div>
									</div>
									<div class="hr-line-dashed"></div>
									<div class="form-group" data-bind="visible: $root.productFees().length > 0">
										<div class="panel-body">
											<div class="panel-group" id="accordion">
												<div class="panel panel-default">
													<div class="panel-heading">
														<h5 class="panel-title">
															<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Applicable fees</a>
														</h5>
													</div>
													<div id="collapseOne" class="panel-collapse collapse">
														<div class="panel-body">
															<div class="table-responsive">
																<table class="table table-condensed">
																	<thead>
																		<tr>
																			<th>Name</th>
																			<th>Amount, Flat(UGX)</th>
																			<th>Trigger <sup data-toggle="tooltip" title="Method for calculating the day when the fee will be applied" data-placement="right"><i class="fa fa-question-circle"></i></sup></th>
																			<th>Date Application Method</th>
																		</tr>
																	</thead>
																	<tbody data-bind="foreach: $root.productFees">
																		<tr>
																			<td data-bind='text: feeName'></td>
																			<td data-bind='text: curr_format(amount)'></td>
																			<td data-bind='text: $root.getDescription(2, chargeTrigger)'></td>
																			<td data-bind='text: $root.getDescription(3, dateApplicationMethod)'></td>
																		</tr>
																	</tbody>
																</table>
															</div>
														</div>
													</div>
												</div>
												<div class="panel panel-default">
													<div class="panel-heading">
														<h4 class="panel-title">
															<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">Collapsible Group Item #2</a>
														</h4>
													</div>
													<div id="collapseTwo" class="panel-collapse collapse">
														<div class="panel-body">
															Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <button class="btn btn-warning" type="reset">Cancel</button>
                                        <button class="btn btn-primary" type="submit" data-bind="enable: depositProduct">Submit</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>	
<?php 
 include("include/footer.php");
include("js/depositAccount.php");
 ?>