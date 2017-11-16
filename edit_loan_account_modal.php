
<div id="edit_loan_account-modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-body">
			<div class="row" id="loan_account_form">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Loan Account <small>Update details</small></h5>
                            <div class="ibox-tools">
                                <a data-dismiss="modal">
                                    <i class="fa fa-times lg"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content" data-bind="with: account_details">
                            <form id="editLoanAccountForm" class="form-horizontal wizard-big" method="post" enctype="multipart/form-data">
								<input type='hidden' name="origin" value="loan_account"/>
                                <h3>Account Information</h3>
									<div class="row">
										<fieldset>
											<input type='hidden' name="clientType" data-bind="attr:{'value':(groupLoanAccountId&&groupLoanAccountId>0)?2:1}"/>
											<!--ko if:(groupLoanAccountId&&groupLoanAccountId>0)-->
												<div class="form-group">
													<div class="col-md-6">
														<label class="col-sm-3">Group</label>
														<label class="col-sm-8" data-bind="text: groupName">Group</label>
														<input type='hidden' name="groupId" data-bind="attr:{'value':groupId}"/>
														<input type='hidden' data-bind="attr:{'value':groupLoanAccountId}" name="loanAccount[groupLoanAccountId]'}"/>
													</div>
												</div>	
											<!--/ko-->
											<div class="form-group">
												<div class="col-md-4">
													<!--ko if:!(groupLoanAccountId&&groupLoanAccountId>0) -->
													<label class="control-label">Product</label>
													<select class="form-control" id="loanProductId2" name="loanAccount[loanProductId]" data-bind='options: $root.loanProducts, optionsText: "productName", optionsCaption: "Select product...", optionsAfterRender: $root.setOptionValue("id"), value: $root.loanProduct2' data-msg-required="Loan product is required" required>
													</select>
													<!--/ko-->
													<!--ko if:(groupLoanAccountId&&groupLoanAccountId>0) -->
													<span data-bind="with: $root.loanProduct2">
														<input type="hidden" id="loanProductId" name="loanAccount[loanProductId]" data-bind="attr:{value:id}"/>
														<label class="control-label" data-bind="text: productName">Product</label>
													</span>
													<!--/ko-->
													<span class="help-block m-b-none" data-bind="with: $root.loanProduct2">
														<small data-bind="text: description">Product description goes here.</small>
													</span>
												</div>
												<div class="col-md-4" data-bind="with: $root.loanProduct2">
													<label class="control-label">Application Date</label>
													<div class="input-group date" data-provide="datepicker"data-date-format="dd-mm-yyyy" data-date-end-date="<?php echo date('d-m-Y');?>">
														<input type="text" class="form-control" name="applicationDate" data-bind="value:moment($parent.applicationDate,'X').format('DD-MM-YYYY')" required>
														<div class="input-group-addon">
															<span class="fa fa-calendar"></span>
														</div>
													</div>
												</div>
											</div>		
										</fieldset>
										<?php if(!isset($client)):?>
										<?php endif;?>
