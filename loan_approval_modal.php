<div id="approve_loan-modal" class="modal fade modal-xl" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>Loan Account Details <small>&nbsp;</small></h5>
                                <div class="ibox-tools">
                                    <!--ko with: account_details-->
                                    <!--ko if: groupId-->
                                    <!--ko if: typeof($parent.groupLoanAccounts)!='undefined'&&$parent.groupLoanAccounts().length>0--><span data-bind="text: groupName"></span> group. (Total requested amount: UGX <span data-bind="text: curr_format(parseFloat(array_total($parent.groupLoanAccounts(),9)))"></span>)&nbsp;&nbsp;&nbsp;
                                    <!--ko if: $parent.curIndex()>1-->
                                    <a data-bind="click:function(){$parent.nextPrevLoanAccount($parent.curIndex()-2);}" title="Previous Account"><i class="fa fa-angle-double-left"></i></a><!--/ko--> <span data-bind="text:$parent.curIndex()">3</span>of <span data-bind="text:$parent.groupLoanAccounts().length">5</span> <!--ko if: $parent.curIndex()<$parent.groupLoanAccounts().length--><a data-bind="click:function(){$parent.nextPrevLoanAccount($parent.curIndex());}" title="Next Account"><i class="fa fa-angle-double-right"></i></a><!--/ko-->
                                    <!--/ko-->
                                    <!--/ko-->
                                    <!--/ko-->
                                    <a data-dismiss="modal">
                                        <i class="fa fa-times"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="" data-bind="with: account_details">
                                    <!--ko if: typeof(member_details)!='undefined'-->
                                    <div class="col-md-12" >
                                        <div class="col-md-12 bordered" style="padding:4px;">
                                            <h3>Client Details</h3>
                                            <div class="col-sm-3"><img style="width:100px;"  data-bind="attr:{src:member_details.id_specimen}" /></div>
                                            <div class="col-sm-9"><i data-bind="css: {'fa':1, 'fa-male': member_details.gender=='M', 'fa-female': member_details.gender=='F'}"></i> <span data-bind="text: clientNames"></span>  ,
                                                <i class="fa fa-mobile"></i> <span data-bind="text: member_details.phone"></span>,  
                                                <i class="fa fa-at"></i> <span data-bind="text: member_details.email"></span>,  
                                                <i class="fa fa-map-envelope-square"></i> <span data-bind="text: member_details.postal_address">Kawempe, Kazo</span>
                                                <i class="fa fa-map-marker"></i> <span data-bind="text: member_details.physical_address">Kawempe, Kazo</span></div>
                                        </div>
                                    </div>
                                    <!--/ko-->
                                    <div class="col-md-12" data-bind="if: typeof(guarantors)!='undefined' && guarantors.length>0">
                                        <div class="col-md-12 bordered">
                                            <h3>Guarantors</h3>
                                            <div class="table-responsive">
                                                <table class="table table-condensed">
                                                    <thead>
                                                        <tr>
                                                            <th>Names</th>
                                                            <th>Savings</th>
                                                            <th>Shares</th>
                                                            <th>Loans</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody data-bind="foreach: guarantors">
                                                        <tr>
                                                            <td data-bind="text: memberNames"></td>
                                                            <td data-bind="text: savings"></td>
                                                            <td data-bind="text: shares"></td>
                                                            <td data-bind="text: outstanding_loan"></td>
                                                        </tr>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th>Total (UGX)</th>
                                                            <th data-bind="text: curr_format(parseInt(array_total(guarantors,2)">&nbsp;</th>
                                                            <th data-bind="text: curr_format(parseInt(array_total(guarantors,3)">&nbsp;</th>
                                                            <th data-bind="text: curr_format(parseInt(array_total(guarantors,4)"></th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12" data-bind="if: status<4&&!groupLoanAccountId&&typeof(collateral_items())!='undefined'&&collateral_items().length>0">
                                        <div class="col-md-12 bordered">
                                            <h3>Collateral</h3>
                                            <div class="table-responsive">
                                                <table class="table table-condensed">
                                                    <thead>
                                                        <tr>
                                                            <th>Item</th>
                                                            <th>Description</th>
                                                            <th>Item Value</th>
                                                            <th>Attachment</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody data-bind="foreach: collateral_items()">
                                                        <tr>
                                                            <td data-bind="text: itemName"></td>
                                                            <td data-bind="text: description"></td>
                                                            <td data-bind="text: curr_format(parseInt(itemValue))"></td>
                                                            <td>
                                                                <!--ko if:(/(.jpg|.png|.gif|.jpeg)$/).test(attachmentUrl)-->
                                                                <img style="width:100px;" data-bind="attr:{src:attachmentUrl}" />
                                                                <!--/ko-->
                                                                <!--ko if:!(/(.jpg|.png|.gif|.jpeg)$/).test(attachmentUrl)-->
                                                                <a data-bind="attr:{href:attachmentUrl}, text:attachmentUrl" target="_blank"></a>
                                                                <!--/ko-->
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th colspan="2">Total</th>
                                                            <th data-bind="text: curr_format(parseInt(array_total(collateral_items(),4)))"></th>
                                                            <th></th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12" data-bind="if: typeof(memberBusinesses)!='undefined' &&memberBusinesses.length>0">
                                        <div class="col-md-12 bordered">
                                            <h3>Business</h3>
                                            <div class="table-responsive">
                                                <table class="table table-condensed">
                                                    <thead>
                                                        <tr>
                                                            <th>Business</th>
                                                            <th>Type</th>
                                                            <th>Location</th>
                                                            <th>No. Employees</th>
                                                            <th>URSB No.</th>
                                                            <th>Business Worth</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody data-bind="foreach: memberBusinesses">
                                                        <tr>
                                                            <td data-bind="text: businessName"></td>
                                                            <td data-bind="text: natureOfBusiness"></td>
                                                            <td data-bind="text: businessLocation"></td>
                                                            <td data-bind="text: numberOfEmployees"></td>
                                                            <td data-bind="text: ursbNumber"></td>
                                                            <td data-bind="text: curr_format(parseInt(businessWorth))"></td>
                                                        </tr>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th>Total</th>
                                                            <th colspan="4"></th>
                                                            <th data-bind="text: curr_format(parseInt(array_total(memberBusinesses,6)))"></th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12" data-bind="if: typeof(relatives)!='undefined' &&relatives.length>0">
                                        <div class="col-md-12 bordered">
                                            <h3>Relatives</h3>
                                            <div class="table-responsive">
                                                <table class="table table-condensed">
                                                    <thead>
                                                        <tr>
                                                            <th>Names</th>
                                                            <th>Gender</th>
                                                            <th>Relationship</th>
                                                            <th>Contact</th>
                                                            <th>Address</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody data-bind="foreach: relatives">
                                                        <tr>
                                                            <td data-bind="text: first_name + ' ' + last_name + ' ' + other_names"></td>
                                                            <td data-bind="text: relative_gender==1?'Male':'Female'"></td>
                                                            <td data-bind="text: rel_type"></td>
                                                            <td data-bind="text: telephone"></td>
                                                            <td data-bind="text: address + ', ' + address2"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12" data-bind="if: typeof(employmentHistory)!='undefined' && employmentHistory.length > 0">
                                        <div class="col-md-12 bordered">
                                            <h3>Employment</h3>
                                            <div class="table-responsive">
                                                <table class="table table-condensed">
                                                    <thead>
                                                        <tr>
                                                            <th>Employer</th>
                                                            <th>Years of Employment</th>
                                                            <th>Nature of Employment</th>
                                                            <th>Monthly Salary</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody data-bind="foreach: employmentHistory">
                                                        <tr>
                                                            <td data-bind="text: employer"></td>
                                                            <td data-bind="text: years_of_employment"></td>
                                                            <td data-bind="text: nature_of_employment"></td>
                                                            <td data-bind="text: curr_format(parseInt(monthlySalary))"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <hr/>
                                <div>
                                    <form class="form-horizontal" id="loanAccountApprovalForm" data-bind="with: account_details">
                                        <div class="col-md-5">
                                            <div class="col-md-12 bordered">
                                                <h3>Requested Loan</h3>
                                                <div class="table-responsive">
                                                    <table class="table table-condensed">
                                                        <tbody>
                                                            <tr>
                                                                <th>Loan Product</th>
                                                                <td data-bind="text: productName"></td>
                                                            </tr>
                                                            <tr>
                                                                <th>Account No.</th>
                                                                <td data-bind="text: loanNo"></td>
                                                            </tr>
                                                            <tr>
                                                                <th>Amount requested</th>
                                                                <td data-bind="text: 'UGX ' + curr_format(parseInt(requestedAmount))"></td>
                                                            </tr>
                                                            <tr>
                                                                <th>1 Installment paid every</th>
                                                                <td data-bind="text: repaymentsFrequency +' '+ getDescription(4, repaymentsMadeEvery) +' (' + installments + ' in total)' "></td>
                                                            </tr>
                                                            <tr>
                                                                <th>Interest: UGX </th>
                                                                <td data-bind="text: curr_format(parseInt(interest))"></td>
                                                            </tr>
                                                            <tr>
                                                                <th>Periodic Principle: UGX </th>
                                                                <td data-bind="text: curr_format(Math.round(parseInt(requestedAmount)/parseInt(installments)))+ ' paid per ' +repaymentsFrequency +' '+ getDescription(4, repaymentsMadeEvery)"></td>
                                                            </tr>
                                                            <tr>
                                                                <th>Periodic Interest: UGX </th>
                                                                <td data-bind="text: curr_format(Math.round(parseInt(interest)/parseInt(installments))) +' ('+(parseFloat(interestRate)/((repaymentsMadeEvery!=0&&!isNaN(repaymentsMadeEvery))?getDescription(6, repaymentsMadeEvery):1))+'%)'+' paid per ' +repaymentsFrequency +' '+ getDescription(4, repaymentsMadeEvery)"></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-7">
                                            <div class="col-md-12 bordered">
                                                <h3>Previous Comments</h3>
                                                <div class="table-responsive">
                                                    <table class="table table-condensed">
                                                        <thead>
                                                            <tr>
                                                                <th>Date</th>
                                                                <th>Recomm. Amount (Ugx)</th>
                                                                <th>Remarks</th>
                                                                <th>Officer</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td data-bind="text: moment(applicationDate,'X').format('DD-MMM-YYYY')"></td>
                                                                <td data-bind="text: curr_format(parseFloat(requestedAmount))"></td>
                                                                <td data-bind="text: comments">remark</td>
                                                                <td data-bind="text: staffNames">officer</td>
                                                            </tr>
                                                            <!--ko if: typeof(approvals)!='undefined' &&approvals.length>0-->
                                                            <!--ko foreach: approvals-->
                                                            <tr>
                                                                <td data-bind="text: moment(dateCreated,'X').format('DD-MMM-YYYY')">date</td>
                                                                <td data-bind="text: curr_format(parseFloat(amountRecommended))">officer</td>
                                                                <td data-bind="text: justification">remark</td>
                                                                <td data-bind="text: staffNames">officer</td>
                                                            </tr>
                                                            <!--/ko-->
                                                            <!--/ko-->
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="col-md-12 bordered">
                                                <h3>Choose Action</h3>
                                                <div class="form-group">
                                                    <?php if (isset($_SESSION['branch_credit']) || isset($_SESSION['management_credit']) || isset($_SESSION['executive_board']) || isset($_SESSION['branch_manager'])): ?>
                                                    <?php endif; ?>
                                                    <?php if (isset($_SESSION['branch_manager']) && $_SESSION['branch_manager']): ?>
                                                        <!-- ko if: (status<4)-->
                                                        <!-- reject only if loan has not yet been forwarded for approval -->
                                                        <div class="col-md-3">
                                                            <label class="control-label text-danger"><input type="radio" name="status" value="11" data-bind="checked: $parent.loanAccountStatus"/> Reject</label>
                                                        </div>
                                                        <!-- /ko -->
                                                    <?php endif; ?>
                                                    <!-- ko if: ((status>1&&status<6)||status==11)-->
                                                    <div class="col-md-4">
                                                        <label class="control-label text-warning"><input type="radio" name="status" value="-1" data-bind="checked: $parent.loanAccountStatus" /> Previous State</label>
                                                    </div>
                                                    <!-- /ko -->
                                                    <?php if (isset($_SESSION['loans_officer']) && $_SESSION['loans_officer'] || (isset($_SESSION['admin']) && $_SESSION['admin'])): ?>
                                                        <!-- ko if: status==1-->
                                                        <div class="col-md-3">
                                                            <label class="control-label text-info"><input type="radio" name="status" value="2" data-bind="checked: $parent.loanAccountStatus" required data-msg-required="Please select option"/> Forward</label>
                                                        </div>
                                                        <!-- /ko -->
                                                    <?php endif; ?>
                                                    <?php if (isset($_SESSION['branch_manager']) && $_SESSION['branch_manager'] || (isset($_SESSION['admin']) && $_SESSION['admin'])): ?>
                                                        <!-- ko if: status==2-->
                                                        <div class="col-md-3">
                                                            <label class="control-label text-info"><input type="radio" name="status" value="3" data-bind="checked: $parent.loanAccountStatus" required data-msg-required="Please select option"/> Forward</label>
                                                        </div>
                                                        <!-- /ko -->
                                                        <!-- ko if: status<5-->
                                                        <!-- withdraw only if loan has not yet been disbursed -->
                                                        <div class="col-md-4">
                                                            <label class="control-label text-info"><input type="radio" name="status" value="12" data-bind="checked: $parent.loanAccountStatus" required data-msg-required="Please select option"/> Close/Withdraw</label>
                                                        </div>
                                                        <!-- /ko -->
                                                    <?php else: ?>
                                                        <!-- ko if: status==3 -->
                                                        <!-- approve only if loan has been forwarded for approval-->
                                                        <?php if ((isset($_SESSION['branch_credit']) && $_SESSION['branch_credit']) || (isset($_SESSION['admin']) && $_SESSION['admin'])) { ?>
                                                            <!-- ko if: parseInt(requestedAmount)<1000001 -->
                                                            <div class="col-sm-3">
                                                                <label class="control-label text-info"><input type="radio" name="status" value="4" data-bind="checked: $parent.loanAccountStatus" required data-msg-required="Please select option"/> Approve</label>
                                                            </div>
                                                            <!-- /ko -->
                                                        <?php } else if (isset($_SESSION['management_credit']) && $_SESSION['management_credit']) { ?>
                                                            <!-- ko if: (parseInt(requestedAmount)>1000000&&parseInt(requestedAmount)<5000001) -->
                                                            <div class="col-sm-3">
                                                                <label class="control-label text-info"><input type="radio" name="status" value="4" data-bind="checked: $parent.loanAccountStatus" required data-msg-required="Please select option"/> Approve</label>
                                                            </div>
                                                            <!-- /ko -->
                                                        <?php } else if (isset($_SESSION['executive_board']) && $_SESSION['executive_board']) { ?>
                                                            <!-- ko if: parseInt(requestedAmount)>5000000 -->
                                                            <div class="col-sm-3">
                                                                <label class="control-label text-info"><input type="radio" name="status" value="4" data-bind="checked: $parent.loanAccountStatus" required data-msg-required="Please select option"/> Approve</label>
                                                            </div>
                                                            <!-- /ko -->
                                                        <?php } ?>
                                                        <!-- /ko -->
                                                    <?php endif; ?>
                                                </div>
                                                <!-- ko if: status==3 -->
                                                <?php if ((isset($_SESSION['branch_credit']) && $_SESSION['branch_credit']) || (isset($_SESSION['management_credit']) && $_SESSION['management_credit']) || (isset($_SESSION['executive_board']) && $_SESSION['executive_board']) || (isset($_SESSION['admin']) && $_SESSION['admin'])): ?>
                                                    <div class="form-group">
                                                        <label class="control-label col-sm-4" for="amountApproved">Amount approved<span class="required">*</span></label>
                                                        <div class="col-sm-8">
                                                            <input type="number"  id="amountApproved" name="amountApproved" class="form-control col-sm-7" data-bind='textInput: $parent.amountApproved, attr: {"data-rule-max":parseInt(requestedAmount), "data-msg-max":"Amount cannot be greater than requested amount "+curr_format(parseFloat(requestedAmount))}' data-msg-required="Enter approved amount" required>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="control-label col-sm-4"></label>
                                                        <div class="col-sm-8">
                                                            <i><span data-bind="text: getWords($parent.amountApproved())+' Uganda shillings only'"></span></i>
                                                        </div>
                                                    </div>
<?php endif; ?>
                                                <!-- /ko -->
                                                <div class="form-group">
                                                    <div class="col-sm-12">
                                                        <label class="control-label" for="textarea">Justification </label>
                                                        <textarea id="approvalNotes"  name="approvalNotes" class="form-control" data-bind="value: $parent.approvalNotes" data-msg-required="Justification is required" required></textarea>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <div class="col-md-8 col-md-offset-4" data-bind="if: $parent.loanAccountStatus()">
                                                        <button data-bind="click: function(){$parent.loanAccountStatus(null);}" type="reset" class="btn btn-white">Cancel</button>
                                                        <button type="submit" class="btn btn-primary">Submit</button>
                                                    </div>
                                                </div>
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
</div>