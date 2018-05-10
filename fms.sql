-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2018 at 12:19 PM
-- Server version: 5.7.9
-- PHP Version: 5.6.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fms`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `exceeded_days`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `exceeded_days` (IN `loans_id` INT, IN `loan_date` DATE, IN `cur_date` DATE, IN `exp_payback` DECIMAL(12,2), IN `loan_duration` INT, IN `loan_age` INT, OUT `no_days` INT)  READS SQL DATA
    COMMENT 'Retrieve the number of days defaulted on a loan in a month'
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE paidAmount DECIMAL(12,2);
DECLARE cur2 CURSOR FOR SELECT SUM(`amount`)amount_paid FROM `loan_repayment` `lp` WHERE (`lp`.`loan_id` = loans_id AND COALESCE((SELECT SUM(`amount`) FROM `loan_repayment` WHERE  `loan_id`=1 AND `transaction_date`<=cur_date),0) < ((exp_payback/loan_duration)*loan_age) OR `loan_id` NOT IN (SELECT `loan_id` FROM `loan_repayment` WHERE  `transaction_date`<=cur_date));

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
OPEN cur2;
  read_loop: LOOP
    FETCH cur2 INTO paidAmount;
    IF done THEN
    	IF paidAmount IS NULL THEN
			SET no_days = DATEDIFF(cur_date, DATE_ADD(loan_date, INTERVAL  loan_age+1 MONTH));
			ELSE
			SET no_days = 0;
            END IF;
        LEAVE read_loop;
    END IF;
    END LOOP;
   CLOSE cur2;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `GetDueDate`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetDueDate` (`disbursementDate` DATETIME, `installments` TINYINT, `time_unit` TINYINT, `repaymentFreq` TINYINT(1), `start_date` DATETIME, `end_date` DATETIME) RETURNS DATE NO SQL
BEGIN
	DECLARE installs INT DEFAULT 0;
    DECLARE tempDate, dueDate DATE;
	WHILE (installs <= installments) DO
		SET installs = installs+1;
		
		CASE time_unit
		WHEN 1 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq DAY);
		WHEN 2 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq WEEK);
		WHEN 3 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq MONTH);
		END CASE;
		IF (tempDate BETWEEN start_date AND end_date) THEN
			SET dueDate = tempDate;
			RETURN dueDate;
		END IF;
	END WHILE;
	
	RETURN dueDate;
END$$

DROP FUNCTION IF EXISTS `getPeriodAspect`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getPeriodAspect` (`period` TINYINT(1)) RETURNS SMALLINT(5) UNSIGNED NO SQL
BEGIN
	DECLARE periodAspect SMALLINT(3);
	CASE period
			WHEN 1 THEN SET periodAspect=365;
			WHEN 2 THEN SET periodAspect = 54;
			WHEN 3 THEN SET periodAspect = 12;
            ELSE SET periodAspect = 12;
	END CASE;
   RETURN periodAspect;
END$$

DROP FUNCTION IF EXISTS `ImmediateDueDate`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ImmediateDueDate` (`disbursementDate` DATETIME, `installments` TINYINT(2), `time_unit` TINYINT(1), `repaymentFreq` TINYINT(1), `end_date` DATETIME) RETURNS DATE NO SQL
BEGIN
	DECLARE installs INT DEFAULT 0;
    DECLARE tempDate, dueDate DATE;
	WHILE (installs <= installments) DO
		SET installs = installs+1;
		
		CASE time_unit
		WHEN 1 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq DAY);
		WHEN 2 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq WEEK);
		WHEN 3 THEN SET tempDate = DATE_ADD(disbursementDate, INTERVAL installs*repaymentFreq MONTH);
		END CASE;
		IF (tempDate < end_date) THEN
			SET dueDate = tempDate;
		END IF;
	END WHILE;
	
	RETURN dueDate;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accesslevel`
--

DROP TABLE IF EXISTS `accesslevel`;
CREATE TABLE IF NOT EXISTS `accesslevel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(156) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accesslevel`
--

INSERT INTO `accesslevel` (`id`, `name`, `description`) VALUES
(1, 'Administrator', 'Over all user of the system'),
(2, 'Loan Officers', 'General operating Staff'),
(3, 'Branch Managers', 'Manager of the organisation'),
(4, 'Branch Credit Committee', 'Executive commite member'),
(5, 'Management Credit Committee\r\n', NULL),
(6, 'Executive board committe', NULL),
(7, 'Accountant', 'Accountant to handle all finances');

-- --------------------------------------------------------

--
-- Table structure for table `address_type`
--

DROP TABLE IF EXISTS `address_type`;
CREATE TABLE IF NOT EXISTS `address_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address_type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
CREATE TABLE IF NOT EXISTS `branch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_number` varchar(45) NOT NULL,
  `branch_name` varchar(150) NOT NULL,
  `physical_address` text NOT NULL,
  `office_phone` varchar(45) DEFAULT NULL,
  `postal_address` varchar(156) DEFAULT NULL,
  `email_address` varchar(156) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `branch_number`, `branch_name`, `physical_address`, `office_phone`, `postal_address`, `email_address`) VALUES
(6, '', 'Muganzirwaza', 'Kampala', '(073) 000-0000', 'kampala', 'info@buladde.or.ug');

-- --------------------------------------------------------

--
-- Table structure for table `counties`
--

DROP TABLE IF EXISTS `counties`;
CREATE TABLE IF NOT EXISTS `counties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `district_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `counties`
--

INSERT INTO `counties` (`id`, `name`, `district_id`) VALUES
(1, 'Kawempe', 1),
(2, 'Kampala Central', 1);

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `name`) VALUES
(1, 'Uganda'),
(2, 'Kenya');

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account`
--

DROP TABLE IF EXISTS `deposit_account`;
CREATE TABLE IF NOT EXISTS `deposit_account` (
  `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `depositProductId` int(11) NOT NULL COMMENT 'Reference to the deposit product',
  `recomDepositAmount` decimal(15,2) NOT NULL,
  `maxWithdrawalAmount` decimal(15,2) NOT NULL,
  `interestRate` decimal(4,2) DEFAULT NULL,
  `openingBalance` decimal(15,2) NOT NULL,
  `termLength` tinyint(4) DEFAULT NULL COMMENT 'Period of time before which withdraws can''t be made',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkDepositProductId` (`depositProductId`),
  KEY `dateModified` (`dateModified`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `dateCreated` (`dateCreated`),
  KEY `account_no` (`account_no`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deposit_account`
--

