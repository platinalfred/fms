<?php

/**
 * This class represents the db table holding the actual fees that apply to a particular deposit product
 */
$curdir = dirname(__FILE__);
require_once($curdir . '/Db.php');

class DepositProductFeen extends Db {

    protected static $table_name = "deposit_product_feen";
    protected static $table_fields = array("id", "depositProductId", "depositProductFeeId", "dateCreated", "createdBy", "modifiedBy");

    public function findById($id) {
        $result = $this->getrec(self::$table_name, "id=" . $id, "");
        return !empty($result) ? $result : false;
    }

    public function findAll() {
        $result_array = $this->getarray(self::$table_name, "", "", "");
        return !empty($result_array) ? $result_array : false;
    }

    public function findAllLPFDetails($where_clause = "") {
        $table = self::$table_name . " JOIN deposit_product_fee ON `deposit_product_feen`.`depositProductFeeId` = `deposit_product_fee`.`id`";
        $fields = "`deposit_product_feen`.`id`, `depositProductId`, `depositProductFeeId`, `amount`, `feeName`, `chargeTrigger`, `dateApplicationMethod`";
        $result_array = $this->getfarray($table, $fields, $where_clause, "", "");
        return !empty($result_array) ? $result_array : false;
    }

    public function addDepositProductFeen($data) {
        $fields = array_slice(self::$table_fields, 1);
        $result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
        return $result;
    }

    public function updateDepositProductFeen($data) {
        $fields = array_slice(self::$table_fields, 1);
        $id = $data['id'];
        unset($data['id']);
        if ($this->updateDepositProductFeen(self::$table_name, $table_fields, $this->generateAddFields($fields, $data), "id=" . $id)) {
            return true;
        }
        return false;
    }

    public function delete($id) {
        $this->delete(self::$table_name, "id=" . $id);
    }

}
