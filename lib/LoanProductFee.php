<?php

/**
 * This class represents the db table holding the fees that can be applied to a particular loan product
 * The user can apply any of these to the given loan product
 */
$curdir = dirname(__FILE__);
require_once($curdir . '/Db.php');

class LoanProductFee extends Db {

    protected static $table_name = "loan_product_fee";
    protected static $table_fields = array("loan_product_fee.id", "feeName", "feeType", "amountCalculatedAs", "requiredFee", "amount", "dateCreated", "createdBy", "modifiedBy");

    public function findById($id) {
        $result = $this->getrec(self::$table_name, "id=" . $id, "");
        return !empty($result) ? $result : false;
    }

    public function findAll() {
        $table_fields = self::$table_fields;
        array_push($table_fields, 'feeTypeName');

        $table = "`loan_product_fee` JOIN `fee_type` ON `loan_product_fee`.`feeType` = `fee_type`.`id`";
        $result_array = $this->getfarray($table, implode(",", $table_fields), "", "", "");
        //return !empty($result_array) ? $result_array : false;
        return $result_array;
    }

    public function addLoanProductFee($data) {
        $fields = array_slice(self::$table_fields, 1);
        $result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
        return $result;
    }

    public function updateLoanProductFee($data) {
        $fields = array_slice(self::$table_fields, 1);
        $id = $data['id'];
        unset($data['id']);
        if ($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=" . $id)) {
            return true;
        }
        return false;
    }

    public function deleteLoanProductFee($id) {
        $this->delete(self::$table_name, "id=" . $id);
    }

}

?>