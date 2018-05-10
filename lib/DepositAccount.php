<?php

$curdir = dirname(__FILE__);
require_once($curdir . '/Db.php');

class DepositAccount extends Db {

    protected static $table_name = "deposit_account";
    protected static $table_fields = array("id", "depositProductId", "recomDepositAmount", "maxWithdrawalAmount", "interestRate", "openingBalance", "termLength", "dateCreated", "createdBy", "dateModified", "modifiedBy");

    public function findById($id) {
        $result = $this->getrec(self::$table_name, "id=" . $id, "", "");
        return !empty($result) ? $result : false;
    }

    public function findAllDetailsById($id) {
        $fields = array("`deposit_account`.`id`", "`productName`", "`deposit_account`.`recomDepositAmount`", "`deposit_account`.`maxWithdrawalAmount`", "`interestRate`", "`deposit_account`.`openingBalance`", "`termLength`", "`deposit_account`.`dateCreated`", "`deposit_account`.`createdBy`");

        $table = self::$table_name . " JOIN `deposit_product` ON `deposit_account`.`depositProductId` = `deposit_product`.`id`";

        $result = $this->getfrec($table, implode(",", $fields), "`deposit_account`.`id`=" . $id, "", "");
        return $result;
    }

    public function findAll() {
        $result_array = $this->getarray(self::$table_name, "", "", "");
        return !empty($result_array) ? $result_array : false;
    }

    public function getSumOfFields($where1 = "1 ", $depositAccountIds = false) {
        $fields = array("COALESCE(SUM(`openingBalance`),0) `openingBalances`");
        $where = $where1;
        $in_part_string = "";
        if ($depositAccountIds) {
            if (is_array($depositAccountIds)) {
                foreach ($depositAccountIds as $depositAccountId) {
                    $in_part_string .= $depositAccountId['depositAccountId'] . ",";
                }
                $where .= " AND `id` IN (" . substr($in_part_string, 0, -1) . ")";
            }
        }
        $result_array = $this->getfrec(self::$table_name, implode(",", $fields), $where, "", "");
        return $result_array['openingBalances'];
    }

    public function findRecentDeposits($start_date, $end_date, $limit) {

        $where = "";


        $member_sql = "(SELECT `members`.`id` `clientId`, depositAccountId, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, 1 `clientType` FROM `member_deposit_account` JOIN (SELECT `member`.`id`, `firstname`, `lastname`, `othername` FROM `member` JOIN `person` ON `member`.`personId`=`person`.`id`)`members` ON `memberId` = `members`.`id`)";
        $saccogroup_sql = "(SELECT `saccogroup`.`id` `clientId`, `depositAccountId`, `groupName` `clientNames`, 2 as `clientType` FROM `group_deposit_account` JOIN `saccogroup` ON `saccoGroupId` = `saccogroup`.`id`)";

        $member_group_union_sql = $member_sql . " UNION " . $saccogroup_sql . " ORDER BY `clientNames`";

        $deposits_sql = "SELECT `depositAccountId`, COALESCE(SUM(amount),0) `sumDeposited` FROM `deposit_account_transaction` WHERE `transactionType` = 1  GROUP BY `depositAccountId`";
        $withdraws_sql = "SELECT `depositAccountId`, COALESCE(SUM(amount),0) `sumWithdrawn` FROM `deposit_account_transaction` WHERE `transactionType` = 2   GROUP BY `depositAccountId`";

        $table = "`deposit_account` JOIN ($member_group_union_sql) `clients` ON `clients`.`depositAccountId` = `deposit_account`.`id` JOIN `deposit_product` ON `deposit_account`.`depositProductId` = `deposit_product`.`id` LEFT JOIN ($deposits_sql) `deposits` ON `deposit_account`.`id` = `deposits`.`depositAccountId` LEFT JOIN ($withdraws_sql) `withdraws` ON `deposit_account`.`id` = `withdraws`.`depositAccountId` ";

        $columns = array("`deposit_account`.`id`", "`clientNames`", "`clientType`", "`clientId`", "`productName`", "`deposit_account`.`openingBalance`", "`deposit_account`.`recomDepositAmount`", "COALESCE(`sumWithdrawn`, 0) sumWithdrawn", "COALESCE(`sumDeposited`, 0) sumDeposited", "`deposit_account`.`dateCreated`");
        //echo $table." - ".implode(",",$columns)."".$where;
        $results = $this->getfarray($table, implode(",", $columns), $where, "", $limit);
        return !empty($results) ? $results : false;
    }

    public function findSpecifics($fields, $where = "") { //pick out data for specific fields
        $in_part_string = "";
        $where_clause = "";
        if (is_array($where)) {
            foreach ($where as $depositAccount) {
                $in_part_string .= $depositAccount['depositAccountId'] . ",";
            }
            $where_clause .= " AND `id` IN (" . substr($in_part_string, 0, -1) . ")";
        }
        $result_array = $this->getfrec(self::$table_name, $fields, $where_clause, "", "");
        return !empty($result_array) ? $result_array : false;
    }

    public function getTransactionHistory($accountId = false) {
        $where = "";
        if (!$accountId) {
            $where = "`depositAccountId` = " . $accountId;
        }
        $result_array = $this->getfrec(self::$table_name, $where, "", "");
        return !empty($result_array) ? $result_array : false;
    }

    public function addDepositAccount($data) {
        $fields = array_slice(self::$table_fields, 1);
        $result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
        return $result;
    }

    public function updateDepositAccount($data) {

        $fields = array_slice(self::$table_fields, 1);
        $id = $data['id'];
        unset($data['id']);
        if ($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=" . $id)) {
            return true;
        }
        return false;
    }

    public function deleteDepositAccount($id) {
        $this->delete(self::$table_name, "id=" . $id);
    }

}