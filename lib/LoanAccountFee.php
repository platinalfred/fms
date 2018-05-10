<?php

$curdir = dirname(__FILE__);
require_once($curdir . '/Db.php');

class LoanAccountFee extends Db {

    protected static $table_name = "loan_account_fee";
    protected static $table_fields = array("id", "loanAccountId", "loanProductFeenId", "feeAmount", "dateCreated", "createdBy", "dateModified", "modifiedBy");

    public function findById($id) {
        $result = $this->getrec(self::$table_name, "id=" . $id, "");
        return !empty($result) ? $result : false;
    }

    public function findAll() {
        $result_array = $this->getarray(self::$table_name, "", "", "");
        return !empty($result_array) ? $result_array : false;
    }

    public function findAllDetailsByLoanAccountId($loanAccountId) {
        $table_product_fees = "(SELECT `loan_product_feen`.`id`, `feeName`, `loanProductId`, `amountCalculatedAs`, `requiredFee`, `amount` FROM `loan_product_feen` JOIN `loan_product_fee` ON `loan_product_feen`.`loanProductFeeId` = `loan_product_fee`.`id`) `productFees`";

        $fields = "`loanProductId`,`loanProductFeenId` `id`, `feeName`, `amount`, `amountCalculatedAs`, `requiredFee`";
        $table = self::$table_name . " JOIN " . $table_product_fees . " ON " . self::$table_name . ".`loanProductFeenId`=`productFees`.`id`";
        $result_array = $this->getfarray($table, $fields, "`loanAccountId`=" . $loanAccountId, "", "");

        $actual_sql = "SELECT `loanProductId`,`loanProductFeenId` `id`, `amount`, `amountCalculatedAs`, `requiredFee` FROM `loan_account_fee` JOIN (SELECT `loan_product_feen`.`id`, `feeName`, `loanProductId`, `amountCalculatedAs`, `requiredFee`, `amount` FROM `loan_product_feen` JOIN `loan_product_fee` ON `loan_product_feen`.`loanProductFeeId` = `loan_product_fee`.`id`) `productFees` ON `loan_account_fee`.`loanProductFeenId`=`productFees`.`id` WHERE `loanAccountId`=1";
        return !empty($result_array) ? $result_array : false;
    }

    public function getSum($where1 = "1 ", $loanAccountIds = false) {
        $where = $where1;
        $in_part_string = "";
        if ($loanAccountIds) {
            foreach ($loanAccountIds as $loanAccountId) {
                $in_part_string .= $loanAccountId['loanAccountId'] . ",";
            }
            $where .= " AND `loanAccountId` IN (" . substr($in_part_string, 0, -1) . ")";
        }
        $field = "COALESCE(SUM(`feeAmount`),0) `feeSum`";
        $result = $this->getfrec(self::$table_name, $field, $where, "", "");
        return !empty($result) ? $result['feeSum'] : 0;
    }

    public function addLoanAccountFee($data) {
        $fields = array_slice(self::$table_fields, 1);
        $result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
        return $result;
    }

    public function updateLoanAccountFee($data) {
        $fields = array_slice(self::$table_fields, 1);
        $id = $data['id'];
        unset($data['id']);
        if ($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=" . $id)) {
            return true;
        }
        return false;
    }

    public function deleteLoanAccountFee($loanAccountId) {
        $this->del(self::$table_name, "loanAccountId=" . $loanAccountId);
    }

}
