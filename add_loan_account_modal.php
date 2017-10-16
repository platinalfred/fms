<div id="add_loan_account-modal" class="modal fade" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body">
                <div class="row" id="loan_account_form">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Loan Application <small>Create loan Account</small></h5>
                                <div class="ibox-tools">
                                    <a class="" data-dismiss="modal">
                                        <i class="fa fa-times lg"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <form id="loanAccountForm" class="form-horizontal wizard-big" method="post" enctype="multipart/form-data">
                                    <input type='hidden' name="id" />
                                    <input type='hidden' name="origin" value="loan_account" />
                                    <h3>Loan Account <small>Account Information</small></h3>
                                    <div class="row">
                                        <fieldset>
                                            <?php if(!isset($client)):?>
                                                <div class="form-group">
                                                    <div class="col-md-6">
                                                        <label class="control-label">Client Type</label>
                                                        <select class="form-control" name="clientType" data-bind='options: clientTypes, optionsText: "client_type", optionsCaption: "Select client type...", optionsAfterRender: $root.setOptionValue("type_id"), value: clientType' data-msg-required="Client type is required" required>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6" data-bind="with: clientType">
                                                        <!--ko if:type_id==1-->
                                                        <label class="control-label">Customer</label>
                                                        <select data-placeholder="Select customer..." name="memberId" class="form-control chosen-select" data-bind='options: $root.clients, optionsText: "clientNames", optionsCaption: "Select customer...", optionsAfterRender: $root.setOptionValue("id"), value: $root.client' data-msg-required="Client name is required" required>
                                                        </select>
                                                        <!--/ko-->
                                                        <!--ko if:type_id==2-->
                                                        <label class="control-label">Member Groups</label>
                                                        <select data-placeholder="Select group..." name="groupId" class="form-control chosen-select" data-bind='options: $root.groups, optionsText: "clientNames", optionsCaption: "Select group...", optionsAfterRender: $root.setOptionValue("id"), value: $root.client' data-msg-required="Please select a group" required>
                                                        </select>
                                                        <!--/ko-->
                                                    </div>
                                                </div>
                                                <?php else:?>
                                                    <input type="hidden" name="clientType" value="<?php echo $client['clientType'];?>" />
                                                    <?php 
										endif;
										?>
                                                        <div class="form-group">
                                                            <div class="col-md-6" data-bind='with: $root.client'>
                                                                <label class="control-label">Product</label>
                                                                <select class="form-control" id="loanProductId" name="loanProductId" data-bind='options: $root.filteredLoanProducts, optionsText: "productName", optionsCaption: "Select product...", optionsAfterRender: $root.setOptionValue("id"), value: $root.loanProduct' data-msg-required="Loan product is required" required>
                                                                </select>
                                                                <span class="help-block m-b-none" data-bind="with: $root.loanProduct">
												<small data-bind="text: description">Product description goes here.</small>
												</span>
                                                            </div>
                                                            <div class="col-md-4" data-bind="with: $root.loanProduct">
                                                                <label class="control-label">Application Date</label>
                                                                <div class="input-group date" data-provide="datepicker" data-date-format="dd-mm-yyyy" data-date-end-date="<?php echo date('d-m-Y');?>">
                                                                    <input type="text" class="form-control" name="applicationDate" data-bind="attr:{value:$parent.applicationDate}" required>
                                                                    <div class="input-group-addon">
                                                                        <span class="fa fa-calendar"></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="form-group" data-bind='with: loanProduct'>
                                                            <div class="col-lg-12">
                                                                <h3>Please fill in the loan application details for the client<span data-bind="text: ($root.filteredGroupMembers().length>1)?'s':''"></span> below</h3>
                                                            </div>
                                                        </div>
                                        </fieldset>
                                        <!--ko with:clientType-->
                                        <!--ko if:(typeof($root.client())!='undefined'&&typeof($root.loanProduct())!='undefined')-->
                                        <div class="hr-line-dashed"></div>
                                        <div data-bind='foreach: $root.filteredGroupMembers'>
                                            <div class="ibox float-e-margins">
                                                <div class="ibox-title">
                                                    <h5 data-bind='text: clientNames'>member</h5>
                                                    <div class="ibox-tools">
                                                        <a class="collapse-link">
					<i data-bind="css:{'fa':1,'fa-chevron-down':$index()>0,'fa-chevron-up':$index()==0}"></i>
				</a>
                                                        <input type='hidden' data-bind="value:((typeof(memberId)!='undefined')?memberId:id), attr:{'name':'loanAccount['+$index()+'][memberId]'}" />
                                                        <!--input type='hidden' data-bind="value:id, attr:{'name':'loanAccount['+$index()+'][groupMemberId]'}"/-->
                                                        <a class="close-link">
                                                            <i class="fa fa-times"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="ibox-content">
                                                    <div class="row">
                                                        <div data-bind="with: $root.loanProduct">
                                                            <div class="hr-line-dashed"></div>
                                                            <!-- Settings adapted from the product -->
                                                            <input type='hidden' data-bind="value:initialAccountState, attr:{'name':'loanAccount['+$parentContext.$index()+'][status]'}" />
                                                            <input type='hidden' data-bind="value:repaymentsFrequency, attr:{'name':'loanAccount['+$parentContext.$index()+'][repaymentsFrequency]'}" />
                                                            <input type='hidden' data-bind="value:repaymentsMadeEvery, attr:{'name':'loanAccount['+$parentContext.$index()+'][repaymentsMadeEvery]'}" />
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">Loan Amount</label>
                                                                <div class="col-md-3">
                                                                    <input type="number" class="form-control input-sm" data-bind='textInput: $parent.requestedAmount2, attr: {"data-rule-min":((parseFloat(minAmount)>0&&$root.clientType==1)?minAmount:null), "data-rule-max": ((parseFloat(maxAmount)>0&&$root.clientType==1)?maxAmount:null), "data-msg-min":"Loan amount is less than "+curr_format(parseInt(minAmount)), "data-msg-max":"Loan amount is more than "+curr_format(parseInt(maxAmount)),"name":"loanAccount["+$parentContext.$index()+"][requestedAmount]"}' />
                                                                    <div>
                                                                        <label class="col-sm-2" data-bind="visible: (parseFloat(minAmount)>0&&$root.clientType==1)">Min</label>
                                                                        <label class="col-sm-4" data-bind="visible: (parseFloat(minAmount)>0&&$root.clientType==1), text: curr_format(parseInt(minAmount))"></label>
                                                                        <label class="col-sm-2" data-bind='visible: (parseFloat(maxAmount)>0&&$root.clientType==1)'>Max</label>
                                                                        <label class="col-sm-4" data-bind="visible: (parseFloat(maxAmount)>0&&$root.clientType==1), text: curr_format(parseInt(maxAmount))"></label>
                                                                    </div>
                                                                </div>
                                                                <label class="col-md-3 control-label">Interest Rate</label>
                                                                <div class="col-md-3">
                                                                    <input type="number" class="form-control input-sm" data-bind='textInput: $parent.interestRate2, attr: {"data-rule-min":(parseFloat(minInterest)>0?minInterest:null), "data-rule-max": (parseFloat(maxInterest)>0?maxInterest:null), "data-msg-min":"Interest Rate is less than "+minInterest, "data-msg-max":"Interest Rate is more than "+maxInterest, value:defInterest,"name":"loanAccount["+$parentContext.$index()+"][interestRate]"}' />
                                                                    <div>
                                                                        <label class="col-sm-2" data-bind="visible: parseFloat(minInterest)>0">Min</label>
                                                                        <label class="col-sm-4" data-bind="visible: parseFloat(minInterest)>0, text: minInterest + '%'"></label>
                                                                        <label class="col-sm-2" data-bind='visible: parseFloat(maxInterest)>0'>Max</label>
                                                                        <label class="col-sm-4" data-bind="visible: parseFloat(maxInterest)>0, text: maxInterest + '%'"></label>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <i><span data-bind="text: getWords($parent.requestedAmount2())+' Uganda shillings only'"></span></i>
                                                                </div>
                                                            </div>
                                                            <div class="hr-line-dashed"></div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">First installment Offset Period <sup data-toggle="tooltip" title="Period of time before which a client can start paying up the loan amount" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
                                                                <div class="col-md-3">
                                                                    <input type="number" class="form-control input-sm" data-bind='attr: {"data-rule-min":(parseFloat(minOffSet)>0?minOffSet:null), "data-rule-max": (parseFloat(maxOffSet)>0?maxOffSet:null), "data-msg-min":"Offset period is less than "+minOffSet, "data-msg-max":"Offset period is more than "+maxOffSet,"name":"loanAccount["+$parentContext.$index()+"][offSetPeriod]", value:defOffSet}'>
                                                                    <div>
                                                                        <label class="col-sm-2" data-bind="visible: parseFloat(minOffSet)>0">Min</label>
                                                                        <label class="col-sm-4" data-bind="visible: parseFloat(minOffSet)>0, text: minOffSet"></label>
                                                                        <label class="col-sm-2" data-bind="visible: parseFloat(maxOffSet)>0">Max</label>
                                                                        <label class="col-sm-4" data-bind="visible: parseFloat(maxOffSet)>0, text: maxOffSet"></label>
                                                                    </div>
                                                                </div>
                                                                <label class="col-md-3 control-label">Grace Period <sup data-toggle="tooltip" class="" title="Number of days the client is given to pay up upon default of the payment contract" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
                                                                <div class="col-md-3">
                                                                    <input type="number" class="form-control input-sm" data-bind='attr: {"data-rule-min":(parseFloat(minGracePeriod)>0?minGracePeriod:null), "data-rule-max": (parseFloat(maxGracePeriod)>0?maxGracePeriod:null), "data-msg-min":"Grace Period is less than "+minGracePeriod, "data-msg-max":"Grace Period is more than "+maxGracePeriod,"name":"loanAccount["+$parentContext.$index()+"][gracePeriod]", value:defGracePeriod}'>
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
                                                                    <input type="number" class="form-control input-sm" data-bind='attr: {"data-rule-min":(parseFloat(minRepaymentInstallments)>0?minRepaymentInstallments:null), "data-rule-max": (parseFloat(maxRepaymentInstallments)>0?maxRepaymentInstallments:null), "data-msg-min":"Repayment Installments less than "+minRepaymentInstallments, "data-msg-max":"Repayment Installments more than "+maxRepaymentInstallments, value:defRepaymentInstallments,"name":"loanAccount["+$parentContext.$index()+"][installments]"}' required />
                                                                    <div>
                                                                        <label class="col-sm-2" data-bind="visible: parseFloat(minRepaymentInstallments)>0">Min</label>
                                                                        <label class="col-sm-4" data-bind="visible: parseFloat(minRepaymentInstallments)>0, text: minRepaymentInstallments"></label>
                                                                        <label class="col-sm-2" data-bind="visible: parseFloat(maxRepaymentInstallments)>0">Max</label>
                                                                        <label class="col-sm-4" data-bind="visible: parseFloat(maxRepaymentInstallments)>0, text: maxRepaymentInstallments"></label>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="control-label"></label>
                                                                    <label>made every <span data-bind="text: repaymentsFrequency +' '+getDescription(4,repaymentsMadeEvery)"></span></label>
                                                                </div>
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
                                                                            <tbody data-bind="foreach: $root.filteredLoanProductFees">
                                                                                <tr>
                                                                                    <td>
                                                                                        <input class="icheckbox_square-green" style="position: relative;" name="fee" type="checkbox" data-bind="checkedValue: $data, checked: $parentContext.$parent.loanAccountFees, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][loanFees]['+$index()+'][loanProductFeenId]', 'value':$data.id}" />
                                                                                    </td>
                                                                                    <td data-bind='text: feeName'></td>
                                                                                    <td data-bind='text: curr_format(amount)'></td>
                                                                                    <td data-bind='text: getDescription(5, $data.amountCalculatedAs)'></td>
                                                                                    <td>
                                                                                        <input type="hidden" data-bind="attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][loanFees]['+$index()+'][feeAmount]','value':getFeeAmount($parentContext.$parent.requestedAmount2(), amount, $data.amountCalculatedAs)}" /><span data-bind='text: curr_format(getFeeAmount($parentContext.$parent.requestedAmount2(), amount, $data.amountCalculatedAs))'></span></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </div>
                                                            </fieldset>
                                                            <!-- /ko -->
                                                            <!--ko if: ($parent.filteredGuarantors().length>0) -->
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
                                                                            <tbody data-bind='foreach: $parent.selectedGuarantors'>
                                                                                <tr>
                                                                                    <td>
                                                                                        <select data-bind="options: $parentContext.$parent.filteredGuarantors, optionsText: 'memberNames', optionsValue, optionsAfterRender: $root.setOptionValue('id'), optionsCaption: 'Select guarantor...', value:guarantor, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+']guarantors['+$index()+'][memberId]'}" class="form-control"> </select>
                                                                                    </td>
                                                                                    <td class='phone' data-bind='with: guarantor'>
                                                                                        <span data-bind='text: phone'> </span>
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
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <div class="col-sm-3">Minimum: <span data-bind='text: minGuarantors'> </span></div>
                                                                    <div class="col-sm-3">Total shares: <span data-bind='text: curr_format($parent.totalShares())'> </span></div>
                                                                    <div class="col-sm-4">Total savings: <span data-bind='text: curr_format($parent.totalSavings())'> </span></div>
                                                                    <div class="col-sm-2">
                                                                        <a data-bind='click: $parent.addGuarantor, enable: $parent.selectedGuarantors().length < minGuarantors' class="btn btn-info btn-sm"><i class="fa fa-plus"></i>Add Guarantor</a>
																	</div>
                                                                </div>
                                                            </fieldset>
                                                            <!-- /ko -->
                                                            <!--ko if: (parseInt($root.client().clientType)==1) -->
                                                            <h3>Collateral <small>Add Collateral</small></h3>
                                                            <fieldset>
                                                                <div class="hr-line-dashed"></div>
                                                                <div class="form-group" data-bind="visible: $parent.addedCollateral().length>0">
                                                                    <div class="col-md-12">
                                                                        <div class="col-sm-6">Total Collateral: UGX <span data-bind="text: curr_format($parent.totalCollateral()), css: {'text-danger': $parent.totalCollateral()<((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100))), 'text-info': $parent.totalCollateral()>((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100)))}"></span> <i data-bind="css: {'fa fa-check text-info':$parent.totalCollateral()>((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100)))}"></i></div>
                                                                        <div class="col-sm-6 text-info">
                                                                            Required Minimum: UGX <span data-bind='text: curr_format((parseInt(minCollateral)/100)*(parseInt($parent.requestedAmount2())+(parseInt($parent.requestedAmount2())*parseInt($parent.interestRate2())/100)))+" at a rate of "+minCollateral+"%"'> </span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="hr-line-dashed"></div>
                                                                    <!--  -->
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
                                                                            <tbody data-bind="foreach: $parent.addedCollateral">
                                                                                <tr>
                                                                                    <td>
                                                                                        <input class="form-control input-sm" data-bind="value: itemName, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][loanCollateral]['+$index()+'][itemName]'}" data-msg-required="Item name is required" required/>
                                                                                    </td>
                                                                                    <td>
                                                                                        <textarea class="form-control input-sm" data-bind="value: description, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][loanCollateral]['+$index()+'][description]'}" data-msg-required="Item description is required" required></textarea>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="form-control input-sm" type="number" data-bind="textInput: itemValue, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][loanCollateral]['+$index()+'][itemValue]'}" required/>
                                                                                        <i><span data-bind="text: getWords(itemValue())+' Uganda shillings only'"></span></i>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="input-sm" type="file" data-bind="value: attachmentUrl, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][loanCollateral]['+$index()+'][attachmentUrl]'}" />
                                                                                    </td>
                                                                                    <td><span title="Remove item" class="btn text-danger" data-bind='click: $parentContext.$parent.removeCollateral'><i class="fa fa-minus"></i></span></td>
                                                                                </tr>
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
                                                                <div class="row" data-bind="foreach: $parent.member_business">
                                                                    <h3 data-bind="text:'Business '+($index()+1)"></h3>
                                                                    <div class="col-lg-6">
                                                                        <div class="form-group">
                                                                            <label>Name of Business</label>
                                                                            <textarea data-bind="value: businessName, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][clientBusinesses]['+$index()+'][businessName]'}" required class="form-control"></textarea>
                                                                        </div>

                                                                    </div>
                                                                    <div class="col-lg-6">
                                                                        <div class="form-group">
                                                                            <label>Business Location</label>
                                                                            <textarea data-bind="value: businessLocation, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][clientBusinesses]['+$index()+'][businessLocation]'}" required class="form-control "></textarea>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-lg-3">
                                                                        <div class="form-group">
                                                                            <label>Number Of Employees</label>
                                                                            <input data-bind="value: numberOfEmployees, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][clientBusinesses]['+$index()+'][numberOfEmployees]'}" required type="number" class="form-control ">
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-lg-2">
                                                                        <div class="form-group">
                                                                            <label>Business Worth</label>
                                                                            <input data-bind="textInput: businessWorth, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][clientBusinesses]['+$index()+'][businessWorth]'}" type="text" class="form-control">
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-lg-2">
                                                                        <div class="form-group">
                                                                            <label>URSB Number</label>
                                                                            <input data-bind="value: ursbNumber, attr:{'name':'loanAccount['+($parentContext.$parentContext.$index())+'][clientBusinesses]['+$index()+'][ursbNumber]'}" type="text" class="form-control ">
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
                                                                    <textarea class="form-control" data-bind='attr: {"name":"loanAccount["+$parentContext.$index()+"][comments]"}'></textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--/ko-->
                                        <!--/ko-->
                                    </div>
                                    <div class="form-group">
                                        <div class="col-sm-6 col-sm-offset-2">
                                            <button class="btn btn-warning" type="reset">Cancel</button>
                                            <button class="btn btn-primary" type="submit" data-bind="enable: loanProduct">Submit</button>
                                            <!--&&(selectedGuarantors().length>=loanProduct.minGuarantors)&&(totalCollateral()>=(parseInt(loanProduct.minCollateral)/100)*(parseInt(requestedAmount2())+(parseInt(requestedAmount2())*parseInt(interestRate2())/100)))-->
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