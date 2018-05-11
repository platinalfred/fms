<?php
$needed_files = array("dataTables", "iCheck", "steps", "jasny");
include("include/header.php");
$member = new Member();
?>
<div class="wrapper wrapper-content  animated fadeInRight">
    <div class="text-center">
        <a data-toggle="modal" class="btn btn-primary" href="#modal-form">Form in simple modal box</a>
    </div>
    <div id="modal-form" class="modal fade " aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-body">
                    <form id="form" action="#" class="wizard-big">
                        <h1>Account</h1>
                        <fieldset>
                            <h2>Account Information</h2>
                            <div class="row">
                                <div class="col-lg-8">
                                    <div class="form-group">
                                        <label>Username *</label>
                                        <input id="userName" name="userName" type="text" class="form-control required">
                                    </div>
                                    <div class="form-group">
                                        <label>Password *</label>
                                        <input id="password" name="password" type="text" class="form-control required">
                                    </div>
                                    <div class="form-group">
                                        <label>Confirm Password *</label>
                                        <input id="confirm" name="confirm" type="text" class="form-control required">
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="text-center">
                                        <div style="margin-top: 20px">
                                            <i class="fa fa-sign-in" style="font-size: 180px;color: #e5e5e5 "></i>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </fieldset>
                        <h1>Profile</h1>
                        <fieldset>
                            <h2>Profile Information</h2>
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>First name *</label>
                                        <input id="name" name="name" type="text" class="form-control required">
                                    </div>
                                    <div class="form-group">
                                        <label>Last name *</label>
                                        <input id="surname" name="surname" type="text" class="form-control required">
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>Email *</label>
                                        <input id="email" name="email" type="text" class="form-control required email">
                                    </div>
                                    <div class="form-group">
                                        <label>Address *</label>
                                        <input id="address" name="address" type="text" class="form-control">
                                    </div>
                                </div>
                            </div>
                        </fieldset>

                        <h1>Warning</h1>
                        <fieldset>
                            <div class="text-center" style="margin-top: 120px">
                                <h2>You did it Man :-)</h2>
                            </div>
                        </fieldset>

                        <h1>Finish</h1>
                        <fieldset>
                            <h2>Terms and Conditions</h2>
                            <input id="acceptTerms" name="acceptTerms" type="checkbox" class="required"> <label for="acceptTerms">I agree with the Terms and Conditions.</label>
                        </fieldset>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <?php include("add_member_modal.php"); ?>
        <div class="col-sm-8">
            <div class="ibox">
                <div class="ibox-content">
                    <span class="text-muted small pull-right">Last modification: <i class="fa fa-clock-o"></i> 2:10 pm - 12.06.2014</span>
                    <h2>Members & Member Groups</h2>

                    <div class="col-sm-5 text-muted small pull-left" style="padding:10px;"><a data-toggle="modal" class="btn btn-primary" href="#add_member"><i class="fa fa-plus"></i> Add Member</a></div>
                    <div class="clear:both;"></div>
                    <div class="input-group">
                        <input type="text" placeholder="Search client " class="input form-control">
                        <span class="input-group-btn">
                            <button type="button" class="btn btn btn-primary"> <i class="fa fa-search"></i> Search Member</button>
                        </span>
                    </div>
                    <div class="clients-list">
                        <ul class="nav nav-tabs">
                            <span class="pull-right small text-muted">1406 Elements</span>
                            <li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-user"></i> Contacts</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-2"><i class="fa fa-briefcase"></i> Companies</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-1" class="tab-pane active">
                                <div class="full-height-scroll">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <tbody>
                                                <tr>
                                                    <td class="client-avatar"><img alt="image" src="img/a2.jpg"> </td>
                                                    <td><a data-toggle="tab" href="#contact-1" class="client-link">Anthony Jackson</a></td>
                                                    <td> Tellus Institute</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> gravida@rbisit.com</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><img alt="image" src="img/a3.jpg"> </td>
                                                    <td><a data-toggle="tab" href="#contact-2" class="client-link">Rooney Lindsay</a></td>
                                                    <td>Proin Limited</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> rooney@proin.com</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><img alt="image" src="img/a4.jpg"> </td>
                                                    <td><a data-toggle="tab" href="#contact-3" class="client-link">Lionel Mcmillan</a></td>
                                                    <td>Et Industries</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +432 955 908</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a5.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-4" class="client-link">Edan Randall</a></td>
                                                    <td>Integer Sem Corp.</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +422 600 213</td>
                                                    <td class="client-status"><span class="label label-warning">Waiting</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a6.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-2" class="client-link">Jasper Carson</a></td>
                                                    <td>Mone Industries</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +400 468 921</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a7.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-3" class="client-link">Reuben Pacheco</a></td>
                                                    <td>Magna Associates</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> pacheco@manga.com</td>
                                                    <td class="client-status"><span class="label label-info">Phoned</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a1.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-1" class="client-link">Simon Carson</a></td>
                                                    <td>Erat Corp.</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> Simon@erta.com</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a3.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-2" class="client-link">Rooney Lindsay</a></td>
                                                    <td>Proin Limited</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> rooney@proin.com</td>
                                                    <td class="client-status"><span class="label label-warning">Waiting</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a4.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-3" class="client-link">Lionel Mcmillan</a></td>
                                                    <td>Et Industries</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +432 955 908</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a5.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-4" class="client-link">Edan Randall</a></td>
                                                    <td>Integer Sem Corp.</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +422 600 213</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a2.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-1" class="client-link">Anthony Jackson</a></td>
                                                    <td> Tellus Institute</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> gravida@rbisit.com</td>
                                                    <td class="client-status"><span class="label label-danger">Deleted</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a7.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-2" class="client-link">Reuben Pacheco</a></td>
                                                    <td>Magna Associates</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> pacheco@manga.com</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a5.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-3"class="client-link">Edan Randall</a></td>
                                                    <td>Integer Sem Corp.</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +422 600 213</td>
                                                    <td class="client-status"><span class="label label-info">Phoned</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a6.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-4" class="client-link">Jasper Carson</a></td>
                                                    <td>Mone Industries</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +400 468 921</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a7.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-2" class="client-link">Reuben Pacheco</a></td>
                                                    <td>Magna Associates</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> pacheco@manga.com</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a1.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-1" class="client-link">Simon Carson</a></td>
                                                    <td>Erat Corp.</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> Simon@erta.com</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a3.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-3" class="client-link">Rooney Lindsay</a></td>
                                                    <td>Proin Limited</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> rooney@proin.com</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a4.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-4" class="client-link">Lionel Mcmillan</a></td>
                                                    <td>Et Industries</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +432 955 908</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a5.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-1" class="client-link">Edan Randall</a></td>
                                                    <td>Integer Sem Corp.</td>
                                                    <td class="contact-type"><i class="fa fa-phone"> </i></td>
                                                    <td> +422 600 213</td>
                                                    <td class="client-status"><span class="label label-info">Phoned</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a2.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-2" class="client-link">Anthony Jackson</a></td>
                                                    <td> Tellus Institute</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> gravida@rbisit.com</td>
                                                    <td class="client-status"><span class="label label-warning">Waiting</span></td>
                                                </tr>
                                                <tr>
                                                    <td class="client-avatar"><a href="#"><img alt="image" src="img/a7.jpg"></a> </td>
                                                    <td><a data-toggle="tab" href="#contact-4" class="client-link">Reuben Pacheco</a></td>
                                                    <td>Magna Associates</td>
                                                    <td class="contact-type"><i class="fa fa-envelope"> </i></td>
                                                    <td> pacheco@manga.com</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-2" class="tab-pane">
                                <div class="full-height-scroll">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <tbody>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-1" class="client-link">Tellus Institute</a></td>
                                                    <td>Rexton</td>
                                                    <td><i class="fa fa-flag"></i> Angola</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Velit Industries</a></td>
                                                    <td>Maglie</td>
                                                    <td><i class="fa fa-flag"></i> Luxembourg</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-3" class="client-link">Art Limited</a></td>
                                                    <td>Sooke</td>
                                                    <td><i class="fa fa-flag"></i> Philippines</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-1" class="client-link">Tempor Arcu Corp.</a></td>
                                                    <td>Eisden</td>
                                                    <td><i class="fa fa-flag"></i> Korea, North</td>
                                                    <td class="client-status"><span class="label label-warning">Waiting</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Penatibus Consulting</a></td>
                                                    <td>Tribogna</td>
                                                    <td><i class="fa fa-flag"></i> Montserrat</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-3" class="client-link"> Ultrices Incorporated</a></td>
                                                    <td>Basingstoke</td>
                                                    <td><i class="fa fa-flag"></i> Tunisia</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Et Arcu Inc.</a></td>
                                                    <td>Sioux City</td>
                                                    <td><i class="fa fa-flag"></i> Burundi</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-1" class="client-link">Tellus Institute</a></td>
                                                    <td>Rexton</td>
                                                    <td><i class="fa fa-flag"></i> Angola</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Velit Industries</a></td>
                                                    <td>Maglie</td>
                                                    <td><i class="fa fa-flag"></i> Luxembourg</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-3" class="client-link">Art Limited</a></td>
                                                    <td>Sooke</td>
                                                    <td><i class="fa fa-flag"></i> Philippines</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-1" class="client-link">Tempor Arcu Corp.</a></td>
                                                    <td>Eisden</td>
                                                    <td><i class="fa fa-flag"></i> Korea, North</td>
                                                    <td class="client-status"><span class="label label-warning">Waiting</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Penatibus Consulting</a></td>
                                                    <td>Tribogna</td>
                                                    <td><i class="fa fa-flag"></i> Montserrat</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-3" class="client-link"> Ultrices Incorporated</a></td>
                                                    <td>Basingstoke</td>
                                                    <td><i class="fa fa-flag"></i> Tunisia</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Et Arcu Inc.</a></td>
                                                    <td>Sioux City</td>
                                                    <td><i class="fa fa-flag"></i> Burundi</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-1" class="client-link">Tellus Institute</a></td>
                                                    <td>Rexton</td>
                                                    <td><i class="fa fa-flag"></i> Angola</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Velit Industries</a></td>
                                                    <td>Maglie</td>
                                                    <td><i class="fa fa-flag"></i> Luxembourg</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-3" class="client-link">Art Limited</a></td>
                                                    <td>Sooke</td>
                                                    <td><i class="fa fa-flag"></i> Philippines</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-1" class="client-link">Tempor Arcu Corp.</a></td>
                                                    <td>Eisden</td>
                                                    <td><i class="fa fa-flag"></i> Korea, North</td>
                                                    <td class="client-status"><span class="label label-warning">Waiting</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Penatibus Consulting</a></td>
                                                    <td>Tribogna</td>
                                                    <td><i class="fa fa-flag"></i> Montserrat</td>
                                                    <td class="client-status"></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-3" class="client-link"> Ultrices Incorporated</a></td>
                                                    <td>Basingstoke</td>
                                                    <td><i class="fa fa-flag"></i> Tunisia</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                                <tr>
                                                    <td><a data-toggle="tab" href="#company-2" class="client-link">Et Arcu Inc.</a></td>
                                                    <td>Sioux City</td>
                                                    <td><i class="fa fa-flag"></i> Burundi</td>
                                                    <td class="client-status"><span class="label label-primary">Active</span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-4">
            <div class="ibox ">

                <div class="ibox-content">
                    <div class="tab-content">
                        <div id="contact-1" class="tab-pane active">
                            <div class="row m-b-lg">
                                <div class="col-lg-4 text-center">
                                    <h2>Nicki Smith</h2>

                                    <div class="m-b-sm">
                                        <img alt="image" class="img-circle" src="img/a2.jpg"
                                             style="width: 62px">
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <strong>
                                        About me
                                    </strong>

                                    <p>
                                        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                                        tempor incididunt ut labore et dolore magna aliqua.
                                    </p>
                                    <button type="button" class="btn btn-primary btn-sm btn-block"><i
                                            class="fa fa-envelope"></i> Send Message
                                    </button>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> 09:00 pm </span>
                                            Please contact me
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 10:16 am </span>
                                            Sign a contract
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 08:22 pm </span>
                                            Open new shop
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 11:06 pm </span>
                                            Call back to Sylvia
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 12:00 am </span>
                                            Write a letter to Sandra
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                                        tempor incididunt ut labore et dolore magna aliqua.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="contact-2" class="tab-pane">
                            <div class="row m-b-lg">
                                <div class="col-lg-4 text-center">
                                    <h2>Edan Randall</h2>

                                    <div class="m-b-sm">
                                        <img alt="image" class="img-circle" src="img/a3.jpg"
                                             style="width: 62px">
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <strong>
                                        About me
                                    </strong>

                                    <p>
                                        Many desktop publishing packages and web page editors now use Lorem Ipsum as their default tempor incididunt model text.
                                    </p>
                                    <button type="button" class="btn btn-primary btn-sm btn-block"><i
                                            class="fa fa-envelope"></i> Send Message
                                    </button>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> 09:00 pm </span>
                                            Lorem Ipsum available
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 10:16 am </span>
                                            Latin words, combined
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 08:22 pm </span>
                                            Open new shop
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 11:06 pm </span>
                                            The generated Lorem Ipsum
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 12:00 am </span>
                                            Content here, content here
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="contact-3" class="tab-pane">
                            <div class="row m-b-lg">
                                <div class="col-lg-4 text-center">
                                    <h2>Jasper Carson</h2>

                                    <div class="m-b-sm">
                                        <img alt="image" class="img-circle" src="img/a4.jpg"
                                             style="width: 62px">
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <strong>
                                        About me
                                    </strong>

                                    <p>
                                        Latin professor at Hampden-Sydney College in Virginia, looked  embarrassing hidden in the middle.
                                    </p>
                                    <button type="button" class="btn btn-primary btn-sm btn-block"><i
                                            class="fa fa-envelope"></i> Send Message
                                    </button>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> 09:00 pm </span>
                                            Aldus PageMaker including
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 10:16 am </span>
                                            Finibus Bonorum et Malorum
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 08:22 pm </span>
                                            Write a letter to Sandra
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 11:06 pm </span>
                                            Standard chunk of Lorem
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 12:00 am </span>
                                            Open new shop
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="contact-4" class="tab-pane">
                            <div class="row m-b-lg">
                                <div class="col-lg-4 text-center">
                                    <h2>Reuben Pacheco</h2>

                                    <div class="m-b-sm">
                                        <img alt="image" class="img-circle" src="img/a5.jpg"
                                             style="width: 62px">
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <strong>
                                        About me
                                    </strong>

                                    <p>
                                        Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero,written in 45 BC. This book is a treatise on.
                                    </p>
                                    <button type="button" class="btn btn-primary btn-sm btn-block"><i
                                            class="fa fa-envelope"></i> Send Message
                                    </button>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> 09:00 pm </span>
                                            The point of using
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 10:16 am </span>
                                            Lorem Ipsum is that it has
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 08:22 pm </span>
                                            Text, and a search for 'lorem ipsum'
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 11:06 pm </span>
                                            Passages of Lorem Ipsum
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> 12:00 am </span>
                                            If you are going
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="company-1" class="tab-pane">
                            <div class="m-b-lg">
                                <h2>Tellus Institute</h2>

                                <p>
                                    Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero,written in 45 BC. This book is a treatise on.
                                </p>
                                <div>
                                    <small>Active project completion with: 48%</small>
                                    <div class="progress progress-mini">
                                        <div style="width: 48%;" class="progress-bar"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> <span class="label label-primary">NEW</span> </span>
                                            The point of using
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> <span class="label label-warning">WAITING</span></span>
                                            Lorem Ipsum is that it has
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> <span class="label label-danger">BLOCKED</span> </span>
                                            If you are going
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="company-2" class="tab-pane">
                            <div class="m-b-lg">
                                <h2>Penatibus Consulting</h2>

                                <p>
                                    There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some.
                                </p>
                                <div>
                                    <small>Active project completion with: 22%</small>
                                    <div class="progress progress-mini">
                                        <div style="width: 22%;" class="progress-bar"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> <span class="label label-warning">WAITING</span> </span>
                                            Aldus PageMaker
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"><span class="label label-primary">NEW</span> </span>
                                            Lorem Ipsum, you need to be sure
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"> <span class="label label-danger">BLOCKED</span> </span>
                                            The generated Lorem Ipsum
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="company-3" class="tab-pane">
                            <div class="m-b-lg">
                                <h2>Ultrices Incorporated</h2>

                                <p>
                                    Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text.
                                </p>
                                <div>
                                    <small>Active project completion with: 72%</small>
                                    <div class="progress progress-mini">
                                        <div style="width: 72%;" class="progress-bar"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="client-detail">
                                <div class="full-height-scroll">

                                    <strong>Last activity</strong>

                                    <ul class="list-group clear-list">
                                        <li class="list-group-item fist-item">
                                            <span class="pull-right"> <span class="label label-danger">BLOCKED</span> </span>
                                            Hidden in the middle of text
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right"><span class="label label-primary">NEW</span> </span>
                                            Non-characteristic words etc.
                                        </li>
                                        <li class="list-group-item">
                                            <span class="pull-right">  <span class="label label-warning">WAITING</span> </span>
                                            Bonorum et Malorum
                                        </li>
                                    </ul>
                                    <strong>Notes</strong>
                                    <p>
                                        There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour.
                                    </p>
                                    <hr/>
                                    <strong>Timeline activity</strong>
                                    <div id="vertical-timeline" class="vertical-container dark-timeline">
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-bolt"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>There are many variations of passages of Lorem Ipsum available.
                                                </p>
                                                <span class="vertical-date small text-muted"> 06:10 pm - 11.03.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon navy-bg">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>The generated Lorem Ipsum is therefore.
                                                </p>
                                                <span class="vertical-date small text-muted"> 02:50 pm - 03.10.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-coffee"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Conference on the sales results for the previous year.
                                                </p>
                                                <span class="vertical-date small text-muted"> 2:10 pm - 12.06.2014 </span>
                                            </div>
                                        </div>
                                        <div class="vertical-timeline-block">
                                            <div class="vertical-timeline-icon gray-bg">
                                                <i class="fa fa-briefcase"></i>
                                            </div>
                                            <div class="vertical-timeline-content">
                                                <p>Many desktop publishing packages and web page editors now use Lorem.
                                                </p>
                                                <span class="vertical-date small text-muted"> 4:20 pm - 10.05.2014 </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