INSERT INTO `deposit_account` (`id`, `account_no`, `depositProductId`, `recomDepositAmount`, `maxWithdrawalAmount`, `interestRate`, `openingBalance`, `termLength`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(00000000001, '', 1, '10000.00', '500000.00', '0.00', '500000.00', 1, 1499160187, 0, 1499160187, 2),
(00000000002, '', 4, '10000.00', '500000.00', '0.00', '400000.00', 12, 1499160651, 0, 1499160651, 2),
(00000000003, '', 1, '10000.00', '500000.00', '0.00', '10000.00', 30, 1505929674, 7, 1505929674, 7),
(00000000004, '', 6, '45000.00', '30000.00', '0.00', '34000.00', 5, 1506156639, 1, 1506156639, 1),
(00000000005, '', 5, '10000.00', '500000.00', '0.00', '10000.00', 4, 1509610441, 1, 1509610441, 1),
(00000000006, '', 1, '10000.00', '500000.00', '0.00', '54000.00', 3, 1509612234, 1, 1509612234, 1),
(00000000007, '', 1, '10000.00', '500000.00', '0.00', '34000.00', 3, 1509612363, 1, 1509612363, 1),
(00000000008, '', 1, '10000.00', '500000.00', '0.00', '34000.00', 4, 1509612657, 1, 1509612657, 1),
(00000000009, '', 1, '10000.00', '500000.00', '0.00', '50000.00', 4, 1509612920, 1, 1509612920, 1),
(00000000010, '', 5, '10000.00', '500000.00', '0.00', '10000.00', 0, 1511245818, 1, 1511245818, 1);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account_fee`
--

DROP TABLE IF EXISTS `deposit_account_fee`;
CREATE TABLE IF NOT EXISTS `deposit_account_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `depositProductFeeId` int(11) DEFAULT NULL,
  `depositAccountId` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Creation timestamp',
  `createdBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1 COMMENT='Fees that have been applied to the deposit account';

--
-- Dumping data for table `deposit_account_fee`
--

INSERT INTO `deposit_account_fee` (`id`, `depositProductFeeId`, `depositAccountId`, `amount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 1, '1000.00', 1499160187, 2, 1499160187, 2),
(2, 0, 0, '1000.00', 1499160651, 2, 1499160651, 2),
(3, 0, 0, '1000.00', 1505929674, 7, 1505929674, 7),
(4, 0, 0, '1000.00', 1506156639, 1, 1506156639, 1),
(5, 0, 0, '800.00', 1506156639, 1, 1506156639, 1),
(6, 0, 0, '1000.00', 1509610441, 1, 1509610441, 1),
(7, 0, 0, '800.00', 1509610441, 1, 1509610441, 1),
(8, 0, 0, '1000.00', 1509612234, 1, 1509612234, 1),
(9, 0, 0, '800.00', 1509612234, 1, 1509612234, 1),
(10, 0, 7, '1000.00', 1509612363, 1, 1509612363, 1),
(11, 0, 7, '800.00', 1509612363, 1, 1509612363, 1),
(12, 2, 8, '1000.00', 1509612657, 1, 1509612657, 1),
(13, 3, 8, '800.00', 1509612657, 1, 1509612657, 1),
(14, 2, 9, '1000.00', 1509612920, 1, 1509612920, 1),
(15, 3, 9, '800.00', 1509612920, 1, 1509612920, 1),
(16, 2, 10, '1000.00', 1511245818, 1, 1511245818, 1),
(17, 3, 10, '800.00', 1511245818, 1, 1511245818, 1);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account_transaction`
--

DROP TABLE IF EXISTS `deposit_account_transaction`;
CREATE TABLE IF NOT EXISTS `deposit_account_transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `depositAccountId` int(11) NOT NULL,
  `amount` decimal(19,2) NOT NULL,
  `comment` text NOT NULL,
  `transactionType` tinyint(1) NOT NULL,
  `transactedBy` int(11) NOT NULL COMMENT 'Officer inserting this record',
  `dateCreated` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `person_id` (`depositAccountId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deposit_account_transaction`
--

INSERT INTO `deposit_account_transaction` (`id`, `depositAccountId`, `amount`, `comment`, `transactionType`, `transactedBy`, `dateCreated`, `dateModified`, `modifiedBy`) VALUES
(1, 2, '70000.00', 'Well received', 1, 2, 1499160742, '0000-00-00 00:00:00', 2),
(2, 1, '670000.00', '', 1, 1, 1499625806, '0000-00-00 00:00:00', 1),
(3, 1, '70000.00', 'returning', 2, 1, 1499625873, '0000-00-00 00:00:00', 1),
(4, 1, '40000.00', 'Deposited by Andrew Olokojo', 1, 1, 1499626389, '0000-00-00 00:00:00', 1),
(5, 1, '450000.00', 'Received by the accountant as is', 1, 1, 1499626536, '0000-00-00 00:00:00', 1),
(6, 3, '1000000.00', 'Deposited By Alfred', 1, 7, 1505983559, '2017-09-21 08:45:59', 7),
(7, 3, '200000.00', 'By Alfred platin ', 2, 7, 1505983593, '2017-09-21 08:46:33', 7),
(8, 3, '20000.00', 'By Alfred platin ', 1, 7, 1505983623, '2017-09-21 08:47:03', 7),
(9, 3, '120000.00', 'By Alfred platin ', 2, 7, 1505983648, '2017-09-21 08:47:28', 7);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product`
--

DROP TABLE IF EXISTS `deposit_product`;
CREATE TABLE IF NOT EXISTS `deposit_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(150) NOT NULL,
  `description` text NOT NULL COMMENT 'Description of product',
  `productType` tinyint(2) NOT NULL,
  `availableTo` tinyint(1) NOT NULL COMMENT '1-Individuals, 2-Groups, 3-Both',
  `recommededDepositAmount` decimal(15,2) DEFAULT NULL,
  `maxWithdrawalAmount` decimal(15,2) DEFAULT NULL,
  `interestPaid` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Whether interest should be paid into the account',
  `defaultInterestRate` decimal(4,2) DEFAULT NULL,
  `minInterestRate` decimal(4,2) DEFAULT NULL,
  `maxInterestRate` decimal(4,2) DEFAULT NULL,
  `perNoOfDays` int(11) DEFAULT NULL COMMENT 'Number of days after which interest is paid',
  `accountBalForCalcInterest` int(11) DEFAULT NULL,
  `whenInterestIsPaid` tinyint(1) DEFAULT NULL,
  `daysInYear` tinyint(1) DEFAULT NULL,
  `applyWHTonInterest` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Whether to apply WHT on interest paid out',
  `defaultOpeningBal` decimal(15,2) DEFAULT NULL,
  `minOpeningBal` decimal(15,2) DEFAULT NULL,
  `maxOpeningBal` decimal(15,2) DEFAULT NULL,
  `defaultTermLength` tinyint(4) DEFAULT NULL COMMENT 'period of time before which a withdraw can be made',
  `minTermLength` tinyint(4) DEFAULT NULL COMMENT 'minimum period of time before which a withdraw can be made',
  `maxTermLength` tinyint(4) DEFAULT NULL COMMENT 'maximum period of time before which a withdraw can be made',
  `termTimeUnit` tinyint(1) DEFAULT NULL COMMENT '1-Days, 2-Weeks, 3-Months',
  `allowArbitraryFees` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Whether arbitraryFees allowed or not',
  `dateCreated` int(11) NOT NULL COMMENT 'Creation timestamp',
  `createdBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL COMMENT 'modification timestamp',
  `modifiedBy` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `fkCreatedBy` (`createdBy`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COMMENT='Deposit Products Table';

--
-- Dumping data for table `deposit_product`
--

INSERT INTO `deposit_product` (`id`, `productName`, `description`, `productType`, `availableTo`, `recommededDepositAmount`, `maxWithdrawalAmount`, `interestPaid`, `defaultInterestRate`, `minInterestRate`, `maxInterestRate`, `perNoOfDays`, `accountBalForCalcInterest`, `whenInterestIsPaid`, `daysInYear`, `applyWHTonInterest`, `defaultOpeningBal`, `minOpeningBal`, `maxOpeningBal`, `defaultTermLength`, `minTermLength`, `maxTermLength`, `termTimeUnit`, `allowArbitraryFees`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Keba account', ' Keba Savings club', 1, 1, '10000.00', '500000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '10000.00', '5000.00', '0.00', 1, 1, 30, 1, 0, 1498485472, 1, 1498485472, '0000-00-00 00:00:00'),
(4, 'Group Plus', ' Group Savings ', 1, 1, '10000.00', '500000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '10000.00', '5000.00', '0.00', 12, 12, 12, 3, 0, 1498486182, 1, 1498486182, '0000-00-00 00:00:00'),
(5, 'Individual Savings Account', 'individual', 1, 1, '10000.00', '500000.00', 0, '1.00', '1.00', '1.00', 30, 1, 1, 2, 0, '10000.00', '10000.00', '10000.00', 12, 1, 12, 3, 0, 1498486623, 1, 1498486623, '0000-00-00 00:00:00'),
(6, 'Group Deposit Accounts', 'Deposit accounts available to group members', 1, 2, '45000.00', '30000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '20000.00', '20000.00', '100000.00', 6, 4, 10, 1, 0, 1506156510, 1, 1506156510, '2017-09-23 08:49:32');

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product_fee`
--

DROP TABLE IF EXISTS `deposit_product_fee`;
CREATE TABLE IF NOT EXISTS `deposit_product_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feeName` varchar(150) NOT NULL,
  `depositProductID` int(11) NOT NULL COMMENT 'ID of the deposit product',
  `amount` decimal(12,2) NOT NULL,
  `chargeTrigger` tinyint(2) NOT NULL,
  `dateApplicationMethod` tinyint(1) DEFAULT NULL COMMENT '1-Manual, 2-Monthly',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `fkDateModified` (`dateModified`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `fkDateCreated` (`dateCreated`),
  KEY `fkDepositProductId` (`depositProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a deposit product';

--
-- Dumping data for table `deposit_product_fee`
--

INSERT INTO `deposit_product_fee` (`id`, `feeName`, `depositProductID`, `amount`, `chargeTrigger`, `dateApplicationMethod`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(2, 'Account Maintenance', 2, '1000.00', 2, 1, 1498485490, 1, '0000-00-00 00:00:00', 1),
(3, 'Monthly ledger fees', 6, '800.00', 2, 2, 1506156510, 1, '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product_type`
--

DROP TABLE IF EXISTS `deposit_product_type`;
CREATE TABLE IF NOT EXISTS `deposit_product_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeName` varchar(50) NOT NULL COMMENT 'Name of the product type',
  `description` varchar(250) NOT NULL COMMENT 'Description of product',
  `dateCreated` int(11) NOT NULL COMMENT 'Record insertion timestamp',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record modification timestamp',
  `createdBy` int(11) NOT NULL COMMENT 'staff that inserted record',
  `modifiedBy` int(11) NOT NULL COMMENT 'User modifying entry',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deposit_product_type`
--

INSERT INTO `deposit_product_type` (`id`, `typeName`, `description`, `dateCreated`, `dateModified`, `createdBy`, `modifiedBy`) VALUES
(1, 'Regular Savings', 'A basic savings account where a client may perform regular deposit and withdrawals and accrue interest over time', 280092020, '0000-00-00 00:00:00', 1, 1),
(2, 'Fixed Deposit ', 'clients make deposits to open the account and can only withdraw the money after an established period of time. The account can''t be closed or withdrawn before the end of that period.', 280092020, '0000-00-00 00:00:00', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

DROP TABLE IF EXISTS `districts`;
CREATE TABLE IF NOT EXISTS `districts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `country_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`id`, `name`, `country_id`) VALUES
(1, 'Kampala', 1),
(2, 'Masaka', 1);

-- --------------------------------------------------------

--
-- Table structure for table `expense`
--

DROP TABLE IF EXISTS `expense`;
CREATE TABLE IF NOT EXISTS `expense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expenseName` text NOT NULL,
  `staff` int(11) NOT NULL,
  `expenseType` tinyint(4) NOT NULL,
  `amountUsed` decimal(15,2) NOT NULL,
  `amountDescription` text NOT NULL,
  `createdBy` int(11) NOT NULL COMMENT 'ID of staff who added the record',
  `expenseDate` int(11) NOT NULL COMMENT 'Timestamp for when this record was added',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp for when this record was added',
  `modifiedBy` int(11) NOT NULL COMMENT 'Staff who modified the record',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `expense_type` (`expenseType`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `expense`
--

INSERT INTO `expense` (`id`, `expenseName`, `staff`, `expenseType`, `amountUsed`, `amountDescription`, `createdBy`, `expenseDate`, `dateModified`, `modifiedBy`, `active`) VALUES
(1, 'Air time', 1, 1, '100000.00', 'Money used to buy airtime to call due clients', 1, 1498658846, '2017-08-11 10:50:01', 1, 1),
(2, '2 Rims of paper', 2, 2, '36000.00', 'Rims for use at office muganzirwaza', 1, 1502445425, '2017-08-11 10:43:03', 1, 1),
(3, 'Office Cleaning', 0, 4, '5000.00', 'Weekly office cleaning expense', 1, 1502448355, '2017-08-11 10:50:20', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `expensetypes`
--

DROP TABLE IF EXISTS `expensetypes`;
CREATE TABLE IF NOT EXISTS `expensetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `expensetypes`
--

INSERT INTO `expensetypes` (`id`, `name`, `description`) VALUES
(1, 'Air Time', 'Air Time1'),
(2, 'Stationary', 'stationary expenses like papers, Pens '),
(3, 'Transport Expenses', 'Transport expenses'),
(4, 'Office Cleaning ', 'cleaning services');

-- --------------------------------------------------------

--
-- Table structure for table `fee_type`
--

DROP TABLE IF EXISTS `fee_type`;
CREATE TABLE IF NOT EXISTS `fee_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `feeTypeName` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Type of the fee to be charged';

--
-- Dumping data for table `fee_type`
--

INSERT INTO `fee_type` (`id`, `description`, `feeTypeName`) VALUES
(1, 'A short term fee', 'Fixed term fee'),
(2, 'A long term fee', 'Long term fee');

-- --------------------------------------------------------

--
-- Table structure for table `gender`
--

DROP TABLE IF EXISTS `gender`;
CREATE TABLE IF NOT EXISTS `gender` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gender`
--

INSERT INTO `gender` (`id`, `name`, `description`) VALUES
(1, 'Male', NULL),
(2, 'Female', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `group_deposit_account`
--

DROP TABLE IF EXISTS `group_deposit_account`;
CREATE TABLE IF NOT EXISTS `group_deposit_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saccoGroupId` int(11) NOT NULL,
  `depositAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateModified` (`dateModified`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `dateCreated` (`dateCreated`),
  KEY `fkDepositAccountId` (`depositAccountId`),
  KEY `fkSaccoGroupId` (`saccoGroupId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Holds a reference to the accounts owned by a sacco group';

--
-- Dumping data for table `group_deposit_account`
--

INSERT INTO `group_deposit_account` (`id`, `saccoGroupId`, `depositAccountId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 0, 4, 1506156639, 1, '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `group_loan_account`
--

DROP TABLE IF EXISTS `group_loan_account`;
CREATE TABLE IF NOT EXISTS `group_loan_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saccoGroupId` int(11) NOT NULL COMMENT 'Refence key to the saccoGroup',
  `loanProductId` int(11) DEFAULT NULL COMMENT 'Reference key to the loan account',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkGroupId` (`saccoGroupId`),
  KEY `fkLoanId` (`loanProductId`),
  KEY `dateCreated` (`dateCreated`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `dateModified` (`dateModified`),
  KEY `fkModifiedBy` (`modifiedBy`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_loan_account`
--

INSERT INTO `group_loan_account` (`id`, `saccoGroupId`, `loanProductId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, NULL, 1502259241, 1, '2017-08-09 06:14:01', 1),
(2, 1, 4, 1508749405, 1, '2017-10-23 09:03:25', 1),
(3, 1, 4, 1508749471, 1, '2017-10-23 09:04:31', 1),
(4, 1, 4, 1508750671, 1, '2017-10-23 09:24:31', 1),
(5, 1, 4, 1508750741, 1, '2017-10-23 09:25:42', 1),
(6, 1, 4, 1508750784, 1, '2017-10-23 09:26:24', 1);

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

DROP TABLE IF EXISTS `group_members`;
CREATE TABLE IF NOT EXISTS `group_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkMemberId` (`memberId`),
  KEY `fkGroupId` (`groupId`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `fkCreatedBy` (`createdBy`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_members`
--

INSERT INTO `group_members` (`id`, `memberId`, `groupId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 6, 1, 1498490848, 1, '2017-06-26 15:29:57', 1),
(2, 7, 1, 1498490848, 1, '2017-06-26 15:29:57', 1),
(3, 8, 1, 1498490848, 1, '2017-06-26 15:29:57', 1),
(4, 9, 1, 1498490848, 1, '2017-06-26 15:29:57', 1),
(5, 10, 2, 1498491029, 1, '2017-06-26 15:31:36', 1),
(6, 11, 2, 1498491029, 1, '2017-06-26 15:31:37', 1),
(7, 12, 2, 1498491029, 1, '2017-06-26 15:31:37', 1),
(8, 13, 2, 1498491029, 1, '2017-06-26 15:31:37', 1);

-- --------------------------------------------------------

--
-- Table structure for table `guarantor`
--

DROP TABLE IF EXISTS `guarantor`;
CREATE TABLE IF NOT EXISTS `guarantor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberId` int(11) NOT NULL COMMENT 'Fk reference to member Id',
  `loanAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `guarantor`
--

INSERT INTO `guarantor` (`id`, `memberId`, `loanAccountId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 6, 2, 1499666238, 1, '0000-00-00 00:00:00', 1),
(2, 3, 2, 1499666238, 1, '0000-00-00 00:00:00', 1),
(3, 6, 3, 1499666781, 1, '2017-07-10 06:06:21', 1),
(4, 3, 3, 1499666781, 1, '2017-07-10 06:06:21', 1),
(5, 6, 4, 1499666994, 1, '2017-07-10 06:09:54', 1),
(6, 3, 4, 1499666994, 1, '2017-07-10 06:09:54', 1),
(7, 6, 5, 1499667059, 1, '2017-07-10 06:10:59', 1),
(8, 3, 5, 1499667059, 1, '2017-07-10 06:10:59', 1);

-- --------------------------------------------------------

--
-- Table structure for table `id_card_types`
--

DROP TABLE IF EXISTS `id_card_types`;
CREATE TABLE IF NOT EXISTS `id_card_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_type` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `id_card_types`
--

INSERT INTO `id_card_types` (`id`, `id_type`, `description`) VALUES
(1, 'National Id', 'National identification Number'),
(3, 'Passport', 'Passport of the country one was bone'),
(4, 'Driving Permit', 'Valid Driving Permit'),
(5, 'L.C Card', 'Local Council Card or Letter');

-- --------------------------------------------------------

--
-- Table structure for table `income`
--

DROP TABLE IF EXISTS `income`;
CREATE TABLE IF NOT EXISTS `income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `incomeSource` int(11) NOT NULL COMMENT 'ID for the income type',
  `amount` decimal(15,2) NOT NULL,
  `dateAdded` int(11) NOT NULL COMMENT 'Timestamp for when record was captured',
  `addedBy` int(11) NOT NULL COMMENT 'ID of the staff who added the income',
  `description` text NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp for when this record was modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'ID of staff who modified the record',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `income_sources`
--

DROP TABLE IF EXISTS `income_sources`;
CREATE TABLE IF NOT EXISTS `income_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `income_sources`
--

INSERT INTO `income_sources` (`id`, `name`, `description`) VALUES
(1, 'Kingdom Donation', 'kingdom Donations'),
(2, 'Government Grant', 'government grants');

-- --------------------------------------------------------

--
-- Table structure for table `individual_type`
--

DROP TABLE IF EXISTS `individual_type`;
CREATE TABLE IF NOT EXISTS `individual_type` (
  `1` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`1`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `individual_type`
--

INSERT INTO `individual_type` (`1`, `name`, `description`) VALUES
(1, 'Member Only', 'Will only be a member without shares'),
(2, 'Member and Share Holder', 'Member and Has Shares');

-- --------------------------------------------------------

--
-- Table structure for table `loan_account`
--

DROP TABLE IF EXISTS `loan_account`;
CREATE TABLE IF NOT EXISTS `loan_account` (
  `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `loanNo` varchar(45) DEFAULT NULL,
  `branch_id` int(11) NOT NULL COMMENT 'Branch id the loan was taken out from',
  `memberId` int(11) NOT NULL COMMENT 'Id of member applying for this loan',
  `groupLoanAccountId` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Partial_Application, 2-Pending Approval, 3-Approved, 4-Active, 5-Active in areas 11- closed/rejected, 12-closed/withdrawn, 13-closed/paid off , 14- closed/resheduled, 15-closed/written off, 16-closed/refinanced',
  `loanProductId` int(11) NOT NULL COMMENT 'Reference to the loan product',
  `requestedAmount` decimal(15,2) NOT NULL COMMENT 'Amount applied for',
  `applicationDate` int(11) NOT NULL COMMENT 'Date loan was applied for',
  `disbursedAmount` decimal(15,2) DEFAULT NULL COMMENT 'Amount disbursed to client',
  `disbursementDate` int(11) DEFAULT NULL COMMENT 'Date loan was disbursed',
  `disbursementNotes` text,
  `interestRate` decimal(5,2) NOT NULL,
  `offSetPeriod` tinyint(4) NOT NULL COMMENT 'Time unit to offset the loan',
  `gracePeriod` tinyint(4) NOT NULL,
  `repaymentsFrequency` tinyint(2) NOT NULL,
  `repaymentsMadeEvery` tinyint(4) NOT NULL COMMENT '1 - Day, 2-Week, 3 - Month',
  `installments` tinyint(4) NOT NULL COMMENT 'Number of repayment installments',
  `penaltyCalculationMethodId` tinyint(2) DEFAULT NULL,
  `penaltyTolerancePeriod` tinyint(4) DEFAULT NULL,
  `penaltyRateChargedPer` tinyint(1) DEFAULT NULL,
  `penaltyRate` decimal(4,2) DEFAULT NULL,
  `linkToDepositAccount` tinyint(1) NOT NULL COMMENT 'Link to deposit Account for repayments',
  `comments` text,
  `amountApproved` decimal(15,2) DEFAULT NULL COMMENT 'Amount Approved',
  `approvalDate` int(11) DEFAULT NULL COMMENT 'Date and time of loan application approval',
  `approvedBy` int(11) DEFAULT NULL COMMENT 'Loans officer who approved the loan',
  `approvalNotes` text,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fkGroupLoanAccountId` (`groupLoanAccountId`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1 COMMENT='Accounts for the loans given out';

--
-- Dumping data for table `loan_account`
--

INSERT INTO `loan_account` (`id`, `loanNo`, `branch_id`, `memberId`, `groupLoanAccountId`, `status`, `loanProductId`, `requestedAmount`, `applicationDate`, `disbursedAmount`, `disbursementDate`, `disbursementNotes`, `interestRate`, `offSetPeriod`, `gracePeriod`, `repaymentsFrequency`, `repaymentsMadeEvery`, `installments`, `penaltyCalculationMethodId`, `penaltyTolerancePeriod`, `penaltyRateChargedPer`, `penaltyRate`, `linkToDepositAccount`, `comments`, `amountApproved`, `approvalDate`, `approvedBy`, `approvalNotes`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(00000000001, 'L1708091402', 0, 6, 1, 1, 1, '4500000.00', 1502259242, NULL, NULL, NULL, '12.00', 1, 7, 1, 3, 6, NULL, NULL, NULL, NULL, 0, NULL, '4500000.00', 1502347429, 3, NULL, 1, 1502259242, 1, '2017-08-10 11:57:01'),
(00000000002, 'L1708091402', 0, 7, 1, 3, 1, '4500000.00', 1502259242, NULL, NULL, NULL, '12.00', 1, 7, 1, 3, 6, NULL, NULL, NULL, NULL, 0, NULL, '4500000.00', 1502796352, 1, 'Loan can now be disbursed, all details verified.', 1, 1502259242, 1, '2017-08-15 11:25:52'),
(00000000003, 'L1708091402', 0, 8, 1, 2, 1, '4500000.00', 1502259242, NULL, NULL, NULL, '12.00', 1, 7, 1, 3, 6, NULL, NULL, NULL, NULL, 0, NULL, '4500000.00', 1502796804, 6, NULL, 1, 1502259242, 1, '2017-08-15 11:33:24'),
(00000000004, 'L1708091402', 0, 9, 1, 1, 1, '4500000.00', 1502259242, NULL, NULL, NULL, '12.00', 1, 7, 1, 3, 6, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 1, 1502259242, 1, '2017-08-09 06:14:02'),
(00000000005, 'L1708093510', 0, 4, 0, 12, 2, '120000.00', 1502260510, '0.00', 0, NULL, '12.00', 30, 1, 1, 3, 1, 0, 0, 0, '0.00', 0, 'Client details have all been checked, client has the potential in a very short time.', '120000.00', 1502794549, 1, NULL, 1, 1502260510, 1, '2017-08-15 10:55:49'),
(00000000008, 'L1708154256', 6, 3, NULL, 3, 2, '300000.00', 1502775776, NULL, NULL, NULL, '5.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'Requested from muganzirwaza', '300000.00', 1502864861, 1, NULL, 1, 1502775776, 1, '2017-08-16 06:27:41'),
(00000000009, 'L1709202243', 6, 1, NULL, 2, 2, '1000000.00', 1504714963, NULL, NULL, NULL, '5.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'The client qualifies for this loan, and he is asking for a loan to boost his business', '0.00', 1505926025, 1, NULL, 1, 1505924563, 1, '2017-09-20 16:47:05'),
(00000000010, 'L1709202558', 6, 1, NULL, 1, 2, '1000000.00', 1504715158, NULL, NULL, NULL, '5.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'The client qualifies for this loan, and he is asking for a loan to boost his business', NULL, NULL, NULL, NULL, 1, 1505924758, 1, '2017-09-20 16:25:58'),
(00000000014, 'L1709234910', 6, 6, NULL, 1, 2, '500000.00', 1506138550, NULL, NULL, NULL, '14.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'No queries on the client''s side of things', NULL, NULL, NULL, NULL, 1, 1506138550, 1, '2017-09-23 03:49:10'),
(00000000015, 'L1709234456', 6, 2, NULL, 1, 2, '900000.00', 1506145496, NULL, NULL, NULL, '19.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'No problems at all', NULL, NULL, NULL, NULL, 1, 1506145496, 1, '2017-09-23 05:44:56'),
(00000000016, 'L1709234607', 6, 2, NULL, 2, 2, '900000.00', 1506145567, NULL, NULL, NULL, '19.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'No problems at all', '900000.00', 1507694410, 1, 'All the documents were verified. The loan may now be served.', 1, 1506145567, 1, '2017-10-11 04:00:10'),
(00000000017, 'L1709254145', 6, 1, NULL, 1, 2, '300000.00', 1506325305, NULL, NULL, NULL, '23.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'All details were verified', NULL, NULL, NULL, NULL, 1, 1506325305, 1, '2017-09-25 07:41:45'),
(00000000019, 'L1709255604', 6, 14, NULL, 1, 2, '700000.00', 1506326164, NULL, NULL, NULL, '14.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'There was no problem observed as regards the clients capability to clear up the credit', NULL, NULL, NULL, NULL, 1, 1506326164, 1, '2017-09-25 07:56:04'),
(00000000020, 'L1710062816', 6, 2, NULL, 1, 3, '700000.00', 1507303696, NULL, NULL, NULL, '14.00', 5, 1, 1, 3, 8, NULL, NULL, NULL, NULL, 0, 'The client passed all the necessary requirements for taking the loan', NULL, NULL, NULL, NULL, 1, 1507303696, 1, '2017-10-06 15:28:16'),
(00000000021, 'L1710060735', 6, 11, NULL, 1, 3, '140000.00', 1507306055, NULL, NULL, NULL, '14.00', 5, 4, 1, 3, 2, NULL, NULL, NULL, NULL, 0, 'Loan application approved', NULL, NULL, NULL, NULL, 1, 1507306055, 1, '2017-10-06 16:07:35'),
(00000000022, 'L1710111453', 6, 3, NULL, 1, 4, '450000.00', 1507695293, NULL, NULL, NULL, '8.00', 3, 2, 0, 0, 2, NULL, NULL, NULL, NULL, 0, 'No problem with the application', NULL, NULL, NULL, NULL, 1, 1507695293, 1, '2017-10-11 04:14:53'),
(00000000023, 'L1710112353', 6, 7, NULL, 5, 2, '5000000.00', 1507695833, '5000000.00', 1507709585, 'nill', '12.00', 30, 1, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'Client shows all capabilities to service the loan fully', '5000000.00', 1507697559, 46, 'Management has verified all the details. The loan can now be served', 1, 1507695833, 1, '2017-10-11 08:13:05'),
(00000000024, 'L1710120814', 6, 4, NULL, 12, 3, '1200000.00', 1507806494, NULL, NULL, NULL, '12.00', 5, 1, 1, 3, 8, NULL, NULL, NULL, NULL, 0, 'All details haven''t yet been reviewed', '1200000.00', 1507807866, 1, 'Unsatisfactory information, client does not meet the minimum conditions required to get a loan', 1, 1507806494, 1, '2017-10-12 11:31:06'),
(00000000025, 'L1710272712', 6, 9, NULL, 1, 4, '340000.00', 1509085632, NULL, NULL, NULL, '12.00', 0, 0, 0, 3, 0, NULL, NULL, NULL, NULL, 0, 'Clients meets all the necessary requirements for the loan', NULL, NULL, NULL, NULL, 1, 1509085632, 1, '2017-11-21 11:06:11'),
(00000000026, 'L1710274234', 6, 7, 3, 1, 4, '120000.00', 1509086554, NULL, NULL, NULL, '0.00', 0, 0, 0, 3, 0, NULL, NULL, NULL, NULL, 0, 'All requirements were presented', NULL, NULL, NULL, NULL, 1, 1509086554, 1, '2017-11-21 11:06:05'),
(00000000027, 'L1710275733', 6, 6, 3, 1, 4, '120000.00', 1509087453, NULL, NULL, NULL, '12.00', 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 'No problem with the application', NULL, NULL, NULL, NULL, 1, 1509087453, 1, '2017-10-27 06:57:33'),
(00000000028, 'L1710275837', 6, 9, 3, 1, 4, '300000.00', 1509087517, NULL, NULL, NULL, '12.00', 0, 0, 0, 3, 0, NULL, NULL, NULL, NULL, 0, 'All the requirements availed', NULL, NULL, NULL, NULL, 1, 1509087517, 1, '2017-11-21 11:06:02'),
(00000000029, 'L1710275930', 6, 8, 3, 1, 4, '140000.00', 1509087570, NULL, NULL, NULL, '12.00', 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 'Application materials availed', NULL, NULL, NULL, NULL, 1, 1509087570, 1, '2017-10-27 06:59:30'),
(00000000030, 'L1711022733', 6, 13, NULL, 1, 3, '34000.00', 1509614853, NULL, NULL, NULL, '12.00', 5, 2, 1, 3, 2, NULL, NULL, NULL, NULL, 0, 'No problems with the application', NULL, NULL, NULL, NULL, 1, 1509614853, 1, '2017-11-02 09:27:33'),
(00000000031, 'L1711153156', 6, 1, NULL, 1, 2, '2000000.00', 1510749116, NULL, NULL, NULL, '30.00', 30, 1, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'Process', NULL, NULL, NULL, NULL, 1, 1510749116, 1, '2017-11-15 12:31:56');

-- --------------------------------------------------------

--
-- Table structure for table `loan_account_approval`
--

DROP TABLE IF EXISTS `loan_account_approval`;
CREATE TABLE IF NOT EXISTS `loan_account_approval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanAccountId` int(11) NOT NULL,
  `amountRecommended` decimal(15,2) DEFAULT NULL,
  `justification` text NOT NULL COMMENT 'Reasons for action taken',
  `status` tinyint(4) NOT NULL COMMENT 'approved-1, rejected-2',
  `staffId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fkLoanAccountId` (`loanAccountId`),
  KEY `fkStaffAccountId` (`staffId`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_account_approval`
--

INSERT INTO `loan_account_approval` (`id`, `loanAccountId`, `amountRecommended`, `justification`, `status`, `staffId`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, 3, '4500000.00', '', 3, 3, 1502347319, 3, '2017-08-10 06:41:59'),
(2, 1, '4500000.00', '', 3, 3, 1502347387, 3, '2017-08-10 06:43:07'),
(5, 2, '4500000.00', 'Loan can now be disbursed, all details verified.', 3, 3, 1502347612, 3, '2017-08-10 06:46:52'),
(6, 5, '120000.00', '', 2, 1, 1502794536, 1, '2017-08-15 10:55:36'),
(7, 5, '120000.00', '', 2, 1, 1502794546, 1, '2017-08-15 10:55:46'),
(8, 5, '120000.00', '', 2, 1, 1502794546, 1, '2017-08-15 10:55:46'),
(9, 5, '120000.00', '', 2, 1, 1502794546, 1, '2017-08-15 10:55:46'),
(10, 5, '120000.00', '', 12, 1, 1502794548, 1, '2017-08-15 10:55:48'),
(11, 5, '120000.00', '', 12, 1, 1502794548, 1, '2017-08-15 10:55:48'),
(12, 5, '120000.00', '', 12, 1, 1502794549, 1, '2017-08-15 10:55:49'),
(13, 5, '120000.00', '', 12, 1, 1502794549, 1, '2017-08-15 10:55:49'),
(14, 8, '300000.00', '', 2, 1, 1502796266, 1, '2017-08-15 11:24:26'),
(15, 8, '300000.00', '', 2, 1, 1502796267, 1, '2017-08-15 11:24:27'),
(16, 8, '300000.00', '', 2, 1, 1502796267, 1, '2017-08-15 11:24:27'),
(17, 8, '300000.00', '', 2, 1, 1502796267, 1, '2017-08-15 11:24:27'),
(18, 8, '300000.00', '', 2, 1, 1502796268, 1, '2017-08-15 11:24:28'),
(19, 8, '300000.00', '', 2, 1, 1502796269, 1, '2017-08-15 11:24:29'),
(20, 8, '300000.00', '', 2, 1, 1502796269, 1, '2017-08-15 11:24:29'),
(21, 8, '300000.00', '', 2, 1, 1502796269, 1, '2017-08-15 11:24:29'),
(22, 8, '300000.00', '', 2, 1, 1502796271, 1, '2017-08-15 11:24:31'),
(23, 8, '300000.00', '', 2, 1, 1502796271, 1, '2017-08-15 11:24:31'),
(24, 2, '4500000.00', '', 2, 1, 1502796278, 1, '2017-08-15 11:24:38'),
(25, 2, '4500000.00', '', 2, 1, 1502796279, 1, '2017-08-15 11:24:39'),
(26, 2, '4500000.00', '', 3, 1, 1502796353, 1, '2017-08-15 11:25:53'),
(27, 3, '4500000.00', '', 2, 6, 1502796804, 6, '2017-08-15 11:33:24'),
(28, 8, '300000.00', '', 3, 1, 1502864854, 1, '2017-08-16 06:27:34'),
(29, 8, '300000.00', '', 3, 1, 1502864856, 1, '2017-08-16 06:27:36'),
(30, 8, '300000.00', '', 3, 1, 1502864861, 1, '2017-08-16 06:27:41'),
(31, 9, '0.00', '', 2, 1, 1505926025, 1, '2017-09-20 16:47:05'),
(32, 9, '1000000.00', '', 3, 3, 1505927450, 3, '2017-09-20 17:10:50'),
(33, 9, '1000000.00', '', 3, 3, 1505927502, 3, '2017-09-20 17:11:42'),
(34, 16, '900000.00', 'All the documents were verified. The loan may now be served.', 2, 1, 1507694410, 1, '2017-10-11 04:00:10'),
(35, 23, '5000000.00', 'All details verified', 2, 1, 1507695899, 1, '2017-10-11 04:24:59'),
(36, 23, '5000000.00', 'All details verified', 3, 1, 1507695958, 1, '2017-10-11 04:25:58'),
(37, 23, '5000000.00', 'Management has verified all the details. The loan can now be served', 4, 46, 1507697559, 46, '2017-10-11 04:52:39'),
(38, 24, '1200000.00', 'Unsatisfactory information, client does not meet the minimum conditions required to get a loan', 2, 1, 1507807727, 1, '2017-10-12 11:28:47'),
(39, 24, '1200000.00', 'Unsatisfactory information, client does not meet the minimum conditions required to get a loan', 12, 1, 1507807866, 1, '2017-10-12 11:31:06');

-- --------------------------------------------------------

--
-- Table structure for table `loan_account_fee`
--

DROP TABLE IF EXISTS `loan_account_fee`;
CREATE TABLE IF NOT EXISTS `loan_account_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanAccountId` int(11) NOT NULL,
  `loanProductFeenId` int(11) NOT NULL,
  `feeAmount` decimal(12,2) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dateCreated` (`dateCreated`),
  KEY `dateModified` (`dateModified`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `fkLoanAccountId` (`loanAccountId`) USING BTREE,
  KEY `fkLoanProductFeeId` (`loanProductFeenId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_account_fee`
--

INSERT INTO `loan_account_fee` (`id`, `loanAccountId`, `loanProductFeenId`, `feeAmount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 22, 1, '20.00', 1507695293, 1, '0000-00-00 00:00:00', 1),
(2, 25, 1, '20000.00', 1509085632, 1, '0000-00-00 00:00:00', 1),
(3, 26, 1, '20000.00', 1509086554, 1, '0000-00-00 00:00:00', 1),
(4, 27, 1, '20000.00', 1509087454, 1, '0000-00-00 00:00:00', 1),
(5, 28, 1, '20000.00', 1509087517, 1, '0000-00-00 00:00:00', 1),
(6, 29, 1, '20000.00', 1509087571, 1, '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_account_penalty`
--

DROP TABLE IF EXISTS `loan_account_penalty`;
CREATE TABLE IF NOT EXISTS `loan_account_penalty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanAccountId` int(11) NOT NULL,
  `penaltyCalculationMethod` tinyint(4) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `daysDelayed` tinyint(4) NOT NULL,
  `penaltyTolerancePeriod` tinyint(4) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `penaltyId` (`penaltyCalculationMethod`),
  KEY `fkLoanId` (`loanAccountId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan accounts are be subjected to';

-- --------------------------------------------------------

--
-- Table structure for table `loan_collateral`
--

DROP TABLE IF EXISTS `loan_collateral`;
CREATE TABLE IF NOT EXISTS `loan_collateral` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanAccountId` int(11) NOT NULL,
  `itemName` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `itemValue` decimal(15,2) NOT NULL,
  `attachmentUrl` varchar(150) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_id` (`loanAccountId`),
  KEY `dateModified` (`dateModified`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateCreated` (`dateCreated`),
  KEY `createdBy` (`createdBy`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_collateral`
--

INSERT INTO `loan_collateral` (`id`, `loanAccountId`, `itemName`, `description`, `itemValue`, `attachmentUrl`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 0, 'Iphone 7c', 'Iphone with latest IOS and modern technology', '300000.00', 'img/loanAccounts/L1708093136/collateral/seamITechLogo.png', 1502260296, 1, '2017-09-23 03:56:24', 1),
(2, 5, 'Iphone 7c', 'Iphone with latest IOS and modern technology', '300000.00', 'img/loanAccounts/L1708093510/collateral/seamITechLogo.png', 1502260511, 1, '2017-09-23 03:56:19', 1),
(3, 6, 'Car log book', 'UAL 560G', '7000000.00', 'img/loanAccounts/L1708153614/collateral/Capture.PNG', 1502775375, 1, '2017-09-23 03:56:12', 1),
(4, 7, 'Car log book', 'UAL 560G', '7000000.00', 'img/loanAccounts/L1708153828/collateral/Capture.PNG', 1502775508, 1, '2017-09-23 03:56:02', 1),
(5, 8, 'Car log book', 'UAL 560G', '7000000.00', 'img/loanAccounts/L1708154256/collateral/Capture.PNG', 1502775776, 1, '2017-09-23 03:55:57', 1),
(6, 9, 'Car Log Book', 'The client brought forward a car log book of car registration Number UAL 560G L Toyota Premio ', '6000000.00', 'img/loanAccounts/L1709202243/collateral/2-218x150.jpg', 1505924564, 1, '2017-09-23 03:55:51', 1),
(7, 10, 'Car Log Book', 'The client brought forward a car log book of car registration Number UAL 560G L Toyota Premio ', '6000000.00', 'img/loanAccounts/L1709202558/collateral/2-218x150.jpg', 1505924758, 1, '2017-09-23 03:55:41', 1),
(11, 14, 'Ipad', 'Model 32', '1800000.00', 'img/loanAccounts/L1709234910/collateral/ECC_2017.PNG', 1506138550, 1, '2017-09-23 04:01:20', 1),
(12, 15, 'Banana plantation', '50x100 acre plantation with land title', '760000.00', 'img/loanAccounts/L1709234456/collateral/WIN_20170831_13_06_32_Pro.jpg', 1506145496, 1, '2017-09-23 05:44:56', 1),
(13, 16, 'Banana plantation', '50x100 acre plantation with land title', '760000.00', 'img/loanAccounts/L1709234607/collateral/WIN_20170831_13_06_32_Pro.jpg', 1506145567, 1, '2017-09-23 05:46:07', 1),
(14, 17, 'Motor cycle', 'UAJ 458K', '1000000.00', 'img/loanAccounts/L1709254145/collateral/WIN_20170831_13_06_32_Pro.jpg', 1506325305, 1, '2017-09-25 07:41:45', 1),
(17, 19, 'Microwave oven', 'Toshiba model', '200000.00', '', 1506326164, 1, '2017-09-25 07:56:04', 1),
(18, 19, 'Desks and benches', 'Available at here work premises', '300000.00', '', 1506326164, 1, '2017-09-25 07:56:04', 1),
(19, 20, 'Electricity Generator', '2.0 HP Diesel Generator', '1150000.00', '', 1507303697, 1, '2017-10-06 15:28:17', 1),
(20, 21, 'Battery equipments', 'Equipments for the batteries', '120000.00', '', 1507306055, 1, '2017-10-06 16:07:35', 1),
(21, 25, 'Motor cycle', 'Registration plates of UAJ 436H', '1230000.00', '', 1509085632, 1, '2017-10-27 06:27:12', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_documents`
--

DROP TABLE IF EXISTS `loan_documents`;
CREATE TABLE IF NOT EXISTS `loan_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loan_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `path` text NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `loan_products`
--

DROP TABLE IF EXISTS `loan_products`;
CREATE TABLE IF NOT EXISTS `loan_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `productType` tinyint(4) NOT NULL COMMENT 'Type of the loan product',
  `active` tinyint(1) DEFAULT '0' COMMENT '1 - Active, 0 Inactive',
  `availableTo` tinyint(4) DEFAULT NULL COMMENT '1 - Clients, 2 - Groups or 3 - Both',
  `defAmount` decimal(15,2) DEFAULT NULL COMMENT 'Default amount that can be disbursed for this product',
  `minAmount` decimal(12,2) DEFAULT NULL COMMENT 'Min Amount that can be loaned for this produc',
  `maxAmount` decimal(12,2) DEFAULT NULL COMMENT 'Max Amount that can be loan for this product',
  `maxTranches` tinyint(2) DEFAULT NULL COMMENT 'maximum number of disbursements for thisproduct',
  `defInterest` decimal(4,2) DEFAULT NULL COMMENT 'Default interest amount',
  `minInterest` decimal(4,2) DEFAULT NULL COMMENT 'min interest rate',
  `maxInterest` decimal(4,2) DEFAULT NULL COMMENT 'maximum interest rate',
  `repaymentsFrequency` tinyint(4) DEFAULT NULL COMMENT 'Number of days/weeks/months before each repyment is made',
  `repaymentsMadeEvery` tinyint(1) DEFAULT NULL COMMENT '1 - Day, 2-Week, 3 - Month',
  `defRepaymentInstallments` tinyint(4) DEFAULT NULL COMMENT 'Number of repayments in a schedule',
  `minRepaymentInstallments` tinyint(4) DEFAULT NULL COMMENT 'minimum installments in which the loan can be repaid',
  `maxRepaymentInstallments` tinyint(4) DEFAULT NULL COMMENT 'maximum installments in which the loan can be repaid',
  `initialAccountState` tinyint(1) DEFAULT '1' COMMENT '1-Pending Approval, 2-Partial_Application',
  `defGracePeriod` tinyint(4) DEFAULT NULL COMMENT 'Default grace period for this product',
  `minGracePeriod` tinyint(4) DEFAULT NULL COMMENT 'Minimum grace period for the loan',
  `maxGracePeriod` tinyint(4) DEFAULT NULL COMMENT 'Maximum grace period for the loan',
  `minCollateral` decimal(5,2) DEFAULT NULL COMMENT 'Percentage of the loan required as collateral',
  `minGuarantors` tinyint(1) DEFAULT NULL COMMENT 'Minimum number of guarantors required',
  `defOffSet` tinyint(4) DEFAULT NULL COMMENT 'Default Offset for first repayment date',
  `minOffSet` tinyint(4) DEFAULT NULL COMMENT 'minimum offset for repayment date',
  `maxOffSet` tinyint(4) DEFAULT NULL COMMENT 'maximum offset for repayment date',
  `penaltyApplicable` tinyint(4) DEFAULT NULL COMMENT '1 - Yes, 0 - No',
  `penaltyCalculationMethodId` tinyint(2) DEFAULT NULL,
  `penaltyTolerancePeriod` tinyint(4) DEFAULT NULL,
  `penaltyRateChargedPer` tinyint(1) DEFAULT NULL,
  `defPenaltyRate` decimal(4,2) DEFAULT NULL,
  `minPenaltyRate` decimal(4,2) DEFAULT NULL,
  `maxPenaltyRate` decimal(4,2) DEFAULT NULL,
  `daysOfYear` tinyint(1) DEFAULT NULL COMMENT 'How days of the year are counted',
  `taxRateSource` tinyint(4) DEFAULT NULL COMMENT 'Reference to the tax rate source',
  `taxCalculationMethod` tinyint(4) DEFAULT NULL COMMENT '1-Inclusive, 2- Exclusive',
  `linkToDepositAccount` tinyint(1) DEFAULT NULL COMMENT '0-No, 1-Yes',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkAvailableTO` (`availableTo`),
  KEY `fkTaxRateSource` (`taxRateSource`),
  KEY `fkTaxCalculationMethod` (`taxCalculationMethod`),
  KEY `fkLinkToDepositAccount` (`linkToDepositAccount`) USING BTREE,
  KEY `dateCreated` (`dateCreated`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `dateModified` (`dateModified`),
  KEY `fkModifiedBy` (`modifiedBy`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_products`
--

INSERT INTO `loan_products` (`id`, `productName`, `description`, `productType`, `active`, `availableTo`, `defAmount`, `minAmount`, `maxAmount`, `maxTranches`, `defInterest`, `minInterest`, `maxInterest`, `repaymentsFrequency`, `repaymentsMadeEvery`, `defRepaymentInstallments`, `minRepaymentInstallments`, `maxRepaymentInstallments`, `initialAccountState`, `defGracePeriod`, `minGracePeriod`, `maxGracePeriod`, `minCollateral`, `minGuarantors`, `defOffSet`, `minOffSet`, `maxOffSet`, `penaltyApplicable`, `penaltyCalculationMethodId`, `penaltyTolerancePeriod`, `penaltyRateChargedPer`, `defPenaltyRate`, `minPenaltyRate`, `maxPenaltyRate`, `daysOfYear`, `taxRateSource`, `taxCalculationMethod`, `linkToDepositAccount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Group Loan', ' Loan to be disbursed to Sacco members group', 1, 1, 2, '5000000.00', '2000000.00', '10000000.00', 1, '15.00', '10.00', '30.00', 1, 3, 6, 1, 6, 1, 7, 1, 7, '40.00', 3, 1, 1, 3, NULL, 2, 7, 3, '10.00', '0.00', '10.00', 0, 1, 1, 0, 1498482882, 1, '0000-00-00 00:00:00', 1),
(2, 'Quick Loan', 'Loan disbursed like immediately', 1, 1, 1, '100000.00', '100000.00', '1000000.00', 1, '5.00', '5.00', '30.00', 1, 3, 1, 1, 12, 1, 1, 1, 1, '60.00', 0, 30, 0, 30, NULL, 2, 1, 1, '5.00', '5.00', '5.00', 0, 1, 1, 1, 1498485018, 1, '2017-11-15 12:31:14', 1),
(3, 'Individual Loan', 'Loan given to an individual member', 1, 1, 1, '230000.00', '200000.00', '2000000.00', 1, '2.30', '3.00', '16.00', 1, 3, 2, 2, 10, 1, 0, 0, 0, '70.00', 2, 5, 0, 5, NULL, 2, 2, 3, '10.00', '5.00', '20.00', 0, 0, 0, 1, 1506931885, 1, '2017-10-02 08:11:25', 1),
(4, 'Agriculture Loan', 'Loan for agricultural production improvement', 1, 1, 3, '540000.00', '0.00', '0.00', 1, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, 1, 0, 0, 0, '43.00', 0, 0, 0, 0, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1506934480, 1, '2017-10-02 08:54:40', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_products_penalty`
--

DROP TABLE IF EXISTS `loan_products_penalty`;
CREATE TABLE IF NOT EXISTS `loan_products_penalty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `penaltyCalculationMethodId` tinyint(4) NOT NULL COMMENT 'Ref to the penalty calculation method',
  `penaltyChargedAs` tinyint(1) NOT NULL,
  `penaltyTolerancePeriod` int(11) NOT NULL COMMENT 'Days before which no penalties will be applied to an account even if there is a late repayment',
  `defaultAmount` decimal(12,2) NOT NULL,
  `minAmount` decimal(12,2) NOT NULL,
  `maxAmount` decimal(12,2) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `fkCreatedBy` (`createBy`),
  KEY `penaltyChargedAs` (`penaltyChargedAs`),
  KEY `fkPenaltyCalcMethod` (`penaltyCalculationMethodId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan products can be subjected to';

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_fee`
--

DROP TABLE IF EXISTS `loan_product_fee`;
CREATE TABLE IF NOT EXISTS `loan_product_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feeName` varchar(50) NOT NULL,
  `feeType` tinyint(4) DEFAULT NULL,
  `amountCalculatedAs` tinyint(1) NOT NULL COMMENT '1-Percentage, 2 - Fixed Amount',
  `requiredFee` tinyint(1) NOT NULL COMMENT '1 - Required, 0 - Optional',
  `amount` decimal(12,2) NOT NULL COMMENT 'Amount or %age to be charged',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateModified` (`dateModified`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `dateCreated` (`dateCreated`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a loan product';

--
-- Dumping data for table `loan_product_fee`
--

INSERT INTO `loan_product_fee` (`id`, `feeName`, `feeType`, `amountCalculatedAs`, `requiredFee`, `amount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Application Fee', 1, 1, 1, '20000.00', 1506934480, 1, '2017-10-02 08:54:40', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_feen`
--

DROP TABLE IF EXISTS `loan_product_feen`;
CREATE TABLE IF NOT EXISTS `loan_product_feen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanProductId` int(11) NOT NULL,
  `loanProductFeeId` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `dateModified` (`dateModified`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateCreated` (`dateCreated`),
  KEY `fkCreatedBy` (`createdBy`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a loan product';

--
-- Dumping data for table `loan_product_feen`
--

INSERT INTO `loan_product_feen` (`id`, `loanProductId`, `loanProductFeeId`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, 4, 1, 1, 1506934480, 1, '2017-10-02 08:57:57');

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_type`
--

DROP TABLE IF EXISTS `loan_product_type`;
CREATE TABLE IF NOT EXISTS `loan_product_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeName` varchar(50) NOT NULL COMMENT 'Name of the product type',
  `description` varchar(250) NOT NULL COMMENT 'Description',
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp record was entered',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record modification date',
  `createdBy` int(11) NOT NULL COMMENT 'staff that entered record',
  `modifiedBy` int(11) NOT NULL COMMENT 'User modifying entry',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_product_type`
--

INSERT INTO `loan_product_type` (`id`, `typeName`, `description`, `dateCreated`, `dateModified`, `createdBy`, `modifiedBy`) VALUES
(1, 'Fixed Term Loan', 'A Fixed interest rate which allows accurate prediction of future payments', 0, '2017-06-26 13:35:13', 0, 0),
(2, 'Dynamic Term Loan', 'Allows dynamic calculation of the interest rate, and thus, future payments\r\n', 0, '2017-06-26 13:35:40', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `loan_repayment`
--

DROP TABLE IF EXISTS `loan_repayment`;
CREATE TABLE IF NOT EXISTS `loan_repayment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transactionId` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `loanAccountId` int(11) NOT NULL COMMENT 'Loan Account ID',
  `amount` decimal(15,2) NOT NULL,
  `transactionType` tinyint(1) DEFAULT NULL,
  `comments` text NOT NULL,
  `transactionDate` int(11) NOT NULL,
  `recievedBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_id` (`loanAccountId`),
  KEY `transaction_date` (`transactionDate`),
  KEY `recieving_staff` (`recievedBy`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `marital_status`
--

DROP TABLE IF EXISTS `marital_status`;
CREATE TABLE IF NOT EXISTS `marital_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `marital_status`
--

INSERT INTO `marital_status` (`id`, `name`, `description`) VALUES
(1, 'Single', 'single'),
(2, 'Married', 'married'),
(3, 'Divorced', 'divorced'),
(4, 'Windowed', 'Windowed');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
CREATE TABLE IF NOT EXISTS `member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personId` int(11) NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Whether member active or not',
  `branch_id` int(11) NOT NULL COMMENT 'Ref to branch member registered from from',
  `memberType` int(11) NOT NULL,
  `dateAdded` int(11) NOT NULL COMMENT 'Timestamp of the moment the member was added',
  `addedBy` int(11) NOT NULL,
  `comment` text,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of the moment the member was modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to staff who modified the record',
  PRIMARY KEY (`id`),
  KEY `added_by` (`addedBy`),
  KEY `person_id` (`personId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `personId`, `active`, `branch_id`, `memberType`, `dateAdded`, `addedBy`, `comment`, `dateModified`, `modifiedBy`) VALUES
(1, 28, 1, 0, 0, 1499115600, 1, 'Created successfully', '2017-07-09 16:33:25', 1),
(2, 29, 1, 0, 0, 1499115600, 1, '', '2017-07-09 16:33:33', 1),
(3, 30, 1, 0, 0, 1499015600, 1, 'Client has business in Kampala and is an It consultant', '2017-07-09 16:33:46', 1),
(4, 31, 1, 0, 0, 1498115600, 1, '', '2017-07-09 16:33:57', 1),
(5, 32, 1, 0, 0, 1499115600, 1, '', '2017-07-09 16:34:03', 1),
(6, 33, 1, 0, 0, 2017, 1, '', '2017-06-26 12:33:29', 1),
(7, 34, 1, 0, 0, 1499115600, 1, '', '2017-07-09 16:34:08', 1),
(8, 35, 1, 0, 0, 1499115600, 1, '', '2017-07-09 16:34:44', 1),
(9, 36, 1, 0, 0, 1499115600, 1, '', '2017-07-09 16:35:03', 1),
(10, 37, 1, 0, 0, 1499115650, 1, '', '2017-07-09 16:35:13', 1),
(11, 38, 1, 0, 0, 1499125600, 1, '', '2017-07-09 16:35:24', 1),
(12, 39, 1, 0, 0, 1493115600, 1, '', '2017-07-09 16:36:00', 1),
(13, 40, 1, 0, 0, 1499115600, 1, '', '2017-07-09 16:43:37', 1),
(14, 41, 1, 0, 0, 1498815600, 1, '', '2017-07-09 16:44:17', 1),
(15, 42, 1, 0, 0, 1499105600, 1, '', '2017-07-09 16:44:01', 1);

-- --------------------------------------------------------

--
-- Table structure for table `member_deposit_account`
--

DROP TABLE IF EXISTS `member_deposit_account`;
CREATE TABLE IF NOT EXISTS `member_deposit_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberId` int(11) NOT NULL,
  `depositAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateModified` (`dateModified`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `dateCreated` (`dateCreated`),
  KEY `fkDepositAccountId` (`depositAccountId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COMMENT='Holds a reference to the accounts owned by a member';

--
-- Dumping data for table `member_deposit_account`
--

INSERT INTO `member_deposit_account` (`id`, `memberId`, `depositAccountId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 3, 1, 0, 0, '0000-00-00 00:00:00', 2),
(2, 3, 2, 0, 0, '0000-00-00 00:00:00', 2),
(3, 3, 3, 1505929674, 7, '0000-00-00 00:00:00', 7),
(4, 8, 5, 1509610441, 1, '0000-00-00 00:00:00', 1),
(5, 5, 6, 1509612234, 1, '2017-11-02 08:43:54', 1),
(6, 11, 7, 1509612363, 1, '2017-11-02 08:46:03', 1),
(7, 13, 8, 1509612657, 1, '2017-11-02 08:50:57', 1),
(8, 5, 9, 1509612920, 1, '2017-11-02 08:55:20', 1),
(9, 3, 10, 1511245818, 1, '2017-11-21 06:30:18', 1);

-- --------------------------------------------------------

--
-- Table structure for table `member_loan_account`
--

DROP TABLE IF EXISTS `member_loan_account`;
CREATE TABLE IF NOT EXISTS `member_loan_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberId` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkMemberId` (`memberId`),
  KEY `fkLoanId` (`loanAccountId`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateModified` (`dateModified`),
  KEY `dateCreated` (`dateCreated`),
  KEY `fkCreatedBy` (`createdBy`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `other_settings`
--

DROP TABLE IF EXISTS `other_settings`;
CREATE TABLE IF NOT EXISTS `other_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minimum_balance` bigint(20) NOT NULL,
  `maximum_guarantors` int(11) NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `parish`
--

DROP TABLE IF EXISTS `parish`;
CREATE TABLE IF NOT EXISTS `parish` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `subcounty_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parish`
--

INSERT INTO `parish` (`id`, `name`, `subcounty_id`) VALUES
(1, 'Kawempe central', 1),
(2, 'Kawempe North', 1);

-- --------------------------------------------------------

--
-- Table structure for table `penalty_calculation_method`
--

DROP TABLE IF EXISTS `penalty_calculation_method`;
CREATE TABLE IF NOT EXISTS `penalty_calculation_method` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `methodDescription` varchar(150) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkCreatedBy` (`createdBy`),
  KEY `fkModifiedBy` (`modifiedBy`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Methods for calculating penalities';

--
-- Dumping data for table `penalty_calculation_method`
--

INSERT INTO `penalty_calculation_method` (`id`, `methodDescription`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'No Penalty', 1498487362, 1, '2017-10-02 08:00:23', 1),
(2, 'Overdue Principle * # of late Days * Penalty Rate', 1498487362, 1, '2017-10-02 08:00:18', 1);

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
CREATE TABLE IF NOT EXISTS `person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(8) NOT NULL,
  `person_type` int(11) NOT NULL,
  `person_number` varchar(45) NOT NULL COMMENT 'Based on person Type -- Client/Staff',
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `othername` varchar(156) DEFAULT NULL,
  `id_type` tinyint(2) NOT NULL COMMENT 'Type of id',
  `id_number` varchar(80) NOT NULL,
  `id_specimen` text NOT NULL,
  `gender` varchar(3) NOT NULL,
  `marital_status` varchar(50) NOT NULL,
  `dateofbirth` date NOT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `email` varchar(156) DEFAULT NULL,
  `postal_address` varchar(156) DEFAULT NULL,
  `physical_address` varchar(156) DEFAULT NULL,
  `occupation` varchar(150) NOT NULL,
  `children_no` tinyint(4) DEFAULT '0',
  `dependants_no` tinyint(4) DEFAULT '0',
  `CRB_card_no` varchar(30) DEFAULT NULL,
  `photograph` text,
  `comment` text,
  `date_registered` datetime NOT NULL,
  `registered_by` int(11) NOT NULL,
  `district` varchar(100) NOT NULL,
  `county` varchar(100) NOT NULL,
  `subcounty` varchar(100) NOT NULL,
  `parish` varchar(100) NOT NULL,
  `village` varchar(100) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_type` (`id_type`),
  KEY `registered_by` (`registered_by`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(1, 'Mr', 2, 'S161116102242', 'Alfred', 'Platin', 'M', 0, 'B94994', '', 'M', '', '1988-08-08', '0702-771-124', 'mplat84@gmail.com', '', 'Kampala', '', 0, 0, '', '', 'First user registration', '2016-11-16 00:00:00', 1, '', '', '', '1', '1', 0),
(28, 'Mr', 0, 'BFS00000028', 'Sulaiman', 'Katumba', '', 1, '94394', 'img/ids/20170618_192630.jpg', 'M', 'Married', '1970-01-01', '(073) 000-0000', '', '36211 kampala', 'kampala', 'BLB Tenant', 1, 1, NULL, '', 'Created successfully', '2017-06-26 00:00:00', 1, 'kampala', 'Kawempe', 'Kawempe', '', 'kawempe tula', 0),
(29, 'Mrs', 0, 'BFS00000029', 'Christine', 'Lwanga', '', 1, '9238', 'img/ids/logo.jpg', 'F', '', '1980-07-08', '(073) 000-0000', '', '', 'kampala', 'BLB Staff', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(30, 'Mr', 0, 'BFS00000030', 'Simon', 'Kabogoza', '', 1, '32828', 'img/ids/developr.jpg', 'M', 'Married', '2017-02-08', '(073) 000-0000', 'mplat84@gmail.com', '', 'kampala', 'kampala', 1, 1, NULL, '', 'Client has business in Kampala and is an It consultant', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(31, 'Mr', 0, 'BFS00000031', 'Francis', 'Muyomba', '', 1, '433423', 'img/ids/maxresdefault.jpg', 'M', 'Single', '1980-01-02', '(023) 000-0000', '', 'kampala', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(32, 'Mr', 0, 'BFS00000032', 'Katende', 'Mukwaba', '', 1, '3434343', 'img/ids/expi.PNG', 'M', 'Single', '1949-02-02', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(33, 'Mr', 0, 'BFS00000033', 'Baker', 'Namukala', '', 1, '74383', 'img/ids/aaa.PNG', 'M', 'Single', '1987-02-04', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, 'img/profiles/WIN_20170709_00_00_28_Pro.jpg', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(34, 'Mr', 0, 'BFS00000034', 'Daniel', 'Twinamatsiko', '', 1, '93438', 'img/ids/queen-elizabeth-national-park.jpg', 'M', '', '2001-01-04', '(073) 290-1901', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(35, 'Mr', 0, 'BFS00000035', 'Fred', 'Tukamuhabwa', '', 1, '84389', 'img/ids/acc-ndali-lodge.jpg', 'M', '', '1988-07-02', '(073) 278-2378', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(36, 'Mrs', 0, 'BFS00000036', 'Christine', 'Tibagwa', '', 1, '438934', 'img/ids/logo.png', 'F', 'Single', '1988-03-02', '(073) 723-7823', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(37, 'Mr', 0, 'BFS00000037', 'Eroni', 'Kikomaga', '', 1, '84589', 'img/ids/image002.jpg', 'M', 'Single', '2000-03-02', '(073) 439-0309', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(38, 'Mrs', 0, 'BFS00000038', 'Ruth', 'Nsamba', '', 1, '848389', 'img/ids/logo.png', 'F', 'Single', '1970-01-01', '(074) 378-4378', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(39, 'Mr', 0, 'BFS00000039', 'William', 'Mugejjera', '', 1, '948389', 'img/ids/payment.PNG', 'M', 'Single', '1988-07-02', '(095) 095-4095', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(40, 'Mrs', 0, 'BFS00000040', 'Rose', 'Nakanyike ', '', 1, '93292', 'img/ids/animated-overlay.gif', 'F', 'Married', '1965-04-03', '(088) 238-2923', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(41, 'Mrs', 0, 'BFS00000041', 'Agnes', 'Nansereko', '', 1, '94393', 'img/ids/jcrop.gif', 'F', '', '1987-02-04', '(074) 383-9894', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(42, 'Mr', 0, 'BFS00000042', 'Christine', 'Nabaweesi', '', 1, '843893', 'img/ids/apple-touch-icon-72-precomposed.png', 'F', '', '1987-08-09', '(903) 409-3409', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(43, 'Mrs', 1, 'SBFS00000043', 'Sarah', 'N', '', 1, 'cm34jjf93lfff', '', 'F', '', '1988-01-01', '(908) 083-9393', 'adongjanet@yahoo.com', '20938', 'Kampala', '', 0, 0, NULL, '', 'Approved to join the team', '0000-00-00 00:00:00', 1, 'Kampala', 'Kampala', 'Kampala ', 'Kampala', 'Kampala', 0),
(44, 'Mrs', 1, 'SBFS00000044', 'Cissy', 'kiyaga', '', 1, 'CM7803JDHU378', '', 'F', '', '1969-12-09', '(077) 493-8930', 'kasulemartin@gmail.com', 'Wobulenzi', 'Luweero Main Market', '', 0, 0, NULL, '', 'New branch credit committe member', '0000-00-00 00:00:00', 1, 'Luweero', 'Wobulenzi', 'Wobulenzi', 'Kitendero', 'Kitendero', 0),
(45, 'Mr', 1, 'SBFS00000045', 'Kalibbala', 'Michael', '', 1, '8932PA8932', '', 'M', '', '1986-08-08', '(073) 903-2902', 'example@buladde.or.ug', '', 'kampala', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 1, '', '', '', '', '', 0),
(46, 'Mr', 1, 'SBFS00000046', 'M', 'Peter', '', 3, 'B6732762378', '', '', '', '1979-01-04', '(073) 673-2767', 'example@buladde.or.ug', '', 'Kampala', '', 0, 0, NULL, '', 'Branch credit committee', '0000-00-00 00:00:00', 1, '', '', '', '', '', 0),
(47, 'Mr', 1, 'SBFS00000047', 'Platin', 'Alfred', '', 1, 'Cew435465', '', 'M', '', '1987-08-08', '(073) 677-6167', '', '', 'kampala', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 1, '', '', '', '', '', 0),
(48, 'Mr', 1, 'SBFS00000048', 'Joshua', 'Atwiine', '', 1, '8934893', '', 'M', '', '1987-08-08', '(070) 278-3272', 'mplat84@gmail.com', '256', 'Kampala', '', 0, 0, NULL, '', 'New Staff to handle accounting details of the firm.', '0000-00-00 00:00:00', 1, 'kampala', 'Uganda', 'Kawempe', 'kawempe', 'kawempe 11', 0);

-- --------------------------------------------------------

--
-- Table structure for table `persontype`
--

DROP TABLE IF EXISTS `persontype`;
CREATE TABLE IF NOT EXISTS `persontype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `persontype`
--

INSERT INTO `persontype` (`id`, `name`, `description`) VALUES
(1, 'member ', 'Person as Member '),
(2, 'staff', 'Person as staff');

-- --------------------------------------------------------

--
-- Table structure for table `person_address`
--

DROP TABLE IF EXISTS `person_address`;
CREATE TABLE IF NOT EXISTS `person_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personId` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `address1` varchar(100) NOT NULL,
  `address2` varchar(100) NOT NULL,
  `address_type` tinyint(4) NOT NULL,
  `parish_id` int(11) NOT NULL,
  `village` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `person_business`
--

DROP TABLE IF EXISTS `person_business`;
CREATE TABLE IF NOT EXISTS `person_business` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personId` int(11) NOT NULL,
  `businessName` varchar(200) NOT NULL,
  `natureOfBusiness` varchar(300) NOT NULL,
  `businessLocation` text NOT NULL,
  `numberOfEmployees` int(11) NOT NULL,
  `businessWorth` decimal(15,2) NOT NULL,
  `ursbNumber` varchar(80) NOT NULL,
  `certificateOfIncorporation` text NOT NULL,
  `dateAdded` int(11) NOT NULL,
  `addedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person_business`
--

INSERT INTO `person_business` (`id`, `personId`, `businessName`, `natureOfBusiness`, `businessLocation`, `numberOfEmployees`, `businessWorth`, `ursbNumber`, `certificateOfIncorporation`, `dateAdded`, `addedBy`, `dateModified`) VALUES
(27, 32, 'End-End Entreprises', '', 'Soroti Junction', 30, '4000000.00', 'UR768392K', '', 1501810465, 0, '2017-08-04 01:34:25'),
(28, 0, 'Connectsoft Ltd', '', 'Equatoria mall', 3, '20000000.00', '4414', '', 1502775375, 0, '2017-08-15 05:36:15'),
(29, 0, 'Connectsoft Ltd', '', 'Equatoria mall', 3, '20000000.00', '4414', '', 1502775508, 0, '2017-08-15 05:38:28'),
(30, 30, 'Connectsoft Ltd', '', 'Equatoria mall', 3, '20000000.00', '4414', '', 1502775776, 0, '2017-08-15 05:42:56'),
(32, 28, 'Connectosft Limited', '', 'Equatoria Building', 3, '30000000.00', '4415', '', 1505924758, 0, '2017-09-20 16:25:58'),
(33, 31, 'Home and Homes restaurants', '', 'Kisuggu, ENtebbe road', 9, '1000000.00', '890JK', '', 1506129980, 0, '2017-09-23 01:26:20'),
(35, 29, 'High End Entreprises', '', 'Kikajjo Zone, Mutundwe', 90, '9000000.00', '7802', '', 1506145567, 0, '2017-09-23 05:46:07'),
(37, 41, 'Mama Dora Food Joint', '', 'Nankulabye, Musiitwa zone', 3, '200000.00', '0000', '', 1506326164, 0, '2017-09-25 07:56:04');

-- --------------------------------------------------------

--
-- Table structure for table `person_employment`
--

DROP TABLE IF EXISTS `person_employment`;
CREATE TABLE IF NOT EXISTS `person_employment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personId` int(11) NOT NULL,
  `employer` varchar(100) NOT NULL,
  `years_of_employment` int(11) NOT NULL,
  `nature_of_employment` varchar(300) NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `monthlySalary` decimal(15,2) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Creation timestamp',
  `createdBy` int(11) NOT NULL COMMENT 'ID for user adding the record',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'modification timestamp',
  `modifiedBy` int(11) NOT NULL COMMENT 'ID for user modifying the record',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person_employment`
--

INSERT INTO `person_employment` (`id`, `personId`, `employer`, `years_of_employment`, `nature_of_employment`, `startDate`, `endDate`, `monthlySalary`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 28, 'Airtel Uganda', 2, 'Customer Care', NULL, NULL, '700000.00', 0, 0, '2017-06-26 10:46:37', 0),
(4, 31, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:29:13', 0),
(5, 32, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:31:39', 0),
(6, 33, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:33:29', 0),
(7, 34, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:34:46', 0),
(8, 35, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:36:26', 0),
(9, 36, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:37:34', 0),
(10, 37, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:38:52', 0),
(11, 38, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:39:45', 0),
(12, 39, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:48:51', 0),
(13, 40, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:50:15', 0),
(14, 41, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:51:14', 0),
(15, 42, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-26 12:52:11', 0);

-- --------------------------------------------------------

--
-- Table structure for table `person_relative`
--

DROP TABLE IF EXISTS `person_relative`;
CREATE TABLE IF NOT EXISTS `person_relative` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personId` int(11) NOT NULL,
  `is_next_of_kin` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - Yes, 0 - No',
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `other_names` varchar(50) DEFAULT NULL,
  `relative_gender` tinyint(2) NOT NULL,
  `relationship` tinyint(2) NOT NULL,
  `address` varchar(100) NOT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `telephone` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `person_id` (`personId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person_relative`
--

INSERT INTO `person_relative` (`id`, `personId`, `is_next_of_kin`, `first_name`, `last_name`, `other_names`, `relative_gender`, `relationship`, `address`, `address2`, `telephone`) VALUES
(1, 28, 1, 'Allan ', 'Kassujja', '', 1, 1, 'kampala', 'kampala', '(073) 211-1111'),
(2, 29, 1, 'Cissy', '', '', 1, 2, '', '', ''),
(3, 30, 1, 'Ronald', 'Mujuni', '', 1, 2, '', 'kampala', '(073) 010-1010'),
(4, 31, 0, '', '', '', 0, 0, '', '', ''),
(5, 32, 1, '', '', '', 0, 2, 'Cissy', '', ''),
(6, 33, 0, '', '', '', 0, 0, '', '', ''),
(7, 34, 0, '', '', '', 0, 0, '', '', ''),
(8, 35, 0, '', '', '', 0, 0, '', '', ''),
(9, 36, 0, '', '', '', 0, 0, '', '', ''),
(10, 37, 0, '', '', '', 0, 0, '', '', ''),
(11, 38, 0, '', '', '', 0, 0, '', '', ''),
(12, 39, 0, '', '', '', 0, 0, '', '', ''),
(13, 40, 0, '', '', '', 0, 0, '', '', ''),
(14, 41, 0, '', '', '', 0, 0, '', '', ''),
(15, 42, 0, '', '', '', 0, 0, '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

DROP TABLE IF EXISTS `position`;
CREATE TABLE IF NOT EXISTS `position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access_level` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `access_level`, `name`, `description`, `active`) VALUES
(1, 1, 'Administrator', 'General System Administration', 1),
(2, 2, 'Loan Officer ', 'Credit officers', 1),
(3, 3, 'Branch Manager', 'Branch Managers', 1),
(4, 5, 'Branch Credit Committee Officer', 'Branch Credit Committee Officer', 1),
(5, 5, 'Management Credit Committee member\n', 'Management Credit Committee\r\n', 1),
(6, 6, 'Executive board committe member', 'Executive board committe', 1),
(7, 7, 'Accountant', 'This is an accountant who will handle account positions', 1);

-- --------------------------------------------------------

--
-- Table structure for table `relationship_type`
--

DROP TABLE IF EXISTS `relationship_type`;
CREATE TABLE IF NOT EXISTS `relationship_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rel_type` varchar(100) NOT NULL COMMENT 'Type of relationship',
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `relationship_type`
--

INSERT INTO `relationship_type` (`id`, `rel_type`, `description`) VALUES
(1, 'Brother', ''),
(2, 'Sister', ''),
(4, 'Husband', 'Persons husband'),
(5, 'Wife', 'Persons Wife'),
(6, 'Nephew', 'nephew'),
(7, 'Niece', 'niece'),
(8, 'Uncle', 'uncle'),
(9, 'Auntie', 'Auntie'),
(10, 'Grand Mother ', 'Grand mother'),
(11, 'Grand Father', 'Grand Father'),
(12, 'Father', 'Father'),
(13, 'Mother', 'mother');

-- --------------------------------------------------------

--
-- Table structure for table `saccogroup`
--

DROP TABLE IF EXISTS `saccogroup`;
CREATE TABLE IF NOT EXISTS `saccogroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupName` varchar(100) NOT NULL COMMENT 'Name of the group',
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp of creation',
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp at modification',
  `modifiedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modifiedBy` (`modifiedBy`),
  KEY `createdBy` (`createdBy`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `saccogroup`
--

INSERT INTO `saccogroup` (`id`, `groupName`, `description`, `active`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'St Francis Bwaise', 'St Francis Bwaise group', 1, 1498490848, 1, '2017-06-26 15:29:57', 1),
(2, 'Yesu Afuga Nabweru', 'Yesu Afuga Nabweru group', 1, 1498491029, 1, '2017-06-26 15:31:36', 1);

-- --------------------------------------------------------

--
-- Table structure for table `securitytype`
--

DROP TABLE IF EXISTS `securitytype`;
CREATE TABLE IF NOT EXISTS `securitytype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(156) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `securitytype`
--

INSERT INTO `securitytype` (`id`, `name`, `description`) VALUES
(1, 'Land Title', 'This will be the land title used as security on the loan'),
(2, 'Laptop', 'Laptop security'),
(3, 'Car Log Book', 'Log book details'),
(4, 'Salary ATM Card', 'Salary atm card');

-- --------------------------------------------------------

--
-- Table structure for table `shares`
--

DROP TABLE IF EXISTS `shares`;
CREATE TABLE IF NOT EXISTS `shares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberId` int(11) NOT NULL,
  `noShares` int(10) UNSIGNED NOT NULL COMMENT 'No of shares',
  `amount` decimal(12,2) NOT NULL,
  `datePaid` int(11) NOT NULL,
  `recordedBy` int(11) NOT NULL,
  `paid_by` varchar(100) NOT NULL,
  `share_rate` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_date` (`datePaid`),
  KEY `person_id` (`memberId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `share_rate`
--

DROP TABLE IF EXISTS `share_rate`;
CREATE TABLE IF NOT EXISTS `share_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(15,2) NOT NULL,
  `date_added` int(11) NOT NULL,
  `added_by` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `share_rate`
--

INSERT INTO `share_rate` (`id`, `amount`, `date_added`, `added_by`) VALUES
(1, '200000.00', 1498486688, 1);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
CREATE TABLE IF NOT EXISTS `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personId` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `username` varchar(120) NOT NULL,
  `password` text NOT NULL,
  `access_level` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `date_added` date NOT NULL,
  `added_by` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `person_id` (`personId`),
  KEY `branch_id` (`branch_id`),
  KEY `person_id_2` (`personId`),
  KEY `person_id_3` (`personId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `personId`, `branch_id`, `position_id`, `username`, `password`, `access_level`, `status`, `start_date`, `end_date`, `date_added`, `added_by`) VALUES
(1, 1, 6, 1, 'platin', '807c1c8ea54c81e6167a19275211b2a3', 1, 1, '0000-00-00', NULL, '2016-11-16', '1'),
(2, 43, 6, 2, 'sara', '9e11830101b6b723ae3fb11e660a2123', 0, 0, '0000-00-00', NULL, '2017-07-04', '1'),
(3, 44, 6, 3, 'cissy', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-07-25', '1'),
(4, 45, 6, 4, 'michael', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-08-11', '1'),
(5, 46, 6, 5, 'peter', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-08-11', '1'),
(6, 47, 6, 2, 'alfred', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-08-15', '1'),
(7, 48, 6, 7, 'joshua', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-09-20', '1');

-- --------------------------------------------------------

--
-- Table structure for table `staff_roles`
--

DROP TABLE IF EXISTS `staff_roles`;
CREATE TABLE IF NOT EXISTS `staff_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `staff_roles`
--

INSERT INTO `staff_roles` (`id`, `role_id`, `personId`) VALUES
(16, 1, 1),
(26, 2, 43),
(27, 3, 44),
(28, 4, 45),
(29, 5, 46),
(30, 2, 47),
(31, 7, 48);

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id`, `name`, `description`) VALUES
(1, 'Available ', ''),
(2, 'Taken ', '');

-- --------------------------------------------------------

--
-- Table structure for table `subcounty`
--

DROP TABLE IF EXISTS `subcounty`;
CREATE TABLE IF NOT EXISTS `subcounty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `county_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subcounty`
--

INSERT INTO `subcounty` (`id`, `name`, `county_id`) VALUES
(1, 'Kawempe', 1),
(2, 'Kawempe 2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

DROP TABLE IF EXISTS `subscription`;
CREATE TABLE IF NOT EXISTS `subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberId` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `subscriptionYear` year(4) NOT NULL,
  `receivedBy` int(11) NOT NULL,
  `datePaid` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff modifying the entry',
  PRIMARY KEY (`id`),
  KEY `person_id` (`memberId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`id`, `memberId`, `amount`, `subscriptionYear`, `receivedBy`, `datePaid`, `dateModified`, `modifiedBy`) VALUES
(1, 15, '20000.00', 2017, 48, 1505985644, '2017-09-21 09:23:17', 48),
(2, 0, '50000.00', 2017, 1, 1506669561, '2017-09-29 07:21:08', 1),
(3, 14, '50000.00', 2017, 1, 1506670204, '2017-09-29 07:30:14', 1);

-- --------------------------------------------------------

--
-- Table structure for table `systemaccesslogs`
--

DROP TABLE IF EXISTS `systemaccesslogs`;
CREATE TABLE IF NOT EXISTS `systemaccesslogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date_logged_in` datetime NOT NULL,
  `date_logged_out` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tax_rate_source`
--

DROP TABLE IF EXISTS `tax_rate_source`;
CREATE TABLE IF NOT EXISTS `tax_rate_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `taxRate` decimal(4,2) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Unix timestamp for the datetime of addition',
  `createdBy` int(11) NOT NULL COMMENT 'Reference to the staff that added this entry',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Unix timestamp for the datetime modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff that modified this entry',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `time_units`
--

DROP TABLE IF EXISTS `time_units`;
CREATE TABLE IF NOT EXISTS `time_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_unit` varbinary(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='Time units definitions';

--
-- Dumping data for table `time_units`
--

INSERT INTO `time_units` (`id`, `time_unit`) VALUES
(1, 0x444159),
(2, 0x5745454b),
(3, 0x4d4f4e5448);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
CREATE TABLE IF NOT EXISTS `transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_type` varchar(45) NOT NULL,
  `branch_number` varchar(45) NOT NULL,
  `personId` int(11) NOT NULL,
  `amount` varchar(45) NOT NULL,
  `amount_description` varchar(256) NOT NULL,
  `transacted_by` varchar(100) NOT NULL,
  `transaction_date` date NOT NULL,
  `approved_by` varchar(45) NOT NULL,
  `comments` text NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `person_id` (`personId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `transfer`
--

DROP TABLE IF EXISTS `transfer`;
CREATE TABLE IF NOT EXISTS `transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bank` int(11) NOT NULL,
  `deposited_from` int(11) NOT NULL,
  `from_bank_branch` int(11) NOT NULL,
  `from_branch` int(11) NOT NULL,
  `to_branch` int(11) NOT NULL,
  `account_number` varchar(100) NOT NULL,
  `amount` text NOT NULL,
  `transfered_by` int(11) NOT NULL,
  `transfer_date` date NOT NULL,
  `added_by` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `village`
--

DROP TABLE IF EXISTS `village`;
CREATE TABLE IF NOT EXISTS `village` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `parish_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `village`
--

INSERT INTO `village` (`id`, `name`, `parish_id`) VALUES
(1, 'Kawempe TC', 1),
(2, 'Kawempe Town', 2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
