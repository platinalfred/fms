<?php
$needed_files = array("dataTables", "iCheck", "steps", "jasny", "moment", "knockout");
$page_title = "My Profile";
include("include/header.php");
require_once("lib/Libraries.php");
$staff = new Staff();
$staff_data = $staff->findStaffDetails($_SESSION['id']);
if ($staff_data) {
    $access_roles = $staff->findAccessRoles($staff_data['personId']);
} else {
    ?>
    <h2>There was no staff selected</h2>
    <?php
}
if (isset($_POST['submit'])) {
    //print_r($_POST);
}
?>
<div class="modal fade" id="DescModal" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body">

            </div>

        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<div class="row">
    <div class="col-sm-11">
        <div class="ibox">
            <div class="ibox-content">
                <form  action="" method="post" name="edit_staff"  class="wizard-big">
                    <input type="hidden" name="id" value="<?php echo $_SESSION['id']; ?>">

                    <input type="hidden" name="tbl" value="update_staff">
                    <h1>My Profile</h1>
                    <fieldset>
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no_padding">Title</label>
                                    <div class="col-sm-8">
                                        <?php echo $staff_data['title']; ?>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-8" style="margin-bottom:11px;">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no_padding">Branch</label>
                                    <div class="col-sm-8">
                                        <?php
                                        $branch = new Branch();
                                        $branch_d = $branch->findById($staff_data['branch_id']);
                                        echo $branch_d['branch_name'];
                                        ?>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-8 bottom_pad" >
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">User Name <span class="req">*</span></label>
                                    <div class="col-md-8 col-sm-8 col-xs-12">
                                        <?php echo $staff_data['username']; ?>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-8 bottom_pad" >
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Password <span class="req">*</span></label>
                                    <div class="col-md-8 col-sm-8 col-xs-12">
                                        <input id="password" name="password" type="password" value="<?php echo $staff_data['pa	ssword']; ?>"  class="form-control" required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-8 bottom_pad" >
                                <div class="form-group">
                                    <label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Confirm Password <span class="req">*</span></label>
                                    <div class="col-md-8 col-sm-8 col-xs-12">
                                        <input id="password" name="password2" value="<?php echo $staff_data['password']; ?>" type="password" class="form-control" required>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-8">
                                <div class="col-sm-12">&nbsp;</div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label no_padding">Position</label>
                                    <div class="col-sm-9">
                                        <?php
                                        $position = new Position();
                                        $positions = $position->findAll();
                                        if ($positions) {
                                            foreach ($positions as $single) {
                                                if ($staff_data['position_id'] == $single['id']) {
                                                    echo $single['name'];
                                                }
                                            }
                                        }
                                        ?>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-8">
                                <div class="col-sm-12">&nbsp;</div>

                                <div class="col-sm-3 no_padding">
                                    <label style=""class="">Name <span class="req">*</span></label>
                                </div>
                                <div class="col-sm-8">
<?php echo $staff_data['firstname'] . " " . $staff_data['lastname'] . " " . $staff_data['othername']; ?>
                                </div>
                                <div class="col-sm-12">&nbsp;</div>


                                <label class="col-sm-3 control-label no_padding" >Gender <span class="req">*</span></label>
                                <div class="col-sm-9">
<?php echo $staff_data['gender']; ?>
                                </div>
                                <div class="col-sm-12">&nbsp;</div>
                                <label class="col-sm-3 control-label no_padding" >Date of Birth <span class="req">*</span></label>
                                <div class="col-sm-9">
<?php echo date("j F, Y", strtotime($staff_data['dateofbirth'])); ?>
                                </div>

                            </div>	
                        </div>

                    </fieldset>
                    <fieldset>

                        <div class="col-lg-4 form-group">
                            <button class="btn btn-xm btn-primary" type="submit" name="submit">Change Password</button>
                        </div>
                    </fieldset>
                </form>
            </div>

        </div>
    </div>

</div>
<?php
include("include/footer.php");
include("js/staff_js.php");

