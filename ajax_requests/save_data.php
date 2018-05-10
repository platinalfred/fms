<?php

require_once('../lib/Libraries.php');
require_once("../lib/SimpleImage.php");
$images = new SimpleImage();

//function to save the fees to be levied on a given loan product
function save_loan_product_fees($data, $loanProductId) {
    require_once('../lib/LoanProductFeen.php');

    $feedback = "success";
    $loanProductFeenObj = new LoanProductFeen();
    if (isset($data['existingLoanProductFees'])) {
        //some fees could have been deleted, so we delete them from the database
        if (!$loanProductFeenObj->del("loan_product_feen", "`id` NOT IN (" . (implode(",", $data['existingLoanProductFees'])) . ") AND `loanProductId` = $loanProductId")) {
            $feedback = "false";
        }
    }
    if (isset($data['newLoanProductFees'])) {
        foreach ($data['newLoanProductFees'] as $productFeeDataItem) {
            if (is_numeric($productFeeDataItem['loanProductFeeId'])) {
                $productFeeDataItem['dateCreated'] = time();
                $productFeeDataItem['createdBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
                $productFeeDataItem['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
                $productFeeDataItem['loanProductId'] = $loanProductId;
                if (!$loanProductFeenObj->addLoanProductFeen($productFeeDataItem)) {
                    $feedback = "false";
                }
            }
        }
    }
    return $feedback;
}

//function to save the fees to be levied on a given deposit product
function save_deposit_product_fees($data, $depositProductId) {
    require_once('../lib/DepositProductFeen.php');
    $deposit_product_feen_obj = new DepositProductFeen();
    $feedback = "success";
    if (isset($data['existingDepositProductFees'])) {
        //some fees could have been deleted, so we delete them from the database
        if ($deposit_product_feen_obj->del("deposit_product_feen", "`id` NOT IN (" . (implode(",", $data['existingDepositProductFees'])) . ") AND `depositProductId` = $depositProductId") === false) {
            $feedback = "false";
        }
    }
    if (isset($data['newDepositProductFees'])) {
        foreach ($data['newDepositProductFees'] as $productFeeDataItem) {
            if (is_numeric($productFeeDataItem['depositProductFeeId'])) {
                $productFeeDataItem['dateCreated'] = time();
                $productFeeDataItem['createdBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
                $productFeeDataItem['dateModified'] = time();
                $productFeeDataItem['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
                $productFeeDataItem['depositProductId'] = $depositProductId;
                if (!$deposit_product_feen_obj->addDepositProductFeen($productFeeDataItem)) {
                    $feedback = "false";
                }
            }
        }
    }
    return $feedback;
}

$output = "Data was not saved";
if (isset($_POST['tbl'])) {
    $data = $_POST;
    switch ($data['tbl']) {
        case "add_subscription":
            $subscribe = new Subscription();
            if ($subscribe->addSubscription($data)) {
                $output = "success";
            } else {
                $output = "Member subscription could not be added. Please try again or contact admin for assistance!";
            }
            break;
        case "add_share":
            $shares = new Shares();
            if ($shares->addShares($data)) {
                $output = "success";
            } else {
                $output = "Member Share could not be added. Please try again or contact admin for assistance!";
            }
            break;
        case "tblShareRate":
            $shares = new Shares();
            if ($shares->addShareRate($data)) {
                $output = "success";
            } else {
                $output = "Share rate could not be added. Please try again or contact admin for assistance!";
            }
            break;
        case "add_group":
            $sacco_group = new SaccoGroup();
            $group_id = $sacco_group->addSaccoGroup($data);
            if ($group_id) {
                $data['groupId'] = $group_id;
                if (!empty($data['members'])) {
                    foreach ($data['members'] as $single) {
                        $data['memberId'] = $single['memberId'];
                        $sacco_group->addSaccoGroupMembers($data);
                    }
                }
                $output = "success";
            } else {
                $output = "Group details could not be added. Please try again or contact admin for assistance!";
            }
            break;
        case "update_group":
            $sacco_group = new SaccoGroup();
            if ($sacco_group->updateSaccoGroup($data)) {
                if (!empty($data['members'])) {
                    foreach ($data['members'] as $single) {
                        $data['memberId'] = $single['memberId'];
                        $sacco_group->addSaccoGroupMembers($data);
                    }
                }
                $output = "success";
            } else {
                $output = "Group details could not be added. Please try again or contact admin for assistance!";
            }
            break;
        //UPDATE STAFF
        case "update_staff":
            $staff = new Staff();
            $person = new Person();
            $data['id'] = $data['personId'];
            $data['dateofbirth'] = date("Y-m-d", strtotime($data['dateofbirth']));
            if ($person->updatePerson($data)) {
                if (!empty($data['access_levels'])) {
                    foreach ($_POST['access_levels'] as $single) {
                        $data['role_id'] = $single;
                        $staff->updateStaffAccessLevels($data);
                    }
                }
                $data['id'] = $_POST['member_id'];
                $hash = password_hash($data['password'], PASSWORD_DEFAULT, ['cost' => 12]);
                if (password_needs_rehash($hash, PASSWORD_DEFAULT, ['cost' => 12])) {
                    $data['password2'] = $hash;
                }
                if ($staff->updateStaff($data)) {
                    $output = "success";
                }
            } else {
                $output = "Staff details could not be updated. Please try again!";
            }
            break;
        //ADD STAFF
        case "add_staff":
            $staff = new Staff();
            $person = new Person();
            $data['dateofbirth'] = date("Y-m-d", strtotime($data['dateofbirth']));
            $data['date_added'] = date("Y-m-d");
            $data['photograph'] = "";
            $data['active'] = 1;
            $person_id = $person->addPerson($data);
            if ($person_id) {
                $data['personId'] = $person_id;
                $person->updateStaffNumber($person_id);
                if (!empty($_POST['access_levels'])) {
                    foreach ($_POST['access_levels'] as $single) {
                        $data['role_id'] = $single;
                        $staff->addStaffAccessLevels($data);
                    }
                }
                $data['password2'] = password_hash($data['password'], PASSWORD_DEFAULT, ['cost' => 12]);
                if ($staff->addStaff($data)) {
                    $output = "success";
                }
            } else {
                $output = "Staff details could not be added. Please try again!";
            }
            break;
        case "add_member":
            $member = new Member();
            $person = new Person();
            $data['date_registered'] = date("Y-m-d");
            $data['dateofbirth'] = date("Y-m-d", strtotime($data['dateofbirth']));
            $data['dateAdded'] = time();
            $data['photograph'] = "";
            $data['active'] = 1;

            $person_id = $person->addPerson($data);
            if ($person_id) {
                $data['personId'] = $person_id;
                $person->updatePersonNumber($person_id);
                $data["personId"] = $person_id;
                $data['branchId'] = $data['branch_id'];
                $data['addedBy'] = $data['modifiedBy'];
                //$data['dateAdded'] = $data['date_registered'];

                if (!empty($data['relative'])) {
                    foreach ($data['relative'] as $single) {
                        $single['personId'] = $person_id;
                        $person->addRelative($single);
                    }
                }
                if (!empty($data['employment'])) {
                    foreach ($data['employment'] as $single) {
                        $single['personId'] = $person_id;
                        $person->addPersonEmployment($single);
                    }
                }
                if (!empty($data['business'])) {
                    foreach ($data['business'] as $single) {
                        $single['dateAdded'] = $data['dateAdded'];
                        $single['addedBy'] = $data['addedBy'];
                        $single['personId'] = $person_id;
                        $person->addPersonBusiness($single);
                    }
                }

                if ($member->addMember($data)) {
                    $output = "success";
                }
                if ($_FILES['id_specimen']['error'] > 0) {
                    $output = "Error: " . $_FILES['id_specimen']['error'] . "<br />";
                } else {
                    $allowedExts = array("gif", "jpeg", "jpg", "png", "JPG", "PNG", "GIF", "application/pdf");
                    $extension = end(explode(".", $_FILES["id_specimen"]["name"]));
                    if (($_FILES["id_specimen"]["size"] < 200000000) && in_array($extension, $allowedExts)) {
                        if ($_FILES["id_specimen"]["error"] > 0) {
                            $output = "Return Code: " . $_FILES["id_specimen"]["error"] . "<br>";
                        } else {
                            $normal = 'img/ids/' . $_FILES['id_specimen']['name'];
                            if (file_exists($normal)) {
                                $data['id_specimen'] = $normal;
                                $data['id'] = $person_id;
                                if ($person->updateSpecimen($data)) {
                                    $output = 'success';
                                } else {
                                    $output = "Oooooops!! there was an error! ";
                                }
                            } else {
                                $data['id_specimen'] = $normal;
                                $data['id'] = $person_id;
                                $images->load($_FILES['id_specimen']['tmp_name']);
                                //$images->resize(131, 120); 
                                $images->output($_FILES["id_specimen"]["type"]);
                                $images->save('img/ids/' . $_FILES['id_specimen']['name']);
                                if ($person->updateSpecimen($data)) {
                                    $output = 'success';
                                } else {
                                    $output = "Oooooops!! there was an error! ";
                                }
                            }
                        }
                    }
                }
            } else {
                $output = "Member details could not be added. Please try again!";
            }
            break;
        case "update_member":
            $member = new Member();
            $person = new Person();

            if (empty($_FILES["id_specimen"]["tmp_name"])) {
                $data['id_specimen'] = @$data["existing_specimen"];
            }
            if ($person->updatePerson($data)) {
                if (!empty($data['relative'])) {
                    $person->deleteRelatives($data['personId']);
                    foreach ($data['relative'] as $single) {
                        $single['personId'] = $data['personId'];
                        $person->addRelative($single);
                    }
                }
                if (!empty($data['employment'])) {
                    $person->deleteEmployment($data['personId']);
                    foreach ($data['employment'] as $single) {
                        $single['dateCreated'] = time();
                        $single['createdBy'] = $data['modifiedBy'];
                        $single['personId'] = $data['personId'];
                        $single['modifiedBy'] = $data['modifiedBy'];
                        $person->addPersonEmployment($single);
                    }
                }
                if (!empty($data['business'])) {
                    $person->deleteBusiness($data['personId']);
                    foreach ($data['business'] as $single) {
                        $single['dateAdded'] = time();
                        $single['addedBy'] = $data['modifiedBy'];
                        $single['personId'] = $data['personId'];
                        $person->addPersonBusiness($single);
                    }
                }
                if ($member->updateMember($data)) {
                    $output = "success";
                }
                if (!empty($_FILES["id_specimen"]["tmp_name"])) {
                    if ($_FILES['id_specimen']['error'] > 0) {
                        $output = "Error: " . $_FILES['id_specimen']['error'] . "<br />";
                    } else {
                        $allowedExts = array("gif", "jpeg", "jpg", "png", "JPG", "PNG", "GIF", "application/pdf");
                        $extension = end(explode(".", $_FILES["id_specimen"]["name"]));
                        if (($_FILES["id_specimen"]["size"] < 200000000) && in_array($extension, $allowedExts)) {
                            if ($_FILES["id_specimen"]["error"] > 0) {
                                $output = "Return Code: " . $_FILES["id_specimen"]["error"] . "<br>";
                            } else {
                                $normal = 'img/ids/' . $_FILES['id_specimen']['name'];
                                if (file_exists($normal)) {
                                    $data['id_specimen'] = $normal;
                                    $data['id'] = $data['personId'];
                                    if ($person->updateSpecimen($data)) {
                                        $output = 'success';
                                    } else {
                                        $output = "Oooooops!! there was an error! ";
                                    }
                                } else {
                                    $data['id_specimen'] = $normal;
                                    $data['id'] = $data['personId'];
                                    $images->load($_FILES['id_specimen']['tmp_name']);
                                    //$images->resize(131, 120); 
                                    $images->output($_FILES["id_specimen"]["type"]);
                                    $images->save('img/ids/' . $_FILES['id_specimen']['name']);
                                    if ($person->updateSpecimen($data)) {
                                        $output = 'success';
                                    } else {
                                        $output = "Oooooops!! there was an error! ";
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                $output = "Member details could not be updated. Please try again!";
            }
            break;
        case "subscription":
            $member = new Member();
            $subscription = new Subscription();
            $income = new Income();
            $data['date_paid'] = date("Y-m-d");
            if ($subscription->addSubscription($data)) {
                echo "success";
            }
            break;
        case "add_income":
            $income = new Income();
            if ($income->addIncome($data)) {
                echo "success";
            }
            break;
        case "shares":
            $shares = new Shares();
            $data['date_paid'] = date("Y-m-d");
            if ($shares->addShares($data)) {
                echo "success";
            }
            break;

        case "tblPersonType":
            $person_type = new PersonType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($person_type->updatePersonType($data)) {
                    $output = "success";
                } else {
                    $output = "Person type could not be updated";
                }
            } else {
                if ($person_type->addPersonType($data)) {
                    $output = "success";
                } else {
                    $output = "Person type could not be added";
                }
            }
            break;
        case "tblMaritalStatus":
            $marital_status = new MaritalStatus();
            if (isset($data['id']) && $data['id'] != "") {
                if ($marital_status->updateMaritalStatus($data)) {
                    $output = "success";
                } else {
                    $output = "Marital Status could not be updated";
                }
            } else {
                if ($marital_status->addMaritalStatus($data)) {
                    $output = "success";
                } else {
                    $output = "Marital Status could not be added";
                }
            }
            break;

        case "tblAccountType":
            $account_type = new AccountType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($account_type->updateAccountType($data)) {
                    $output = "success";
                } else {
                    $output = "Account type could not be updated";
                }
            } else {
                if ($account_type->addAccountType($data)) {
                    $output = "success";
                } else {
                    $output = "Account type could not be added";
                }
            }
            break;
        case "tblBranch":
            $branch = new Branch();
            if (isset($data['id']) && $data['id'] != "") {
                if ($branch->updateBranch($data)) {
                    $output = "success";
                } else {
                    $output = "Branch type could not be updated";
                }
            } else {
                if ($branch->addBranch($data)) {
                    $output = "success";
                } else {
                    $output = "Branch type could not be added";
                }
            }
            break;
        case "tblAccessLevel":
            $access_level = new AccessLevel();
            if ($access_level->addAccessLevel($data)) {
                $output = "success";
            } else {
                $output = "AccessLevel type could not be added";
            }
            break;
        case "tblIncomeSource":
            $income_source = new IncomeSource();
            if (isset($data['id']) && $data['id'] != "") {
                if ($income_source->updatIncomeSource($data)) {
                    $output = "success";
                } else {
                    echo "Could not update income source";
                }
            } else {
                if ($income_source->addIncomeSource($data)) {
                    $output = "success";
                } else {
                    $output = "Income source could not be added";
                }
            }
            break;
        case "tblIndividualType":
            $individual_type = new IndividualType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($individual_type->updateIndividualType($data)) {
                    $output = "success";
                } else {
                    $output = "Individual type could not be updated.";
                }
            } else {
                if ($individual_type->addIndividualType($data)) {
                    $output = "success";
                } else {
                    $output = "Individual type could not be added";
                }
            }
            break;
        case "tblLoanType":
            $loan_type = new LoanType();
            if ($loan_type->addLoanType($data)) {
                $output = "success";
            } else {
                $output = "Loan type could not be added";
            }
            break;
        case "tblPenalityCalculation":
            $penality_calculation = new PenaltyCalculationMethod();
            if ($penality_calculation->addPenaltyCalculationMethod($data)) {
                $output = "success";
            } else {
                $output = "Penality calculation could not be added";
            }
            break;
        case "tblLoanProductPenalty":
            $loan_product_penalty = new LoanProductsPenalties();
            if ($loan_product_penalty->addLoanProductPenalty($data)) {
                $output = "success";
            } else {
                $output = "Loan product penalty could not be added";
            }
            break;
        case "tblRelationshipType":
            $relation_type = new RelationshipType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($relation_type->updateRelationshipType($data)) {
                    $output = "success";
                } else {
                    $output = "Relationship type could not be updated";
                }
            } else {
                if ($relation_type->addRelationshipType($data)) {
                    $output = "success";
                } else {
                    $output = "Relationship type could not be added";
                }
            }
            break;
        case "tblRepaymentDuration":
            $repayment_duration = new LoanRepaymentDuration();
            if ($repayment_duration->addLoanRepaymentDuration($data)) {
                $output = "success";
            } else {
                $output = "Loan repayment duration could not be added";
            }
            break;
        case "tblSecurityType":
            $security_type = new SecurityType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($security_type->updateSecurityType($data)) {
                    $output = "success";
                } else {
                    $output = "Security type could not be updated";
                }
            } else {
                if ($security_type->addSecurityType($data)) {
                    $output = "success";
                } else {
                    $output = "Security type could not be added";
                }
            }
            break;
        case "tblPosition":
            $position = new Position();
            if (isset($data['id']) && $data['id'] != "") {
                if ($position->updatePosition($data)) {
                    $output = "success";
                } else {
                    $output = "Position could not be updated";
                }
            } else {
                if ($position->addPosition($data)) {
                    $output = "success";
                } else {
                    $output = "Position could not be added";
                }
            }
            break;
        case "tblIdCardType":
            $id_card_type = new IdCardType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($id_card_type->updateIdCardType($data)) {
                    $output = "success";
                } else {
                    $output = "Id Card Type could not be updated";
                }
            } else {
                if ($id_card_type->addIdCardType($data)) {
                    $output = "success";
                } else {
                    $output = "Id Card Type could not be added";
                }
            }
            break;
        case "tblLoanProductType":
            $loan_product_type = new LoanProductType();
            if (isset($data['id']) && $data['id'] != "") {
                if ($loan_product_type->updateProductType($data)) {
                    $output = "success";
                } else {
                    echo "Could not update loan product type";
                }
            } else {
                if ($loan_product_type->addLoanProductType($data)) {
                    $output = "success";
                } else {
                    $output = "Loan Product Type could not be added";
                }
            }

            break;
        case "tblAddressType":
            $address_type = new AddressType();
            if ($address_type->addIdAdressType($data)) {
                $output = "success";
            }
            break;
        case "tblExpenseType":
            $expense_types = new ExpenseTypes();
            if (isset($data['id']) && $data['id'] != "") {
                if ($expense_types->updateExpenseType($data)) {
                    $output = "success";
                } else {
                    echo "Could not update an expense type";
                }
            } else {
                if ($expense_types->addExpenseType($data)) {
                    $output = "success";
                } else {
                    echo "Could not add an expense type";
                }
            }
            break;
        case "tblAddExpense":
            $expenses = new Expenses();
            if (isset($data['id']) && $data['id'] != "") {
                if ($expenses->updateExpense($data)) {
                    $output = "updated";
                } else {
                    echo "Could not update an expense";
                }
            } else {
                if ($expenses->addExpense($data)) {
                    $output = "success";
                } else {
                    echo "Could not add an expense";
                }
            }
            break;
        case "tblLoanProduct":
            $loanProduct = new LoanProduct();
            $data['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
            unset($data['tbl']);

            $output = "false";
            if (isset($data['id']) && is_numeric($data['id'])) {//we are updating the loan product
                $product_fees = array();
                if (isset($data['existingLoanProductFees'])) {
                    $product_fees['existingLoanProductFees'] = $data['existingLoanProductFees'];
                    unset($data['existingLoanProductFees']);
                }
                if (isset($data['newLoanProductFees'])) {
                    $product_fees['newLoanProductFees'] = $data['newLoanProductFees'];
                    unset($data['newLoanProductFees']);
                }

                if ($loanProduct->updateLoanProduct($data)) {
                    //print_r($data);
                    $product_id = $data['id'];
                    unset($data['id']);
                    $output = save_loan_product_fees($product_fees, $product_id);
                }
            } else { //this is a new entry for the loan product
                $data['dateCreated'] = time();
                $data['createdBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;

                $loanProductId = $loanProduct->addLoanProduct($data);

                if ($loanProductId) {
                    //then the actual fees assigned to this product
                    $output = save_loan_product_fees($data, $loanProductId);
                }
            }
            unset($data);
            break;
        case 'tblLoanProductFee':
            $data['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
            $loanProductFeeObj = new LoanProductFee();
            if (isset($data['id']) && is_numeric($data['id'])) {
                //update the loan product entry
                $output = $loanProductFeeObj->updateLoanProductFee($data);
            } else {
                //insert new loan product fees to the loan products table
                $data['dateCreated'] = time();
                $data['createdBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
                $output = $loanProductFeeObj->addLoanProductFee($data);
            }
            break;
        case 'tblDepositProductFee':
            $data['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
            $depositProductFeeObj = new DepositProductFee();
            unset($data['tbl']);
            if(isset($data['dateApplicationMethod']) && $data['dateApplicationMethod']==""){
                unset($data['dateApplicationMethod']);
            }
            if (isset($data['id']) && is_numeric($data['id'])) {
                if($depositProductFeeObj->updateDepositProductFee($data)){
                    $output = 'success';
                }
            } else {
                //insert new deposit product fees to the deposit product fees table
                unset($data['id']);
                $data['dateCreated'] = time();
                $data['createdBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
                if($depositProductFeeObj->addDepositProductFee($data)){
                    $output = 'success';
                }
                
            }
            break;

        case "tblDepositProduct":

            $deposit_product_obj = new DepositProduct();
            $data['dateModified'] = time();
            $data['modifiedBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;
            unset($data['tbl']);

            $output = "false";
            if (isset($data['id']) && is_numeric($data['id'])) {//we are updating the deposit product
                $product_fees = array();
                if (isset($data['existingDepositProductFees'])) {
                    $product_fees['existingDepositProductFees'] = $data['existingDepositProductFees'];
                    unset($data['existingDepositProductFees']);
                }
                if (isset($data['newDepositProductFees'])) {
                    $product_fees['newDepositProductFees'] = $data['newDepositProductFees'];
                    unset($data['newDepositProductFees']);
                }

                if ($deposit_product_obj->updateDepositProduct($data)) {
                    //print_r($data);
                    $deposit_product_id = $data['id'];
                    unset($data['id']);
                    $output = save_deposit_product_fees($product_fees, $deposit_product_id);
                }
            } else { //this is a new entry for the deposit product
                $data['dateCreated'] = time();
                $data['createdBy'] = isset($_SESSION['staffId']) ? $_SESSION['staffId'] : 1;

                if (is_numeric($depositProductId = $deposit_product_ob->addDepositProduct($data))) {
                    //then the actual fees assigned to this product
                    $output = save_deposit_product_fees($data, $depositProductId);
                }
            }
            unset($data);

            break;
        default:
            echo "No data submited!";
            break;
    }
    echo $output;
}