<div class="hr-line-dashed"></div>
<div data-bind='with: $root.loanAccount2'>
	<div class="ibox float-e-margins">
		<div class="ibox-title">
			<h5 data-bind="text: ((typeof(clientNames)!='undefined')?clientNames:((typeof(clientNames)!='undefined')?clientNames:'')) + '('+loanNo+')'">member</h5>
			<div class="ibox-tools">
				<input type='hidden' data-bind="value:((typeof(memberId)!='undefined')?memberId:id), attr:{'name':'loanAccount[memberId]'}"/>
				<input type='hidden' data-bind="value:id, attr:{'name':'loanAccount[id]'}"/>
			</div>
		</div>
		<div class="ibox-content">
			<div class="row">
				<div data-bind="with: $root.loanProduct2">
					<div class="hr-line-dashed"></div>
					<!-- Settings adapted from the product -->
					<input type='hidden' data-bind="value:initialAccountState, attr:{'name':'loanAccount[status]'}"/>
					<input type='hidden' data-bind="value:repaymentsFrequency, attr:{'name':'loanAccount[repaymentsFrequency]'}"/>
					<input type='hidden' data-bind="value:repaymentsMadeEvery, attr:{'name':'loanAccount[repaymentsMadeEvery]'}"/>
					<div class="form-group">
						<label class="col-md-3 control-label">Loan Amount</label>
						<div class="col-md-3">
							<input type="number"  class="form-control input-sm" data-bind='textInput: $parent.requestedAmount2, attr: {"data-rule-min":((parseFloat(minAmount)>0&&$root.clientType==1)?minAmount:null), "data-rule-max": ((parseFloat(maxAmount)>0&&$root.clientType==1)?maxAmount:null), "data-msg-min":"Loan amount is less than "+curr_format(parseInt(minAmount)), "data-msg-max":"Loan amount is more than "+curr_format(parseInt(maxAmount)),"name":"loanAccount[requestedAmount]"}'/>
							<div>
								<label class="col-sm-2" data-bind="visible: (parseFloat(minAmount)>0&&$root.clientType==1)">Min</label>
								<label class="col-sm-4" data-bind="visible: (parseFloat(minAmount)>0&&$root.clientType==1), text: curr_format(parseInt(minAmount))"></label>
								<label class="col-sm-2" data-bind='visible: (parseFloat(maxAmount)>0&&$root.clientType==1)'>Max</label>
								<label class="col-sm-4" data-bind="visible: (parseFloat(maxAmount)>0&&$root.clientType==1), text: curr_format(parseInt(maxAmount))"></label>
							</div>
						</div>
						<label class="col-md-3 control-label">Interest Rate</label>
						<div class="col-md-3">
							<input type="number" class="form-control input-sm" data-bind='textInput: $parent.interestRate2, attr: { value:defInterest,"name":"loanAccount[interestRate]"}'/>
							<!--input type="number" class="form-control input-sm" data-bind='textInput: $parent.interestRate2, attr: {"data-rule-min":(parseFloat(minInterest)>0?minInterest:null), "data-rule-max": (parseFloat(maxInterest)>0?maxInterest:null), "data-msg-min":"Interest Rate is less than "+minInterest, "data-msg-max":"Interest Rate is more than "+maxInterest, value:defInterest,"name":"loanAccount[interestRate]"}'/>
							<div>
								<label class="col-sm-2" data-bind="visible: parseFloat(minInterest)>0">Min</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(minInterest)>0, text: minInterest + '%'"></label>
								<label class="col-sm-2" data-bind='visible: parseFloat(maxInterest)>0'>Max</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(maxInterest)>0, text: maxInterest + '%'"></label>
							</div-->
						</div>
						<div class="col-md-6">
							<i><span data-bind="text: getWords((parseFloat($parent.requestedAmount2()))+' Uganda shillings only'"></span></i>
						</div>
					</div>
					<div class="hr-line-dashed"></div>
					<div class="form-group">
						<label class="col-md-3 control-label">First installment Offset Period <sup data-toggle="tooltip"  title="Period of time before which a client can start paying up the loan amount" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
						<div class="col-md-3">
							<input type="number" class="form-control input-sm" data-bind='attr: {"data-rule-min":(parseFloat(minOffSet)>0?minOffSet:null), "data-rule-max": (parseFloat(maxOffSet)>0?maxOffSet:null), "data-msg-min":"Offset period is less than "+minOffSet, "data-msg-max":"Offset period is more than "+maxOffSet,"name":"loanAccount[offSetPeriod]", value:defOffSet}'>
							<div>
								<label class="col-sm-2" data-bind="visible: parseFloat(minOffSet)>0">Min</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(minOffSet)>0, text: minOffSet"></label>
								<label class="col-sm-2" data-bind="visible: parseFloat(maxOffSet)>0">Max</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(maxOffSet)>0, text: maxOffSet"></label>
							</div>
						</div>
						<label class="col-md-3 control-label">Grace Period <sup data-toggle="tooltip" class="" title="Number of days the client is given to pay up upon default of the payment contract" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
						<div class="col-md-3">
							<input type="number" class="form-control input-sm" data-bind='attr: {"data-rule-min":(parseFloat(minGracePeriod)>0?minGracePeriod:null), "data-rule-max": (parseFloat(maxGracePeriod)>0?maxGracePeriod:null), "data-msg-min":"Grace Period is less than "+minGracePeriod, "data-msg-max":"Grace Period is more than "+maxGracePeriod,"name":"loanAccount[gracePeriod]", value:defGracePeriod}'>
							<div>
								<label class="col-sm-2" data-bind="visible: parseFloat(minGracePeriod)>0">Min</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(minGracePeriod)>0, text: minGracePeriod"></label>
								<label class="col-sm-2" data-bind="visible: parseFloat(maxGracePeriod)>0">Max</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(maxGracePeriod)>0, text: maxGracePeriod"></label>
							</div>
						</div>
					</div>
					<div class="hr-line-dashed"></div>
					<div class="form-group">
						<label class="col-md-3 control-label">Repayment Installments</label>
						<div class="col-md-3">
							<input type="number" class="form-control input-sm" data-bind='value: $parent.installments2,attr: {"data-rule-min":(parseFloat(minRepaymentInstallments)>0?minRepaymentInstallments:null), "data-rule-max": (parseFloat(maxRepaymentInstallments)>0?maxRepaymentInstallments:null), "data-msg-min":"Repayment Installments less than "+minRepaymentInstallments, "data-msg-max":"Repayment Installments more than "+maxRepaymentInstallments, value:defRepaymentInstallments,"name":"loanAccount[installments]"}' required />
							<div>
								<label class="col-sm-2" data-bind="visible: parseFloat(minRepaymentInstallments)>0">Min</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(minRepaymentInstallments)>0, text: minRepaymentInstallments"></label>
								<label class="col-sm-2" data-bind="visible: parseFloat(maxRepaymentInstallments)>0">Max</label>
								<label class="col-sm-4" data-bind="visible: parseFloat(maxRepaymentInstallments)>0, text: maxRepaymentInstallments"></label>
							</div>
						</div>
						<div class="col-md-6"><label class="control-label"></label><label>made every <span data-bind="text: repaymentsFrequency +' '+getDescription(4,repaymentsMadeEvery)"></span></label></div>
					</div>
					<!--ko if: $root.filteredLoanProductFees().length>0 -->
					<h3>Loan Fees <small>Applicable Fees (<span data-bind="text: $root.filteredLoanProductFees().length"></span>)</small></h3>
					<fieldset>
						<div class="form-group">
							<div class="table-responsive">
								<table class="table table-condensed">
									<thead>
										<tr>
											<th>Choose</th>
											<th>Name</th>
											<th>Rate</th>
											<th>Rate As</th>
											<th>Amount(UGX)</th>
										</tr>
									</thead>
									<tbody>
										<!-- ko if: typeof($parent.loan_account_fees)!='undefined' -->
										<!-- ko foreach: $parent.loan_account_fees -->
										<tr>
											<td><input class="icheckbox_square-green" style="position: relative;" name="fee" type="checkbox" checked data-bind=" attr:{'name':'loanAccount[loanFees]['+$index()+'][loanProductFeenId]', 'value':id}" /></td>
											<td data-bind='text: feeName'></td>
											<td data-bind='text: curr_format(amount)'></td>
											<td data-bind='text: getDescription(5, amountCalculatedAs)'></td>
											<td><input type="hidden" data-bind="attr:{'name':'loanAccount[loanFees]['+$index()+'][feeAmount]','value':getFeeAmount($parentContext.$parent.requestedAmount2(), amount, amountCalculatedAs)}"/><span data-bind='text: curr_format(getFeeAmount($parentContext.$parent.requestedAmount2(), amount, $data.amountCalculatedAs))'></span></td>
										</tr>
										<!--/ko-->
										<!--/ko-->
										<!-- ko foreach: $root.filteredLoanProductFees() -->
										<tr>
											<td><input class="icheckbox_square-green" style="position: relative;" name="fee" type="checkbox" data-bind="checkedValue: $data, checked: $parentContext.$parent.loanAccountFees, attr:{'name':'loanAccount[loanFees]['+(typeof($parent.loan_account_fees)!='undefined'?$parent.loan_account_fees.length:0)+'][loanProductFeenId]', 'value':$data.id}" /></td>
											<td data-bind='text: feeName'></td>
											<td data-bind='text: curr_format(amount)'></td>
											<td data-bind='text: getDescription(5, $data.amountCalculatedAs)'></td>
											<td><input type="hidden" data-bind="attr:{'name':'loanAccount[loanFees]['+($index()+(typeof($parent.loan_account_fees)!='undefined'?$parent.loan_account_fees.length:0)+'][feeAmount]','value':getFeeAmount($parentContext.$parent.requestedAmount2(), amount, $data.amountCalculatedAs)}"/><span data-bind='text: curr_format(getFeeAmount($parentContext.$parent.requestedAmount2(), amount, $data.amountCalculatedAs))'></span></td>
										</tr>
										<!--/ko-->
									</tbody>
								</table>
							</div>
						</div>
					</fieldset>
					<!-- /ko -->
					<!--ko if: ((typeof($parent.filteredGuarantors())!='undefined'&&$parent.filteredGuarantors().length>0||(typeof($parent.guarantors)!='undefined'&&$parent.guarantors.length>0))&&$root.clientType().type_id==1) -->
					<h3>Guarantors <small>Choose Guarantors</small></h3>
					<fieldset>
						<div class="form-group">
							<div class="table-responsive">
								<table class="table table-striped table-condensed table-hover">
									<thead>
										<tr>
											<th>Member</th>
											<th class='contact'>Phone</th>
											<th>Shares</th>
											<th>Savings</th>
											<th>&nbsp;</th>
										</tr>
									</thead>
									<tbody data-bind=''>
										<!--ko if: typeof($parent.guarantors)!='undefined'-->
										<!--ko foreach: $parent.guarantors-->
										<tr>
											<td data-bind='with: guarantor'>
												<input type="hidden" data-bind="value:id, attr:{'name':'loanAccountguarantors['+$index()+'][memberId]'}">
												<span data-bind='text: memberNames' > </span>
											</td>
											<td class='phone' data-bind='text: phone'>
											</td>
											<td class='shares' data-bind='text: shares'>
											</td>
											<td class='savings' data-bind='text: savings'>
											</td>
											<td>
												<span title="Remove item" class="btn text-danger" data-bind='click: function(){$($element).parent().parent().remove();}'><i class="fa fa-minus"></i></span>
											</td>
										</tr>
										<!--/ko-->
										<!--/ko-->
										<!--ko foreach: $parent.selectedGuarantors-->
										<tr>
											<td>
												<select data-bind="options: $parentContext.$parent.filteredGuarantors, optionsText: 'memberNames', optionsAfterRender: $root.setOptionValue('id'), optionsCaption: 'Select guarantor...', value:guarantor, attr:{'name':'loanAccountguarantors['+($index()+(typeof($parent.guarantors)!='undefined'?$parent.guarantors.length:0))+'][memberId]'}" class="form-control"> </select>
											</td>
											<td class='phone' data-bind='with: guarantor'>
												<span data-bind='text: phone' > </span>
											</td>
											<td class='shares' data-bind='with: guarantor'>
												<span data-bind='text: curr_format(shares)'> </span>
											</td>
											<td class='savings' data-bind='with: guarantor'>
												<span data-bind='text: curr_format(savings)'> </span>
											</td>
											<td>
												<span title="Remove item" class="btn text-danger" data-bind='click: $parentContext.$parent.removeGuarantor'><i class="fa fa-minus"></i></span>
											</td>
										</tr>
										<!--/ko-->
									</tbody>
								</table>
							</div>
							<div class="col-sm-3">
							<a data-bind='click: $parent.addGuarantor, enable: $parent.selectedGuarantors().length < minGuarantors' class="btn btn-info btn-sm"><i class="fa fa-plus"></i>Add Guarantor</a></div>
							<div class="col-sm-3">Minimum: <span data-bind='text: minGuarantors'> </span></div>
							<div class="col-sm-3">Total shares: <span data-bind='text: curr_format($parent.totalShares())'> </span></div>
							<div class="col-sm-3">Total savings: <span data-bind='text: curr_format($parent.totalSavings())'> </span></div>
						</div>
					</fieldset>
					<!-- /ko -->
					<!--ko if: (!$parent.groupId||$parent.groupId==0) -->
					<h3>Collateral <small>Add Collateral</small></h3>
					<fieldset>
						<div class="hr-line-dashed"></div>
						<div class="form-group" data-bind="visible: ($parent.addedCollateral()&&$parent.addedCollateral().length>0)||(typeof($parent.collateral_items())!='undefined'&&$parent.collateral_items()!=false)">
							<div class="col-md-12">
								<div class="col-sm-6">Total Collateral: UGX <span data-bind="text: curr_format($parent.totalCollateral()), css: {'text-danger': $parent.totalCollateral()<((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100))), 'text-info': $parent.totalCollateral()>((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100)))}"></span> <i  data-bind="css: {'fa fa-check text-info':$parent.totalCollateral()>((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100)))}"></i></div>
								<div class="col-sm-6 text-info">
								Required Minimum: UGX <span data-bind='text: curr_format((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100)))+" at a rate of "+minCollateral+"%"'> </span>
								</div>
							</div>
							<div class="hr-line-dashed"></div><!--  -->
							<div class="table-responsive">
								<table class="table table-condensed">
									<thead>
										<tr>
											<th>Item Name</th>
											<th>Description</th>
											<th>Item Value</th>
											<th>Attachment</th>
											<th>&nbsp;</th>
										</tr>
									</thead>
									<tbody>
										<!--ko if: typeof($parent.collateral_items())!='undefined'&&$parent.collateral_items()-->
										<!--ko foreach: $parent.collateral_items()-->
										<tr>
											<td><input class="form-control input-sm" data-bind="value: itemName, attr:{'name':'loanAccount[loanCollateral]['+$index()+'][itemName]'}" data-msg-required="Item name is required" required /></td>
											<td><textarea class="form-control input-sm" data-bind="value: description, attr:{'name':'loanAccount[loanCollateral]['+$index()+'][description]'}" data-msg-required="Item description is required" required></textarea></td>
											<td><input class="form-control input-sm" type="number" data-bind="textInput: itemValue, attr:{'name':'loanAccount[loanCollateral]['+$index()+'][itemValue]'}" required/>
											<i><span data-bind="text: getWords(parseInt(itemValue))+' Uganda shillings only'"></span></i>
											</td>
											<td>
												<input class="input-sm" type="file" data-bind="attr:{'name':'loanAccount[loanCollateral]['+$index()+'][attachmentUrl]'}"/>
											</td>
											<td><span title="Remove item" class="btn text-danger" data-bind='click: function(){$($element).parent().parent().remove();}'><i class="fa fa-minus"></i></span></td>
										</tr>
										<!--/ko-->
										<!--/ko-->
										<!--ko foreach: $parent.addedCollateral-->
										<tr>
											<td><input class="form-control input-sm" data-bind="value: itemName, attr:{'name':'loanAccount[loanCollateral]['+($index()+(typeof($parentContext.$parent.collateral_items())!='undefined'?$parentContext.$parent.collateral_items().length:0))+'][itemName]'}" data-msg-required="Item name is required" required/></td>
											<td><textarea class="form-control input-sm" data-bind="value: description, attr:{'name':'loanAccount[loanCollateral]['+($index()+(typeof($parentContext.$parent.collateral_items())!='undefined'?$parentContext.$parent.collateral_items().length:0))+'][description]'}" data-msg-required="Item description is required" required></textarea></td>
											<td><input class="form-control input-sm" type="number" data-bind="textInput: itemValue, attr:{'name':'loanAccount[loanCollateral]['+($index()+(typeof($parentContext.$parent.collateral_items())!='undefined'?$parentContext.$parent.collateral_items().length:0))+'][itemValue]'}" required/>
											<i><span data-bind="text: getWords(itemValue())+' Uganda shillings only'"></span></i>
											</td>
											<td><input class="input-sm" type="file" data-bind="value: attachmentUrl, attr:{'name':'loanAccount[loanCollateral]['+($index()+(typeof($parentContext.$parent.collateral_items())!='undefined'?$parentContext.$parent.collateral_items().length:0))+'][attachmentUrl]'}"/></td>
											<td><span title="Remove item" class="btn text-danger" data-bind='click: $parentContext.$parent.removeCollateral'><i class="fa fa-minus"></i></span></td>
										</tr>
										<!--/ko-->
									</tbody>
								</table>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-12">
							<span class="btn btn-info btn-sm pull-right" data-bind='click: $parent.addCollateral'><i class="fa fa-plus"></i> Add Item</span>
							</div>
						</div>
					</fieldset>
					<!-- /ko -->
					<h3>Businesses <small>Add Businesses</small></h3>
					<fieldset>
						<!--ko if: typeof($parent.memberBusinesses)!='undefined'&&$parent.memberBusinesses!=false-->
						<div class="row">
							<div class="col-lg-2">
								<label>Name of Business</label>
							</div>
							<div class="col-lg-3">
								<label>Business Location</label>
							</div>
							<div class="col-lg-2">
								<label>Number Of Employees</label>
							</div>
							<div class="col-lg-2">
								<label>Business Worth</label>
							</div>
							<div class="col-lg-2">
								<label>URSB Number</label>
							</div>
							<div class="col-lg-1">
							</div>
						</div>
						<div class="row" data-bind="foreach: $parent.memberBusinesses">
							<h3 data-bind="text:'Business '+($index()+1)"></h3>
							<div class="col-lg-2">
								<div class="form-group">
									<input type="text" data-bind="value: businessName, attr:{'name':'loanAccount[clientBusinesses]['+$index()+'][businessName]'}" required class="form-control"/>
								</div>
							</div>
							<div class="col-lg-3">
								<div class="form-group">
									<textarea data-bind="value: businessLocation, attr:{'name':'loanAccount[clientBusinesses]['+$index()+'][businessLocation]'}" required class="form-control "></textarea>
								</div>
							</div>
							<div class="col-lg-2">
								<div class="form-group">
									<input data-bind="value: numberOfEmployees, attr:{'name':'loanAccount[clientBusinesses]['+$index()+'][numberOfEmployees]'}" required type="number" class="form-control ">
								</div>
							</div>
							<div class="col-lg-2">
								<div class="form-group">
									<input data-bind="textInput: businessWorth, attr:{'name':'loanAccount[clientBusinesses]['+$index()+'][businessWorth]'}"  type="text" class="form-control">
								</div>
							</div>
							<div class="col-lg-2">
								<div class="form-group">
									<input data-bind="value: ursbNumber, attr:{'name':'loanAccount[clientBusinesses]['+$index()+'][ursbNumber]'}"  type="text" class="form-control ">
								</div>
							</div>
							<div class="col-lg-1">
								<span title="Remove Business" class="btn text-danger btn-lg"  data-bind='click: function(){$($element).parent().parent().remove();}'><i class="fa fa-minus"></i></span></div>
							<div class="clearboth"></div>
						</div>
						<!--/ko-->
						<div class="row" data-bind="foreach: $parent.member_business">
							<h3 data-bind="text:'Business '+($index()+((typeof($parentContext.$parent.memberBusinesses)!='undefined'&&$parentContext.$parent.memberBusinesses!=false)?$parentContext.$parent.memberBusinesses.length:0)+1)"></h3>
							<div class="col-lg-2">
								<div class="form-group">
									<input type="text" data-bind="value: businessName, attr:{'name':'loanAccount[clientBusinesses]['+($index()+(typeof($parent.memberBusinesses)!='undefined'?$parent.memberBusinesses.length:0))+'][businessName]'}" required class="form-control"/>
								</div>
							</div>
							<div class="col-lg-3">
								<div class="form-group">
									<textarea data-bind="value: businessLocation, attr:{'name':'loanAccount[clientBusinesses]['+($index()+(typeof($parentContext.$parent.memberBusinesses)!='undefined'?$parentContext.$parent.memberBusinesses.length:0)+'][businessLocation]'}" required class="form-control "></textarea>
								</div>
							</div>
							<div class="col-lg-2">
								<div class="form-group">
									<input data-bind="value: numberOfEmployees, attr:{'name':'loanAccount[clientBusinesses]['+($index()+(typeof($parentContext.$parent.memberBusinesses)!='undefined'?$parentContext.$parent.memberBusinesses.length:0)+'][numberOfEmployees]'}" required type="number" class="form-control ">
								</div>
							</div>
							<div class="col-lg-2">
								<div class="form-group">
									<input data-bind="textInput: businessWorth, attr:{'name':'loanAccount[clientBusinesses]['+($index()+(typeof($parentContext.$parent.memberBusinesses)!='undefined'?$parentContext.$parent.memberBusinesses.length:0)+'][businessWorth]'}"  type="text" class="form-control">
								</div>
							</div>
							<div class="col-lg-2">
								<div class="form-group">
									<input data-bind="value: ursbNumber, attr:{'name':'loanAccount[clientBusinesses]['+($index()+(typeof($parentContext.$parent.memberBusinesses)!='undefined'?$parentContext.$parent.memberBusinesses.length:0)+'][ursbNumber]'}"  type="text" class="form-control ">
								</div>
							</div>
							<div class="col-lg-1"><span title="Remove Business" class="btn text-danger btn-lg" data-bind='click: $parentContext.$parent.removeBusiness'><i class="fa fa-minus"></i></span></div>
							<div class="clearboth"></div>
						</div>
						<div class="row">
							<div class="clearboth"></div>
							<div class="col-lg-12">
								 <div class="form-group">
									<span class="btn btn-info btn-sm pull-right" data-bind='click: $parent.addBusinnes'><i class="fa fa-plus"></i> Add more</span>
								</div>
							</div>
						</div>
					</fieldset>
					<div class="form-group">
						<div class="clearboth"></div>
						<div class="col-lg-12">
						<label class="control-label">Comment</label>
						<textarea class="form-control" data-bind='attr: {"name":"loanAccount[comments]"}, value:$parent.comments'></textarea></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
									</div>
                                <div class="form-group">
                                    <div class="col-sm-6 col-sm-offset-2">
                                        <button class="btn btn-warning" type="reset">Cancel</button>
                                        <button class="btn btn-primary" type="submit" data-bind="enable: $root.loanProduct2">Submit</button><!--&&(selectedGuarantors().length>=loanProduct2.minGuarantors)&&(totalCollateral()>=(parseInt(loanProduct2.minCollateral)/100)*(parseInt(requestedAmount2())+(parseInt(requestedAmount2())*parseInt(interestRate2())/100)))-->
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