include("include/footer.php");
?>    
<script>
    $(document).ready(function () {
        var dTable;
        $(".save").click(function () {
            var frmdata = $(this).closest("form").serialize();
            $.ajax({
                url: "save_data.php",
                type: 'POST',
                data: frmdata,
                success: function (response) {
                    alert(response);
                    if ($.trim(response) == "success") {
                        showStatusMessage("Successfully added new record", "success");
                        setTimeout(function () {
                            dTable.ajax.reload();
                            hideStatusMessage();
                        }, 2000);
                    } else {

                        showStatusMessage(response, "fail");
                        setTimeout(function () {
                            hideStatusMessage();
                        }, 5000);
                    }

                }
            });

            return false;
        });
        if ($("#members").length) {
            dTable = $('#members').DataTable({
                dom: "lfrtipB",
                "processing": true,
                "serverSide": true,
                "deferRender": true,
                "order": [[1, 'asc']], /**/
                "ajax": {
                    "url": "settings_data.php",
                    "type": "JSON",
                    "type": "POST",
                    "data": function (d) {
                        d.tbl = 'person_type';
                        //d.start_date = getStartDate();
                        //d.end_date = getEndDate();
                    }
                }, "columnDefs": [{
                        "targets": [2],
                        "orderable": false,
                        "searchable": false
                    }/* , {
                     "targets": [0],
                     "orderable": false
                     } */],
                columns: [{data: 'photo', render: function (data, type, full, meta) {
                            return (data !== null) ? '<img alt="image" src="' + data + '">' : "";
                        }},
                    {data: 'person_number'},
                    {data: 'firstname'},
                    {data: 'id', render: function (data, type, full, meta) {
                            return '<a data-toggle="modal" href="#edit_person_type" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-person_type-personTypeTable" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                        }}

                ],
                buttons: [
                    {
                        extend: "copy",
                        className: "btn-sm"
                    },
                    {
                        extend: "csv",
                        className: "btn-sm"
                    },
                    {
                        extend: "excel",
                        className: "btn-sm"
                    },
                    {
                        extend: "pdfHtml5",
                        className: "btn-sm"
                    },
                    {
                        extend: "print",
                        className: "btn-sm"
                    },
                ],
                responsive: true,
            });
            //$("#datatable-buttons").DataTable();
        }

        getChangeValues();
        var parish_id = $("#parish_select").val();
        getVillage(parish_id);
        function getChangeValues() {
            $("#parish_select").on('change', function () {
                var id = $(this).val();
                getVillage(id);
            });
        }
        function getParishes(subcounty_id) {
            $.ajax({
                type: "post",
                url: "find_location.php?subcounty=" + subcounty_id,
                success: function (response) {
                    $("#parish").html(response);
                    setTimeout(function () {
                        var parish = $("#parish_select").val();
                        getVillage(parish);
                    }, 200);
                }
            });
        }
        function getVillage(parish_id) {
            $.ajax({
                type: "post",
                url: "find_location.php?parish=" + parish_id,
                success: function (response) {
                    $("#village").html(response);
                    getChangeValues();
                }
            });
        }

        $("#form").steps({
            bodyTag: "fieldset",
            onStepChanging: function (event, currentIndex, newIndex) {
                // Always allow going backward even if the current step contains invalid fields!
                if (currentIndex > newIndex) {
                    return true;
                }
                // Forbid suppressing "Warning" step if the user is to young
                if (newIndex === 3 && Number($("#age").val()) < 18) {
                    return false;
                }
                var form = $(this);

                // Clean up if user went backward before
                if (currentIndex < newIndex)
                {
                    // To remove error styles
                    $(".body:eq(" + newIndex + ") label.error", form).remove();
                    $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
                }

                // Disable validation on fields that are disabled or hidden.
                form.validate().settings.ignore = ":disabled,:hidden";

                // Start validation; Prevent going forward if false
                return form.valid();
            },
            onStepChanged: function (event, currentIndex, priorIndex)
            {
                // Suppress (skip) "Warning" step if the user is old enough.
                if (currentIndex === 2 && Number($("#age").val()) >= 18)
                {
                    $(this).steps("next");
                }

                // Suppress (skip) "Warning" step if the user is old enough and wants to the previous step.
                if (currentIndex === 2 && priorIndex === 3)
                {
                    $(this).steps("previous");
                }
            },
            onFinishing: function (event, currentIndex)
            {
                var form = $(this);

                // Disable validation on fields that are disabled.
                // At this point it's recommended to do an overall check (mean ignoring only disabled fields)
                form.validate().settings.ignore = ":disabled";

                // Start validation; Prevent form submission if false
                return form.valid();
            },
            onFinished: function (event, currentIndex)
            {
                var form = $(this);

                // Submit form input
                form.submit();
            }
        }).validate({
            errorPlacement: function (error, element)
            {
                element.before(error);
            },
            rules: {
                confirm: {
                    equalTo: "#password"
                }
            }
        });
    });
</script> 