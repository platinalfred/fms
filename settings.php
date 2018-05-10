<?php
/*
  include specific plugin files that you need on a page by  adding the names as below in the array
  dataTables, ChartJs,iCheck,daterangepicker,clockpicker,colorpicker,datapicker,easypiechart,fullcalendar,idle-timer,morris, nouslider, summernote,validate,wow,video,touchspin,Sparkline,Flot, Peity, Jvectormap, touchspin, select2, daterangepicker, clockpicker, ionRangeSlider, datapicker, nouslider, jasny, switchery, cropper, colorpicker, steps, dropzone, bootstrap-markdown
 */
$needed_files = array("dataTables", "iCheck", "jasny", "knockout", "moment");
$page_title = "Settings";
include("include/header.php");
require_once("lib/Libraries.php");
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-lg-12  m-b-md" style="padding-top:10px;">
        <div class="tabs-container">
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#tab-20" >Loan Products</a></li>
                <li><a data-toggle="tab" href="#tab-21" >Deposit Products</a></li>
                <li class=""><a data-toggle="tab"  href="#tab-9" >Loan Product Types</a></li>
                <li><a data-toggle="tab" href="#tab-23" >Share Rate</a></li>
                <li><a data-toggle="tab" href="#tab-1" >Person Types</a></li>
                <!--<li class=""><a data-toggle="tab" href="#tab-2">Account Types</a></li>-->
                <li class=""><a data-toggle="tab" href="#tab-3" >Branches</a></li>
                <li class=""><a data-toggle="tab" href="#tab-5" >Access Levels</a></li>
                <li class=""><a data-toggle="tab" href="#tab-17">Positions</a></li>

                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">More <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li class=""><a data-toggle="tab" role="tab" href="#tab-24">Loan Product Fees</a></li>
                        <li class=""><a data-toggle="tab" role="tab" href="#tab-25">Deposit Product Fees</a></li>

                        <li class=""><a data-toggle="tab" role="tab" href="#tab-7">Income Sources</a></li>
                        <li class=""><a data-toggle="tab" role="tab" href="#tab-8">Individual Types</a></li>

                        <li class=""><a data-toggle="tab" role="tab" href="#tab-14">Relationship Types </a></li>
                        <!--<li class=""><a data-toggle="tab" role="tab" href="#tab-15">Repayment Duration</a></li> -->
                        <li class=""><a role="tab" data-toggle="tab" href="#tab-6">Id Card Types</a></li>
                        <li class=""><a data-toggle="tab" role="tab" href="#tab-16">Security Types</a></li>

                        <!--<li class=""><a data-toggle="tab" role="tab" href="#tab-18" href="#">Address Type</a></li>-->
                        <li class=""><a data-toggle="tab" role="tab" href="#tab-19">Marital Status</a></li>
                        <li class=""><a data-toggle="tab" role="tab" href="#tab-22">Expense Type</a></li>
                    </ul>
                </li>
            </ul>
            <div class="tab-content">
                <!--  Person Type Start   -->
                <div id="tab-1" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_person_type-modal"><i class="fa fa-plus"></i> Add person type</a>
                            </div>
                            <div id="add_person_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="alert  alert-dismissable " id="notice_message"  style="display:none;">
                                                <button aria-hidden="true" data-dismiss="alert" class="close" type="submit">×</button>
                                                <div id="notice"></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add/Update Person Type.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" action="save_data.php" id="formPersonType">
                                                            <input name="tbl" value="tblPersonType" type="hidden">
                                                            <input name="id"  type="hidden">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit"><i class="ti-save"></i>Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblPersonType">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!--  End Person Type   -->
                <!--  Share Rate Start   -->
                <div id="tab-23" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-6 col-offset-sm-8">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-body">
                                        <div class="alert  alert-dismissable " id="notice_message"  style="display:none;">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="submit">×</button>
                                            <div id="notice"></div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <p>Manage Share Rate </p>
                                                <div class="ibox-content">
                                                    <?php
                                                    $shares_obj = new Shares();
                                                    $share_rate = $shares_obj->findShareRate();
                                                    ?>
                                                    <form class="form-horizontal" method="post" action="save_data.php" id="personTypeTable">
                                                        <input name="tbl" value="tblShareRate" type="hidden">
                                                        <div class="form-group"><label class="col-lg-4 control-label">Share Amount</label>
                                                            <div class="col-lg-8"><input name="amount" type="text" value="<?php echo number_format($share_rate['amount'], 0, ".", ","); ?>" class="form-control athousand_separator"> <span class="help-block m-b-none">An amount that is paid for a share.</span>
                                                            </div>
                                                        </div>
                                                        <div class="form-group"><label class="col-lg-4 control-label">Changed By</label>
                                                            <div class="col-lg-8"><?php echo $person->findNamesById($_SESSION['personId']); ?></div>
                                                            <input name="added_by" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
                                                            <input name="date_added" type="hidden" value="<?php echo time(); ?>">
                                                        </div>
                                                        <div class="form-group">
                                                            <div class="col-lg-offset-2 col-lg-10">
                                                                <button class="btn btn-sm btn-primary save" type="submit"><i class="ti-save"></i>Save</button>
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
                <!-- End Share Rate -->
                <!-- Account Type 
                <div id="tab-2" class="tab-pane">
                        <div class="panel-body">
                                <div class="col-lg-2 col-offset-sm-8">
                                        <div class="text-center">
                                                <a data-toggle="modal" class="btn btn-primary" href="#account_type-modal"><i class="fa fa-plus"></i> Add Account type</a>
                                        </div>
                                        <div id="account_type-modal" class="modal fade" aria-hidden="true">
                                                <div class="modal-dialog">
                                                        <div class="modal-content">
                                                                <div class="modal-body">
                                                                        <div class="alert  alert-dismissable " id="notice_message"  style="display:none;">
                                                                                <button aria-hidden="true" data-dismiss="alert" class="close" type="submit">×</button>
                                                                                <div id="notice"></div>
                                                                        </div>
                                                                        <div class="row">
                                                                                <div class="col-sm-12">
                                                                                        <p>Account Type</p>
                                                                                        <div class="ibox-content">
                                                                                                <form class="form-horizontal" method="post" id="formAccountType"> 
                                                                                                        <input type="hidden" name="tbl" value="tblAccountTypes">
                                                                                                        <input type="hidden" name="id" >
                                                                                                        <div class="form-group"><label class="col-lg-2 control-label">Title</label>
                                                                                                                <div class="col-lg-10"><input name="title" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Account type name.</span>
                                                                                                                </div>
                                                                                                        </div>
                                                                                                        <div class="form-group"><label class="col-lg-2 control-label">Minimum Balance</label>
                                                                                                                <div class="col-lg-10"><input id="minimum_balance" name="minimum_balance" type="text"  class="form-control"> <span class="help-block m-b-none">The minimum balance an account holder should keep on the account.</span>
                                                                                                                </div>
                                                                                                        </div>
                                                                                                        <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                                                                        </div>
                                                                                                        <div class="form-group">
                                                                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                                                                        <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                                <div class="col-lg-12" style="margin-top:10px;">
                                        <div class="ibox-content">
                                                <div class="table-responsive">
                                                        <table class="table table-striped table-bordered table-hover" id="account_types">
                                                                <thead>
                                                                <tr>
                                                                        <th>Name</th>
                                                                        <th>Minimum Balance</th>
                                                                        <th>Description</th>
                                                                        <th></th>
                                                                </tr>
                                                                </thead>
                                                                <tbody>
                                                                        
                                                                </tbody>
                                                        </table>
                                                </div>
                                        </div>
                                </div>
                        </div>
                </div>
                <! End Account Type -->
                <!-- Branch -->
                <div id="tab-3" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_branch-modal"><i class="fa fa-plus"></i> Add Branch</a>
                            </div>
                            <div id="add_branch-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Branch</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" id="formBranch">
                                                            <input type="hidden" name="tbl" value="tblBranches">
                                                            <input type="hidden" name="id" >
                                                            <div class="form-group"><label class="col-lg-2 control-label">Branch Name</label>
                                                                <div class="col-lg-10"><input type="text" name="branch_name"  placeholder="Branch Name" class="form-control" required > 
                                                                </div>
                                                            </div>

                                                            <div class="form-group"><label class="col-lg-2 control-label"> Office Phone</label>
                                                                <div class="col-sm-10">
                                                                    <input type="text" class="form-control" data-mask="(999) 999-9999" placeholder="" name="office_phone">
                                                                    <span class="help-block">(073) 000-0000</span>
                                                                </div>

                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Email Address</label>
                                                                <div class="col-lg-10"><input type="email" name="email_address"  placeholder="mail@example.com" class="form-control" > 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Physical Address</label>
                                                                <div class="col-lg-10"><textarea required name="physical_address" placeholder="Physical Address" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Postal Address</label>
                                                                <div class="col-lg-10"><input type="text" name="postal_address"  placeholder="Postal Address" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblBranch">
                                        <thead>
                                            <tr>
                                                <th>Branch Name</th>
                                                <th>Office Phone</th>
                                                <th>Email Address</th>
                                                <th>Physical Address</th>
                                                <th>Postal Address</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Branch -->
                <!-- Start Access Level -->
                <div id="tab-5" class="tab-pane ">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_access_level-modal"><i class="fa fa-plus"></i> Add Access Level</a>
                            </div>
                            <div id="add_access_level-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add Access Level.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" id="formAccessLevel">
                                                            <input type="hidden" name="tbl" value="tblAccessLevel">
                                                            <input type="hidden" name="id" value="">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>

                                                                <div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Access Level name (e.g Administrator).</span>
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblAccessLevel" >
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Access level-->
                <!-- Id Card Type-->
                <div id="tab-6" class="tab-pane ">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_id_card_type-modal"><i class="fa fa-plus"></i> Add Id Card Type</a>
                            </div>
                            <div id="add_id_card_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add / Update ID Card Type</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" id="formIdCardType">
                                                            <input type="hidden" name="tbl" value="tblIdCardType">
                                                            <input type="hidden" name="id" >
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>

                                                                <div class="col-lg-10"><input name="id_type" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">ID card Type (e.g National ID).</span>
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblIdCardType" >
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Income Source -->
                <div id="tab-7" class="tab-pane ">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_income_source-modal"><i class="fa fa-plus"></i> Add Income Source</a>
                            </div>
                            <div id="add_income_source-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add / Update Income Source.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" id="formIncomeSource">
                                                            <input name="tbl" value="tblIncomeSource" type="hidden">
                                                            <input name="id"  type="hidden">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Add source of organization income.</span>
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblIncomeSource">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Individual Type -->
                <div id="tab-8" class="tab-pane ">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_individual_type-modal"><i class="fa fa-plus"></i> Add Individual type</a>
                            </div>
                            <div id="add_individual_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add / Update Individual Type.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" id="formIndividualType">
                                                            <input type="hidden" name="tbl" value="tblIndividualType">
                                                            <input type="hidden" name="id" >
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>

                                                                <div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Specify the forms by which an individual can be registered (e.g Member Only).</span>
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblIndividualType" >
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Individual Type -->
                <!-- Loan Product Type -->
                <div id="tab-9" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" id="loan_product_type_modal" href="#add_loan_product_type-modal"><i class="fa fa-plus"></i> Add Loan Product type</a>
                            </div>
                            <div id="add_loan_product_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add/update Loan Product Type.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" method="post" id="formLoanProductType">
                                                            <input type="hidden" name="tbl" value="tblLoanProductType">
                                                            <input name="id"  type="hidden">
                                                            <input type="hidden" name="dateCreated" value="<?php echo time(); ?>">
                                                            <input type="hidden" name="dateModified" value="<?php echo time(); ?>">				
                                                            <input type="hidden" name="createdBy" value="<?php echo $_SESSION['staffId']; ?>">
                                                            <input type="hidden" name="modifiedBy" value="<?php echo $_SESSION['staffId']; ?>">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Title</label>

                                                                <div class="col-lg-10"><input name="typeName" type="text" placeholder="Name" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblLoanProductType">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Penalty Calculation Method Start -->		
                <div id="tab-12" class="tab-pane ">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_penalty_calculation_method-modal"><i class="fa fa-plus"></i>Add Penalty Calculation Method</a>
                            </div>
                            <div id="add_penalty_calculation_method-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add penalty  Calculation Method</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formPenaltyCalculationMethod">
                                                            <input type="hidden" name="tbl" value="penality_calculation">
                                                            <input type="hidden" name="dateCreated" value="<?php echo time(); ?>">
                                                            <input type="hidden" name="dateModified" value="<?php echo time(); ?>">				
                                                            <input type="hidden" name="createdBy" value="<?php echo $_SESSION['staffId']; ?>">
                                                            <input type="hidden" name="modifiedBy" value="<?php echo $_SESSION['staffId']; ?>">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Title</label>

                                                                <div class="col-lg-10"><input name="methodDescription" type="text" placeholder="Penalty Title" class="form-control"> <span class="help-block m-b-none">Title of the penalty.</span>
                                                                </div>
                                                            </div>

                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-lg btn-primary save" type="submit">Submit</button>
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


                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblPenaltyCalculationMethod">
                                        <thead>
                                            <tr>
                                                <th>Method</th>
                                                <th>Date Created</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Method</th>
                                                <th>Date Created</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!--End PenaltyCalculationMethod -->
                <!-- Relationship Type-->
                <div id="tab-14" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_relationship_type-modal"><i class="fa fa-plus"></i> Add Relationship type</a>
                            </div>
                            <div id="add_relationship_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add / Update Relationship Type.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formRelationshipType">
                                                            <input type="hidden" name="tbl"  value="tblRelationshipType">
                                                            <input type="hidden" name="id" >
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input type="text" name="rel_type" placeholder="Name" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblRelationshipType">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Relationship Type-->
                <!-- Repayment Duration 
                <div id="tab-15" class="tab-pane">
                        <div class="panel-body">
                                <div class="col-lg-2 col-offset-sm-8">
                                        <div class="text-center">
                                                <a data-toggle="modal" class="btn btn-primary" href="#loan_repayment_duration"><i class="fa fa-plus"></i> Add repayment duration</a>
                                        </div>
                                        <div id="loan_repayment_duration" class="modal fade" aria-hidden="true">
                                                <div class="modal-dialog">
                                                        <div class="modal-content">
                                                                <div class="modal-body">
                                                                        <div class="row">
                                                                                <div class="col-sm-12">
                                                                                        <p>Add repayment duration.</p>
                                                                                        <div class="ibox-content">
                                                                                                <form class="form-horizontal" id="tblRepaymentDuration">
                                                                                                        <input type="hidden" name="tbl" value="repayment_duration">
                                                                                                        <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                                                                <div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
                                                                                                                </div>
                                                                                                        </div>
                                                                                                        <div class="form-group"><label class="col-lg-2 control-label">Pay Back Days</label>
                                                                                                                <div class="col-lg-10"><input type="number" name="no_of_days" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Numbe of days to pay back a loan.</span>
                                                                                                                </div>
                                                                                                        </div>
                                                                                                        <div class="form-group">
                                                                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                                                                        <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                                <div class="col-lg-12" style="margin-top:10px;">
                                        <div class="ibox-content">
                                                <div class="table-responsive">
                                                        <table class="table table-striped table-bordered table-hover" id="loan_repayment_durations">
                                                                <thead>
                                                                <tr>
                                                                        <th>Name</th>
                                                                        <th>Pay Back Days</th>
                                                                        <th></th>
                                                                </tr>
                                                                </thead>
                                                                <tbody></tbody>
                                                                <tfoot>
                                                                        <tr>
                                                                                <th>Name</th>
                                                                                <th>Pay Back Days</th>
                                                                                <th></th>
                                                                        </tr>
                                                                </tfoot>
                                                        </table>
                                                </div>
                                        </div>
                                </div>
                                
                        </div>
                </div>
                <! End repayment duration -->
                <!-- Security Type -->
                <div id="tab-16" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_security_type-modal"><i class="fa fa-plus"></i> Add Security type</a>
                            </div>
                            <div id="add_security_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add / Update Security Type.</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formSecurityType">
                                                            <input type="hidden" name="id"  >
                                                            <input type="hidden" name="tbl"  value="tblSecurityType">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblSecurityType">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Security Type-->
                <!-- Position -->
                <div id="tab-17" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_position-modal"><i class="fa fa-plus"></i> Add Position</a>
                            </div>
                            <div id="add_position-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add /Update Position</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formPosition">
                                                            <input type="hidden" name="id" >
                                                            <input type="hidden" name="tbl"  value="tblPosition">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="item form-group">
                                                                <label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding" for="id_type">Access Level <span class="required">*</span>
                                                                </label>
                                                                <div class="col-md-9 col-sm-9 col-xs-12">
                                                                    <select class="form-control m-b" name="access_level_id" required >
                                                                        <option>Please select</option>
                                                                        <?php
                                                                        $access_level_obj = new AccessLevel();
                                                                        $access_level = $access_level_obj->findAll();
                                                                        if ($access_level) {
                                                                            foreach ($access_level as $single) {
                                                                                ?>
                                                                                <option value="<?php echo $single['id']; ?>" ><?php echo $single['name']; ?></option>
                                                                                <?php
                                                                            }
                                                                        }
                                                                        ?>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblPosition">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Access Level</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Access Level</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Position -->

                <!-- Address Type -->
                <div id="tab-18" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_address_type-modal"><i class="fa fa-plus"></i> Add Address Type</a>
                            </div>
                            <div id="add_address_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add Address Type</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formAdressType">
                                                            <input type="hidden" name="tbl" value="tblAddressTypes">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Type</label>
                                                                <div class="col-lg-10"><input type="text" name="address_type" placeholder="Adress Type" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblAddressTypes">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Edit / Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Address Type -->
                <!-- Marital Status -->
                <div id="tab-19" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_marital_status-modal"><i class="fa fa-plus"></i> Add Marital Status</a>
                            </div>
                            <div id="add_marital_status-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Add / update Marital Status</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formMaritalStatus">
                                                            <input type="hidden" name="id" >
                                                            <input type="hidden" name="tbl"  value="tblMaritalStatus">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input type="text" name="name" placeholder="Adress Type" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblMaritalStatus">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Edit / Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Marital Status -->
                <!-- Expense Type -->
                <div id="tab-22" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_expense_type-modal"><i class="fa fa-plus"></i> Add Expense Type</a>
                            </div>
                            <div id="add_expense_type-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <p>Expense Type</p>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formExpenseType">
                                                            <input type="hidden" name="tbl"  value="tblExpenseType">
                                                            <input type="hidden" name="id" id="id_field">
                                                            <div class="form-group"><label class="col-lg-2 control-label">Name</label>
                                                                <div class="col-lg-10"><input type="text" name="name" placeholder="Expense Type" class="form-control"> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group"><label class="col-lg-2 control-label">Description</label>
                                                                <div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-2 col-lg-10">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblExpenseType">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Edit / Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Expense Type -->
                <!-- Loan Products -->
                <div id="tab-20" class="tab-pane active">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_loan_product-modal"><i class="fa fa-plus"></i> Add Loan Product</a>
                            </div>
                            <div id="add_loan_product-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <?php include_once("views/loan_product.php"); ?>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblLoanProduct">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Product Type</th>
                                                <th>Edit/View/Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Product Type</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Loan Products -->
                <!-- Deposit Products -->
                <div id="tab-21" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_deposit_product-modal"><i class="fa fa-plus"></i> Add Deposit Product</a>
                            </div>
                            <div id="add_deposit_product-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <?php include_once("views/deposit_product.php"); ?>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblDepositProduct">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Product Type</th>
                                                <th>Edit / Delete</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Product Type</th>
                                                <th></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- End Deposit Products -->
                <!-- Loan Product Fees -->
                <div id="tab-24" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_loan_product_fee-modal"><i class="fa fa-plus"></i> Add Loan Product Fee</a>
                            </div>
                            <div id="add_loan_product_fee-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <div class="ibox-title">
                                                        <h5>Loan Product Fee</h5>
                                                        <div class="ibox-tools">
                                                            <a class="" data-dismiss="modal">
                                                                <i class="fa fa-times lg" style="color:red;"></i>
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formLoanProductFee">
                                                            <input type="hidden" name="tbl" value="tblLoanProductFee">
                                                            <input type="hidden" name="id">
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Fee Name</label>
                                                                <div class="col-lg-8">
                                                                    <input type="text" name="feeName" id="feeName" placeholder="Fee Name" class="form-control"/> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Amount Calculated As</label>
                                                                <div class="col-lg-8">
                                                                    <select class="form-control" id="amountCalculatedAs" name="amountCalculatedAs" data-bind="options: amountCalculatedAsOptions, optionsText: 'desc', optionsAfterRender: setOptionValue('id'), optionsCaption: 'Select...'">
                                                                        
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Rate/Amount</label>
                                                                <div class="col-lg-8">
                                                                    <input class="form-control input-sm required" type="number" name="amount" required/>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Fee Type</label>
                                                                <div class="col-lg-8">
                                                                    <select class="form-control" name="feeType" id="feeType" data-bind="options: feeTypesOptions, optionsText: 'description', optionsCaption: 'Select...', optionsAfterRender: setOptionValue('id')" data-msg-required="Fee type is required">
                                                                        
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Required Fee?</label>
                                                                <div class="col-lg-8">
                                                                    <select class="form-control" name="requiredFee" id="requiredFee" data-msg-required="Fee type is required">
                                                                        <option value="0">No</option>
                                                                        <option value="1">Yes</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-4 col-lg-8">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblLoanProductFee">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Amount Calculated As</th>
                                                <th>Amount</th>
                                                <th>Fee Type</th>
                                                <th>Required Fee?</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Amount Calculated As</th>
                                                <th>Amount</th>
                                                <th>Fee Type</th>
                                                <th>Required Fee?</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Loan Product Fee -->
                <!-- Deposit Product Fees -->
                <div id="tab-25" class="tab-pane">
                    <div class="panel-body">
                        <div class="col-lg-2 col-offset-sm-8">
                            <div class="text-center">
                                <a data-toggle="modal" class="btn btn-primary" href="#add_deposit_product_fee-modal"><i class="fa fa-plus"></i> Add Deposit Product Fee</a>
                            </div>
                            <div id="add_deposit_product_fee-modal" class="modal fade" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <div class="ibox-title">
                                                        <h5>Deposit Product Fee</h5>
                                                        <div class="ibox-tools">
                                                            <a class="" data-dismiss="modal">
                                                                <i class="fa fa-times lg" style="color:red;"></i>
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div class="ibox-content">
                                                        <form class="form-horizontal" id="formDepositProductFee">
                                                            <input type="hidden" name="tbl"  value="tblDepositProductFee">
                                                            <input type="hidden" name="id" id="id">
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Fee Name</label>
                                                                <div class="col-lg-8">
                                                                    <input type="text" name="feeName" id="feeName" placeholder="Fee Name" class="form-control" data-msg-required="Fee name  is required" required /> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Amount </label>
                                                                <div class="col-lg-8">
                                                                    <input type="text" name="amount" id="feeName" placeholder="Fee Amount" class="form-control" data-msg-required="Amount is required" required /> 
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-lg-4 control-label">Trigger</label>
                                                                <div class="col-lg-8">
                                                                    <select class="form-control" id="chargeTrigger" name="chargeTrigger" data-bind="options: chargeTriggerOptions, optionsText: 'desc', optionsAfterRender: setOptionValue('id'), optionsCaption: '--select--', value: chargeTrigger">
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <!-- ko with: chargeTrigger-->
                                                            <div class="form-group" data-bind='visible: id==2'>
                                                                <label class="col-lg-4 control-label">Date Application Method <sup data-toggle="tooltip" title="Method for calculating the day when the fee will be applied" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
                                                                <div class="col-lg-8">
                                                                    <select class="form-control " id="dateApplicationMethod" name="dateApplicationMethod" data-bind='options: dateApplicationMethodOptions, optionsText: "desc",  optionsAfterRender: setOptionValue("id"), optionsCaption: "Select..."' required="required">
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <!--/ko-->
                                                            <div class="form-group">
                                                                <div class="col-lg-offset-4 col-lg-8">
                                                                    <button class="btn btn-sm btn-primary save" type="submit">Submit</button>
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
                        <div class="col-lg-12" style="margin-top:10px;">
                            <div class="ibox-content">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover" id="tblDepositProductFee">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Amount, Flat(UGX)</th>
                                                <th title="Method for calculating the day when the fee will be applied">Trigger</th>
                                                <th>Date Application Method</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th>Name</th>
                                                <th>Amount, Flat(UGX)</th>
                                                <th>Trigger</th>
                                                <th>Date Appln. Method</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Deposit Product Fee -->
            </div>
        </div>
    </div>
</div>
<?php
include("js/settings_js.php");
include("include/footer.php");
