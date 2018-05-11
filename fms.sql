-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 11, 2018 at 03:27 PM
-- Server version: 10.1.30-MariaDB
-- PHP Version: 7.2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
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
CREATE DEFINER=`buladde`@`localhost` PROCEDURE `exceeded_days` (IN `loans_id` INT, IN `loan_date` DATE, IN `cur_date` DATE, IN `exp_payback` DECIMAL(12,2), IN `loan_duration` INT, IN `loan_age` INT, OUT `no_days` INT)  READS SQL DATA
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
CREATE DEFINER=`buladde`@`localhost` FUNCTION `GetDueDate` (`disbursementDate` DATETIME, `installments` TINYINT, `time_unit` TINYINT, `repaymentFreq` TINYINT(1), `start_date` DATETIME, `end_date` DATETIME) RETURNS DATE NO SQL
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

CREATE DEFINER=`buladde`@`localhost` FUNCTION `getPeriodAspect` (`period` TINYINT(1)) RETURNS SMALLINT(5) UNSIGNED NO SQL
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

CREATE DEFINER=`buladde`@`localhost` FUNCTION `ImmediateDueDate` (`disbursementDate` DATETIME, `installments` TINYINT(2), `time_unit` TINYINT(1), `repaymentFreq` TINYINT(1), `end_date` DATETIME) RETURNS DATE NO SQL
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

CREATE TABLE `accesslevel` (
  `id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accesslevel`
--

INSERT INTO `accesslevel` (`id`, `name`, `description`, `active`) VALUES
(1, 'Administrator', 'Over all user of the system', 1),
(2, 'Loan Officers', 'General operating Staff', 1),
(3, 'Branch Managers', 'Manager of the organisation', 1),
(4, 'Branch Credit Committee', 'Executive commite member', 1),
(5, 'Management Credit Committee\r\n', NULL, 1),
(6, 'Executive board committe', NULL, 1),
(7, 'Accountant', 'Accountant to handle all finances', 1);

-- --------------------------------------------------------

--
-- Table structure for table `address_type`
--

CREATE TABLE `address_type` (
  `id` int(11) NOT NULL,
  `address_type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `id` int(11) NOT NULL,
  `branch_number` varchar(45) NOT NULL,
  `branch_name` varchar(150) NOT NULL,
  `physical_address` text NOT NULL,
  `office_phone` varchar(45) DEFAULT NULL,
  `postal_address` varchar(156) DEFAULT NULL,
  `email_address` varchar(156) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `branch_number`, `branch_name`, `physical_address`, `office_phone`, `postal_address`, `email_address`, `active`) VALUES
(1, '', 'Main Branch', 'Kampala Munganzirwaza', '(073) 000-0000', 'kampala', 'info@buladde.or.ug', 1);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account`
--

CREATE TABLE `deposit_account` (
  `id` int(11) UNSIGNED ZEROFILL NOT NULL,
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
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deposit_account`
--

INSERT INTO `deposit_account` (`id`, `account_no`, `depositProductId`, `recomDepositAmount`, `maxWithdrawalAmount`, `interestRate`, `openingBalance`, `termLength`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(00000000001, 'BFS0000000001', 2, '2000.00', '5000000.00', '0.00', '40000.00', 0, 1511264600, 4, 1511264600, 4),
(00000000002, 'BFS000000002', 2, '2000.00', '5000000.00', '0.00', '200000.00', 0, 1511428772, 1, 1511428772, 1),
(00000000003, 'BFS000000003', 2, '2000.00', '5000000.00', '0.00', '50000.00', 0, 1511434071, 1, 1511434071, 1),
(00000000004, 'BFS000000004', 2, '2000.00', '5000000.00', '0.00', '10000.00', 0, 1511434388, 1, 1511434388, 1),
(00000000005, 'BFS000000005', 2, '2000.00', '5000000.00', '0.00', '52000.00', 0, 1511444534, 1, 1511444534, 1),
(00000000006, 'BFS000000006', 2, '2000.00', '5000000.00', '0.00', '20000.00', 0, 1511444955, 7, 1511444955, 7),
(00000000007, 'BFS000000007', 2, '2000.00', '5000000.00', '0.00', '5000.00', 0, 1511450474, 7, 1511450474, 7),
(00000000008, 'BFS000000008', 2, '2000.00', '5000000.00', '0.00', '40000.00', 0, 1511781934, 7, 1511781934, 7),
(00000000009, 'BFS000000009', 2, '2000.00', '5000000.00', '0.00', '10000.00', 0, 1511957076, 7, 1511957076, 7),
(00000000010, 'BFS000000010', 2, '2000.00', '5000000.00', '0.00', '420000.00', 0, 1512649647, 7, 1512649647, 7),
(00000000011, 'BFS000000011', 2, '2000.00', '5000000.00', '0.00', '200000.00', 0, 1512650258, 7, 1512650258, 7),
(00000000012, 'BFS000000012', 2, '2000.00', '5000000.00', '0.00', '300000.00', 0, 1513595727, 1, 1513595727, 1),
(00000000013, 'BFS000000013', 2, '2000.00', '5000000.00', '0.00', '280000.00', 0, 1517832098, 7, 1517832098, 7),
(00000000014, 'BFS000000014', 2, '2000.00', '5000000.00', '0.00', '220000.00', 0, 1517833213, 7, 1517833213, 7),
(00000000015, 'BFS000000015', 2, '2000.00', '5000000.00', '0.00', '20000.00', 0, 1517833727, 7, 1517833727, 7),
(00000000016, 'BFS000000016', 2, '2000.00', '5000000.00', '0.00', '620000.00', 0, 1517837197, 7, 1517837197, 7),
(00000000017, 'BFS000000017', 2, '2000.00', '5000000.00', '0.00', '20000.00', 0, 1517837277, 7, 1517837277, 7),
(00000000018, 'BFS000000018', 2, '2000.00', '5000000.00', '0.00', '460000.00', 0, 1517841211, 7, 1517841211, 7),
(00000000019, 'BFS000000019', 2, '2000.00', '5000000.00', '0.00', '20000.00', 0, 1517842327, 7, 1517842327, 7),
(00000000020, 'BFS000000020', 2, '2000.00', '5000000.00', '0.00', '65000.00', 0, 1518166869, 7, 1518166869, 7),
(00000000021, 'BFS000000021', 2, '2000.00', '5000000.00', '0.00', '100000.00', 0, 1518166904, 7, 1518166904, 7),
(00000000022, 'BFS000000022', 2, '2000.00', '5000000.00', '0.00', '40000.00', 0, 1518516412, 7, 1518516412, 7),
(00000000023, 'BFS000000023', 2, '2000.00', '5000000.00', '0.00', '500000.00', 0, 1518517337, 7, 1518517337, 7),
(00000000024, 'BFS000000024', 2, '2000.00', '5000000.00', '0.00', '20000.00', 0, 1518677447, 7, 1518677447, 7),
(00000000025, 'BFS000000025', 2, '2000.00', '5000000.00', '0.00', '30000.00', 0, 1518682588, 7, 1518682588, 7),
(00000000026, 'BFS000000026', 2, '2000.00', '5000000.00', '0.00', '10000.00', 0, 1521180984, 7, 1521180984, 7);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account_fee`
--

CREATE TABLE `deposit_account_fee` (
  `id` int(11) NOT NULL,
  `depositProductFeeId` int(11) DEFAULT NULL,
  `depositAccountId` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Creation timestamp',
  `createdBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees that have been applied to the deposit account';

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account_transaction`
--

CREATE TABLE `deposit_account_transaction` (
  `id` int(11) NOT NULL,
  `depositAccountId` int(11) NOT NULL,
  `amount` decimal(19,2) NOT NULL,
  `comment` text NOT NULL,
  `transactionType` tinyint(1) NOT NULL,
  `transactedBy` int(11) NOT NULL COMMENT 'Officer inserting this record',
  `dateCreated` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deposit_account_transaction`
--

INSERT INTO `deposit_account_transaction` (`id`, `depositAccountId`, `amount`, `comment`, `transactionType`, `transactedBy`, `dateCreated`, `dateModified`, `modifiedBy`) VALUES
(1, 6, '70000.00', 'sara namatovu', 1, 7, 1511450736, '2017-11-23 15:25:36', 7),
(2, 2, '100000.00', 'lubanjwa fumusi', 1, 7, 1511450969, '2017-11-23 15:29:29', 7),
(3, 2, '294000.00', 'lubanjwa fumusi', 2, 7, 1511777745, '2017-11-27 10:15:45', 7),
(4, 3, '300000.00', 'busingye', 1, 7, 1512450779, '2017-12-05 05:12:59', 7),
(5, 12, '50000.00', '', 1, 7, 1513596120, '2017-12-18 11:22:00', 7),
(6, 7, '5000.00', 'nassozi', 2, 7, 1517838683, '2018-02-05 13:51:23', 7),
(7, 18, '460000.00', 'kalema', 2, 7, 1517841318, '2018-02-05 14:35:18', 7),
(8, 6, '290000.00', 'NAMATOVU', 1, 7, 1517846372, '2018-02-05 15:59:32', 7),
(9, 8, '95000.00', 'Sebunya', 1, 7, 1517848100, '2018-02-05 16:28:20', 7),
(10, 9, '20000.00', 'cabrine', 1, 7, 1517914872, '2018-02-06 11:01:12', 7);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product`
--

CREATE TABLE `deposit_product` (
  `id` int(11) NOT NULL,
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
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Deposit Products Table';

--
-- Dumping data for table `deposit_product`
--

INSERT INTO `deposit_product` (`id`, `productName`, `description`, `productType`, `availableTo`, `recommededDepositAmount`, `maxWithdrawalAmount`, `interestPaid`, `defaultInterestRate`, `minInterestRate`, `maxInterestRate`, `perNoOfDays`, `accountBalForCalcInterest`, `whenInterestIsPaid`, `daysInYear`, `applyWHTonInterest`, `defaultOpeningBal`, `minOpeningBal`, `maxOpeningBal`, `defaultTermLength`, `minTermLength`, `maxTermLength`, `termTimeUnit`, `allowArbitraryFees`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(2, 'FREE SAVINGS', 'SAVINGS WITHDRAW-ABLE AT ANY TIME ', 1, 3, '2000.00', '5000000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '2000.00', '2000.00', '0.00', 0, 0, 0, 1, 0, 1510036235, 1, 1510036235, 0);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product_fee`
--

CREATE TABLE `deposit_product_fee` (
  `id` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  `feeName` varchar(150) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `chargeTrigger` tinyint(2) NOT NULL,
  `dateApplicationMethod` tinyint(1) DEFAULT NULL COMMENT '1-Manual, 2-Monthly',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a deposit product';

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product_feen`
--

CREATE TABLE `deposit_product_feen` (
  `id` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  `depositProductId` int(11) NOT NULL,
  `depositProductFeeId` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a given deposit product';

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product_type`
--

CREATE TABLE `deposit_product_type` (
  `id` int(11) NOT NULL,
  `typeName` varchar(50) NOT NULL COMMENT 'Name of the product type',
  `description` varchar(250) NOT NULL COMMENT 'Description of product',
  `dateCreated` int(11) NOT NULL COMMENT 'Record insertion timestamp',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record modification timestamp',
  `createdBy` int(11) NOT NULL COMMENT 'staff that inserted record',
  `modifiedBy` int(11) NOT NULL COMMENT 'User modifying entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deposit_product_type`
--

INSERT INTO `deposit_product_type` (`id`, `typeName`, `description`, `dateCreated`, `dateModified`, `createdBy`, `modifiedBy`) VALUES
(1, 'Regular Savings', 'A basic savings account where a client may perform regular deposit and withdrawals and accrue interest over time', 280092020, '0000-00-00 00:00:00', 1, 1),
(2, 'Fixed Deposit ', 'clients make deposits to open the account and can only withdraw the money after an established period of time. The account can\'t be closed or withdrawn before the end of that period.', 280092020, '0000-00-00 00:00:00', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `expense`
--

CREATE TABLE `expense` (
  `id` int(11) NOT NULL,
  `expenseName` text NOT NULL,
  `staff` int(11) NOT NULL,
  `expenseType` tinyint(4) NOT NULL,
  `amountUsed` decimal(15,2) NOT NULL,
  `amountDescription` text NOT NULL,
  `createdBy` int(11) NOT NULL COMMENT 'ID of staff who added the record',
  `expenseDate` int(11) NOT NULL COMMENT 'Timestamp for when this record was added',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp for when this record was added',
  `modifiedBy` int(11) NOT NULL COMMENT 'Staff who modified the record',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `expensetypes`
--

CREATE TABLE `expensetypes` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `expensetypes`
--

INSERT INTO `expensetypes` (`id`, `name`, `description`, `active`) VALUES
(1, 'Air Time', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `fee_type`
--

CREATE TABLE `fee_type` (
  `id` int(11) NOT NULL,
  `description` varchar(100) NOT NULL,
  `feeTypeName` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Type of the fee to be charged';

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

CREATE TABLE `gender` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `group_deposit_account` (
  `id` int(11) NOT NULL,
  `saccoGroupId` int(11) NOT NULL,
  `depositAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Holds a reference to the accounts owned by a sacco group';

-- --------------------------------------------------------

--
-- Table structure for table `group_loan_account`
--

CREATE TABLE `group_loan_account` (
  `id` int(11) NOT NULL,
  `saccoGroupId` int(11) NOT NULL COMMENT 'Refence key to the saccoGroup',
  `loanProductId` int(11) DEFAULT NULL COMMENT 'Reference key to the loan account',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_loan_account`
--

INSERT INTO `group_loan_account` (`id`, `saccoGroupId`, `loanProductId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 3, 1511265652, 3, '2017-11-21 12:00:52', 3),
(2, 2, 3, 1517983544, 8, '2018-02-07 06:05:44', 8),
(3, 3, 3, 1523710648, 8, '2018-04-14 12:57:28', 8),
(4, 2, 3, 1524131909, 1, '2018-04-19 09:58:29', 1),
(5, 2, 6, 1524133564, 1, '2018-04-19 10:26:04', 1),
(6, 1, 6, 1525859524, 1, '2018-05-09 09:52:04', 1),
(7, 1, 6, 1525929174, 1, '2018-05-10 05:12:54', 1),
(8, 5, 6, 1525929674, 1, '2018-05-10 05:21:14', 1),
(9, 5, 6, 1525930573, 1, '2018-05-10 05:36:13', 1),
(10, 5, 1, 1525933884, 1, '2018-05-10 06:31:24', 1),
(11, 5, 1, 1525933905, 1, '2018-05-10 06:31:45', 1),
(12, 1, 1, 1525935560, 1, '2018-05-10 06:59:20', 1),
(13, 1, 1, 1525935669, 1, '2018-05-10 07:01:09', 1),
(14, 5, 1, 1526025517, 1, '2018-05-11 07:58:37', 1),
(15, 3, 6, 1526040172, 1, '2018-05-11 12:02:52', 1),
(16, 3, 6, 1526043658, 1, '2018-05-11 13:00:58', 1);

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_members`
--

INSERT INTO `group_members` (`id`, `memberId`, `groupId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 650, 1, 1511265446, 739, '2017-11-21 11:59:35', 739),
(2, 99, 1, 1511265446, 739, '2017-11-21 11:59:35', 739),
(3, 389, 1, 1511265446, 739, '2017-11-21 11:59:35', 739),
(4, 380, 1, 1511265446, 739, '2017-11-21 11:59:35', 739),
(5, 484, 2, 1517983135, 794, '2018-02-07 06:02:38', 794),
(6, 15, 2, 1517983135, 794, '2018-02-07 06:02:39', 794),
(7, 624, 2, 1517983135, 794, '2018-02-07 06:02:39', 794),
(8, 418, 2, 1517983135, 794, '2018-02-07 06:02:39', 794),
(9, 663, 2, 1517983135, 794, '2018-02-07 06:02:39', 794),
(10, 249, 3, 1523710491, 794, '2018-04-14 12:56:23', 794),
(11, 8, 3, 1523710491, 794, '2018-04-14 12:56:23', 794),
(12, 9, 3, 1523710491, 794, '2018-04-14 12:56:23', 794),
(13, 13, 3, 1523710491, 794, '2018-04-14 12:56:23', 794),
(17, 883, 5, 1525929303, 737, '2018-05-10 05:17:26', 737),
(18, 835, 5, 1525929303, 737, '2018-05-10 05:17:26', 737),
(19, 9, 5, 1525929303, 737, '2018-05-10 05:17:26', 737),
(20, 13, 5, 1525929303, 737, '2018-05-10 05:17:26', 737);

-- --------------------------------------------------------

--
-- Table structure for table `guarantor`
--

CREATE TABLE `guarantor` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL COMMENT 'Fk reference to member Id',
  `loanAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `id_card_types`
--

CREATE TABLE `id_card_types` (
  `id` int(11) NOT NULL,
  `id_type` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `id_card_types`
--

INSERT INTO `id_card_types` (`id`, `id_type`, `description`, `active`) VALUES
(1, 'National Id', 'National identification Number', 1),
(3, 'Passport', 'Passport of the country one was bone', 1),
(4, 'Driving Permit', 'Valid Driving Permit', 1),
(5, 'L.C Card', 'Local Council Card or Letter', 1);

-- --------------------------------------------------------

--
-- Table structure for table `income`
--

CREATE TABLE `income` (
  `id` int(11) NOT NULL,
  `incomeSource` int(11) NOT NULL COMMENT 'ID for the income type',
  `amount` decimal(15,2) NOT NULL,
  `dateAdded` int(11) NOT NULL COMMENT 'Timestamp for when record was captured',
  `addedBy` int(11) NOT NULL COMMENT 'ID of the staff who added the income',
  `description` text NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp for when this record was modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'ID of staff who modified the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `income_sources`
--

CREATE TABLE `income_sources` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `income_sources`
--

INSERT INTO `income_sources` (`id`, `name`, `description`, `active`) VALUES
(1, 'Kingdom Donation', 'kingdom Donations', 1),
(2, 'Government Grant', 'government grants', 1);

-- --------------------------------------------------------

--
-- Table structure for table `individual_type`
--

CREATE TABLE `individual_type` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `individual_type`
--

INSERT INTO `individual_type` (`id`, `name`, `description`, `active`) VALUES
(1, 'Member Only', 'Will only be a member without shares', 1),
(2, 'Member and Share Holder', 'Member and Has Shares', 1),
(3, 'Member and Share Holder1', 'Member and Has Shares', 0);

-- --------------------------------------------------------

--
-- Table structure for table `loan_account`
--

CREATE TABLE `loan_account` (
  `id` int(11) UNSIGNED ZEROFILL NOT NULL,
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
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Accounts for the loans given out';

--
-- Dumping data for table `loan_account`
--

INSERT INTO `loan_account` (`id`, `loanNo`, `branch_id`, `memberId`, `groupLoanAccountId`, `status`, `loanProductId`, `requestedAmount`, `applicationDate`, `disbursedAmount`, `disbursementDate`, `disbursementNotes`, `interestRate`, `offSetPeriod`, `gracePeriod`, `repaymentsFrequency`, `repaymentsMadeEvery`, `installments`, `penaltyCalculationMethodId`, `penaltyTolerancePeriod`, `penaltyRateChargedPer`, `penaltyRate`, `linkToDepositAccount`, `comments`, `amountApproved`, `approvalDate`, `approvedBy`, `approvalNotes`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(00000000001, 'L1711164723', 1, 658, NULL, 5, 1, '1000000.00', 1510825643, '1000000.00', 1524114353, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'He is a teacher at entebbe international high school,has a canteen business in the school,and runs a mobile money business in abayita ababiri market', '1000000.00', 1524052874, 9, '1m for 6mths', 3, 1510825643, 3, '2018-04-19 05:05:53'),
(00000000002, 'L1711213606', 1, 742, NULL, 5, 2, '400000.00', 1510572966, '400000.00', 1524114477, NULL, '120.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'the client has 2 rental units in Namugongo and works as a store keeper at a construction site with a monthly wage of 350,000/=', '400000.00', 1524052470, 9, '400,000 at 10%pmth for 1 month', 3, 1511264166, 3, '2018-04-19 05:07:57'),
(00000000003, 'L1711210714', 1, 650, 1, 3, 3, '300000.00', 1511179634, NULL, NULL, NULL, '30.00', 7, 0, 1, 2, 12, NULL, NULL, NULL, NULL, 0, 'He operate a mechanic business in lweza and self employed.', '300000.00', 1511267519, 6, 'she operates a mechanics workshop', 3, 1511266034, 3, '2017-11-21 12:31:59'),
(00000000004, 'L1711210853', 1, 99, 1, 3, 3, '200000.00', 1511179733, NULL, NULL, NULL, '30.00', 7, 0, 1, 2, 12, NULL, NULL, NULL, NULL, 0, 'Operates a restaurant in lweza and sales spare parts', '200000.00', 1511267490, 6, 'she operates a spare parts and local restaurant', 3, 1511266133, 3, '2017-11-21 12:31:30'),
(00000000005, 'L1711211030', 1, 389, 1, 3, 3, '300000.00', 1511179830, NULL, NULL, NULL, '30.00', 7, 0, 1, 2, 12, NULL, NULL, NULL, NULL, 0, 'Owns a poultry farm in Lweza', '300000.00', 1511267450, 6, 'she operates a poultry business and 300,000 was approved', 3, 1511266230, 3, '2017-11-21 12:30:50'),
(00000000006, 'L1711211158', 1, 380, 1, 3, 3, '200000.00', 1511179918, NULL, NULL, NULL, '30.00', 7, 0, 1, 2, 12, NULL, NULL, NULL, NULL, 0, 'Permanent resident of Lweza and has charcoal business.', '200000.00', 1511267410, 6, 'she operates a charcoal business', 3, 1511266318, 3, '2017-11-21 12:30:10'),
(00000000007, 'L1711223646', 1, 743, NULL, -1, 1, '2500000.00', 1511159806, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, 'He works at Kabojja Junior school and he is a parmanent employee earning a monthly salary of 634,250/= with monthly allowances of 1,160,000/=.\r\nHas pledged securities of fridge,TV,sofa chairs,sideboard', '2500000.00', 1524122632, 10, 'rejected', 3, 1511332606, 3, '2018-04-19 07:23:52'),
(00000000008, 'L1711293037', 1, 187, NULL, 12, 1, '500000.00', 1511955037, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 5, NULL, NULL, NULL, NULL, 0, 'She wants this loan to facilitate her acquire more materialto make bitengi for the festive season.she currently has less stockt to give choiceof selection for her ustomers.', '500000.00', 1523852326, 1, 'reffered for re application', 3, 1511955037, 3, '2018-04-16 04:18:46'),
(00000000009, 'L1711293057', 1, 187, NULL, -1, 1, '500000.00', 1511955057, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 5, NULL, NULL, NULL, NULL, 0, 'She wants this loan to facilitate her acquire more materialto make bitengi for the festive season.she currently has less stockt to give choiceof selection for her ustomers.', '500000.00', 1524037458, 6, 'its 500,000 for 6mths', 3, 1511955057, 3, '2018-04-18 07:44:18'),
(00000000010, 'L1711290303', 1, 473, NULL, 12, 4, '6200000.00', 1508414583, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, 'The purpose of the loan is for home construction.', '6200000.00', 1523852857, 1, 'recommended 6200000 for 24months', 3, 1511956983, 3, '2018-04-16 04:27:37'),
(00000000011, 'L1711290922', 1, 473, NULL, 3, 4, '6200000.00', 1508414962, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, 'He is a staff of BLB serving as a research and investigations officer. Earns a net salary of 2,523,555 monthly.The loan is to be paid in monthly for 2 years.Has got a letter of undertaking from his employer and pledged salary as security.Has further pledged savings with staff saving scheme as security in case of default', '6200000.00', 1524037339, 6, 'recommended 6.2m for 24mths', 3, 1511957362, 3, '2018-04-18 07:42:19'),
(00000000012, 'L1711292257', 1, 473, NULL, 3, 4, '6200000.00', 1511958177, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, 'He is a staff of BLB serving as a research and investigations officer.Net monthly salary is 2,523,555/-Loan has been undertaken by employer in case of default', '6200000.00', 1512031881, 6, 'Client is employed with BLB net take home is 2,523,555/= a loan 0f 6.2m is recommmended for 24 months with a monthly instalment of 387,500/ per month', 3, 1511958177, 3, '2017-11-30 08:51:21'),
(00000000013, 'L1801245728', 1, 769, NULL, -1, 2, '1000000.00', 1516798648, NULL, NULL, NULL, '10.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'client is applying for an emergency loan to re capitalise her business of the shop', '1000000.00', 1516858826, 6, 'loan interest terms are wrong', 3, 1516798648, 3, '2018-01-25 05:40:26'),
(00000000014, 'L1801255925', 1, 781, NULL, 12, 1, '5621500.00', 1516856365, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, 'Loan applied with a purpose of acquiring a akyaapa mungalo.', '5621500.00', 1525938670, 6, 'not recommended', 3, 1516856365, 3, '2018-05-10 07:51:10'),
(00000000015, 'L1801252607', 1, 786, NULL, 12, 1, '23187400.00', 1516857967, NULL, NULL, NULL, '24.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, 'This is a loan to facilitate her to acquire a Kyaapa mungalo Loan.', '23187400.00', 1525938655, 6, 'not recommended', 3, 1516857967, 3, '2018-05-10 07:50:55'),
(00000000016, 'L1801253340', 1, 455, NULL, 12, 5, '5000000.00', 1516858420, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, 'Loan for house construction', '5000000.00', 1525938640, 6, 'not recommended', 3, 1516858420, 3, '2018-05-10 07:50:40'),
(00000000017, 'L1801254858', 1, 769, NULL, 5, 1, '1000000.00', 1516859338, '1000000.00', 1517589062, '1,000,000', '120.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'Emmergency loan to recapitalise her ratail business shop in Namuwongo.', '1000000.00', 1517588779, 9, 'emergency loan of 1m for 1 month was approved', 3, 1516859338, 3, '2018-02-02 16:31:02'),
(00000000018, 'L1801254400', 1, 68, NULL, 12, 1, '30000000.00', 1516697040, NULL, NULL, NULL, '0.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'I recommend him for 20,000,000/= ', '30000000.00', 1525938739, 6, 'not recommended', 8, 1516869840, 8, '2018-05-10 07:52:19'),
(00000000019, 'L1801272643', 1, 790, NULL, -1, 1, '5000000.00', 1516962403, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 16, NULL, NULL, NULL, NULL, 0, 'a loan of 5m for 16 months recommended', '0.00', 1518021669, 6, 'Recalculate interest', 1, 1517048803, 1, '2018-02-07 16:41:09'),
(00000000020, 'L1801274429', 1, 410, NULL, 5, 1, '800000.00', 1516963469, '400000.00', 1517589099, '400,000', '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, ' i recommend her for a loan of 800,000 payable in 6 months', '400000.00', 1517588685, 9, 'Client\'s business is small and since she is adding working capital she takes first that', 8, 1517049869, 8, '2018-02-02 16:31:39'),
(00000000021, 'L1802075739', 1, 795, NULL, 12, 1, '12677000.00', 1517986659, NULL, NULL, NULL, '90.00', 30, 0, 1, 3, 30, NULL, NULL, NULL, NULL, 0, 'RECOMMENDED', '12677000.00', 1525938627, 6, 'not recommended', 8, 1517986659, 8, '2018-05-10 07:50:27'),
(00000000022, 'L1803060817', 1, 818, NULL, -1, 1, '1200000.00', 1520338097, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'Loan for clearing school dues for his daughter.', '1200000.00', 1520342920, 6, 'please apply for 1m for 5mths', 3, 1520338097, 3, '2018-03-06 13:28:40'),
(00000000023, 'L1803062038', 1, 102, NULL, -1, 1, '5000000.00', 1520338838, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, 'Loan for personal development', '5000000.00', 1523714035, 6, 'recommended', 3, 1520338838, 3, '2018-04-14 13:53:55'),
(00000000024, 'L1803063757', 1, 818, NULL, 5, 1, '1000000.00', 1520343477, '1000000.00', 1520345125, '10,000', '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'Loan for clearing school dues for his daughter.', '1000000.00', 1520345046, 9, 'approved', 3, 1520343477, 3, '2018-03-06 14:05:25'),
(00000000025, 'L1803210842', 1, 102, NULL, 5, 1, '2000000.00', 1521630522, '2000000.00', 1522916113, NULL, '30.00', 30, 0, 1, 3, 8, NULL, NULL, NULL, NULL, 0, 'loan for home improvement ', '2000000.00', 1522915727, 10, '2,000,000 for a period of 8months approved', 3, 1521630522, 3, '2018-04-05 08:15:13'),
(00000000026, 'L1803213706', 1, 31, NULL, 5, 1, '3000000.00', 1521632226, '2000000.00', 1523714438, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, 'loan to buy poultry maize brand for since prices are still low.Has 300 layers ,coffee and redpepper', '2000000.00', 1522915996, 10, '2,000,000 for a period of 8months approved', 3, 1521632226, 3, '2018-04-14 14:00:38'),
(00000000027, 'L1803214420', 1, 604, NULL, 5, 1, '500000.00', 1521632660, '500000.00', 1522906850, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'loan to facilitate her make more liquid soap for business', '500000.00', 1522906667, 9, '500,000 for 6months is approved', 3, 1521632660, 3, '2018-04-05 05:40:50'),
(00000000028, 'L1803215201', 1, 862, NULL, 12, 1, '1000000.00', 1521633121, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'loan to buy poultry maize brand since prices are still low.has 350 layers,coffee farmer', '1000000.00', 1522915394, 6, 'to be re applied', 3, 1521633121, 3, '2018-04-05 08:03:14'),
(00000000029, 'L1803211531', 1, 23, NULL, 5, 1, '1000000.00', 1521648931, '1000000.00', 1522906810, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'I recommend client for a loan of 1m payable in 6months', '1000000.00', 1522906616, 9, '1m for 6months is approved', 8, 1521648931, 8, '2018-04-05 05:40:10'),
(00000000030, 'L1803223721', 1, 573, NULL, 5, 1, '2000000.00', 1482223041, '2000000.00', 1521708670, '20,000', '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, 'client recommended for 2m', '2000000.00', 1521708594, 10, 'A loan of 2m shs to be serviced in 12 months approved', 8, 1521707841, 8, '2018-03-22 08:51:10'),
(00000000031, 'L1804055755', 1, 898, NULL, -1, 1, '500000.00', 1522922275, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, 'recommended for a loan of 500,000 payable in 6mths', '500000.00', 1523426104, 6, 're apply', 8, 1522922275, 8, '2018-04-11 05:55:04'),
(00000000032, 'L1804144400', 1, 441, NULL, 5, 1, '700000.00', 1481888640, '700000.00', 1523706792, '10,000', '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, 'a loan of 700,000 recommended for 4months', '700000.00', 1523706702, 9, '700,000 appvd for 4mths', 8, 1523706240, 8, '2018-04-14 11:53:12'),
(00000000033, 'L1804144938', 1, 414, NULL, 5, 2, '500000.00', 1482414578, '500000.00', 1523714334, NULL, '60.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, 'recommended', '500000.00', 1523714270, 9, 'Appvd', 1, 1523713778, 1, '2018-04-14 13:58:54'),
(00000000034, 'L1804160719', 1, 614, NULL, -1, 1, '1500000.00', 1482379639, NULL, NULL, NULL, '34.00', 30, 0, 1, 3, 3, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1524113815, 10, 're apply', 1, 1523851639, 1, '2018-04-19 04:56:55'),
(00000000035, 'L1804163118', 1, 465, NULL, 5, 1, '500000.00', 1482381078, '500000.00', 1524114396, NULL, '36.00', 30, 0, 1, 3, 5, NULL, NULL, NULL, NULL, 0, 'recommended', '500000.00', 1524052400, 9, '500,000 for 5months', 1, 1523853078, 1, '2018-04-19 05:06:36'),
(00000000036, 'L1804182750', 1, 414, NULL, 5, 1, '500000.00', 1524040070, '500000.00', 1524114375, NULL, '36.00', 30, 0, 1, 3, 5, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1524052350, 9, '500,000 for 5months', 1, 1524040070, 1, '2018-04-19 05:06:15'),
(00000000037, 'L1804190017', 1, 885, NULL, 5, 1, '1500000.00', 1524114017, '1500000.00', 1524114417, NULL, '36.00', 30, 0, 1, 3, 3, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1524114228, 10, '1.5m for 3mths', 1, 1524114017, 1, '2018-04-19 05:06:57'),
(00000000038, 'L1804193034', 1, 682, NULL, 5, 4, '4500000.00', 1490851834, '4500000.00', 1524386939, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '4500000.00', 1524122598, 10, '4,500,000 for 12mths', 1, 1524115834, 1, '2018-04-22 08:48:59'),
(00000000039, 'L1804193205', 1, 857, NULL, 5, 1, '700000.00', 1490851925, '700000.00', 1524386920, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '700000.00', 1524122182, 9, '700,000 for 4months', 1, 1524115925, 1, '2018-04-22 08:48:40'),
(00000000040, 'L1804194331', 1, 747, NULL, 5, 1, '1000000.00', 1491975811, '1000000.00', 1524386575, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524122270, 9, '1,000,000 for 12mths', 1, 1524116611, 1, '2018-04-22 08:42:55'),
(00000000041, 'L1804194506', 1, 837, NULL, 5, 1, '1000000.00', 1492062306, '1000000.00', 1524386818, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524122311, 9, '1,000,000 for 6mths', 1, 1524116706, 1, '2018-04-22 08:46:58'),
(00000000042, 'L1804191038', 1, 18, NULL, 5, 1, '1500000.00', 1492755038, '1500000.00', 1524386786, NULL, '30.00', 30, 0, 1, 3, 10, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1524122576, 10, '1,500,000 for 10mths', 1, 1524118238, 1, '2018-04-22 08:46:26'),
(00000000043, 'L1804191633', 1, 14, NULL, 5, 1, '800000.00', 1494483393, '800000.00', 1524386611, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '800000.00', 1524122382, 9, '1,000,000 for 6mths', 1, 1524118593, 1, '2018-04-22 08:43:31'),
(00000000044, 'L1804192306', 1, 20, NULL, 5, 1, '1000000.00', 1494483786, '1000000.00', 1524386719, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524122407, 9, '1,000,000 for 4mths', 1, 1524118986, 1, '2018-04-22 08:45:19'),
(00000000045, 'L1804193053', 1, 378, NULL, 5, 1, '1000000.00', 1494484253, '1000000.00', 1524386768, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524122422, 9, '1,000,000 for 4mths', 1, 1524119453, 1, '2018-04-22 08:46:08'),
(00000000046, 'L1804193949', 1, 282, NULL, 5, 1, '1000000.00', 1495694389, '1000000.00', 1524386805, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524122454, 9, '1,000,000 for 6mths', 1, 1524119989, 1, '2018-04-22 08:46:45'),
(00000000047, 'L1804192922', 1, 551, NULL, 4, 1, '5000000.00', 1495783762, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '5000000.00', 1524388506, 10, '500,000 for 12months', 1, 1524122962, 1, '2018-04-22 09:15:06'),
(00000000048, 'L1804194241', 1, 508, NULL, 4, 1, '1000000.00', 1495784561, NULL, NULL, NULL, '36.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524387601, 9, '1,000,000 for 4mths', 1, 1524123761, 1, '2018-04-22 09:00:01'),
(00000000049, 'L1804192421', 1, 184, NULL, 4, 1, '1500000.00', 1496046261, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1524388252, 10, '1,500,000 for 6months', 1, 1524126261, 1, '2018-04-22 09:10:52'),
(00000000050, 'L1804192828', 1, 889, NULL, 4, 1, '300000.00', 1496046508, NULL, NULL, NULL, '120.00', 30, 0, 1, 3, 3, NULL, NULL, NULL, NULL, 0, '', '300000.00', 1524387568, 9, '300,000 for 3mths', 1, 1524126508, 1, '2018-04-22 08:59:28'),
(00000000051, 'L1804191519', 1, 484, 2, 12, 3, '1000000.00', 1498731319, NULL, NULL, NULL, '30.00', 7, 0, 1, 2, 24, NULL, NULL, NULL, NULL, 0, '', '0.00', 1524133073, 1, 'reapply', 1, 1524132919, 1, '2018-04-19 10:17:53'),
(00000000052, 'L1804192920', 1, 852, NULL, 4, 1, '700000.00', 1496658560, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '700000.00', 1524387533, 9, '700,000 for 6mths', 1, 1524133760, 1, '2018-04-22 08:58:53'),
(00000000053, 'L1804193710', 1, 293, NULL, 4, 1, '1000000.00', 1496918230, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524387499, 9, '1,000,000 for 6mths', 1, 1524134230, 1, '2018-04-22 08:58:19'),
(00000000054, 'L1804193809', 1, 266, NULL, 4, 1, '800000.00', 1496921889, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '800000.00', 1524387473, 9, '800,000 for 6mths', 1, 1524137889, 1, '2018-04-22 08:57:53'),
(00000000055, 'L1804190418', 1, 343, NULL, 4, 1, '250000.00', 1496923458, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '250000.00', 1524387343, 9, '250,000 for 6mths', 1, 1524139458, 1, '2018-04-22 08:55:43'),
(00000000056, 'L1804191312', 1, 290, NULL, 4, 1, '500000.00', 1497615192, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1524387307, 9, '500,000 for 6mths', 1, 1524139992, 1, '2018-04-22 08:55:07'),
(00000000057, 'L1804202238', 1, 139, NULL, 4, 1, '300000.00', 1497594158, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '300000.00', 1525965801, 9, '300,000 for 6mths', 1, 1524205358, 1, '2018-05-10 15:23:21'),
(00000000058, 'L1804202846', 1, 29, NULL, 4, 1, '500000.00', 1497594526, NULL, NULL, NULL, '36.00', 30, 0, 1, 3, 5, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525965775, 9, '500,000 for 5mths', 1, 1524205726, 1, '2018-05-10 15:22:55'),
(00000000059, 'L1804203340', 1, 271, NULL, 4, 1, '300000.00', 1497854020, NULL, NULL, NULL, '120.00', 30, 0, 1, 3, 2, NULL, NULL, NULL, NULL, 0, '', '300000.00', 1525965509, 1, '300,000 for 2mths recommended', 1, 1524206020, 1, '2018-05-10 15:18:29'),
(00000000060, 'L1804224055', 1, 129, NULL, 4, 1, '1600000.00', 1498124455, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '1600000.00', 1526026902, 10, '1.6m recommended for 12mths', 1, 1524390055, 1, '2018-05-11 08:21:42'),
(00000000061, 'L1804224831', 1, 884, NULL, 4, 1, '2000000.00', 1498643311, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '2000000.00', 1526026867, 10, '2m recommended for 4mths', 1, 1524390511, 1, '2018-05-11 08:21:07'),
(00000000062, 'L1804225153', 1, 543, NULL, 12, 1, '1000000.00', 1498902713, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 9, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524390768, 1, '2,000,000 for 4mths', 1, 1524390713, 1, '2018-04-22 09:52:48'),
(00000000063, 'L1804225346', 1, 543, NULL, 4, 1, '1000000.00', 1498902826, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525963467, 9, '1,000,000 for 12mths recommended', 1, 1524390826, 1, '2018-05-10 14:44:27'),
(00000000064, 'L1804225916', 1, 521, NULL, 4, 1, '2015000.00', 1499162356, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '2015000.00', 1526026789, 10, '2.015m recommended for 12mths', 1, 1524391156, 1, '2018-05-11 08:19:49'),
(00000000065, 'L1804221534', 1, 549, NULL, 12, 1, '3500000.00', 1499940934, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '3500000.00', 1524392336, 1, '2,015,000 for 12mths', 1, 1524392134, 1, '2018-04-22 10:18:56'),
(00000000066, 'L1804221951', 1, 549, NULL, 12, 1, '3500000.00', 1499941191, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '3500000.00', 1524392434, 1, '2,015,000 for 12mths', 1, 1524392391, 1, '2018-04-22 10:20:34'),
(00000000067, 'L1804222223', 1, 549, NULL, 4, 1, '3500000.00', 1499941343, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 8, NULL, NULL, NULL, NULL, 0, '', '3500000.00', 1526026744, 10, '3.5m recommended for 8mths', 1, 1524392543, 1, '2018-05-11 08:19:04'),
(00000000068, 'L1804234606', 1, 520, NULL, 3, 1, '8500000.00', 1500615966, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '8500000.00', 1524476815, 6, '8,500,000 for 12mths recommended', 1, 1524462366, 1, '2018-04-23 09:46:55'),
(00000000069, 'L1804233653', 1, 452, NULL, 12, 1, '1000000.00', 1501144613, NULL, NULL, NULL, '999.99', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1524472671, 1, 'wrong interest terms', 1, 1524472613, 1, '2018-04-23 08:37:51'),
(00000000070, 'L1804233947', 1, 452, NULL, 4, 1, '1000000.00', 1501144787, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525963037, 9, '1,000,000 for 6mths recommended', 1, 1524472787, 1, '2018-05-10 14:37:17'),
(00000000071, 'L1804234335', 1, 102, NULL, 4, 1, '2000000.00', 1501231415, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '2000000.00', 1526026585, 10, '2m recommended for 6mths', 1, 1524473015, 1, '2018-05-11 08:16:25'),
(00000000072, 'L1804234715', 1, 465, NULL, 4, 1, '1000000.00', 1501231635, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525963001, 9, '1,000,000 for 6mths recommended', 1, 1524473235, 1, '2018-05-10 14:36:41'),
(00000000073, 'L1804235813', 1, 293, NULL, 4, 1, '2000000.00', 1502359093, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '2000000.00', 1526026538, 10, '2m recommended for 6mths', 1, 1524477493, 1, '2018-05-11 08:15:38'),
(00000000074, 'L1804242347', 1, 322, NULL, 4, 1, '1500000.00', 1502688227, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 10, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1526026490, 10, '1.5m recommended for 10mths', 1, 1524547427, 1, '2018-05-11 08:14:50'),
(00000000075, 'L1804242908', 1, 563, NULL, 4, 1, '700000.00', 1502774948, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '700000.00', 1525962840, 9, '700,000 for 6mths recommended', 1, 1524547748, 1, '2018-05-10 14:34:00'),
(00000000076, 'L1804241006', 1, 411, NULL, 4, 1, '500000.00', 1502777406, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525962790, 9, '500,000 for 6mths recommended', 1, 1524550206, 1, '2018-05-10 14:33:10'),
(00000000077, 'L1804241338', 1, 233, NULL, 4, 1, '400000.00', 1502777618, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '400000.00', 1525962742, 9, '400,000 for 6mths recommended', 1, 1524550418, 1, '2018-05-10 14:32:22'),
(00000000078, 'L1804242120', 1, 151, NULL, 4, 1, '1000000.00', 1502950880, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525961992, 9, '1,000,000 for 6mths recommended', 1, 1524550880, 1, '2018-05-10 14:19:52'),
(00000000079, 'L1804264600', 1, 165, NULL, 4, 1, '1500000.00', 1503315960, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 20, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1526026466, 10, '1.5m recommended for 20mths', 1, 1524743160, 1, '2018-05-11 08:14:26'),
(00000000080, 'L1804261639', 1, 354, NULL, 4, 1, '500000.00', 1524744999, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525951019, 9, '500,000 for 6months', 1, 1524744999, 1, '2018-05-10 11:16:59'),
(00000000081, 'L1805020125', 1, 354, NULL, 4, 1, '500000.00', 1503381685, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525961967, 9, '500,000 for 6mths recommended', 1, 1525240885, 1, '2018-05-10 14:19:27'),
(00000000082, 'L1805020307', 1, 271, NULL, 4, 1, '500000.00', 1503554587, NULL, NULL, NULL, '60.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525961946, 9, '500,000 for 4mths recommended', 1, 1525240987, 1, '2018-05-10 14:19:06'),
(00000000083, 'L1805020551', 1, 261, NULL, 4, 1, '1000000.00', 1504591551, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525961914, 9, '1,000,000 for 6mths recommended', 1, 1525241151, 1, '2018-05-10 14:18:34'),
(00000000084, 'L1805021418', 1, 19, NULL, 4, 1, '1000000.00', 1504592058, NULL, NULL, NULL, '60.00', 30, 0, 1, 3, 2, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525961270, 9, '1,000,000 for 2mths recommended', 1, 1525241658, 1, '2018-05-10 14:07:50'),
(00000000085, 'L1805021628', 1, 631, NULL, 4, 1, '2500000.00', 1505110588, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '2500000.00', 1526026394, 10, '2.5m recommended for 12mths', 1, 1525241788, 1, '2018-05-11 08:13:14'),
(00000000086, 'L1805022210', 1, 612, NULL, 4, 1, '3000000.00', 1505974930, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 10, NULL, NULL, NULL, NULL, 0, '', '3000000.00', 1526026363, 10, '3m recommended for 10mths', 1, 1525242130, 1, '2018-05-11 08:12:43'),
(00000000087, 'L1805024025', 1, 31, NULL, 4, 1, '1000000.00', 1506588025, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525961162, 9, '1,000,000 for 6mths recommended', 1, 1525250425, 1, '2018-05-10 14:06:02'),
(00000000088, 'L1805025039', 1, 550, NULL, 4, 1, '2750000.00', 1506675039, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '2750000.00', 1526026279, 10, '2,750,000 recommended for 12mths', 1, 1525251039, 1, '2018-05-11 08:11:19'),
(00000000089, 'L1805022112', 1, 39, NULL, 4, 1, '800000.00', 1507022472, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 7, NULL, NULL, NULL, NULL, 0, '', '800000.00', 1525961070, 9, '800,000 for 7mths recommended', 1, 1525252872, 1, '2018-05-10 14:04:30'),
(00000000090, 'L1805023426', 1, 326, NULL, 4, 1, '3456200.00', 1507109666, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 10, NULL, NULL, NULL, NULL, 0, '', '3456200.00', 1526026241, 10, '3,456,200 recommended for 10mths', 1, 1525253666, 1, '2018-05-11 08:10:41'),
(00000000091, 'L1805025504', 1, 590, NULL, 4, 1, '1500000.00', 1507283704, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1526026169, 10, '1.5m recommended for 6mths', 1, 1525254904, 1, '2018-05-11 08:09:29'),
(00000000092, 'L1805020050', 1, 63, NULL, 4, 4, '4500000.00', 1507629650, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 9, NULL, NULL, NULL, NULL, 0, '', '4500000.00', 1526026119, 10, '4.5m recommended for 9mths', 1, 1525255250, 1, '2018-05-11 08:08:39'),
(00000000093, 'L1805021032', 1, 604, NULL, 4, 1, '400000.00', 1508148632, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '400000.00', 1525959240, 9, '400,000 for 1mth recommended', 1, 1525255832, 1, '2018-05-10 13:34:00'),
(00000000094, 'L1805021502', 1, 623, NULL, 3, 1, '6900000.00', 1508321702, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 15, NULL, NULL, NULL, NULL, 0, '', '6900000.00', 1525943752, 1, '6,900,000 recommended for 15months', 1, 1525256102, 1, '2018-05-10 09:15:52'),
(00000000095, 'L1805021821', 1, 42, NULL, 3, 1, '11900000.00', 1508408301, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 15, NULL, NULL, NULL, NULL, 0, '', '11900000.00', 1525943729, 1, '11,900,000 recommended for 15months', 1, 1525256301, 1, '2018-05-10 09:15:29'),
(00000000096, 'L1805022325', 1, 273, NULL, 4, 1, '2212480.00', 1508495005, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '2212480.00', 1526025674, 10, '2,212,480 recommended for 12mths', 1, 1525256605, 1, '2018-05-11 08:01:14'),
(00000000097, 'L1805032144', 1, 559, NULL, 4, 4, '2200000.00', 1509600104, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 10, NULL, NULL, NULL, NULL, 0, '', '2200000.00', 1526025568, 10, '2,200,000 recommended for 10mths', 1, 1525324904, 1, '2018-05-11 07:59:28'),
(00000000098, 'L1805032651', 1, 635, NULL, 4, 1, '1000000.00', 1509686811, NULL, NULL, NULL, '120.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525958837, 9, '1,000,000 for 1mth recommended', 1, 1525325211, 1, '2018-05-10 13:27:17'),
(00000000099, 'L1805034042', 1, 609, NULL, 4, 1, '300000.00', 1509716442, NULL, NULL, NULL, '60.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '300000.00', 1525958086, 9, '300,000 for 6mth recommended', 1, 1525354842, 1, '2018-05-10 13:14:46'),
(00000000100, 'L1805030110', 1, 658, NULL, 4, 1, '1000000.00', 1511190070, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525957636, 9, '1,000,000 for 6mth recommended', 1, 1525359670, 1, '2018-05-10 13:07:16'),
(00000000101, 'L1805031408', 1, 742, NULL, 12, 1, '1000000.00', 1511190848, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525360476, 1, '1m for 6mths', 1, 1525360448, 1, '2018-05-03 15:14:36'),
(00000000102, 'L1805031548', 1, 742, NULL, 4, 1, '400000.00', 1511190948, NULL, NULL, NULL, '120.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, '', '400000.00', 1525957579, 9, '400,000 for 1mth recommended', 1, 1525360548, 1, '2018-05-10 13:06:19'),
(00000000103, 'L1805032322', 1, 109, NULL, 4, 1, '4200000.00', 1511277802, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '4200000.00', 1526025415, 10, '4,200,000 recommended for 12mths', 1, 1525361002, 1, '2018-05-11 07:56:55'),
(00000000104, 'L1805032643', 1, 522, NULL, 3, 1, '5880000.00', 1511796403, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 18, NULL, NULL, NULL, NULL, 0, '', '5880000.00', 1525942886, 1, '5,880,000 recommended for 18mths', 1, 1525361203, 1, '2018-05-10 09:01:26'),
(00000000105, 'L1805033630', 1, 473, NULL, 3, 4, '6200000.00', 1511796990, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, '', '6200000.00', 1525942797, 1, '6,200,000 recommended for 24mths', 1, 1525361790, 1, '2018-05-10 08:59:58'),
(00000000106, 'L1805034347', 1, 59, NULL, 4, 1, '4838363.00', 1512056627, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '4838363.00', 1526025346, 10, '4,838,363 recommended for 12mths', 1, 1525362227, 1, '2018-05-11 07:55:46'),
(00000000107, 'L1805035007', 1, 89, NULL, 12, 4, '3000000.00', 1512661807, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '3000000.00', 1525362629, 1, '4,838,363m for 12mths recommended', 1, 1525362607, 1, '2018-05-03 15:50:29'),
(00000000108, 'L1805035130', 1, 89, NULL, 4, 4, '3000000.00', 1512661890, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 18, NULL, NULL, NULL, NULL, 0, '', '3000000.00', 1526025308, 10, '3m recommended for 18mths', 1, 1525362690, 1, '2018-05-11 07:55:08'),
(00000000109, 'L1805031659', 1, 957, NULL, 3, 1, '9910000.00', 1512749819, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 18, NULL, NULL, NULL, NULL, 0, '', '9910000.00', 1525942050, 1, '9,910,000m recommended for 18mths', 1, 1525364219, 1, '2018-05-10 08:47:30'),
(00000000110, 'L1805032403', 1, 282, NULL, 4, 1, '1000000.00', 1513095843, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525957539, 9, '1,000,000 for 6mths recommended', 1, 1525364643, 1, '2018-05-10 13:05:39'),
(00000000111, 'L1805033940', 1, 725, NULL, 3, 4, '10000000.00', 1514392780, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 18, NULL, NULL, NULL, NULL, 0, '', '10000000.00', 1525939071, 6, 'salary loan of 10m recommended for 18mths', 1, 1525365580, 1, '2018-05-10 07:57:51'),
(00000000112, 'L1805034313', 1, 184, NULL, 4, 1, '1500000.00', 1513096993, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1500000.00', 1526025258, 10, '1.5m recommended for 6mths', 1, 1525365793, 1, '2018-05-11 07:54:18'),
(00000000113, 'L1805031554', 1, 319, NULL, 4, 1, '600000.00', 1513703754, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '600000.00', 1525957273, 9, '600,000 for 4mths recommended', 1, 1525367754, 1, '2018-05-10 13:01:13'),
(00000000114, 'L1805031937', 1, 806, NULL, 4, 1, '800000.00', 1513703977, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '800000.00', 1525957248, 9, '800,000 for 6mths recommended', 1, 1525367977, 1, '2018-05-10 13:00:48'),
(00000000115, 'L1805045445', 1, 616, NULL, 4, 1, '1000000.00', 1513662885, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525957515, 9, '1,000,000 for 6mths recommended', 1, 1525413285, 1, '2018-05-10 13:05:15'),
(00000000116, 'L1805045945', 1, 138, NULL, 4, 1, '1000000.00', 1513663185, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525957485, 9, '1,000,000 for 6mths recommended', 1, 1525413585, 1, '2018-05-10 13:04:45'),
(00000000117, 'L1805040902', 1, 372, NULL, 4, 1, '1000000.00', 1513663742, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525957389, 9, '1,000,000 for 6mths recommended', 1, 1525414142, 1, '2018-05-10 13:03:09'),
(00000000118, 'L1805041535', 1, 187, NULL, 4, 1, '500000.00', 1513664135, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525957321, 9, '500,000 for 6mths recommended', 1, 1525414535, 1, '2018-05-10 13:02:01'),
(00000000119, 'L1805042359', 1, 776, NULL, 4, 1, '2000000.00', 1514442239, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 14, NULL, NULL, NULL, NULL, 0, '', '2000000.00', 1526025216, 10, '2m recommended for 14mths', 1, 1525415039, 1, '2018-05-11 07:53:36'),
(00000000120, 'L1805042905', 1, 508, NULL, 4, 1, '1700000.00', 1516775345, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 8, NULL, NULL, NULL, NULL, 0, '', '1700000.00', 1526024830, 10, '1.7m recommended for 8mths', 1, 1525415345, 1, '2018-05-11 07:47:10'),
(00000000121, 'L1805043343', 1, 17, NULL, 4, 4, '4500000.00', 1516862023, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, '', '4500000.00', 1526024785, 10, '4.5m recommended for 24mths', 1, 1525415623, 1, '2018-05-11 07:46:25'),
(00000000122, 'L1805044800', 1, 660, NULL, 4, 4, '4500000.00', 1516862880, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, '', '4500000.00', 1526024754, 10, '4.5m recommended for 24mths', 1, 1525416480, 1, '2018-05-11 07:45:54'),
(00000000123, 'L1805093103', 1, 769, NULL, 4, 2, '1000000.00', 1517319063, NULL, NULL, NULL, '120.00', 30, 0, 1, 3, 1, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525957140, 9, '1m for 1mths recommended', 1, 1525872663, 1, '2018-05-10 12:59:00'),
(00000000124, 'L1805093820', 1, 410, NULL, 4, 1, '400000.00', 1517319500, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 3, NULL, NULL, NULL, NULL, 0, '', '400000.00', 1525957094, 9, '400,000 for 3mths recommended', 1, 1525873100, 1, '2018-05-10 12:58:14'),
(00000000125, 'L1805095516', 1, 700, NULL, 4, 1, '300000.00', 1517320516, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 3, NULL, NULL, NULL, NULL, 0, '', '300000.00', 1525956915, 9, '300,000 for 3mths recommended', 1, 1525874116, 1, '2018-05-10 12:55:15'),
(00000000126, 'L1805090038', 1, 790, NULL, 4, 1, '3765500.00', 1518184838, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '3765500.00', 1526024612, 10, '3,765,500 recommended for 12mths', 1, 1525874438, 1, '2018-05-11 07:43:32'),
(00000000127, 'L1805091201', 1, 538, NULL, 4, 2, '350000.00', 1525875121, NULL, NULL, NULL, '60.00', 30, 0, 1, 3, 2, NULL, NULL, NULL, NULL, 0, '', '350000.00', 1525950979, 9, '350,000 for 2months', 1, 1525875121, 1, '2018-05-10 11:16:19'),
(00000000128, 'L1805092221', 1, 117, NULL, 4, 4, '4300000.00', 1518531741, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 24, NULL, NULL, NULL, NULL, 0, '', '4300000.00', 1526024476, 10, '4,300,000 recommended for 24mths', 1, 1525875741, 1, '2018-05-11 07:41:16'),
(00000000129, 'L1805095749', 1, 202, NULL, 4, 1, '800000.00', 1518706669, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '800000.00', 1525955936, 9, '800,000 for 6mths recommended', 1, 1525877869, 1, '2018-05-10 12:38:56'),
(00000000130, 'L1805095957', 1, 340, NULL, 4, 1, '500000.00', 1518706797, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525955916, 9, '500,000 for 6mths recommended', 1, 1525877997, 1, '2018-05-10 12:38:36'),
(00000000131, 'L1805090608', 1, 964, NULL, 3, 4, '8000000.00', 1518710768, NULL, NULL, NULL, '25.00', 30, 0, 1, 3, 19, NULL, NULL, NULL, NULL, 0, '', '8000000.00', 1525933040, 6, '8m for 19months recommended', 1, 1525881968, 1, '2018-05-10 06:17:20'),
(00000000132, 'L1805093112', 1, 818, NULL, 4, 1, '1000000.00', 1520353872, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525955875, 9, '1m for 6mths recommended', 1, 1525883472, 1, '2018-05-10 12:37:55'),
(00000000133, 'L1805093417', 1, 7, NULL, 4, 1, '1000000.00', 1521218057, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 4, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525955736, 9, '1m for 4mths recommended', 1, 1525883657, 1, '2018-05-10 12:35:36'),
(00000000134, 'L1805093932', 1, 102, NULL, 4, 1, '2000000.00', 1521563972, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 8, NULL, NULL, NULL, NULL, 0, '', '2000000.00', 1526024248, 10, '2,000,000 recommended for 8mths', 1, 1525883972, 1, '2018-05-11 07:37:28'),
(00000000135, 'L1805094202', 1, 604, NULL, 4, 1, '500000.00', 1521823322, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '500000.00', 1525955709, 9, '500,000 for 6mths recommended', 1, 1525884122, 1, '2018-05-10 12:35:09'),
(00000000136, 'L1805090731', 1, 414, NULL, 4, 1, '1000000.00', 1521824851, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525955672, 9, '1m for 12mths recommended', 1, 1525885651, 1, '2018-05-10 12:34:32'),
(00000000137, 'L1805091141', 1, 23, NULL, 4, 1, '1000000.00', 1521825101, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525951592, 9, '1,000,000 for 6months', 1, 1525885901, 1, '2018-05-10 11:26:32'),
(00000000138, 'L1805091519', 1, 862, NULL, 4, 1, '1000000.00', 1522084519, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525951447, 9, '1,000,000 for 6months', 1, 1525886119, 1, '2018-05-10 11:24:07'),
(00000000139, 'L1805091629', 1, 31, NULL, 4, 1, '2000000.00', 1522343789, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '2000000.00', 1526024128, 10, '2,000,000 recommended for 12mths', 1, 1525886189, 1, '2018-05-11 07:35:28'),
(00000000140, 'L1805091837', 1, 451, NULL, 4, 1, '1000000.00', 1523380717, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 6, NULL, NULL, NULL, NULL, 0, '', '1000000.00', 1525951406, 9, '1,000,000 for 6months', 1, 1525886317, 1, '2018-05-10 11:23:26'),
(00000000141, 'L1805092535', 1, 823, NULL, 4, 1, '600000.00', 1523381135, NULL, NULL, NULL, '39.60', 30, 0, 1, 3, 3, NULL, NULL, NULL, NULL, 0, '', '600000.00', 1525951293, 9, '600,000 for 3months', 1, 1525886735, 1, '2018-05-10 11:21:33'),
(00000000142, 'L1805093401', 1, 965, NULL, 3, 1, '5703100.00', 1522863241, NULL, NULL, NULL, '30.00', 30, 0, 1, 3, 12, NULL, NULL, NULL, NULL, 0, '', '5703100.00', 1526023705, 6, '5,703,100 recommended for 12mths', 1, 1525887241, 1, '2018-05-11 07:28:25'),
(00000000143, 'L1805102402', 1, 883, 8, 12, 6, '1200000.00', 1490246642, NULL, NULL, NULL, '30.00', 7, 0, 1, 1, 24, NULL, NULL, NULL, NULL, 0, '', '1200000.00', 1525930468, 1, 'wrong periodic interest', 1, 1525929842, 1, '2018-05-10 05:34:28'),
(00000000144, 'L1805102503', 1, 835, 8, 12, 6, '600000.00', 1490246703, NULL, NULL, NULL, '30.00', 7, 0, 1, 1, 24, NULL, NULL, NULL, NULL, 0, '', '600000.00', 1525930519, 1, 'wrong periodic interest', 1, 1525929903, 1, '2018-05-10 05:35:19'),
(00000000145, 'L1805102601', 1, 9, 8, 12, 6, '600000.00', 1490246761, NULL, NULL, NULL, '30.00', 7, 0, 1, 1, 24, NULL, NULL, NULL, NULL, 0, '', '600000.00', 1525930505, 1, 'wrong periodic interest', 1, 1525929961, 1, '2018-05-10 05:35:05'),
(00000000146, 'L1805102715', 1, 13, 8, 12, 6, '400000.00', 1490246835, NULL, NULL, NULL, '30.00', 7, 0, 1, 1, 24, NULL, NULL, NULL, NULL, 0, '', '400000.00', 1525930487, 1, 'wrong periodic interest', 1, 1525930035, 1, '2018-05-10 05:34:47');

-- --------------------------------------------------------

--
-- Table structure for table `loan_account_approval`
--

CREATE TABLE `loan_account_approval` (
  `id` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `amountRecommended` decimal(15,2) DEFAULT NULL,
  `justification` text NOT NULL COMMENT 'Reasons for action taken',
  `status` tinyint(4) NOT NULL COMMENT 'approved-1, rejected-2',
  `staffId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_account_approval`
--

INSERT INTO `loan_account_approval` (`id`, `loanAccountId`, `amountRecommended`, `justification`, `status`, `staffId`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, 1, '1000000.00', 'income to instalment ratio is 1.7:1. Collateral is atleast 2 times the size of the loan', 2, 3, 1510826683, 3, '2017-11-16 10:04:43'),
(2, 6, '200000.00', 'income to instalment ratio is 2:1', 2, 3, 1511266615, 3, '2017-11-21 12:16:55'),
(3, 5, '300000.00', 'income to instalment ratio is 2:1', 2, 3, 1511266631, 3, '2017-11-21 12:17:11'),
(4, 4, '200000.00', 'income to instalment ratio is 2:1', 2, 3, 1511266640, 3, '2017-11-21 12:17:20'),
(5, 3, '300000.00', 'income to instalment ratio is 2:1', 2, 3, 1511266649, 3, '2017-11-21 12:17:29'),
(6, 6, '200000.00', 'she operates a charcoal business', 3, 6, 1511267410, 6, '2017-11-21 12:30:10'),
(7, 5, '300000.00', 'she operates a poultry business and 300,000 was approved', 3, 6, 1511267450, 6, '2017-11-21 12:30:50'),
(8, 4, '200000.00', 'she operates a spare parts and local restaurant', 3, 6, 1511267490, 6, '2017-11-21 12:31:30'),
(9, 3, '300000.00', 'she operates a mechanics workshop', 3, 6, 1511267519, 6, '2017-11-21 12:31:59'),
(10, 1, '1000000.00', 'a loan of 1m was approved for 6 months', 3, 6, 1511267645, 6, '2017-11-21 12:34:05'),
(11, 7, '2500000.00', 'basing on client\'s financials,Collateral and the fact that he is a salaried client,recommended by his employer ,i recommend  for a loan of 2.5m.Income to instalment ratio is 1.6:1', 2, 3, 1511333065, 3, '2017-11-22 06:44:25'),
(12, 2, '400000.00', 'has pledged collateral of kibanja-5m,sofa chairs-300,000/-tv-200,000/-.\nnet income to instalment ratio is 1.2:1.0', 2, 3, 1511946704, 3, '2017-11-29 09:11:44'),
(13, 7, '2500000.00', 'Client is  a teacher at Kabojja Junior school with a monthly salary of 634,250,but has an obligation in Centenary Bank 1.5m for 12 months is recommended', 3, 6, 1511947610, 6, '2017-11-29 09:26:50'),
(14, 2, '400000.00', 'A loan of 400,000 payable in one month is approved', 3, 6, 1511948265, 6, '2017-11-29 09:37:45'),
(15, 9, '500000.00', 'her income to instalment ratio is 2:1. has pledged collateral of fridge-400,000/-,Sowing machine-300,000/-.Recommend her for aloan of 400,000/- payable in 5 months.', 2, 3, 1511955357, 3, '2017-11-29 11:35:57'),
(16, 12, '6200000.00', 'His income to instalment ratio is 2.2:1', 2, 3, 1511958311, 3, '2017-11-29 12:25:11'),
(17, 12, '6200000.00', 'Client is employed with BLB net take home is 2,523,555/= a loan 0f 6.2m is recommmended for 24 months with a monthly instalment of 387,500/ per month', 3, 6, 1512031881, 6, '2017-11-30 08:51:21'),
(18, 13, '1000000.00', 'Has 8 rental units in Mutungo and a retail shop that sales cheaps,tea,porpcorns and soft drinks.has pledged collateral of sofa chairs,dinning set,fridge worthy 1.7m.her income to instalment ratio is 1.7:1', 2, 3, 1516855936, 3, '2018-01-25 04:52:16'),
(19, 14, '5621500.00', 'permanent resident of Ndejje .Owns a home with 8 rental units earning 150,000/= each monthly. wants to register and acquire a leasehold tittle over his Kibanja. Has got a letter from Omutongole Wa Kabaka,LC 1 letter and a recommendation from BLB ', 2, 3, 1516856879, 3, '2018-01-25 05:07:59'),
(20, 15, '23187400.00', 'is a permanent resident of Mutungo.Has got 8 rental units where she earns 300,000/= from each monthly.she owns and runs asaloon in nakawa and has a bicycle spare parts shop.Has pledged her kibanja as collateral for the loan.', 2, 3, 1516858200, 3, '2018-01-25 05:30:00'),
(21, 16, '5000000.00', 'Has applied for 20m for family house construction.He owns a nursery school in Kabimbiri Mukono and a civil servant teaching in Kikandwa cou pri sch.Has piggery and a coffe business.Has pledged land tittle and has got consent from other family members', 2, 3, 1516858664, 3, '2018-01-25 05:37:44'),
(22, 13, '1000000.00', 'loan interest terms are wrong', 11, 6, 1516858826, 6, '2018-01-25 05:40:26'),
(23, 17, '1000000.00', 'Apermanent residentof Namuwongo.Has applied for an emmergency loan of 1m.Has rental houses,retail business that sales cheaps,tea,popcorns and soft drinks.pledged sofa chairs,dinning set,fridge as collateral worthy 1.7m', 2, 3, 1516859580, 3, '2018-01-25 05:53:00'),
(24, 18, '30000000.00', 'i recommend 20m loan', 2, 8, 1517042018, 8, '2018-01-27 08:33:38'),
(25, 18, '30000000.00', 'i recommend 20m loan', 2, 8, 1517042020, 8, '2018-01-27 08:33:40'),
(26, 19, '5000000.00', 'i recommend client for a loan of 5m payable in 16months', 2, 8, 1517048932, 8, '2018-01-27 10:28:52'),
(27, 20, '800000.00', 'I recommend her for a loan of 800,000 payable in 6 mths', 2, 8, 1517049959, 8, '2018-01-27 10:45:59'),
(28, 17, '1000000.00', '1,000,000 recommended for 1 month', 3, 6, 1517587714, 6, '2018-02-02 16:08:34'),
(29, 20, '800000.00', '400,000 recommended for 3 months', 3, 6, 1517587792, 6, '2018-02-02 16:09:52'),
(30, 19, '5000000.00', '5m recommended for 16mths', 3, 6, 1517587853, 6, '2018-02-02 16:10:53'),
(31, 20, '400000.00', 'Client\'s business is small and since she is adding working capital she takes first that', 4, 9, 1517588685, 9, '2018-02-02 16:24:45'),
(32, 17, '1000000.00', 'emergency loan of 1m for 1 month was approved', 4, 9, 1517588779, 9, '2018-02-02 16:26:19'),
(33, 21, '12677000.00', 'I recommend him for 12,677,000', 2, 8, 1517987496, 8, '2018-02-07 07:11:36'),
(34, 19, '0.00', 'Recalculate interest', 11, 6, 1518021670, 6, '2018-02-07 16:41:10'),
(35, 22, '1200000.00', 'A staff of Tropical bank serving as assistant Branch manager Katwe Branch.Has monthly salary of 1.9m and a semi parmanent citizen of Wabigalo zone LC1.Has net income of 652,250.Income to instalment ratio is 1:2', 2, 3, 1520338346, 3, '2018-03-06 12:12:26'),
(36, 23, '5000000.00', 'Aresident of Kitende Makandwa village and an employee of A&s elctronics ltd.He is a second time borrower with Buladde .Has monthly salary of 600,000/= and rental income of 400,000/= from 2 units.Income to instalment ratio is 1:2', 2, 3, 1520339076, 3, '2018-03-06 12:24:36'),
(37, 22, '1200000.00', 'please apply for 1m for 5mths', 11, 6, 1520342919, 6, '2018-03-06 13:28:39'),
(38, 22, '1200000.00', 'please apply for 1m for 5mths', 11, 6, 1520342920, 6, '2018-03-06 13:28:40'),
(39, 24, '1000000.00', 'A staff of tropical bank serving as assistant branch manager Katwe Branch.Has monthly net salary of 1.9m.Net surplus is 652,250.Income to instalment ratio is 1:2', 2, 3, 1520343631, 3, '2018-03-06 13:40:31'),
(40, 24, '1000000.00', 'recommended for 1m for 6mths', 3, 6, 1520344956, 6, '2018-03-06 14:02:36'),
(41, 24, '1000000.00', 'approved', 4, 9, 1520345046, 9, '2018-03-06 14:04:06'),
(42, 25, '2000000.00', 'works with A&S electronics and has a monthly salary of 600,000/-,rental income of 400,000/- amonth,second time borrower', 2, 3, 1521630668, 3, '2018-03-21 11:11:08'),
(43, 26, '3000000.00', 'has poultry in busunjju,grows coffe and red pepper.Collateral is substantial and is a second term borrower.Income to instalment ratio is 3:1', 2, 3, 1521632408, 3, '2018-03-21 11:40:08'),
(44, 27, '500000.00', 'second time borrower with previous loan of 400000/-.has liquid soap business.income to instalment ratio is 2:1', 2, 3, 1521632771, 3, '2018-03-21 11:46:11'),
(45, 28, '1000000.00', 'has poultry business.Collateral is substantial.income to instalment ratio is 2:1', 2, 3, 1521633268, 3, '2018-03-21 11:54:28'),
(46, 29, '1000000.00', 'I recommend Sengendo Robert for a loan of 1m payable in 6months ', 2, 8, 1521649012, 8, '2018-03-21 16:16:52'),
(47, 30, '2000000.00', 'client recommended for 2m for 12months', 2, 8, 1521707989, 8, '2018-03-22 08:39:49'),
(48, 30, '2000000.00', 'A loan of 2m for 12months is recommended.', 3, 6, 1521708331, 6, '2018-03-22 08:45:31'),
(49, 30, '2000000.00', 'A loan of 2m shs to be serviced in 12 months approved', 4, 10, 1521708594, 10, '2018-03-22 08:49:54'),
(50, 29, '1000000.00', 'A loan of 1m payable in 6months recommended', 3, 6, 1522904875, 6, '2018-04-05 05:07:55'),
(51, 27, '500000.00', 'A Loan of 500,000 for 6 months approved', 3, 6, 1522905228, 6, '2018-04-05 05:13:48'),
(52, 25, '2000000.00', 'A Loan of 2m for 8 months is recommended', 3, 6, 1522906521, 6, '2018-04-05 05:35:21'),
(53, 29, '1000000.00', '1m for 6months is approved', 4, 9, 1522906616, 9, '2018-04-05 05:36:56'),
(54, 27, '500000.00', '500,000 for 6months is approved', 4, 9, 1522906668, 9, '2018-04-05 05:37:48'),
(55, 28, '1000000.00', 'to be re applied', 12, 6, 1522915392, 6, '2018-04-05 08:03:12'),
(56, 28, '1000000.00', 'to be re applied', 12, 6, 1522915394, 6, '2018-04-05 08:03:14'),
(57, 26, '3000000.00', '2,000,000 for 12 months approved', 3, 6, 1522915460, 6, '2018-04-05 08:04:20'),
(58, 25, '2000000.00', '2,000,000 for a period of 8months approved', 4, 10, 1522915727, 10, '2018-04-05 08:08:47'),
(59, 26, '2000000.00', '2,000,000 for a period of 8months approved', 4, 10, 1522915996, 10, '2018-04-05 08:13:16'),
(60, 31, '500000.00', 'I recommend a loan of 500,000 payable in 6mths', 2, 8, 1522922426, 8, '2018-04-05 10:00:26'),
(61, 31, '500000.00', 're apply', 11, 6, 1523426105, 6, '2018-04-11 05:55:05'),
(62, 32, '700000.00', 'recommended', 2, 8, 1523706478, 8, '2018-04-14 11:47:58'),
(63, 32, '700000.00', 'recommended 700,000 for 4 mths', 3, 6, 1523706599, 6, '2018-04-14 11:49:59'),
(64, 32, '700000.00', '700,000 appvd for 4mths', 4, 9, 1523706702, 9, '2018-04-14 11:51:42'),
(65, 33, '500000.00', 'recommended', 2, 1, 1523713893, 1, '2018-04-14 13:51:33'),
(66, 33, '500000.00', 'recommended', 3, 6, 1523713992, 6, '2018-04-14 13:53:12'),
(67, 23, '5000000.00', 'recommended', 11, 6, 1523714035, 6, '2018-04-14 13:53:55'),
(68, 33, '500000.00', 'Appvd', 4, 9, 1523714270, 9, '2018-04-14 13:57:50'),
(69, 34, '1500000.00', 'A loan of 1500000 for 3months', 2, 1, 1523852060, 1, '2018-04-16 04:14:20'),
(70, 8, '500000.00', 'reffered for re application', 12, 1, 1523852326, 1, '2018-04-16 04:18:46'),
(71, 11, '6200000.00', 'recommended 6200000 for 24months', 2, 1, 1523852617, 1, '2018-04-16 04:23:37'),
(72, 10, '6200000.00', 'recommended 6200000 for 24months', 12, 1, 1523852857, 1, '2018-04-16 04:27:37'),
(73, 35, '500000.00', 'recommended', 2, 1, 1523853126, 1, '2018-04-16 04:32:06'),
(74, 11, '6200000.00', 'recommended 6.2m for 24mths', 3, 6, 1524037339, 6, '2018-04-18 07:42:19'),
(75, 9, '500000.00', 'its 500,000 for 6mths', 11, 6, 1524037458, 6, '2018-04-18 07:44:18'),
(76, 34, '1500000.00', '1.5m recommended for 3months', 3, 6, 1524037585, 6, '2018-04-18 07:46:25'),
(77, 35, '500000.00', '500,000 for 5monts', 3, 6, 1524037821, 6, '2018-04-18 07:50:21'),
(78, 36, '500000.00', 'forwarded 500,000 for 5months', 2, 1, 1524040659, 1, '2018-04-18 08:37:39'),
(79, 36, '500000.00', 'forwarded', 3, 6, 1524041736, 6, '2018-04-18 08:55:36'),
(80, 36, '500000.00', '500,000 for 5months', 4, 9, 1524052350, 9, '2018-04-18 11:52:30'),
(81, 35, '500000.00', '500,000 for 5months', 4, 9, 1524052400, 9, '2018-04-18 11:53:20'),
(82, 2, '400000.00', '400,000 at 10%pmth for 1 month', 4, 9, 1524052470, 9, '2018-04-18 11:54:30'),
(83, 1, '1000000.00', '1m for 6mths', 4, 9, 1524052874, 9, '2018-04-18 12:01:14'),
(84, 34, '1500000.00', 're apply', 11, 10, 1524113815, 10, '2018-04-19 04:56:55'),
(85, 37, '1500000.00', '1,500,000 for 3 months', 2, 1, 1524114083, 1, '2018-04-19 05:01:23'),
(86, 37, '1500000.00', 'recommended 1.5m for 3mths', 3, 6, 1524114178, 6, '2018-04-19 05:02:58'),
(87, 37, '1500000.00', '1.5m for 3mths', 4, 10, 1524114228, 10, '2018-04-19 05:03:48'),
(88, 38, '4500000.00', '4.5m for 12 months', 2, 1, 1524117572, 1, '2018-04-19 05:59:32'),
(89, 39, '700000.00', '700,000 for 4months recommended', 2, 1, 1524117637, 1, '2018-04-19 06:00:37'),
(90, 40, '1000000.00', '1,000,000 for 12months recommended', 2, 1, 1524117686, 1, '2018-04-19 06:01:26'),
(91, 41, '1000000.00', '1,000,000 for 6months recommended', 2, 1, 1524118054, 1, '2018-04-19 06:07:34'),
(92, 42, '1500000.00', '1,500,000 for 10months recommended', 2, 1, 1524118365, 1, '2018-04-19 06:12:45'),
(93, 43, '800000.00', '800,000 for 6months recommended', 2, 1, 1524118645, 1, '2018-04-19 06:17:25'),
(94, 44, '1000000.00', '1,000,000 for 4months recommended', 2, 1, 1524119027, 1, '2018-04-19 06:23:47'),
(95, 45, '1000000.00', '1,000,000 for 4months recommended', 2, 1, 1524119475, 1, '2018-04-19 06:31:15'),
(96, 46, '1000000.00', '1,000,000 for 6months recommended', 2, 1, 1524120009, 1, '2018-04-19 06:40:09'),
(97, 38, '4500000.00', '4500000 for 12mths', 3, 6, 1524121441, 6, '2018-04-19 07:04:01'),
(98, 39, '700000.00', '700,000 for 4months', 3, 6, 1524121476, 6, '2018-04-19 07:04:36'),
(99, 40, '1000000.00', '1,000,000 for 12mths', 3, 6, 1524121661, 6, '2018-04-19 07:07:41'),
(100, 41, '1000000.00', '1,000,000 for 6mths', 3, 6, 1524121699, 6, '2018-04-19 07:08:19'),
(101, 42, '1500000.00', '1,500,000 for 10months', 3, 6, 1524121789, 6, '2018-04-19 07:09:49'),
(102, 43, '800000.00', '800,000 for 6months', 3, 6, 1524121834, 6, '2018-04-19 07:10:34'),
(103, 44, '1000000.00', '1,000,000 for 4months', 3, 6, 1524121948, 6, '2018-04-19 07:12:28'),
(104, 45, '1000000.00', '1,000,000 for 4months', 3, 6, 1524122046, 6, '2018-04-19 07:14:06'),
(105, 46, '1000000.00', '1,000,000 for 6months', 3, 6, 1524122072, 6, '2018-04-19 07:14:32'),
(106, 39, '700000.00', '700,000 for 4months', 4, 9, 1524122182, 9, '2018-04-19 07:16:22'),
(107, 40, '1000000.00', '1,000,000 for 12mths', 4, 9, 1524122270, 9, '2018-04-19 07:17:50'),
(108, 41, '1000000.00', '1,000,000 for 6mths', 4, 9, 1524122311, 9, '2018-04-19 07:18:31'),
(109, 43, '800000.00', '1,000,000 for 6mths', 4, 9, 1524122382, 9, '2018-04-19 07:19:42'),
(110, 44, '1000000.00', '1,000,000 for 4mths', 4, 9, 1524122407, 9, '2018-04-19 07:20:07'),
(111, 45, '1000000.00', '1,000,000 for 4mths', 4, 9, 1524122422, 9, '2018-04-19 07:20:22'),
(112, 46, '1000000.00', '1,000,000 for 6mths', 4, 9, 1524122454, 9, '2018-04-19 07:20:54'),
(113, 42, '1500000.00', '1,500,000 for 10mths', 4, 10, 1524122576, 10, '2018-04-19 07:22:56'),
(114, 38, '4500000.00', '4,500,000 for 12mths', 4, 10, 1524122598, 10, '2018-04-19 07:23:18'),
(115, 7, '2500000.00', 'rejected', 11, 10, 1524122632, 10, '2018-04-19 07:23:52'),
(116, 47, '5000000.00', '5,000,000 for 12months', 2, 1, 1524123020, 1, '2018-04-19 07:30:20'),
(117, 48, '1000000.00', '1,000,000 for 4months', 2, 1, 1524123811, 1, '2018-04-19 07:43:31'),
(118, 48, '1000000.00', '1m for 4months', 3, 1, 1524126035, 1, '2018-04-19 08:20:35'),
(119, 47, '5000000.00', 'recommended 5,000,000 for 12 months', 3, 1, 1524126084, 1, '2018-04-19 08:21:24'),
(120, 49, '1500000.00', '1,500,000 recommended for 6 months', 2, 1, 1524126348, 1, '2018-04-19 08:25:48'),
(121, 50, '300000.00', '300,000 for 3months', 2, 1, 1524126555, 1, '2018-04-19 08:29:15'),
(122, 49, '1500000.00', 'recommended for 1.5m for 6mths', 3, 6, 1524128046, 6, '2018-04-19 08:54:06'),
(123, 50, '300000.00', 'recommended for 300,000 for 3mths', 3, 6, 1524128155, 6, '2018-04-19 08:55:55'),
(124, 51, '0.00', 'reapply', 12, 1, 1524133073, 1, '2018-04-19 10:17:53'),
(125, 52, '700000.00', 'recommended for 700,000 for 6mths', 2, 1, 1524133822, 1, '2018-04-19 10:30:22'),
(126, 53, '1000000.00', 'recommended for 1,000,000 for 6months', 2, 1, 1524134278, 1, '2018-04-19 10:37:58'),
(127, 54, '800000.00', 'recommended for 800,000 for 6months', 2, 1, 1524137984, 1, '2018-04-19 11:39:44'),
(128, 55, '250000.00', '250,000 for a period of 6mths', 2, 1, 1524139506, 1, '2018-04-19 12:05:06'),
(129, 56, '500000.00', '800,000 for a period of 6mths', 2, 1, 1524140171, 1, '2018-04-19 12:16:11'),
(130, 56, '500000.00', '500,000 for 6mths', 3, 6, 1524142226, 6, '2018-04-19 12:50:26'),
(131, 55, '250000.00', '250,000 for 6mths', 3, 6, 1524142276, 6, '2018-04-19 12:51:16'),
(132, 54, '800000.00', '800,000 for 6mths', 3, 6, 1524142308, 6, '2018-04-19 12:51:48'),
(133, 53, '1000000.00', '1,000,000 for 6mths', 3, 6, 1524142375, 6, '2018-04-19 12:52:55'),
(134, 52, '700000.00', '700,000 for 6mths', 3, 6, 1524142406, 6, '2018-04-19 12:53:26'),
(135, 59, '300000.00', '300,000 for 2months', 2, 1, 1524206078, 1, '2018-04-20 06:34:38'),
(136, 57, '300000.00', '300,000 for 6months', 2, 1, 1524206167, 1, '2018-04-20 06:36:07'),
(137, 58, '500000.00', '500,000 for 5months', 2, 1, 1524206253, 1, '2018-04-20 06:37:33'),
(138, 56, '500000.00', '500,000 for 6mths', 4, 9, 1524387307, 9, '2018-04-22 08:55:07'),
(139, 55, '250000.00', '250,000 for 6mths', 4, 9, 1524387343, 9, '2018-04-22 08:55:43'),
(140, 54, '800000.00', '800,000 for 6mths', 4, 9, 1524387473, 9, '2018-04-22 08:57:53'),
(141, 53, '1000000.00', '1,000,000 for 6mths', 4, 9, 1524387499, 9, '2018-04-22 08:58:19'),
(142, 52, '700000.00', '700,000 for 6mths', 4, 9, 1524387533, 9, '2018-04-22 08:58:53'),
(143, 50, '300000.00', '300,000 for 3mths', 4, 9, 1524387568, 9, '2018-04-22 08:59:28'),
(144, 48, '1000000.00', '1,000,000 for 4mths', 4, 9, 1524387601, 9, '2018-04-22 09:00:01'),
(145, 49, '1500000.00', '1,500,000 for 6months', 4, 10, 1524388252, 10, '2018-04-22 09:10:52'),
(146, 47, '5000000.00', '500,000 for 12months', 4, 10, 1524388506, 10, '2018-04-22 09:15:06'),
(147, 59, '300000.00', '300,000 for 2mths', 3, 6, 1524389331, 6, '2018-04-22 09:28:51'),
(148, 58, '500000.00', '500,000 for 5mths', 3, 6, 1524389402, 6, '2018-04-22 09:30:02'),
(149, 57, '300000.00', '300,000 for 6mths', 3, 6, 1524389437, 6, '2018-04-22 09:30:37'),
(150, 60, '1600000.00', '1,600,000 for 12mths', 2, 1, 1524390102, 1, '2018-04-22 09:41:42'),
(151, 61, '2000000.00', '2,000,000 for 4mths', 2, 1, 1524390572, 1, '2018-04-22 09:49:32'),
(152, 62, '1000000.00', '2,000,000 for 4mths', 12, 1, 1524390768, 1, '2018-04-22 09:52:48'),
(153, 63, '1000000.00', '1,000,000 for 12mths', 2, 1, 1524390852, 1, '2018-04-22 09:54:12'),
(154, 64, '2015000.00', '2,015,000 for 12mths', 2, 1, 1524391197, 1, '2018-04-22 09:59:57'),
(155, 65, '3500000.00', '2,015,000 for 12mths', 12, 1, 1524392336, 1, '2018-04-22 10:18:56'),
(156, 66, '3500000.00', '2,015,000 for 12mths', 12, 1, 1524392434, 1, '2018-04-22 10:20:34'),
(157, 67, '3500000.00', '3,500,000 for 8mths', 2, 1, 1524392580, 1, '2018-04-22 10:23:00'),
(158, 68, '8500000.00', '8.5m for 12months recommended', 2, 1, 1524462542, 1, '2018-04-23 05:49:02'),
(159, 69, '1000000.00', 'wrong interest terms', 12, 1, 1524472671, 1, '2018-04-23 08:37:51'),
(160, 70, '1000000.00', '1,000,000 for 6mths', 2, 1, 1524472884, 1, '2018-04-23 08:41:24'),
(161, 71, '2000000.00', '2,000,000 for 6mths', 2, 1, 1524473045, 1, '2018-04-23 08:44:05'),
(162, 72, '1000000.00', '1,000,000 for 6mths', 2, 1, 1524473554, 1, '2018-04-23 08:52:34'),
(163, 72, '1000000.00', '1,000,000 for 6mths recommended', 3, 6, 1524476629, 6, '2018-04-23 09:43:49'),
(164, 71, '2000000.00', '2,000,000 for 6mths recommended', 3, 6, 1524476754, 6, '2018-04-23 09:45:54'),
(165, 70, '1000000.00', '1,000,000 for 6mths recommended', 3, 6, 1524476786, 6, '2018-04-23 09:46:26'),
(166, 68, '8500000.00', '8,500,000 for 12mths recommended', 3, 6, 1524476815, 6, '2018-04-23 09:46:55'),
(167, 67, '3500000.00', '3,500,000 for 8mths recommended', 3, 6, 1524476862, 6, '2018-04-23 09:47:42'),
(168, 64, '2015000.00', '2,015,000 for 12mths recommended', 3, 6, 1524477176, 6, '2018-04-23 09:52:56'),
(169, 63, '1000000.00', '1,000,000 for 12mths recommended', 3, 6, 1524477235, 6, '2018-04-23 09:53:55'),
(170, 61, '2000000.00', '2,000,000 for 4mths recommended', 3, 6, 1524477282, 6, '2018-04-23 09:54:42'),
(171, 60, '1600000.00', '1,600,000 for 12mths recommended', 3, 6, 1524477319, 6, '2018-04-23 09:55:19'),
(172, 73, '2000000.00', '2,000,000 for 6mths', 2, 1, 1524547472, 1, '2018-04-24 05:24:32'),
(173, 74, '1500000.00', '1,500,000 for 10mths', 2, 1, 1524547543, 1, '2018-04-24 05:25:43'),
(174, 75, '700000.00', '700,000 for 6mths', 2, 1, 1524550241, 1, '2018-04-24 06:10:41'),
(175, 76, '500000.00', '500,000 for 6mths', 2, 1, 1524550311, 1, '2018-04-24 06:11:51'),
(176, 77, '400000.00', '400,000 for 6mths', 2, 1, 1524550468, 1, '2018-04-24 06:14:28'),
(177, 78, '1000000.00', '1,000,000 for 6mths', 2, 1, 1524550928, 1, '2018-04-24 06:22:08'),
(178, 78, '1000000.00', '1m for 6mths', 3, 6, 1524561516, 6, '2018-04-24 09:18:36'),
(179, 77, '400000.00', '400,000 for 6mths', 3, 6, 1524561767, 6, '2018-04-24 09:22:47'),
(180, 76, '500000.00', '500,000 for 6mths', 3, 6, 1524562103, 6, '2018-04-24 09:28:23'),
(181, 75, '700000.00', '700,000 for 6mths', 3, 6, 1524562131, 6, '2018-04-24 09:28:51'),
(182, 74, '1500000.00', '1,500,000 for 10mths', 3, 6, 1524562175, 6, '2018-04-24 09:29:35'),
(183, 73, '2000000.00', '2,000,000 for 6mths', 3, 6, 1524562225, 6, '2018-04-24 09:30:25'),
(184, 80, '500000.00', '500,000 for 6mths recommended', 2, 1, 1524746311, 1, '2018-04-26 12:38:31'),
(185, 86, '3000000.00', '3m for 10mths', 2, 1, 1525248404, 1, '2018-05-02 08:06:44'),
(186, 85, '2500000.00', '2.5m for 12mths', 2, 1, 1525248812, 1, '2018-05-02 08:13:32'),
(187, 84, '1000000.00', '1m for 2mths', 2, 1, 1525248853, 1, '2018-05-02 08:14:13'),
(188, 83, '1000000.00', '1m for 6mths', 2, 1, 1525248889, 1, '2018-05-02 08:14:49'),
(189, 82, '500000.00', '500,000 for 4mths', 2, 1, 1525248934, 1, '2018-05-02 08:15:34'),
(190, 81, '500000.00', '500,000 for 6mths', 2, 1, 1525248966, 1, '2018-05-02 08:16:06'),
(191, 79, '1500000.00', '1,500,000 for 20mths', 2, 1, 1525249093, 1, '2018-05-02 08:18:13'),
(192, 87, '1000000.00', '1m for 6mths recommended', 2, 1, 1525250488, 1, '2018-05-02 08:41:28'),
(193, 88, '2750000.00', '2.75m for 12mths recommended', 2, 1, 1525251095, 1, '2018-05-02 08:51:35'),
(194, 89, '800000.00', '800,000 for 7mths', 2, 1, 1525252943, 1, '2018-05-02 09:22:23'),
(195, 90, '3456200.00', '3,456,200 for 10mths', 2, 1, 1525253716, 1, '2018-05-02 09:35:16'),
(196, 91, '1500000.00', '1,500,000 for 6mths', 2, 1, 1525254977, 1, '2018-05-02 09:56:17'),
(197, 92, '4500000.00', '4,500,000 for 9mths', 2, 1, 1525255280, 1, '2018-05-02 10:01:20'),
(198, 95, '11900000.00', '11,900,000 for 15mths', 2, 1, 1525256348, 1, '2018-05-02 10:19:08'),
(199, 94, '6900000.00', '6,900,000 for 15mths', 2, 1, 1525256395, 1, '2018-05-02 10:19:55'),
(200, 93, '400000.00', '400,000 for 4mths', 2, 1, 1525256443, 1, '2018-05-02 10:20:43'),
(201, 96, '2212480.00', '2,212,480 for 12mths', 2, 1, 1525323290, 1, '2018-05-03 04:54:50'),
(202, 97, '2200000.00', '2,200,000 for 10mths recommended', 2, 1, 1525325253, 1, '2018-05-03 05:27:33'),
(203, 98, '1000000.00', '1000,000 for 1mth recommended', 2, 1, 1525325298, 1, '2018-05-03 05:28:18'),
(204, 99, '300000.00', '300,000 for 4mths recommended', 2, 1, 1525354905, 1, '2018-05-03 13:41:45'),
(205, 100, '1000000.00', '1m for 6mths', 2, 1, 1525359720, 1, '2018-05-03 15:02:00'),
(206, 101, '1000000.00', '1m for 6mths', 12, 1, 1525360476, 1, '2018-05-03 15:14:36'),
(207, 102, '400000.00', '400,000 for 1mths recommended', 2, 1, 1525360873, 1, '2018-05-03 15:21:13'),
(208, 103, '4200000.00', '4.2m for 12mths recommended', 2, 1, 1525361042, 1, '2018-05-03 15:24:02'),
(209, 104, '5880000.00', '5.88m for 18mths recommended', 2, 1, 1525361673, 1, '2018-05-03 15:34:33'),
(210, 105, '6200000.00', '6.2m for 24mths recommended', 2, 1, 1525361825, 1, '2018-05-03 15:37:05'),
(211, 106, '4838363.00', '4,838,363m for 12mths recommended', 2, 1, 1525362461, 1, '2018-05-03 15:47:41'),
(212, 107, '3000000.00', '4,838,363m for 12mths recommended', 12, 1, 1525362629, 1, '2018-05-03 15:50:29'),
(213, 108, '3000000.00', '3m for 18mths recommended', 2, 1, 1525362734, 1, '2018-05-03 15:52:14'),
(214, 109, '9910000.00', '9,910,000 recommended for 18mths', 2, 1, 1525364274, 1, '2018-05-03 16:17:54'),
(215, 110, '1000000.00', '1m for 6mths', 2, 1, 1525364687, 1, '2018-05-03 16:24:47'),
(216, 111, '10000000.00', '10m for 18mths', 2, 1, 1525365610, 1, '2018-05-03 16:40:10'),
(217, 112, '1500000.00', '1.5m for 6mths', 2, 1, 1525365833, 1, '2018-05-03 16:43:53'),
(218, 113, '600000.00', '600,000m for4mths', 2, 1, 1525367796, 1, '2018-05-03 17:16:36'),
(219, 114, '800000.00', '800,000m for6mths', 2, 1, 1525368022, 1, '2018-05-03 17:20:22'),
(220, 114, '800000.00', '800,000m for6mths', 2, 1, 1525368023, 1, '2018-05-03 17:20:23'),
(221, 115, '1000000.00', '1m recommended for 6mths', 2, 1, 1525413365, 1, '2018-05-04 05:56:05'),
(222, 116, '1000000.00', '1m recommended for 6mths', 2, 1, 1525413623, 1, '2018-05-04 06:00:23'),
(223, 117, '1000000.00', '1m recommended for 6mths', 2, 1, 1525414162, 1, '2018-05-04 06:09:22'),
(224, 118, '500000.00', '500,000 for 6mths recommended', 2, 1, 1525414843, 1, '2018-05-04 06:20:43'),
(225, 119, '2000000.00', '2m for 14mths recommended', 2, 1, 1525415119, 1, '2018-05-04 06:25:19'),
(226, 120, '1700000.00', '1.7m for 8mths recommended', 2, 1, 1525415399, 1, '2018-05-04 06:29:59'),
(227, 121, '4500000.00', '4.5m for 24mths recommended', 2, 1, 1525415757, 1, '2018-05-04 06:35:57'),
(228, 122, '4500000.00', '4.5m for 24mths recommended', 2, 1, 1525416510, 1, '2018-05-04 06:48:30'),
(229, 80, '500000.00', '500,000 for 6mths', 3, 6, 1525872099, 6, '2018-05-09 13:21:39'),
(230, 79, '1500000.00', '1,500,000 for 20months', 3, 6, 1525872318, 6, '2018-05-09 13:25:18'),
(231, 123, '1000000.00', '1,000,000 for 1mth recommended', 2, 1, 1525872706, 1, '2018-05-09 13:31:46'),
(232, 124, '400000.00', '400,000 for 3mths recommended', 2, 1, 1525873149, 1, '2018-05-09 13:39:09'),
(233, 125, '300000.00', '300,000 for 3mths recommended', 2, 1, 1525874280, 1, '2018-05-09 13:58:00'),
(234, 126, '3765500.00', '3,765,500 for 12mths recommended', 2, 1, 1525874647, 1, '2018-05-09 14:04:07'),
(235, 127, '350000.00', '350,000 for 2mths recommended', 2, 1, 1525875161, 1, '2018-05-09 14:12:41'),
(236, 128, '4300000.00', '4,300,000 for 24mths recommended', 2, 1, 1525875827, 1, '2018-05-09 14:23:47'),
(237, 128, '4300000.00', '4,300,000 for 24mths recommended', 2, 1, 1525875828, 1, '2018-05-09 14:23:48'),
(238, 129, '800000.00', '800,000 for 6mths recommended', 2, 1, 1525877910, 1, '2018-05-09 14:58:30'),
(239, 130, '500000.00', '500,000 for 6mths recommended', 2, 1, 1525878147, 1, '2018-05-09 15:02:27'),
(240, 131, '8000000.00', '8m recommended for 19mths', 2, 1, 1525883248, 1, '2018-05-09 16:27:28'),
(241, 132, '1000000.00', '1m recommended for 6mths', 2, 1, 1525883497, 1, '2018-05-09 16:31:37'),
(242, 133, '1000000.00', '1m recommended for 4mths', 2, 1, 1525883773, 1, '2018-05-09 16:36:13'),
(243, 134, '2000000.00', '2m recommended for 8mths', 2, 1, 1525884003, 1, '2018-05-09 16:40:03'),
(244, 135, '500000.00', '500,000 recommended for 6mths', 2, 1, 1525884154, 1, '2018-05-09 16:42:34'),
(245, 136, '1000000.00', '1m for 12mths', 2, 1, 1525885685, 1, '2018-05-09 17:08:05'),
(246, 137, '1000000.00', '1m for 6mths', 2, 1, 1525885961, 1, '2018-05-09 17:12:41'),
(247, 138, '1000000.00', '1m for 6mths', 2, 1, 1525886135, 1, '2018-05-09 17:15:35'),
(248, 139, '2000000.00', '2m for 12mths recommended', 2, 1, 1525886221, 1, '2018-05-09 17:17:01'),
(249, 140, '1000000.00', '1m recommended for 6mths', 2, 1, 1525886454, 1, '2018-05-09 17:20:54'),
(250, 141, '600000.00', '600,000 recommended for 3mths', 2, 1, 1525886781, 1, '2018-05-09 17:26:21'),
(251, 142, '5703100.00', '5,703,100 for 12 months recommended', 2, 1, 1525887295, 1, '2018-05-09 17:34:55'),
(252, 127, '350000.00', '350,000 for 2months', 3, 1, 1525928723, 1, '2018-05-10 05:05:23'),
(253, 141, '600000.00', '600,000 for 3mths', 3, 1, 1525929120, 1, '2018-05-10 05:12:00'),
(254, 143, '1200000.00', 'wrong periodic interest', 12, 1, 1525930468, 1, '2018-05-10 05:34:28'),
(255, 146, '400000.00', 'wrong periodic interest', 12, 1, 1525930487, 1, '2018-05-10 05:34:47'),
(256, 145, '600000.00', 'wrong periodic interest', 12, 1, 1525930505, 1, '2018-05-10 05:35:05'),
(257, 144, '600000.00', 'wrong periodic interest', 12, 1, 1525930519, 1, '2018-05-10 05:35:19'),
(258, 81, '500000.00', '500,000 for 6mths recommended', 3, 6, 1525932316, 6, '2018-05-10 06:05:16'),
(259, 140, '1000000.00', '1,000,000 for 6mths recommended', 3, 6, 1525932372, 6, '2018-05-10 06:06:12'),
(260, 139, '2000000.00', '2,000,000 for 6mths recommended', 3, 6, 1525932430, 6, '2018-05-10 06:07:10'),
(261, 138, '1000000.00', '1,000,000 for 6mths recommended', 3, 6, 1525932474, 6, '2018-05-10 06:07:54'),
(262, 137, '1000000.00', '1,000,000 for 6mths recommended', 3, 6, 1525932500, 6, '2018-05-10 06:08:20'),
(263, 136, '1000000.00', '1,000,000 for 12mths recommended', 3, 6, 1525932519, 6, '2018-05-10 06:08:39'),
(264, 135, '500000.00', '500,000 for 6mths recommended', 3, 6, 1525932573, 6, '2018-05-10 06:09:33'),
(265, 134, '2000000.00', '2,000,000 for 8mths recommended', 3, 6, 1525932609, 6, '2018-05-10 06:10:09'),
(266, 133, '1000000.00', '1,000,000 for 4mths recommended', 3, 6, 1525932823, 6, '2018-05-10 06:13:43'),
(267, 132, '1000000.00', '1,000,000 for 6mths recommended', 3, 6, 1525932876, 6, '2018-05-10 06:14:36'),
(268, 131, '8000000.00', '8m for 19months recommended', 3, 6, 1525933040, 6, '2018-05-10 06:17:20'),
(269, 130, '500000.00', '500,000 for 6months recommended', 3, 6, 1525933071, 6, '2018-05-10 06:17:51'),
(270, 129, '800000.00', '800,000 for 6months recommended', 3, 6, 1525933090, 6, '2018-05-10 06:18:10'),
(271, 128, '4300000.00', '4.3m for 24months recommended', 3, 6, 1525933440, 6, '2018-05-10 06:24:00'),
(272, 126, '3765500.00', '3,765,500m for 12months recommended', 3, 6, 1525933475, 6, '2018-05-10 06:24:35'),
(273, 125, '300000.00', '300,000 for 3months recommended', 3, 6, 1525933531, 6, '2018-05-10 06:25:31'),
(274, 124, '400000.00', '400,000 for 3mths', 3, 6, 1525933935, 6, '2018-05-10 06:32:15'),
(275, 123, '1000000.00', '1m for 1mth recommended', 3, 6, 1525938448, 6, '2018-05-10 07:47:28'),
(276, 122, '4500000.00', '4.5m for 24mths recommended', 3, 6, 1525938541, 6, '2018-05-10 07:49:01'),
(277, 121, '4500000.00', '4.5m for 24mths recommended', 3, 6, 1525938585, 6, '2018-05-10 07:49:45'),
(278, 21, '12677000.00', 'not recommended', 12, 6, 1525938627, 6, '2018-05-10 07:50:27'),
(279, 16, '5000000.00', 'not recommended', 12, 6, 1525938640, 6, '2018-05-10 07:50:40'),
(280, 15, '23187400.00', 'not recommended', 12, 6, 1525938655, 6, '2018-05-10 07:50:55'),
(281, 14, '5621500.00', 'not recommended', 12, 6, 1525938670, 6, '2018-05-10 07:51:10'),
(282, 120, '1700000.00', '1.7m recommended for 8months', 3, 6, 1525938711, 6, '2018-05-10 07:51:51'),
(283, 18, '30000000.00', 'not recommended', 12, 6, 1525938739, 6, '2018-05-10 07:52:19'),
(284, 119, '2000000.00', 'salary loan of 2m recommended for 14mths', 3, 6, 1525939024, 6, '2018-05-10 07:57:04'),
(285, 111, '10000000.00', 'salary loan of 10m recommended for 18mths', 3, 6, 1525939071, 6, '2018-05-10 07:57:51'),
(286, 114, '800000.00', '800,000 recommended for 6mths', 3, 6, 1525939153, 6, '2018-05-10 07:59:13'),
(287, 113, '600000.00', '800,000 recommended for 4mths', 3, 6, 1525939393, 6, '2018-05-10 08:03:13'),
(288, 118, '500000.00', '500,000 recommended for 6mths', 3, 6, 1525939681, 6, '2018-05-10 08:08:01'),
(289, 117, '1000000.00', '1m recommended for 6mths', 3, 1, 1525941728, 1, '2018-05-10 08:42:08'),
(290, 116, '1000000.00', '1m recommended for 6mths', 3, 1, 1525941750, 1, '2018-05-10 08:42:30'),
(291, 115, '1000000.00', '1m recommended for 6mths', 3, 1, 1525941766, 1, '2018-05-10 08:42:46'),
(292, 112, '1500000.00', '1.5m recommended for 6mths', 3, 1, 1525941823, 1, '2018-05-10 08:43:43'),
(293, 110, '1000000.00', '1m recommended for 6mths', 3, 1, 1525941999, 1, '2018-05-10 08:46:39'),
(294, 109, '9910000.00', '9,910,000m recommended for 18mths', 3, 1, 1525942050, 1, '2018-05-10 08:47:30'),
(295, 108, '3000000.00', '3m recommended for 18mths', 3, 1, 1525942252, 1, '2018-05-10 08:50:52'),
(296, 106, '4838363.00', '4,838,363 recommended for 12mths', 3, 1, 1525942296, 1, '2018-05-10 08:51:36'),
(297, 105, '6200000.00', '6,200,000 recommended for 24mths', 3, 1, 1525942798, 1, '2018-05-10 08:59:58'),
(298, 104, '5880000.00', '5,880,000 recommended for 18mths', 3, 1, 1525942886, 1, '2018-05-10 09:01:26'),
(299, 103, '4200000.00', '4,200,000 recommended for 12mths', 3, 1, 1525942914, 1, '2018-05-10 09:01:54'),
(300, 102, '400000.00', '400,000 recommended for 1mths', 3, 1, 1525942952, 1, '2018-05-10 09:02:32'),
(301, 100, '1000000.00', '1m recommended for 6months', 3, 1, 1525943004, 1, '2018-05-10 09:03:24'),
(302, 99, '300000.00', '300,000 recommended for 4months', 3, 1, 1525943038, 1, '2018-05-10 09:03:58'),
(303, 98, '1000000.00', '1m recommended for 1months', 3, 1, 1525943072, 1, '2018-05-10 09:04:32'),
(304, 97, '2200000.00', '2.2m recommended for 10months', 3, 1, 1525943108, 1, '2018-05-10 09:05:08'),
(305, 96, '2212480.00', '2,212,480m recommended for 10months', 3, 1, 1525943513, 1, '2018-05-10 09:11:53'),
(306, 95, '11900000.00', '11,900,000 recommended for 15months', 3, 1, 1525943729, 1, '2018-05-10 09:15:29'),
(307, 94, '6900000.00', '6,900,000 recommended for 15months', 3, 1, 1525943752, 1, '2018-05-10 09:15:52'),
(308, 93, '400000.00', '400,000 recommended for 4months', 3, 1, 1525943804, 1, '2018-05-10 09:16:44'),
(309, 92, '4500000.00', '4.5m recommended for 9months', 3, 1, 1525943846, 1, '2018-05-10 09:17:26'),
(310, 91, '1500000.00', '1.5m recommended for 6months', 3, 1, 1525944748, 1, '2018-05-10 09:32:28'),
(311, 90, '3456200.00', '3,456,200 recommended for 10months', 3, 1, 1525945550, 1, '2018-05-10 09:45:50'),
(312, 89, '800000.00', '800,000 recommended for 7months', 3, 1, 1525945584, 1, '2018-05-10 09:46:24'),
(313, 88, '2750000.00', '2,750,000 recommended for 12months', 3, 1, 1525945677, 1, '2018-05-10 09:47:57'),
(314, 87, '1000000.00', '1m recommended for 6months', 3, 1, 1525945707, 1, '2018-05-10 09:48:27'),
(315, 86, '3000000.00', '3m recommended for 10months', 3, 1, 1525945728, 1, '2018-05-10 09:48:48'),
(316, 85, '2500000.00', '2.5m recommended for 12months', 3, 1, 1525945774, 1, '2018-05-10 09:49:34'),
(317, 84, '1000000.00', '1m recommended for 2months', 3, 1, 1525945798, 1, '2018-05-10 09:49:58'),
(318, 83, '1000000.00', '1m recommended for 6months', 3, 1, 1525945813, 1, '2018-05-10 09:50:13'),
(319, 82, '500000.00', '500,000 recommended for 4months', 3, 1, 1525945838, 1, '2018-05-10 09:50:38'),
(320, 127, '350000.00', '350,000 for 2months', 4, 9, 1525950979, 9, '2018-05-10 11:16:19'),
(321, 80, '500000.00', '500,000 for 6months', 4, 9, 1525951019, 9, '2018-05-10 11:16:59'),
(322, 141, '600000.00', '600,000 for 3months', 4, 9, 1525951293, 9, '2018-05-10 11:21:33'),
(323, 140, '1000000.00', '1,000,000 for 6months', 4, 9, 1525951406, 9, '2018-05-10 11:23:26'),
(324, 138, '1000000.00', '1,000,000 for 6months', 4, 9, 1525951447, 9, '2018-05-10 11:24:07'),
(325, 137, '1000000.00', '1,000,000 for 6months', 4, 9, 1525951592, 9, '2018-05-10 11:26:32'),
(326, 136, '1000000.00', '1m for 12mths recommended', 4, 9, 1525955672, 9, '2018-05-10 12:34:32'),
(327, 135, '500000.00', '500,000 for 6mths recommended', 4, 9, 1525955709, 9, '2018-05-10 12:35:09'),
(328, 133, '1000000.00', '1m for 4mths recommended', 4, 9, 1525955736, 9, '2018-05-10 12:35:36'),
(329, 132, '1000000.00', '1m for 6mths recommended', 4, 9, 1525955875, 9, '2018-05-10 12:37:55'),
(330, 130, '500000.00', '500,000 for 6mths recommended', 4, 9, 1525955916, 9, '2018-05-10 12:38:36'),
(331, 129, '800000.00', '800,000 for 6mths recommended', 4, 9, 1525955936, 9, '2018-05-10 12:38:56'),
(332, 125, '300000.00', '300,000 for 3mths recommended', 4, 9, 1525956915, 9, '2018-05-10 12:55:15'),
(333, 124, '400000.00', '400,000 for 3mths recommended', 4, 9, 1525957094, 9, '2018-05-10 12:58:14'),
(334, 123, '1000000.00', '1m for 1mths recommended', 4, 9, 1525957140, 9, '2018-05-10 12:59:00'),
(335, 114, '800000.00', '800,000 for 6mths recommended', 4, 9, 1525957248, 9, '2018-05-10 13:00:48'),
(336, 113, '600000.00', '600,000 for 4mths recommended', 4, 9, 1525957273, 9, '2018-05-10 13:01:13'),
(337, 118, '500000.00', '500,000 for 6mths recommended', 4, 9, 1525957321, 9, '2018-05-10 13:02:01'),
(338, 117, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525957389, 9, '2018-05-10 13:03:09'),
(339, 116, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525957485, 9, '2018-05-10 13:04:45'),
(340, 115, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525957515, 9, '2018-05-10 13:05:15'),
(341, 110, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525957539, 9, '2018-05-10 13:05:39'),
(342, 102, '400000.00', '400,000 for 1mth recommended', 4, 9, 1525957579, 9, '2018-05-10 13:06:19'),
(343, 100, '1000000.00', '1,000,000 for 6mth recommended', 4, 9, 1525957636, 9, '2018-05-10 13:07:16'),
(344, 99, '300000.00', '300,000 for 6mth recommended', 4, 9, 1525958086, 9, '2018-05-10 13:14:46'),
(345, 98, '1000000.00', '1,000,000 for 1mth recommended', 4, 9, 1525958837, 9, '2018-05-10 13:27:17'),
(346, 93, '400000.00', '400,000 for 1mth recommended', 4, 9, 1525959240, 9, '2018-05-10 13:34:00'),
(347, 89, '800000.00', '800,000 for 7mths recommended', 4, 9, 1525961070, 9, '2018-05-10 14:04:30'),
(348, 87, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525961162, 9, '2018-05-10 14:06:02'),
(349, 84, '1000000.00', '1,000,000 for 2mths recommended', 4, 9, 1525961270, 9, '2018-05-10 14:07:50'),
(350, 83, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525961914, 9, '2018-05-10 14:18:34'),
(351, 82, '500000.00', '500,000 for 4mths recommended', 4, 9, 1525961946, 9, '2018-05-10 14:19:06'),
(352, 81, '500000.00', '500,000 for 6mths recommended', 4, 9, 1525961967, 9, '2018-05-10 14:19:27'),
(353, 78, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525961992, 9, '2018-05-10 14:19:52'),
(354, 77, '400000.00', '400,000 for 6mths recommended', 4, 9, 1525962743, 9, '2018-05-10 14:32:23'),
(355, 76, '500000.00', '500,000 for 6mths recommended', 4, 9, 1525962790, 9, '2018-05-10 14:33:10'),
(356, 75, '700000.00', '700,000 for 6mths recommended', 4, 9, 1525962840, 9, '2018-05-10 14:34:00'),
(357, 72, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525963001, 9, '2018-05-10 14:36:41'),
(358, 70, '1000000.00', '1,000,000 for 6mths recommended', 4, 9, 1525963037, 9, '2018-05-10 14:37:17'),
(359, 63, '1000000.00', '1,000,000 for 12mths recommended', 4, 9, 1525963468, 9, '2018-05-10 14:44:28'),
(360, 59, '300000.00', '300,000 for 2mths recommended', 4, 1, 1525965509, 1, '2018-05-10 15:18:29'),
(361, 58, '500000.00', '500,000 for 5mths', 4, 9, 1525965775, 9, '2018-05-10 15:22:55'),
(362, 57, '300000.00', '300,000 for 6mths', 4, 9, 1525965801, 9, '2018-05-10 15:23:21'),
(363, 142, '5703100.00', '5,703,100 recommended for 12mths', 3, 6, 1526023705, 6, '2018-05-11 07:28:25'),
(364, 139, '2000000.00', '2,000,000 recommended for 12mths', 4, 10, 1526024128, 10, '2018-05-11 07:35:28'),
(365, 134, '2000000.00', '2,000,000 recommended for 8mths', 4, 10, 1526024248, 10, '2018-05-11 07:37:28'),
(366, 128, '4300000.00', '4,300,000 recommended for 24mths', 4, 10, 1526024476, 10, '2018-05-11 07:41:16'),
(367, 126, '3765500.00', '3,765,500 recommended for 12mths', 4, 10, 1526024601, 10, '2018-05-11 07:43:21'),
(368, 126, '3765500.00', '3,765,500 recommended for 12mths', 4, 10, 1526024613, 10, '2018-05-11 07:43:33'),
(369, 122, '4500000.00', '4.5m recommended for 24mths', 4, 10, 1526024754, 10, '2018-05-11 07:45:54'),
(370, 121, '4500000.00', '4.5m recommended for 24mths', 4, 10, 1526024785, 10, '2018-05-11 07:46:25'),
(371, 120, '1700000.00', '1.7m recommended for 8mths', 4, 10, 1526024830, 10, '2018-05-11 07:47:10'),
(372, 119, '2000000.00', '2m recommended for 14mths', 4, 10, 1526025216, 10, '2018-05-11 07:53:36'),
(373, 112, '1500000.00', '1.5m recommended for 6mths', 4, 10, 1526025258, 10, '2018-05-11 07:54:18'),
(374, 108, '3000000.00', '3m recommended for 18mths', 4, 10, 1526025308, 10, '2018-05-11 07:55:08'),
(375, 106, '4838363.00', '4,838,363 recommended for 12mths', 4, 10, 1526025346, 10, '2018-05-11 07:55:46'),
(376, 103, '4200000.00', '4,200,000 recommended for 12mths', 4, 10, 1526025415, 10, '2018-05-11 07:56:55'),
(377, 97, '2200000.00', '2,200,000 recommended for 10mths', 4, 10, 1526025568, 10, '2018-05-11 07:59:28'),
(378, 96, '2212480.00', '2,212,480 recommended for 12mths', 4, 10, 1526025674, 10, '2018-05-11 08:01:14'),
(379, 92, '4500000.00', '4.5m recommended for 9mths', 4, 10, 1526026119, 10, '2018-05-11 08:08:39'),
(380, 91, '1500000.00', '1.5m recommended for 6mths', 4, 10, 1526026169, 10, '2018-05-11 08:09:29'),
(381, 90, '3456200.00', '3,456,200 recommended for 10mths', 4, 10, 1526026242, 10, '2018-05-11 08:10:42'),
(382, 88, '2750000.00', '2,750,000 recommended for 12mths', 4, 10, 1526026279, 10, '2018-05-11 08:11:19'),
(383, 86, '3000000.00', '3m recommended for 10mths', 4, 10, 1526026363, 10, '2018-05-11 08:12:43'),
(384, 85, '2500000.00', '2.5m recommended for 12mths', 4, 10, 1526026394, 10, '2018-05-11 08:13:14'),
(385, 79, '1500000.00', '1.5m recommended for 20mths', 4, 10, 1526026466, 10, '2018-05-11 08:14:26'),
(386, 74, '1500000.00', '1.5m recommended for 10mths', 4, 10, 1526026490, 10, '2018-05-11 08:14:50'),
(387, 73, '2000000.00', '2m recommended for 6mths', 4, 10, 1526026538, 10, '2018-05-11 08:15:38'),
(388, 71, '2000000.00', '2m recommended for 6mths', 4, 10, 1526026585, 10, '2018-05-11 08:16:25'),
(389, 67, '3500000.00', '3.5m recommended for 8mths', 4, 10, 1526026744, 10, '2018-05-11 08:19:04'),
(390, 64, '2015000.00', '2.015m recommended for 12mths', 4, 10, 1526026789, 10, '2018-05-11 08:19:49'),
(391, 61, '2000000.00', '2m recommended for 4mths', 4, 10, 1526026867, 10, '2018-05-11 08:21:07'),
(392, 60, '1600000.00', '1.6m recommended for 12mths', 4, 10, 1526026902, 10, '2018-05-11 08:21:42');

-- --------------------------------------------------------

--
-- Table structure for table `loan_account_fee`
--

CREATE TABLE `loan_account_fee` (
  `id` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `loanProductFeenId` int(11) NOT NULL,
  `feeAmount` decimal(12,2) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_account_fee`
--

INSERT INTO `loan_account_fee` (`id`, `loanAccountId`, `loanProductFeenId`, `feeAmount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 2, '20000.00', 1510825643, 3, '0000-00-00 00:00:00', 3),
(2, 1, 3, '100000.00', 1510825643, 3, '0000-00-00 00:00:00', 3),
(3, 1, 4, '20000.00', 1510825643, 3, '0000-00-00 00:00:00', 3),
(4, 1, 1, '30000.00', 1510825643, 3, '0000-00-00 00:00:00', 3),
(5, 2, 5, '8000.00', 1511264166, 3, '0000-00-00 00:00:00', 3),
(6, 2, 8, '40000.00', 1511264166, 3, '0000-00-00 00:00:00', 3),
(7, 2, 6, '20000.00', 1511264166, 3, '0000-00-00 00:00:00', 3),
(8, 2, 7, '12000.00', 1511264166, 3, '0000-00-00 00:00:00', 3),
(9, 3, 9, '6000.00', 1511266034, 3, '0000-00-00 00:00:00', 3),
(10, 3, 12, '30000.00', 1511266034, 3, '0000-00-00 00:00:00', 3),
(11, 3, 0, '20000.00', 1511266034, 3, '0000-00-00 00:00:00', 3),
(12, 3, 11, '9000.00', 1511266034, 3, '0000-00-00 00:00:00', 3),
(13, 4, 9, '4000.00', 1511266133, 3, '0000-00-00 00:00:00', 3),
(14, 4, 12, '20000.00', 1511266133, 3, '0000-00-00 00:00:00', 3),
(15, 4, 0, '20000.00', 1511266133, 3, '0000-00-00 00:00:00', 3),
(16, 4, 11, '6000.00', 1511266133, 3, '0000-00-00 00:00:00', 3),
(17, 5, 9, '6000.00', 1511266230, 3, '0000-00-00 00:00:00', 3),
(18, 5, 12, '30000.00', 1511266230, 3, '0000-00-00 00:00:00', 3),
(19, 5, 0, '20000.00', 1511266230, 3, '0000-00-00 00:00:00', 3),
(20, 5, 11, '9000.00', 1511266230, 3, '0000-00-00 00:00:00', 3),
(21, 6, 9, '4000.00', 1511266318, 3, '0000-00-00 00:00:00', 3),
(22, 6, 12, '20000.00', 1511266318, 3, '0000-00-00 00:00:00', 3),
(23, 6, 0, '20000.00', 1511266318, 3, '0000-00-00 00:00:00', 3),
(24, 6, 11, '6000.00', 1511266318, 3, '0000-00-00 00:00:00', 3),
(25, 7, 2, '50000.00', 1511332607, 3, '0000-00-00 00:00:00', 3),
(26, 7, 3, '250000.00', 1511332607, 3, '0000-00-00 00:00:00', 3),
(27, 7, 4, '20000.00', 1511332607, 3, '0000-00-00 00:00:00', 3),
(28, 7, 1, '75000.00', 1511332607, 3, '0000-00-00 00:00:00', 3),
(29, 8, 2, '10000.00', 1511955038, 3, '0000-00-00 00:00:00', 3),
(30, 8, 3, '50000.00', 1511955038, 3, '0000-00-00 00:00:00', 3),
(31, 8, 4, '20000.00', 1511955038, 3, '0000-00-00 00:00:00', 3),
(32, 8, 1, '15000.00', 1511955038, 3, '0000-00-00 00:00:00', 3),
(33, 9, 2, '10000.00', 1511955057, 3, '0000-00-00 00:00:00', 3),
(34, 9, 3, '50000.00', 1511955057, 3, '0000-00-00 00:00:00', 3),
(35, 9, 4, '20000.00', 1511955057, 3, '0000-00-00 00:00:00', 3),
(36, 9, 1, '15000.00', 1511955057, 3, '0000-00-00 00:00:00', 3),
(37, 10, 13, '124000.00', 1511956983, 3, '0000-00-00 00:00:00', 3),
(38, 10, 16, '620000.00', 1511956983, 3, '0000-00-00 00:00:00', 3),
(39, 10, 14, '20000.00', 1511956983, 3, '0000-00-00 00:00:00', 3),
(40, 10, 15, '186000.00', 1511956983, 3, '0000-00-00 00:00:00', 3),
(41, 11, 13, '124000.00', 1511957362, 3, '0000-00-00 00:00:00', 3),
(42, 11, 16, '620000.00', 1511957362, 3, '0000-00-00 00:00:00', 3),
(43, 11, 14, '20000.00', 1511957362, 3, '0000-00-00 00:00:00', 3),
(44, 11, 15, '186000.00', 1511957362, 3, '0000-00-00 00:00:00', 3),
(45, 12, 13, '124000.00', 1511958177, 3, '0000-00-00 00:00:00', 3),
(46, 12, 16, '620000.00', 1511958177, 3, '0000-00-00 00:00:00', 3),
(47, 12, 14, '20000.00', 1511958177, 3, '0000-00-00 00:00:00', 3),
(48, 12, 15, '186000.00', 1511958177, 3, '0000-00-00 00:00:00', 3),
(49, 13, 5, '20000.00', 1516798648, 3, '0000-00-00 00:00:00', 3),
(50, 13, 8, '100000.00', 1516798648, 3, '0000-00-00 00:00:00', 3),
(51, 13, 6, '20000.00', 1516798648, 3, '0000-00-00 00:00:00', 3),
(52, 13, 7, '30000.00', 1516798648, 3, '0000-00-00 00:00:00', 3),
(53, 14, 2, '112430.00', 1516856366, 3, '0000-00-00 00:00:00', 3),
(54, 14, 3, '562150.00', 1516856366, 3, '0000-00-00 00:00:00', 3),
(55, 14, 4, '20000.00', 1516856366, 3, '0000-00-00 00:00:00', 3),
(56, 14, 1, '168645.00', 1516856366, 3, '0000-00-00 00:00:00', 3),
(57, 15, 2, '463748.00', 1516857967, 3, '0000-00-00 00:00:00', 3),
(58, 15, 3, '2318740.00', 1516857967, 3, '0000-00-00 00:00:00', 3),
(59, 15, 4, '20000.00', 1516857967, 3, '0000-00-00 00:00:00', 3),
(60, 15, 1, '695622.00', 1516857967, 3, '0000-00-00 00:00:00', 3),
(61, 16, 17, '100000.00', 1516858420, 3, '0000-00-00 00:00:00', 3),
(62, 16, 18, '500000.00', 1516858420, 3, '0000-00-00 00:00:00', 3),
(63, 16, 19, '20000.00', 1516858420, 3, '0000-00-00 00:00:00', 3),
(64, 16, 20, '150000.00', 1516858420, 3, '0000-00-00 00:00:00', 3),
(65, 17, 2, '20000.00', 1516859338, 3, '0000-00-00 00:00:00', 3),
(66, 17, 3, '100000.00', 1516859338, 3, '0000-00-00 00:00:00', 3),
(67, 17, 4, '20000.00', 1516859338, 3, '0000-00-00 00:00:00', 3),
(68, 17, 1, '30000.00', 1516859338, 3, '0000-00-00 00:00:00', 3),
(69, 18, 2, '600000.00', 1516869840, 8, '0000-00-00 00:00:00', 8),
(70, 18, 3, '3000000.00', 1516869840, 8, '0000-00-00 00:00:00', 8),
(71, 18, 4, '20000.00', 1516869840, 8, '0000-00-00 00:00:00', 8),
(72, 18, 1, '900000.00', 1516869840, 8, '0000-00-00 00:00:00', 8),
(73, 19, 2, '100000.00', 1517048803, 1, '0000-00-00 00:00:00', 1),
(74, 19, 3, '500000.00', 1517048803, 1, '0000-00-00 00:00:00', 1),
(75, 19, 4, '20000.00', 1517048803, 1, '0000-00-00 00:00:00', 1),
(76, 19, 1, '150000.00', 1517048803, 1, '0000-00-00 00:00:00', 1),
(77, 20, 2, '16000.00', 1517049870, 8, '0000-00-00 00:00:00', 8),
(78, 20, 3, '80000.00', 1517049870, 8, '0000-00-00 00:00:00', 8),
(79, 20, 4, '20000.00', 1517049870, 8, '0000-00-00 00:00:00', 8),
(80, 20, 1, '24000.00', 1517049870, 8, '0000-00-00 00:00:00', 8),
(81, 21, 2, '253540.00', 1517986659, 8, '0000-00-00 00:00:00', 8),
(82, 21, 3, '1267700.00', 1517986659, 8, '0000-00-00 00:00:00', 8),
(83, 21, 4, '20000.00', 1517986659, 8, '0000-00-00 00:00:00', 8),
(84, 21, 1, '380310.00', 1517986659, 8, '0000-00-00 00:00:00', 8),
(85, 22, 2, '24000.00', 1520338097, 3, '0000-00-00 00:00:00', 3),
(86, 22, 3, '120000.00', 1520338097, 3, '0000-00-00 00:00:00', 3),
(87, 22, 4, '20000.00', 1520338097, 3, '0000-00-00 00:00:00', 3),
(88, 22, 1, '36000.00', 1520338097, 3, '0000-00-00 00:00:00', 3),
(89, 23, 2, '100000.00', 1520338838, 3, '0000-00-00 00:00:00', 3),
(90, 23, 3, '500000.00', 1520338838, 3, '0000-00-00 00:00:00', 3),
(91, 23, 4, '20000.00', 1520338838, 3, '0000-00-00 00:00:00', 3),
(92, 23, 1, '150000.00', 1520338838, 3, '0000-00-00 00:00:00', 3),
(93, 24, 2, '20000.00', 1520343477, 3, '0000-00-00 00:00:00', 3),
(94, 24, 3, '100000.00', 1520343477, 3, '0000-00-00 00:00:00', 3),
(95, 24, 4, '20000.00', 1520343477, 3, '0000-00-00 00:00:00', 3),
(96, 24, 1, '30000.00', 1520343477, 3, '0000-00-00 00:00:00', 3),
(97, 25, 2, '40000.00', 1521630522, 3, '0000-00-00 00:00:00', 3),
(98, 25, 3, '200000.00', 1521630522, 3, '0000-00-00 00:00:00', 3),
(99, 25, 4, '20000.00', 1521630522, 3, '0000-00-00 00:00:00', 3),
(100, 25, 1, '60000.00', 1521630522, 3, '0000-00-00 00:00:00', 3),
(101, 26, 2, '60000.00', 1521632226, 3, '0000-00-00 00:00:00', 3),
(102, 26, 3, '300000.00', 1521632226, 3, '0000-00-00 00:00:00', 3),
(103, 26, 4, '20000.00', 1521632226, 3, '0000-00-00 00:00:00', 3),
(104, 26, 1, '90000.00', 1521632226, 3, '0000-00-00 00:00:00', 3),
(105, 27, 2, '10000.00', 1521632660, 3, '0000-00-00 00:00:00', 3),
(106, 27, 3, '50000.00', 1521632660, 3, '0000-00-00 00:00:00', 3),
(107, 27, 4, '20000.00', 1521632660, 3, '0000-00-00 00:00:00', 3),
(108, 27, 1, '15000.00', 1521632660, 3, '0000-00-00 00:00:00', 3),
(109, 28, 2, '20000.00', 1521633121, 3, '0000-00-00 00:00:00', 3),
(110, 28, 3, '100000.00', 1521633121, 3, '0000-00-00 00:00:00', 3),
(111, 28, 4, '20000.00', 1521633121, 3, '0000-00-00 00:00:00', 3),
(112, 28, 1, '30000.00', 1521633121, 3, '0000-00-00 00:00:00', 3),
(113, 29, 2, '20000.00', 1521648931, 8, '0000-00-00 00:00:00', 8),
(114, 29, 3, '100000.00', 1521648931, 8, '0000-00-00 00:00:00', 8),
(115, 29, 4, '20000.00', 1521648931, 8, '0000-00-00 00:00:00', 8),
(116, 29, 1, '30000.00', 1521648931, 8, '0000-00-00 00:00:00', 8),
(117, 30, 0, '40000.00', 1521707841, 8, '0000-00-00 00:00:00', 8),
(118, 30, 0, '200000.00', 1521707841, 8, '0000-00-00 00:00:00', 8),
(119, 30, 0, '20000.00', 1521707841, 8, '0000-00-00 00:00:00', 8),
(120, 30, 0, '60000.00', 1521707841, 8, '0000-00-00 00:00:00', 8),
(121, 31, 2, '10000.00', 1522922275, 8, '0000-00-00 00:00:00', 8),
(122, 31, 3, '50000.00', 1522922275, 8, '0000-00-00 00:00:00', 8),
(123, 31, 4, '20000.00', 1522922275, 8, '0000-00-00 00:00:00', 8),
(124, 31, 1, '15000.00', 1522922275, 8, '0000-00-00 00:00:00', 8),
(125, 32, 2, '14000.00', 1523706240, 8, '0000-00-00 00:00:00', 8),
(126, 32, 3, '70000.00', 1523706240, 8, '0000-00-00 00:00:00', 8),
(127, 32, 0, '20000.00', 1523706240, 8, '0000-00-00 00:00:00', 8),
(128, 32, 1, '21000.00', 1523706240, 8, '0000-00-00 00:00:00', 8),
(129, 33, 5, '10000.00', 1523713778, 1, '0000-00-00 00:00:00', 1),
(130, 33, 0, '50000.00', 1523713778, 1, '0000-00-00 00:00:00', 1),
(131, 33, 0, '20000.00', 1523713778, 1, '0000-00-00 00:00:00', 1),
(132, 33, 7, '15000.00', 1523713778, 1, '0000-00-00 00:00:00', 1),
(133, 34, 2, '30000.00', 1523851639, 1, '0000-00-00 00:00:00', 1),
(134, 34, 0, '150000.00', 1523851639, 1, '0000-00-00 00:00:00', 1),
(135, 34, 4, '20000.00', 1523851639, 1, '0000-00-00 00:00:00', 1),
(136, 34, 1, '45000.00', 1523851639, 1, '0000-00-00 00:00:00', 1),
(137, 35, 2, '10000.00', 1523853078, 1, '0000-00-00 00:00:00', 1),
(138, 35, 0, '50000.00', 1523853078, 1, '0000-00-00 00:00:00', 1),
(139, 35, 4, '20000.00', 1523853079, 1, '0000-00-00 00:00:00', 1),
(140, 35, 1, '15000.00', 1523853079, 1, '0000-00-00 00:00:00', 1),
(141, 36, 2, '10000.00', 1524040070, 1, '0000-00-00 00:00:00', 1),
(142, 36, 0, '50000.00', 1524040070, 1, '0000-00-00 00:00:00', 1),
(143, 36, 0, '20000.00', 1524040070, 1, '0000-00-00 00:00:00', 1),
(144, 36, 1, '15000.00', 1524040070, 1, '0000-00-00 00:00:00', 1),
(145, 37, 2, '30000.00', 1524114017, 1, '0000-00-00 00:00:00', 1),
(146, 37, 0, '150000.00', 1524114017, 1, '0000-00-00 00:00:00', 1),
(147, 37, 0, '20000.00', 1524114017, 1, '0000-00-00 00:00:00', 1),
(148, 37, 1, '45000.00', 1524114017, 1, '0000-00-00 00:00:00', 1),
(149, 38, 13, '90000.00', 1524115834, 1, '0000-00-00 00:00:00', 1),
(150, 38, 16, '450000.00', 1524115834, 1, '0000-00-00 00:00:00', 1),
(151, 38, 14, '20000.00', 1524115834, 1, '0000-00-00 00:00:00', 1),
(152, 38, 15, '135000.00', 1524115834, 1, '0000-00-00 00:00:00', 1),
(153, 39, 2, '14000.00', 1524115925, 1, '0000-00-00 00:00:00', 1),
(154, 39, 3, '70000.00', 1524115925, 1, '0000-00-00 00:00:00', 1),
(155, 39, 4, '20000.00', 1524115925, 1, '0000-00-00 00:00:00', 1),
(156, 39, 1, '21000.00', 1524115925, 1, '0000-00-00 00:00:00', 1),
(157, 40, 2, '20000.00', 1524116611, 1, '0000-00-00 00:00:00', 1),
(158, 40, 0, '100000.00', 1524116611, 1, '0000-00-00 00:00:00', 1),
(159, 40, 4, '20000.00', 1524116611, 1, '0000-00-00 00:00:00', 1),
(160, 40, 1, '30000.00', 1524116611, 1, '0000-00-00 00:00:00', 1),
(161, 41, 2, '20000.00', 1524116706, 1, '0000-00-00 00:00:00', 1),
(162, 41, 3, '100000.00', 1524116706, 1, '0000-00-00 00:00:00', 1),
(163, 41, 4, '20000.00', 1524116706, 1, '0000-00-00 00:00:00', 1),
(164, 41, 1, '30000.00', 1524116706, 1, '0000-00-00 00:00:00', 1),
(165, 42, 2, '30000.00', 1524118238, 1, '0000-00-00 00:00:00', 1),
(166, 42, 3, '150000.00', 1524118238, 1, '0000-00-00 00:00:00', 1),
(167, 42, 4, '20000.00', 1524118238, 1, '0000-00-00 00:00:00', 1),
(168, 42, 1, '45000.00', 1524118238, 1, '0000-00-00 00:00:00', 1),
(169, 43, 2, '16000.00', 1524118593, 1, '0000-00-00 00:00:00', 1),
(170, 43, 3, '80000.00', 1524118593, 1, '0000-00-00 00:00:00', 1),
(171, 43, 4, '20000.00', 1524118593, 1, '0000-00-00 00:00:00', 1),
(172, 43, 1, '24000.00', 1524118593, 1, '0000-00-00 00:00:00', 1),
(173, 44, 2, '20000.00', 1524118986, 1, '0000-00-00 00:00:00', 1),
(174, 44, 3, '100000.00', 1524118986, 1, '0000-00-00 00:00:00', 1),
(175, 44, 4, '20000.00', 1524118986, 1, '0000-00-00 00:00:00', 1),
(176, 44, 1, '30000.00', 1524118986, 1, '0000-00-00 00:00:00', 1),
(177, 45, 2, '20000.00', 1524119453, 1, '0000-00-00 00:00:00', 1),
(178, 45, 3, '100000.00', 1524119453, 1, '0000-00-00 00:00:00', 1),
(179, 45, 4, '20000.00', 1524119453, 1, '0000-00-00 00:00:00', 1),
(180, 45, 1, '30000.00', 1524119453, 1, '0000-00-00 00:00:00', 1),
(181, 46, 2, '20000.00', 1524119989, 1, '0000-00-00 00:00:00', 1),
(182, 46, 3, '100000.00', 1524119989, 1, '0000-00-00 00:00:00', 1),
(183, 46, 4, '20000.00', 1524119989, 1, '0000-00-00 00:00:00', 1),
(184, 46, 1, '30000.00', 1524119989, 1, '0000-00-00 00:00:00', 1),
(185, 47, 2, '100000.00', 1524122962, 1, '0000-00-00 00:00:00', 1),
(186, 47, 3, '500000.00', 1524122962, 1, '0000-00-00 00:00:00', 1),
(187, 47, 4, '20000.00', 1524122962, 1, '0000-00-00 00:00:00', 1),
(188, 47, 1, '150000.00', 1524122962, 1, '0000-00-00 00:00:00', 1),
(189, 48, 2, '20000.00', 1524123761, 1, '0000-00-00 00:00:00', 1),
(190, 48, 3, '100000.00', 1524123761, 1, '0000-00-00 00:00:00', 1),
(191, 48, 4, '20000.00', 1524123761, 1, '0000-00-00 00:00:00', 1),
(192, 48, 1, '30000.00', 1524123761, 1, '0000-00-00 00:00:00', 1),
(193, 49, 2, '30000.00', 1524126261, 1, '0000-00-00 00:00:00', 1),
(194, 49, 3, '150000.00', 1524126261, 1, '0000-00-00 00:00:00', 1),
(195, 49, 4, '20000.00', 1524126261, 1, '0000-00-00 00:00:00', 1),
(196, 49, 1, '45000.00', 1524126261, 1, '0000-00-00 00:00:00', 1),
(197, 50, 2, '6000.00', 1524126508, 1, '0000-00-00 00:00:00', 1),
(198, 50, 0, '30000.00', 1524126508, 1, '0000-00-00 00:00:00', 1),
(199, 50, 4, '20000.00', 1524126508, 1, '0000-00-00 00:00:00', 1),
(200, 50, 1, '9000.00', 1524126508, 1, '0000-00-00 00:00:00', 1),
(201, 51, 9, '20000.00', 1524132919, 1, '0000-00-00 00:00:00', 1),
(202, 51, 12, '100000.00', 1524132919, 1, '0000-00-00 00:00:00', 1),
(203, 51, 0, '20000.00', 1524132919, 1, '0000-00-00 00:00:00', 1),
(204, 51, 11, '30000.00', 1524132919, 1, '0000-00-00 00:00:00', 1),
(205, 52, 2, '14000.00', 1524133760, 1, '0000-00-00 00:00:00', 1),
(206, 52, 3, '70000.00', 1524133760, 1, '0000-00-00 00:00:00', 1),
(207, 52, 4, '20000.00', 1524133760, 1, '0000-00-00 00:00:00', 1),
(208, 52, 1, '21000.00', 1524133760, 1, '0000-00-00 00:00:00', 1),
(209, 53, 2, '20000.00', 1524134230, 1, '0000-00-00 00:00:00', 1),
(210, 53, 3, '100000.00', 1524134230, 1, '0000-00-00 00:00:00', 1),
(211, 53, 4, '20000.00', 1524134230, 1, '0000-00-00 00:00:00', 1),
(212, 53, 1, '30000.00', 1524134230, 1, '0000-00-00 00:00:00', 1),
(213, 54, 2, '16000.00', 1524137889, 1, '0000-00-00 00:00:00', 1),
(214, 54, 3, '80000.00', 1524137889, 1, '0000-00-00 00:00:00', 1),
(215, 54, 4, '20000.00', 1524137889, 1, '0000-00-00 00:00:00', 1),
(216, 54, 1, '24000.00', 1524137889, 1, '0000-00-00 00:00:00', 1),
(217, 55, 2, '5000.00', 1524139458, 1, '0000-00-00 00:00:00', 1),
(218, 55, 3, '25000.00', 1524139458, 1, '0000-00-00 00:00:00', 1),
(219, 55, 4, '20000.00', 1524139458, 1, '0000-00-00 00:00:00', 1),
(220, 55, 1, '7500.00', 1524139458, 1, '0000-00-00 00:00:00', 1),
(221, 56, 2, '10000.00', 1524139992, 1, '0000-00-00 00:00:00', 1),
(222, 56, 3, '50000.00', 1524139992, 1, '0000-00-00 00:00:00', 1),
(223, 56, 4, '20000.00', 1524139992, 1, '0000-00-00 00:00:00', 1),
(224, 56, 1, '15000.00', 1524139992, 1, '0000-00-00 00:00:00', 1),
(225, 57, 2, '6000.00', 1524205358, 1, '0000-00-00 00:00:00', 1),
(226, 57, 3, '30000.00', 1524205358, 1, '0000-00-00 00:00:00', 1),
(227, 57, 4, '20000.00', 1524205358, 1, '0000-00-00 00:00:00', 1),
(228, 57, 1, '9000.00', 1524205358, 1, '0000-00-00 00:00:00', 1),
(229, 58, 2, '10000.00', 1524205726, 1, '0000-00-00 00:00:00', 1),
(230, 58, 0, '50000.00', 1524205726, 1, '0000-00-00 00:00:00', 1),
(231, 58, 4, '20000.00', 1524205726, 1, '0000-00-00 00:00:00', 1),
(232, 58, 1, '15000.00', 1524205726, 1, '0000-00-00 00:00:00', 1),
(233, 59, 2, '6000.00', 1524206020, 1, '0000-00-00 00:00:00', 1),
(234, 59, 0, '30000.00', 1524206020, 1, '0000-00-00 00:00:00', 1),
(235, 59, 4, '20000.00', 1524206020, 1, '0000-00-00 00:00:00', 1),
(236, 59, 1, '9000.00', 1524206020, 1, '0000-00-00 00:00:00', 1),
(237, 60, 2, '32000.00', 1524390055, 1, '0000-00-00 00:00:00', 1),
(238, 60, 3, '160000.00', 1524390055, 1, '0000-00-00 00:00:00', 1),
(239, 60, 4, '20000.00', 1524390055, 1, '0000-00-00 00:00:00', 1),
(240, 60, 1, '48000.00', 1524390055, 1, '0000-00-00 00:00:00', 1),
(241, 61, 2, '40000.00', 1524390511, 1, '0000-00-00 00:00:00', 1),
(242, 61, 0, '200000.00', 1524390511, 1, '0000-00-00 00:00:00', 1),
(243, 61, 4, '20000.00', 1524390511, 1, '0000-00-00 00:00:00', 1),
(244, 61, 1, '60000.00', 1524390511, 1, '0000-00-00 00:00:00', 1),
(245, 62, 2, '20000.00', 1524390714, 1, '0000-00-00 00:00:00', 1),
(246, 62, 0, '100000.00', 1524390714, 1, '0000-00-00 00:00:00', 1),
(247, 62, 4, '20000.00', 1524390714, 1, '0000-00-00 00:00:00', 1),
(248, 62, 1, '30000.00', 1524390714, 1, '0000-00-00 00:00:00', 1),
(249, 63, 2, '20000.00', 1524390826, 1, '0000-00-00 00:00:00', 1),
(250, 63, 0, '100000.00', 1524390826, 1, '0000-00-00 00:00:00', 1),
(251, 63, 4, '20000.00', 1524390826, 1, '0000-00-00 00:00:00', 1),
(252, 63, 1, '30000.00', 1524390826, 1, '0000-00-00 00:00:00', 1),
(253, 64, 2, '40300.00', 1524391156, 1, '0000-00-00 00:00:00', 1),
(254, 64, 3, '201500.00', 1524391156, 1, '0000-00-00 00:00:00', 1),
(255, 64, 4, '20000.00', 1524391156, 1, '0000-00-00 00:00:00', 1),
(256, 64, 1, '60450.00', 1524391156, 1, '0000-00-00 00:00:00', 1),
(257, 65, 2, '70000.00', 1524392134, 1, '0000-00-00 00:00:00', 1),
(258, 65, 3, '350000.00', 1524392134, 1, '0000-00-00 00:00:00', 1),
(259, 65, 4, '20000.00', 1524392134, 1, '0000-00-00 00:00:00', 1),
(260, 65, 1, '105000.00', 1524392134, 1, '0000-00-00 00:00:00', 1),
(261, 66, 2, '70000.00', 1524392391, 1, '0000-00-00 00:00:00', 1),
(262, 66, 3, '350000.00', 1524392391, 1, '0000-00-00 00:00:00', 1),
(263, 66, 4, '20000.00', 1524392391, 1, '0000-00-00 00:00:00', 1),
(264, 66, 1, '105000.00', 1524392391, 1, '0000-00-00 00:00:00', 1),
(265, 67, 2, '70000.00', 1524392543, 1, '0000-00-00 00:00:00', 1),
(266, 67, 3, '350000.00', 1524392543, 1, '0000-00-00 00:00:00', 1),
(267, 67, 4, '20000.00', 1524392543, 1, '0000-00-00 00:00:00', 1),
(268, 67, 1, '105000.00', 1524392543, 1, '0000-00-00 00:00:00', 1),
(269, 68, 2, '170000.00', 1524462366, 1, '0000-00-00 00:00:00', 1),
(270, 68, 3, '850000.00', 1524462366, 1, '0000-00-00 00:00:00', 1),
(271, 68, 4, '20000.00', 1524462366, 1, '0000-00-00 00:00:00', 1),
(272, 68, 1, '255000.00', 1524462366, 1, '0000-00-00 00:00:00', 1),
(273, 69, 2, '20000.00', 1524472613, 1, '0000-00-00 00:00:00', 1),
(274, 69, 3, '100000.00', 1524472613, 1, '0000-00-00 00:00:00', 1),
(275, 69, 4, '20000.00', 1524472613, 1, '0000-00-00 00:00:00', 1),
(276, 69, 1, '30000.00', 1524472613, 1, '0000-00-00 00:00:00', 1),
(277, 70, 2, '20000.00', 1524472787, 1, '0000-00-00 00:00:00', 1),
(278, 70, 0, '100000.00', 1524472787, 1, '0000-00-00 00:00:00', 1),
(279, 70, 4, '20000.00', 1524472787, 1, '0000-00-00 00:00:00', 1),
(280, 70, 1, '30000.00', 1524472787, 1, '0000-00-00 00:00:00', 1),
(281, 71, 2, '40000.00', 1524473016, 1, '0000-00-00 00:00:00', 1),
(282, 71, 3, '200000.00', 1524473016, 1, '0000-00-00 00:00:00', 1),
(283, 71, 4, '20000.00', 1524473016, 1, '0000-00-00 00:00:00', 1),
(284, 71, 1, '60000.00', 1524473016, 1, '0000-00-00 00:00:00', 1),
(285, 72, 2, '20000.00', 1524473235, 1, '0000-00-00 00:00:00', 1),
(286, 72, 0, '100000.00', 1524473235, 1, '0000-00-00 00:00:00', 1),
(287, 72, 4, '20000.00', 1524473235, 1, '0000-00-00 00:00:00', 1),
(288, 72, 1, '30000.00', 1524473235, 1, '0000-00-00 00:00:00', 1),
(289, 73, 2, '40000.00', 1524477493, 1, '0000-00-00 00:00:00', 1),
(290, 73, 3, '200000.00', 1524477493, 1, '0000-00-00 00:00:00', 1),
(291, 73, 4, '20000.00', 1524477493, 1, '0000-00-00 00:00:00', 1),
(292, 73, 1, '60000.00', 1524477493, 1, '0000-00-00 00:00:00', 1),
(293, 74, 2, '30000.00', 1524547427, 1, '0000-00-00 00:00:00', 1),
(294, 74, 3, '150000.00', 1524547427, 1, '0000-00-00 00:00:00', 1),
(295, 74, 4, '20000.00', 1524547427, 1, '0000-00-00 00:00:00', 1),
(296, 74, 1, '45000.00', 1524547427, 1, '0000-00-00 00:00:00', 1),
(297, 75, 2, '14000.00', 1524547749, 1, '0000-00-00 00:00:00', 1),
(298, 75, 3, '70000.00', 1524547749, 1, '0000-00-00 00:00:00', 1),
(299, 75, 4, '20000.00', 1524547749, 1, '0000-00-00 00:00:00', 1),
(300, 75, 1, '21000.00', 1524547749, 1, '0000-00-00 00:00:00', 1),
(301, 76, 2, '10000.00', 1524550206, 1, '0000-00-00 00:00:00', 1),
(302, 76, 3, '50000.00', 1524550206, 1, '0000-00-00 00:00:00', 1),
(303, 76, 4, '20000.00', 1524550206, 1, '0000-00-00 00:00:00', 1),
(304, 76, 1, '15000.00', 1524550206, 1, '0000-00-00 00:00:00', 1),
(305, 77, 2, '8000.00', 1524550418, 1, '0000-00-00 00:00:00', 1),
(306, 77, 3, '40000.00', 1524550418, 1, '0000-00-00 00:00:00', 1),
(307, 77, 4, '20000.00', 1524550418, 1, '0000-00-00 00:00:00', 1),
(308, 77, 1, '12000.00', 1524550418, 1, '0000-00-00 00:00:00', 1),
(309, 78, 2, '20000.00', 1524550881, 1, '0000-00-00 00:00:00', 1),
(310, 78, 3, '100000.00', 1524550881, 1, '0000-00-00 00:00:00', 1),
(311, 78, 4, '20000.00', 1524550881, 1, '0000-00-00 00:00:00', 1),
(312, 78, 1, '30000.00', 1524550881, 1, '0000-00-00 00:00:00', 1),
(313, 79, 2, '30000.00', 1524743160, 1, '0000-00-00 00:00:00', 1),
(314, 79, 3, '150000.00', 1524743160, 1, '0000-00-00 00:00:00', 1),
(315, 79, 4, '20000.00', 1524743160, 1, '0000-00-00 00:00:00', 1),
(316, 79, 1, '45000.00', 1524743160, 1, '0000-00-00 00:00:00', 1),
(317, 80, 2, '10000.00', 1524744999, 1, '0000-00-00 00:00:00', 1),
(318, 80, 3, '50000.00', 1524744999, 1, '0000-00-00 00:00:00', 1),
(319, 80, 4, '20000.00', 1524744999, 1, '0000-00-00 00:00:00', 1),
(320, 80, 1, '15000.00', 1524744999, 1, '0000-00-00 00:00:00', 1),
(321, 81, 2, '10000.00', 1525240885, 1, '0000-00-00 00:00:00', 1),
(322, 81, 3, '50000.00', 1525240885, 1, '0000-00-00 00:00:00', 1),
(323, 81, 4, '20000.00', 1525240885, 1, '0000-00-00 00:00:00', 1),
(324, 81, 1, '15000.00', 1525240885, 1, '0000-00-00 00:00:00', 1),
(325, 82, 2, '10000.00', 1525240987, 1, '0000-00-00 00:00:00', 1),
(326, 82, 3, '50000.00', 1525240987, 1, '0000-00-00 00:00:00', 1),
(327, 82, 4, '20000.00', 1525240987, 1, '0000-00-00 00:00:00', 1),
(328, 82, 1, '15000.00', 1525240987, 1, '0000-00-00 00:00:00', 1),
(329, 83, 2, '20000.00', 1525241151, 1, '0000-00-00 00:00:00', 1),
(330, 83, 3, '100000.00', 1525241151, 1, '0000-00-00 00:00:00', 1),
(331, 83, 4, '20000.00', 1525241151, 1, '0000-00-00 00:00:00', 1),
(332, 83, 1, '30000.00', 1525241151, 1, '0000-00-00 00:00:00', 1),
(333, 84, 2, '20000.00', 1525241658, 1, '0000-00-00 00:00:00', 1),
(334, 84, 3, '100000.00', 1525241658, 1, '0000-00-00 00:00:00', 1),
(335, 84, 4, '20000.00', 1525241658, 1, '0000-00-00 00:00:00', 1),
(336, 84, 1, '30000.00', 1525241658, 1, '0000-00-00 00:00:00', 1),
(337, 85, 2, '50000.00', 1525241788, 1, '0000-00-00 00:00:00', 1),
(338, 85, 3, '250000.00', 1525241788, 1, '0000-00-00 00:00:00', 1),
(339, 85, 4, '20000.00', 1525241788, 1, '0000-00-00 00:00:00', 1),
(340, 85, 1, '75000.00', 1525241788, 1, '0000-00-00 00:00:00', 1),
(341, 86, 2, '60000.00', 1525242130, 1, '0000-00-00 00:00:00', 1),
(342, 86, 0, '300000.00', 1525242130, 1, '0000-00-00 00:00:00', 1),
(343, 86, 4, '20000.00', 1525242130, 1, '0000-00-00 00:00:00', 1),
(344, 86, 1, '90000.00', 1525242130, 1, '0000-00-00 00:00:00', 1),
(345, 87, 2, '20000.00', 1525250425, 1, '0000-00-00 00:00:00', 1),
(346, 87, 3, '100000.00', 1525250425, 1, '0000-00-00 00:00:00', 1),
(347, 87, 4, '20000.00', 1525250425, 1, '0000-00-00 00:00:00', 1),
(348, 87, 1, '30000.00', 1525250425, 1, '0000-00-00 00:00:00', 1),
(349, 88, 2, '55000.00', 1525251039, 1, '0000-00-00 00:00:00', 1),
(350, 88, 3, '275000.00', 1525251039, 1, '0000-00-00 00:00:00', 1),
(351, 88, 4, '20000.00', 1525251039, 1, '0000-00-00 00:00:00', 1),
(352, 88, 1, '82500.00', 1525251039, 1, '0000-00-00 00:00:00', 1),
(353, 89, 2, '16000.00', 1525252872, 1, '0000-00-00 00:00:00', 1),
(354, 89, 3, '80000.00', 1525252872, 1, '0000-00-00 00:00:00', 1),
(355, 89, 4, '20000.00', 1525252872, 1, '0000-00-00 00:00:00', 1),
(356, 89, 1, '24000.00', 1525252872, 1, '0000-00-00 00:00:00', 1),
(357, 90, 2, '69124.00', 1525253666, 1, '0000-00-00 00:00:00', 1),
(358, 90, 3, '345620.00', 1525253666, 1, '0000-00-00 00:00:00', 1),
(359, 90, 4, '20000.00', 1525253666, 1, '0000-00-00 00:00:00', 1),
(360, 90, 1, '103686.00', 1525253666, 1, '0000-00-00 00:00:00', 1),
(361, 91, 2, '30000.00', 1525254904, 1, '0000-00-00 00:00:00', 1),
(362, 91, 3, '150000.00', 1525254904, 1, '0000-00-00 00:00:00', 1),
(363, 91, 4, '20000.00', 1525254904, 1, '0000-00-00 00:00:00', 1),
(364, 91, 1, '45000.00', 1525254904, 1, '0000-00-00 00:00:00', 1),
(365, 92, 13, '90000.00', 1525255250, 1, '0000-00-00 00:00:00', 1),
(366, 92, 0, '450000.00', 1525255250, 1, '0000-00-00 00:00:00', 1),
(367, 92, 14, '20000.00', 1525255250, 1, '0000-00-00 00:00:00', 1),
(368, 92, 15, '135000.00', 1525255250, 1, '0000-00-00 00:00:00', 1),
(369, 93, 2, '8000.00', 1525255832, 1, '0000-00-00 00:00:00', 1),
(370, 93, 3, '40000.00', 1525255832, 1, '0000-00-00 00:00:00', 1),
(371, 93, 4, '20000.00', 1525255832, 1, '0000-00-00 00:00:00', 1),
(372, 93, 1, '12000.00', 1525255832, 1, '0000-00-00 00:00:00', 1),
(373, 94, 2, '138000.00', 1525256102, 1, '0000-00-00 00:00:00', 1),
(374, 94, 3, '690000.00', 1525256102, 1, '0000-00-00 00:00:00', 1),
(375, 94, 4, '20000.00', 1525256102, 1, '0000-00-00 00:00:00', 1),
(376, 94, 1, '207000.00', 1525256102, 1, '0000-00-00 00:00:00', 1),
(377, 95, 2, '238000.00', 1525256301, 1, '0000-00-00 00:00:00', 1),
(378, 95, 0, '1190000.00', 1525256301, 1, '0000-00-00 00:00:00', 1),
(379, 95, 4, '20000.00', 1525256301, 1, '0000-00-00 00:00:00', 1),
(380, 95, 1, '357000.00', 1525256301, 1, '0000-00-00 00:00:00', 1),
(381, 96, 2, '44249.60', 1525256605, 1, '0000-00-00 00:00:00', 1),
(382, 96, 0, '221248.00', 1525256605, 1, '0000-00-00 00:00:00', 1),
(383, 96, 4, '20000.00', 1525256605, 1, '0000-00-00 00:00:00', 1),
(384, 96, 1, '66374.40', 1525256605, 1, '0000-00-00 00:00:00', 1),
(385, 97, 13, '44000.00', 1525324904, 1, '0000-00-00 00:00:00', 1),
(386, 97, 0, '220000.00', 1525324904, 1, '0000-00-00 00:00:00', 1),
(387, 97, 14, '20000.00', 1525324904, 1, '0000-00-00 00:00:00', 1),
(388, 97, 15, '66000.00', 1525324904, 1, '0000-00-00 00:00:00', 1),
(389, 98, 2, '20000.00', 1525325211, 1, '0000-00-00 00:00:00', 1),
(390, 98, 3, '100000.00', 1525325211, 1, '0000-00-00 00:00:00', 1),
(391, 98, 4, '20000.00', 1525325211, 1, '0000-00-00 00:00:00', 1),
(392, 98, 1, '30000.00', 1525325211, 1, '0000-00-00 00:00:00', 1),
(393, 99, 2, '6000.00', 1525354842, 1, '0000-00-00 00:00:00', 1),
(394, 99, 3, '30000.00', 1525354842, 1, '0000-00-00 00:00:00', 1),
(395, 99, 4, '20000.00', 1525354842, 1, '0000-00-00 00:00:00', 1),
(396, 99, 1, '9000.00', 1525354842, 1, '0000-00-00 00:00:00', 1),
(397, 100, 2, '20000.00', 1525359671, 1, '0000-00-00 00:00:00', 1),
(398, 100, 3, '100000.00', 1525359671, 1, '0000-00-00 00:00:00', 1),
(399, 100, 4, '20000.00', 1525359671, 1, '0000-00-00 00:00:00', 1),
(400, 100, 1, '30000.00', 1525359671, 1, '0000-00-00 00:00:00', 1),
(401, 101, 2, '20000.00', 1525360448, 1, '0000-00-00 00:00:00', 1),
(402, 101, 3, '100000.00', 1525360448, 1, '0000-00-00 00:00:00', 1),
(403, 101, 4, '20000.00', 1525360448, 1, '0000-00-00 00:00:00', 1),
(404, 101, 1, '30000.00', 1525360448, 1, '0000-00-00 00:00:00', 1),
(405, 102, 2, '8000.00', 1525360548, 1, '0000-00-00 00:00:00', 1),
(406, 102, 3, '40000.00', 1525360548, 1, '0000-00-00 00:00:00', 1),
(407, 102, 4, '20000.00', 1525360548, 1, '0000-00-00 00:00:00', 1),
(408, 102, 1, '12000.00', 1525360548, 1, '0000-00-00 00:00:00', 1),
(409, 103, 2, '84000.00', 1525361002, 1, '0000-00-00 00:00:00', 1),
(410, 103, 0, '420000.00', 1525361002, 1, '0000-00-00 00:00:00', 1),
(411, 103, 4, '20000.00', 1525361002, 1, '0000-00-00 00:00:00', 1),
(412, 103, 1, '126000.00', 1525361002, 1, '0000-00-00 00:00:00', 1),
(413, 104, 2, '117600.00', 1525361203, 1, '0000-00-00 00:00:00', 1),
(414, 104, 0, '588000.00', 1525361203, 1, '0000-00-00 00:00:00', 1),
(415, 104, 4, '20000.00', 1525361203, 1, '0000-00-00 00:00:00', 1),
(416, 104, 1, '176400.00', 1525361203, 1, '0000-00-00 00:00:00', 1),
(417, 105, 13, '124000.00', 1525361790, 1, '0000-00-00 00:00:00', 1),
(418, 105, 16, '620000.00', 1525361790, 1, '0000-00-00 00:00:00', 1),
(419, 105, 14, '20000.00', 1525361790, 1, '0000-00-00 00:00:00', 1),
(420, 105, 15, '186000.00', 1525361790, 1, '0000-00-00 00:00:00', 1),
(421, 106, 2, '96767.26', 1525362227, 1, '0000-00-00 00:00:00', 1),
(422, 106, 0, '483836.30', 1525362227, 1, '0000-00-00 00:00:00', 1),
(423, 106, 4, '20000.00', 1525362227, 1, '0000-00-00 00:00:00', 1),
(424, 106, 1, '145150.89', 1525362227, 1, '0000-00-00 00:00:00', 1),
(425, 107, 13, '60000.00', 1525362607, 1, '0000-00-00 00:00:00', 1),
(426, 107, 0, '300000.00', 1525362607, 1, '0000-00-00 00:00:00', 1),
(427, 107, 14, '20000.00', 1525362607, 1, '0000-00-00 00:00:00', 1),
(428, 107, 15, '90000.00', 1525362607, 1, '0000-00-00 00:00:00', 1),
(429, 108, 13, '60000.00', 1525362690, 1, '0000-00-00 00:00:00', 1),
(430, 108, 0, '300000.00', 1525362690, 1, '0000-00-00 00:00:00', 1),
(431, 108, 14, '20000.00', 1525362690, 1, '0000-00-00 00:00:00', 1),
(432, 108, 15, '90000.00', 1525362690, 1, '0000-00-00 00:00:00', 1),
(433, 109, 2, '198200.00', 1525364219, 1, '0000-00-00 00:00:00', 1),
(434, 109, 0, '991000.00', 1525364219, 1, '0000-00-00 00:00:00', 1),
(435, 109, 4, '20000.00', 1525364219, 1, '0000-00-00 00:00:00', 1),
(436, 109, 1, '297300.00', 1525364219, 1, '0000-00-00 00:00:00', 1),
(437, 110, 2, '20000.00', 1525364643, 1, '0000-00-00 00:00:00', 1),
(438, 110, 3, '100000.00', 1525364643, 1, '0000-00-00 00:00:00', 1),
(439, 110, 4, '20000.00', 1525364643, 1, '0000-00-00 00:00:00', 1),
(440, 110, 1, '30000.00', 1525364643, 1, '0000-00-00 00:00:00', 1),
(441, 111, 13, '200000.00', 1525365580, 1, '0000-00-00 00:00:00', 1),
(442, 111, 0, '1000000.00', 1525365580, 1, '0000-00-00 00:00:00', 1),
(443, 111, 14, '20000.00', 1525365580, 1, '0000-00-00 00:00:00', 1),
(444, 111, 15, '300000.00', 1525365580, 1, '0000-00-00 00:00:00', 1),
(445, 112, 2, '30000.00', 1525365793, 1, '0000-00-00 00:00:00', 1),
(446, 112, 3, '150000.00', 1525365793, 1, '0000-00-00 00:00:00', 1),
(447, 112, 4, '20000.00', 1525365793, 1, '0000-00-00 00:00:00', 1),
(448, 112, 1, '45000.00', 1525365793, 1, '0000-00-00 00:00:00', 1),
(449, 113, 2, '12000.00', 1525367754, 1, '0000-00-00 00:00:00', 1),
(450, 113, 3, '60000.00', 1525367754, 1, '0000-00-00 00:00:00', 1),
(451, 113, 4, '20000.00', 1525367754, 1, '0000-00-00 00:00:00', 1),
(452, 113, 1, '18000.00', 1525367754, 1, '0000-00-00 00:00:00', 1),
(453, 114, 2, '16000.00', 1525367977, 1, '0000-00-00 00:00:00', 1),
(454, 114, 3, '80000.00', 1525367977, 1, '0000-00-00 00:00:00', 1),
(455, 114, 4, '20000.00', 1525367977, 1, '0000-00-00 00:00:00', 1),
(456, 114, 1, '24000.00', 1525367977, 1, '0000-00-00 00:00:00', 1),
(457, 115, 2, '20000.00', 1525413285, 1, '0000-00-00 00:00:00', 1),
(458, 115, 3, '100000.00', 1525413285, 1, '0000-00-00 00:00:00', 1),
(459, 115, 4, '20000.00', 1525413285, 1, '0000-00-00 00:00:00', 1),
(460, 115, 1, '30000.00', 1525413285, 1, '0000-00-00 00:00:00', 1),
(461, 116, 2, '20000.00', 1525413585, 1, '0000-00-00 00:00:00', 1),
(462, 116, 3, '100000.00', 1525413585, 1, '0000-00-00 00:00:00', 1),
(463, 116, 4, '20000.00', 1525413585, 1, '0000-00-00 00:00:00', 1),
(464, 116, 1, '30000.00', 1525413585, 1, '0000-00-00 00:00:00', 1),
(465, 117, 2, '20000.00', 1525414143, 1, '0000-00-00 00:00:00', 1),
(466, 117, 3, '100000.00', 1525414143, 1, '0000-00-00 00:00:00', 1),
(467, 117, 4, '20000.00', 1525414143, 1, '0000-00-00 00:00:00', 1),
(468, 117, 1, '30000.00', 1525414143, 1, '0000-00-00 00:00:00', 1),
(469, 118, 2, '10000.00', 1525414535, 1, '0000-00-00 00:00:00', 1),
(470, 118, 3, '50000.00', 1525414535, 1, '0000-00-00 00:00:00', 1),
(471, 118, 4, '20000.00', 1525414535, 1, '0000-00-00 00:00:00', 1),
(472, 118, 1, '15000.00', 1525414535, 1, '0000-00-00 00:00:00', 1),
(473, 119, 2, '40000.00', 1525415039, 1, '0000-00-00 00:00:00', 1),
(474, 119, 3, '200000.00', 1525415039, 1, '0000-00-00 00:00:00', 1),
(475, 119, 4, '20000.00', 1525415039, 1, '0000-00-00 00:00:00', 1),
(476, 119, 1, '60000.00', 1525415039, 1, '0000-00-00 00:00:00', 1),
(477, 120, 2, '34000.00', 1525415345, 1, '0000-00-00 00:00:00', 1),
(478, 120, 3, '170000.00', 1525415345, 1, '0000-00-00 00:00:00', 1),
(479, 120, 4, '20000.00', 1525415345, 1, '0000-00-00 00:00:00', 1),
(480, 120, 1, '51000.00', 1525415345, 1, '0000-00-00 00:00:00', 1),
(481, 121, 13, '90000.00', 1525415623, 1, '0000-00-00 00:00:00', 1),
(482, 121, 0, '450000.00', 1525415623, 1, '0000-00-00 00:00:00', 1),
(483, 121, 14, '20000.00', 1525415623, 1, '0000-00-00 00:00:00', 1),
(484, 121, 15, '135000.00', 1525415623, 1, '0000-00-00 00:00:00', 1),
(485, 122, 13, '90000.00', 1525416480, 1, '0000-00-00 00:00:00', 1),
(486, 122, 0, '450000.00', 1525416480, 1, '0000-00-00 00:00:00', 1),
(487, 122, 14, '20000.00', 1525416480, 1, '0000-00-00 00:00:00', 1),
(488, 122, 15, '135000.00', 1525416480, 1, '0000-00-00 00:00:00', 1),
(489, 123, 5, '20000.00', 1525872663, 1, '0000-00-00 00:00:00', 1),
(490, 123, 8, '100000.00', 1525872663, 1, '0000-00-00 00:00:00', 1),
(491, 123, 6, '20000.00', 1525872663, 1, '0000-00-00 00:00:00', 1),
(492, 123, 7, '30000.00', 1525872663, 1, '0000-00-00 00:00:00', 1),
(493, 124, 2, '8000.00', 1525873100, 1, '0000-00-00 00:00:00', 1),
(494, 124, 3, '40000.00', 1525873100, 1, '0000-00-00 00:00:00', 1),
(495, 124, 4, '20000.00', 1525873100, 1, '0000-00-00 00:00:00', 1),
(496, 124, 1, '12000.00', 1525873100, 1, '0000-00-00 00:00:00', 1),
(497, 125, 2, '6000.00', 1525874116, 1, '0000-00-00 00:00:00', 1),
(498, 125, 3, '30000.00', 1525874116, 1, '0000-00-00 00:00:00', 1),
(499, 125, 4, '20000.00', 1525874116, 1, '0000-00-00 00:00:00', 1),
(500, 125, 1, '9000.00', 1525874116, 1, '0000-00-00 00:00:00', 1),
(501, 126, 2, '75310.00', 1525874438, 1, '0000-00-00 00:00:00', 1),
(502, 126, 3, '376550.00', 1525874438, 1, '0000-00-00 00:00:00', 1),
(503, 126, 4, '20000.00', 1525874438, 1, '0000-00-00 00:00:00', 1),
(504, 126, 1, '112965.00', 1525874438, 1, '0000-00-00 00:00:00', 1),
(505, 127, 5, '7000.00', 1525875121, 1, '0000-00-00 00:00:00', 1),
(506, 127, 8, '35000.00', 1525875121, 1, '0000-00-00 00:00:00', 1),
(507, 127, 6, '20000.00', 1525875121, 1, '0000-00-00 00:00:00', 1),
(508, 127, 7, '10500.00', 1525875121, 1, '0000-00-00 00:00:00', 1),
(509, 128, 13, '86000.00', 1525875741, 1, '0000-00-00 00:00:00', 1),
(510, 128, 0, '430000.00', 1525875741, 1, '0000-00-00 00:00:00', 1),
(511, 128, 14, '20000.00', 1525875741, 1, '0000-00-00 00:00:00', 1),
(512, 128, 15, '129000.00', 1525875741, 1, '0000-00-00 00:00:00', 1),
(513, 129, 2, '16000.00', 1525877869, 1, '0000-00-00 00:00:00', 1),
(514, 129, 3, '80000.00', 1525877869, 1, '0000-00-00 00:00:00', 1),
(515, 129, 4, '20000.00', 1525877869, 1, '0000-00-00 00:00:00', 1),
(516, 129, 1, '24000.00', 1525877869, 1, '0000-00-00 00:00:00', 1),
(517, 130, 2, '10000.00', 1525877997, 1, '0000-00-00 00:00:00', 1),
(518, 130, 3, '50000.00', 1525877997, 1, '0000-00-00 00:00:00', 1),
(519, 130, 4, '20000.00', 1525877997, 1, '0000-00-00 00:00:00', 1),
(520, 130, 1, '15000.00', 1525877997, 1, '0000-00-00 00:00:00', 1),
(521, 131, 13, '160000.00', 1525881968, 1, '0000-00-00 00:00:00', 1),
(522, 131, 16, '800000.00', 1525881968, 1, '0000-00-00 00:00:00', 1),
(523, 131, 14, '20000.00', 1525881968, 1, '0000-00-00 00:00:00', 1),
(524, 131, 15, '240000.00', 1525881968, 1, '0000-00-00 00:00:00', 1),
(525, 132, 2, '20000.00', 1525883472, 1, '0000-00-00 00:00:00', 1),
(526, 132, 3, '100000.00', 1525883472, 1, '0000-00-00 00:00:00', 1),
(527, 132, 4, '20000.00', 1525883472, 1, '0000-00-00 00:00:00', 1),
(528, 132, 1, '30000.00', 1525883472, 1, '0000-00-00 00:00:00', 1),
(529, 133, 2, '20000.00', 1525883657, 1, '0000-00-00 00:00:00', 1),
(530, 133, 3, '100000.00', 1525883657, 1, '0000-00-00 00:00:00', 1),
(531, 133, 4, '20000.00', 1525883657, 1, '0000-00-00 00:00:00', 1),
(532, 133, 1, '30000.00', 1525883657, 1, '0000-00-00 00:00:00', 1),
(533, 134, 2, '40000.00', 1525883972, 1, '0000-00-00 00:00:00', 1),
(534, 134, 3, '200000.00', 1525883972, 1, '0000-00-00 00:00:00', 1),
(535, 134, 4, '20000.00', 1525883972, 1, '0000-00-00 00:00:00', 1),
(536, 134, 1, '60000.00', 1525883972, 1, '0000-00-00 00:00:00', 1),
(537, 135, 2, '10000.00', 1525884122, 1, '0000-00-00 00:00:00', 1),
(538, 135, 3, '50000.00', 1525884122, 1, '0000-00-00 00:00:00', 1),
(539, 135, 4, '20000.00', 1525884122, 1, '0000-00-00 00:00:00', 1),
(540, 135, 1, '15000.00', 1525884122, 1, '0000-00-00 00:00:00', 1),
(541, 136, 2, '20000.00', 1525885651, 1, '0000-00-00 00:00:00', 1),
(542, 136, 0, '100000.00', 1525885651, 1, '0000-00-00 00:00:00', 1),
(543, 136, 4, '20000.00', 1525885651, 1, '0000-00-00 00:00:00', 1),
(544, 136, 1, '30000.00', 1525885651, 1, '0000-00-00 00:00:00', 1),
(545, 137, 2, '20000.00', 1525885901, 1, '0000-00-00 00:00:00', 1),
(546, 137, 3, '100000.00', 1525885901, 1, '0000-00-00 00:00:00', 1),
(547, 137, 4, '20000.00', 1525885901, 1, '0000-00-00 00:00:00', 1),
(548, 137, 1, '30000.00', 1525885901, 1, '0000-00-00 00:00:00', 1),
(549, 138, 2, '20000.00', 1525886119, 1, '0000-00-00 00:00:00', 1),
(550, 138, 3, '100000.00', 1525886119, 1, '0000-00-00 00:00:00', 1),
(551, 138, 4, '20000.00', 1525886119, 1, '0000-00-00 00:00:00', 1),
(552, 138, 1, '30000.00', 1525886119, 1, '0000-00-00 00:00:00', 1),
(553, 139, 2, '40000.00', 1525886189, 1, '0000-00-00 00:00:00', 1),
(554, 139, 3, '200000.00', 1525886189, 1, '0000-00-00 00:00:00', 1),
(555, 139, 4, '20000.00', 1525886189, 1, '0000-00-00 00:00:00', 1),
(556, 139, 1, '60000.00', 1525886189, 1, '0000-00-00 00:00:00', 1),
(557, 140, 2, '20000.00', 1525886317, 1, '0000-00-00 00:00:00', 1),
(558, 140, 0, '100000.00', 1525886317, 1, '0000-00-00 00:00:00', 1),
(559, 140, 4, '20000.00', 1525886317, 1, '0000-00-00 00:00:00', 1),
(560, 140, 1, '30000.00', 1525886317, 1, '0000-00-00 00:00:00', 1),
(561, 141, 2, '12000.00', 1525886735, 1, '0000-00-00 00:00:00', 1),
(562, 141, 3, '60000.00', 1525886735, 1, '0000-00-00 00:00:00', 1),
(563, 141, 4, '20000.00', 1525886735, 1, '0000-00-00 00:00:00', 1),
(564, 141, 1, '18000.00', 1525886735, 1, '0000-00-00 00:00:00', 1),
(565, 142, 2, '114062.00', 1525887241, 1, '0000-00-00 00:00:00', 1),
(566, 142, 3, '570310.00', 1525887241, 1, '0000-00-00 00:00:00', 1),
(567, 142, 4, '20000.00', 1525887241, 1, '0000-00-00 00:00:00', 1),
(568, 142, 1, '171093.00', 1525887241, 1, '0000-00-00 00:00:00', 1),
(569, 143, 21, '24000.00', 1525929842, 1, '0000-00-00 00:00:00', 1),
(570, 143, 22, '120000.00', 1525929842, 1, '0000-00-00 00:00:00', 1),
(571, 143, 23, '20000.00', 1525929842, 1, '0000-00-00 00:00:00', 1),
(572, 143, 24, '36000.00', 1525929842, 1, '0000-00-00 00:00:00', 1),
(573, 144, 21, '12000.00', 1525929903, 1, '0000-00-00 00:00:00', 1),
(574, 144, 22, '60000.00', 1525929903, 1, '0000-00-00 00:00:00', 1),
(575, 144, 23, '20000.00', 1525929903, 1, '0000-00-00 00:00:00', 1),
(576, 144, 24, '18000.00', 1525929903, 1, '0000-00-00 00:00:00', 1),
(577, 145, 21, '12000.00', 1525929961, 1, '0000-00-00 00:00:00', 1),
(578, 145, 22, '60000.00', 1525929961, 1, '0000-00-00 00:00:00', 1),
(579, 145, 23, '20000.00', 1525929961, 1, '0000-00-00 00:00:00', 1),
(580, 145, 24, '18000.00', 1525929961, 1, '0000-00-00 00:00:00', 1),
(581, 146, 21, '8000.00', 1525930035, 1, '0000-00-00 00:00:00', 1),
(582, 146, 22, '40000.00', 1525930035, 1, '0000-00-00 00:00:00', 1),
(583, 146, 23, '20000.00', 1525930035, 1, '0000-00-00 00:00:00', 1),
(584, 146, 24, '12000.00', 1525930035, 1, '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_account_penalty`
--

CREATE TABLE `loan_account_penalty` (
  `id` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `penaltyCalculationMethod` tinyint(4) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `daysDelayed` tinyint(4) NOT NULL,
  `penaltyTolerancePeriod` tinyint(4) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan accounts are be subjected to';

-- --------------------------------------------------------

--
-- Table structure for table `loan_collateral`
--

CREATE TABLE `loan_collateral` (
  `id` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `itemName` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `itemValue` decimal(15,2) NOT NULL,
  `attachmentUrl` varchar(150) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_collateral`
--

INSERT INTO `loan_collateral` (`id`, `loanAccountId`, `itemName`, `description`, `itemValue`, `attachmentUrl`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 'Deep freezer fridge', 'deep freezer,white in colour,', '600000.00', '', 1510825643, 3, '2017-11-16 09:47:23', 3),
(2, 1, 'Kiosk', 'metalic,red in colour', '850000.00', '', 1510825643, 3, '2017-11-16 09:47:23', 3),
(3, 1, 'Sofar chairs', 'Black with grey designs', '500000.00', '', 1510825643, 3, '2017-11-16 09:47:23', 3),
(4, 1, '14 Inch Tv', 'pyramid type with grey and black coloured housing', '100000.00', '', 1510825643, 3, '2017-11-16 09:47:23', 3),
(5, 2, 'Kibanja', 'Located in Namugongo Nattoko Village', '5000000.00', '', 1511264166, 3, '2017-11-21 11:36:06', 3),
(6, 2, 'Sofa chairs', 'Brown In colour', '300000.00', '', 1511264166, 3, '2017-11-21 11:36:06', 3),
(7, 2, 'TV', '14 Inch with Black and grey housing', '200000.00', '', 1511264166, 3, '2017-11-21 11:36:06', 3),
(8, 7, 'Fridge', 'double door and white in colour of Angella type', '500000.00', '', 1511332607, 3, '2017-11-22 06:36:47', 3),
(9, 7, 'Tv', '21Inch with black and grey housing.Kodama type', '200000.00', '', 1511332607, 3, '2017-11-22 06:36:47', 3),
(10, 7, 'Sofa chairs', 'Grey in colour', '300000.00', '', 1511332607, 3, '2017-11-22 06:36:47', 3),
(11, 7, 'Side board', 'Wooden', '400000.00', '', 1511332607, 3, '2017-11-22 06:36:47', 3),
(12, 8, 'FRIDGE', 'Double door and white in colour', '400000.00', '', 1511955038, 3, '2017-11-29 11:30:38', 3),
(13, 8, 'sowing machine', 'Manual with black and brown wooden frame', '300000.00', '', 1511955038, 3, '2017-11-29 11:30:38', 3),
(14, 9, 'FRIDGE', 'Double door and white in colour', '400000.00', '', 1511955057, 3, '2017-11-29 11:30:57', 3),
(15, 9, 'sowing machine', 'Manual with black and brown wooden frame', '300000.00', '', 1511955057, 3, '2017-11-29 11:30:57', 3),
(16, 10, 'Monthly salary', 'monthly salary from Buganda land board', '2523000.00', '', 1511956984, 3, '2017-11-29 12:03:04', 3),
(17, 11, 'Monthly salary', 'salary from Buganda Land Board', '2523000.00', '', 1511957362, 3, '2017-11-29 12:09:22', 3),
(18, 12, 'Monthly salary ', 'Salary from Buganda Land Board', '2523000.00', '', 1511958177, 3, '2017-11-29 12:22:57', 3),
(19, 13, 'sofaset,sideboard,tv set', 'sofaset brown in colour\r\nDinning set wooden six seater\r\nfridge white double door', '1700000.00', '', 1516798648, 3, '2018-01-24 12:57:28', 3),
(20, 14, 'KIBANJA', 'kibanja in ndejje with tittle to be processed', '15000000.00', '', 1516856366, 3, '2018-01-25 04:59:26', 3),
(21, 15, 'KIBANJA IN MBUYA II', 'KIBANJA OF APPROXIMATELY 0.272 HA LOCATED IN MBUYA II', '36000000.00', '', 1516857967, 3, '2018-01-25 05:26:07', 3),
(22, 16, 'Land tittle', 'land located in Mityana Kiteredde Village 50 acres', '150000000.00', '', 1516858420, 3, '2018-01-25 05:33:40', 3),
(23, 17, 'Sofa Chairs', 'Brown in colour with black designs', '600000.00', '', 1516859338, 3, '2018-01-25 05:48:58', 3),
(24, 17, 'Dinning set', 'wooden with chairs covered with leather', '600000.00', '', 1516859338, 3, '2018-01-25 05:48:58', 3),
(25, 17, 'fridge', 'double door big in size', '499999.00', '', 1516859338, 3, '2018-01-25 05:48:58', 3),
(26, 19, 'Land tittle', 'land at mbuya developed with rentals', '15000000.00', '', 1517048803, 1, '2018-01-27 10:26:43', 1),
(27, 20, '1 fridge', 'white in colour', '300000.00', '', 1517049870, 8, '2018-01-27 10:44:30', 8),
(28, 20, '2 tvs', 'toshiba and panashiba  black 21 inch each', '500000.00', '', 1517049870, 8, '2018-01-27 10:44:30', 8),
(29, 20, 'sideboard', 'brown and wooden', '400000.00', '', 1517049870, 8, '2018-01-27 10:44:30', 8),
(30, 20, 'sofaset', '4 seaters brown cloth ', '300000.00', '', 1517049870, 8, '2018-01-27 10:44:30', 8),
(31, 21, 'KIBANJA IN NATEETE KAJUMBI', 'DEVELOPED WITH RENTALS', '40000000.00', '', 1517986659, 8, '2018-02-07 06:57:39', 8),
(32, 22, 'sofa chairs', '3 seater and 2 single seater cream in colour', '1000000.00', '', 1520338097, 3, '2018-03-06 12:08:17', 3),
(33, 22, 'TV', 'LG,Grey coloured,24inch,Pyramid type', '400000.00', '', 1520338097, 3, '2018-03-06 12:08:17', 3),
(34, 22, 'sideboard', 'wooden', '400000.00', '', 1520338097, 3, '2018-03-06 12:08:17', 3),
(35, 23, 'sofa chairs', 'Classic chairs with brown cloth and wooden frame', '1300000.00', '', 1520338838, 3, '2018-03-06 12:20:38', 3),
(36, 23, 'TV', 'Flat screen LG 30 inch', '1000000.00', '', 1520338838, 3, '2018-03-06 12:20:38', 3),
(37, 23, 'Fridge', 'white in colour ', '500000.00', '', 1520338838, 3, '2018-03-06 12:20:38', 3),
(38, 24, 'Sofa Chairs', '3 seater and 2 single seater cream in colour', '1000000.00', '', 1520343477, 3, '2018-03-06 13:37:57', 3),
(39, 24, 'TV', 'LG Grey in colour 24 inch Pyramid type', '400000.00', '', 1520343477, 3, '2018-03-06 13:37:57', 3),
(40, 24, 'sideboard', 'Wooden', '400000.00', '', 1520343477, 3, '2018-03-06 13:37:57', 3),
(41, 25, 'sofa chairs', 'brown in colour', '1300000.00', '', 1521630522, 3, '2018-03-21 11:08:42', 3),
(42, 25, 'TV', 'LG (30 INCH) FLAT SCREEN', '1000000.00', '', 1521630522, 3, '2018-03-21 11:08:42', 3),
(43, 25, 'Fridge', 'white in colour', '500000.00', '', 1521630522, 3, '2018-03-21 11:08:42', 3),
(44, 26, 'kibanja', 'kibanja in Ndejje lufuka', '20000000.00', '', 1521632226, 3, '2018-03-21 11:37:06', 3),
(45, 27, 'sofa chairs', 'red in colour', '600000.00', '', 1521632660, 3, '2018-03-21 11:44:20', 3),
(46, 27, 'tv', 'sony 14 inch', '100000.00', '', 1521632660, 3, '2018-03-21 11:44:20', 3),
(47, 27, 'Centre table', 'wooden', '200000.00', '', 1521632660, 3, '2018-03-21 11:44:20', 3),
(48, 28, 'kibanja', '06 developed acres in Busunjju.', '24000000.00', '', 1521633121, 3, '2018-03-21 11:52:01', 3),
(49, 28, 'sofa chairs', 'grey in colour', '1000000.00', '', 1521633121, 3, '2018-03-21 11:52:01', 3),
(50, 29, 'sofaset', 'brown and black in colour', '200000.00', '', 1521648931, 8, '2018-03-21 16:15:31', 8),
(51, 29, 'Tvset', 'silver and black 21 inch', '150000.00', '', 1521648931, 8, '2018-03-21 16:15:31', 8),
(52, 29, 'stock of goods', 'retail and wholesale items', '4000000.00', '', 1521648931, 8, '2018-03-21 16:15:31', 8),
(53, 29, 'radio system', 'black', '100000.00', '', 1521648931, 8, '2018-03-21 16:15:31', 8),
(54, 29, 'kibanja', 'kibanja at maganjo kawempe ith house', '20000000.00', '', 1521648931, 8, '2018-03-21 16:15:31', 8),
(55, 30, 'kibanja at katwe', 'developed kibanja at katwe', '15000000.00', '', 1521707841, 8, '2018-03-22 08:37:21', 8),
(56, 31, 'sideboard', 'wooden brown', '200000.00', '', 1522922275, 8, '2018-04-05 09:57:55', 8),
(57, 31, 'sofaset', 'brown cloth', '300000.00', '', 1522922275, 8, '2018-04-05 09:57:55', 8),
(58, 31, 'tv set', 'black and silver 21', '200000.00', '', 1522922275, 8, '2018-04-05 09:57:55', 8),
(59, 31, 'coffee table and radio system', 'black', '300000.00', '', 1522922275, 8, '2018-04-05 09:57:55', 8),
(60, 32, 'chattels', 'tv sofaset,salary', '1400000.00', '', 1523706240, 8, '2018-04-14 11:44:00', 8),
(61, 46, 'chattels', 'sofaset\r\ntvset\r\nsideboard', '2000000.00', '', 1524119989, 1, '2018-04-19 06:39:49', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_documents`
--

CREATE TABLE `loan_documents` (
  `id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `path` text NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `loan_products`
--

CREATE TABLE `loan_products` (
  `id` int(11) NOT NULL,
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
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_products`
--

INSERT INTO `loan_products` (`id`, `productName`, `description`, `productType`, `active`, `availableTo`, `defAmount`, `minAmount`, `maxAmount`, `maxTranches`, `defInterest`, `minInterest`, `maxInterest`, `repaymentsFrequency`, `repaymentsMadeEvery`, `defRepaymentInstallments`, `minRepaymentInstallments`, `maxRepaymentInstallments`, `initialAccountState`, `defGracePeriod`, `minGracePeriod`, `maxGracePeriod`, `minCollateral`, `minGuarantors`, `defOffSet`, `minOffSet`, `maxOffSet`, `penaltyApplicable`, `penaltyCalculationMethodId`, `penaltyTolerancePeriod`, `penaltyRateChargedPer`, `defPenaltyRate`, `minPenaltyRate`, `maxPenaltyRate`, `daysOfYear`, `taxRateSource`, `taxCalculationMethod`, `linkToDepositAccount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'individual loan', 'provides individual collateral', 1, 1, 1, '100000.00', '100000.00', '30000000.00', 1, '24.00', '24.00', '30.00', 1, 3, 1, 1, 36, 1, 0, 0, 0, '25.00', 1, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510138090, 1, '2017-11-08 09:48:10', 1),
(2, 'Quick loan', 'quick loan to individuals', 1, 1, 1, '100000.00', '100000.00', '30000000.00', 1, '60.00', '60.00', '99.99', 1, 3, 1, 1, 12, 1, 0, 0, 0, '25.00', 0, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510138955, 1, '2017-11-08 10:02:35', 1),
(4, 'Salary', ' Salary Loan', 1, 1, 3, '100000.00', '100000.00', '30000000.00', 1, '24.00', '10.00', '30.00', 1, 3, 1, 1, 36, 1, 0, 0, 0, '25.00', 1, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 1510139922, 1, '2017-11-08 10:18:42', 1),
(5, 'Land Acquisitation / Development', 'Land Acquisitation / Development', 1, 1, 1, '100000.00', '100000.00', '30000000.00', 1, '25.00', '10.00', '30.00', 1, 3, 1, 1, 36, 1, 0, 0, 0, '25.00', 1, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510140192, 1, '2017-11-08 10:23:12', 1),
(6, 'Group Loan', 'group loan product', 1, 1, 2, '100000.00', '100000.00', '30000000.00', 1, '30.00', '25.00', '30.00', 1, 2, 1, 1, 127, 1, 0, 0, 0, '25.00', 0, 7, 7, 7, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 0, 0, '2018-05-11 12:43:58', 1),
(7, 'Group Loan', '', 1, 0, 2, '100000.00', '100000.00', '30000000.00', 1, '30.00', '25.00', '30.00', 1, 2, 1, 1, 127, 1, 0, 0, 0, '25.00', 0, 7, 7, 7, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 0, 0, '2018-05-11 07:59:44', 0);

-- --------------------------------------------------------

--
-- Table structure for table `loan_products_penalty`
--

CREATE TABLE `loan_products_penalty` (
  `id` int(11) NOT NULL,
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
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan products can be subjected to';

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_fee`
--

CREATE TABLE `loan_product_fee` (
  `id` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  `feeName` varchar(50) NOT NULL,
  `feeType` tinyint(4) DEFAULT NULL,
  `amountCalculatedAs` tinyint(1) NOT NULL COMMENT '1-Percentage, 2 - Fixed Amount',
  `requiredFee` tinyint(1) NOT NULL COMMENT '1 - Required, 0 - Optional',
  `amount` decimal(12,2) NOT NULL COMMENT 'Amount or %age to be charged',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a loan product';

--
-- Dumping data for table `loan_product_fee`
--

INSERT INTO `loan_product_fee` (`id`, `status`, `feeName`, `feeType`, `amountCalculatedAs`, `requiredFee`, `amount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(2, 1, 'Insurance Fee', 1, 2, 1, '2.00', 1508144331, 1, '2017-10-16 06:58:51', 1),
(3, 1, 'Compulsary Saving', 1, 2, 1, '10.00', 1508144331, 1, '2017-10-16 06:58:51', 1),
(4, 1, 'Loan Form Fee', 1, 1, 1, '20000.00', 1510070142, 1, '2017-11-08 09:48:48', 1),
(5, 1, 'Application fee', 1, 2, 1, '3.00', 1510138090, 1, '2017-11-08 09:48:10', 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_feen`
--

CREATE TABLE `loan_product_feen` (
  `id` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT '1',
  `loanProductId` int(11) NOT NULL,
  `loanProductFeeId` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a loan product';

--
-- Dumping data for table `loan_product_feen`
--

INSERT INTO `loan_product_feen` (`id`, `status`, `loanProductId`, `loanProductFeeId`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, 1, 1, 5, 1, 1510138091, 1, '2017-11-08 09:48:11'),
(2, 1, 1, 2, 1, 1510138091, 1, '2017-11-08 09:48:11'),
(3, 1, 1, 3, 1, 1510138091, 1, '2017-11-08 09:48:11'),
(4, 1, 1, 4, 1, 1510138091, 1, '2017-11-08 09:48:11'),
(5, 1, 2, 2, 1, 1510138955, 1, '2017-11-08 10:02:35'),
(6, 1, 2, 4, 1, 1510138955, 1, '2017-11-08 10:02:35'),
(7, 1, 2, 5, 1, 1510138955, 1, '2017-11-08 10:02:35'),
(8, 1, 2, 3, 1, 1510138955, 1, '2017-11-08 10:02:35'),
(9, 1, 3, 2, 1, 1510139226, 1, '2017-11-08 10:07:06'),
(10, 1, 3, 4, 1, 1510139226, 1, '2017-11-08 10:07:06'),
(11, 1, 3, 5, 1, 1510139226, 1, '2017-11-08 10:07:06'),
(12, 1, 3, 3, 1, 1510139226, 1, '2017-11-08 10:07:06'),
(13, 1, 4, 2, 1, 1510139922, 1, '2017-11-08 10:18:42'),
(14, 1, 4, 4, 1, 1510139923, 1, '2017-11-08 10:18:43'),
(15, 1, 4, 5, 1, 1510139923, 1, '2017-11-08 10:18:43'),
(16, 1, 4, 3, 1, 1510139923, 1, '2017-11-08 10:18:43'),
(17, 1, 5, 2, 1, 1510140192, 1, '2017-11-08 10:23:12'),
(18, 1, 5, 3, 1, 1510140192, 1, '2017-11-08 10:23:12'),
(19, 1, 5, 4, 1, 1510140192, 1, '2017-11-08 10:23:12'),
(20, 1, 5, 5, 1, 1510140192, 1, '2017-11-08 10:23:12'),
(21, 1, 6, 2, 1, 1524133406, 1, '2018-04-19 10:23:26'),
(22, 1, 6, 3, 1, 1524133406, 1, '2018-04-19 10:23:26'),
(23, 1, 6, 4, 1, 1524133406, 1, '2018-04-19 10:23:26'),
(24, 1, 6, 5, 1, 1524133406, 1, '2018-04-19 10:23:26'),
(25, 1, 7, 2, 1, 1526025584, 1, '2018-05-11 07:59:44'),
(26, 1, 7, 3, 1, 1526025584, 1, '2018-05-11 07:59:44'),
(27, 1, 7, 4, 1, 1526025584, 1, '2018-05-11 07:59:44'),
(28, 1, 7, 5, 1, 1526025584, 1, '2018-05-11 07:59:44');

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_type`
--

CREATE TABLE `loan_product_type` (
  `id` int(11) NOT NULL,
  `typeName` varchar(50) NOT NULL COMMENT 'Name of the product type',
  `description` varchar(250) NOT NULL COMMENT 'Description',
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp record was entered',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record modification date',
  `createdBy` int(11) NOT NULL COMMENT 'staff that entered record',
  `modifiedBy` int(11) NOT NULL COMMENT 'User modifying entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_product_type`
--

INSERT INTO `loan_product_type` (`id`, `typeName`, `description`, `dateCreated`, `dateModified`, `createdBy`, `modifiedBy`) VALUES
(1, 'Fixed Term Loan', 'A Fixed interest rate which allows accurate prediction of future payments', 0, '2017-06-26 11:35:13', 0, 0),
(2, 'Dynamic Term Loan', 'Allows dynamic calculation of the interest rate, and thus, future payments\r\n', 0, '2017-06-26 11:35:40', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `loan_repayment`
--

CREATE TABLE `loan_repayment` (
  `id` int(11) NOT NULL,
  `transactionId` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `loanAccountId` int(11) NOT NULL COMMENT 'Loan Account ID',
  `amount` decimal(15,2) NOT NULL,
  `transactionType` tinyint(1) DEFAULT NULL,
  `comments` text NOT NULL,
  `transactionDate` int(11) NOT NULL,
  `recievedBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `marital_status`
--

CREATE TABLE `marital_status` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `marital_status`
--

INSERT INTO `marital_status` (`id`, `name`, `description`, `active`) VALUES
(1, 'Single', 'single', 1),
(2, 'Married', 'married', 1),
(3, 'Divorced', 'divorced', 1),
(4, 'Windowed', 'Windowed', 1);

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Whether member active or not',
  `branch_id` int(11) NOT NULL COMMENT 'Ref to branch member registered from from',
  `memberType` int(11) NOT NULL,
  `dateAdded` int(11) NOT NULL COMMENT 'Timestamp of the moment the member was added',
  `addedBy` int(11) NOT NULL,
  `comment` text,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of the moment the member was modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to staff who modified the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `personId`, `active`, `branch_id`, `memberType`, `dateAdded`, `addedBy`, `comment`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:46', 1),
(2, 2, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:46', 1),
(3, 3, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 07:22:46', 1),
(4, 4, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:47', 1),
(5, 5, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:47', 1),
(6, 6, 1, 1, 1, 1476309600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:47', 1),
(7, 7, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:47', 1),
(8, 8, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(9, 9, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(10, 10, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(11, 11, 1, 1, 1, 1504476000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(12, 12, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(13, 13, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(14, 14, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(15, 15, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2018-03-20 09:26:21', 819),
(16, 16, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:48', 1),
(17, 17, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:49', 1),
(18, 18, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 07:22:49', 1),
(19, 19, 1, 1, 1, 1504562400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:49', 1),
(20, 20, 0, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2018-03-21 13:49:20', 1),
(21, 21, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:50', 1),
(22, 22, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2018-03-23 08:28:27', 819),
(23, 23, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:51', 1),
(24, 24, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:51', 1),
(25, 25, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:51', 1),
(26, 26, 1, 1, 1, 1501711200, 1, 'This member data was exported from an excel', '2017-11-15 07:22:52', 1),
(27, 27, 1, 1, 1, 1509055200, 1, 'This member data was exported from an excel', '2018-03-06 11:13:51', 819),
(28, 28, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:52', 1),
(29, 29, 1, 1, 1, 1497564000, 1, 'This member data was exported from an excel', '2018-03-23 08:35:15', 819),
(30, 30, 1, 1, 1, 1491170400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:52', 1),
(31, 31, 1, 1, 1, 1503957600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(32, 32, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(33, 33, 1, 1, 1, 1472594400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(34, 34, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(35, 35, 1, 1, 1, 1501020000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(36, 36, 1, 1, 1, 1476914400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(37, 37, 1, 1, 1, 1481065200, 1, 'This member data was exported from an excel', '2017-11-15 07:22:53', 1),
(38, 38, 1, 1, 1, 1479164400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:54', 1),
(39, 39, 1, 1, 1, 1478646000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:54', 1),
(40, 40, 1, 1, 1, 1502229600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:54', 1),
(41, 41, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:54', 1),
(42, 42, 1, 1, 1, 1506376800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:54', 1),
(43, 43, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:54', 1),
(44, 44, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(45, 45, 1, 1, 1, 1482274800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(46, 46, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(47, 47, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(48, 48, 1, 1, 1, 1506636000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(49, 49, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(50, 50, 1, 1, 1, 1478214000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(51, 51, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:55', 1),
(52, 52, 1, 1, 1, 1499637600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:56', 1),
(53, 53, 1, 1, 1, 1507759200, 1, 'This member data was exported from an excel', '2017-11-15 07:22:56', 1),
(54, 54, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:56', 1),
(55, 55, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:56', 1),
(56, 56, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:56', 1),
(57, 57, 1, 1, 1, 1494194400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:57', 1),
(58, 58, 1, 1, 1, 1505685600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:57', 1),
(59, 59, 1, 1, 1, 1507672800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:57', 1),
(60, 60, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:57', 1),
(61, 61, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:57', 1),
(62, 62, 1, 1, 1, 1494453600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:57', 1),
(63, 63, 1, 1, 1, 1472594400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:58', 1),
(64, 64, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:58', 1),
(65, 65, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:58', 1),
(66, 66, 1, 1, 1, 1476309600, 1, 'This member data was exported from an excel', '2017-11-15 07:22:58', 1),
(67, 67, 1, 1, 1, 1504044000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:58', 1),
(68, 68, 1, 1, 1, 1504476000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:59', 1),
(69, 69, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:22:59', 1),
(70, 70, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:22:59', 1),
(71, 71, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:59', 1),
(72, 72, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:22:59', 1),
(73, 73, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:00', 1),
(74, 74, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:00', 1),
(75, 75, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2018-03-20 09:30:16', 819),
(76, 76, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:01', 1),
(77, 77, 1, 1, 1, 1477519200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:01', 1),
(78, 78, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:01', 1),
(79, 79, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:01', 1),
(80, 80, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:02', 1),
(81, 81, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:02', 1),
(82, 82, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:03', 1),
(83, 83, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:03', 1),
(84, 84, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:04', 1),
(85, 85, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:04', 1),
(86, 86, 1, 1, 1, 1503007200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:04', 1),
(87, 87, 1, 1, 1, 1506549600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:04', 1),
(88, 88, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:04', 1),
(89, 89, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:04', 1),
(90, 90, 0, 1, 1, 1509055200, 1, 'This member data was exported from an excel', '2018-03-23 07:45:48', 1),
(91, 91, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:05', 1),
(92, 92, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:05', 1),
(93, 93, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:05', 1),
(94, 94, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:05', 1),
(95, 95, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:05', 1),
(96, 96, 1, 1, 1, 1499119200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:06', 1),
(97, 97, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2018-04-26 12:16:11', 819),
(98, 98, 1, 1, 1, 1509404400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:06', 1),
(99, 99, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:06', 1),
(100, 100, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:06', 1),
(101, 101, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:07', 1),
(102, 102, 1, 1, 1, 1499637600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:07', 1),
(103, 103, 1, 1, 1, 1475532000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:07', 1),
(104, 104, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:07', 1),
(105, 105, 0, 1, 1, 1507586400, 1, 'This member data was exported from an excel', '2018-03-06 12:56:14', 1),
(106, 106, 1, 1, 1, 1507586400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:07', 1),
(107, 107, 1, 1, 1, 1509404400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:08', 1),
(108, 108, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:08', 1),
(109, 109, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:08', 1),
(110, 110, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:08', 1),
(111, 111, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:08', 1),
(112, 112, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(113, 113, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(114, 114, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(115, 115, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(116, 116, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(117, 117, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(118, 118, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(119, 119, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:09', 1),
(120, 120, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:10', 1),
(121, 121, 1, 1, 1, 1494799200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:10', 1),
(122, 122, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:10', 1),
(123, 123, 1, 1, 1, 1509318000, 1, 'This member data was exported from an excel', '2018-03-06 11:16:29', 819),
(124, 124, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:10', 1),
(125, 125, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:10', 1),
(126, 126, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:11', 1),
(127, 127, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:11', 1),
(128, 128, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:11', 1),
(129, 129, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:12', 1),
(130, 130, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:12', 1),
(131, 131, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:12', 1),
(132, 132, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:12', 1),
(133, 133, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:13', 1),
(134, 134, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:14', 1),
(135, 135, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:14', 1),
(136, 136, 1, 1, 1, 1476655200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:14', 1),
(137, 137, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:14', 1),
(138, 138, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:14', 1),
(139, 139, 1, 1, 1, 1510744119, 1, 'This member data was exported from an excel', '2017-11-15 10:09:40', 1),
(140, 140, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:15', 1),
(141, 141, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2018-04-26 10:35:38', 819),
(142, 142, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:15', 1),
(143, 143, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:15', 1),
(144, 144, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:15', 1),
(145, 145, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:15', 1),
(146, 146, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:16', 1),
(147, 147, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:16', 1),
(148, 148, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:16', 1),
(149, 149, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2018-03-21 10:47:28', 819),
(150, 150, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:16', 1),
(151, 151, 1, 1, 1, 1501020000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:17', 1),
(152, 152, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:17', 1),
(153, 153, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:17', 1),
(154, 154, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:17', 1),
(155, 155, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:17', 1),
(156, 156, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:17', 1),
(157, 157, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:18', 1),
(158, 158, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:18', 1),
(159, 159, 1, 1, 1, 1508364000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:18', 1),
(160, 160, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:18', 1),
(161, 161, 0, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2018-03-21 13:05:41', 1),
(162, 162, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:19', 1),
(163, 163, 1, 1, 1, 1494194400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:19', 1),
(164, 164, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:19', 1),
(165, 165, 1, 1, 1, 1500501600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:19', 1),
(166, 166, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:19', 1),
(167, 167, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:19', 1),
(168, 168, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(169, 169, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(170, 170, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(171, 171, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(172, 172, 1, 1, 1, 1496786400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(173, 173, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(174, 174, 1, 1, 1, 1480028400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(175, 175, 0, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2018-03-21 10:36:30', 1),
(176, 176, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(177, 177, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:20', 1),
(178, 178, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:21', 1),
(179, 179, 1, 1, 1, 1503957600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:21', 1),
(180, 180, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:21', 1),
(181, 181, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:21', 1),
(182, 182, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:21', 1),
(183, 183, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:22', 1),
(184, 184, 0, 1, 1, 1502402400, 1, 'This member data was exported from an excel', '2018-03-21 13:35:00', 1),
(185, 185, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:23', 1),
(186, 186, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:23', 1),
(187, 187, 1, 1, 1, 1505858400, 1, 'This member data was exported from an excel', '2018-03-21 12:28:40', 819),
(188, 188, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:23', 1),
(189, 189, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:24', 1),
(190, 190, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:24', 1),
(191, 191, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(192, 192, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(193, 193, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(194, 194, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(195, 195, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(196, 196, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(197, 197, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:25', 1),
(198, 198, 1, 1, 1, 1501884000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(199, 199, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(200, 200, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(201, 201, 1, 1, 1, 1494280800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(202, 202, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(203, 203, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(204, 204, 1, 1, 1, 1480028400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:26', 1),
(205, 205, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:27', 1),
(206, 206, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:27', 1),
(207, 207, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:27', 1),
(208, 208, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2018-03-20 13:33:27', 819),
(209, 209, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:27', 1),
(210, 210, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(211, 211, 1, 1, 1, 1497909600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(212, 212, 1, 1, 1, 1479855600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(213, 213, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(214, 214, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(215, 215, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(216, 216, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(217, 217, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(218, 218, 1, 1, 1, 1499724000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:28', 1),
(219, 219, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(220, 220, 1, 1, 1, 1479423600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(221, 221, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(222, 222, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(223, 223, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(224, 224, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(225, 225, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(226, 226, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(227, 227, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:29', 1),
(228, 228, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:30', 1),
(229, 229, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:30', 1),
(230, 230, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:30', 1),
(231, 231, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:30', 1),
(232, 232, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:30', 1),
(233, 233, 1, 1, 1, 1500242400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:30', 1),
(234, 234, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:31', 1),
(235, 235, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:31', 1),
(236, 236, 1, 1, 1, 1506895200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:31', 1),
(237, 237, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:32', 1),
(238, 238, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:32', 1),
(239, 239, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:33', 1),
(240, 240, 1, 1, 1, 1504821600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:33', 1),
(241, 241, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:33', 1),
(242, 242, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:33', 1),
(243, 243, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:34', 1),
(244, 244, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:34', 1),
(245, 245, 1, 1, 1, 1499292000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:35', 1),
(246, 246, 1, 1, 1, 1501452000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:35', 1),
(247, 247, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:35', 1),
(248, 248, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:36', 1),
(249, 249, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:36', 1),
(250, 250, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:36', 1),
(251, 251, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:36', 1),
(252, 252, 1, 1, 1, 1479164400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:36', 1),
(253, 253, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:36', 1),
(254, 254, 1, 1, 1, 1501711200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(255, 255, 1, 1, 1, 1496786400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(256, 256, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(257, 257, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(258, 258, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(259, 259, 1, 1, 1, 1495144800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(260, 260, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(261, 261, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:37', 1),
(262, 262, 1, 1, 1, 1472767200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(263, 263, 1, 1, 1, 1493935200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(264, 264, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(265, 265, 1, 1, 1, 1495490400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(266, 266, 1, 1, 1, 1491343200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(267, 267, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(268, 268, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:38', 1),
(269, 269, 1, 1, 1, 1477519200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(270, 270, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(271, 271, 1, 1, 1, 1497909600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(272, 272, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(273, 273, 1, 1, 1, 1507672800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(274, 274, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(275, 275, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:39', 1),
(276, 276, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:40', 1),
(277, 277, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:40', 1),
(278, 278, 1, 1, 1, 1493935200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:40', 1),
(279, 279, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:40', 1),
(280, 280, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:40', 1),
(281, 281, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:40', 1),
(282, 282, 0, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2018-03-21 13:34:34', 1),
(283, 283, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:41', 1),
(284, 284, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:41', 1),
(285, 285, 1, 1, 1, 1491343200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:41', 1),
(286, 286, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:41', 1),
(287, 287, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:41', 1),
(288, 288, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:41', 1),
(289, 289, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:42', 1),
(290, 290, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:42', 1),
(291, 291, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:42', 1),
(292, 292, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:43', 1),
(293, 293, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:43', 1),
(294, 294, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:43', 1),
(295, 295, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:43', 1),
(296, 296, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:44', 1),
(297, 297, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:44', 1),
(298, 298, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:44', 1),
(299, 299, 1, 1, 1, 1491170400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:44', 1),
(300, 300, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:45', 1),
(301, 301, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:45', 1),
(302, 302, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:45', 1),
(303, 303, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:45', 1),
(304, 304, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:45', 1),
(305, 305, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:45', 1),
(306, 306, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:46', 1),
(307, 307, 1, 1, 1, 1494799200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:46', 1),
(308, 308, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:46', 1),
(309, 309, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:47', 1),
(310, 310, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:47', 1),
(311, 311, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2018-04-26 12:17:36', 819),
(312, 312, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:47', 1),
(313, 313, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:47', 1),
(314, 314, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:47', 1),
(315, 315, 1, 1, 1, 1480028400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:47', 1),
(316, 316, 1, 1, 1, 1506463200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(317, 317, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(318, 318, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(319, 319, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(320, 320, 1, 1, 1, 1493589600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(321, 321, 1, 1, 1, 1502748000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(322, 322, 1, 1, 1, 1502229600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:48', 1),
(323, 323, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(324, 324, 1, 1, 1, 1484521200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(325, 325, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(326, 326, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(327, 327, 1, 1, 1, 1508104800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(328, 328, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(329, 329, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(330, 330, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(331, 331, 1, 1, 1, 1502316000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:49', 1),
(332, 332, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(333, 333, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(334, 334, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(335, 335, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(336, 336, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(337, 337, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(338, 338, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:50', 1),
(339, 339, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2018-03-15 09:44:57', 819),
(340, 340, 1, 1, 1, 1497564000, 1, 'This member data was exported from an excel', '2018-03-23 08:44:05', 819),
(341, 341, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:51', 1),
(342, 342, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:51', 1),
(343, 343, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:52', 1),
(344, 344, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:52', 1),
(345, 345, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:53', 1),
(346, 346, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:53', 1),
(347, 347, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:53', 1),
(348, 348, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:53', 1),
(349, 349, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:53', 1),
(350, 350, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:54', 1),
(351, 351, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:54', 1),
(352, 352, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:54', 1),
(353, 353, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:54', 1),
(354, 354, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:55', 1),
(355, 355, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:55', 1),
(356, 356, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:55', 1),
(357, 357, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:55', 1),
(358, 358, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:55', 1),
(359, 359, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:55', 1),
(360, 360, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:56', 1),
(361, 361, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:56', 1),
(362, 362, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:56', 1),
(363, 363, 1, 1, 1, 1475532000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:56', 1),
(364, 364, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:56', 1),
(365, 365, 1, 1, 1, 1491170400, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(366, 366, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(367, 367, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(368, 368, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(369, 369, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(370, 370, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(371, 371, 1, 1, 1, 1496008800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(372, 372, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(373, 373, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:57', 1),
(374, 374, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:58', 1),
(375, 375, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:58', 1),
(376, 376, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:58', 1),
(377, 377, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:58', 1),
(378, 378, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:58', 1),
(379, 379, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:58', 1),
(380, 380, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2018-03-21 12:18:13', 819),
(381, 381, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:59', 1),
(382, 382, 1, 1, 1, 1494453600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:59', 1),
(383, 383, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 07:23:59', 1),
(384, 384, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 07:23:59', 1),
(385, 385, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:23:59', 1),
(386, 386, 1, 1, 1, 1483570800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:00', 1),
(387, 387, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:00', 1),
(388, 388, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:00', 1),
(389, 389, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2018-03-21 12:24:07', 819),
(390, 390, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:00', 1),
(391, 391, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:00', 1),
(392, 392, 1, 1, 1, 1508709600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(393, 393, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(394, 394, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(395, 395, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(396, 396, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(397, 397, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(398, 398, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2018-03-21 10:43:29', 819),
(399, 399, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:01', 1),
(400, 400, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:02', 1),
(401, 401, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:02', 1),
(402, 402, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:02', 1),
(403, 403, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:03', 1),
(404, 404, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:03', 1),
(405, 405, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:03', 1),
(406, 406, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:04', 1),
(407, 407, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:04', 1),
(408, 408, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:04', 1),
(409, 409, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:04', 1),
(410, 410, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:04', 1),
(411, 411, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(412, 412, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(413, 413, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(414, 414, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(415, 415, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(416, 416, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(417, 417, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:05', 1),
(418, 418, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:06', 1),
(419, 419, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:06', 1),
(420, 420, 1, 1, 1, 1492466400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:07', 1),
(421, 421, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:07', 1),
(422, 422, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:07', 1),
(423, 423, 1, 1, 1, 1508191200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:07', 1),
(424, 424, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:07', 1),
(425, 425, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:08', 1),
(426, 426, 1, 1, 1, 1500588000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:08', 1),
(427, 427, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:08', 1),
(428, 428, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:08', 1),
(429, 429, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:08', 1),
(430, 430, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:08', 1),
(431, 431, 1, 1, 1, 1495144800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(432, 432, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(433, 433, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(434, 434, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(435, 435, 1, 1, 1, 1499205600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(436, 436, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(437, 437, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(438, 438, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:09', 1),
(439, 439, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:10', 1),
(440, 440, 1, 1, 1, 1509055200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:10', 1),
(441, 441, 1, 1, 1, 1481583600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:10', 1),
(442, 442, 1, 1, 1, 1477000800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:10', 1),
(443, 443, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:10', 1),
(444, 444, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:10', 1),
(445, 445, 1, 1, 1, 1500415200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(446, 446, 1, 1, 1, 1493330400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(447, 447, 1, 1, 1, 1504044000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(448, 448, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(449, 449, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(450, 450, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(451, 451, 1, 1, 1, 1476223200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:11', 1),
(452, 452, 1, 1, 1, 1501106400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:12', 1),
(453, 453, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:12', 1),
(454, 454, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:12', 1),
(455, 455, 1, 1, 1, 1506895200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:12', 1),
(456, 456, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:13', 1),
(457, 457, 1, 1, 1, 1492466400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:13', 1),
(458, 458, 1, 1, 1, 1502229600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:14', 1),
(459, 459, 1, 1, 1, 1479078000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:14', 1),
(460, 460, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:14', 1),
(461, 461, 1, 1, 1, 1502402400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:14', 1),
(462, 462, 1, 1, 1, 1501797600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:15', 1),
(463, 463, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:15', 1),
(464, 464, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:15', 1),
(465, 465, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:15', 1),
(466, 466, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:15', 1),
(467, 467, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:15', 1);
INSERT INTO `member` (`id`, `personId`, `active`, `branch_id`, `memberType`, `dateAdded`, `addedBy`, `comment`, `dateModified`, `modifiedBy`) VALUES
(468, 468, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2018-03-20 13:09:09', 819),
(469, 469, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:16', 1),
(470, 470, 1, 1, 1, 1503525600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:16', 1),
(471, 471, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:16', 1),
(472, 472, 1, 1, 1, 1500933600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:16', 1),
(473, 473, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:16', 1),
(474, 474, 1, 1, 1, 1502748000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:17', 1),
(475, 475, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:17', 1),
(476, 476, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:17', 1),
(477, 477, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:17', 1),
(478, 478, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:17', 1),
(479, 479, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:17', 1),
(480, 480, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:18', 1),
(481, 481, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:18', 1),
(482, 482, 1, 1, 1, 1505685600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:18', 1),
(483, 483, 1, 1, 1, 1502316000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:18', 1),
(484, 484, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:18', 1),
(485, 485, 1, 1, 1, 1476914400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:18', 1),
(486, 486, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(487, 487, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(488, 488, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(489, 489, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(490, 490, 1, 1, 1, 1470693600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(491, 491, 1, 1, 1, 1480546800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(492, 492, 1, 1, 1, 1502834400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:19', 1),
(493, 493, 1, 1, 1, 1506549600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(494, 494, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(495, 495, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(496, 496, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(497, 497, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(498, 498, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(499, 499, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:20', 1),
(500, 500, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:21', 1),
(501, 501, 1, 1, 1, 1499292000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:21', 1),
(502, 502, 1, 1, 1, 1501711200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:21', 1),
(503, 503, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:21', 1),
(504, 504, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:22', 1),
(505, 505, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:22', 1),
(506, 506, 1, 1, 1, 1493589600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:22', 1),
(507, 507, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:23', 1),
(508, 508, 1, 1, 1, 1495058400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:23', 1),
(509, 509, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:23', 1),
(510, 510, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:23', 1),
(511, 511, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:24', 1),
(512, 512, 1, 1, 1, 1504562400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:24', 1),
(513, 513, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:24', 1),
(514, 514, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:24', 1),
(515, 515, 1, 1, 1, 1479942000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:25', 1),
(516, 516, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:26', 1),
(517, 517, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:26', 1),
(518, 518, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:26', 1),
(519, 519, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:26', 1),
(520, 520, 1, 1, 1, 1500501600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:26', 1),
(521, 521, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:27', 1),
(522, 522, 1, 1, 1, 1507240800, 1, 'This member data was exported from an excel', '2018-03-21 12:48:20', 819),
(523, 523, 1, 1, 1, 1478214000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:27', 1),
(524, 524, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:27', 1),
(525, 525, 1, 1, 1, 1493935200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:27', 1),
(526, 526, 1, 1, 1, 1509318000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:28', 1),
(527, 527, 1, 1, 1, 1496786400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:28', 1),
(528, 528, 1, 1, 1, 1476914400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:28', 1),
(529, 529, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:28', 1),
(530, 530, 1, 1, 1, 1495058400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:28', 1),
(531, 531, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:28', 1),
(532, 532, 1, 1, 1, 1492466400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:29', 1),
(533, 533, 1, 1, 1, 1495490400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:29', 1),
(534, 534, 1, 1, 1, 1501106400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:29', 1),
(535, 535, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2018-03-19 09:33:07', 819),
(536, 536, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:29', 1),
(537, 537, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:29', 1),
(538, 538, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:29', 1),
(539, 539, 1, 1, 1, 1499637600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(540, 540, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(541, 541, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(542, 542, 1, 1, 1, 1478214000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(543, 543, 1, 1, 1, 1499292000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(544, 544, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(545, 545, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(546, 546, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:30', 1),
(547, 547, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:31', 1),
(548, 548, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:31', 1),
(549, 549, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:31', 1),
(550, 550, 1, 1, 1, 1504476000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:31', 1),
(551, 551, 1, 1, 1, 1494453600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:31', 1),
(552, 552, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:31', 1),
(553, 553, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:32', 1),
(554, 554, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:32', 1),
(555, 555, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:32', 1),
(556, 556, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:32', 1),
(557, 557, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:32', 1),
(558, 558, 1, 1, 1, 1502316000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:32', 1),
(559, 559, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:33', 1),
(560, 560, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:33', 1),
(561, 561, 1, 1, 1, 1479078000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:33', 1),
(562, 562, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:34', 1),
(563, 563, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:34', 1),
(564, 564, 1, 1, 1, 1501106400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:35', 1),
(565, 565, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:35', 1),
(566, 566, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:35', 1),
(567, 567, 1, 1, 1, 1507240800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:36', 1),
(568, 568, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:36', 1),
(569, 569, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:36', 1),
(570, 570, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:37', 1),
(571, 571, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:37', 1),
(572, 572, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:37', 1),
(573, 573, 1, 1, 1, 1480546800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:37', 1),
(574, 574, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:37', 1),
(575, 575, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:37', 1),
(576, 576, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:38', 1),
(577, 577, 1, 1, 1, 1506636000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:38', 1),
(578, 578, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:38', 1),
(579, 579, 1, 1, 1, 1500242400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:38', 1),
(580, 580, 0, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2018-03-21 13:00:43', 1),
(581, 581, 1, 1, 1, 1476396000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:39', 1),
(582, 582, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:39', 1),
(583, 583, 1, 1, 1, 1503007200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:39', 1),
(584, 584, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:39', 1),
(585, 585, 1, 1, 1, 1500933600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:39', 1),
(586, 586, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2018-03-23 08:31:39', 819),
(587, 587, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:40', 1),
(588, 588, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:40', 1),
(589, 589, 1, 1, 1, 1476223200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:40', 1),
(590, 590, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:40', 1),
(591, 591, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:41', 1),
(592, 592, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:41', 1),
(593, 593, 1, 1, 1, 1493589600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:41', 1),
(594, 594, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:41', 1),
(595, 595, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:41', 1),
(596, 596, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:42', 1),
(597, 597, 1, 1, 1, 1503525600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:42', 1),
(598, 598, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:42', 1),
(599, 599, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:42', 1),
(600, 600, 1, 1, 1, 1491343200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:42', 1),
(601, 601, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:42', 1),
(602, 602, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(603, 603, 1, 1, 1, 1501452000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(604, 604, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(605, 605, 1, 1, 1, 1506549600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(606, 606, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(607, 607, 1, 1, 1, 1501452000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(608, 608, 1, 1, 1, 1502402400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(609, 609, 1, 1, 1, 1480287600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:43', 1),
(610, 610, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:44', 1),
(611, 611, 1, 1, 1, 1499896800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:44', 1),
(612, 612, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:44', 1),
(613, 613, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:44', 1),
(614, 614, 1, 1, 1, 1472594400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:44', 1),
(615, 615, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:45', 1),
(616, 616, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:46', 1),
(617, 617, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:46', 1),
(618, 618, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:46', 1),
(619, 619, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:47', 1),
(620, 620, 1, 1, 1, 1484694000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:47', 1),
(621, 621, 1, 1, 1, 1506463200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:47', 1),
(622, 622, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:48', 1),
(623, 623, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2018-03-21 12:52:52', 819),
(624, 624, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:48', 1),
(625, 625, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:48', 1),
(626, 626, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:48', 1),
(627, 627, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:49', 1),
(628, 628, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:49', 1),
(629, 629, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:49', 1),
(630, 630, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:49', 1),
(631, 631, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:50', 1),
(632, 632, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:50', 1),
(633, 633, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:50', 1),
(634, 634, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:50', 1),
(635, 635, 1, 1, 1, 1482274800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:50', 1),
(636, 636, 1, 1, 1, 1491948000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:50', 1),
(637, 637, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:51', 1),
(638, 638, 1, 1, 1, 1508450400, 1, 'This member data was exported from an excel', '2018-03-23 07:49:35', 819),
(639, 639, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2018-03-15 09:41:03', 819),
(640, 640, 1, 1, 1, 1479164400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:51', 1),
(641, 641, 1, 1, 1, 1476136800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:51', 1),
(642, 642, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:51', 1),
(643, 643, 1, 1, 1, 1504044000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:52', 1),
(644, 644, 1, 1, 1, 1494280800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:52', 1),
(645, 645, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:52', 1),
(646, 646, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:52', 1),
(647, 647, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:52', 1),
(648, 648, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(649, 649, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(650, 650, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(651, 651, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(652, 652, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(653, 653, 1, 1, 1, 1498168800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(654, 654, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(655, 655, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:53', 1),
(656, 656, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(657, 657, 1, 1, 1, 1476309600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(658, 658, 1, 1, 1, 1508191200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(659, 659, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(660, 660, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(661, 661, 1, 1, 1, 1505685600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(662, 662, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(663, 663, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(664, 664, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(665, 665, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:54', 1),
(666, 666, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:55', 1),
(667, 667, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:55', 1),
(668, 668, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:55', 1),
(669, 669, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:55', 1),
(670, 670, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:56', 1),
(671, 671, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 07:24:56', 1),
(672, 672, 1, 1, 1, 1499724000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:56', 1),
(673, 673, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:56', 1),
(674, 674, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:57', 1),
(675, 675, 1, 1, 1, 1485126000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:57', 1),
(676, 676, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:58', 1),
(677, 677, 1, 1, 1, 1489014000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:58', 1),
(678, 678, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:58', 1),
(679, 679, 1, 1, 1, 1485903600, 1, 'This member data was exported from an excel', '2017-11-15 07:24:58', 1),
(680, 680, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:59', 1),
(681, 681, 1, 1, 1, 1483398000, 1, 'This member data was exported from an excel', '2017-11-15 07:24:59', 1),
(682, 682, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:24:59', 1),
(683, 683, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:24:59', 1),
(684, 684, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2018-03-19 09:28:13', 819),
(685, 685, 1, 1, 1, 1487890800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:00', 1),
(686, 686, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:00', 1),
(687, 687, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:00', 1),
(688, 688, 1, 1, 1, 1490050800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:00', 1),
(689, 689, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(690, 690, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(691, 691, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(692, 692, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(693, 693, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(694, 694, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(695, 695, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:01', 1),
(696, 696, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:02', 1),
(697, 697, 1, 1, 1, 1487804400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:02', 1),
(698, 698, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:02', 1),
(699, 699, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:02', 1),
(700, 700, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:02', 1),
(701, 701, 1, 1, 1, 1484521200, 1, 'This member data was exported from an excel', '2017-11-15 07:25:02', 1),
(702, 702, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:03', 1),
(703, 703, 1, 1, 1, 1487545200, 1, 'This member data was exported from an excel', '2017-11-15 07:25:03', 1),
(704, 704, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:03', 1),
(705, 705, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:03', 1),
(706, 706, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:03', 1),
(707, 707, 1, 1, 1, 1487890800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:03', 1),
(708, 708, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(709, 709, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(710, 710, 1, 1, 1, 1488150000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(711, 711, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(712, 712, 1, 1, 1, 1490050800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(713, 713, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(714, 714, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(715, 715, 1, 1, 1, 1490223600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(716, 716, 1, 1, 1, 1484780400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:04', 1),
(717, 717, 1, 1, 1, 1488150000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(718, 718, 1, 1, 1, 1483570800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(719, 719, 1, 1, 1, 1489100400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(720, 720, 1, 1, 1, 1489100400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(721, 721, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(722, 722, 1, 1, 1, 1487631600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(723, 723, 1, 1, 1, 1484780400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:05', 1),
(724, 724, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:06', 1),
(725, 725, 1, 1, 1, 1489532400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:06', 1),
(726, 726, 1, 1, 1, 1486508400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:06', 1),
(727, 727, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:06', 1),
(728, 728, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:07', 1),
(729, 729, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:07', 1),
(730, 730, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:08', 1),
(731, 731, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:08', 1),
(732, 732, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:08', 1),
(733, 733, 1, 1, 1, 1487804400, 1, 'This member data was exported from an excel', '2017-11-15 07:25:08', 1),
(734, 734, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 07:25:09', 1),
(735, 735, 1, 1, 1, 1488495600, 1, 'This member data was exported from an excel', '2017-11-15 07:25:09', 1),
(736, 736, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 07:25:09', 1),
(737, 741, 1, 1, 0, 1510822001, 0, '', '2017-11-16 08:46:41', 0),
(738, 742, 0, 1, 0, 1510822033, 0, '', '2017-11-16 09:05:51', 0),
(739, 743, 0, 1, 0, 1510822062, 0, '', '2017-11-16 09:05:41', 0),
(740, 744, 1, 1, 0, 1510822748, 0, '', '2017-11-16 08:59:08', 0),
(741, 745, 1, 1, 0, 1510833759, 0, '', '2017-11-16 12:02:39', 0),
(742, 747, 1, 1, 0, 1511263636, 0, '', '2017-11-21 11:27:16', 0),
(743, 749, 1, 0, 0, 1511330087, 0, 'He is a parmanent teacher of Kabojja Junior Junior.', '2017-11-22 05:54:47', 0),
(744, 750, 1, 1, 0, 1511331886, 0, '', '2017-11-22 06:24:46', 0),
(745, 751, 1, 1, 1, 1474243200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(746, 752, 1, 1, 1, 1474243200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(747, 753, 1, 1, 1, 1474243200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(748, 754, 1, 1, 1, 1475020800, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(749, 755, 1, 1, 1, 1475020800, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(750, 756, 1, 1, 1, 1475020800, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(751, 757, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(752, 758, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(753, 759, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(754, 760, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(755, 761, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(756, 762, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(757, 763, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(758, 764, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(759, 765, 1, 1, 1, 1475107200, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(760, 766, 1, 1, 1, 1475193600, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(761, 767, 1, 1, 1, 1475193600, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(762, 768, 1, 1, 1, 1477526400, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(763, 769, 1, 1, 1, 1477526400, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(764, 770, 1, 1, 1, 1477612800, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(765, 771, 1, 1, 1, 1477612800, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(766, 772, 1, 1, 1, 1477612800, 1, 'This member data was exported from an excel', '2017-11-22 09:04:12', 1),
(767, 773, 1, 1, 1, 1511429495, 0, '', '2017-11-23 09:31:35', 0),
(768, 774, 0, 1, 1, 1511429535, 0, '', '2018-03-06 11:45:10', 0),
(769, 775, 1, 1, 1, 1511434014, 0, '', '2017-11-23 10:46:54', 0),
(770, 777, 1, 1, 0, 1511445818, 0, '', '2017-11-23 14:03:39', 0),
(771, 778, 1, 1, 0, 1511949074, 0, 'He is a bodaboda cyclist', '2017-11-29 09:51:14', 0),
(772, 779, 1, 1, 0, 1511954193, 0, '', '2017-11-29 11:16:33', 0),
(773, 780, 1, 1, 0, 1511956606, 0, '', '2017-11-29 11:56:46', 0),
(774, 781, 1, 1, 0, 1511957952, 0, '', '2017-11-29 12:19:12', 0),
(775, 782, 1, 1, 0, 1511958598, 0, '', '2017-11-29 12:29:58', 0),
(776, 783, 1, 1, 1, 1511960378, 0, '', '2017-11-29 12:59:38', 0),
(777, 784, 1, 1, 0, 1512452107, 0, '', '2017-12-05 05:35:07', 0),
(778, 785, 1, 1, 1, 1513319535, 0, '', '2017-12-15 06:32:15', 0),
(779, 786, 1, 1, 0, 1513576983, 0, '', '2017-12-18 06:03:03', 0),
(780, 787, 1, 1, 1, 1513583540, 0, '', '2017-12-18 07:52:20', 0),
(781, 788, 1, 1, 0, 1516784514, 0, '', '2018-01-24 09:01:54', 0),
(782, 789, 0, 1, 0, 1516785690, 0, '', '2018-01-24 09:24:27', 0),
(783, 790, 1, 1, 0, 1516786324, 0, 'client is a business man', '2018-01-24 09:32:04', 0),
(784, 791, 0, 1, 0, 1516786524, 0, 'client is a business man', '2018-01-24 09:37:26', 0),
(785, 792, 1, 1, 0, 1516789340, 0, '', '2018-01-24 10:22:20', 0),
(786, 793, 1, 1, 0, 1516857446, 0, 'CLIENT IS A BUSINESS WOMAN WHO IS A HAIR DRESSER,HAS RENTAL HOUSES AND A BICYCLE SPARE PARTS SHOP IN MUTUNGO', '2018-01-25 05:17:26', 0),
(787, 795, 1, 1, 0, 1516867254, 0, '', '2018-01-25 08:00:54', 0),
(788, 796, 1, 1, 0, 1516868460, 0, '', '2018-01-25 08:21:00', 0),
(789, 797, 1, 1, 0, 1516869574, 0, '', '2018-01-25 08:39:34', 0),
(790, 798, 1, 1, 0, 1516872997, 0, '', '2018-03-06 11:56:23', 819),
(791, 801, 1, 1, 1, 1517833107, 0, '', '2018-02-05 12:18:27', 0),
(792, 802, 1, 1, 0, 1517836971, 0, '', '2018-02-05 13:22:51', 0),
(793, 803, 1, 1, 0, 1517843268, 0, '', '2018-02-05 15:07:48', 0),
(794, 804, 1, 1, 0, 1517844262, 0, '', '2018-02-05 15:24:22', 0),
(795, 805, 1, 1, 0, 1517985935, 0, '', '2018-02-07 06:45:35', 0),
(796, 806, 1, 1, 1, 1518105069, 0, '', '2018-02-08 15:51:09', 0),
(797, 807, 1, 1, 0, 1518157148, 0, '', '2018-02-09 06:19:09', 0),
(798, 808, 1, 1, 0, 1518171213, 0, '', '2018-02-09 10:13:33', 0),
(799, 809, 1, 1, 0, 1518412770, 0, '', '2018-02-12 05:19:30', 0),
(800, 810, 1, 1, 0, 1518414525, 0, '', '2018-02-12 05:48:45', 0),
(801, 811, 1, 1, 0, 1518423759, 0, '', '2018-02-12 08:22:39', 0),
(802, 812, 1, 1, 0, 1518505590, 0, '', '2018-02-13 07:06:30', 0),
(803, 813, 1, 1, 0, 1518587459, 0, '', '2018-02-14 05:57:24', 737),
(804, 814, 1, 1, 0, 1518674952, 0, '', '2018-02-15 06:09:12', 0),
(805, 815, 1, 1, 0, 1518679282, 0, '', '2018-02-15 07:21:23', 0),
(806, 816, 1, 1, 0, 1519889111, 0, '', '2018-03-01 07:25:11', 0),
(807, 817, 1, 1, 0, 1519971712, 0, '', '2018-03-02 06:24:49', 737),
(808, 818, 1, 1, 0, 1519974022, 0, '', '2018-03-02 07:00:22', 0),
(809, 820, 0, 1, 0, 1520240251, 0, '', '2018-03-05 09:35:37', 0),
(810, 821, 0, 1, 0, 1520240592, 0, '', '2018-03-05 09:35:57', 0),
(811, 822, 1, 1, 0, 1520242515, 0, '', '2018-03-05 09:35:15', 0),
(812, 823, 1, 1, 0, 1520327345, 0, '', '2018-03-06 09:09:05', 0),
(813, 824, 1, 1, 0, 1520328668, 0, '', '2018-03-06 09:31:09', 0),
(814, 825, 1, 1, 0, 1520329463, 0, '', '2018-03-06 09:44:23', 0),
(815, 826, 1, 1, 0, 1520329815, 0, '', '2018-03-06 09:50:15', 0),
(816, 827, 1, 1, 0, 1520330301, 0, '', '2018-03-06 09:58:21', 0),
(817, 828, 0, 1, 0, 1520330495, 0, '', '2018-03-06 11:03:38', 0),
(818, 829, 1, 1, 0, 1520337703, 0, '', '2018-03-06 12:01:43', 0),
(819, 830, 1, 1, 0, 1520428038, 0, '', '2018-03-07 13:07:18', 0),
(820, 831, 1, 1, 0, 1520428200, 0, '', '2018-03-07 13:10:00', 0),
(821, 832, 1, 1, 0, 1521012783, 0, '', '2018-03-14 07:33:03', 0),
(822, 833, 1, 1, 0, 1521020417, 0, '', '2018-03-14 09:40:17', 0),
(823, 834, 1, 1, 0, 1521020747, 0, '', '2018-03-14 09:45:47', 0),
(824, 835, 1, 1, 0, 1521035724, 0, '', '2018-03-14 13:55:24', 0),
(825, 836, 1, 1, 0, 1521102874, 0, '', '2018-03-15 08:34:34', 0),
(826, 837, 1, 1, 0, 1521104173, 0, '', '2018-03-15 08:56:13', 0),
(827, 838, 1, 1, 0, 1521104667, 0, '', '2018-03-15 09:04:27', 0),
(828, 839, 1, 1, 0, 1521106422, 0, '', '2018-03-15 09:33:42', 0),
(829, 840, 1, 1, 0, 1521108026, 0, '', '2018-03-15 10:01:33', 819),
(830, 841, 1, 1, 0, 1521109510, 0, 'THIS IS A JOINT ACCOUNT', '2018-03-15 10:25:10', 0),
(831, 842, 1, 1, 0, 1521111669, 0, '', '2018-03-15 11:01:09', 0),
(832, 843, 1, 1, 0, 1521111954, 0, '', '2018-03-15 11:05:54', 0),
(833, 844, 1, 1, 0, 1521179376, 0, '', '2018-03-16 05:49:36', 0),
(834, 845, 1, 1, 0, 1521450382, 0, '', '2018-03-19 09:06:22', 0),
(835, 846, 1, 1, 0, 1521450683, 0, '', '2018-03-19 09:11:23', 0),
(836, 847, 1, 1, 0, 1521450892, 0, '', '2018-03-19 09:14:52', 0),
(837, 848, 1, 1, 0, 1521451126, 0, '', '2018-03-19 09:18:46', 0),
(838, 849, 1, 1, 0, 1521451429, 0, '', '2018-03-19 09:23:49', 0),
(839, 850, 1, 1, 0, 1521452299, 0, '', '2018-03-19 09:38:19', 0),
(840, 851, 1, 1, 0, 1521452565, 0, '', '2018-03-19 09:46:07', 819),
(841, 852, 1, 1, 0, 1521452991, 0, '', '2018-03-19 09:49:51', 0),
(842, 853, 1, 1, 0, 1521453392, 0, '', '2018-03-19 09:56:32', 0),
(843, 854, 1, 1, 0, 1521453863, 0, '', '2018-03-19 10:04:23', 0),
(844, 855, 1, 1, 0, 1521456291, 0, '', '2018-03-19 10:44:51', 0),
(845, 856, 1, 1, 0, 1521456544, 0, '', '2018-03-19 10:49:04', 0),
(846, 857, 1, 1, 0, 1521459019, 0, '', '2018-03-19 11:30:19', 0),
(847, 858, 1, 1, 0, 1521459637, 0, '', '2018-03-19 11:40:37', 0),
(848, 859, 1, 1, 0, 1521459970, 0, '', '2018-03-19 11:46:10', 0),
(849, 860, 1, 1, 0, 1521460860, 0, '', '2018-03-19 12:01:00', 0),
(850, 861, 1, 1, 0, 1521461041, 0, '', '2018-03-19 12:04:01', 0),
(851, 862, 1, 1, 0, 1521463354, 0, '', '2018-03-19 12:42:34', 0),
(852, 863, 1, 1, 0, 1521463636, 0, '', '2018-03-19 12:47:16', 0),
(853, 864, 1, 1, 0, 1521463928, 0, '', '2018-03-19 12:52:08', 0),
(854, 865, 1, 1, 0, 1521464198, 0, '', '2018-03-19 12:56:38', 0),
(855, 866, 1, 1, 0, 1521464724, 0, '', '2018-03-19 13:05:24', 0),
(856, 867, 1, 1, 0, 1521464984, 0, '', '2018-03-19 13:09:44', 0),
(857, 868, 1, 1, 0, 1521465208, 0, '', '2018-03-19 13:13:28', 0),
(858, 869, 1, 1, 0, 1521465401, 0, '', '2018-03-19 13:16:41', 0),
(859, 870, 1, 1, 0, 1521465714, 0, '', '2018-03-19 13:21:54', 0),
(860, 871, 1, 1, 0, 1521465970, 0, '', '2018-03-19 13:26:10', 0),
(861, 872, 1, 1, 0, 1521467167, 0, '', '2018-03-19 13:46:07', 0),
(862, 873, 1, 1, 0, 1521468494, 0, '', '2018-03-19 14:08:14', 0),
(863, 874, 1, 1, 0, 1521524330, 0, '', '2018-03-20 05:38:50', 0),
(864, 875, 1, 1, 0, 1521524787, 0, '', '2018-03-20 05:46:27', 0),
(865, 876, 1, 1, 0, 1521525165, 0, '', '2018-03-20 05:52:45', 0),
(866, 877, 1, 1, 0, 1521525516, 0, '', '2018-03-20 05:58:36', 0),
(867, 878, 1, 1, 0, 1521525788, 0, '', '2018-03-20 06:03:08', 0),
(868, 879, 1, 1, 0, 1521526189, 0, '', '2018-03-20 06:09:49', 0),
(869, 880, 1, 1, 0, 1521526486, 0, '', '2018-03-20 06:14:46', 0),
(870, 881, 1, 1, 0, 1521528650, 0, '', '2018-03-20 06:50:50', 0),
(871, 882, 1, 1, 0, 1521530877, 0, '', '2018-03-20 07:27:57', 0),
(872, 883, 1, 1, 0, 1521536447, 0, '', '2018-03-20 09:00:47', 0),
(873, 884, 1, 1, 0, 1521536849, 0, '', '2018-03-20 09:07:29', 0),
(874, 885, 1, 1, 0, 1521537290, 0, '', '2018-03-20 09:14:50', 0),
(875, 886, 1, 1, 0, 1521537671, 0, '', '2018-03-20 09:21:11', 0),
(876, 887, 1, 1, 0, 1521543495, 0, '', '2018-03-20 10:58:15', 0),
(877, 888, 1, 1, 0, 1521543713, 0, '', '2018-03-20 11:01:53', 0),
(878, 889, 1, 1, 0, 1521628062, 0, '', '2018-03-21 10:27:42', 0),
(879, 890, 1, 1, 0, 1521628520, 0, '', '2018-03-21 10:35:20', 0),
(880, 891, 1, 1, 0, 1521632177, 0, '', '2018-03-21 11:36:17', 0),
(881, 892, 1, 1, 0, 1521632417, 0, '', '2018-03-21 11:40:17', 0),
(882, 893, 1, 1, 0, 1521632805, 0, '', '2018-03-21 11:46:45', 0),
(883, 894, 1, 1, 0, 1521633152, 0, '', '2018-03-21 11:52:32', 0),
(884, 895, 1, 1, 1, 1521633557, 0, '', '2018-03-21 11:59:17', 0),
(885, 896, 1, 1, 0, 1521633966, 0, '', '2018-03-21 12:06:06', 0),
(886, 897, 1, 1, 0, 1521634216, 0, '', '2018-03-21 12:10:16', 0),
(887, 898, 1, 1, 0, 1521634455, 0, '', '2018-03-21 12:14:15', 0),
(888, 899, 1, 1, 0, 1521635544, 0, '', '2018-03-21 12:32:24', 0),
(889, 900, 1, 1, 0, 1521635798, 0, '', '2018-03-21 12:36:38', 0),
(890, 901, 1, 1, 0, 1521636204, 0, '', '2018-03-21 12:43:24', 0),
(891, 902, 1, 1, 0, 1521637062, 0, '', '2018-03-21 12:57:42', 0),
(892, 903, 1, 1, 0, 1521718695, 0, '', '2018-03-22 11:38:15', 0),
(893, 904, 1, 1, 0, 1521723003, 0, '', '2018-03-22 12:50:03', 0),
(894, 905, 1, 1, 0, 1521791093, 0, '', '2018-03-23 07:44:53', 0),
(895, 906, 1, 1, 0, 1521791790, 0, 'BOUGHT A SHARE OF 5OOOOSHS', '2018-03-23 08:01:17', 819),
(896, 907, 1, 1, 0, 1521800059, 0, '', '2018-03-23 10:14:19', 0),
(897, 908, 1, 1, 0, 1521803643, 0, '', '2018-03-23 11:14:03', 0),
(898, 909, 1, 1, 0, 1522853070, 0, '', '2018-04-12 07:32:15', 819),
(899, 910, 1, 1, 1, 1523520585, 0, '', '2018-04-12 08:09:45', 0),
(900, 911, 1, 1, 0, 1523521545, 0, '', '2018-04-12 08:25:45', 0),
(901, 912, 1, 1, 0, 1523521769, 0, '', '2018-04-12 08:29:29', 0),
(902, 913, 1, 1, 0, 1523522158, 0, '', '2018-04-12 08:35:58', 0),
(903, 914, 1, 1, 0, 1523522954, 0, '', '2018-04-12 08:49:14', 0),
(904, 915, 1, 1, 0, 1523523227, 0, '', '2018-04-12 08:53:47', 0),
(905, 916, 1, 1, 0, 1523523553, 0, '', '2018-04-25 09:24:29', 819),
(906, 917, 1, 1, 0, 1523524075, 0, '', '2018-04-12 09:07:55', 0),
(907, 918, 1, 1, 0, 1523524450, 0, '', '2018-04-12 09:14:10', 0),
(908, 919, 1, 1, 0, 1523524879, 0, '', '2018-04-12 09:21:19', 0),
(909, 920, 1, 1, 0, 1523525966, 0, '', '2018-04-12 09:39:26', 0),
(910, 921, 1, 1, 0, 1523527242, 0, '', '2018-04-12 10:00:42', 0),
(911, 922, 1, 1, 0, 1523527505, 0, '', '2018-04-12 10:05:05', 0),
(912, 923, 1, 1, 0, 1523527726, 0, '', '2018-04-12 10:08:46', 0),
(913, 924, 1, 1, 0, 1523528083, 0, '', '2018-04-12 10:14:43', 0),
(914, 925, 1, 1, 0, 1523528700, 0, '', '2018-04-12 10:25:00', 0),
(915, 926, 1, 1, 0, 1523529597, 0, '', '2018-04-12 10:39:57', 0),
(916, 927, 1, 1, 0, 1523531368, 0, '', '2018-04-12 11:09:28', 0),
(917, 928, 1, 1, 0, 1523531803, 0, '', '2018-04-12 11:16:43', 0),
(918, 929, 1, 1, 0, 1523532155, 0, '', '2018-04-12 11:22:35', 0),
(919, 930, 1, 1, 0, 1523532410, 0, '', '2018-04-12 11:26:50', 0),
(920, 931, 1, 1, 0, 1523535456, 0, '', '2018-04-12 12:17:36', 0),
(921, 932, 1, 1, 0, 1523535754, 0, '', '2018-04-12 12:22:37', 0),
(922, 933, 1, 1, 0, 1523536837, 0, '', '2018-04-12 12:40:37', 0),
(923, 934, 1, 1, 0, 1523537809, 0, '', '2018-04-12 12:56:49', 0),
(924, 935, 1, 1, 0, 1523538065, 0, '', '2018-04-12 13:01:06', 0),
(925, 936, 1, 1, 0, 1523538391, 0, '', '2018-04-12 13:06:31', 0),
(926, 937, 1, 1, 0, 1523539061, 0, '', '2018-04-12 13:17:41', 0),
(927, 938, 1, 1, 0, 1523539380, 0, '', '2018-04-12 13:23:00', 0),
(928, 939, 1, 1, 0, 1523960546, 0, '', '2018-04-17 10:22:26', 0),
(929, 940, 1, 1, 0, 1523960750, 0, '', '2018-04-17 10:25:50', 0),
(930, 941, 1, 1, 0, 1523961617, 0, '', '2018-04-17 10:40:18', 0),
(931, 942, 1, 1, 0, 1523961911, 0, '', '2018-04-17 10:45:11', 0),
(932, 943, 1, 1, 0, 1523962456, 0, '', '2018-04-17 10:54:16', 0),
(933, 944, 1, 1, 0, 1524473061, 0, '', '2018-04-23 08:44:21', 0),
(934, 945, 1, 1, 0, 1524495241, 0, '', '2018-04-23 14:54:01', 0),
(935, 946, 1, 1, 0, 1524495436, 0, '', '2018-04-23 14:57:16', 0),
(936, 947, 1, 1, 0, 1524569953, 0, '', '2018-04-24 11:39:13', 0),
(937, 948, 1, 1, 0, 1524570297, 0, '', '2018-04-24 11:44:57', 0),
(938, 949, 1, 1, 0, 1524726672, 0, '', '2018-04-26 07:11:12', 0),
(939, 950, 1, 1, 0, 1524727046, 0, '', '2018-04-26 07:17:26', 0),
(940, 951, 1, 1, 0, 1524727299, 0, '', '2018-04-26 07:21:39', 0),
(941, 952, 1, 1, 0, 1524738479, 0, '', '2018-04-26 10:27:59', 0),
(942, 953, 1, 1, 0, 1524739369, 0, '', '2018-04-26 10:42:49', 0),
(943, 954, 1, 1, 0, 1524740324, 0, '', '2018-04-26 10:58:44', 0),
(944, 955, 1, 1, 0, 1524740791, 0, '', '2018-04-26 11:06:31', 0),
(945, 956, 1, 1, 0, 1524741071, 0, '', '2018-04-26 11:11:11', 0),
(946, 957, 1, 1, 0, 1524741415, 0, '', '2018-04-26 11:16:55', 0),
(947, 958, 1, 1, 0, 1524741779, 0, '', '2018-04-26 11:22:59', 0),
(948, 959, 1, 1, 0, 1524742107, 0, '', '2018-04-26 11:28:27', 0),
(949, 960, 1, 1, 0, 1524742593, 0, '', '2018-04-26 11:36:33', 0),
(950, 961, 1, 1, 0, 1524743121, 0, '', '2018-04-26 11:45:21', 0),
(951, 962, 1, 1, 0, 1524825708, 0, '', '2018-04-27 10:41:48', 0),
(952, 963, 1, 1, 0, 1524828205, 0, '', '2018-04-27 11:23:25', 0),
(953, 964, 1, 1, 0, 1524828428, 0, '', '2018-04-27 11:27:08', 0),
(954, 965, 1, 1, 0, 1524828762, 0, '', '2018-04-27 11:32:43', 0),
(955, 966, 1, 1, 0, 1524828959, 0, '', '2018-04-27 11:35:59', 0),
(956, 967, 1, 1, 0, 1525243394, 0, '', '2018-05-02 06:43:15', 0),
(957, 968, 0, 1, 0, 1525363171, 0, '', '2018-05-04 06:37:34', 0),
(958, 969, 1, 1, 0, 1525415725, 0, '', '2018-05-04 06:35:25', 0),
(959, 970, 1, 1, 0, 1525416232, 0, '', '2018-05-04 06:43:52', 0),
(960, 971, 1, 1, 0, 1525416588, 0, '', '2018-05-04 06:49:48', 0),
(961, 972, 1, 1, 0, 1525417036, 0, '', '2018-05-04 06:57:17', 0),
(962, 973, 1, 1, 0, 1525423253, 0, '', '2018-05-04 08:40:53', 0),
(963, 974, 1, 1, 0, 1525424041, 0, '', '2018-05-04 08:54:01', 0),
(964, 975, 0, 1, 0, 1525880873, 0, '', '2018-05-10 10:46:37', 0),
(965, 976, 0, 1, 0, 1525887178, 0, '', '2018-05-10 10:46:47', 0),
(966, 977, 1, 1, 0, 1525949775, 0, '', '2018-05-10 10:56:15', 0),
(967, 978, 1, 1, 0, 1525950199, 0, '', '2018-05-10 11:04:52', 819),
(968, 979, 1, 1, 0, 1525950454, 0, '', '2018-05-10 11:07:34', 0),
(969, 980, 1, 1, 0, 1525950772, 0, '', '2018-05-10 11:12:52', 0),
(970, 981, 1, 1, 0, 1525951784, 0, '', '2018-05-10 11:29:44', 0),
(971, 982, 1, 1, 0, 1525952053, 0, '', '2018-05-10 11:34:13', 0),
(972, 983, 1, 1, 0, 1526022561, 0, '', '2018-05-11 07:09:21', 0);

-- --------------------------------------------------------

--
-- Table structure for table `member_deposit_account`
--

CREATE TABLE `member_deposit_account` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `depositAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Holds a reference to the accounts owned by a member';

--
-- Dumping data for table `member_deposit_account`
--

INSERT INTO `member_deposit_account` (`id`, `memberId`, `depositAccountId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(2, 742, 1, 1511264600, 4, '2017-11-21 11:43:20', 4),
(3, 526, 2, 1511428772, 1, '2017-11-23 09:19:32', 1),
(4, 769, 3, 1511434071, 1, '2017-11-23 10:47:51', 1),
(5, 570, 4, 1511434388, 1, '2017-11-23 10:53:08', 1),
(6, 240, 5, 1511444534, 1, '2017-11-23 13:42:14', 1),
(7, 627, 6, 1511444955, 7, '2017-11-23 13:49:15', 7),
(8, 770, 7, 1511450474, 7, '2017-11-23 15:21:14', 7),
(9, 56, 8, 1511781934, 7, '2017-11-27 11:25:34', 7),
(10, 316, 9, 1511957076, 7, '2017-11-29 12:04:36', 7),
(11, 714, 10, 1512649647, 7, '2017-12-07 12:27:27', 7),
(12, 743, 11, 1512650258, 7, '2017-12-07 12:37:38', 7),
(13, 774, 12, 1513595727, 1, '2017-12-18 11:15:27', 1),
(14, 597, 13, 1517832098, 7, '2018-02-05 12:01:38', 7),
(15, 791, 14, 1517833213, 7, '2018-02-05 12:20:13', 7),
(16, 605, 15, 1517833727, 7, '2018-02-05 12:28:47', 7),
(17, 447, 16, 1517837197, 7, '2018-02-05 13:26:37', 7),
(18, 770, 17, 1517837277, 7, '2018-02-05 13:27:57', 7),
(19, 596, 18, 1517841211, 7, '2018-02-05 14:33:31', 7),
(20, 165, 19, 1517842327, 7, '2018-02-05 14:52:07', 7),
(21, 796, 20, 1518166869, 7, '2018-02-09 09:01:09', 7),
(22, 797, 21, 1518166904, 7, '2018-02-09 09:01:44', 7),
(23, 802, 22, 1518516412, 7, '2018-02-13 10:06:52', 7),
(24, 423, 23, 1518517337, 7, '2018-02-13 10:22:18', 7),
(25, 804, 24, 1518677447, 7, '2018-02-15 06:50:47', 7),
(26, 772, 25, 1518682588, 7, '2018-02-15 08:16:28', 7),
(27, 62, 26, 1521180984, 7, '2018-03-16 06:16:24', 7);

-- --------------------------------------------------------

--
-- Table structure for table `member_loan_account`
--

CREATE TABLE `member_loan_account` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `other_settings`
--

CREATE TABLE `other_settings` (
  `id` int(11) NOT NULL,
  `minimum_balance` bigint(20) NOT NULL,
  `maximum_guarantors` int(11) NOT NULL DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `penalty_calculation_method`
--

CREATE TABLE `penalty_calculation_method` (
  `id` int(11) NOT NULL,
  `methodDescription` varchar(150) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Methods for calculating penalities';

--
-- Dumping data for table `penalty_calculation_method`
--

INSERT INTO `penalty_calculation_method` (`id`, `methodDescription`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Overdue Principle * # of late Days * Penalty Rate', 1498487362, 1, '0000-00-00 00:00:00', 1),
(2, 'No Penalty', 1498487362, 1, '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

CREATE TABLE `person` (
  `id` int(11) NOT NULL,
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
  `phone2` varchar(23) NOT NULL,
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
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(1, '', 1, 'BFS00000001', 'ROSE', 'ZAWEDDE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(2, '', 1, 'BFS00000002', 'Jane', 'ZaIwango', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(3, '', 1, 'BFS00000003', 'JOSEPH', 'WALUSIMBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-08 00:00:00', 0, '', '', '', '', '', 0),
(4, '', 1, 'BFS00000004', 'JAMES', 'WAISWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-22 00:00:00', 0, '', '', '', '', '', 0),
(5, '', 1, 'BFS00000005', '', 'Wafula', 'Edward', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(6, '', 1, 'BFS00000006', 'Bukirwa', 'Vicky', 'Kalibbala', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-13 00:00:00', 0, '', '', '', '', '', 0),
(7, '', 1, 'BFS00000007', 'PHIONAH', 'UMONKUNDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(8, '', 1, 'BFS00000008', 'Daniel', 'Twinamasiko', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(9, '', 1, 'BFS00000009', '', 'Tukamuhabwa', 'Fred', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(10, '', 1, 'BFS00000010', 'Jovanisi', 'Tuhirirwe', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(11, '', 1, 'BFS00000011', 'VINCENT', 'TUGUME', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-04 00:00:00', 0, '', '', '', '', '', 0),
(12, '', 1, 'BFS00000012', 'Julian', 'Tugume', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(13, '', 1, 'BFS00000013', 'Christine', 'Tibagwa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(14, '', 1, 'BFS00000014', 'Elizimansi', 'Taduba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(15, 'Mr', 1, 'BFS00000015', 'SSUUNA', 'FRANCIS', '', 1, 'CM600121002URL', 'img/ids/Snapshot_20180320_28.JPG', 'M', 'Single', '0000-00-00', '(075) 383-7218', '', '', '', 'BBANDA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_27.JPG', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', 'ZONE 9', '', '', '', 819),
(16, '', 1, 'BFS00000016', 'ISAAC', 'SSIMBWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(17, '', 1, 'BFS00000017', 'DAVID', 'SSEVUME', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(18, '', 1, 'BFS00000018', 'Mukiibi', 'Ssetuba', 'Sserunjoji', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-31 00:00:00', 0, '', '', '', '', '', 0),
(19, '', 1, 'BFS00000019', '', 'SSETTUBA', 'FREDRICK', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-05 00:00:00', 0, '', '', '', '', '', 0),
(20, '', 1, 'BFS00000020', 'Hussein', 'Ssesanga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(21, '', 1, 'BFS00000021', 'DEO', 'SSERUTEEGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(22, 'Mr', 1, 'BFS00000022', 'PETER', 'SSENYONDO', '', 5, '5207', 'img/ids/Snapshot_20180323_6.JPG', 'M', 'Single', '0000-00-00', '(075) 404-7057', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', 'NDIKUTTAMADA', '', '', '', 819),
(23, '', 1, 'BFS00000023', 'ROBERT', 'SSENGENDO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-22 00:00:00', 0, '', '', '', '', '', 0),
(24, '', 1, 'BFS00000024', 'Bruhan', 'Ssemwogerere', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(25, '', 1, 'BFS00000025', 'YEKO', 'SSEMBALIRWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-13 00:00:00', 0, '', '', '', '', '', 0),
(26, '', 1, 'BFS00000026', 'ALLAN', 'SSEMANDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-03 00:00:00', 0, '', '', '', '', '', 0),
(27, 'Mr', 1, 'BFS00000027', 'EMMANUEL', 'SSEMAKULA', '', 1, 'CM77052104RD8H', '', 'M', 'Single', '0000-00-00', '(077) 788-3808', '', '', '', 'NATEETE', 'BUSINESSMAN', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-27 00:00:00', 0, 'Wakiso', 'LUNGUJJA', '', '', '', 819),
(28, '', 1, 'BFS00000028', '', 'Ssemakula', 'Zakalia', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(29, 'Mr', 1, 'BFS00000029', 'DAVID', 'SSEGULANYI', '', 1, 'CM9010010320YL', 'img/ids/Snapshot_20180323_11.JPG', 'M', 'Single', '0000-00-00', '(070) 223-9624', '', '', '', 'BUZIGA', 'DATA ENTRANT', 0, 0, NULL, 'img/profiles/Snapshot_20180323_10.JPG', 'This member data was exported from an excel', '2017-06-16 00:00:00', 0, 'KAMPALA', '', '', '', '', 819),
(30, '', 1, 'BFS00000030', 'Musa', 'Ssebuliba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-03 00:00:00', 0, '', '', '', '', '', 0),
(31, '', 1, 'BFS00000031', 'JUNDABBU', 'SSEBIRI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-29 00:00:00', 0, '', '', '', '', '', 0),
(32, '', 1, 'BFS00000032', 'Henry', 'Ssebagala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(33, '', 1, 'BFS00000033', 'Lameck', 'Sonko', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-08-31 00:00:00', 0, '', '', '', '', '', 0),
(34, '', 1, 'BFS00000034', 'Brian', 'Serunyigo', 'Isaac', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(35, '', 1, 'BFS00000035', 'DAVID', 'SERUNKUMA', '', 0, '', '', '', '', '0000-00-00', '772874618', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-26 00:00:00', 0, '', '', '', '', '', 0),
(36, '', 1, 'BFS00000036', 'Bruno', 'Serunkuma', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-20 00:00:00', 0, '', '', '', '', '', 0),
(37, '', 1, 'BFS00000037', 'Mitala', 'Serunjogi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-07 00:00:00', 0, '', '', '', '', '', 0),
(38, '', 1, 'BFS00000038', 'Daniel', 'Senyomo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-15 00:00:00', 0, '', '', '', '', '', 0),
(39, '', 1, 'BFS00000039', 'andrew', 'Senyimba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-09 00:00:00', 0, '', '', '', '', '', 0),
(40, '', 1, 'BFS00000040', 'AUGUSTINE', 'SENKUBUGE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-09 00:00:00', 0, '', '', '', '', '', 0),
(41, '', 1, 'BFS00000041', '', 'SENINDE', 'GASTER', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-17 00:00:00', 0, '', '', '', '', '', 0),
(42, '', 1, 'BFS00000042', 'MICHAEL', 'SENDAGIRE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-26 00:00:00', 0, '', '', '', '', '', 0),
(43, '', 1, 'BFS00000043', '', 'SEMWOGERERE', 'SAUDAH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(44, '', 1, 'BFS00000044', 'Steven', 'Sempala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(45, '', 1, 'BFS00000045', 'Samuel', 'Sempagala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-21 00:00:00', 0, '', '', '', '', '', 0),
(46, '', 1, 'BFS00000046', 'HUSSEIN', 'SEMPAGALA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(47, '', 1, 'BFS00000047', 'Emmanuel', 'Sembatya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(48, '', 1, 'BFS00000048', 'FRED', 'SEMAKULA', 'NOAH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-29 00:00:00', 0, '', '', '', '', '', 0),
(49, '', 1, 'BFS00000049', 'Florence', 'Semakula', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(50, '', 1, 'BFS00000050', 'Ephraim', 'semakula', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-04 00:00:00', 0, '', '', '', '', '', 0),
(51, '', 1, 'BFS00000051', '', 'SEKISAMMBU', 'IBRAHIM', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
(52, '', 1, 'BFS00000052', '', 'SEKAMATE', 'JIMMY', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-10 00:00:00', 0, '', '', '', '', '', 0),
(53, '', 1, 'BFS00000053', 'ANDREW', 'SEKAJUGO', 'MUWANGA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-12 00:00:00', 0, '', '', '', '', '', 0),
(54, '', 1, 'BFS00000054', 'Ismail', 'Seguya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(55, '', 1, 'BFS00000055', 'RONALD', 'SEGIIBWA', 'L', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-05 00:00:00', 0, '', '', '', '', '', 0),
(56, '', 1, 'BFS00000056', 'FRED', 'SEBUNYA', 'LUKUUSA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-22 00:00:00', 0, '', '', '', '', '', 0),
(57, '', 1, 'BFS00000057', 'ABDU', 'SEBULIME', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-08 00:00:00', 0, '', '', '', '', '', 0),
(58, '', 1, 'BFS00000058', 'RICHARD', 'SEBULIBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-18 00:00:00', 0, '', '', '', '', '', 0),
(59, '', 1, 'BFS00000059', 'VINCENT', 'SEBUGENYI', 'MUTANULWA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-11 00:00:00', 0, '', '', '', '', '', 0),
(60, '', 1, 'BFS00000060', 'STEVEN', 'SEBANDEKE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(61, '', 1, 'BFS00000061', 'LIBINGA', 'SAZIRI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(62, '', 1, 'BFS00000062', 'MUHAMAD', 'SALONGO', 'KALULE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-11 00:00:00', 0, '', '', '', '', '', 0),
(63, '', 1, 'BFS00000063', 'Wagwa', 'Ruth', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-08-31 00:00:00', 0, '', '', '', '', '', 0),
(64, '', 1, 'BFS00000064', 'Paul', 'Ronny', 'Kaweesa', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(65, '', 1, 'BFS00000065', 'Kateregga', 'Richard', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(66, '', 1, 'BFS00000066', 'Bukenya', 'Rebecca', 'Magezi', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-13 00:00:00', 0, '', '', '', '', '', 0),
(67, '', 1, 'BFS00000067', 'STEVEN', 'OTONYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-30 00:00:00', 0, '', '', '', '', '', 0),
(68, '', 1, 'BFS00000068', '', 'OMUGAVENSWA', 'JOE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-04 00:00:00', 0, '', '', '', '', '', 0),
(69, '', 1, 'BFS00000069', '', 'OMACHA', 'MIRIAM', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(70, '', 1, 'BFS00000070', 'STEFANIA', 'NYONGERA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(71, '', 1, 'BFS00000071', 'Stephen', 'Nyombi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(72, '', 1, 'BFS00000072', 'JOSHUA', 'NYOGOLI', 'KISOGA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(73, '', 1, 'BFS00000073', 'JOSHUA', 'NYOGOLI', 'KISOGA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(74, '', 1, 'BFS00000074', '', 'NYIMABASHEKA', 'LILIAN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(75, 'Mr', 1, 'BFS00000075', 'GODFREY', 'NYANZI', '', 1, 'CM81052106Z05L', 'img/ids/Snapshot_20180320_30.JPG', 'M', 'Single', '0000-00-00', '(075) 132-1468', '', '', '', 'NDIKUTTAMADA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_29.JPG', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', 'MASAJJA', '', '', '', 819),
(76, '', 1, 'BFS00000076', 'KEDRESS', 'NYANJURA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-08 00:00:00', 0, '', '', '', '', '', 0),
(77, '', 1, 'BFS00000077', 'karlson', 'Nvuule', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-27 00:00:00', 0, '', '', '', '', '', 0),
(78, '', 1, 'BFS00000078', 'Namutebi', 'Nusifa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(79, '', 1, 'BFS00000079', 'PETER', 'NTULUME', 'KATO', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-13 00:00:00', 0, '', '', '', '', '', 0),
(80, '', 1, 'BFS00000080', 'SHAMIM', 'NTONGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(81, '', 1, 'BFS00000081', 'SHAMIM', 'NTONGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(82, '', 1, 'BFS00000082', 'John', 'Ntambi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(83, '', 1, 'BFS00000083', '', 'Ntale', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(84, '', 1, 'BFS00000084', 'Wilber', 'Nsubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(85, '', 1, 'BFS00000085', 'Samuel', 'Nsubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(86, '', 1, 'BFS00000086', 'JOSEPH', 'NSUBUGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-18 00:00:00', 0, '', '', '', '', '', 0),
(87, '', 1, 'BFS00000087', 'Jimmy', 'Nsubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-28 00:00:00', 0, '', '', '', '', '', 0),
(88, '', 1, 'BFS00000088', 'Edwin', 'Nsubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(89, '', 1, 'BFS00000089', 'DENIS', 'NSOBYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-31 00:00:00', 0, '', '', '', '', '', 0),
(90, '', 1, 'BFS00000090', 'YASIN', 'NSEREKO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-27 00:00:00', 0, '', '', '', '', '', 0),
(91, '', 1, 'BFS00000091', 'Dan', 'Nsereko', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(92, '', 1, 'BFS00000092', 'RHODA', 'NSANGI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-28 00:00:00', 0, '', '', '', '', '', 0),
(93, '', 1, 'BFS00000093', 'WASWA', 'NSAMBA', 'MARTIN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(94, '', 1, 'BFS00000094', 'Ruth', 'Nsamba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(95, '', 1, 'BFS00000095', 'John', 'Nsamba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(96, '', 1, 'BFS00000096', 'BENARD', 'NOWASIIMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-04 00:00:00', 0, '', '', '', '', '', 0),
(97, 'Mr', 1, 'BFS00000097', 'DEO', 'NKUNDIZIZANA', '', 1, 'CM770', '', 'M', 'Single', '0000-00-00', '(075) 329-4411', '', '', '', 'NAMASUBA', 'SELF EMPLOYED', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(98, '', 1, 'BFS00000098', 'FRED', 'NKUGWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-31 00:00:00', 0, '', '', '', '', '', 0),
(99, '', 1, 'BFS00000099', 'SCOVIA', 'NIMUSIIMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(100, '', 1, 'BFS00000100', 'SARAH', 'NEWUMBE', 'GRACE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(101, '', 1, 'BFS00000101', 'PASCAL', 'NEGULE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(102, '', 1, 'BFS00000102', 'DAVID', 'NDOBE', 'JOTHAM', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-10 00:00:00', 0, '', '', '', '', '', 0),
(103, '', 1, 'BFS00000103', 'Barnabas', 'Ndawula', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-04 00:00:00', 0, '', '', '', '', '', 0),
(104, '', 1, 'BFS00000104', 'Sarah', 'Ndagire', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(105, '', 1, 'BFS00000105', 'JANE', 'NDAGIRE', 'FRANCES', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-10 00:00:00', 0, '', '', '', '', '', 0),
(106, '', 1, 'BFS00000106', 'JANE', 'NDAGIRE', 'FRANCES', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-10 00:00:00', 0, '', '', '', '', '', 0),
(107, '', 1, 'BFS00000107', 'FLORENCE', 'NDAGIRE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-31 00:00:00', 0, '', '', '', '', '', 0),
(108, '', 1, 'BFS00000108', 'SARAH', 'NAZZIWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(109, '', 1, 'BFS00000109', 'SAYIDAT', 'NAYIGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-05 00:00:00', 0, '', '', '', '', '', 0),
(110, '', 1, 'BFS00000110', 'Nusura', 'Nayiga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(111, '', 1, 'BFS00000111', '', 'NAYIGA', 'NOORAH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(112, '', 1, 'BFS00000112', '', 'Nayiga', 'Annet', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(113, '', 1, 'BFS00000113', 'Mayimuna', 'Nawaguma', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(114, '', 1, 'BFS00000114', 'Faridah', 'Nawaguma', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(115, '', 1, 'BFS00000115', 'MIRIAM', 'NATUKUNDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-03 00:00:00', 0, '', '', '', '', '', 0),
(116, '', 1, 'BFS00000116', 'Fiona', 'Nasuuna', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(117, '', 1, 'BFS00000117', 'JANET', 'NASSOZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(118, '', 1, 'BFS00000118', 'AIDAH', 'NASSOZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, '', '', '', '', '', 0),
(119, '', 1, 'BFS00000119', 'HASIFA', 'NASSOLO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(120, '', 1, 'BFS00000120', 'ERON', 'NASSIWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(121, '', 1, 'BFS00000121', 'MAGGIE', 'NASSIMBWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-15 00:00:00', 0, '', '', '', '', '', 0),
(122, '', 1, 'BFS00000122', 'JULIET', 'NASSIMBWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(123, 'Mrs', 1, 'BFS00000123', 'MASTULA', 'NASSANGA', '', 1, 'CF8005210GQAH', '', 'F', 'Single', '0000-00-00', '(070) 108-8901', '', '', '', 'Masajja', 'BUSINESS WOMAN', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-30 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(124, '', 1, 'BFS00000124', 'MARIAM', 'NASSALI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(125, '', 1, 'BFS00000125', 'GERTRUDE', 'NASSAAZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(126, '', 1, 'BFS00000126', 'Edward', 'Naserenga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(127, '', 1, 'BFS00000127', 'Noelina', 'Nasali', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(128, '', 1, 'BFS00000128', 'Tinah', 'Nasaazi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(129, '', 1, 'BFS00000129', '', 'Nanziri', 'Vina', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(130, '', 1, 'BFS00000130', 'Jane', 'Nanyonjo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(131, '', 1, 'BFS00000131', 'HADIJA', 'NANYONJO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-03 00:00:00', 0, '', '', '', '', '', 0),
(132, '', 1, 'BFS00000132', 'AIDAH', 'NANYONJO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-03 00:00:00', 0, '', '', '', '', '', 0),
(133, '', 1, 'BFS00000133', '', 'Nanyonjo', 'Harriet', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(134, '', 1, 'BFS00000134', 'Hadijja', 'Nanyombi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(135, '', 1, 'BFS00000135', 'Sarah', 'Nanyanzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(136, '', 1, 'BFS00000136', 'Rehema', 'Nanvuma', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-17 00:00:00', 0, '', '', '', '', '', 0),
(137, '', 1, 'BFS00000137', 'Viola', 'Nantume', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(138, '', 1, 'BFS00000138', 'Sauba', 'Nantume', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(139, '', 1, 'BFS00000139', 'Ritah', 'Nantume', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0),
(140, '', 1, 'BFS00000140', '', 'NANTUMBWE', 'RUTH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(141, 'Mrs', 1, 'BFS00000141', 'ROBINAH', 'NANTUBWE', '', 1, 'CF905210FNOML', 'img/ids/Snapshot_20180426_1.JPG', 'F', 'Married', '0000-00-00', '(078) 209-2093', '', '', '', 'ZANA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180426_1.JPG', 'This member data was exported from an excel', '2017-06-06 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(142, '', 1, 'BFS00000142', 'Masitulah', 'Nantongo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(143, '', 1, 'BFS00000143', 'Hasifah', 'Nantongo', 'Amir', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(144, '', 1, 'BFS00000144', 'Fatuma', 'Nanteza', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(145, '', 1, 'BFS00000145', 'ANNET', 'NANTEZA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-18 00:00:00', 0, '', '', '', '', '', 0),
(146, '', 1, 'BFS00000146', 'Nooru', 'Nansubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(147, '', 1, 'BFS00000147', 'Justine', 'Nansubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(148, '', 1, 'BFS00000148', 'JAZIRAAH', 'NANSUBUGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(149, 'Mrs', 1, 'BFS00000149', 'NANSUBUGA', 'ROBINAH', '', 5, 'CF810', 'img/ids/Snapshot_20180321_6.JPG', 'F', 'Single', '0000-00-00', '(077) 202-9976', '', '', '', 'MASAJJA ZONE B', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_6.JPG', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', 'NDILUCUTTA MADDA', 819),
(150, '', 1, 'BFS00000150', 'Agnes', 'Nansereko', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(151, '', 1, 'BFS00000151', 'CATHERINE', 'NANSERA', '', 0, '', '', '', '', '0000-00-00', '755934824', '775830401', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-26 00:00:00', 0, '', '', '', '', '', 0),
(152, '', 1, 'BFS00000152', 'JESCA', 'NANSASI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(153, '', 1, 'BFS00000153', 'Faridah', 'Nansamba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(154, '', 1, 'BFS00000154', 'Faridah', 'Nansamba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(155, '', 1, 'BFS00000155', 'Harriet', 'Nanono', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(156, '', 1, 'BFS00000156', 'CHRISTINE', 'NANKYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(157, '', 1, 'BFS00000157', '', 'NANKYA', 'AISHA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(158, '', 1, 'BFS00000158', 'HOPE', 'NANKINGA', 'AISH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-08 00:00:00', 0, '', '', '', '', '', 0),
(159, '', 1, 'BFS00000159', 'ELLEN', 'NANKINGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-19 00:00:00', 0, '', '', '', '', '', 0),
(160, '', 1, 'BFS00000160', 'DEBORAH', 'NANKANJA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(161, '', 1, 'BFS00000161', '', 'Nankabirwa', 'Ruth', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(162, '', 1, 'BFS00000162', 'ZAINAH', 'NANJEGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-31 00:00:00', 0, '', '', '', '', '', 0),
(163, '', 1, 'BFS00000163', '', 'NANGONZI', 'MERCY', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-08 00:00:00', 0, '', '', '', '', '', 0),
(164, '', 1, 'BFS00000164', 'BENNA', 'NANFUKA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
(165, '', 1, 'BFS00000165', 'BANALETA', 'NANFUKA', '', 0, '', '', '', '', '0000-00-00', '703309289', '784848645', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-20 00:00:00', 0, '', '', '', '', '', 0),
(166, '', 1, 'BFS00000166', '', 'Nanfuka', 'Aisha', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(167, '', 1, 'BFS00000167', 'SARAH', 'NANDUDU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-03 00:00:00', 0, '', '', '', '', '', 0),
(168, '', 1, 'BFS00000168', 'Sylivia', 'Nandawula', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(169, '', 1, 'BFS00000169', 'Brenda', 'Nandawula', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(170, '', 1, 'BFS00000170', 'Rehema', 'Namyenya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(171, '', 1, 'BFS00000171', 'Fatuma', 'Namyalo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(172, '', 1, 'BFS00000172', 'CISSY', 'NAMWIJUGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-07 00:00:00', 0, '', '', '', '', '', 0),
(173, '', 1, 'BFS00000173', 'Lydia', 'Namwase', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(174, '', 1, 'BFS00000174', 'Mastula', 'Namwanje', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-25 00:00:00', 0, '', '', '', '', '', 0),
(175, '', 1, 'BFS00000175', 'GRACE', 'NAMWANJE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
(176, '', 1, 'BFS00000176', 'Prossy', 'Namuyomba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(177, '', 1, 'BFS00000177', 'HAMIDAH', 'NAMUYOMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(178, '', 1, 'BFS00000178', 'AISHA', 'NAMUYOMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(179, '', 1, 'BFS00000179', 'FLORENCE', 'NAMUYANJA', 'MUYIMBA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-29 00:00:00', 0, '', '', '', '', '', 0),
(180, '', 1, 'BFS00000180', 'Gladys', 'Namuyaga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(181, '', 1, 'BFS00000181', 'Gloria', 'Namuwonge', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(182, '', 1, 'BFS00000182', 'Shirat', 'Namutebi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(183, '', 1, 'BFS00000183', 'NULUYATI', 'NAMUTEBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(184, '', 1, 'BFS00000184', 'MARGRET', 'NAMUTEBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-11 00:00:00', 0, '', '', '', '', '', 0),
(185, '', 1, 'BFS00000185', 'Margret', 'Namutebi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-10 00:00:00', 0, '', '', '', '', '', 0),
(186, '', 1, 'BFS00000186', 'Madina', 'Namutebi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(187, 'Mrs', 1, 'BFS00000187', 'JULIET', 'NAMUTEBI', '', 1, 'CF6905210DHHOL', 'img/ids/Snapshot_20180321_24.JPG', 'F', 'Single', '0000-00-00', '(077) 661-6135', '', '', '', 'MASAJJA ZONE B', 'TAILOR', 0, 0, NULL, 'img/profiles/Snapshot_20180321_23.JPG', 'This member data was exported from an excel', '2017-09-20 00:00:00', 0, 'MASAJJA B', '', '', '', '', 819),
(188, '', 1, 'BFS00000188', 'Jalia', 'Namutebi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-31 00:00:00', 0, '', '', '', '', '', 0),
(189, '', 1, 'BFS00000189', 'Eve', 'Namutebi', 'Namubiru', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(190, '', 1, 'BFS00000190', '', 'Namutebi', 'Shanitah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(191, '', 1, 'BFS00000191', '', 'Namutebi', 'Proscovia', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(192, '', 1, 'BFS00000192', '', 'NAMUSWE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(193, '', 1, 'BFS00000193', 'Stella', 'Namusoke', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(194, '', 1, 'BFS00000194', 'MARY', 'NAMUSOKE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-21 00:00:00', 0, '', '', '', '', '', 0),
(195, '', 1, 'BFS00000195', 'JANE', 'NAMUSISI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(196, '', 1, 'BFS00000196', 'Harriet', 'Namusisi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(197, '', 1, 'BFS00000197', '', 'Namulinde', 'Zam', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(198, '', 1, 'BFS00000198', 'AGALI', 'NAMULIIRA', 'JULIET', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-05 00:00:00', 0, '', '', '', '', '', 0),
(199, '', 1, 'BFS00000199', 'Noor', 'Namuli', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(200, '', 1, 'BFS00000200', 'Evelyn', 'Namuli', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(201, '', 1, 'BFS00000201', 'JANAT', 'NAMULEME', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-09 00:00:00', 0, '', '', '', '', '', 0),
(202, '', 1, 'BFS00000202', 'Aisha', 'Namuleme', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(203, '', 1, 'BFS00000203', 'Margret', 'Namukwaya', 'Kyatelekera', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(204, '', 1, 'BFS00000204', 'Ruth', 'Namukasa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-25 00:00:00', 0, '', '', '', '', '', 0),
(205, '', 1, 'BFS00000205', 'Edith', 'Namukasa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(206, '', 1, 'BFS00000206', 'Madreene', 'Namujjuzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(207, '', 1, 'BFS00000207', '', 'Namujju', 'Jane', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(208, 'Mr', 1, 'BFS00000208', 'JOYCE', 'NAMUGERWA', '', 1, 'CF84024103R4PL', 'img/ids/Snapshot_20180320_41.JPG', 'F', 'Single', '0000-00-00', '(078) 247-4946', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_40.JPG', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(209, '', 1, 'BFS00000209', 'Masitula', 'Namugenyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(210, '', 1, 'BFS00000210', 'JAMIDAH', 'NAMUGENYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(211, '', 1, 'BFS00000211', 'HALIMA', 'NAMUGENYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-20 00:00:00', 0, '', '', '', '', '', 0),
(212, '', 1, 'BFS00000212', 'Aida', 'Namugenyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-23 00:00:00', 0, '', '', '', '', '', 0),
(213, '', 1, 'BFS00000213', 'BENAH', 'NAMUGAYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(214, '', 1, 'BFS00000214', 'LOSIRA', 'NAMUGAYA', 'EDITH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(215, '', 1, 'BFS00000215', '', 'NAMUGANZA', 'SALIMA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
(216, '', 1, 'BFS00000216', 'Milly', 'Namuganyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(217, '', 1, 'BFS00000217', '', 'Namugambe', 'Grace', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(218, '', 1, 'BFS00000218', 'IRENE', 'NAMUGABO', 'JOYCE', 0, '', '', '', '', '0000-00-00', '789477920', '73600923', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-11 00:00:00', 0, '', '', '', '', '', 0),
(219, '', 1, 'BFS00000219', 'REGINAH', 'NAMUDDU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(220, '', 1, 'BFS00000220', 'c', 'Namuddu', 'Kiyaga', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-18 00:00:00', 0, '', '', '', '', '', 0),
(221, '', 1, 'BFS00000221', 'Teddy', 'Namubiru', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(222, '', 1, 'BFS00000222', 'MAYI', 'NAMUBIRU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(223, '', 1, 'BFS00000223', 'HASIFAH', 'NAMUBIIRU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(224, '', 1, 'BFS00000224', 'Prossy', 'Nampima', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(225, '', 1, 'BFS00000225', '', 'NAMITALA', 'JOAN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-17 00:00:00', 0, '', '', '', '', '', 0),
(226, '', 1, 'BFS00000226', '', 'Namisango', 'Zakia', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(227, '', 1, 'BFS00000227', '', 'Namisango', 'Jane', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-27 00:00:00', 0, '', '', '', '', '', 0),
(228, '', 1, 'BFS00000228', 'Ramula', 'Namirembe', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(229, '', 1, 'BFS00000229', 'MEDRINE', 'NAMIREMBE', '', 0, '', '', '', '', '0000-00-00', '754527562', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-14 00:00:00', 0, '', '', '', '', '', 0),
(230, '', 1, 'BFS00000230', 'Jenefer', 'Nambuya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(231, '', 1, 'BFS00000231', 'JUDITH', 'NAMBOOZO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, '', '', '', '', '', 0),
(232, '', 1, 'BFS00000232', 'Juliet', 'Nambiite', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(233, '', 1, 'BFS00000233', 'CAROL', 'NAMBASA', '', 0, '', '', '', '', '0000-00-00', '752415721', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-17 00:00:00', 0, '', '', '', '', '', 0),
(234, '', 1, 'BFS00000234', 'Faridah', 'Namazzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(235, '', 1, 'BFS00000235', 'Resty', 'Namayengo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(236, '', 1, 'BFS00000236', 'PROSCOVIA', 'NAMAYANJA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-02 00:00:00', 0, '', '', '', '', '', 0),
(237, '', 1, 'BFS00000237', 'OLIVE', 'NAMAWUBA', 'LWANGA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-08 00:00:00', 0, '', '', '', '', '', 0),
(238, '', 1, 'BFS00000238', 'Zulaikah', 'Namatovu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(239, '', 1, 'BFS00000239', 'Winfred', 'Namatovu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(240, '', 1, 'BFS00000240', 'SARAH', 'NAMATOVU', 'SENTONGO', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-08 00:00:00', 0, '', '', '', '', '', 0),
(241, '', 1, 'BFS00000241', 'Sarah', 'Namatovu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(242, '', 1, 'BFS00000242', 'PAULINE', 'NAMATA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-06 00:00:00', 0, '', '', '', '', '', 0),
(243, '', 1, 'BFS00000243', 'ANNET', 'NAMATA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-07 00:00:00', 0, '', '', '', '', '', 0),
(244, '', 1, 'BFS00000244', 'Sarah', 'Namale', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(245, '', 1, 'BFS00000245', 'MELANIE', 'NAMALE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-06 00:00:00', 0, '', '', '', '', '', 0),
(246, '', 1, 'BFS00000246', 'WINFRED', 'NAMAKULA', '', 0, '', '', '', '', '0000-00-00', '753933348', '786004192', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-31 00:00:00', 0, '', '', '', '', '', 0),
(247, '', 1, 'BFS00000247', 'SARAH', 'NAMAKULA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
(248, '', 1, 'BFS00000248', 'REBECCA', 'NAMAKULA', 'LOVINSOR', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(249, '', 1, 'BFS00000249', 'Baker', 'Namakula', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(250, '', 1, 'BFS00000250', 'PATRICIA', 'NAMAGEMBE', 'PROSSY', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(251, '', 1, 'BFS00000251', 'Patience', 'Namagembe', 'Favour', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(252, '', 1, 'BFS00000252', 'Gorret', 'Namagembe', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-15 00:00:00', 0, '', '', '', '', '', 0),
(253, '', 1, 'BFS00000253', '', 'Namagembe', 'Sarah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(254, '', 1, 'BFS00000254', 'OLIVIA', 'NAMAGANDA', 'COX', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-03 00:00:00', 0, '', '', '', '', '', 0),
(255, '', 1, 'BFS00000255', 'LUKIA', 'NAMAGANDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-07 00:00:00', 0, '', '', '', '', '', 0),
(256, '', 1, 'BFS00000256', 'Gatrude', 'Namaganda', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(257, '', 1, 'BFS00000257', 'ZULAIKA', 'NALWOGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-05 00:00:00', 0, '', '', '', '', '', 0),
(258, '', 1, 'BFS00000258', 'Margret', 'Nalwoga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(259, '', 1, 'BFS00000259', 'SHARON', 'NALWEYISO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-19 00:00:00', 0, '', '', '', '', '', 0),
(260, '', 1, 'BFS00000260', 'Prossy', 'Nalweyiso', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(261, '', 1, 'BFS00000261', 'AFUWA', 'NALWEYISO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-28 00:00:00', 0, '', '', '', '', '', 0),
(262, '', 1, 'BFS00000262', 'Florence', 'Nalwanga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-02 00:00:00', 0, '', '', '', '', '', 0),
(263, '', 1, 'BFS00000263', 'AMINAH', 'NALWADDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-05 00:00:00', 0, '', '', '', '', '', 0),
(264, '', 1, 'BFS00000264', 'SAYYIDAT', 'NALUYIMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(265, '', 1, 'BFS00000265', 'MARGRET', 'NALUYIMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-23 00:00:00', 0, '', '', '', '', '', 0),
(266, '', 1, 'BFS00000266', 'Janat', 'Naluwooza', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-05 00:00:00', 0, '', '', '', '', '', 0),
(267, '', 1, 'BFS00000267', 'OLIVIA', 'NALUSE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(268, '', 1, 'BFS00000268', 'Aisha', 'Nalunkuma', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(269, '', 1, 'BFS00000269', 'Prossy', 'Nalunga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-27 00:00:00', 0, '', '', '', '', '', 0),
(270, '', 1, 'BFS00000270', 'Grace', 'Nalumansi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-10 00:00:00', 0, '', '', '', '', '', 0),
(271, '', 1, 'BFS00000271', 'GRACE', 'NALULE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-20 00:00:00', 0, '', '', '', '', '', 0),
(272, '', 1, 'BFS00000272', '', 'Nalule', 'Zam', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(273, '', 1, 'BFS00000273', 'PROSCOVIA', 'NALUKWAGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-11 00:00:00', 0, '', '', '', '', '', 0),
(274, '', 1, 'BFS00000274', 'Faridah', 'Nalukwago', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-31 00:00:00', 0, '', '', '', '', '', 0),
(275, '', 1, 'BFS00000275', 'Resty', 'Nalukenge', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(276, '', 1, 'BFS00000276', 'IMMACULATE', 'NALUKENGE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(277, '', 1, 'BFS00000277', 'HELLEN', 'NALUGYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-08 00:00:00', 0, '', '', '', '', '', 0),
(278, '', 1, 'BFS00000278', '', 'NALUGYA', 'PHIONAH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-05 00:00:00', 0, '', '', '', '', '', 0),
(279, '', 1, 'BFS00000279', 'LISA', 'NALUGWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(280, '', 1, 'BFS00000280', 'Irene', 'Nalugwa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(281, '', 1, 'BFS00000281', 'Hasifah', 'Nalugo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(282, '', 1, 'BFS00000282', 'Rose', 'Naluggya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(283, '', 1, 'BFS00000283', 'Ausmin', 'Naluggya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(284, '', 1, 'BFS00000284', 'ROBINA', 'NALUGAVE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-06 00:00:00', 0, '', '', '', '', '', 0),
(285, '', 1, 'BFS00000285', '', 'Nalubwama', 'Zuraikah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-05 00:00:00', 0, '', '', '', '', '', 0),
(286, '', 1, 'BFS00000286', 'JOYCE', 'NALUBULWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-08 00:00:00', 0, '', '', '', '', '', 0),
(287, '', 1, 'BFS00000287', 'Ritah', 'Nalubowa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(288, '', 1, 'BFS00000288', 'MIRIAM', 'NALUBOWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-05 00:00:00', 0, '', '', '', '', '', 0),
(289, '', 1, 'BFS00000289', 'Sarah', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(290, '', 1, 'BFS00000290', 'Rehema', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(291, '', 1, 'BFS00000291', 'Oliver', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(292, '', 1, 'BFS00000292', 'Leilah', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(293, '', 1, 'BFS00000293', 'Irene', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(294, '', 1, 'BFS00000294', 'Aminah', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(295, '', 1, 'BFS00000295', 'Agnes', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(296, '', 1, 'BFS00000296', 'NORAH', 'NALONGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-28 00:00:00', 0, '', '', '', '', '', 0),
(297, '', 1, 'BFS00000297', 'FATMA', 'NALONGO', 'NABACWA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(298, '', 1, 'BFS00000298', '', 'NALIKA', 'JOSEPHINE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(299, '', 1, 'BFS00000299', 'Zuraikah', 'Nakyonyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-03 00:00:00', 0, '', '', '', '', '', 0),
(300, '', 1, 'BFS00000300', 'Eva', 'Nakyanzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(301, '', 1, 'BFS00000301', '', 'NAKYANZI', 'AGNES', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(302, '', 1, 'BFS00000302', 'Fatuma', 'Nakubulwa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(303, '', 1, 'BFS00000303', '', 'Nakiyombya', 'Violet', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(304, '', 1, 'BFS00000304', 'JANE', 'NAKIYINGI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-08 00:00:00', 0, '', '', '', '', '', 0),
(305, '', 1, 'BFS00000305', 'Patience', 'Nakiwala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(306, '', 1, 'BFS00000306', 'Agatha', 'Nakiwala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(307, '', 1, 'BFS00000307', '', 'NAKIWALA', 'RUTH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-15 00:00:00', 0, '', '', '', '', '', 0),
(308, '', 1, 'BFS00000308', 'ROSE', 'NAKIVUMBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(309, '', 1, 'BFS00000309', 'Fiona', 'Nakityo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(310, '', 1, 'BFS00000310', 'Deborah', 'Nakitto', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(311, 'Mr', 1, 'BFS00000311', 'CATHY', 'NAKITTO', '', 1, 'CF860', '', 'F', 'Single', '0000-00-00', '(078) 224-7316', '', '', '', 'NANKULABYE', 'SELF EMPLOYED', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, 'KAMPALA', '', '', '', '', 819),
(312, '', 1, 'BFS00000312', 'BENADETTE', 'NAKITENDE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(313, '', 1, 'BFS00000313', '', 'NAKISOZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(314, '', 1, 'BFS00000314', 'RASHIDA', 'NAKIRYOWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(315, '', 1, 'BFS00000315', 'Unia', 'Nakirigya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-25 00:00:00', 0, '', '', '', '', '', 0),
(316, '', 1, 'BFS00000316', 'CABRINE', 'NAKIRANDA', 'FRANCESXAVIER', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-27 00:00:00', 0, '', '', '', '', '', 0),
(317, '', 1, 'BFS00000317', 'RHODA', 'NAKINTU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-05 00:00:00', 0, '', '', '', '', '', 0),
(318, '', 1, 'BFS00000318', '', 'NAKINTU', 'JANE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(319, '', 1, 'BFS00000319', '', 'NAKINTU', 'GRACE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(320, '', 1, 'BFS00000320', '', 'NAKIMERA', 'FATUMA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-01 00:00:00', 0, '', '', '', '', '', 0),
(321, '', 1, 'BFS00000321', 'FLORENCE', 'NAKIMBUGWE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-15 00:00:00', 0, '', '', '', '', '', 0),
(322, '', 1, 'BFS00000322', 'ALLEN', 'NAKIKU', 'MULWANA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-09 00:00:00', 0, '', '', '', '', '', 0),
(323, '', 1, 'BFS00000323', 'REHMA', 'NAKIGUDDE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(324, '', 1, 'BFS00000324', 'Nangendo', 'Nakigozi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-16 00:00:00', 0, '', '', '', '', '', 0),
(325, '', 1, 'BFS00000325', 'Dorothy', 'Nakigozi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(326, '', 1, 'BFS00000326', 'SARAH', 'NAKIGANDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(327, '', 1, 'BFS00000327', 'EVA', 'NAKIGANDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-16 00:00:00', 0, '', '', '', '', '', 0),
(328, '', 1, 'BFS00000328', 'MARGRET', 'NAKIBUUKA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(329, '', 1, 'BFS00000329', 'CHRISTINE', 'NAKIBUKA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(330, '', 1, 'BFS00000330', '', 'Nakibuka', 'Shamim', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(331, '', 1, 'BFS00000331', 'JUSTINE', 'NAKIBONEKA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-10 00:00:00', 0, '', '', '', '', '', 0),
(332, '', 1, 'BFS00000332', 'Samalie', 'Nakibirango', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-10 00:00:00', 0, '', '', '', '', '', 0),
(333, '', 1, 'BFS00000333', 'Sarah', 'Nakiberu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(334, '', 1, 'BFS00000334', 'REHEMA', 'NAKAZIBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(335, '', 1, 'BFS00000335', 'MARGARET', 'NAKAYIZZA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-18 00:00:00', 0, '', '', '', '', '', 0),
(336, '', 1, 'BFS00000336', 'sarah', 'nakayiza', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(337, '', 1, 'BFS00000337', '', 'NAKAYIWA', 'SYLVIA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, '', '', '', '', '', 0),
(338, '', 1, 'BFS00000338', 'Faith', 'Nakayinga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(339, 'Mrs', 1, 'BFS00000339', 'NAKAYIKI', 'LYDIA', '', 1, 'CF89030106J8LA', 'img/ids/Snapshot_20180315_7.JPG', 'F', 'Married', '0000-00-00', '(070) 478-9553', '', '', 'NTINDA MINTERS VILLAGE', 'NTINDA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180315_8.JPG', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 819),
(340, 'Mrs', 1, 'BFS00000340', 'RUKIA', 'NAKAYI', '', 3, 'B1024483', 'img/ids/Snapshot_20180323_13.JPG', 'F', 'Single', '0000-00-00', '(078) 130-8055', '', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-16 00:00:00', 0, '', '', '', '', '', 819),
(341, '', 1, 'BFS00000341', '', 'NAKAYENGA', 'NUULIATTI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(342, '', 1, 'BFS00000342', 'HADIJA', 'NAKAWUNGU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(343, '', 1, 'BFS00000343', '', 'Nakawungu', 'Sarah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(344, '', 1, 'BFS00000344', 'Jiidah', 'Nakawunde', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(345, '', 1, 'BFS00000345', 'Mary', 'Nakawuki', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(346, '', 1, 'BFS00000346', 'Jalia', 'Nakawuki', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(347, '', 1, 'BFS00000347', 'GORRETI', 'NAKAWOMBE', 'SANDRA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(348, '', 1, 'BFS00000348', 'JOVIA', 'NAKAVUMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(349, '', 1, 'BFS00000349', '', 'NAKATTE', 'ZAMU', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-31 00:00:00', 0, '', '', '', '', '', 0),
(350, '', 1, 'BFS00000350', 'Rebecca', 'Nakate', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(351, '', 1, 'BFS00000351', 'Joyce', 'Nakate', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(352, '', 1, 'BFS00000352', 'Hasifah', 'Nakate', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(353, '', 1, 'BFS00000353', 'RITAH', 'NAKASUMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(354, '', 1, 'BFS00000354', 'Saudah', 'Nakasujja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(355, '', 1, 'BFS00000355', 'Sarah', 'Nakasi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(356, '', 1, 'BFS00000356', 'Florence', 'Nakasaawe', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(357, '', 1, 'BFS00000357', 'Rose', 'Nakanyike', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(358, '', 1, 'BFS00000358', 'Justine', 'Nakanyike', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(359, '', 1, 'BFS00000359', 'Gorreth', 'Nakanyike', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(360, '', 1, 'BFS00000360', 'MADALENA', 'NAKANWAGI', '&MUSOKE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(361, '', 1, 'BFS00000361', 'ROBINAH', 'NAKANJAKO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(362, '', 1, 'BFS00000362', 'Sherina', 'Nakamya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(363, '', 1, 'BFS00000363', 'Rosette', 'Nakalyango', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-04 00:00:00', 0, '', '', '', '', '', 0),
(364, '', 1, 'BFS00000364', 'ZUURA', 'NAKALEMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-17 00:00:00', 0, '', '', '', '', '', 0),
(365, '', 1, 'BFS00000365', 'Scovia', 'Nakalema', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-03 00:00:00', 0, '', '', '', '', '', 0),
(366, '', 1, 'BFS00000366', 'PROSSY', 'NAKALEMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(367, '', 1, 'BFS00000367', 'AMINAH', 'NAKALEMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
(368, '', 1, 'BFS00000368', 'Joyce', 'Nakalawa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(369, '', 1, 'BFS00000369', 'JACKIE', 'NAKAGERE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-06 00:00:00', 0, '', '', '', '', '', 0),
(370, '', 1, 'BFS00000370', 'MARGRET', 'NAKACWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(371, '', 1, 'BFS00000371', 'CAROL', 'NAKABOGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-29 00:00:00', 0, '', '', '', '', '', 0),
(372, '', 1, 'BFS00000372', 'Lydia', 'Nakabiri', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(373, '', 1, 'BFS00000373', '', 'Nakabira', 'Max', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-27 00:00:00', 0, '', '', '', '', '', 0),
(374, '', 1, 'BFS00000374', 'Robert', 'Nakabaale', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-27 00:00:00', 0, '', '', '', '', '', 0),
(375, '', 1, 'BFS00000375', 'Puline', 'Nakaayi', 'Bisaso', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-10 00:00:00', 0, '', '', '', '', '', 0),
(376, '', 1, 'BFS00000376', '', 'Najjuko', 'Sarah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(377, '', 1, 'BFS00000377', '', 'Najjuko', 'Azidah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(378, '', 1, 'BFS00000378', 'Madinah', 'Najjingo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(379, '', 1, 'BFS00000379', 'ANNET', 'NAJJINGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(380, 'Mrs', 1, 'BFS00000380', 'YUNIA', 'NAJJEMBA', '', 1, 'CF70023104CTPA', 'img/ids/Snapshot_20180321_19.JPG', 'F', 'Single', '0000-00-00', '(070) 223-8972', '', '', '', 'LWEZA A', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_20.JPG', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 819),
(381, '', 1, 'BFS00000381', 'RUKIA', 'NAIGAGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(382, '', 1, 'BFS00000382', 'GRACE', 'NAIGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-11 00:00:00', 0, '', '', '', '', '', 0),
(383, '', 1, 'BFS00000383', 'Diana', 'Naiga', 'Rose', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(384, '', 1, 'BFS00000384', 'BETTY', 'NAIGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
(385, '', 1, 'BFS00000385', 'Annet', 'Naiga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(386, '', 1, 'BFS00000386', '', 'Nagujja', 'Evelyne', 0, '', '', '', '', '0000-00-00', '704296702', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-05 00:00:00', 0, '', '', '', '', '', 0),
(387, '', 1, 'BFS00000387', 'HAMIDAH', 'NAGILINYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(388, '', 1, 'BFS00000388', 'SARAH', 'NAGAYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(389, 'Mr', 1, 'BFS00000389', 'YUDAYA', 'NAGAWA', '', 1, 'CF790', 'img/ids/Snapshot_20180321_21.JPG', 'M', 'Single', '0000-00-00', '(077) 442-2930', '', '', 'LWEZA A', 'LWEZA A', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_22.JPG', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 819),
(390, '', 1, 'BFS00000390', 'SANDRA', 'NAGAWA', 'KABANDA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(391, '', 1, 'BFS00000391', 'MARIAM', 'NAGAWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(392, '', 1, 'BFS00000392', 'KIGUNDU', 'NAGAWA', 'PROSCOVIA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-23 00:00:00', 0, '', '', '', '', '', 0),
(393, '', 1, 'BFS00000393', 'MEGA', 'NADUGGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(394, '', 1, 'BFS00000394', 'Maria', 'Nabwetunge', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(395, '', 1, 'BFS00000395', 'Erios', 'Nabunya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(396, '', 1, 'BFS00000396', 'BERNA', 'NABUNYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-18 00:00:00', 0, '', '', '', '', '', 0),
(397, '', 1, 'BFS00000397', 'Masitulah', 'Nabulya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(398, 'Mrs', 1, 'BFS00000398', 'JOYCE', 'NABUKENYA', '', 1, 'CF60032106AE4A', 'img/ids/Snapshot_20180321_4.JPG', 'F', 'Single', '0000-00-00', '(070) 132-5707', '', '', '', 'MASAJJA ZONE B', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_5.JPG', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 819),
(399, '', 1, 'BFS00000399', 'HAJARAH', 'NABUKENYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
(400, '', 1, 'BFS00000400', 'Fatuma', 'Nabukenya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-31 00:00:00', 0, '', '', '', '', '', 0),
(401, '', 1, 'BFS00000401', '', 'Nabukenya', 'Rose', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(402, '', 1, 'BFS00000402', 'Mwajibu', 'Nabukeera', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(403, '', 1, 'BFS00000403', 'Aidah', 'Nabukeera', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(404, '', 1, 'BFS00000404', '', 'Nabukeera', 'Mary', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(405, '', 1, 'BFS00000405', 'Poline', 'Nabukalu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(406, '', 1, 'BFS00000406', 'SAMALIE', 'NABIWEMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(407, '', 1, 'BFS00000407', 'Jowereya', 'Nabitto', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(408, '', 1, 'BFS00000408', 'JANE', 'NABITENGERO', 'ROSE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(409, '', 1, 'BFS00000409', 'AGNES', 'NABISUBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(410, '', 1, 'BFS00000410', 'IRENE', 'NABIRYO', 'DOREEN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(411, '', 1, 'BFS00000411', 'AGATHA', 'NABENDE', '', 0, '', '', '', '', '0000-00-00', '774691376', '706538540', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-14 00:00:00', 0, '', '', '', '', '', 0),
(412, '', 1, 'BFS00000412', 'VIVIAN', 'NABBUTO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(413, '', 1, 'BFS00000413', 'Immaculate', 'Nabbanja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(414, '', 1, 'BFS00000414', 'Christine', 'Nabbanja', 'Lwanga', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(415, '', 1, 'BFS00000415', 'Getrude', 'Nabbale', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(416, '', 1, 'BFS00000416', 'Fatumah', 'Nabayemba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(417, '', 1, 'BFS00000417', 'SUSAN', 'NABAWESI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(418, '', 1, 'BFS00000418', 'Peterarina', 'Nabawesi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(419, '', 1, 'BFS00000419', 'Margret', 'Nabaweesi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-10 00:00:00', 0, '', '', '', '', '', 0),
(420, '', 1, 'BFS00000420', 'Grace', 'Nabaweesi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-18 00:00:00', 0, '', '', '', '', '', 0),
(421, '', 1, 'BFS00000421', 'Christine', 'Nabaweesi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(422, '', 1, 'BFS00000422', 'Poline', 'Nabaweesa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(423, '', 1, 'BFS00000423', 'GORRET', 'NABAWANUKA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-17 00:00:00', 0, '', '', '', '', '', 0),
(424, '', 1, 'BFS00000424', 'RUTH', 'NABATTE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(425, '', 1, 'BFS00000425', 'SHERINAH', 'NABATANZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(426, '', 1, 'BFS00000426', 'BRIDGET', 'NABASUMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-21 00:00:00', 0, '', '', '', '', '', 0),
(427, '', 1, 'BFS00000427', '', 'Nabasumba', 'Prossy', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(428, '', 1, 'BFS00000428', '', 'Nabasitu', 'Hanifah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(429, '', 1, 'BFS00000429', 'BETTY', 'NABASIRYE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
(430, '', 1, 'BFS00000430', 'Teddy', 'Nabanja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(431, '', 1, 'BFS00000431', '', 'NABALENDE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-19 00:00:00', 0, '', '', '', '', '', 0),
(432, '', 1, 'BFS00000432', 'ROSE', 'NABAKOOZA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(433, '', 1, 'BFS00000433', '', 'Nabakooza', 'Sylivia', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(434, '', 1, 'BFS00000434', 'Harriet', 'Nabagesera', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(435, '', 1, 'BFS00000435', 'PEACE', 'NABAGAYAZA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-05 00:00:00', 0, '', '', '', '', '', 0),
(436, '', 1, 'BFS00000436', 'Violet', 'Nabadda', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(437, '', 1, 'BFS00000437', 'Mayimuna', 'Nabadda', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(438, '', 1, 'BFS00000438', 'CHRISTINE', 'NABADDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(439, '', 1, 'BFS00000439', '', 'Nabacwa', 'Rose', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(440, '', 1, 'BFS00000440', 'JOHN', 'MUYUNGA', 'IAN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-27 00:00:00', 0, '', '', '', '', '', 0),
(441, '', 1, 'BFS00000441', 'Francis', 'Muyomba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-13 00:00:00', 0, '', '', '', '', '', 0),
(442, '', 1, 'BFS00000442', 'Richard', 'Muwonge', 'Newton', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-21 00:00:00', 0, '', '', '', '', '', 0),
(443, '', 1, 'BFS00000443', 'LAMECK', 'MUWONGE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-14 00:00:00', 0, '', '', '', '', '', 0),
(444, '', 1, 'BFS00000444', 'NICHOLAS', 'MUWNGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(445, '', 1, 'BFS00000445', 'ABDUL', 'MUWANIKA', 'HAKIM', 0, '', '', '', '', '0000-00-00', '774951498', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-19 00:00:00', 0, '', '', '', '', '', 0),
(446, '', 1, 'BFS00000446', 'Micheal', 'Muwanguzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-28 00:00:00', 0, '', '', '', '', '', 0),
(447, '', 1, 'BFS00000447', 'JANE', 'MUWANGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-30 00:00:00', 0, '', '', '', '', '', 0),
(448, '', 1, 'BFS00000448', 'DAPHINE', 'MUTONI', 'SOITA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(449, '', 1, 'BFS00000449', 'Sauda', 'Mutesi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(450, '', 1, 'BFS00000450', 'SARAH', 'MUTESI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-07 00:00:00', 0, '', '', '', '', '', 0),
(451, '', 1, 'BFS00000451', 'Gerald', 'Mutesasira', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-12 00:00:00', 0, '', '', '', '', '', 0),
(452, '', 1, 'BFS00000452', '', 'MUTESASIRA', 'GERALD', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-27 00:00:00', 0, '', '', '', '', '', 0),
(453, '', 1, 'BFS00000453', 'Sharifah', 'Musoke', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(454, '', 1, 'BFS00000454', 'JOSEPH', 'MUSOKE', 'MUTEBI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(455, '', 1, 'BFS00000455', 'JOSEPH', 'MUSISI', 'BUYINZA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-02 00:00:00', 0, '', '', '', '', '', 0),
(456, '', 1, 'BFS00000456', 'Edward', 'Musaasizi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(457, '', 1, 'BFS00000457', 'Martin', 'Munywanyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-18 00:00:00', 0, '', '', '', '', '', 0),
(458, '', 1, 'BFS00000458', 'ELI', 'MUNYNDO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-09 00:00:00', 0, '', '', '', '', '', 0),
(459, '', 1, 'BFS00000459', 'ivan', 'mulumba', 'mathias', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-14 00:00:00', 0, '', '', '', '', '', 0),
(460, '', 1, 'BFS00000460', 'Prossy', 'Mulondo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(461, '', 1, 'BFS00000461', 'PROSSY', 'MULONDO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-11 00:00:00', 0, '', '', '', '', '', 0),
(462, '', 1, 'BFS00000462', '', 'MULINDWA', 'MADAM', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-04 00:00:00', 0, '', '', '', '', '', 0),
(463, '', 1, 'BFS00000463', 'Herbert', 'Mulamba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(464, '', 1, 'BFS00000464', 'ROBINAH', 'MUKWAYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-31 00:00:00', 0, '', '', '', '', '', 0),
(465, '', 1, 'BFS00000465', 'Katende', 'Mukwaba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(466, '', 1, 'BFS00000466', 'Joyce', 'Mukitte', 'Easther', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(467, '', 1, 'BFS00000467', 'ISAAC', 'MUKISA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-21 00:00:00', 0, '', '', '', '', '', 0),
(468, 'Mr', 1, 'BFS00000468', 'HERBERT', 'MUKISA', '', 1, 'CM75030102674G', 'img/ids/Snapshot_20180320_39.JPG', 'M', 'Single', '0000-00-00', '(075) 070-1310', '', '', '', 'GANGU', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_31.JPG', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(469, '', 1, 'BFS00000469', 'MAURICE', 'MUKIIBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-08 00:00:00', 0, '', '', '', '', '', 0),
(470, '', 1, 'BFS00000470', 'HERBERT', 'MUKIIBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-24 00:00:00', 0, '', '', '', '', '', 0),
(471, '', 1, 'BFS00000471', 'KAGENYI', 'MUKASA', 'KASALALA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(472, '', 1, 'BFS00000472', 'JOSEPH', 'MUKASA', '', 0, '', '', '', '', '0000-00-00', '772952120', '753952120', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-25 00:00:00', 0, '', '', '', '', '', 0),
(473, '', 1, 'BFS00000473', 'Cassmir', 'Mukasa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(474, '', 1, 'BFS00000474', 'ANDREW', 'MUKASA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-15 00:00:00', 0, '', '', '', '', '', 0),
(475, '', 1, 'BFS00000475', '', 'Mujjuni', 'Florah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(476, '', 1, 'BFS00000476', 'Martin', 'Mujabi', 'Kuteesa', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(477, '', 1, 'BFS00000477', 'Charles', 'Mugisha', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(478, '', 1, 'BFS00000478', 'Bomba', 'Mugisha', 'Ali', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(479, '', 1, 'BFS00000479', 'Noah', 'Mugerwa', '', 0, '', '', '', '', '0000-00-00', '753872665', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(480, '', 1, 'BFS00000480', 'DAUDA', 'MUGERWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(481, '', 1, 'BFS00000481', 'Max', 'Mugala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(482, '', 1, 'BFS00000482', 'CHARLES', 'MUGAGGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-18 00:00:00', 0, '', '', '', '', '', 0),
(483, '', 1, 'BFS00000483', 'SAMUEL', 'MUGABBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-10 00:00:00', 0, '', '', '', '', '', 0),
(484, '', 1, 'BFS00000484', 'ROBERT', 'MUDHASI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-13 00:00:00', 0, '', '', '', '', '', 0),
(485, '', 1, 'BFS00000485', 'Sam', 'Mubiru', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-20 00:00:00', 0, '', '', '', '', '', 0),
(486, '', 1, 'BFS00000486', 'CHARLES', 'MUBIRU', 'SALONGO', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-11 00:00:00', 0, '', '', '', '', '', 0),
(487, '', 1, 'BFS00000487', 'BULASIO', 'MUBIRU', 'NSAMBU', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-17 00:00:00', 0, '', '', '', '', '', 0),
(488, '', 1, 'BFS00000488', 'Aminah', 'Mubiru', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(489, '', 1, 'BFS00000489', 'WINFRED', 'MONGHO', 'MOUREEN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(490, '', 1, 'BFS00000490', 'Margaret', 'Miiro', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-08-09 00:00:00', 0, '', '', '', '', '', 0),
(491, '', 1, 'BFS00000491', '', 'micheal', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-01 00:00:00', 0, '', '', '', '', '', 0),
(492, '', 1, 'BFS00000492', 'MERABU', 'MBOGGA', 'KASAJJA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-16 00:00:00', 0, '', '', '', '', '', 0),
(493, '', 1, 'BFS00000493', 'DINAH', 'MBAYITA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-28 00:00:00', 0, '', '', '', '', '', 0),
(494, '', 1, 'BFS00000494', 'MEDIUS', 'MBABAZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(495, '', 1, 'BFS00000495', 'Jolly', 'Mbabazi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(496, '', 1, 'BFS00000496', 'JANAT', 'MBABAZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-25 00:00:00', 0, '', '', '', '', '', 0),
(497, '', 1, 'BFS00000497', 'Shifah', 'Mayanja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(498, '', 1, 'BFS00000498', 'Gustavas', 'Mayanja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(499, '', 1, 'BFS00000499', 'FRANCIS', 'MATOVU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(500, '', 1, 'BFS00000500', 'BALIKUDDEMBE', 'MATOVU', 'JOSEPH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(501, '', 1, 'BFS00000501', 'ALEX', 'MATOVU', 'SEMPALA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-06 00:00:00', 0, '', '', '', '', '', 0),
(502, '', 1, 'BFS00000502', 'FAROUK', 'MASEMBE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-03 00:00:00', 0, '', '', '', '', '', 0),
(503, '', 1, 'BFS00000503', 'DENIS', 'MASEMBE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(504, '', 1, 'BFS00000504', 'Kasozi', 'Martin', 'Kibuuka', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(505, '', 1, 'BFS00000505', 'Monica', 'Manine', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(506, '', 1, 'BFS00000506', '', 'LUZINDA', 'IRENE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-01 00:00:00', 0, '', '', '', '', '', 0),
(507, '', 1, 'BFS00000507', 'LYDIA', 'LUYIGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, '', '', '', '', '', 0),
(508, '', 1, 'BFS00000508', 'DAUDA', 'LUTAAYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-18 00:00:00', 0, '', '', '', '', '', 0),
(509, '', 1, 'BFS00000509', 'Edward', 'Luswata', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(510, '', 1, 'BFS00000510', 'JACKLINE', 'LUNKUSE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(511, '', 1, 'BFS00000511', 'Sadic', 'Lule', 'Kitoke', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(512, '', 1, 'BFS00000512', 'ALI', 'LULE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-05 00:00:00', 0, '', '', '', '', '', 0),
(513, '', 1, 'BFS00000513', 'NATHAN', 'LUKYAMUZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(514, '', 1, 'BFS00000514', 'Fred', 'Lukenge', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(515, '', 1, 'BFS00000515', 'Mariam', 'Lugoloobi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-24 00:00:00', 0, '', '', '', '', '', 0),
(516, '', 1, 'BFS00000516', 'Raymond', 'Lubwama', 'Peter', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(517, '', 1, 'BFS00000517', '', 'Lubwama', 'Steven', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(518, '', 1, 'BFS00000518', 'DAVID', 'LUBOWA', 'HENRY', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-05 00:00:00', 0, '', '', '', '', '', 0),
(519, '', 1, 'BFS00000519', 'TWAHA', 'LUBEGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-25 00:00:00', 0, '', '', '', '', '', 0),
(520, '', 1, 'BFS00000520', 'SHARIFAH', 'LUBEGA', 'KADDUNABBI', 0, '', '', '', '', '0000-00-00', '702771307', '772211907', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-20 00:00:00', 0, '', '', '', '', '', 0),
(521, '', 1, 'BFS00000521', 'JULIUS', 'LUBEGA', 'FRANCIS', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-03 00:00:00', 0, '', '', '', '', '', 0),
(522, 'Mr', 1, 'BFS00000522', 'JOSEPH', 'LUBEGA', '', 1, 'CM7505210EXVYA', 'img/ids/Snapshot_20180321_29.JPG', 'M', 'Single', '0000-00-00', '(077) 462-6423', '', '', '', 'NAJJANAKUMBI', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_28.JPG', 'This member data was exported from an excel', '2017-10-06 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(523, '', 1, 'BFS00000523', 'David', 'Lubega', 'Mutunzi', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-04 00:00:00', 0, '', '', '', '', '', 0),
(524, '', 1, 'BFS00000524', 'Alex', 'Lubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(525, '', 1, 'BFS00000525', 'AKIM', 'LUBEGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-05 00:00:00', 0, '', '', '', '', '', 0),
(526, '', 1, 'BFS00000526', 'FUMUSI', 'LUBANJWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, 'img/profiles/IMG_20171123_121600[1].jpg', 'This member data was exported from an excel', '2017-10-30 00:00:00', 0, '', '', '', '', '', 0),
(527, '', 1, 'BFS00000527', 'ARTHUR', 'KYOBE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-07 00:00:00', 0, '', '', '', '', '', 0),
(528, '', 1, 'BFS00000528', 'David', 'Kyewalabye', 'Male', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-20 00:00:00', 0, '', '', '', '', '', 0),
(529, '', 1, 'BFS00000529', 'James', 'Kyeswa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(530, '', 1, 'BFS00000530', 'PETER', 'KYEGUNJA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-18 00:00:00', 0, '', '', '', '', '', 0),
(531, '', 1, 'BFS00000531', 'Sarah', 'Kyaterekera', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(532, '', 1, 'BFS00000532', 'Crofasi', 'Kyasimire', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-18 00:00:00', 0, '', '', '', '', '', 0),
(533, '', 1, 'BFS00000533', 'FRED', 'KYALIGONZA', 'BIRUNGI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-23 00:00:00', 0, '', '', '', '', '', 0),
(534, '', 1, 'BFS00000534', 'SADIIKI', 'KULABIGWO', '', 0, '', '', '', '', '0000-00-00', '775294909', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-27 00:00:00', 0, '', '', '', '', '', 0),
(535, 'Mrs', 1, 'BFS00000535', 'VANESSA', 'KOBUSINGYE', '', 1, 'CF82004102PQNK', 'img/ids/Snapshot_20180319_10.JPG', 'F', 'Single', '0000-00-00', '(075) 414-3485', '', '', '', 'NAMASUMBA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180319_11.JPG', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(536, '', 1, 'BFS00000536', 'FARIDAH', 'KOBUSINGYE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(537, '', 1, 'BFS00000537', 'AISHA', 'KOBUSINGYE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-22 00:00:00', 0, '', '', '', '', '', 0),
(538, '', 1, 'BFS00000538', 'MATHIAS', 'KIZITO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(539, '', 1, 'BFS00000539', 'GERAALD', 'KIZITO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-10 00:00:00', 0, '', '', '', '', '', 0),
(540, '', 1, 'BFS00000540', 'Bashir', 'Kizito', 'Juma', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(541, '', 1, 'BFS00000541', 'RAPHAEL', 'KIYEGGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-21 00:00:00', 0, '', '', '', '', '', 0),
(542, '', 1, 'BFS00000542', 'David', 'Kiyaga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-04 00:00:00', 0, '', '', '', '', '', 0),
(543, '', 1, 'BFS00000543', 'DAVID', 'KIYAGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-06 00:00:00', 0, '', '', '', '', '', 0),
(544, '', 1, 'BFS00000544', 'David', 'Kiwumulo', 'Kaweesa', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(545, '', 1, 'BFS00000545', 'RONALD', 'KITANDWE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(546, '', 1, 'BFS00000546', 'Herbert', 'Kitandwe', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(547, '', 1, 'BFS00000547', 'DAVID', 'KISITU', 'WALUSIMBI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-11 00:00:00', 0, '', '', '', '', '', 0),
(548, '', 1, 'BFS00000548', 'JALIRU', 'KISAMBIRA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(549, '', 1, 'BFS00000549', 'GODFREY', 'KISAMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-07 00:00:00', 0, '', '', '', '', '', 0),
(550, '', 1, 'BFS00000550', 'HASSAN', 'KIRUNDA', 'SSALONGO', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-04 00:00:00', 0, '', '', '', '', '', 0),
(551, '', 1, 'BFS00000551', 'TADEO', 'KIRIBATA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-11 00:00:00', 0, '', '', '', '', '', 0),
(552, '', 1, 'BFS00000552', 'Christine', 'Kirabo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(553, '', 1, 'BFS00000553', 'Daniel', 'Kirabira', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(554, '', 1, 'BFS00000554', 'Panea', 'Kintu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(555, '', 1, 'BFS00000555', 'Fred', 'Kimaliridde', '', 0, '', '', '', '', '0000-00-00', '754463371', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(556, '', 1, 'BFS00000556', '', 'KILYOKYA', 'JALIA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(557, '', 1, 'BFS00000557', 'ANGELLA', 'KIIZA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(558, '', 1, 'BFS00000558', 'HERMAN', 'KIGOZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-10 00:00:00', 0, '', '', '', '', '', 0),
(559, '', 1, 'BFS00000559', 'JIMMY', 'KIGANDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-18 00:00:00', 0, '', '', '', '', '', 0),
(560, '', 1, 'BFS00000560', 'RONNIE', 'KIBULE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(561, '', 1, 'BFS00000561', '', 'kiberu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-14 00:00:00', 0, '', '', '', '', '', 0),
(562, '', 1, 'BFS00000562', 'KISAKYE', 'KETTY', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-17 00:00:00', 0, '', '', '', '', '', 0),
(563, '', 1, 'BFS00000563', 'LATIF', 'KESSI', '', 0, '', '', '', '', '0000-00-00', '757744809', '780448189', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-14 00:00:00', 0, '', '', '', '', '', 0),
(564, '', 1, 'BFS00000564', 'WILLIAM', 'KAYONDO', 'KATEREGA', 0, '', '', '', '', '0000-00-00', '751286013', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-27 00:00:00', 0, '', '', '', '', '', 0),
(565, '', 1, 'BFS00000565', 'SOLOMON', 'KAYEMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(566, '', 1, 'BFS00000566', '', 'Kayemba', 'Edward', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(567, '', 1, 'BFS00000567', 'CISSY', 'KAYAGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-06 00:00:00', 0, '', '', '', '', '', 0),
(568, '', 1, 'BFS00000568', '', 'Kayaga', 'Edith', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(569, '', 1, 'BFS00000569', 'Alex', 'Kawuma', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-25 00:00:00', 0, '', '', '', '', '', 0),
(570, '', 1, 'BFS00000570', 'CALTON', 'KAWEESI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-14 00:00:00', 0, '', '', '', '', '', 0),
(571, '', 1, 'BFS00000571', 'SAMUEL', 'KAWEESA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(572, '', 1, 'BFS00000572', 'LYDIA', 'KAWALA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(573, '', 1, 'BFS00000573', 'Sulaiman', 'Katumba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-01 00:00:00', 0, '', '', '', '', '', 0),
(574, '', 1, 'BFS00000574', 'FRANCIS', 'KATONGOLE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(575, '', 1, 'BFS00000575', 'Richard', 'Kato', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(576, '', 1, 'BFS00000576', 'Oliva', 'Katerega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(577, '', 1, 'BFS00000577', 'JUDE', 'KATENDE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-29 00:00:00', 0, '', '', '', '', '', 0),
(578, '', 1, 'BFS00000578', 'Hadijjah', 'Katende', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(579, '', 1, 'BFS00000579', 'CHRISTINE', 'KATENDE', 'KYAZZE', 0, '', '', '', '', '0000-00-00', '774578897', '702428280', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-17 00:00:00', 0, '', '', '', '', '', 0),
(580, '', 1, 'BFS00000580', 'Juliet', 'Katana', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(581, '', 1, 'BFS00000581', 'Henry', 'kasule', 'Eria', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-14 00:00:00', 0, '', '', '', '', '', 0),
(582, '', 1, 'BFS00000582', 'Charles', 'Kasujja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(583, '', 1, 'BFS00000583', 'TWAHA', 'KASOZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-18 00:00:00', 0, '', '', '', '', '', 0),
(584, '', 1, 'BFS00000584', 'ROBINAH', 'KASOZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-28 00:00:00', 0, '', '', '', '', '', 0),
(585, '', 1, 'BFS00000585', 'DAVID', 'KASIRYE', '', 0, '', '', '', '', '0000-00-00', '752771224', '730571224', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-25 00:00:00', 0, '', '', '', '', '', 0),
(586, 'Mr', 1, 'BFS00000586', 'PAULINE', 'KANYANGE', 'MALE', 1, 'CF770631082V4C', 'img/ids/Snapshot_20180323_8.JPG', 'F', 'Single', '0000-00-00', '(077) 649-4075', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', 'NDIKUTTAMANDA', 819),
(587, '', 1, 'BFS00000587', 'AIDAH', 'KANSAZE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-28 00:00:00', 0, '', '', '', '', '', 0),
(588, '', 1, 'BFS00000588', 'Pinon', 'Kanamwangi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(589, '', 1, 'BFS00000589', 'Ishakh', 'Kanakulya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-12 00:00:00', 0, '', '', '', '', '', 0),
(590, '', 1, 'BFS00000590', 'DANIEL', 'KAMUNTU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-11 00:00:00', 0, '', '', '', '', '', 0),
(591, '', 1, 'BFS00000591', 'GRACE', 'KAMAZIIMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-25 00:00:00', 0, '', '', '', '', '', 0),
(592, '', 1, 'BFS00000592', 'HADIJJAH', 'KALUNGI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(593, '', 1, 'BFS00000593', 'NUSURA', 'KALIBAKYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-01 00:00:00', 0, '', '', '', '', '', 0),
(594, '', 1, 'BFS00000594', 'Micheal', 'Kalibaala', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(595, '', 1, 'BFS00000595', 'SARAH', 'KALEMBE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(596, '', 1, 'BFS00000596', 'GEORGE', 'KALEMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-21 00:00:00', 0, '', '', '', '', '', 0),
(597, '', 1, 'BFS00000597', 'DISAN', 'KALEMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-24 00:00:00', 0, '', '', '', '', '', 0),
(598, '', 1, 'BFS00000598', 'ABBEY', 'KALANDA', 'NOOR', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-31 00:00:00', 0, '', '', '', '', '', 0),
(599, '', 1, 'BFS00000599', 'Godfrey', 'Kalambuzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(600, '', 1, 'BFS00000600', 'Deborah', 'Kakembo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-05 00:00:00', 0, '', '', '', '', '', 0),
(601, '', 1, 'BFS00000601', 'Catherine', 'Kakayi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(602, '', 1, 'BFS00000602', 'Lilian', 'Kakaire', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(603, '', 1, 'BFS00000603', '', 'KAHANGIRE', 'EDSON', 0, '', '', '', '', '0000-00-00', '772510896', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-31 00:00:00', 0, '', '', '', '', '', 0),
(604, '', 1, 'BFS00000604', 'ROBINAH', 'KAGIMU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-22 00:00:00', 0, '', '', '', '', '', 0),
(605, '', 1, 'BFS00000605', 'CHRISTINE', 'KAGIMU', 'NAKITTO', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-28 00:00:00', 0, '', '', '', '', '', 0),
(606, '', 1, 'BFS00000606', '', 'KAGIMU', 'FRANCIS', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-11 00:00:00', 0, '', '', '', '', '', 0),
(607, '', 1, 'BFS00000607', 'GEORGE', 'KAGGWA', 'WILLIAM', 0, '', '', '', '', '0000-00-00', '772658147', '730658147', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-31 00:00:00', 0, '', '', '', '', '', 0),
(608, '', 1, 'BFS00000608', '', 'KAFUUMA', 'MARTIN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-11 00:00:00', 0, '', '', '', '', '', 0),
(609, '', 1, 'BFS00000609', 'Nuhu', 'Kaddu', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-28 00:00:00', 0, '', '', '', '', '', 0),
(610, '', 1, 'BFS00000610', 'Ibrahim', 'Kabuye', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(611, '', 1, 'BFS00000611', 'ALEX', 'KABUGO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-13 00:00:00', 0, '', '', '', '', '', 0),
(612, '', 1, 'BFS00000612', 'SENKAALI', 'KABONGE', 'DISANI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-14 00:00:00', 0, '', '', '', '', '', 0),
(613, '', 1, 'BFS00000613', 'charles', 'kabonge', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(614, '', 1, 'BFS00000614', 'Simon', 'Kabogoza', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-08-31 00:00:00', 0, '', '', '', '', '', 0),
(615, '', 1, 'BFS00000615', '', 'KABERE', 'MARIA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, '', '', '', '', '', 0),
(616, '', 1, 'BFS00000616', 'JANE', 'KABATONGOLE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(617, '', 1, 'BFS00000617', 'Lilian', 'Kabasinguzi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(618, '', 1, 'BFS00000618', 'ISAAC', 'JOSEPH', 'MUSOKE', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-14 00:00:00', 0, '', '', '', '', '', 0),
(619, '', 1, 'BFS00000619', 'REUBEN', 'JJUUKO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-31 00:00:00', 0, '', '', '', '', '', 0),
(620, '', 1, 'BFS00000620', 'Patrick', 'Jjemba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-18 00:00:00', 0, '', '', '', '', '', 0),
(621, '', 1, 'BFS00000621', 'KALANZI', 'HUSSEIN', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-27 00:00:00', 0, '', '', '', '', '', 0),
(622, '', 1, 'BFS00000622', 'John', 'Golooba', 'Mark', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(623, 'Mr', 1, 'BFS00000623', 'GOLOOBA', 'DAVID', '', 1, 'CM56068100UFJJ', 'img/ids/Snapshot_20180321_30.JPG', 'M', 'Single', '0000-00-00', '(077) 964-4525', '', '', '', 'KASUBI', 'SELF EMPLOYED', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', 'KAWALA', '', 819),
(624, '', 1, 'BFS00000624', 'Kisitu', 'Gogo', 'Henry', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(625, '', 1, 'BFS00000625', 'Moses', 'Gambobbi', 'Kizito', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(626, '', 1, 'BFS00000626', 'Edrisa', 'Galabuzi', 'Ssalongo', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(627, '', 1, 'BFS00000627', 'OF', 'FAMILY', 'NAMATOVU', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(628, '', 1, 'BFS00000628', 'JACINTA', 'EMILLU', 'MULELENGI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(629, '', 1, 'BFS00000629', 'Zainah', 'Ddamulira', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(630, '', 1, 'BFS00000630', 'DEO', 'BYAMUKAMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
(631, '', 1, 'BFS00000631', 'JAMADAH', 'BUSULWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-08 00:00:00', 0, '', '', '', '', '', 0),
(632, '', 1, 'BFS00000632', 'JANE', 'BUSINGYE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-07 00:00:00', 0, '', '', '', '', '', 0),
(633, '', 1, 'BFS00000633', 'Angellah', 'Busingye', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(634, '', 1, 'BFS00000634', 'Abdul', 'Bulondo', 'Malik', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(635, '', 1, 'BFS00000635', 'Andrew', 'Bulega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-21 00:00:00', 0, '', '', '', '', '', 0),
(636, '', 1, 'BFS00000636', 'Hadijjah', 'Bukirwa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-12 00:00:00', 0, '', '', '', '', '', 0),
(637, '', 1, 'BFS00000637', 'Francis', 'Bukenya', 'Wasswa', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(638, 'Mr', 1, 'BFS00000638', 'AHMED', 'BUKENYA', 'YIGA', 1, 'CM82012100T1MD', 'img/ids/Snapshot_20180323_2.JPG', 'M', 'Single', '0000-00-00', '(070) 517-1265', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180323_3.JPG', 'This member data was exported from an excel', '2017-10-20 00:00:00', 0, 'KAMPALA', '', '', '', '', 819),
(639, 'Mr', 1, 'BFS00000639', 'BUKENYA', 'SULAIMAN', '', 1, 'CM83032105F22G', 'img/ids/Snapshot_20180315_9.JPG', 'M', 'Single', '0000-00-00', '(070) 296-1273', '', '', 'NTINDA', 'NTINDA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180315_10.JPG', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', 'NTINDA MINISTERS VILLAGE', '', '', '', 819),
(640, '', 1, 'BFS00000640', 'Denis', 'Bugaya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-15 00:00:00', 0, '', '', '', '', '', 0),
(641, '', 1, 'BFS00000641', 'Henry', 'Brian', 'Namuyimba', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-11 00:00:00', 0, '', '', '', '', '', 0),
(642, '', 1, 'BFS00000642', 'ROBERT', 'BISASO', 'JOSEPH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(643, '', 1, 'BFS00000643', 'FRED', 'BISASO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-30 00:00:00', 0, '', '', '', '', '', 0),
(644, '', 1, 'BFS00000644', '', 'BIRUNGI', 'JOHN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-09 00:00:00', 0, '', '', '', '', '', 0),
(645, '', 1, 'BFS00000645', 'Mary', 'Birabwa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(646, '', 1, 'BFS00000646', 'Agnes', 'Birabwa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(647, '', 1, 'BFS00000647', 'YUNUSU', 'BBOSA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-14 00:00:00', 0, '', '', '', '', '', 0),
(648, '', 1, 'BFS00000648', 'Samuel', 'Batesaki', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(649, '', 1, 'BFS00000649', 'DAUDA', 'BASIITA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-25 00:00:00', 0, '', '', '', '', '', 0),
(650, '', 1, 'BFS00000650', 'ASAPH', 'BARAMUSIIMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(651, '', 1, 'BFS00000651', 'AWALI', 'BAMUSINILWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-13 00:00:00', 0, '', '', '', '', '', 0),
(652, '', 1, 'BFS00000652', 'Jane', 'Baljwaha', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(653, '', 1, 'BFS00000653', 'JOSEPH', 'BALIKUDEMBE', 'LUBOYELA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-23 00:00:00', 0, '', '', '', '', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(654, '', 1, 'BFS00000654', 'Emmanuel', 'Balaba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(655, '', 1, 'BFS00000655', 'Kagimu', 'Bakkabulindi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(656, '', 1, 'BFS00000656', 'SARAH', 'BAGUMA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(657, '', 1, 'BFS00000657', 'Juliet', 'Babumba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-13 00:00:00', 0, '', '', '', '', '', 0),
(658, '', 1, 'BFS00000658', 'JAMES', 'ATUHWERE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-17 00:00:00', 0, '', '', '', '', '', 0),
(659, '', 1, 'BFS00000659', 'Sylivia', 'Asimwe', 'Birungi', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(660, '', 1, 'BFS00000660', 'PROSSY', 'ASIIMWE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(661, '', 1, 'BFS00000661', 'GRACE', 'ASIIMWE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-18 00:00:00', 0, '', '', '', '', '', 0),
(662, '', 1, 'BFS00000662', 'Jackson', 'Ashaba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-27 00:00:00', 0, '', '', '', '', '', 0),
(663, '', 1, 'BFS00000663', 'Hellen', 'Asekenya', 'Kawalya', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(664, '', 1, 'BFS00000664', 'ZIMBE', 'ANN', 'NAKAMYA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-25 00:00:00', 0, '', '', '', '', '', 0),
(665, '', 1, 'BFS00000665', 'DENIS', 'AMPIIRE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-25 00:00:00', 0, '', '', '', '', '', 0),
(666, '', 1, 'BFS00000666', 'ZULA', 'ALUMU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(667, '', 1, 'BFS00000667', 'ANITAH', 'AKUNDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(668, '', 1, 'BFS00000668', 'STEPHEN', 'AKOL', '', 0, '', '', '', '', '0000-00-00', '774261076', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(669, '', 1, 'BFS00000669', 'MARGRET', 'AIKORU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(670, '', 1, 'BFS00000670', 'Talent', 'Ahereza', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(671, '', 1, 'BFS00000671', 'SCHOLA', 'ACHANDORE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-21 00:00:00', 0, '', '', '', '', '', 0),
(672, '', 1, 'BFS00000672', 'DOREEN', 'ACHAN', '', 0, '', '', '', '', '0000-00-00', '774063275', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-11 00:00:00', 0, '', '', '', '', '', 0),
(673, '', 1, 'BFS00000673', 'Wasswa', '', 'Faridah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(674, '', 1, 'BFS00000674', 'Wamala', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(675, '', 1, 'BFS00000675', 'Tusiime', '', 'Precious', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-23 00:00:00', 0, '', '', '', '', '', 0),
(676, '', 1, 'BFS00000676', 'Tumuhimbise', '', 'Enid', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(677, '', 1, 'BFS00000677', 'Ssengooba', '', 'Harunah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-09 00:00:00', 0, '', '', '', '', '', 0),
(678, '', 1, 'BFS00000678', 'Ssemambo', '', 'Ibrahim', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(679, '', 1, 'BFS00000679', 'Serwanga', '', 'Godfrey', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-01 00:00:00', 0, '', '', '', '', '', 0),
(680, '', 1, 'BFS00000680', 'Sekyewa', '', 'Zubair', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(681, '', 1, 'BFS00000681', 'Sejjengo', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-03 00:00:00', 0, '', '', '', '', '', 0),
(682, '', 1, 'BFS00000682', 'Samula', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(683, '', 1, 'BFS00000683', 'Nanozi', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(684, 'Mrs', 1, 'BFS00000684', 'NANKYA', 'JOWERIA', '', 5, '08628896', 'img/ids/Snapshot_20180319_9.JPG', 'F', 'Single', '0000-00-00', '(077) 634-2636', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180319_8.JPG', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', 'NDIKUTTAMDA', 'KUKYEBUSABALA', '', 819),
(685, '', 1, 'BFS00000685', 'Namyalo', '', 'Safina', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-24 00:00:00', 0, '', '', '', '', '', 0),
(686, '', 1, 'BFS00000686', 'Namuyiga', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(687, '', 1, 'BFS00000687', 'Namusoke', '', 'Juliet', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-09 00:00:00', 0, '', '', '', '', '', 0),
(688, '', 1, 'BFS00000688', 'Namugenyi', '', 'Sophie', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-21 00:00:00', 0, '', '', '', '', '', 0),
(689, '', 1, 'BFS00000689', 'Namubiru', '', 'Mariam', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(690, '', 1, 'BFS00000690', 'Namubiru', '', 'Jackie', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(691, '', 1, 'BFS00000691', 'Namirimu', '', 'Margret', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(692, '', 1, 'BFS00000692', 'Namakula', '', 'Dorothy', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(693, '', 1, 'BFS00000693', 'Namaganda', '', 'Sarah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(694, '', 1, 'BFS00000694', 'Namagala', '', 'Filista', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(695, '', 1, 'BFS00000695', 'Nalumansi', '', 'Jane', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(696, '', 1, 'BFS00000696', 'Nakyanzi', '', 'Lakabu', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(697, '', 1, 'BFS00000697', 'Nakimuli', '', 'Betty', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-23 00:00:00', 0, '', '', '', '', '', 0),
(698, '', 1, 'BFS00000698', 'Nakibuka', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(699, '', 1, 'BFS00000699', 'Nakato', '', 'Sarah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(700, '', 1, 'BFS00000700', 'Nakanwagi', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(701, '', 1, 'BFS00000701', 'Nakabanda', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-16 00:00:00', 0, '', '', '', '', '', 0),
(702, '', 1, 'BFS00000702', 'Nabukenya', '', 'Caroline', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(703, '', 1, 'BFS00000703', 'Nabukenya', '', 'caroline', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-20 00:00:00', 0, '', '', '', '', '', 0),
(704, '', 1, 'BFS00000704', 'Nabukeera', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(705, '', 1, 'BFS00000705', 'Nabikoolo', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-09 00:00:00', 0, '', '', '', '', '', 0),
(706, '', 1, 'BFS00000706', 'Nabatanzi', '', 'Shalifah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(707, '', 1, 'BFS00000707', 'Mwendeze', '', 'Beatrice', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-24 00:00:00', 0, '', '', '', '', '', 0),
(708, '', 1, 'BFS00000708', 'Mwebesa', '', 'Justus', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(709, '', 1, 'BFS00000709', 'Musisi', '', 'Richard', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-09 00:00:00', 0, '', '', '', '', '', 0),
(710, '', 1, 'BFS00000710', 'mukasa', '', 'ronald', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-27 00:00:00', 0, '', '', '', '', '', 0),
(711, '', 1, 'BFS00000711', 'Mukasa', '', 'Fred', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(712, '', 1, 'BFS00000712', 'Mukasa', '', 'Fred', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-21 00:00:00', 0, '', '', '', '', '', 0),
(713, '', 1, 'BFS00000713', 'Mugejjera', '', 'William', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(714, '', 1, 'BFS00000714', 'Mpalampa', '', 'Emirio', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-06 00:00:00', 0, '', '', '', '', '', 0),
(715, '', 1, 'BFS00000715', 'Mayinja', '', 'Ronald', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-23 00:00:00', 0, '', '', '', '', '', 0),
(716, '', 1, 'BFS00000716', 'Matovu', '', 'Henry', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-19 00:00:00', 0, '', '', '', '', '', 0),
(717, '', 1, 'BFS00000717', 'Lutalo', '', 'Lawrence', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-27 00:00:00', 0, '', '', '', '', '', 0),
(718, '', 1, 'BFS00000718', 'Lubega', '', 'Ritah', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-05 00:00:00', 0, '', '', '', '', '', 0),
(719, '', 1, 'BFS00000719', 'Kyeyune', '', 'Lulenti', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-10 00:00:00', 0, '', '', '', '', '', 0),
(720, '', 1, 'BFS00000720', 'Kyadondo', '', 'Florence', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-10 00:00:00', 0, '', '', '', '', '', 0),
(721, '', 1, 'BFS00000721', 'Kiyingi', '', 'Derrick', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-06 00:00:00', 0, '', '', '', '', '', 0),
(722, '', 1, 'BFS00000722', 'Kiweewa', '', 'Godfrey', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-21 00:00:00', 0, '', '', '', '', '', 0),
(723, '', 1, 'BFS00000723', 'Kivumbi', '', 'Patrick', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-19 00:00:00', 0, '', '', '', '', '', 0),
(724, '', 1, 'BFS00000724', 'Kikomaga', '', 'Eloni', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(725, '', 1, 'BFS00000725', 'Kigozi', '', 'Jude', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-15 00:00:00', 0, '', '', '', '', '', 0),
(726, '', 1, 'BFS00000726', 'Kiconco', '', 'Rehma', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-08 00:00:00', 0, '', '', '', '', '', 0),
(727, '', 1, 'BFS00000727', 'Kayaga', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(728, '', 1, 'BFS00000728', 'Kayaga', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-09 00:00:00', 0, '', '', '', '', '', 0),
(729, '', 1, 'BFS00000729', 'Katushabe', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-30 00:00:00', 0, '', '', '', '', '', 0),
(730, '', 1, 'BFS00000730', 'Kasirye', '', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-13 00:00:00', 0, '', '', '', '', '', 0),
(731, '', 1, 'BFS00000731', 'Kaneyenzire', '', 'Irene', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-09 00:00:00', 0, '', '', '', '', '', 0),
(732, '', 1, 'BFS00000732', 'Kaliyo', '', 'Oliver', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(733, '', 1, 'BFS00000733', 'Kajura', '', 'James', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-23 00:00:00', 0, '', '', '', '', '', 0),
(734, '', 1, 'BFS00000734', 'Kagabane', '', 'Martha', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-02-07 00:00:00', 0, '', '', '', '', '', 0),
(735, '', 1, 'BFS00000735', 'Jjuko', '', 'Sulaiman', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-03 00:00:00', 0, '', '', '', '', '', 0),
(736, '', 1, 'BFS00000736', '', '', 'NAMAZZI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-04 00:00:00', 0, '', '', '', '', '', 0),
(737, 'Mr', 1, 'SBFS00000737', 'Platin ', 'Alfred', 'Mugasa', 1, 'CM86082103PE5A', '', 'M', '', '1988-08-08', '(070) 277-1124', '(077) 435-5568', 'mplat84@gmail.com', '', 'Kampala', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0),
(738, 'Mr', 1, 'SBFS00000738', 'P', 'Joshua', 'A', 1, '8932923', '', 'M', '', '1980-01-01', '(070) 277-1124', '', 'mplat84@gmail.com', '', 'kampala', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0),
(739, 'Mr', 1, 'SBFS00000739', 'aaron', 'ssekanjako', '', 5, '005', '', 'M', '', '1980-01-06', '(070) 130-0539', '(077) 754-3515', '', '', 'muganzirwaza', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0),
(740, 'Mr', 1, 'SBFS00000740', 'aaron', 'ssekanjako', '', 5, '005', '', '', '', '1980-01-06', '(070) 130-0534', '(077) 754-3516', '', '', 'muganzirwaza', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(741, 'Mr', 0, 'BFS00000741', 'Charles', 'Sserwanga', '', 1, 'CM8503610A4FNL', '', 'M', 'Single', '1985-01-01', '(077) 984-4364', '(070) 615-5502', '', '', 'Katabi', 'Teacher', 0, 0, NULL, '', '', '2017-11-16 00:00:00', 0, '', '', '', '', '', 0),
(742, 'Mr', 0, 'BFS00000742', 'Charles', 'Sserwanga', '', 1, 'CM8503610A4FNL', '', 'M', 'Single', '1985-01-01', '(077) 984-4364', '(070) 615-5502', '', '', 'Katabi', 'Teacher', 0, 0, NULL, '', '', '2017-11-16 00:00:00', 0, '', '', '', '', '', 0),
(743, 'Mr', 0, 'BFS00000743', 'Charles', 'Sserwanga', '', 1, 'CM8503610A4FNL', '', 'M', 'Single', '1985-01-01', '(077) 984-4364', '(070) 615-5502', '', '', 'Katabi', 'Teacher', 0, 0, NULL, '', '', '2017-11-16 00:00:00', 0, '', '', '', '', '', 0),
(744, 'Mr', 0, 'BFS00000744', 'Methodius', 'Niwagaba', '', 1, 'CM93009109EV1L', '', 'M', 'Single', '1993-09-15', '(078) 991-0275', '(070) 160-9000', '', '', 'Katabi', 'Teacher', 0, 0, NULL, '', '', '2017-11-16 00:00:00', 0, '', '', '', '', '', 0),
(745, 'Mr', 0, 'BFS00000745', 'Alfred', 'platin', 'M', 1, 'CM34466565', 'img/ids/developr.jpg', 'M', 'Single', '1999-03-29', '(070) 377-1124', '', 'mplat84@gmail.com', '', 'kampala', 'IT', 0, 0, NULL, '', '', '2017-11-16 00:00:00', 0, '', '', '', '', '', 0),
(746, 'Mrs', 1, 'SBFS00000746', 'sarah', 'Nansitu', 'kaweesa', 1, ' 07776u5656', '', 'F', '', '1970-01-01', '(078) 740-2284', '(070) 298-4133', 'kaweesa2012@gmail.com', '', 'salama', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(747, 'Mrs', 0, 'BFS00000747', 'Annet', 'Nalule', 'Hedwig', 1, 'CF72024106G4PD', 'img/ids/DSC00854.JPG', 'F', 'Single', '1972-11-18', '(077) 265-6872', '(070) 220-2589', '', '', 'Namugongo', 'Business', 0, 0, NULL, 'img/profiles/IMG_20171205_082227[1].jpg', '', '2017-11-21 00:00:00', 0, '', '', '', '', '', 0),
(748, 'Mr', 1, 'SBFS00000748', 'michael', 'kalibbala', '', 5, '3', '', 'M', '', '1983-05-03', '(077) 264-4458', '', '', '', 'katwe', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0),
(749, 'Mr', 0, 'BFS00000749', 'Peter', 'Mwesigwa ', 'Solomon', 1, 'CM67007109KE7E', 'img/ids/DSC00856.JPG', 'M', 'Married', '1967-11-25', '(078) 258-6364', '(070) 446-5324', '', '', 'Kyebando Central', 'Teacher', 4, 0, NULL, 'img/profiles/DSC00858.JPG', 'He is a parmanent teacher of Kabojja Junior Junior.', '2017-11-22 00:00:00', 0, 'Kampala', '', '', '', '', 0),
(750, 'Mrs', 0, 'BFS00000750', 'Esther', 'Asekenye', '', 1, 'CF73021100TVZD', '', 'F', 'Married', '1973-05-25', '(075) 363-2533', '(077) 464-2442', '', '', 'Kyebando Central', 'Teacher', 4, 0, NULL, 'img/profiles/DSC00861.JPG', '', '2017-11-22 00:00:00', 0, 'Kampala', '', '', '', '', 0),
(751, '', 1, 'BFS00000751', 'Fiona', 'Nakityo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(752, '', 1, 'BFS00000752', 'Eve', 'Namutebi', 'Namubiru', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(753, '', 1, 'BFS00000753', 'Christine', 'Nabbanja', 'Lwanga', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-19 00:00:00', 0, '', '', '', '', '', 0),
(754, '', 1, 'BFS00000754', 'Charles', 'Kasujja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(755, '', 1, 'BFS00000755', 'Edward', 'Naserenga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(756, '', 1, 'BFS00000756', 'Pinon', 'Kanamwangi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(757, '', 1, 'BFS00000757', 'John', 'Ntambi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(758, '', 1, 'BFS00000758', 'Kasozi', 'Martin', 'Kibuuka', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(759, '', 1, 'BFS00000759', 'Immaculate', 'Nabbanja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(760, '', 1, 'BFS00000760', 'Oliver', 'Nalubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(761, '', 1, 'BFS00000761', 'Stephen', 'Nyombi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(762, '', 1, 'BFS00000762', 'Francis', 'Bukenya', 'Wasswa', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(763, '', 1, 'BFS00000763', 'Emmanuel', 'Sembatya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(764, '', 1, 'BFS00000764', 'Juliet', 'Nambiite', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(765, '', 1, 'BFS00000765', 'Fred', 'Kimaliridde', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-29 00:00:00', 0, '', '', '', '', '', 0),
(766, '', 1, 'BFS00000766', 'John', 'Nsamba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(767, '', 1, 'BFS00000767', 'Raymond', 'Lubwama', 'Peter', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-30 00:00:00', 0, '', '', '', '', '', 0),
(768, '', 1, 'BFS00000768', 'karlson', 'Nvuule', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-27 00:00:00', 0, '', '', '', '', '', 0),
(769, '', 1, 'BFS00000769', 'Prossy', 'Nalunga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-27 00:00:00', 0, '', '', '', '', '', 0),
(770, '', 1, 'BFS00000770', 'Samuel', 'Nsubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(771, '', 1, 'BFS00000771', 'Gustavas', 'Mayanja', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(772, '', 1, 'BFS00000772', 'Daniel', 'Kirabira', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-28 00:00:00', 0, '', '', '', '', '', 0),
(773, 'Mr', 0, 'BFS00000773', 'GODFREY', 'MATOVU', 'MATEEGA', 1, 'CM720521060V3J', '', 'M', 'Married', '1972-10-20', '(075) 164-9367', '(077) 264-9367', '', '', 'KAWEMPE', 'BUSINESS MAN-BRIDAL,REAL ESTATE', 0, 0, NULL, 'img/profiles/IMG_20171110_093904[1].jpg', '', '2017-11-23 00:00:00', 0, '', '', '', '', '', 0),
(774, 'Mr', 0, 'BFS00000774', 'GODFREY', 'MATOVU', 'MATEEGA', 1, 'CM720521060V3J', '', 'M', 'Married', '1972-10-20', '(075) 164-9367', '(077) 264-9367', '', '', 'KAWEMPE', 'BUSINESS MAN-BRIDAL,REAL ESTATE', 0, 0, NULL, '', '', '2017-11-23 00:00:00', 0, '', '', '', '', '', 0),
(775, 'Mrs', 0, 'BFS00000775', 'BEGUMISA', 'BUSINGYE', 'GELLADINE', 1, 'CF63037101DV6A', '', 'F', 'Single', '1963-12-30', '(070) 268-9130', '(078) 517-9502', '', '', 'NAMUWONGO', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/IMG_20171123_135032[1].jpg', '', '2017-11-23 00:00:00', 0, '', '', '', '', '', 0),
(776, 'Mr', 1, 'SBFS00000776', 'michael', 'kalibbala', '', 5, '2', '', 'M', '', '1983-05-03', '(077) 264-4468', '', '', '', 'KATWE', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0),
(777, 'Mrs', 0, 'BFS00000777', 'MILLY', 'NASSOZI', '', 1, 'CF6506810118PK', '', 'F', 'Single', '1965-01-20', '(070) 277-9819', '', '', '', 'KASUBI', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/IMG_20171123_181753[1].jpg', '', '2017-11-23 00:00:00', 0, '', '', '', '', '', 0),
(778, 'Mr', 0, 'BFS00000778', 'Eria', 'Kimbugwe', 'Ssalongo', 1, 'cm71105101v8HD', '', 'M', 'Married', '1971-04-29', '(075) 763-4903', '(077) 363-4903', '', '', 'Matugga', 'Bodaboda cyclist', 0, 0, NULL, 'img/profiles/DSC00894.JPG', 'He is a bodaboda cyclist', '2017-11-29 00:00:00', 0, '', '', '', '', '', 0),
(779, 'Mrs', 0, 'BFS00000779', 'Justine', 'Mirembe', '', 1, 'cf920521044WMA', '', 'F', 'Single', '1992-12-23', '(070) 273-3915', '', '', '', 'Masajja', '', 0, 0, NULL, 'img/profiles/DSC00896.JPG', '', '2017-11-29 00:00:00', 0, 'Wakiso', '', '', '', '', 0),
(780, 'Mr', 0, 'BFS00000780', 'Casimir', 'Mukasa', '', 1, 'cm7206810607pl', '', 'M', 'Married', '1972-11-11', '(077) 297-0965', '(073) 080-0815', '', '', 'Busega', 'Researcher', 4, 0, NULL, 'img/profiles/DSC00901.JPG', '', '2017-11-29 00:00:00', 0, '', '', '', '', '', 0),
(781, 'Mrs', 0, 'BFS00000781', 'JOYCE', 'BABIRYE', '', 1, 'CF58082100K46C', '', 'F', 'Single', '1958-10-02', '(077) 421-2766', '(070) 187-6289', '', '', 'KATWE', '', 0, 0, NULL, '', '', '2017-11-29 00:00:00', 0, '', '', '', '', '', 0),
(782, 'Mr', 0, 'BFS00000782', 'JOSEPH', 'MUNYAGWA', '', 1, 'CM80052102F67F', '', 'M', 'Married', '1980-08-08', '(075) 683-3748', '', '', '', 'MAKINDYE LUWAFU', 'BUSINESS MAN', 0, 0, NULL, '', '', '2017-11-29 00:00:00', 0, '', '', '', '', '', 0),
(783, 'Mr', 0, 'BFS00000783', 'PAUL', 'KYOZAIRE', '', 1, 'CM5508410076EF', '', 'M', 'Married', '1955-06-15', '(077) 680-3929', '', '', '', 'RUBAGA', 'TEACHER AT ST ANDREW KAGGWA GOMBE', 0, 0, NULL, 'img/profiles/IMG_20171129_160014[1].jpg', '', '2017-11-29 00:00:00', 0, '', '', '', '', '', 0),
(784, 'Mr', 0, 'BFS00000784', 'GONZAGA', 'KABUUBI', '', 5, '3', '', 'M', 'Single', '1987-11-12', '(077) 407-0398', '', '', '', 'MASANAFU', 'BUSINESS MAN', 0, 0, NULL, '', '', '2017-12-05 00:00:00', 0, '', '', '', '', '', 0),
(785, 'Mr', 0, 'BFS00000785', 'JOSEPH', 'SSEMWOGERERE', 'TIMOTHY', 1, 'CM86031109QU0F', '', 'M', 'Single', '1986-05-24', '(077) 648-3235', '(075) 248-3235', '', '', 'KAWUKU BUNGA', 'BUSINESS MAN', 0, 0, NULL, '', '', '2017-12-15 00:00:00', 0, '', '', '', '', '', 0),
(786, 'Mr', 0, 'BFS00000786', 'DENIS', 'KATO', 'SEMWOGERERE', 1, 'CM93031107999C', '', 'M', 'Single', '1993-09-14', '(070) 235-1428', '', '', '', 'NANSANA', 'BUSINESS MAN', 0, 0, NULL, '', '', '2017-12-18 00:00:00', 0, '', '', '', '', '', 0),
(787, 'Mrs', 0, 'BFS00000787', 'AGNES', 'NAMUSOKE', '', 1, 'CF66039100ZY9J', '', 'F', 'Single', '1965-10-20', '(075) 782-8912', '(077) 496-0063', '', '', 'MAKINDYE', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2017-12-18 00:00:00', 0, '', '', '', '', '', 0),
(788, 'Mr', 0, 'BFS00000788', 'TANANSI', 'BYEKWASO', 'MULEMA', 1, 'CM76036100CEMC', '', 'M', 'Married', '1976-05-08', '(075) 539-4355', '', '', 'ndejje', 'NDEJJE', 'self employed', 0, 0, NULL, '', '', '2018-01-24 00:00:00', 0, 'KAMPALA', 'kyadondo', '', 'kampala', 'NDEJJE', 0),
(789, 'Mr', 0, 'BFS00000789', 'Alfred', 'Mugasa', 'Platin', 1, '200', 'img/ids/nana.jpg', 'M', 'Single', '1999-06-15', '(070) 277-1124', '', 'mplat84@gmail.com', '', 'kampala', 'IT', 0, 0, NULL, '', '', '2018-01-24 00:00:00', 0, '', '', '', '', '', 0),
(790, 'Mr', 0, 'BFS00000790', 'GODFREY', 'KIMBOWA', '', 1, 'CM72036100CE1H', '', 'M', 'Married', '1972-10-23', '(078) 244-8514', '(075) 344-8514', '', '', 'ndejje kanyanya', 'BUSINESS  MAN', 0, 0, NULL, '', 'client is a business man', '2018-01-24 00:00:00', 0, 'WAKISO', '', '', '', 'ndejje', 0),
(791, 'Mr', 0, 'BFS00000791', 'GODFREY', 'KIMBOWA', '', 1, 'CM72036100CE1H', '', 'M', 'Married', '1972-10-23', '(078) 244-8514', '(075) 344-8514', '', '', 'ndejje kanyanya', 'BUSINESS  MAN', 0, 0, NULL, '', 'client is a business man', '2018-01-24 00:00:00', 0, 'WAKISO', '', '', '', 'ndejje', 0),
(792, 'Mrs', 0, 'BFS00000792', 'PROSSY', 'NAKANWAGI', '', 1, 'CM84036106VLWE', '', 'F', 'Married', '1980-07-08', '(078) 879-2187', '', '', '', 'NDEJJE', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-01-24 00:00:00', 0, 'KLA', 'NDEJJE', '', 'NDEJJE', 'NDEJJE', 0),
(793, 'Mrs', 0, 'BFS00000793', 'LOVINA', 'NAMPEREZA', '', 5, 'VOTERS CARD:12068010602', '', 'F', 'Single', '1973-07-04', '(075) 262-6477', '', '', '', 'MUTUNGO', 'BUSINESS WOMAN', 2, 0, NULL, '', 'CLIENT IS A BUSINESS WOMAN WHO IS A HAIR DRESSER,HAS RENTAL HOUSES AND A BICYCLE SPARE PARTS SHOP IN MUTUNGO', '2018-01-25 00:00:00', 0, 'KAMPALA', '', '', '', 'MUTUNGO', 0),
(794, 'Mrs', 1, 'SBFS00000794', 'Sarah', 'Nansitu', 'Kaweesa', 3, 'CF58082100K46C', '', 'F', '', '1970-01-01', '(070) 298-4133', '', 'kaweesa2012@gmail.com', '', 'salama', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(795, 'Mr', 0, 'BFS00000795', 'JOE', 'OMUGAVENSWA', '', 1, 'CM60024102UMPA', 'img/ids/IMG_20180125_105234[1].jpg', 'M', 'Married', '1960-04-09', '(070) 492-9617', '(072) 190-0489', '', 'NANKULABYE', 'NANKULABYE ZONE 5', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-01-25 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(796, 'Mr', 0, 'BFS00000796', 'JOHN', 'SETUBA ', '', 1, 'CM62024106FQNJ', 'img/ids/IMG_20180125_111644[1].jpg', 'M', 'Married', '1962-05-11', '(078) 287-6181', '', '', '', 'NABWERU', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-01-25 00:00:00', 0, '', '', '', '', '', 0),
(797, 'Mr', 0, 'BFS00000797', 'fred', 'ssemakula', '', 1, 'CM82024100L29E', 'img/ids/IMG_20180125_112416[1].jpg', 'M', 'Married', '1982-04-15', '(078) 227-9337', '', '', '', 'NANKULABYE ZONE 5', '', 0, 0, NULL, '', '', '2018-01-25 00:00:00', 0, '', '', '', '', '', 0),
(798, 'Mr', 0, 'BFS00000798', 'UMARU', 'KANYIKE', '', 1, 'CM7401210243HC', 'img/ids/IMG_20180125_115438[1].jpg', 'M', 'Single', '1974-01-09', '(070) 153-4143', '', '', '', 'MBUYA', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-01-25 00:00:00', 0, '', '', '', '', '', 819),
(799, 'Mr', 1, 'SBFS00000799', 'michael', 'kalibbala', '', 5, '2', '', 'M', '', '1983-05-03', '(071) 257-5689', '', '', 'katwe', 'KATWE', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', 'katwe', '', 'katwe', '', 0),
(800, 'Mr', 1, 'SBFS00000800', 'michael', 'kalibbala', '', 5, '4', '', 'M', '', '1983-05-03', '(077) 264-4458', '', '', '', 'katwe', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, 'KAMPALA', 'kampala', '', '', '', 0),
(801, 'Mr', 0, 'BFS00000801', 'EMILIO', 'MPALAMPA', '', 5, '3', 'img/ids/IMG_20180109_092500[1].jpg', 'M', 'Single', '1990-04-14', '(078) 422-0730', '(070) 185-9290', '', '', 'KATWE', 'BLB STAFF', 0, 0, NULL, '', '', '2018-02-05 00:00:00', 0, 'KAMPALA', 'KAMPALA', '', 'KAMPALA', '', 0),
(802, 'Mr', 0, 'BFS00000802', 'LAWRENCE', 'SSEBIRANDA ', '', 1, 'CM57032104ZMLH', '', 'M', 'Married', '1957-11-05', '(077) 286-1437', '(075) 186-1437', '', '', 'NANSANA', 'self employed', 0, 0, NULL, '', '', '2018-02-05 00:00:00', 0, 'KAMPALA', '', '', 'KAMPALA', '', 0),
(803, 'Mr', 0, 'BFS00000803', 'PATRICK', 'MUJUUKA', '', 5, '2', '', 'M', 'Married', '1974-07-19', '(077) 241-5061', '(077) 241-5061', '', '', 'NALUMUNYE', 'SENIOR PRESENTER CBS', 0, 0, NULL, '', '', '2018-02-05 00:00:00', 0, 'KLA', 'KYADDONDO', '', 'KLA', '', 0),
(804, 'Mr', 0, 'BFS00000804', 'JULIUS', 'MUTAMBA ', '', 1, 'CM850341019CZK', '', 'M', 'Married', '1985-02-28', '(070) 658-1025', '(078) 609-6466', '', '', 'BWEYOGERERE', 'SHOP ATTENDANT', 0, 0, NULL, '', '', '2018-02-05 00:00:00', 0, 'KLA', 'KYADONDO', '', '', '', 0),
(805, 'Mr', 0, 'BFS00000805', 'GRACE', 'MUSISI', '', 1, 'CM57068106VUXG', '', 'M', 'Married', '1957-02-10', '(078) 282-1858', '(075) 082-1851', '', '', 'NATEETE', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-02-07 00:00:00', 0, 'KLA', 'KLA', '', 'KLA', '', 0),
(806, 'Mrs', 0, 'BFS00000806', 'REBECCA', 'BUKENYA', 'MAGEZI', 5, '5', '', 'F', 'Married', '1957-02-07', '(075) 888-0106', '', '', '', 'KAMPALA', 'HUMAN RESOURCE MANAGER', 0, 0, NULL, '', '', '2018-02-08 00:00:00', 0, 'KLA', 'KLA', '', '', '', 0),
(807, 'Mr', 0, 'BFS00000807', 'BARNABAS', 'NDAWULA', '', 5, '4', '', 'M', 'Married', '1972-06-06', '(073) 077-7189', '', '', '', 'KAMPALA', 'LEGAL', 0, 0, NULL, '', '', '2018-02-09 00:00:00', 0, 'KAMPALA', '', '', 'KAMPALA', '', 0),
(808, 'Mrs', 0, 'BFS00000808', 'RUTH', 'MPANJA ', '', 1, 'CF860061013UHL', '', 'F', 'Married', '1986-12-21', '(077) 473-3289', '(070) 180-4590', '', '', 'MUYENGA BUKASA', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-02-09 00:00:00', 0, 'BUKASA', 'KLA', '', 'BUKASA', '', 0),
(809, 'Mrs', 0, 'BFS00000809', 'SALIMA', 'NALUKENGE', 'OKELLO', 1, 'CF69041101M0JK', '', 'F', 'Single', '1969-12-25', '(077) 161-9152', '', '', '', 'MUYENGA BUKASA', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-02-12 00:00:00', 0, 'KAMPALA', '', '', 'BUKASA', '', 0),
(810, 'Mrs', 0, 'BFS00000810', 'FARIDAH', 'TIBIKOMWA', 'SANUBI', 1, 'CF9101310DNEJ', '', 'F', 'Single', '1991-06-21', '(075) 380-5379', '', '', '', 'MUYENGA BUKASA', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-02-12 00:00:00', 0, 'KAMPALA', 'KYADDONDO', '', '', '', 0),
(811, 'Mrs', 0, 'BFS00000811', 'TALIB', 'NIMI', '', 5, '2', '', 'F', 'Single', '1966-11-25', '(078) 921-1559', '', '', '', 'KISUGU', '', 0, 0, NULL, '', '', '2018-02-12 00:00:00', 0, 'KAMPALA', 'KYADDONDO', '', 'KAMPALA', '', 0),
(812, 'Mrs', 0, 'BFS00000812', 'ANNET', 'NAKITENDE', '', 1, 'CF7505210CM3VE', '', 'F', 'Single', '1975-12-03', '(077) 454-6179', '', '', '', 'BUDDO', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-02-13 00:00:00', 0, 'KAMPALA', 'NATEETE', '', 'KLA', '', 0),
(813, 'Mr', 0, 'BFS00000813', 'RICHARD', 'LUTANDA', '', 1, 'CM7706810180WH', '', 'M', 'Single', '1977-12-12', '(070) 135-9362', '', '', '', 'SALAAMA', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-02-14 00:00:00', 0, 'KLA', 'KYADDONDO', '', 'SALAAMA', '', 737),
(814, 'Mr', 0, 'BFS00000814', 'MAJIDU', 'WALUSIMBI', '', 1, 'CM75052100WRQL', '', 'M', 'Single', '1975-08-08', '(077) 578-6899', '', '', '', 'GANGU', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-02-15 00:00:00', 0, 'WAKISO', '', '', 'KLA', '', 0),
(815, 'Mr', 0, 'BFS00000815', 'PETER', 'KIZITO', '', 1, 'CM75052101NUVJ', '', 'M', 'Married', '1975-09-09', '(070) 454-5353', '', '', '', 'GANGU', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-02-15 00:00:00', 0, 'KLA', '', '', 'KAMPALA', 'GANGU', 0),
(816, 'Mrs', 0, 'BFS00000816', 'ALICE', 'ZAWEDDE', '', 1, 'CF63032100FE9K', '', 'F', 'Single', '1963-02-23', '(075) 485-3338', '', '', '', 'MENGO', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-03-01 00:00:00', 0, 'KLA', '', '', 'MENGO', '', 0),
(817, 'Mr', 0, 'BFS00000817', 'SEKYANZI', 'DAVID', 'KITAAKULE', 1, 'CM6104410ZV1K', 'img/ids/IMG_20180302_091659_resized_20180302_091823455 (1).jpg', 'M', 'Married', '1961-12-08', '(077) 233-4078', '(075) 920-7712', '', '', 'NAKASONGOLA', 'FARMER', 0, 0, NULL, 'img/profiles/IMG_20180302_091659_resized_20180302_091823455 (1).jpg', '', '2018-03-02 00:00:00', 0, 'NAKASONGOLA', '', '', 'KAKEGE', '', 737),
(818, 'Mrs', 0, 'BFS00000818', 'RIVIAN', 'NAKIGOZI', '', 1, 'CF93052108PXVD', 'img/ids/IMG_20180302_094839_resized_20180302_094926900.jpg', 'F', 'Single', '1993-05-01', '(070) 673-4748', '(039) 200-3124', '', '', 'LUBUGUMU', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/IMG_20180302_094854_resized_20180302_094927309.jpg', '', '2018-03-02 00:00:00', 0, 'NDEJJE', '', '', '', '', 0),
(819, 'Mrs', 1, 'SBFS00000819', 'MARIAM', 'NAMUDDU', '', 3, 'B1374890', '', 'F', '', '1970-01-01', '(070) 125-5645', '(079) 100-7994', 'vmnamuddu@gmail.com', '', 'SALAAMA', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, 'MAKINDYE', 'LUWAFFU', '', '', '', 0),
(820, 'Mr', 0, 'BFS00000820', 'PATRICK', 'WASWA', '', 1, 'CM60047101XE2H', 'img/ids/IMG_20180305_114859_resized_20180305_115115103.jpg', 'M', 'Divorced', '1960-03-21', '(078) 181-9759', '', '', '', 'KALAGI', 'TAILOR', 0, 0, NULL, '', '', '2018-03-05 00:00:00', 0, 'MUKONO', '', '', '', '', 0),
(821, 'Mr', 0, 'BFS00000821', 'PATRICK', 'WASWA', '', 1, 'CM60047101XE2H', 'img/ids/IMG_20180305_114859_resized_20180305_115115103.jpg', 'M', 'Single', '1960-03-21', '(078) 215-8711', '', '', '', 'KALAGI', 'BUSINESS MAN', 0, 0, NULL, '', '', '2018-03-05 00:00:00', 0, 'MUKONO', '', '', '', '', 0),
(822, 'Mr', 0, 'BFS00000822', 'PATRICK', 'WASWA', '', 1, 'CM60047101XE2H', 'img/ids/IMG_20180305_114859_resized_20180305_115115103.jpg', 'M', 'Single', '1960-03-21', '(078) 181-9759', '', '', '', 'KALAGI', 'TAILOR', 0, 0, NULL, 'img/profiles/Snapshot_20180315_19.JPG', '', '2018-03-05 00:00:00', 0, 'MUKONO', '', '', '', '', 0),
(823, 'Mr', 0, 'BFS00000823', 'MUDASILU', 'KAVUMA', '', 1, 'CM93027103N4DL', 'img/ids/IMG_20180306_120158_resized_20180306_120317274.jpg', 'M', 'Single', '1993-06-05', '(070) 052-7198', '', '', '', 'BUDDO', 'BUILDER', 0, 0, NULL, 'img/profiles/IMG_20180306_120158_resized_20180306_120317274.jpg', '', '2018-03-06 00:00:00', 0, 'BUDDO', '', '', '', '', 0),
(824, 'Mr', 0, 'BFS00000824', 'HADIJAH', 'NAZZIWA ', '', 1, 'CF860241077RFF', 'img/ids/IMG_20180306_122358_resized_20180306_122654990.jpg', 'F', 'Single', '1986-11-10', '(070) 137-6882', '', '', '', 'LUBAGA', 'HERBAL /LOCAL DOCTOR', 0, 0, NULL, 'img/profiles/IMG_20180306_122349_resized_20180306_122654801.jpg', '', '2018-03-06 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(825, 'Mrs', 0, 'BFS00000825', 'HADIJAH', 'NABATANZI ', '', 1, 'CF69031101Z17E', 'img/ids/IMG_20180306_123344_resized_20180306_123915679.jpg', 'F', 'Married', '1969-01-25', '(070) 165-2252', '(075) 266-0126', '', '', 'KIBUTIKA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/IMG_20180306_123336_resized_20180306_123748321.jpg', '', '2018-03-06 00:00:00', 0, 'NDEJJE', '', '', '', '', 0),
(826, 'Mrs', 0, 'BFS00000826', 'NABULIME', 'SWABURA', '', 1, 'CF71068103J83G', 'img/ids/IMG_20180306_123359_resized_20180306_123748103.jpg', 'F', 'Single', '1971-01-01', '(070) 141-9190', '', '', '', 'NDEJJE', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/IMG_20180306_123611_resized_20180306_123747905.jpg', '', '2018-03-06 00:00:00', 0, 'NDEJJE', '', '', '', '', 0),
(827, 'Mrs', 0, 'BFS00000827', 'SARAH', 'NANSITU', '', 1, 'CF90023102R2DD', 'img/ids/IMG_20180306_123651_resized_20180306_123748496.jpg', 'F', 'Single', '1990-11-24', '(078) 740-2284', '', '', '', 'SALAAMA', 'EMPLOYEE AT BULADDE FINANCIAL SERVICES', 0, 0, NULL, 'img/profiles/IMG_20180306_123651_resized_20180306_123748496.jpg', '', '2018-03-06 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(828, 'Mrs', 0, 'BFS00000828', 'SARAH', 'NANSITU', '', 1, 'CF90023102R2DD', 'img/ids/IMG_20180306_123651_resized_20180306_123748496.jpg', 'F', 'Single', '1990-11-24', '(078) 740-2284', '', '', '', 'SALAAMA', 'EMPLOYEE AT BULADDE FINANCIAL SERVICES', 0, 0, NULL, '', '', '2018-03-06 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(829, 'Mr', 0, 'BFS00000829', 'YUSUF', 'WALUKA', '', 1, 'CM82039100LM7G', 'img/ids/IMG_20180306_145707_resized_20180306_025801844.jpg', 'M', 'Single', '1982-10-10', '(070) 340-4027', '(071) 341-3543', '', '', 'KIBULI', 'BANKER', 0, 0, NULL, 'img/profiles/IMG_20180306_145658_resized_20180306_025802079.jpg', '', '2018-03-06 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(830, 'Mr', 0, 'BFS00000830', 'MOSES', 'KIGULI', '', 5, '4', '', 'M', 'Married', '1963-06-11', '(070) 900-0300', '', '', '', 'KAMPALA', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-03-07 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(831, 'Mrs', 0, 'BFS00000831', 'EDITH', 'KIGULI', '', 5, '4', '', 'F', 'Married', '1968-07-30', '(075) 143-5621', '', '', '', 'KAMPALA', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-03-07 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(832, 'Mrs', 0, 'BFS00000832', 'BERNADETTE', 'NAKYAMBADDE', '', 1, 'CF770171011HPA', 'img/ids/Snapshot_20180314_1.JPG', 'F', 'Single', '1977-12-15', '(070) 265-0286', '(078) 622-0892', '', '', 'BUKULUGI', 'AUDITOR', 0, 0, NULL, 'img/profiles/Snapshot_20180314_2.JPG', '', '2018-03-14 00:00:00', 0, '', '', '', 'MASANAFFU', '', 0),
(833, 'Mrs', 0, 'BFS00000833', 'Mastuurah', 'Nassuuna ', '', 1, 'CF88099101L9DK', 'img/ids/Snapshot_20180314_10.JPG', 'F', 'Single', '1988-11-03', '(075) 836-6886', '(078) 619-4652', '', '', 'KASANGATI', 'Teacher', 0, 0, NULL, 'img/profiles/Snapshot_20180314_9.JPG', '', '2018-03-14 00:00:00', 0, '', '', '', '', '', 0),
(834, 'Mrs', 0, 'BFS00000834', 'HARRIET', 'NABWAMI', '', 1, 'CF79012103YTDA', 'img/ids/Snapshot_20180314_7.JPG', 'F', 'Single', '1979-12-26', '(075) 876-1102', '(077) 266-5087', '', '', 'NANGABO', 'TEACHER', 0, 0, NULL, 'img/profiles/Snapshot_20180314_8.JPG', '', '2018-03-14 00:00:00', 0, '', '', 'KITEGOMBA', '', '', 0),
(835, 'Mr', 0, 'BFS00000835', 'JONATHAN', 'SEBINA', 'MUYINGO', 1, 'CM6702310512WG', 'img/ids/Snapshot_20180314_13.JPG', 'M', 'Married', '1967-10-23', '(077) 249-6116', '', '', '', 'NDEJJE ', 'BBS', 0, 0, NULL, 'img/profiles/Snapshot_20180314_12.JPG', '', '2018-03-14 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(836, 'Mrs', 0, 'BFS00000836', 'CAROL', 'NALINNYA', '', 4, 'BLB/PF/40', 'img/ids/Snapshot_20180315_1.JPG', 'F', 'Single', '1999-07-07', '(077) 554-5874', '(070) 505-6057', '', '', 'MAKINDYE', 'BLB', 0, 0, NULL, 'img/profiles/Snapshot_20180315.JPG', '', '2018-03-15 00:00:00', 0, '', '', '', '', '', 0),
(837, 'Mr', 0, 'BFS00000837', 'SOPHIA', 'RAMATHAN', 'MENYA', 3, 'B1346661', 'img/ids/Snapshot_20180315_3.JPG', 'F', 'Single', '1986-02-15', '(075) 244-9986', '', '', '', 'BUZIGA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180315_2.JPG', '', '2018-03-15 00:00:00', 0, '', '', 'KONGE', 'MAKINDYE', '', 0),
(838, 'Mr', 0, 'BFS00000838', 'VINCENT', 'SSENKAMBA', '', 1, 'CM72052108UYNF', 'img/ids/Snapshot_20180315_5.JPG', 'M', 'Married', '1972-08-24', '(075) 332-1773', '(075) 264-2866', '', '', 'KITALA', 'MECHANIC', 0, 0, NULL, 'img/profiles/Snapshot_20180315_4.JPG', '', '2018-03-15 00:00:00', 0, '', '', '', '', '', 0),
(839, 'Mr', 0, 'BFS00000839', 'HUZAIL', 'SSESEWA', '', 3, 'B0985695', 'img/ids/Snapshot_20180315_6.JPG', 'M', 'Single', '1986-08-12', '(070) 147-2255', '', '', '', 'BUSABALA', 'BUSINESS MAN', 0, 0, NULL, 'img/profiles/Snapshot_20180313.JPG', '', '2018-03-15 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(840, 'Mr', 0, 'BFS00000840', 'JOHN', 'SSEBIRUMBI', '', 1, 'CM46069100V5PC', 'img/ids/Snapshot_20180315_12.JPG', 'M', 'Married', '1946-04-17', '(078) 272-7046', '(070) 258-3848', '', '', 'KAZO', 'BUSINESS MAN', 0, 0, NULL, 'img/profiles/Snapshot_20180315_11.JPG', '', '2018-03-15 00:00:00', 0, '', '', '', 'BWAISE', '', 819),
(841, 'Mr', 0, 'BFS00000841', 'JAMES', 'LUBEGA', '', 0, 'CM5808210143AK', 'img/ids/Snapshot_20180315_15.JPG', 'M', 'Married', '1958-02-24', '(075) 498-0059', '(077) 552-1137', '', '', 'NJERU', 'FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180315_16.JPG', 'THIS IS A JOINT ACCOUNT', '2018-03-15 00:00:00', 0, '', '', '', '', '', 0),
(842, 'Mr', 0, 'BFS00000842', 'GEORGE', 'IGA', 'WILLIAM', 1, 'CN64082100GFFJ', 'img/ids/Snapshot_20180315_14.JPG', 'M', 'Married', '1964-02-26', '(070) 678-7643', '(077) 712-1717', '', '', 'NJERU', 'BUSINESS MAN AND FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180315_13.JPG', '', '2018-03-15 00:00:00', 0, '', 'NJERU', '', '', '', 0),
(843, 'Mr', 0, 'BFS00000843', 'ALOYSIUS', 'KAWOOYA', 'KIKWABANGA', 1, 'CM7703210285YJ', 'img/ids/Snapshot_20180315_18.JPG', 'M', 'Single', '1977-06-20', '(075) 946-5064', '(077) 304-2862', '', '', 'MPIGI', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180315_17.JPG', '', '2018-03-15 00:00:00', 0, '', '', '', '', '', 0),
(844, 'Mr', 0, 'BFS00000844', 'ISAAC', 'BIKORWENDA', '', 5, '212', 'img/ids/Snapshot_20180316.JPG', 'M', 'Married', '1976-02-20', '(075) 142-7561', '', '', '', 'WAKISO', 'FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180316.JPG', '', '2018-03-16 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(845, 'Mr', 0, 'BFS00000845', 'TUKAMUHABWA', 'FRED', '', 5, '300', 'img/ids/Snapshot_20180319.JPG', 'M', 'Single', '1972-05-09', '(078) 811-9506', '(070) 333-8090', '', '', 'BWAISE', 'BUSINESS MAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319.JPG', '', '2018-03-19 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(846, 'Mr', 0, 'BFS00000846', 'TWINAMATSIKO', 'DANIEL', '', 1, 'CM80034101T9WL', 'img/ids/Snapshot_20180319_1.JPG', 'M', 'Single', '1980-07-10', '(077) 722-9450', '(075) 229-4500', '', '', 'BWAISE', 'BODA BODA', 0, 0, NULL, 'img/profiles/Snapshot_20180319_2.JPG', '', '2018-03-19 00:00:00', 0, 'KAMAPLA', '', '', '', '', 0),
(847, 'Mrs', 0, 'BFS00000847', 'KATANA', 'JULIET', '', 1, 'CF94........', 'img/ids/Snapshot_20180319_3.JPG', 'F', 'Married', '1994-06-15', '(075) 910-4559', '', '', 'NDEJJE', 'NDEJJE', 'SHOE SELLER', 0, 0, NULL, 'img/profiles/Snapshot_20180319_3.JPG', '', '2018-03-19 00:00:00', 0, 'NDEJJE CENTRAL', '', '', '', '', 0),
(848, 'Mr', 0, 'BFS00000848', 'SAAD', 'SSEBULIBA', 'MUSA', 3, 'B1015257', 'img/ids/Snapshot_20180319_5.JPG', 'M', 'Married', '1979-02-12', '(075) 263-4688', '(077) 263-4688', '', '', 'NDEJJE ', 'BUSINESS MAN ', 0, 0, NULL, 'img/profiles/Snapshot_20180319_4.JPG', '', '2018-03-19 00:00:00', 0, '', '', '', 'KIBUTIKA', '', 0),
(849, 'Mrs', 0, 'BFS00000849', 'NAMUJJU', 'JANE', '', 1, 'CF72100105HKRC', 'img/ids/Snapshot_20180319_6.JPG', 'F', 'Single', '1972-07-01', '(077) 449-4691', '(075) 236-0721', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180319_7.JPG', '', '2018-03-19 00:00:00', 0, '', '', 'NDIKUTTA MADDA STAGE', 'NDIKUTTA MADDA STAGE', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(850, 'Mrs', 0, 'BFS00000850', 'RUTH', 'NANKABIRWA', '', 1, 'CF690241020VHG', 'img/ids/Snapshot_20180319_13.JPG', 'F', 'Single', '1969-03-19', '(075) 581-9626', '', '', '', 'NAMASUBA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180319_12.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(851, 'Mrs', 0, 'BFS00000851', 'NAMAKULA', 'DOROTHY', '', 1, 'CF91036102VKQD', 'img/ids/Snapshot_20180319_15.JPG', 'F', 'Single', '0000-00-00', '(078) 909-0569', '(077) 321-0036', '', '', 'BUNAMWAYA', ' BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_16.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', 'ZAANA', '', '', 819),
(852, 'Mrs', 0, 'BFS00000852', 'HADIJAH', 'NABIKOLO', '', 1, 'CF6100...', 'img/ids/Snapshot_20180319_14.JPG', 'F', 'Single', '1961-01-01', '(070) 213-7499', '(078) 213-7499', '', '', 'MASAJJA', 'SHOE SELLER', 0, 0, NULL, 'img/profiles/Snapshot_20180319_14.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(853, 'Mr', 0, 'BFS00000853', 'FLORENCE', 'KAYAGA', '', 5, 'KLE/192', 'img/ids/Snapshot_20180319_18.JPG', 'F', 'Single', '1979-05-25', '(075) 861-5081', '(077) 869-7637', '', '', 'ZAANA', 'MARKET VENDOR', 0, 0, NULL, 'img/profiles/Snapshot_20180319_17.JPG', '', '2018-03-19 00:00:00', 0, '', '', 'KEYAGALILE', '', '', 0),
(854, 'Mrs', 0, 'BFS00000854', 'JULIET', 'NABUUMA', '', 1, 'CF9903110AFL6D', 'img/ids/Snapshot_20180319_19.JPG', 'F', 'Single', '1999-08-08', '(077) 123-7510', '', '', '', 'MUNYONYO', 'HOUSE MAID', 0, 0, NULL, 'img/profiles/Snapshot_20180319_20.JPG', '', '2018-03-19 00:00:00', 0, 'KAMAPLA', '', '', '', '', 0),
(855, 'Mrs', 0, 'BFS00000855', 'CAROLINE', 'NABUKENYA', '', 1, 'CF6905210GDY8C', 'img/ids/Snapshot_20180319_22.JPG', 'F', 'Single', '1969-03-03', '(075) 712-4438', '', '', '', 'ZAANA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_21.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(856, 'Mrs', 0, 'BFS00000856', 'MILLY', 'NAMUYIGA', '', 1, 'CF9023103R87F', 'img/ids/Snapshot_20180319_23.JPG', 'F', 'Single', '1979-10-09', '(075) 729-7746', '', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_23.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(857, 'Mr', 0, 'BFS00000857', 'WILLIAM', 'MUGEJJERA', '', 5, '19219', 'img/ids/Snapshot_20180319_25.JPG', 'F', 'Single', '1996-09-13', '(075) 404-7250', '', '', '', 'NABWERU', 'CRAFT MAKER', 0, 0, NULL, 'img/profiles/Snapshot_20180319_26.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(858, 'Mrs', 0, 'BFS00000858', 'ERON', 'KIKOMAGA', '', 1, 'CF66043100D8F', 'img/ids/Snapshot_20180319_28.JPG', 'M', 'Single', '1966-10-24', '(077) 721-6034', '(070) 670-0447', '', '', 'NABWERU', 'FARMIMG ', 0, 0, NULL, 'img/profiles/Snapshot_20180319_27.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(859, 'Mrs', 0, 'BFS00000859', 'MARIAM', 'NAMUBIRU', '', 1, '116943000CLIO', 'img/ids/Snapshot_20180319_30.JPG', 'F', 'Single', '1987-01-01', '(077) 472-6950', '(075) 768-7147', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_29.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(860, 'Mr', 0, 'BFS00000860', ' MUSA', 'BUKENYA', '', 3, 'B1069933', 'img/ids/Snapshot_20180319_31.JPG', 'M', 'Single', '1989-08-01', '(078) 229-6960', '(070) 429-6960', '', '', 'GA YAZA', 'BUSINESS MAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_31.JPG', '', '2018-03-19 00:00:00', 0, 'GAYAZA', '', '', '', '', 0),
(861, 'Mr', 0, 'BFS00000861', 'MOSES', 'BYAMUKAMA', '', 1, 'CF690', 'img/ids/Snapshot_20180319_32.JPG', 'M', 'Married', '1969-01-09', '(077) 229-4499', '(070) 132-0980', '', '', 'KAWEMPE', 'BUSINESS MAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_32.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(862, 'Mr', 0, 'BFS00000862', 'LAKABU', 'NAKYAANZI', '', 1, 'CF77091100HR2H', 'img/ids/Snapshot_20180319_33.JPG', 'F', 'Single', '1977-01-01', '(075) 332-7147', '', '', '', 'NABWERU', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_34.JPG', '', '2018-03-19 00:00:00', 0, '', '', '', '', '', 0),
(863, 'Mr', 0, 'BFS00000863', 'MARTIN', 'MUNYWANYI', '', 1, 'CM740681018KMG', 'img/ids/Snapshot_20180319_36.JPG', 'F', 'Single', '1974-05-15', '(070) 199-6042', '(078) 017-7976', '', '', 'KATWE', 'INTERIOR DESIGNER', 0, 0, NULL, 'img/profiles/Snapshot_20180319_35.JPG', '', '2018-03-19 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(864, 'Mrs', 0, 'BFS00000864', ' HARRIET', 'NANYONJO', '', 1, 'CF6909110462ZA', 'img/ids/Snapshot_20180319_38.JPG', 'F', 'Married', '1969-05-26', '(075) 268-2491', '', '', '', 'NABWERU', 'HOUSE WIFE', 0, 0, NULL, 'img/profiles/Snapshot_20180319_37.JPG', '', '2018-03-19 00:00:00', 0, '', '', 'NABWERU NORTH', '', '', 0),
(865, 'Mr', 0, 'BFS00000865', 'KIYINGI', 'DERRICK', '', 1, 'CM9504210HKTKF', 'img/ids/Snapshot_20180319_40.JPG', 'M', 'Single', '1995-10-21', '(077) 163-1776', '(075) 991-0241', '', '', 'NABWERU', 'BUSINESS MAN ', 0, 0, NULL, 'img/profiles/Snapshot_20180319_39.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(866, 'Mrs', 0, 'BFS00000866', 'PROSSY', 'NANSOZI', '', 1, 'CF86023101PD4K', 'img/ids/Snapshot_20180319_42.JPG', 'F', 'Married', '1986-08-18', '(075) 555-6441', '(075) 037-8240', '', '', 'NABWERU', 'MARKET VENDOR', 0, 0, NULL, 'img/profiles/Snapshot_20180319_41.JPG', '', '2018-03-19 00:00:00', 0, '', '', 'NABWERU SOUTH', '', '', 0),
(867, 'Mrs', 0, 'BFS00000867', 'REHEMA', 'KICONCO', '', 1, 'CF7700910AF5ND', 'img/ids/Snapshot_20180319_44.JPG', 'F', 'Single', '1977-05-10', '(077) 431-8560', '', '', '', 'ZAANA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_43.JPG', '', '2018-03-19 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(868, 'Mrs', 0, 'BFS00000868', 'SARAH', 'NAKABANDA', '', 4, 'CF780...', 'img/ids/Snapshot_20180319_45.JPG', 'F', 'Married', '1978-10-03', '(078) 800-9068', '', '', '', 'KASUBI', 'SALES EXECUTIVE', 0, 0, NULL, '', '', '2018-03-19 00:00:00', 0, '', '', '', '', '', 0),
(869, 'Mrs', 0, 'BFS00000869', 'POLINE', 'NABUKALU', '', 1, 'CF84082106ULNF', 'img/ids/Snapshot_20180319_46.JPG', 'F', 'Single', '1984-10-04', '(077) 820-9410', '(070) 530-9686', '', '', 'NABWERU', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180319_47.JPG', '', '2018-03-19 00:00:00', 0, '', '', 'NABWERU NORTH', '', '', 0),
(870, 'Mrs', 0, 'BFS00000870', 'ROSE', 'NALUGGYA', '', 1, 'CF570231009KCA', 'img/ids/Snapshot_20180319_48.JPG', 'F', 'Married', '1957-12-30', '(075) 856-6891', '(078) 552-7639', '', '', 'KIGUNDU ZONE', 'SHOP ATTENDANT', 0, 0, NULL, 'img/profiles/Snapshot_20180319_49.JPG', '', '2018-03-19 00:00:00', 0, '', 'SEBINA', 'KALERWE', '', '', 0),
(871, 'Mrs', 0, 'BFS00000871', 'MARGRET', 'NAMUTEBI', '', 1, 'CF64052100AEYJ', 'img/ids/Snapshot_20180319_51.JPG', 'F', 'Married', '1964-08-20', '(077) 437-1905', '', '', '', 'KIGUNDU ZONE', 'GOAT SELLER', 0, 0, NULL, 'img/profiles/Snapshot_20180319_50.JPG', '', '2018-03-19 00:00:00', 0, '', '', 'SEBINA', '', '', 0),
(872, 'Mr', 0, 'BFS00000872', 'HUSSEIN', 'SESSANGA ', '', 1, 'CM79023104E8RE', 'img/ids/Snapshot_20180319_53.JPG', 'F', 'Single', '1979-10-01', '(070) 231-6317', '', '', '', 'MASAJJA', 'SHOP ATTENDANT', 0, 0, NULL, 'img/profiles/Snapshot_20180319_52.JPG', '', '2018-03-19 00:00:00', 0, '', '', '', '', '', 0),
(873, 'Mrs', 0, 'BFS00000873', 'LABIAH', 'NANTUME ', '', 1, 'CF41068106V6G', 'img/ids/Snapshot_20180319_55.JPG', 'F', 'Married', '1941-01-01', '(078) 829-5878', '(075) 235-9916', '', '', 'BUSUNJJU', 'FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180319_54.JPG', '', '2018-03-19 00:00:00', 0, 'BUSUNJJU', '', '', '', '', 0),
(874, 'Mrs', 0, 'BFS00000874', 'MADINA', 'NAJJINGO', '', 1, 'CF870....', 'img/ids/Snapshot_20180320.JPG', 'F', 'Single', '1987-12-11', '(075) 346-5341', '', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320.JPG', '', '2018-03-20 00:00:00', 0, 'WAKISO', '', 'KKIVULE', '', '', 0),
(875, 'Mrs', 0, 'BFS00000875', 'SARAH', 'NAMAGEMBE', '', 1, 'CF7105210FWZGE', 'img/ids/Snapshot_20180320_2.JPG', 'F', 'Single', '1971-07-02', '(070) 459-4472', '', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_1.JPG', '', '2018-03-20 00:00:00', 0, '', 'GANDU', '', '', '', 0),
(876, 'Mrs', 0, 'BFS00000876', 'TEDDY', 'NABANJA', 'NYANZI', 3, 'B1245879', 'img/ids/Snapshot_20180320_4.JPG', 'F', 'Single', '1987-10-08', '(077) 886-1881', '', '', '', 'MAKINDYE', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_3.JPG', '', '2018-03-20 00:00:00', 0, '', '', '', '', '', 0),
(877, 'Mrs', 0, 'BFS00000877', 'MUKIIBI', 'SETTUBA', 'SSERUNJOGI', 1, 'CM89105105W33J', 'img/ids/Snapshot_20180320_6.JPG', 'M', 'Single', '1989-05-03', '(075) 666-3600', '(077) 566-3600', '', 'KITEREDDE', 'KISAAKA', 'BUSINESSMAN', 0, 0, NULL, '', '', '2018-03-20 00:00:00', 0, 'LWENGO', '', '', '', '', 0),
(878, 'Mrs', 0, 'BFS00000878', 'FLORA', 'MUJUNI', '', 1, 'CF69004102VPPH', 'img/ids/Snapshot_20180320_8.JPG', 'F', 'Married', '1969-12-04', '(070) 500-9225', '(077) 269-5050', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_7.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'BUSABALA ROAD', '', '', 0),
(879, 'Mrs', 0, 'BFS00000879', 'GORRETH', 'NAKANYIKE', '', 1, 'CF82024103UEKL', 'img/ids/Snapshot_20180320_10.JPG', 'F', 'Single', '1982-12-03', '(078) 740-0060', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_9.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'NDIKUTTA', 'MADDA', '', 0),
(880, 'Mrs', 0, 'BFS00000880', 'PROSSY', 'NALWEYISO', '', 1, 'CF78023106UFNH', 'img/ids/Snapshot_20180320_12.JPG', 'F', 'Single', '1978-11-04', '(078) 477-1542', '(075) 033-0264', '', '', 'BUSABALA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_11.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'WALULENZI', '', '', 0),
(881, 'Mrs', 0, 'BFS00000881', 'FARIDAH', 'NALUKWAGO', '', 5, '7470', 'img/ids/Snapshot_20180320_14.JPG', 'F', 'Single', '1972-11-12', '(078) 053-0799', '(075) 879-1314', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_13.JPG', '', '2018-03-20 00:00:00', 0, '', '', '', '', '', 0),
(882, 'Mr', 0, 'BFS00000882', 'GODFREY', 'SSALI', 'KIGGUNDU', 1, 'CM680521100RC0J', 'img/ids/Snapshot_20180320_18.JPG', 'M', 'Married', '1968-04-04', '(075) 665-6864', '(077) 665-6864', '', 'KITENDE', 'LUMULI', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_17.JPG', '', '2018-03-20 00:00:00', 0, 'BUSIRO', '', 'SSISA', '', '', 0),
(883, 'Mrs', 0, 'BFS00000883', 'JALIA', 'NAMUTEBI', '', 5, '5048', 'img/ids/Snapshot_20180320_20.JPG', 'F', 'Married', '1965-11-12', '(075) 031-8752', '(077) 367-9294', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_19.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'KUMASOMERO', '', '', 0),
(884, 'Mrs', 0, 'BFS00000884', 'FATUMAH', 'NABUKENYA', '', 1, 'CF92105102AXDC', 'img/ids/Snapshot_20180320_22.JPG', 'F', 'Single', '1992-11-10', '(075) 404-4341', '(078) 271-7558', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_21.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'KUMASOMERO', '', '', 0),
(885, 'Mrs', 0, 'BFS00000885', 'JUSTINE', 'NANSUBUGA', '', 1, 'CF790231018NEJ', 'img/ids/Snapshot_20180320_24.JPG', 'F', 'Single', '1979-12-04', '(078) 259-5751', '(077) 242-3432', '', '', 'MASAJJA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_23.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'KUMASOMERO', '', '', 0),
(886, 'Mrs', 0, 'BFS00000886', 'PETER', 'NABAWESI', '', 1, 'CF71031100XU4E', 'img/ids/Snapshot_20180320_26.JPG', 'F', 'Single', '1971-02-02', '(078) 345-4426', '', '', '', 'BWEYOGERERE', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_25.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'KITO', '', '', 0),
(887, 'Mrs', 0, 'BFS00000887', 'VICKIE', 'KASIMBI', 'RUTH', 1, 'CF8201710067EJ', 'img/ids/Snapshot_20180320_33.JPG', 'F', 'Single', '1982-05-04', '(070) 458-7680', '(077) 258-7680', '', '', 'MAKINDYE', 'NOT EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180320_34.JPG', '', '2018-03-20 00:00:00', 0, '', '', '', '', '', 0),
(888, 'Mrs', 0, 'BFS00000888', 'LYDIA', 'NAKIBUUKA', '', 1, 'CF900301040RDA', 'img/ids/Snapshot_20180320_36.JPG', 'F', 'Married', '1990-05-04', '(075) 948-5485', '', '', '', 'PARK VILLAGE', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180320_37.JPG', '', '2018-03-20 00:00:00', 0, '', '', 'MPIGI', '', '', 0),
(889, 'Mr', 0, 'BFS00000889', 'FRED', 'LUYONDE', '', 1, 'CM82023106WC1G', 'img/ids/Snapshot_20180321_1.JPG', 'M', 'Single', '1982-02-02', '(075) 577-5186', '', '', '', 'KIBIRI ZONE A', 'BODABODA ', 0, 0, NULL, 'img/profiles/Snapshot_20180321.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(890, 'Mrs', 0, 'BFS00000890', 'GRACE', 'NAMWANJE', '', 4, '2360', 'img/ids/Snapshot_20180321_3.JPG', 'F', 'Married', '1983-04-04', '(077) 444-5710', '', '', '', 'MASAJJA ZONE B', 'SELF EMPLOYED', 0, 0, NULL, '', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(891, 'Mrs', 0, 'BFS00000891', 'SALMAH', 'NAMUGANZA', '', 1, 'CF790131028AGF', 'img/ids/Snapshot_20180321_7.JPG', 'F', 'Single', '1979-05-12', '(077) 571-7440', '(075) 599-2778', '', '', 'MASAJJA ZONE B', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_8.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', 'MADDA', '', 0),
(892, 'Mrs', 0, 'BFS00000892', 'NORAH', 'NAYIGA', '', 1, 'CF760', 'img/ids/Snapshot_20180321_9.JPG', 'F', 'Single', '1976-08-04', '(075) 193-7266', '', '', '', 'GANGU B', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_9.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(893, 'Mr', 0, 'BFS00000893', 'ANDREW', 'SSENYIMBA', '', 4, '10/14', 'img/ids/Snapshot_20180321_12.JPG', 'M', 'Single', '1992-10-08', '(070) 067-0167', '(078) 390-3952', '', '', 'KYENGERA', 'DRIVER ', 0, 0, NULL, 'img/profiles/Snapshot_20180321_10.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(894, 'Mrs', 0, 'BFS00000894', 'BAKER', 'NAMAKULA', '', 1, 'CF730', 'img/ids/Snapshot_20180321_13.JPG', 'F', 'Single', '1973-10-12', '(075) 922-7065', '', '', '', 'NABWERU', 'HAIR DRESSER', 0, 0, NULL, 'img/profiles/Snapshot_20180321_13.JPG', '', '2018-03-21 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(895, 'Mr', 0, 'BFS00000895', 'GUSTOVUS', 'MAYANJA', '', 1, 'CM780', 'img/ids/Snapshot_20180321_14.JPG', 'M', 'Single', '1978-09-03', '(075) 130-7203', '', '', '', 'MUKONO', 'BLB COMPLIANCE', 0, 0, NULL, 'img/profiles/Snapshot_20180321_14.JPG', '', '2018-03-21 00:00:00', 0, 'MUKONO', '', '', '', '', 0),
(896, 'Mr', 0, 'BFS00000896', 'SIMON', 'KABOGOZA', '', 1, 'CM740', 'img/ids/Snapshot_20180321_14.JPG', 'M', 'Single', '1974-08-12', '(073) 042-0709', '(077) 242-0709', '', '', 'KIKAJJO', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_14.JPG', '', '2018-03-21 00:00:00', 0, '', '', 'BUSIRO', '', '', 0),
(897, 'Mrs', 0, 'BFS00000897', 'FLORENCE', 'NALWANGA', '', 1, 'CF870', 'img/ids/Snapshot_20180321_16.JPG', 'F', 'Single', '1987-06-12', '(078) 742-6969', '(073) 000-3524', '', '', 'MAKINDYE', 'ADMINISTRATOR', 0, 0, NULL, '', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(898, 'Mrs', 0, 'BFS00000898', 'SCOVIA', 'NIMUSIIMA', '', 1, 'CF83034101WO1D', 'img/ids/Snapshot_20180321_17.JPG', 'F', 'Single', '1983-06-05', '(077) 314-4887', '', '', '', 'LWEZA A', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180321_18.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(899, 'Mr', 0, 'BFS00000899', 'NUTTU', 'KADDU', '', 1, 'CM910', 'img/ids/Snapshot_20180321_25.JPG', 'M', 'Single', '1991-03-07', '(070) 044-7969', '(077) 071-9664', '', '', 'LUNGUJJA', 'DRIVER', 0, 0, NULL, 'img/profiles/Snapshot_20180321_25.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(900, 'Mr', 0, 'BFS00000900', 'MOSES', 'KIZITO', 'GAMBOBBI', 1, 'CM760', 'img/ids/Snapshot_20180321_26.JPG', 'M', 'Single', '1976-09-03', '(073) 050-0614', '(075) 282-2403', '', '', 'MAKINDYE', 'OFFICER BLB', 0, 0, NULL, 'img/profiles/Snapshot_20180321_26.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(901, 'Mr', 0, 'BFS00000901', 'SULAIMAN', 'KATUMBA', '', 1, 'CM520', 'img/ids/Snapshot_20180321_27.JPG', 'M', 'Single', '1952-10-06', '(078) 240-5574', '(070) 334-3996', '', '', 'KATWE 11', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180321_27.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', 'KIGANDA ZONE', 0),
(902, 'Mr', 0, 'BFS00000902', 'BRIAN', 'SSERUNYIIGO', '', 1, 'CM910', 'img/ids/Snapshot_20180321_31.JPG', 'M', 'Single', '1991-02-07', '(077) 527-4651', '(070) 096-2455', '', '', 'NAMUNGOONA', 'SURVEYOR', 0, 0, NULL, 'img/profiles/Snapshot_20180321_31.JPG', '', '2018-03-21 00:00:00', 0, '', '', '', '', '', 0),
(903, 'Mrs', 0, 'BFS00000903', 'SLYIVIA', 'NALUGAAJU', '', 1, 'CF81024107XHCH', 'img/ids/Snapshot_20180322_3.JPG', 'F', 'Single', '1981-05-11', '(077) 733-3507', '(075) 551-1665', '', '', 'NDEJJE', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180322_2.JPG', '', '2018-03-22 00:00:00', 0, '', '', 'KIBUTIKA', '', '', 0),
(904, 'Mrs', 0, 'BFS00000904', 'BEATRICE', 'NALUBEGA', '', 1, 'CF76036104HWZD', 'img/ids/Snapshot_20180322_5.JPG', 'F', 'Married', '1976-10-05', '(078) 290-4464', '', '', '', 'NSAMBYA', 'SELF EMPLOYED', 0, 0, NULL, '', '', '2018-03-22 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(905, 'Mr', 0, 'BFS00000905', 'YASIN', 'NSEREKO', '', 1, 'CM69098101DKHD', 'img/ids/Snapshot_20180323_1.JPG', 'M', 'Single', '1969-08-12', '(078) 201-8749', '', '', 'NAKULABYE', 'MUJOMBA', 'TAILOR', 0, 0, NULL, 'img/profiles/Snapshot_20180323.JPG', '', '2018-03-23 00:00:00', 0, 'KAMPALA', '', 'RUBAGA DIVISION', '', '', 0),
(906, 'Mrs', 0, 'BFS00000906', 'TEOPISTA', 'MBATUDDE', '', 1, 'C60098101Z0JK', 'img/ids/Snapshot_20180323_5.JPG', 'F', 'Married', '1960-02-02', '(077) 789-8589', '(075) 189-8589', '', '', 'MBALALA LC1', 'FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180323_4.JPG', 'BOUGHT A SHARE OF 5OOOOSHS', '2018-03-23 00:00:00', 0, 'MITYANA', '', '', '', '', 819),
(907, 'Mrs', 0, 'BFS00000907', 'FARIDAH', 'NAJJINGO', '', 1, 'CF840991019ZPF', 'img/ids/Snapshot_20180323_15.JPG', 'F', 'Single', '1984-10-05', '(078) 340-8140', '(070) 502-6240', '', '', 'NYANAMA', 'BANKER', 0, 0, NULL, '', '', '2018-03-23 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(908, 'Mr', 0, 'BFS00000908', 'MUZAMIL', 'SWALE', 'MUSEMA', 1, 'CM91066100ETAK', 'img/ids/Snapshot_20180323_17.JPG', 'M', 'Single', '1991-05-04', '(070) 481-8051', '(070) 609-0251', '', '', 'KAWEMPE', 'BUS AGENT', 0, 0, NULL, 'img/profiles/Snapshot_20180323_18.JPG', '', '2018-03-23 00:00:00', 0, '', '', '', 'LUBAGA', '', 0),
(909, 'Mr', 0, 'BFS00000909', 'SAIDI', 'BUSULWA', '', 1, 'CM79091102CQ3H', 'img/ids/Snapshot_20180412.JPG', 'M', 'Married', '1979-10-10', '(077) 292-7534', '(075) 292-7534', '', '', 'KYENGERA', 'BODA BODA CYCLIST', 0, 0, NULL, 'img/profiles/Snapshot_20180412.JPG', '', '2018-04-04 00:00:00', 0, 'WAKISO', 'WAKISO', '', 'WAKISO', '', 819),
(910, 'Mr', 0, 'BFS00000910', 'JUMA', 'MBARIRWA', '', 4, '10319303/3/1', 'img/ids/Snapshot_20180412_1.JPG', 'M', 'Married', '1962-10-01', '(070) 677-1720', '', '', '', 'NABINGO', 'WELDER', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(911, 'Mr', 0, 'BFS00000911', 'ABDALAHTIIFU', 'MUTYABA', '', 1, 'CM780321013H9L', 'img/ids/Snapshot_20180412_2.JPG', 'M', 'Married', '1978-04-01', '(077) 982-8485', '(075) 982-8485', '', '', 'SALAAMA', 'CARPENTER', 0, 0, NULL, 'img/profiles/Snapshot_20180412_2.JPG', '', '2018-04-12 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(912, 'Mrs', 0, 'BFS00000912', 'RUTH', 'NAMWANJE ', '', 1, 'CF79023100MDOF', 'img/ids/Snapshot_20180412_3.JPG', 'F', 'Single', '1979-09-10', '(070) 396-3292', '(078) 481-7765', '', '', 'NDEJJE', 'FARMER', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(913, 'Mrs', 0, 'BFS00000913', 'PROSSY', 'SSENTAMU', '', 1, 'CF7505210F1MPK', 'img/ids/Snapshot_20180412_4.JPG', 'F', 'Single', '1975-03-07', '(070) 188-1674', '', '', '', 'MASAJJA', 'CLOTHES SELLER', 0, 0, NULL, 'img/profiles/Snapshot_20180412_4.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(914, 'Mr', 0, 'BFS00000914', 'Samuel', 'Ssendyowa', '', 1, 'CM90', 'img/ids/Snapshot_20180412_5.JPG', 'F', 'Married', '1989-12-31', '(075) 326-1643', '', '', '', 'MASAJJA', 'phone techniques', 0, 0, NULL, 'img/profiles/Snapshot_20180412_5.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(915, 'Mrs', 0, 'BFS00000915', 'ZAMU', 'NABATTU', '', 1, 'CF67100104ATQL', 'img/ids/Snapshot_20180412_6.JPG', 'F', 'Married', '1967-10-09', '(070) 172-8693', '', '', '', 'GANGU', 'MEDICINE SELLER', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(916, 'Mr', 0, 'BFS00000916', 'GODFREY', 'MULINDWA', '', 1, 'CM73024103M45J', 'img/ids/Snapshot_20180425.JPG', 'M', 'Married', '1973-10-19', '(077) 336-6505', '(075) 715-7352', '', '', 'KIRA', 'DRIVER STEEL TUBE', 0, 0, NULL, 'img/profiles/Snapshot_20180412_7.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(917, 'Mrs', 0, 'BFS00000917', 'PROSSY', 'NABUKENYA', '', 1, 'CF80105101X5VH', 'img/ids/Snapshot_20180412_8.JPG', 'F', 'Married', '1980-02-10', '(075) 880-5349', '', '', '', 'NDEJJE', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180412_8.JPG', '', '2018-04-12 00:00:00', 0, '', '', '', '', '', 0),
(918, 'Mr', 0, 'BFS00000918', 'TADEO', 'LUBEGA', '', 1, 'CM97036102NH1E', 'img/ids/Snapshot_20180412_9.JPG', 'M', 'Single', '1997-03-06', '(070) 100-6704', '', '', '', 'KANAABA', 'MECHANIC', 0, 0, NULL, 'img/profiles/Snapshot_20180412_9.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(919, 'Mrs', 0, 'BFS00000919', 'CATHERINE', 'NAMAGANDA', '', 1, 'CF780', 'img/ids/Snapshot_20180412_10.JPG', 'F', 'Married', '1978-07-11', '(077) 488-7370', '', '', '', 'NDEJJE', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(920, 'Mrs', 0, 'BFS00000920', 'CATHERINE', 'NABADDA', '', 1, 'CF86098104RMEH', 'img/ids/Snapshot_20180412_11.JPG', 'F', 'Single', '1986-07-12', '(070) 084-3956', '', '', '', 'NDEJJE', 'FARMER AND TAILORING', 0, 0, NULL, 'img/profiles/Snapshot_20180412_11.JPG', '', '2018-04-12 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(921, 'Mrs', 0, 'BFS00000921', 'BARBRAH', 'NABACHWA', '', 1, 'CF83032102ZYLK', 'img/ids/Snapshot_20180412_12.JPG', 'F', 'Single', '1983-02-02', '(078) 240-3738', '', '', '', 'BUSEGA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180412_12.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(922, 'Mr', 0, 'BFS00000922', 'DENIS', 'KAASA', '', 1, 'CM80098101T15H', 'img/ids/Snapshot_20180412_13.JPG', 'M', 'Single', '1980-01-07', '(075) 295-2120', '', '', '', 'KANAABA', 'BUSINESS MAN ', 0, 0, NULL, 'img/profiles/Snapshot_20180412_13.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(923, 'Mr', 0, 'BFS00000923', 'HERBERT', 'LUSIBA', '', 1, 'CM76052109AJ9H', 'img/ids/Snapshot_20180412_14.JPG', 'M', 'Single', '1976-07-04', '(075) 237-7214', '(078) 395-3054', '', '', 'MAYA', 'BUSINESS MAN ', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(924, 'Mr', 0, 'BFS00000924', 'JULIUS', 'KYAMBADDDE', '', 5, '7555', 'img/ids/Snapshot_20180412_15.JPG', 'M', 'Single', '1982-01-01', '(075) 604-2733', '', '', '', 'NDEJJE', 'WELDER', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(925, 'Mr', 0, 'BFS00000925', 'HERMAN', 'NSIBAMBI', '', 1, 'CM74052105L27H', 'img/ids/Snapshot_20180412_16.JPG', 'M', 'Single', '1974-06-08', '(078) 946-6882', '', '', '', 'MAYA', 'BUSINESS MAN ', 0, 0, NULL, 'img/profiles/Snapshot_20180412_16.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(926, 'Mr', 0, 'BFS00000926', 'PAUL', 'KITANDWE', '', 1, 'CM77012106YEE', 'img/ids/Snapshot_20180412_17.JPG', 'M', 'Married', '1977-01-06', '(077) 331-7226', '(073) 031-7226', '', '', 'KIBUYE 11', 'BUSINESS MAN ', 0, 0, NULL, 'img/profiles/Snapshot_20180412_17.JPG', '', '2018-04-12 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(927, 'Mrs', 0, 'BFS00000927', 'JOANNESFRANCIS', 'BIRABWA', '', 1, 'CF680681027JRL', 'img/ids/Snapshot_20180412_18.JPG', 'M', 'Married', '1968-01-04', '(077) 246-6276', '', '', '', 'MASANAFFU', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180412_18.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(928, 'Mr', 0, 'BFS00000928', 'MASSAN', 'MALUDAH', 'MICHEAL', 1, 'CM59026107094C', 'img/ids/Snapshot_20180412_19.JPG', 'M', 'Married', '1959-12-11', '(070) 638-7183', '', '', '', 'MASANAFFU', 'BUSINESS MAN ', 0, 0, NULL, 'img/profiles/Snapshot_20180412_19.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(929, 'Mr', 0, 'BFS00000929', 'JONATHAN', 'SSENTUME', '', 4, '10955410/1/1', 'img/ids/Snapshot_20180412_20.JPG', 'M', 'Married', '1971-03-01', '(075) 638-8437', '(078) 238-8437', '', '', 'MASANAFFU', 'MACHINE OPERATOR', 0, 0, NULL, 'img/profiles/Snapshot_20180412_20.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(930, 'Mr', 0, 'BFS00000930', 'HUMARU', 'KATUMBA', '', 1, 'CM750241003YKK', 'img/ids/Snapshot_20180412_21.JPG', 'M', 'Single', '1975-07-08', '(070) 082-4441', '', '', '', 'KASUBI', 'DRIVER', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(931, 'Mr', 0, 'BFS00000931', 'HARUNA', 'KACHWENDU', '', 1, 'CM68033100K5DG', 'img/ids/Snapshot_20180412_22.JPG', 'M', 'Married', '1968-01-05', '(071) 731-5689', '', '', '', 'KAZO', 'CONTRACTOR', 0, 0, NULL, 'img/profiles/Snapshot_20180412_22.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(932, 'Mr', 0, 'BFS00000932', 'SAM', 'SUDU', '', 1, 'CM81014101R0PA', 'img/ids/Snapshot_20180412_23.JPG', 'M', 'Single', '1981-01-11', '(078) 291-9514', '(070) 161-2191', '', 'KITALA', 'ENTEBBE', 'DATA ENTRY', 0, 0, NULL, 'img/profiles/Snapshot_20180412_24.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(933, 'Mr', 0, 'BFS00000933', 'EDWARD', 'SEKANYO', '', 1, 'CM9102310ATM6E', 'img/ids/Snapshot_20180412_25.JPG', 'M', 'Married', '1991-08-08', '(078) 430-8043', '(070) 592-1542', '', '', 'MPEREREWE', 'DRIVER', 0, 0, NULL, 'img/profiles/Snapshot_20180412_25.JPG', '', '2018-04-12 00:00:00', 0, 'KAMAPLA', '', '', '', '', 0),
(934, 'Mr', 0, 'BFS00000934', 'ABDUL', 'SSEMANDA', 'HAKIM', 1, 'CM8805210EWJ8G', 'img/ids/Snapshot_20180412_26.JPG', 'M', 'Single', '1988-08-01', '(070) 432-1008', '', '', '', 'WAKALIGA', 'DRIVER', 0, 0, NULL, 'img/profiles/Snapshot_20180412_26.JPG', '', '2018-04-12 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(935, 'Mrs', 0, 'BFS00000935', 'CATHERINE', 'NALUGWA', '', 3, 'B1166198', 'img/ids/Snapshot_20180412_27.JPG', 'F', 'Married', '1986-03-12', '(070) 670-4651', '', '', '', 'WAKALIGA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180412_27.JPG', '', '2018-04-12 00:00:00', 0, 'KAMAPLA', '', '', '', '', 0),
(936, 'Mr', 0, 'BFS00000936', 'ABDUL', 'KATENDE', 'AZIZ', 3, 'B0768595', 'img/ids/Snapshot_20180412_29.JPG', 'M', 'Married', '1960-12-09', '(075) 246-6515', '', '', '', 'KAKIRI', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180412_29.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(937, 'Mr', 0, 'BFS00000937', 'REBECCA', 'NANSASI', '', 1, 'CM750', 'img/ids/Snapshot_20180412_30.JPG', 'F', 'Married', '1975-09-03', '(071) 319-7603', '', '', '', 'MAIN STREET', 'REGISTERED NURSE', 0, 0, NULL, '', '', '2018-04-12 00:00:00', 0, 'KAMAPLA', '', '', '', '', 0),
(938, 'Mr', 0, 'BFS00000938', 'SARAH', 'KAITESI', '', 1, 'CF88024103TFFF', 'img/ids/Snapshot_20180412_31.JPG', 'F', 'Single', '1988-09-09', '(077) 262-4808', '', '', '', 'NSAMBYA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180412_31.JPG', '', '2018-04-12 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(939, 'Mrs', 0, 'BFS00000939', 'JOWERIA', 'NAJUUKO', '', 1, 'CF92098102DRDC', 'img/ids/Snapshot_20180417.JPG', 'F', 'Single', '1992-11-03', '(075) 449-4248', '', '', '', 'SEETA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180417.JPG', '', '2018-04-17 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(940, 'Mr', 0, 'BFS00000940', 'MICHEAL', 'MUJABI', '', 1, 'CM76068100JE2L', 'img/ids/Snapshot_20180417_1.JPG', 'M', 'Single', '1976-11-12', '(075) 241-6122', '', '', '', 'MAKINDYE', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180417_1.JPG', '', '2018-04-17 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(941, 'Mr', 0, 'BFS00000941', 'JORAM', 'WEYASE', 'MUGALU', 1, 'CM89032101DZYJ', 'img/ids/Snapshot_20180417_2.JPG', 'M', 'Single', '1989-11-11', '(077) 382-3902', '', '', '', 'BUSEGA', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180417_2.JPG', '', '2018-04-17 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(942, 'Mr', 0, 'BFS00000942', 'FREDRICK', 'KAVUMA', '', 5, '3182', 'img/ids/Snapshot_20180417_3.JPG', 'M', 'Single', '1998-04-06', '(070) 035-9878', '', '', '', 'KITEBI', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180417_3.JPG', '', '2018-04-17 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(943, 'Mrs', 0, 'BFS00000943', 'SHAMIRAH', 'NANSUBUGA', '', 1, 'CM780', 'img/ids/Snapshot_20180417_5.JPG', 'F', 'Married', '1978-03-10', '(075) 548-6374', '', '', '', 'KASANGATI', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180417_5.JPG', '', '2018-04-17 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(944, 'Mr', 0, 'BFS00000944', 'DRAKE', 'BAKALAAMYE', '', 1, 'CM85069101MDTF', 'img/ids/Snapshot_20180423.JPG', 'M', 'Single', '1985-11-08', '(070) 013-5963', '(077) 359-1581', '', '', 'KIBUYE', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180423.JPG', '', '2018-04-23 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(945, 'Mr', 0, 'BFS00000945', 'MUCHWA', 'SSEBADDUKA', '', 1, 'CM94032109WXME', 'img/ids/Snapshot_20180423_1.JPG', 'M', 'Single', '1994-10-02', '(070) 149-2436', '', '', '', 'NASANA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180423_1.JPG', '', '2018-04-23 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(946, 'Mr', 0, 'BFS00000946', 'JAMES', 'MUWANGUZI', '', 5, 'UG777450', 'img/ids/Snapshot_20180423_2.JPG', 'M', 'Single', '1984-11-11', '(078) 797-6503', '', '', '', 'MUTUNDWE', 'FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180423_2.JPG', '', '2018-04-23 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(947, 'Mr', 0, 'BFS00000947', 'AHAMADU', 'LUBEGA', '', 1, 'CM800981058JA', 'img/ids/Snapshot_20180424_1.JPG', 'M', 'Single', '1980-01-03', '(070) 264-1718', '', '', '', 'KYENGERA', 'BUSINESSMAN', 0, 0, NULL, '', '', '2018-04-24 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(948, 'Mr', 0, 'BFS00000948', 'JOYCE', 'KIZZA', '', 1, 'CF55030100AK4E', 'img/ids/Snapshot_20180424.JPG', 'F', 'Married', '1955-09-11', '(070) 318-5097', '', '', '', 'NASANA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180424.JPG', '', '2018-04-24 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(949, 'Mr', 0, 'BFS00000949', 'STEVEN', 'KALEMA', '', 1, 'CM75098104352H', 'img/ids/Snapshot_20180425_2.JPG', 'M', 'Married', '1975-03-05', '(077) 287-7543', '', '', '', 'NABWERU', 'DRIVER', 0, 0, NULL, 'img/profiles/Snapshot_20180425_2.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(950, 'Mr', 0, 'BFS00000950', 'STEPHEN', 'LUWAGGA', '', 1, 'CM72052103Q8RL', 'img/ids/Snapshot_20180425_3.JPG', 'M', 'Married', '1972-09-07', '(077) 639-5627', '(075) 725-3822', '', 'GAYAZA', 'KITEZI', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180425_3.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(951, 'Mr', 0, 'BFS00000951', 'YUSUF', 'LUBOWA', '', 1, 'CM90024108HR2A', 'img/ids/Snapshot_20180425_1.JPG', 'M', 'Married', '1990-12-03', '(077) 228-3609', '', '', '', 'LUBYA', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180425_1.JPG', '', '2018-04-26 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(952, 'Mr', 0, 'BFS00000952', 'VINA', 'NANZIRI', '', 1, 'CF68091102APDA', 'img/ids/Snapshot_20180426.JPG', 'F', 'Married', '1968-09-10', '(070) 336-3651', '(078) 433-4553', '', '', 'NABWERU', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(953, 'Mrs', 0, 'BFS00000953', 'NURU', 'NANSUBUGA', '', 1, 'CF950', 'img/ids/Snapshot_20180426_2.JPG', 'F', 'Married', '1995-01-04', '(077) 087-4380', '(070) 464-7611', '', '', ' LWEZA B', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180426_2.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(954, 'Mrs', 0, 'BFS00000954', 'HELLEN', 'ASEKENYE', 'KAWALYA', 1, 'CF740391023XTD', 'img/ids/Snapshot_20180426_4.JPG', 'F', 'Married', '1974-05-12', '(075) 260-0092', '(078) 230-1590', '', '', 'NAGURU', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180426_4.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(955, 'Mrs', 0, 'BFS00000955', 'LILLAN', 'NYIMABASHEKA', '', 1, 'CF820', 'img/ids/Snapshot_20180426_5.JPG', 'F', 'Single', '1982-10-10', '(070) 421-2546', '', '', '', 'NDIKUTTAMANDA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180426_5.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(956, 'Mr', 0, 'BFS00000956', 'DAUDA', 'MUGERWA', '', 1, 'CM890', 'img/ids/Snapshot_20180426_6.JPG', 'M', 'Married', '1989-01-01', '(075) 551-4972', '', '', '', 'MASAJJA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180426_6.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(957, 'Mrs', 0, 'BFS00000957', 'IMACULATE', 'NALUKENGE', '', 1, 'CF80', 'img/ids/Snapshot_20180426_7.JPG', 'F', 'Married', '1980-04-09', '(070) 407-3828', '(078) 766-2113', '', '', 'NDIKUTTAMANDA', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180426_7.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(958, 'Mrs', 0, 'BFS00000958', 'GRACE', 'NAYIGA', '', 1, 'CF80', 'img/ids/Snapshot_20180426_8.JPG', 'F', 'Married', '1980-02-12', '(075) 200-8187', '(077) 200-8187', '', 'KIZIBA', 'GANGU', 'SELF EMPLOYED', 0, 0, NULL, '', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(959, 'Mr', 0, 'BFS00000959', 'IGNATIUS', 'LUKWAGO', '', 1, 'CM820', 'img/ids/Snapshot_20180426_9.JPG', 'M', 'Married', '1982-06-08', '(070) 396-2913', '', '', '', 'MAKINDYE', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180426_9.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(960, 'Mrs', 0, 'BFS00000960', 'NICHOLAS', 'MUWANGMA', '', 1, 'CM860', 'img/ids/Snapshot_20180426_10.JPG', 'M', 'Married', '1986-12-25', '(077) 467-0823', '(070) 167-0823', '', '', 'SALAAMA', 'SELF EMPLOYED', 0, 0, NULL, '', '', '2018-04-26 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(961, 'Mr', 0, 'BFS00000961', 'BALIKUDDEMBE ', 'MATOVU', 'JOSEPH', 1, 'CM860', 'img/ids/Snapshot_20180426_11.JPG', 'M', 'Married', '1986-06-09', '(070) 436-6878', '', '', '', 'MASANAFU', 'SELF EMPLOYED', 0, 0, NULL, 'img/profiles/Snapshot_20180426_11.JPG', '', '2018-04-26 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(962, 'Mr', 0, 'BFS00000962', 'STEVEN', 'MUKAMA', 'KYAKA', 5, '3516', 'img/ids/Snapshot_20180427.JPG', 'M', 'Married', '1976-08-06', '(075) 139-5282', '', '', '', 'MAKINDYE', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180427.JPG', '', '2018-04-27 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(963, 'Mr', 0, 'BFS00000963', 'WILSON', 'WAKOLI', '', 1, 'CM740821052YVD', 'img/ids/Snapshot_20180427_1.JPG', 'M', 'Married', '1974-10-02', '(075) 172-0745', '', '', '', 'SALAAMA', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180427_1.JPG', '', '2018-04-27 00:00:00', 0, 'MAKINDYE', '', '', '', '', 0),
(964, 'Mr', 0, 'BFS00000964', 'FRED', 'BAGUMA', '', 1, 'CM70006100UWTJ', 'img/ids/Snapshot_20180427_2.JPG', 'M', 'Married', '1970-10-06', '(075) 844-8434', '', '', '', 'MAKINDYE', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180427_2.JPG', '', '2018-04-27 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(965, 'Mr', 0, 'BFS00000965', 'ALOYSIUS', 'KASAKYA', 'LUMU', 1, 'CM53032104JOQE', 'img/ids/Snapshot_20180427_3.JPG', 'M', 'Married', '1953-03-07', '(077) 299-5220', '(075) 172-5325', '', '', 'KASANGATI', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180427_3.JPG', '', '2018-04-27 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(966, 'Mr', 0, 'BFS00000966', 'DEUS', 'SSEBULIME', 'EDRINE', 1, 'CM89052100NKVL', 'img/ids/Snapshot_20180427_4.JPG', 'M', 'Married', '1989-08-12', '(070) 129-6622', '', '', '', 'MUTUNDWE', 'SOCIAL WORKER', 0, 0, NULL, 'img/profiles/Snapshot_20180427_4.JPG', '', '2018-04-27 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(967, 'Mr', 0, 'BFS00000967', 'YASIN', 'LUSIIBA', '', 1, 'CM86030101NTHA', 'img/ids/Snapshot_20180502.JPG', 'M', 'Married', '1986-12-09', '(075) 772-3507', '', '', '', 'NATEETE', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180502.JPG', '', '2018-05-02 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(968, 'Mrs', 0, 'BFS00000968', 'RUTH', 'MBABAZI ', 'AKIIKI', 1, 'CM7401210243HC', '', 'F', 'Single', '1964-10-03', '(071) 254-6783', '', '', '', 'KAMPALA', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-05-03 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(969, 'Mr', 0, 'BFS00000969', 'HERBERT', 'SSEKYANZI', '', 1, 'CM74036104CJ3J', 'img/ids/Snapshot_20180504_2.JPG', 'M', 'Married', '1974-08-06', '(077) 238-1144', '', '', '', 'NSANGI', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180504_2.JPG', '', '2018-05-04 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(970, 'Mrs', 0, 'BFS00000970', 'NABIILA', 'NAKALEMA', '', 1, 'CF9302310C17FF', 'img/ids/Snapshot_20180504_1.JPG', 'F', 'Single', '1993-03-07', '(070) 612-8590', '', '', '', 'NATEETE', 'HARI DRESSER', 0, 0, NULL, 'img/profiles/Snapshot_20180504_1.JPG', '', '2018-05-04 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(971, 'Mrs', 0, 'BFS00000971', 'KEDDRETH', 'KEMIREMBE', '', 1, 'CF720091012GVD', 'img/ids/Snapshot_20180504.JPG', 'M', 'Married', '1972-02-04', '(070) 111-0651', '', '', '', 'NTINDA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180504.JPG', '', '2018-05-04 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(972, 'Mrs', 0, 'BFS00000972', 'MBABAZI', 'RUTH', 'AKIIKI', 1, 'CF7401210243HC', 'img/ids/Snapshot_20180314_3.JPG', 'F', 'Married', '1964-10-03', '(071) 254-6783', '', '', '', 'KAMPALA', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-05-04 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(973, 'Mrs', 0, 'BFS00000973', 'HOPE', 'TUGUMISIRIZE', '', 1, 'CF6400910KX7CL', 'img/ids/Snapshot_20180504_3.JPG', 'F', 'Married', '1964-03-12', '(077) 443-5083', '', '', '', 'NTINDA', 'BUSINESSWOMAN/FARMER', 0, 0, NULL, 'img/profiles/Snapshot_20180504_3.JPG', '', '2018-05-04 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(974, 'Mrs', 0, 'BFS00000974', 'HAMIDAH', 'NASSOZI', '', 1, 'CF9103210C70IJA', 'img/ids/Snapshot_20180504_4.JPG', 'F', 'Married', '1991-07-08', '(077) 591-0191', '', '', '', 'NTINDA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180504_4.JPG', '', '2018-05-04 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(975, 'Mrs', 0, 'BFS00000975', 'VIOLA', 'NAMBI', '', 1, 'CF63032100FE9K', '', 'F', 'Single', '1986-06-10', '(070) 642-8002', '', '', '', 'KAMPALA', 'DEPUTY HEAD TEACHER', 0, 0, NULL, '', '', '2018-05-09 00:00:00', 0, 'KAMPALA', '', '', '', '', 0),
(976, 'Mr', 0, 'BFS00000976', 'GODFREY', 'KASASA', '', 1, 'CF7505210CM3VE', '', 'M', 'Single', '1971-02-10', '(078) 256-7894', '', '', '', 'KAMPALA', 'BUSINESS  MAN', 0, 0, NULL, '', '', '2018-05-09 00:00:00', 0, '', '', '', '', '', 0),
(977, 'Mr', 0, 'BFS00000977', 'MININSA', 'NALUGWA', 'KIZZA', 1, 'CF67099103KL3D', 'img/ids/Snapshot_20180510.JPG', 'F', 'Married', '1967-01-01', '(070) 618-3975', '(077) 260-7133', '', '', 'BUSABALA', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180510.JPG', '', '2018-05-10 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(978, 'Mrs', 0, 'BFS00000978', 'MARIAM', 'NAMUSISI', '', 5, '1316', 'img/ids/Snapshot_20180510_1.JPG', 'F', 'Married', '1976-08-01', '(070) 215-4706', '', '', '', 'KATWE', 'BUSINESS WOMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180510_1.JPG', '', '2018-05-10 00:00:00', 0, 'WAKISO', '', '', '', '', 819),
(979, 'Mrs', 0, 'BFS00000979', 'HARRIET', 'NAMULI', '', 1, 'CF72023101GA8J', 'img/ids/Snapshot_20180510_2.JPG', 'F', 'Married', '1972-09-09', '(070) 526-4087', '', '', '', 'KIBILI', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-05-10 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(980, 'Mr', 0, 'BFS00000980', 'BASHIR', 'SSENGOOBA', 'KABANDA', 1, 'CM85098101N07H', 'img/ids/Snapshot_20180510_3.JPG', 'M', 'Single', '1985-08-03', '(070) 289-9187', '', '', '', 'SALAAMA', 'WELDER', 0, 0, NULL, '', '', '2018-05-10 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(981, 'Mrs', 0, 'BFS00000981', 'CHRISTINE', 'NABAWESI', '', 1, 'CF9106910455VD', 'img/ids/Snapshot_20180510_4.JPG', 'F', 'Single', '1991-01-01', '(078) 868-3915', '', '', '', 'NABWERU', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-05-10 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(982, 'Mrs', 0, 'BFS00000982', 'HANIFAH', 'NABASITU', '', 1, 'CF880231088XJFK', 'img/ids/Snapshot_20180510_5.JPG', 'F', 'Married', '1988-08-10', '(075) 323-9797', '(078) 713-2186', '', '', 'NABWERU', 'BUSINESS WOMAN', 0, 0, NULL, '', '', '2018-05-10 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(983, 'Mr', 0, 'BFS00000983', 'TONNY', 'SSENKOOTO', '', 1, 'CM852100102GFLD', 'img/ids/Snapshot_20180511.JPG', 'M', 'Married', '1982-06-08', '(075) 535-8377', '', '', '', 'SSENGUKKU', 'BUSINESSMAN', 0, 0, NULL, 'img/profiles/Snapshot_20180511.JPG', '', '2018-05-11 00:00:00', 0, 'WAKISO', '', '', '', '', 0),
(984, 'Mr', 1, 'SBFS00000984', 'Michael', 'kalibbala', '', 1, 'CM76036100CEMC', '', 'M', '', '1983-05-03', '(071) 257-5689', '', '', '', 'KAMPALA', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `persontype`
--

CREATE TABLE `persontype` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` text,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `persontype`
--

INSERT INTO `persontype` (`id`, `name`, `description`, `active`) VALUES
(1, 'member ', 'Person as Member ', 1),
(2, 'staff', 'Person as staff', 1);

-- --------------------------------------------------------

--
-- Table structure for table `person_address`
--

CREATE TABLE `person_address` (
  `id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `address1` varchar(100) NOT NULL,
  `address2` varchar(100) NOT NULL,
  `address_type` tinyint(4) NOT NULL,
  `parish_id` int(11) NOT NULL,
  `village` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `person_business`
--

CREATE TABLE `person_business` (
  `id` int(11) NOT NULL,
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
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person_business`
--

INSERT INTO `person_business` (`id`, `personId`, `businessName`, `natureOfBusiness`, `businessLocation`, `numberOfEmployees`, `businessWorth`, `ursbNumber`, `certificateOfIncorporation`, `dateAdded`, `addedBy`, `dateModified`) VALUES
(1, 747, '', '', '', 0, '0.00', '', '', 1511263636, 0, '2017-11-21 11:27:16'),
(2, 749, '', '', '', 0, '0.00', '', '', 1511330087, 0, '2017-11-22 05:54:47'),
(3, 773, '', '', '', 0, '0.00', '', '', 1511429495, 0, '2017-11-23 09:31:35'),
(4, 774, '', '', '', 0, '0.00', '', '', 1511429535, 0, '2017-11-23 09:32:15'),
(6, 777, '', 'RENTALS', 'KASUBI', 0, '0.00', '', '', 1511445818, 0, '2017-11-23 14:03:39'),
(7, 781, '', '', '', 0, '0.00', '', '', 1511957952, 0, '2017-11-29 12:19:12'),
(8, 782, '', '', '', 0, '0.00', '', '', 1511958598, 0, '2017-11-29 12:29:58'),
(9, 783, '', '', '', 0, '0.00', '', '', 1511960378, 0, '2017-11-29 12:59:38'),
(10, 784, '', '', '', 0, '0.00', '', '', 1512452107, 0, '2017-12-05 05:35:07'),
(11, 785, '', '', '', 0, '0.00', '', '', 1513319535, 0, '2017-12-15 06:32:15'),
(12, 786, '', '', '', 0, '0.00', '', '', 1513576983, 0, '2017-12-18 06:03:03'),
(13, 787, '', '', '', 0, '0.00', '', '', 1513583540, 0, '2017-12-18 07:52:20'),
(14, 788, '', '', '', 0, '0.00', '', '', 1516784514, 0, '2018-01-24 09:01:54'),
(15, 792, '', '', '', 0, '0.00', '', '', 1516789340, 0, '2018-01-24 10:22:20'),
(16, 775, 'rentals', '', 'namuwongo', 1, '1700000.00', '', '', 1516798648, 0, '2018-01-24 12:57:28'),
(17, 795, '', 'RENTAL HOUSES', 'NANKULABYE', 0, '0.00', '', '', 1516867254, 0, '2018-01-25 08:00:54'),
(18, 796, '', '', '', 0, '0.00', '', '', 1516868460, 0, '2018-01-25 08:21:00'),
(19, 797, '', '', '', 0, '0.00', '', '', 1516869574, 0, '2018-01-25 08:39:34'),
(22, 410, 'bar', '', 'zana', 1, '2.00', '', '', 1517049870, 0, '2018-01-27 10:44:30'),
(23, 801, '', '', '', 0, '0.00', '', '', 1517833107, 0, '2018-02-05 12:18:27'),
(24, 802, '', '', '', 0, '0.00', '', '', 1517836971, 0, '2018-02-05 13:22:51'),
(25, 803, '', '', '', 0, '0.00', '', '', 1517843268, 0, '2018-02-05 15:07:48'),
(26, 804, '', '', '', 0, '0.00', '', '', 1517844262, 0, '2018-02-05 15:24:22'),
(27, 805, '', 'NATEETE RENTALS', 'NATEETE', 0, '40.00', '', '', 1517985935, 0, '2018-02-07 06:45:35'),
(28, 806, '', '', '', 0, '0.00', '', '', 1518105069, 0, '2018-02-08 15:51:09'),
(29, 807, '', '', '', 0, '0.00', '', '', 1518157148, 0, '2018-02-09 06:19:09'),
(30, 808, '', '', '', 0, '0.00', '', '', 1518171213, 0, '2018-02-09 10:13:33'),
(31, 809, '', '', '', 0, '0.00', '', '', 1518412770, 0, '2018-02-12 05:19:30'),
(32, 810, '', '', '', 0, '0.00', '', '', 1518414525, 0, '2018-02-12 05:48:45'),
(33, 811, '', '', '', 0, '0.00', '', '', 1518423759, 0, '2018-02-12 08:22:39'),
(34, 812, '', '', '', 0, '0.00', '', '', 1518505590, 0, '2018-02-13 07:06:30'),
(36, 813, '', '', '', 0, '0.00', '', '', 1518587844, 737, '2018-02-14 05:57:24'),
(37, 814, '', '', '', 0, '0.00', '', '', 1518674952, 0, '2018-02-15 06:09:12'),
(38, 815, '', '', '', 0, '0.00', '', '', 1518679282, 0, '2018-02-15 07:21:23'),
(39, 816, '', 'RETAIL SHOP', 'MENGO', 1, '1.00', '', '', 1519889111, 0, '2018-03-01 07:25:11'),
(41, 817, '', '', '', 0, '0.00', '', '', 1519971889, 737, '2018-03-02 06:24:49'),
(42, 818, '', '', '', 0, '0.00', '', '', 1519974022, 0, '2018-03-02 07:00:22'),
(43, 820, '', '', '', 0, '0.00', '', '', 1520240251, 0, '2018-03-05 08:57:31'),
(44, 821, '', '', '', 0, '0.00', '', '', 1520240592, 0, '2018-03-05 09:03:12'),
(45, 822, '', '', '', 0, '0.00', '', '', 1520242515, 0, '2018-03-05 09:35:15'),
(46, 823, '', '', '', 0, '0.00', '', '', 1520327345, 0, '2018-03-06 09:09:05'),
(47, 824, '', '', '', 0, '0.00', '', '', 1520328668, 0, '2018-03-06 09:31:09'),
(48, 825, '', '', '', 0, '0.00', '', '', 1520329463, 0, '2018-03-06 09:44:23'),
(49, 826, '', '', '', 0, '0.00', '', '', 1520329815, 0, '2018-03-06 09:50:15'),
(50, 827, '', '', '', 0, '0.00', '', '', 1520330301, 0, '2018-03-06 09:58:21'),
(51, 828, '', '', '', 0, '0.00', '', '', 1520330495, 0, '2018-03-06 10:01:35'),
(52, 798, 'rentals', '', 'mbuya', 1, '15000000.00', '', '', 1520337383, 819, '2018-03-06 11:56:23'),
(53, 829, '', '', '', 0, '0.00', '', '', 1520337703, 0, '2018-03-06 12:01:43'),
(54, 102, 'Rental Houses', '', 'Makandwa(Kitende', 1, '400000.00', '', '', 1520338838, 0, '2018-03-06 12:20:38'),
(55, 830, '', '', '', 0, '0.00', '', '', 1520428038, 0, '2018-03-07 13:07:18'),
(56, 831, '', '', '', 0, '0.00', '', '', 1520428200, 0, '2018-03-07 13:10:00'),
(57, 832, '', '', '', 0, '0.00', '', '', 1521012783, 0, '2018-03-14 07:33:03'),
(58, 833, '', '', '', 0, '0.00', '', '', 1521020417, 0, '2018-03-14 09:40:17'),
(59, 834, '', '', '', 0, '0.00', '', '', 1521020747, 0, '2018-03-14 09:45:47'),
(60, 835, '', '', '', 0, '0.00', '', '', 1521035724, 0, '2018-03-14 13:55:24'),
(61, 836, '', '', '', 0, '0.00', '', '', 1521102874, 0, '2018-03-15 08:34:34'),
(62, 837, '', '', '', 0, '0.00', '', '', 1521104173, 0, '2018-03-15 08:56:13'),
(63, 838, '', '', '', 0, '0.00', '', '', 1521104667, 0, '2018-03-15 09:04:27'),
(64, 839, '', '', '', 0, '0.00', '', '', 1521106422, 0, '2018-03-15 09:33:42'),
(66, 840, '', '', '', 0, '0.00', '', '', 1521108093, 819, '2018-03-15 10:01:33'),
(67, 841, '', '', '', 0, '0.00', '', '', 1521109510, 0, '2018-03-15 10:25:10'),
(68, 842, '', '', '', 0, '0.00', '', '', 1521111669, 0, '2018-03-15 11:01:09'),
(69, 843, '', '', '', 0, '0.00', '', '', 1521111954, 0, '2018-03-15 11:05:54'),
(70, 844, '', '', '', 0, '0.00', '', '', 1521179376, 0, '2018-03-16 05:49:36'),
(71, 845, '', '', '', 0, '0.00', '', '', 1521450382, 0, '2018-03-19 09:06:22'),
(72, 846, '', '', '', 0, '0.00', '', '', 1521450683, 0, '2018-03-19 09:11:23'),
(73, 847, '', '', '', 0, '0.00', '', '', 1521450892, 0, '2018-03-19 09:14:52'),
(74, 848, '', '', '', 0, '0.00', '', '', 1521451126, 0, '2018-03-19 09:18:46'),
(75, 849, '', '', '', 0, '0.00', '', '', 1521451429, 0, '2018-03-19 09:23:49'),
(76, 850, '', '', '', 0, '0.00', '', '', 1521452299, 0, '2018-03-19 09:38:19'),
(79, 851, '', '', '', 0, '0.00', '', '', 1521452808, 819, '2018-03-19 09:46:48'),
(80, 852, '', '', '', 0, '0.00', '', '', 1521452991, 0, '2018-03-19 09:49:51'),
(81, 853, '', '', '', 0, '0.00', '', '', 1521453392, 0, '2018-03-19 09:56:32'),
(82, 854, '', '', '', 0, '0.00', '', '', 1521453863, 0, '2018-03-19 10:04:23'),
(83, 855, '', '', '', 0, '0.00', '', '', 1521456291, 0, '2018-03-19 10:44:51'),
(84, 856, '', '', '', 0, '0.00', '', '', 1521456544, 0, '2018-03-19 10:49:04'),
(85, 857, '', '', '', 0, '0.00', '', '', 1521459019, 0, '2018-03-19 11:30:19'),
(86, 858, '', '', '', 0, '0.00', '', '', 1521459637, 0, '2018-03-19 11:40:37'),
(87, 859, '', '', '', 0, '0.00', '', '', 1521459970, 0, '2018-03-19 11:46:10'),
(88, 860, '', '', '', 0, '0.00', '', '', 1521460860, 0, '2018-03-19 12:01:00'),
(89, 861, '', '', '', 0, '0.00', '', '', 1521461041, 0, '2018-03-19 12:04:01'),
(90, 862, '', '', '', 0, '0.00', '', '', 1521463354, 0, '2018-03-19 12:42:34'),
(91, 863, '', '', '', 0, '0.00', '', '', 1521463636, 0, '2018-03-19 12:47:16'),
(92, 864, '', '', '', 0, '0.00', '', '', 1521463928, 0, '2018-03-19 12:52:08'),
(93, 865, '', '', '', 0, '0.00', '', '', 1521464198, 0, '2018-03-19 12:56:38'),
(94, 866, '', '', '', 0, '0.00', '', '', 1521464724, 0, '2018-03-19 13:05:24'),
(95, 867, '', '', '', 0, '0.00', '', '', 1521464984, 0, '2018-03-19 13:09:44'),
(96, 868, '', '', '', 0, '0.00', '', '', 1521465208, 0, '2018-03-19 13:13:28'),
(97, 869, '', '', '', 0, '0.00', '', '', 1521465401, 0, '2018-03-19 13:16:41'),
(98, 870, '', '', '', 0, '0.00', '', '', 1521465714, 0, '2018-03-19 13:21:54'),
(99, 871, '', '', '', 0, '0.00', '', '', 1521465970, 0, '2018-03-19 13:26:10'),
(100, 872, '', '', '', 0, '0.00', '', '', 1521467167, 0, '2018-03-19 13:46:07'),
(101, 873, '', '', '', 0, '0.00', '', '', 1521468494, 0, '2018-03-19 14:08:14'),
(102, 874, '', '', '', 0, '0.00', '', '', 1521524330, 0, '2018-03-20 05:38:50'),
(103, 875, '', '', '', 0, '0.00', '', '', 1521524787, 0, '2018-03-20 05:46:27'),
(104, 876, '', '', '', 0, '0.00', '', '', 1521525165, 0, '2018-03-20 05:52:45'),
(105, 877, '', '', '', 0, '0.00', '', '', 1521525516, 0, '2018-03-20 05:58:36'),
(106, 878, '', '', '', 0, '0.00', '', '', 1521525788, 0, '2018-03-20 06:03:08'),
(107, 879, '', '', '', 0, '0.00', '', '', 1521526189, 0, '2018-03-20 06:09:49'),
(108, 880, '', '', '', 0, '0.00', '', '', 1521526486, 0, '2018-03-20 06:14:46'),
(109, 881, '', '', '', 0, '0.00', '', '', 1521528650, 0, '2018-03-20 06:50:50'),
(110, 882, '', '', '', 0, '0.00', '', '', 1521530877, 0, '2018-03-20 07:27:57'),
(111, 883, '', '', '', 0, '0.00', '', '', 1521536447, 0, '2018-03-20 09:00:47'),
(112, 884, '', '', '', 0, '0.00', '', '', 1521536849, 0, '2018-03-20 09:07:29'),
(113, 885, '', '', '', 0, '0.00', '', '', 1521537290, 0, '2018-03-20 09:14:50'),
(114, 886, '', '', '', 0, '0.00', '', '', 1521537671, 0, '2018-03-20 09:21:11'),
(115, 887, '', '', '', 0, '0.00', '', '', 1521543495, 0, '2018-03-20 10:58:15'),
(116, 888, '', '', '', 0, '0.00', '', '', 1521543713, 0, '2018-03-20 11:01:53'),
(117, 889, '', '', '', 0, '0.00', '', '', 1521628062, 0, '2018-03-21 10:27:42'),
(118, 890, '', '', '', 0, '0.00', '', '', 1521628520, 0, '2018-03-21 10:35:20'),
(119, 891, '', '', '', 0, '0.00', '', '', 1521632177, 0, '2018-03-21 11:36:17'),
(120, 892, '', '', '', 0, '0.00', '', '', 1521632417, 0, '2018-03-21 11:40:17'),
(121, 893, '', '', '', 0, '0.00', '', '', 1521632805, 0, '2018-03-21 11:46:45'),
(122, 894, '', '', '', 0, '0.00', '', '', 1521633152, 0, '2018-03-21 11:52:32'),
(123, 895, '', '', '', 0, '0.00', '', '', 1521633557, 0, '2018-03-21 11:59:17'),
(124, 896, '', '', '', 0, '0.00', '', '', 1521633966, 0, '2018-03-21 12:06:06'),
(125, 897, '', '', '', 0, '0.00', '', '', 1521634216, 0, '2018-03-21 12:10:16'),
(126, 898, '', '', '', 0, '0.00', '', '', 1521634455, 0, '2018-03-21 12:14:15'),
(127, 899, '', '', '', 0, '0.00', '', '', 1521635544, 0, '2018-03-21 12:32:24'),
(128, 900, '', '', '', 0, '0.00', '', '', 1521635798, 0, '2018-03-21 12:36:38'),
(129, 901, '', '', '', 0, '0.00', '', '', 1521636204, 0, '2018-03-21 12:43:24'),
(130, 902, '', '', '', 0, '0.00', '', '', 1521637062, 0, '2018-03-21 12:57:42'),
(131, 23, 'Ssengendo robert as per the trading license', '', 'Kawempe ku taano', 0, '6.00', '', '', 1521648931, 0, '2018-03-21 16:15:31'),
(132, 903, '', '', '', 0, '0.00', '', '', 1521718695, 0, '2018-03-22 11:38:15'),
(133, 904, '', '', '', 0, '0.00', '', '', 1521723003, 0, '2018-03-22 12:50:03'),
(134, 905, '', '', '', 0, '0.00', '', '', 1521791093, 0, '2018-03-23 07:44:53'),
(136, 906, '', '', '', 0, '0.00', '', '', 1521792077, 819, '2018-03-23 08:01:17'),
(137, 907, '', '', '', 0, '0.00', '', '', 1521800059, 0, '2018-03-23 10:14:19'),
(138, 908, '', '', '', 0, '0.00', '', '', 1521803643, 0, '2018-03-23 11:14:03'),
(141, 909, 'boda boda', '', 'nasser rd muza stage', 1, '3.00', '', '', 1523518335, 819, '2018-04-12 07:32:15'),
(142, 910, '', '', '', 0, '0.00', '', '', 1523520585, 0, '2018-04-12 08:09:45'),
(143, 911, '', '', '', 0, '0.00', '', '', 1523521545, 0, '2018-04-12 08:25:45'),
(144, 912, '', '', '', 0, '0.00', '', '', 1523521769, 0, '2018-04-12 08:29:29'),
(145, 913, '', '', '', 0, '0.00', '', '', 1523522158, 0, '2018-04-12 08:35:58'),
(146, 914, '', '', '', 0, '0.00', '', '', 1523522954, 0, '2018-04-12 08:49:14'),
(147, 915, '', '', '', 0, '0.00', '', '', 1523523227, 0, '2018-04-12 08:53:47'),
(149, 917, '', '', '', 0, '0.00', '', '', 1523524075, 0, '2018-04-12 09:07:55'),
(150, 918, '', '', '', 0, '0.00', '', '', 1523524450, 0, '2018-04-12 09:14:10'),
(151, 919, '', '', '', 0, '0.00', '', '', 1523524879, 0, '2018-04-12 09:21:19'),
(152, 920, '', '', '', 0, '0.00', '', '', 1523525966, 0, '2018-04-12 09:39:26'),
(153, 921, '', '', '', 0, '0.00', '', '', 1523527242, 0, '2018-04-12 10:00:42'),
(154, 922, '', '', '', 0, '0.00', '', '', 1523527505, 0, '2018-04-12 10:05:05'),
(155, 923, '', '', '', 0, '0.00', '', '', 1523527726, 0, '2018-04-12 10:08:46'),
(156, 924, '', '', '', 0, '0.00', '', '', 1523528083, 0, '2018-04-12 10:14:43'),
(157, 925, '', '', '', 0, '0.00', '', '', 1523528700, 0, '2018-04-12 10:25:00'),
(158, 926, '', '', '', 0, '0.00', '', '', 1523529597, 0, '2018-04-12 10:39:57'),
(159, 927, '', '', '', 0, '0.00', '', '', 1523531368, 0, '2018-04-12 11:09:28'),
(160, 928, '', '', '', 0, '0.00', '', '', 1523531803, 0, '2018-04-12 11:16:43'),
(161, 929, '', '', '', 0, '0.00', '', '', 1523532155, 0, '2018-04-12 11:22:35'),
(162, 930, '', '', '', 0, '0.00', '', '', 1523532410, 0, '2018-04-12 11:26:50'),
(163, 931, '', '', '', 0, '0.00', '', '', 1523535456, 0, '2018-04-12 12:17:36'),
(164, 932, '', '', '', 0, '0.00', '', '', 1523535754, 0, '2018-04-12 12:22:37'),
(165, 933, '', '', '', 0, '0.00', '', '', 1523536837, 0, '2018-04-12 12:40:37'),
(166, 934, '', '', '', 0, '0.00', '', '', 1523537809, 0, '2018-04-12 12:56:49'),
(167, 935, '', '', '', 0, '0.00', '', '', 1523538065, 0, '2018-04-12 13:01:06'),
(168, 936, '', '', '', 0, '0.00', '', '', 1523538391, 0, '2018-04-12 13:06:31'),
(169, 937, '', '', '', 0, '0.00', '', '', 1523539061, 0, '2018-04-12 13:17:41'),
(170, 938, '', '', '', 0, '0.00', '', '', 1523539380, 0, '2018-04-12 13:23:00'),
(171, 939, '', '', '', 0, '0.00', '', '', 1523960546, 0, '2018-04-17 10:22:26'),
(172, 940, '', '', '', 0, '0.00', '', '', 1523960750, 0, '2018-04-17 10:25:50'),
(173, 941, '', '', '', 0, '0.00', '', '', 1523961617, 0, '2018-04-17 10:40:18'),
(174, 942, '', '', '', 0, '0.00', '', '', 1523961911, 0, '2018-04-17 10:45:11'),
(175, 943, '', '', '', 0, '0.00', '', '', 1523962456, 0, '2018-04-17 10:54:16'),
(176, 944, '', '', '', 0, '0.00', '', '', 1524473061, 0, '2018-04-23 08:44:21'),
(177, 945, '', '', '', 0, '0.00', '', '', 1524495241, 0, '2018-04-23 14:54:01'),
(178, 946, '', '', '', 0, '0.00', '', '', 1524495436, 0, '2018-04-23 14:57:16'),
(179, 947, '', '', '', 0, '0.00', '', '', 1524569953, 0, '2018-04-24 11:39:13'),
(180, 948, '', '', '', 0, '0.00', '', '', 1524570297, 0, '2018-04-24 11:44:57'),
(181, 916, '', '', '', 0, '0.00', '', '', 1524648269, 819, '2018-04-25 09:24:29'),
(182, 949, '', '', '', 0, '0.00', '', '', 1524726672, 0, '2018-04-26 07:11:12'),
(183, 950, '', '', '', 0, '0.00', '', '', 1524727046, 0, '2018-04-26 07:17:26'),
(184, 951, '', '', '', 0, '0.00', '', '', 1524727299, 0, '2018-04-26 07:21:39'),
(185, 952, '', '', '', 0, '0.00', '', '', 1524738479, 0, '2018-04-26 10:27:59'),
(186, 953, '', '', '', 0, '0.00', '', '', 1524739369, 0, '2018-04-26 10:42:49'),
(187, 954, '', '', '', 0, '0.00', '', '', 1524740324, 0, '2018-04-26 10:58:44'),
(188, 955, '', '', '', 0, '0.00', '', '', 1524740791, 0, '2018-04-26 11:06:31'),
(189, 956, '', '', '', 0, '0.00', '', '', 1524741071, 0, '2018-04-26 11:11:11'),
(190, 957, '', '', '', 0, '0.00', '', '', 1524741415, 0, '2018-04-26 11:16:55'),
(191, 958, '', '', '', 0, '0.00', '', '', 1524741779, 0, '2018-04-26 11:22:59'),
(192, 959, '', '', '', 0, '0.00', '', '', 1524742107, 0, '2018-04-26 11:28:27'),
(193, 960, '', '', '', 0, '0.00', '', '', 1524742593, 0, '2018-04-26 11:36:33'),
(194, 961, '', '', '', 0, '0.00', '', '', 1524743121, 0, '2018-04-26 11:45:21'),
(195, 962, '', '', '', 0, '0.00', '', '', 1524825708, 0, '2018-04-27 10:41:48'),
(196, 963, '', '', '', 0, '0.00', '', '', 1524828205, 0, '2018-04-27 11:23:25'),
(197, 964, '', '', '', 0, '0.00', '', '', 1524828428, 0, '2018-04-27 11:27:08'),
(198, 965, '', '', '', 0, '0.00', '', '', 1524828762, 0, '2018-04-27 11:32:43'),
(199, 966, '', '', '', 0, '0.00', '', '', 1524828959, 0, '2018-04-27 11:35:59'),
(200, 967, '', '', '', 0, '0.00', '', '', 1525243394, 0, '2018-05-02 06:43:15'),
(201, 968, '', '', '', 0, '0.00', '', '', 1525363171, 0, '2018-05-03 15:59:31'),
(202, 969, '', '', '', 0, '0.00', '', '', 1525415725, 0, '2018-05-04 06:35:25'),
(203, 970, '', '', '', 0, '0.00', '', '', 1525416232, 0, '2018-05-04 06:43:52'),
(204, 971, '', '', '', 0, '0.00', '', '', 1525416588, 0, '2018-05-04 06:49:48'),
(205, 972, '', '', '', 0, '0.00', '', '', 1525417036, 0, '2018-05-04 06:57:17'),
(206, 973, '', '', '', 0, '0.00', '', '', 1525423253, 0, '2018-05-04 08:40:53'),
(207, 974, '', '', '', 0, '0.00', '', '', 1525424041, 0, '2018-05-04 08:54:01'),
(208, 975, '', '', '', 0, '0.00', '', '', 1525880873, 0, '2018-05-09 15:47:53'),
(209, 976, '', '', '', 0, '0.00', '', '', 1525887178, 0, '2018-05-09 17:32:58'),
(210, 977, '', '', '', 0, '0.00', '', '', 1525949775, 0, '2018-05-10 10:56:15'),
(212, 978, '', '', '', 0, '0.00', '', '', 1525950292, 819, '2018-05-10 11:04:52'),
(213, 979, '', '', '', 0, '0.00', '', '', 1525950454, 0, '2018-05-10 11:07:34'),
(214, 980, '', '', '', 0, '0.00', '', '', 1525950772, 0, '2018-05-10 11:12:52'),
(215, 981, '', '', '', 0, '0.00', '', '', 1525951784, 0, '2018-05-10 11:29:44'),
(216, 982, '', '', '', 0, '0.00', '', '', 1525952053, 0, '2018-05-10 11:34:13'),
(217, 983, '', '', '', 0, '0.00', '', '', 1526022561, 0, '2018-05-11 07:09:21');

-- --------------------------------------------------------

--
-- Table structure for table `person_employment`
--

CREATE TABLE `person_employment` (
  `id` int(11) NOT NULL,
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
  `modifiedBy` int(11) NOT NULL COMMENT 'ID for user modifying the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person_employment`
--

INSERT INTO `person_employment` (`id`, `personId`, `employer`, `years_of_employment`, `nature_of_employment`, `startDate`, `endDate`, `monthlySalary`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 747, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-21 11:27:16', 0),
(2, 749, 'Kabojja Junior School', 10, 'Parmanent', NULL, NULL, '634.00', 0, 0, '2017-11-22 05:54:47', 0),
(3, 750, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-22 06:24:46', 0),
(4, 773, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-23 09:31:35', 0),
(5, 774, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-23 09:32:15', 0),
(6, 775, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-23 10:46:54', 0),
(7, 777, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-23 14:03:39', 0),
(8, 780, 'Buganda Land Board', 10, 'Contract', NULL, NULL, '2.00', 0, 0, '2017-11-29 11:56:46', 0),
(9, 781, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-29 12:19:12', 0),
(10, 782, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-29 12:29:58', 0),
(11, 783, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-11-29 12:59:38', 0),
(12, 784, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-12-05 05:35:07', 0),
(13, 785, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-12-15 06:32:15', 0),
(14, 786, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-12-18 06:03:03', 0),
(15, 787, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-12-18 07:52:20', 0),
(16, 788, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-01-24 09:01:54', 0),
(17, 792, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-01-24 10:22:20', 0),
(18, 795, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-01-25 08:00:54', 0),
(19, 796, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-01-25 08:21:00', 0),
(20, 797, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-01-25 08:39:34', 0),
(22, 801, 'BLB', 3, 'CONTRACT', NULL, NULL, '0.00', 0, 0, '2018-02-05 12:18:27', 0),
(23, 802, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-05 13:22:51', 0),
(24, 803, 'CBS', 12, 'SENIOR PRESENTER', NULL, NULL, '0.00', 0, 0, '2018-02-05 15:07:48', 0),
(25, 804, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-05 15:24:22', 0),
(26, 805, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-07 06:45:35', 0),
(27, 806, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-08 15:51:09', 0),
(28, 807, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-09 06:19:09', 0),
(29, 808, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-09 10:13:33', 0),
(30, 809, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-12 05:19:30', 0),
(31, 810, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-12 05:48:45', 0),
(32, 811, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-12 08:22:39', 0),
(33, 812, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-13 07:06:30', 0),
(35, 813, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-14 05:57:24', 0),
(36, 814, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-15 06:09:12', 0),
(37, 815, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-02-15 07:21:23', 0),
(38, 816, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-01 07:25:11', 0),
(40, 817, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-02 06:24:49', 0),
(41, 818, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-02 07:00:22', 0),
(42, 820, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-05 08:57:31', 0),
(43, 821, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-05 09:03:12', 0),
(44, 822, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-05 09:35:15', 0),
(45, 823, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 09:09:05', 0),
(46, 824, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 09:31:09', 0),
(47, 825, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 09:44:23', 0),
(48, 826, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 09:50:15', 0),
(49, 827, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 09:58:21', 0),
(50, 828, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 10:01:35', 0),
(51, 798, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 11:56:23', 0),
(52, 829, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-06 12:01:43', 0),
(53, 830, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-07 13:07:18', 0),
(54, 831, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-07 13:10:00', 0),
(55, 832, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-14 07:33:03', 0),
(56, 833, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-14 09:40:17', 0),
(57, 834, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-14 09:45:47', 0),
(58, 835, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-14 13:55:24', 0),
(59, 836, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 08:34:34', 0),
(60, 837, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 08:56:13', 0),
(61, 838, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 09:04:27', 0),
(62, 839, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 09:33:42', 0),
(64, 840, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 10:01:33', 0),
(65, 841, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 10:25:10', 0),
(66, 842, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 11:01:09', 0),
(67, 843, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-15 11:05:54', 0),
(68, 844, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-16 05:49:36', 0),
(69, 845, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:06:22', 0),
(70, 846, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:11:23', 0),
(71, 847, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:14:52', 0),
(72, 848, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:18:46', 0),
(73, 849, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:23:49', 0),
(74, 850, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:38:19', 0),
(77, 851, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:46:48', 0),
(78, 852, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:49:51', 0),
(79, 853, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 09:56:32', 0),
(80, 854, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 10:04:23', 0),
(81, 855, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 10:44:51', 0),
(82, 856, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 10:49:04', 0),
(83, 857, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 11:30:19', 0),
(84, 858, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 11:40:37', 0),
(85, 859, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 11:46:10', 0),
(86, 860, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 12:01:00', 0),
(87, 861, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 12:04:01', 0),
(88, 862, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 12:42:34', 0),
(89, 863, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 12:47:16', 0),
(90, 864, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 12:52:08', 0),
(91, 865, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 12:56:38', 0),
(92, 866, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:05:24', 0),
(93, 867, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:09:44', 0),
(94, 868, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:13:28', 0),
(95, 869, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:16:41', 0),
(96, 870, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:21:54', 0),
(97, 871, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:26:10', 0),
(98, 872, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 13:46:07', 0),
(99, 873, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-19 14:08:14', 0),
(100, 874, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 05:38:50', 0),
(101, 875, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 05:46:27', 0),
(102, 876, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 05:52:45', 0),
(103, 877, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 05:58:36', 0),
(104, 878, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 06:03:08', 0),
(105, 879, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 06:09:49', 0),
(106, 880, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 06:14:46', 0),
(107, 881, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 06:50:50', 0),
(108, 882, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 07:27:57', 0),
(109, 883, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 09:00:47', 0),
(110, 884, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 09:07:29', 0),
(111, 885, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 09:14:50', 0),
(112, 886, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 09:21:11', 0),
(113, 887, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 10:58:15', 0),
(114, 888, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-20 11:01:53', 0),
(115, 889, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 10:27:42', 0),
(116, 890, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 10:35:20', 0),
(117, 891, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 11:36:17', 0),
(118, 892, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 11:40:17', 0),
(119, 893, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 11:46:45', 0),
(120, 894, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 11:52:32', 0),
(121, 895, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 11:59:17', 0),
(122, 896, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:06:06', 0),
(123, 897, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:10:16', 0),
(124, 898, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:14:15', 0),
(125, 899, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:32:24', 0),
(126, 900, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:36:38', 0),
(127, 901, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:43:24', 0),
(128, 902, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-21 12:57:42', 0),
(129, 903, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-22 11:38:15', 0),
(130, 904, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-22 12:50:03', 0),
(131, 905, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-23 07:44:53', 0),
(133, 906, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-23 08:01:17', 0),
(134, 907, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-23 10:14:19', 0),
(135, 908, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-03-23 11:14:03', 0),
(137, 909, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 07:32:15', 0),
(138, 910, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 08:09:45', 0),
(139, 911, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 08:25:45', 0),
(140, 912, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 08:29:29', 0),
(141, 913, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 08:35:58', 0),
(142, 914, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 08:49:14', 0),
(143, 915, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 08:53:47', 0),
(145, 917, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 09:07:55', 0),
(146, 918, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 09:14:10', 0),
(147, 919, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 09:21:19', 0),
(148, 920, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 09:39:26', 0),
(149, 921, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 10:00:42', 0),
(150, 922, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 10:05:05', 0),
(151, 923, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 10:08:46', 0),
(152, 924, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 10:14:43', 0),
(153, 925, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 10:25:00', 0),
(154, 926, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 10:39:57', 0),
(155, 927, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 11:09:28', 0),
(156, 928, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 11:16:43', 0),
(157, 929, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 11:22:35', 0),
(158, 930, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 11:26:50', 0),
(159, 931, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 12:17:36', 0),
(160, 932, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 12:22:36', 0),
(161, 933, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 12:40:37', 0),
(162, 934, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 12:56:49', 0),
(163, 935, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 13:01:06', 0),
(164, 936, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 13:06:31', 0),
(165, 937, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 13:17:41', 0),
(166, 938, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-12 13:23:00', 0),
(167, 939, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-17 10:22:26', 0),
(168, 940, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-17 10:25:50', 0),
(169, 941, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-17 10:40:17', 0),
(170, 942, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-17 10:45:11', 0),
(171, 943, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-17 10:54:16', 0),
(172, 944, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-23 08:44:21', 0),
(173, 945, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-23 14:54:01', 0),
(174, 946, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-23 14:57:16', 0),
(175, 947, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-24 11:39:13', 0),
(176, 948, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-24 11:44:57', 0),
(177, 916, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-25 09:24:29', 0),
(178, 949, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 07:11:12', 0),
(179, 950, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 07:17:26', 0),
(180, 951, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 07:21:39', 0),
(181, 952, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 10:27:59', 0),
(182, 953, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 10:42:49', 0),
(183, 954, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 10:58:44', 0),
(184, 955, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:06:31', 0),
(185, 956, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:11:11', 0),
(186, 957, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:16:55', 0),
(187, 958, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:22:59', 0),
(188, 959, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:28:27', 0),
(189, 960, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:36:33', 0),
(190, 961, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-26 11:45:21', 0),
(191, 962, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-27 10:41:48', 0),
(192, 963, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-27 11:23:25', 0),
(193, 964, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-27 11:27:08', 0),
(194, 965, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-27 11:32:43', 0),
(195, 966, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-04-27 11:35:59', 0),
(196, 967, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-02 06:43:15', 0),
(197, 968, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-03 15:59:31', 0),
(198, 969, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-04 06:35:25', 0),
(199, 970, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-04 06:43:52', 0),
(200, 971, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-04 06:49:48', 0),
(201, 972, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-04 06:57:17', 0),
(202, 973, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-04 08:40:53', 0),
(203, 974, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-04 08:54:01', 0),
(204, 975, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-09 15:47:53', 0),
(205, 976, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-09 17:32:58', 0),
(206, 977, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-10 10:56:15', 0),
(208, 978, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-10 11:04:52', 0),
(209, 979, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-10 11:07:34', 0),
(210, 980, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-10 11:12:52', 0),
(211, 981, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-10 11:29:44', 0),
(212, 982, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-10 11:34:13', 0),
(213, 983, '', 0, '', NULL, NULL, '0.00', 0, 0, '2018-05-11 07:09:21', 0);

-- --------------------------------------------------------

--
-- Table structure for table `person_relative`
--

CREATE TABLE `person_relative` (
  `id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  `is_next_of_kin` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - Yes, 0 - No',
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `other_names` varchar(50) DEFAULT NULL,
  `relative_gender` tinyint(2) NOT NULL,
  `relationship` tinyint(2) NOT NULL,
  `address` varchar(100) NOT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `telephone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person_relative`
--

INSERT INTO `person_relative` (`id`, `personId`, `is_next_of_kin`, `first_name`, `last_name`, `other_names`, `relative_gender`, `relationship`, `address`, `address2`, `telephone`) VALUES
(1, 741, 0, 'Mulindwa', 'Lawrence', '', 0, 1, '', '', '(070) 543-3395'),
(2, 744, 0, 'Tumuhise', 'Lois', '', 1, 1, '', '', '(078) 991-0362'),
(3, 749, 1, 'Asekenye', 'Esther', '', 0, 5, '', '', '(075) 363-2533'),
(4, 750, 1, 'Mwesigwa', 'Peter', 'Solomon', 1, 4, '', '', '(078) 258-6364'),
(5, 773, 1, 'NAGAWA', 'PROSCOVIA', '', 0, 5, '', '', '(075) 265-3960'),
(6, 774, 1, 'NAGAWA', 'PROSCOVIA', '', 0, 5, '', '', '(075) 265-3960'),
(7, 775, 1, 'TWIKIRIZE', 'CHARITY', '', 0, 7, '', '', '(078) 517-9502'),
(8, 777, 0, '', '', '', 0, 0, '', '', ''),
(9, 779, 1, 'Namutebi', 'Juliet', '', 0, 13, '', '', '(077) 661-6135'),
(10, 780, 0, 'Nankanja ', 'Justine', '', 0, 5, '', '', '(077) 437-3266'),
(11, 781, 0, '', '', '', 0, 0, '', '', ''),
(12, 782, 0, '', '', '', 0, 0, '', '', ''),
(13, 783, 1, 'KYOZAIRE', 'JOLLY', '', 0, 5, '', '', '(077) 288-8926'),
(14, 784, 0, '', '', '', 0, 0, '', '', ''),
(15, 785, 1, 'NANYONGA', 'AMINA', '', 0, 2, '', '', '(077) 982-1659'),
(16, 786, 1, 'NAMUGERWA', 'STELLA', '', 0, 2, '', '', '(070) 235-1428'),
(17, 787, 0, 'NAMBOOZI', 'BARBRA', '', 0, 7, '', '', '(075) 208-8275'),
(18, 788, 0, 'NAKANWAGI', 'PROSSY', '', 0, 5, '', '', '(075) 122-9997'),
(19, 790, 1, 'NAKALINZI', 'JOSEPHINE', '', 0, 5, '', '', '(075) 912-6051'),
(20, 791, 1, 'NAKALINZI', 'JOSEPHINE', '', 0, 5, '', '', '(075) 912-6051'),
(21, 792, 0, 'BYEKWASO', 'TANANSI', 'MULEMA', 1, 4, '', '', '(075) 122-9997'),
(22, 793, 0, '', '', '', 0, 0, '', '', ''),
(23, 795, 0, '', '', '', 0, 0, '', '', ''),
(24, 796, 0, '', '', '', 0, 0, '', '', ''),
(25, 797, 0, '', '', '', 0, 0, '', '', ''),
(27, 801, 0, 'BENGO', 'LAWRENCE', '', 1, 8, '', '', '(077) 517-0238'),
(28, 802, 0, 'NANTEZA', 'MARY', 'KYAMUMMI', 0, 5, '', '', '(078) 236-6779'),
(29, 803, 0, 'NALUBEGA', 'LYDIA', '', 0, 5, '', '', '(077) 241-5061'),
(30, 804, 0, 'TWKIRIZE', 'BEATRICE', '', 0, 5, '', '', '(078) 609-6466'),
(31, 805, 0, 'NANONO', 'JOSEPHINE', '', 0, 5, '', '', '(075) 386-3321'),
(32, 806, 0, '', '', '', 0, 0, '', '', ''),
(33, 807, 0, '', '', '', 0, 0, '', '', ''),
(34, 808, 0, 'KAYIGA', 'ISAAC', '', 1, 4, '', '', '(078) 201-4620'),
(35, 809, 0, 'SINAI', 'NAIGA', '', 0, 2, '', '', '(077) 161-9152'),
(36, 810, 0, 'KAKIRE', 'ASUMAN', '', 1, 4, '', '', '(075) 380-5379'),
(37, 811, 0, 'HALIMA', 'TALIB', '', 0, 2, '', '', '(078) 921-1559'),
(38, 812, 0, 'TEBANDEKE', 'NOAH', '', 1, 6, '', '', '(075) 580-6050'),
(40, 813, 0, 'SEMUJJU', 'TREVOR', '', 1, 6, '', '', '(075) 255-5155'),
(41, 814, 0, 'ALESEKI', 'JULIET', '', 0, 5, '', '', '(070) 551-0772'),
(42, 815, 1, 'OLIVE', 'MULUNGI', '', 0, 5, '', '', '(070) 431-1566'),
(43, 816, 0, 'KIIZA', 'MARIA', '', 0, 7, '', '', '(075) 485-3338'),
(45, 817, 1, 'SSENYONDO', 'PETER', '', 1, 1, 'NAKASONGOLA', '', '(077) 491-5197'),
(46, 818, 1, 'GRACE', 'NAMUDDU', '', 0, 2, 'NDEJJE', 'LUBUGUMU', '(077) 254-0214'),
(47, 820, 1, 'NALWOGA ', 'RITAH', '', 0, 2, 'MUYENGA', '', '(078) 215-8711'),
(48, 821, 1, 'NALWOGA RITAH', '', '', 0, 2, 'MUYENGA', '', '(078) 215-8711'),
(49, 822, 1, 'NALWOGA ', 'RITAH', '', 0, 2, 'MUYENGA', '', '(078) 215-8711'),
(50, 823, 0, '', '', '', 0, 0, '', '', ''),
(51, 824, 1, 'NAMBAZIIRA ', 'SHAMAMIM', '', 0, 2, '0701268200', '', ''),
(52, 825, 1, 'SSENYONDO', 'BASHIR', '', 1, 1, '0752660126', '', ''),
(53, 826, 1, 'SSENTAMU', 'YUNUSU', '', 1, 1, 'NDEJJE', '', '(070) 262-8936'),
(54, 827, 1, 'KAWEESA ', 'JOSEPH ', 'KITYO', 1, 1, 'SALAAMA', '', '(077) 242-3003'),
(55, 828, 1, 'KAWEESA', 'JOSEPH', 'KITYO', 1, 1, 'SALAAMA', '', '(077) 242-3003'),
(56, 798, 0, '', '', '', 0, 0, '', '', ''),
(57, 829, 1, 'NAKYAMBADDE', 'REBECCA', '', 0, 2, 'KIBULI', '', '(075) 611-7406'),
(58, 830, 0, 'KIGULI', 'EDITH', '', 0, 5, '', '', ''),
(59, 831, 0, 'KIGULI', 'MOSES', '', 1, 4, '', '', ''),
(60, 832, 1, 'VINCENT', 'PETER', 'BWOGI', 1, 1, '', '', ''),
(61, 833, 0, 'NABWAMI', 'HARRIET', '', 0, 2, 'KIWALIMU ZONE', '', '(077) 266-5087'),
(62, 834, 1, 'NASSUNA', 'MASTUURRAH', '', 0, 2, 'KITEGOMBA', '', '(075) 836-6886'),
(63, 835, 1, 'REGUS', 'MUYINGO', '', 0, 5, 'SABAGABO', '', '(070) 597-5146'),
(64, 836, 1, 'ESTHER', 'NDAGIRE', '', 0, 2, 'MUYENGA', '', ''),
(65, 837, 1, 'FARDIDAH', 'KAKANDE', '', 0, 2, 'KONGE', '', '(075) 244-9986'),
(66, 838, 1, 'ABDUL', 'MULISA', '', 1, 1, 'KITALA', '', '(075) 264-2866'),
(67, 839, 1, 'NANONO', 'ZAINA', '', 0, 5, 'BUSABALA', '', '(070) 098-8090'),
(69, 840, 1, 'PETER', 'LUWANGA', '', 1, 1, 'KAZO', '', '(070) 258-3848'),
(70, 841, 1, 'IGA GEORGE', 'WILLIAM', '', 1, 1, 'NJERU', '', '(070) 678-7643'),
(71, 842, 1, 'LUBEGA', 'JAMES', '', 1, 1, '', '', '(075) 498-0059'),
(72, 843, 1, 'NAKATE', 'JANE', '', 0, 5, 'MPIGI', '', '(075) 374-6872'),
(73, 844, 1, 'NANSAMBA ', 'JOVIA', 'KIRABO', 0, 5, 'WAKISO', '', '(075) 142-7561'),
(74, 845, 1, 'KYALIKUNDA', 'NAVERA', '', 0, 2, '', '', ''),
(75, 846, 1, 'KATUSHABE', 'CLAIRE', '', 0, 5, 'BWAISE', '', '(075) 229-4500'),
(76, 847, 1, 'JOSEPH', 'WALAKILA', '', 0, 4, 'NDEJJE', '', '(075) 910-4559'),
(77, 848, 1, 'WASWA', 'SAAD', '', 1, 1, 'NDEJJE', '', '(077) 263-4688'),
(78, 849, 1, 'NAKAWOOYA', 'JOAN', '', 0, 2, 'MASAJJA', '', '(075) 236-0721'),
(79, 850, 1, 'NAMWANJE', 'RITAH', '', 0, 2, 'NAMASUBA', '', '(075) 581-9626'),
(82, 851, 1, 'FLORENCE ', 'NAKIITO', '', 0, 2, 'ZAANA', '', '(075) 245-5775'),
(83, 852, 1, 'SANYIKA', 'NABAKKA', '', 0, 1, 'NDIKUKA', 'MADDE', '(075) 512-0588'),
(84, 853, 1, 'DERRICK', 'KATELEGGA', '', 1, 1, 'ZAANA', '', ''),
(85, 854, 1, 'NABAKOOZA', 'ANNET', '', 0, 13, 'MUBENDE', '', '(070) 132-7229'),
(86, 855, 1, 'NAKASINDE', 'CATHERINE', '', 0, 2, 'BUNAMWAYA', '', '(070) 632-1789'),
(87, 856, 1, 'NAKIBILANGO', 'SAMALIE', '', 0, 2, 'MASAJJA', '', '(075) 621-2168'),
(88, 857, 1, 'MUGEJJERA', 'WILLIAM', '', 1, 1, 'NABWERU', '', '(075) 404-7250'),
(89, 858, 1, 'MARVIN', 'KAWEERE', '', 1, 1, 'NABWERU', '', '(070) 670-0447'),
(90, 859, 1, 'KIZZA', 'JOHN', '', 1, 1, 'MASAJJA', '', '(070) 444-3804'),
(91, 860, 1, 'NAMBALIRWA', 'JANAT', '', 0, 5, 'GAYAZA', '', '(078) 259-4501'),
(92, 861, 0, 'MAZIMA', 'DEDUS', '', 1, 1, 'KAWEMPE', '', '(078) 366-2525'),
(93, 862, 1, 'NAMBATYA', 'SHADIA', '', 0, 2, 'NABWERU', '', '(075) 332-7147'),
(94, 863, 1, 'NAMYALO', 'MARGRET', '', 0, 5, 'KATWE', '', '(070) 140-1953'),
(95, 864, 1, 'HARRIET', 'NANYONJO', '', 0, 2, 'NABWERU', '', '(075) 268-2491'),
(96, 865, 1, 'MAMBLE', 'FRED', '', 1, 1, 'NABWERU', '', '(075) 374-7630'),
(97, 866, 1, 'KASIRYE', 'FRANCIS', '', 1, 4, 'NABWERU', '', '(075) 837-8240'),
(98, 867, 1, 'NAKANWANGI', 'HABIBAH', '', 0, 2, 'BUNAMWAYA', '', '(070) 594-4738'),
(99, 868, 1, 'IBANDA', 'PROMISE', 'SANYU', 0, 2, 'KASUBI', '', '(078) 800-9068'),
(100, 869, 1, 'SSEMAKULA', 'TADEO', '', 1, 1, 'NABWERU', '', '(070) 530-9886'),
(101, 870, 1, 'NAJJUKO', 'LILLIAN', '', 0, 2, 'KALWERWE', '', '(078) 552-7639'),
(102, 871, 1, 'NABAKOOZA', 'MARY', '', 0, 2, 'KIGUNDU ZONE', '', '(077) 437-1905'),
(103, 872, 1, 'NAJJINGO', 'MADINAH', '', 0, 5, 'MASAJJA', '', '(075) 233-7345'),
(104, 873, 1, 'NANTUME', 'LABIAH', '', 0, 2, 'BUSUNJJU', '', '(077) 254-6195'),
(105, 874, 1, 'FAKILAH', 'NAGUJJAH', '', 0, 2, 'KIVULE', '', '(075) 346-5341'),
(106, 875, 1, 'RITAH', 'NANYANZI', '', 0, 2, '', 'MASAJJA', ''),
(107, 876, 1, 'NYANZI', 'JOYCE', '', 0, 2, 'SALAAMA', '', '(077) 886-1881'),
(108, 877, 1, 'NAMUSSEMBE', 'JOAN', '', 0, 5, 'MASAJJA', 'KIBIRA B', '(077) 566-3600'),
(109, 878, 1, 'MUTABAZI', 'NICHOLAS', '', 1, 4, 'MASAJJA', '', '(078) 855-3255'),
(110, 879, 1, 'GORRET', 'GORRET', '', 0, 2, 'MASAJJA', '', '(078) 740-0060'),
(111, 880, 1, 'KIGUNDU', 'RASHID', '', 0, 2, 'BUSABALA', 'WALULENZI ZONE', '(070) 577-8303'),
(112, 881, 1, 'NALUJJA', 'PHIONAH', '', 0, 2, '0758791314', '', ''),
(113, 882, 1, 'TAMALE', 'LWANGA', 'DERRICK', 1, 1, 'KAJJANSI', '', '(070) 671-2907'),
(114, 883, 1, 'KAAYA', 'HASSIM', '', 1, 4, 'MASAJJA', '', '(075) 266-7110'),
(115, 884, 1, 'NABUMA', 'AUSNAH', '', 0, 2, 'MASAJJA', '', '(078) 271-7558'),
(116, 885, 1, 'DDAMULIRA', 'CHARLES', '', 1, 4, 'MASAJJA', '', '(077) 242-3432'),
(117, 886, 1, 'CANDIDAH', 'NABAWESI', '', 0, 2, 'BWEYOGERERE', '', '(161) 778-0609'),
(118, 887, 1, 'MUJJUMBI', 'SUSAN', '', 0, 2, 'MAKINDYE', '', '(075) 595-8153'),
(119, 888, 1, 'KATIIMBO', 'HENRY', '', 1, 4, 'MPIGI', '', '(077) 948-5885'),
(120, 889, 1, 'BASULIRA', 'NASAR', '', 1, 1, 'KIBIRI', '', '(070) 086-5251'),
(121, 890, 1, 'TENWYA', 'TONY', '', 1, 1, 'MASAJJA ZONE B', '', '(075) 362-3092'),
(122, 891, 1, 'NAGAWA', 'SYLVIA', '', 0, 2, 'MASAJJA ZONE B', '', '(075) 187-5439'),
(123, 892, 1, 'NAKANDI', 'MAYIMUNA', '', 0, 2, 'GANGU B', '', '(075) 193-7266'),
(124, 893, 1, 'LUSWATA', 'EDWARD', '', 1, 1, 'KYENGERA', '', '(077) 282-3074'),
(125, 894, 1, 'NABISUBI ', 'JOAN', '', 0, 2, 'NABWERU', '', '(075) 922-7065'),
(126, 895, 1, 'NAMULONDO', 'LILLIAN', '', 0, 5, 'MUKONO', '', '(075) 870-0088'),
(127, 896, 1, 'OLIVIA', 'BLICK', 'KABOGOZA', 1, 1, 'KIKAJJO', 'BUSIRO', '(077) 692-2966'),
(128, 897, 1, 'NALWANGA', 'FLORENCE', '', 0, 2, 'WAKISO', '', '(073) 000-3524'),
(129, 898, 1, 'TUGUMSIRIZA', 'RICHARD', '', 1, 4, 'LWEZA A', '', '(077) 964-3287'),
(130, 899, 1, 'NAGITTA', 'JANE', '', 0, 2, 'LUNGUJJA', '', '(078) 238-1685'),
(131, 900, 1, 'SSERUGGA', 'MATOVU', 'CHARLES', 1, 1, 'MAKINDYE', '', '(077) 250-0075'),
(132, 901, 1, 'NAMAKULA', 'SAIDAH', '', 0, 5, 'KIGANDA ZONE', 'KATWE', '(077) 444-1223'),
(133, 902, 1, 'BUKANJA', 'MOREEN', '', 0, 5, 'NAMUNGOONA', '', '(077) 530-4831'),
(134, 903, 1, 'NAKALWAYI', 'EDWIQ', '', 1, 1, 'NDEJJE', '', '(075) 109-9295'),
(135, 904, 1, 'MUSAAZI', 'JOHN', '', 1, 4, 'NSAMBYA', '', '(077) 262-4808'),
(136, 905, 1, 'HAKIM ', 'kAYONGO', '', 1, 1, 'MASAJJA', '', '(074) 178-0898'),
(138, 906, 1, 'SSEMANDA', 'GODFREY', '', 0, 4, 'MBALALA LC1', '', '(075) 516-0270'),
(139, 907, 1, 'MAYENGO', 'MOSES', '', 1, 4, 'NYANAMA', '', '(070) 290-9183'),
(140, 908, 1, 'ADAKU', 'ISAMIL', '', 1, 8, 'KAWEMPE', '', '(077) 264-7202'),
(142, 909, 0, 'NAMUKWAYA', 'ZARI', '', 0, 5, '', '', '(077) 392-7534'),
(143, 910, 1, 'NAMWANJE', 'HADIJAH', '', 0, 5, 'NABBINGO', '', '(075) 286-3788'),
(144, 911, 1, 'MUHAMMED', 'LUYOMBYA', 'KAYONGO', 1, 1, 'KATWE', '', '(077) 422-4863'),
(145, 912, 1, 'NAMPEERA', 'VIOLA', '', 0, 2, 'NDEJJE', '', '(070) 143-9313'),
(146, 913, 1, 'NANTABI', 'LILLIAN', '', 0, 2, 'KIKAJJO', '', '(075) 997-2015'),
(147, 914, 1, 'SSENDYOWA', 'SHARON', '', 0, 5, 'MA', '', '(075) 398-5635'),
(148, 915, 1, 'NASAKA', 'SUMAYA', '', 0, 2, 'GANGU', '', '(070) 501-5444'),
(150, 917, 1, 'KYAMBADDE', 'STEVEN', '', 1, 4, 'NDEJJE', '', '(077) 239-3389'),
(151, 918, 1, 'NAMUTEBI', 'PROSSY', '', 0, 2, 'KANAABA', 'WAKISO', '(070) 325-0275'),
(152, 919, 1, 'NAMAGANDA', 'CATHERINE', '', 0, 2, 'NDEJJE', 'WAKISO', '(077) 488-7370'),
(153, 920, 1, 'TAHIA', 'KATENDE', '', 1, 4, 'MAKINDYE', '', '(070) 215-0608'),
(154, 921, 1, 'SARAH', 'NAMBI', '', 0, 2, 'BULOOBA', '', '(077) 531-8963'),
(155, 922, 1, 'NAKITENDE', 'HARRIET', '', 0, 2, 'KANAABA', '', '(075) 704-7970'),
(156, 923, 1, 'NSIBAMBI', 'HERMAN', '', 1, 1, 'LUBOWA', '', '(078) 946-6882'),
(157, 924, 1, 'NAMASIBI', 'JULIET', '', 0, 5, 'NDEJJE', '', '(070) 226-0679'),
(158, 925, 1, 'NANTEZA', 'ERINA', '', 0, 5, 'MAYA', 'WAKISO', '(075) 200-6165'),
(159, 926, 0, 'NAMITALA', 'VICKY', '', 0, 5, 'KIBUYE 11', '', '(070) 276-4311'),
(160, 927, 1, 'MALUDAH', 'MASSAN', 'MICHEAL', 1, 4, 'MASANAFFU', 'WAKISO', '(070) 638-7183'),
(161, 928, 1, 'BIRABWA', 'JOANNESFRANCIS', '', 0, 5, 'MANASAFFU', 'WAKISO', '(077) 246-6276'),
(162, 929, 1, 'SSENTUME', 'MIRIAM', '', 0, 5, 'MASANAFFU', '', '(075) 194-2397'),
(163, 930, 1, 'NAMUBIRU', 'NULIRU', '', 0, 5, 'KASUBI', 'WAKISO', '(077) 614-4431'),
(164, 931, 1, 'SHADIA', 'KAITESI', '', 0, 2, 'MUKONO', '', '(070) 404-6946'),
(165, 932, 1, 'SEBESTIAN', 'CHEROTIN', '', 1, 1, 'ENTEBBE', 'KITALA', '(070) 161-2191'),
(166, 933, 1, 'NSIIMA', 'SHEILA', '', 0, 5, 'MPEREREWE', 'KAMPALA', '(070) 614-8195'),
(167, 934, 1, 'NALUGWA', 'CATHERINE', '', 0, 5, 'WAKALIGA', 'KAMPALA', '(070) 670-4651'),
(168, 935, 1, 'SSEMANDA', 'ABDUL', 'HAKIM', 1, 4, 'WAKALIGA', 'KAMPALA', '(070) 432-1008'),
(169, 936, 1, 'NAMATOVU', 'HAMIDAH', '', 0, 5, 'KAKIRI', '', '(075) 544-5220'),
(170, 937, 1, 'DANIEL', 'BBUULE', '', 1, 4, 'MAIN STREET', 'KAMPALA', '(070) 048-4088'),
(171, 938, 1, 'MUSAZI', 'JOHN', '', 0, 4, 'NSAMBYA', '', '(077) 262-4808'),
(172, 939, 1, 'MULINDWA', 'FADHIL', '', 1, 4, 'SEETA', 'MUKONO', '(075) 331-8157'),
(173, 940, 1, 'KAVUMA', 'FRED', '', 1, 1, 'MAKINDYE', '', '(070) 035-9878'),
(174, 941, 1, 'LUTALO', 'MOSES', '', 1, 1, 'BUSEGA', 'WAKISO', '(070) 519-2591'),
(175, 942, 1, 'NANTEZA', 'AISHA', '', 0, 5, 'KITEBI', 'WAKISO', '(078) 153-7085'),
(176, 943, 1, 'SEBIRUMBI', 'SIRIMANI', '', 1, 4, 'KASANGATI', 'WAKISO', '(075) 722-1177'),
(177, 944, 1, 'MUKASA', 'JOSEPH', '', 1, 1, 'KIBUYE', 'JOSEPH', '(075) 395-2120'),
(178, 945, 1, 'MURANGA', 'BEYONCE', '', 0, 5, 'NASANA', 'WAKISO', '(075) 554-3817'),
(179, 946, 1, 'LUZINDA', 'MICHEAL', '', 1, 1, 'KITEBI', 'WAKISO', '(070) 145-9725'),
(180, 947, 1, 'ABDUL', 'YIGA', '', 1, 1, 'GANGU ', 'WAKISO', '(075) 513-1193'),
(181, 948, 1, 'SARAH', 'NAMULI', '', 0, 2, 'LUZIRA', 'WAKISO', '(075) 527-9419'),
(182, 916, 1, 'NALUGAAJU', 'MARGRET', '', 0, 2, 'KIRA', 'KIYINDA ZONE', '(077) 705-6489'),
(183, 949, 1, 'SSEMAKULA', 'RICHARD', '', 1, 1, 'NABWERU', 'WAKISO', '(075) 802-8581'),
(184, 950, 1, 'BARIRYE', 'CAROLYNE', '', 0, 5, 'KITEZI', 'GAYAZA', '(075) 625-8246'),
(185, 951, 1, 'YUSUF', 'LUBOWA', '', 1, 1, 'RUBUGA', 'KAMPALA', '(077) 283-6090'),
(186, 952, 1, 'NANYONJO', 'HARRIET', '', 0, 2, 'NABWERU', 'WAKISO', '(070) 336-3651'),
(187, 953, 1, 'NAMUYAGA', 'GLADYS', '', 1, 2, 'LWEZA B', 'WAKISO', '(070) 464-7611'),
(188, 954, 1, 'BERINDA', 'NABIDDO', '', 0, 2, 'KYANJA', 'KATUMBA', '(070) 648-7159'),
(189, 955, 1, 'KALUMBA', 'GODFREY', '', 1, 4, 'NDIKUTTAMADA', 'WAKISO', '(075) 361-1695'),
(190, 956, 1, 'NATUKUNDA', 'MARIAM', '', 0, 5, 'NDIKUTTAMADA', 'WAKISO', '(075) 551-4972'),
(191, 957, 1, 'NAMBIITE', 'CAROL', '', 0, 2, 'NDIKUTTAMADA', 'WAKISO', '(078) 766-2113'),
(192, 958, 1, 'MPAGI', 'DISAN', '', 1, 1, 'GANGU', 'KIZIBA', '(075) 200-8186'),
(193, 959, 1, 'NAMPPIMA', 'MOREEN', '', 0, 5, 'MAKINDYE', 'WAKISO', '(075) 580-0726'),
(194, 960, 1, 'NAMUDDU', 'GLORIA', '', 0, 5, 'SALAAMA', 'WAKISO', '(070) 598-2921'),
(195, 961, 1, 'NAMUTAMBA', 'ZAINAH', '', 0, 5, 'MASANAFU', 'WAKISO', '(070) 117-7046'),
(196, 962, 1, 'NAMUGGA', 'PROSSY', '', 0, 5, 'MAKINDYE', 'WAKISO', '(078) 226-3601'),
(197, 963, 1, 'BAGUMA', 'FRED', '', 1, 1, 'MAKINDYE', '', '(075) 844-8424'),
(198, 964, 1, 'KIYUMA', 'TIMOTHY', '', 1, 1, 'MAKINDYE', '', '(078) 851-6576'),
(199, 965, 1, 'SSEBAMBULIDDE', 'KEITH', '', 1, 1, 'KASANGATI', '', '(075) 172-5325'),
(200, 966, 1, 'SANSWI', 'TEDDY', '', 0, 5, 'MUTUNDWE', '', '(075) 941-8198'),
(201, 967, 1, 'NAKALEMA', 'NABIIRA', '', 0, 2, '0706128590', 'NATEETE', '(070) 612-8590'),
(202, 968, 0, '', '', '', 0, 0, '', '', ''),
(203, 969, 1, 'TULINAYA', 'JULIET', '', 0, 5, 'NSANGI', 'WAKISO', '(077) 438-0858'),
(204, 970, 1, 'NABATEREGGA', 'SHATIRAH', '', 0, 2, 'KAWEMPE', 'WAKISO', '(070) 535-3552'),
(205, 971, 1, 'KASIGAZI', 'HUMPHREY', '', 1, 1, 'MAKERERE', 'WAKISO', '(070) 249-6625'),
(206, 972, 1, 'RUTH', 'MBABAZI', '', 0, 5, 'KAMPALA', 'WAKISO', '(071) 254-6783'),
(207, 973, 1, 'TWEBASIZE', 'VIENE', '', 0, 2, 'NTINDA', 'WAKISO', '(070) 246-7794'),
(208, 974, 0, 'MUGULUMA', 'JOB', '', 1, 4, 'NTINDA', 'WAKISO', '(070) 443-5525'),
(209, 975, 0, '', '', '', 0, 0, '', '', ''),
(210, 976, 0, '', '', '', 0, 0, '', '', ''),
(211, 977, 1, 'NYANZI', 'JACKSON', '', 1, 1, 'BUSABALA', 'WAKISO', '(077) 486-8355'),
(213, 978, 1, '0705918287', '', '', 0, 2, 'KATWE', 'WAKISO', '(070) 591-8287'),
(214, 979, 1, 'NALUBWAMA', 'JOAN', '', 0, 2, 'KIBILI', 'WAKISO', '(077) 064-7528'),
(215, 980, 1, 'MOURIDI', 'WAKAKILA', '', 0, 2, 'MASAJJA', 'WAKISO', '(075) 494-6829'),
(216, 981, 1, 'MABIRIZI', 'JACKSON', '', 1, 4, 'NABWERU', 'WAKISO', '(078) 868-3915'),
(217, 982, 1, 'NAMATOVU', 'CHRISTINE', '', 0, 2, 'NABWERU', 'WAKISO', '(078) 462-9226'),
(218, 983, 1, 'NAMUGANYI', 'PERCY', '', 0, 5, 'RUBAGA', 'WAKISO', '(075) 615-8345');

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `id` int(11) NOT NULL,
  `access_level_id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `access_level_id`, `name`, `description`, `active`) VALUES
(1, 1, 'Administrator', 'General System Administration', 1),
(2, 2, 'Loan Officer ', 'Credit officers', 1),
(3, 3, 'Branch Manager', 'Branch Managers', 1),
(4, 5, 'Branch Credit Committee Officer', 'Branch Credit Committee Officer', 1),
(5, 5, 'Management Credit Committee member', 'Management Credit Committee\r\n', 1),
(6, 6, 'Executive board committe member', 'Executive board committe', 1),
(7, 7, 'Accountant', 'This is an accountant who will handle account positions', 1);

-- --------------------------------------------------------

--
-- Table structure for table `relationship_type`
--

CREATE TABLE `relationship_type` (
  `id` int(11) NOT NULL,
  `rel_type` varchar(100) NOT NULL COMMENT 'Type of relationship',
  `description` varchar(200) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `relationship_type`
--

INSERT INTO `relationship_type` (`id`, `rel_type`, `description`, `active`) VALUES
(1, 'Brother', '', 1),
(2, 'Sister', '', 1),
(4, 'Husband', 'Persons husband', 1),
(5, 'Wife', 'Persons Wife', 1),
(6, 'Nephew', 'nephew', 1),
(7, 'Niece', 'niece', 1),
(8, 'Uncle', 'uncle', 1),
(9, 'Auntie', 'Auntie', 1),
(10, 'Grand Mother ', 'Grand mother', 1),
(11, 'Grand Father', 'Grand Father', 1),
(12, 'Father', 'Father', 1),
(13, 'Mother', 'mother', 1);

-- --------------------------------------------------------

--
-- Table structure for table `saccogroup`
--

CREATE TABLE `saccogroup` (
  `id` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL COMMENT 'Name of the group',
  `description` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp of creation',
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp at modification',
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `saccogroup`
--

INSERT INTO `saccogroup` (`id`, `groupName`, `description`, `active`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Trust Group Lweza', 'Group operates in Lweza on Entebbe road', 1, 1511265446, 739, '2017-11-21 11:59:35', 739),
(2, 'AGALI AWAMU BANDA', 'They operate from banda and kireka areas', 0, 1517983135, 794, '2018-04-19 10:26:50', 794),
(3, 'ST FRANCIS', 'NABWERU', 0, 1523710491, 794, '2018-04-14 13:36:46', 794),
(5, 'ST FRANCIS', '', 1, 1525929303, 737, '2018-05-10 05:17:26', 737);

-- --------------------------------------------------------

--
-- Table structure for table `securitytype`
--

CREATE TABLE `securitytype` (
  `id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `securitytype`
--

INSERT INTO `securitytype` (`id`, `name`, `description`, `active`) VALUES
(1, 'Land Title', 'This will be the land title used as security on the loan', 1),
(2, 'Laptop', 'Laptop security', 1),
(3, 'Car Log Book', 'Log book details', 1),
(4, 'Salary ATM Card', 'Salary atm card', 1);

-- --------------------------------------------------------

--
-- Table structure for table `shares`
--

CREATE TABLE `shares` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `noShares` int(10) UNSIGNED NOT NULL COMMENT 'No of shares',
  `amount` decimal(12,2) NOT NULL,
  `datePaid` int(11) NOT NULL,
  `recordedBy` int(11) NOT NULL,
  `paid_by` varchar(100) NOT NULL,
  `share_rate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shares`
--

INSERT INTO `shares` (`id`, `memberId`, `noShares`, `amount`, `datePaid`, `recordedBy`, `paid_by`, `share_rate`) VALUES
(1, 562, 1, '200000.00', 1509580800, 776, 'kisakye ketty', 0);

-- --------------------------------------------------------

--
-- Table structure for table `share_rate`
--

CREATE TABLE `share_rate` (
  `id` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `date_added` int(11) NOT NULL,
  `added_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `share_rate`
--

INSERT INTO `share_rate` (`id`, `amount`, `date_added`, `added_by`) VALUES
(1, '200000.00', 1498486688, 1);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `username` varchar(120) NOT NULL,
  `password` text NOT NULL,
  `password2` int(11) NOT NULL,
  `access_level` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `date_added` date NOT NULL,
  `added_by` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `personId`, `branch_id`, `position_id`, `username`, `password`, `password2`, `access_level`, `status`, `start_date`, `end_date`, `date_added`, `added_by`) VALUES
(1, 737, 1, 1, 'platin', '9e11830101b6b723ae3fb11e660a2123', 0, 0, 1, '0000-00-00', NULL, '2017-11-15', '<br />\r\n<b>Notice</b>:  Undefined index: Staf'),
(2, 738, 1, 7, 'joshua', '9e11830101b6b723ae3fb11e660a2123', 0, 0, 1, '0000-00-00', NULL, '2017-11-15', '<br />\r\n<b>Notice</b>:  Undefined index: Staf'),
(3, 739, 1, 2, 'ssekanjako aaron', 'c6859a9fe15baef809b823f3aa25f0c5', 0, 0, 1, '0000-00-00', NULL, '2017-11-16', ''),
(4, 740, 1, 7, 'Accountant', '214ba92ab6cecfe82131ba337d812bcf', 0, 0, 1, '0000-00-00', NULL, '2017-11-16', ''),
(5, 746, 1, 2, 'kaweesasarah', 'cdf788dbdf4ba367415fa45820f07f87', 0, 0, 0, '0000-00-00', NULL, '2017-11-21', ''),
(6, 748, 1, 3, 'kalibbala', '1de9ffca4eadcf8e02a7a442890ad8b0', 0, 0, 1, '0000-00-00', NULL, '2017-11-21', ''),
(7, 776, 1, 7, 'michael', 'cf4817a1f21ddc48f5e75a42f0c9a438', 0, 0, 1, '0000-00-00', NULL, '2017-11-23', ''),
(8, 794, 1, 2, 'kaweesasarah', 'ee730f0fd461f4ab7a065dff2859b7b7', 0, 0, 1, '0000-00-00', NULL, '2018-01-25', ''),
(9, 799, 1, 4, 'bcc', '6e44f3399499047a45f315c44cc5fdac', 0, 0, 1, '0000-00-00', NULL, '2018-02-02', ''),
(10, 800, 1, 5, 'mcc', 'f45e9a52175372024c59aa4b97076222', 0, 0, 1, '0000-00-00', NULL, '2018-02-02', ''),
(11, 819, 1, 1, 'Namuddu', '2ce2a7a8eda366179badcbd21951c323', 0, 0, 1, '0000-00-00', NULL, '2018-03-02', ''),
(12, 984, 1, 6, 'ecc', 'b376e67e4f363344d92088dcac053255', 0, 0, 1, '0000-00-00', NULL, '2018-05-11', '');

-- --------------------------------------------------------

--
-- Table structure for table `staff_roles`
--

CREATE TABLE `staff_roles` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `personId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `staff_roles`
--

INSERT INTO `staff_roles` (`id`, `role_id`, `personId`) VALUES
(12, 1, 737),
(13, 7, 738),
(14, 2, 739),
(15, 7, 740),
(16, 2, 746),
(17, 3, 748),
(18, 7, 776),
(19, 2, 794),
(20, 4, 799),
(21, 5, 800),
(24, 1, 819),
(25, 6, 984);

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id`, `name`, `description`) VALUES
(1, 'Available ', ''),
(2, 'Taken ', '');

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `receipt_no` int(11) NOT NULL,
  `subscriptionYear` year(4) NOT NULL,
  `receivedBy` int(11) NOT NULL,
  `datePaid` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff modifying the entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`id`, `memberId`, `amount`, `receipt_no`, `subscriptionYear`, `receivedBy`, `datePaid`, `dateModified`, `modifiedBy`) VALUES
(1, 1, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:22:46', 1),
(2, 2, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:22:46', 1),
(3, 3, '25000.00', 0, 2017, 0, 1502143200, '2017-11-15 07:22:46', 1),
(4, 4, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 07:22:47', 1),
(5, 5, '20000.00', 135, 2017, 0, 1484175600, '2017-11-15 07:22:47', 1),
(6, 6, '20000.00', 47, 2016, 0, 1476309600, '2017-11-15 07:22:47', 1),
(7, 7, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:22:47', 1),
(8, 8, '20000.00', 126, 2017, 0, 1483916400, '2017-11-15 07:22:48', 1),
(9, 9, '20000.00', 125, 2017, 0, 1483916400, '2017-11-15 07:22:48', 1),
(10, 10, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:22:48', 1),
(11, 11, '20000.00', 0, 2017, 0, 1504476000, '2017-11-15 07:22:48', 1),
(12, 12, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:22:48', 1),
(13, 13, '20000.00', 124, 2017, 0, 1483916400, '2017-11-15 07:22:48', 1),
(14, 14, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:22:48', 1),
(15, 15, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:22:48', 1),
(16, 16, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:22:48', 1),
(17, 17, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:22:49', 1),
(18, 18, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 07:22:49', 1),
(19, 19, '20000.00', 0, 2017, 0, 1504562400, '2017-11-15 07:22:49', 1),
(20, 20, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:22:50', 1),
(21, 21, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 07:22:50', 1),
(22, 22, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:22:50', 1),
(23, 23, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 07:22:51', 1),
(24, 24, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:22:51', 1),
(25, 25, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 07:22:52', 1),
(26, 26, '25000.00', 0, 2017, 0, 1501711200, '2017-11-15 07:22:52', 1),
(27, 27, '20000.00', 0, 2017, 0, 1509055200, '2017-11-15 07:22:52', 1),
(28, 28, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:22:52', 1),
(29, 29, '20000.00', 0, 2017, 0, 1497564000, '2017-11-15 07:22:52', 1),
(30, 30, '20000.00', 0, 2017, 0, 1491170400, '2017-11-15 07:22:52', 1),
(31, 31, '20000.00', 0, 2017, 0, 1503957600, '2017-11-15 07:22:53', 1),
(32, 32, '20000.00', 32, 2016, 0, 1475186400, '2017-11-15 07:22:53', 1),
(33, 33, '20000.00', 3, 2016, 0, 1472594400, '2017-11-15 07:22:53', 1),
(34, 34, '20000.00', 30, 2016, 0, 1475186400, '2017-11-15 07:22:53', 1),
(35, 35, '20000.00', 0, 2017, 0, 1501020000, '2017-11-15 07:22:53', 1),
(36, 36, '20000.00', 53, 2016, 0, 1476914400, '2017-11-15 07:22:53', 1),
(37, 37, '20000.00', 92, 2016, 0, 1481065200, '2017-11-15 07:22:53', 1),
(38, 38, '20000.00', 81, 2016, 0, 1479164400, '2017-11-15 07:22:54', 1),
(39, 39, '20000.00', 77, 2016, 0, 1478646000, '2017-11-15 07:22:54', 1),
(40, 40, '20000.00', 0, 2017, 0, 1502229600, '2017-11-15 07:22:54', 1),
(41, 41, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 07:22:54', 1),
(42, 42, '20000.00', 0, 2017, 0, 1506376800, '2017-11-15 07:22:54', 1),
(43, 43, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:22:54', 1),
(44, 44, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:22:55', 1),
(45, 45, '20000.00', 94, 2016, 0, 1482274800, '2017-11-15 07:22:55', 1),
(46, 46, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:22:55', 1),
(47, 47, '20000.00', 24, 2016, 0, 1475100000, '2017-11-15 07:22:55', 1),
(48, 48, '20000.00', 0, 2017, 0, 1506636000, '2017-11-15 07:22:55', 1),
(49, 49, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:22:55', 1),
(50, 50, '20000.00', 76, 2016, 0, 1478214000, '2017-11-15 07:22:55', 1),
(51, 51, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 07:22:55', 1),
(52, 52, '20000.00', 0, 2017, 0, 1499637600, '2017-11-15 07:22:56', 1),
(53, 53, '20000.00', 0, 2017, 0, 1507759200, '2017-11-15 07:22:56', 1),
(54, 54, '20000.00', 66, 2016, 0, 1477605600, '2017-11-15 07:22:56', 1),
(55, 55, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 07:22:56', 1),
(56, 56, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 07:22:56', 1),
(57, 57, '20000.00', 0, 2017, 0, 1494194400, '2017-11-15 07:22:57', 1),
(58, 58, '20000.00', 0, 2017, 0, 1505685600, '2017-11-15 07:22:57', 1),
(59, 59, '20000.00', 0, 2017, 0, 1507672800, '2017-11-15 07:22:57', 1),
(60, 60, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:22:57', 1),
(61, 61, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:22:57', 1),
(62, 62, '20000.00', 0, 2017, 0, 1494453600, '2017-11-15 07:22:57', 1),
(63, 63, '10000.00', 1, 2016, 0, 1472594400, '2017-11-15 07:22:58', 1),
(64, 64, '20000.00', 55, 2016, 0, 1477260000, '2017-11-15 07:22:58', 1),
(65, 65, '20000.00', 31, 2016, 0, 1475186400, '2017-11-15 07:22:58', 1),
(66, 66, '20000.00', 48, 2016, 0, 1476309600, '2017-11-15 07:22:58', 1),
(67, 67, '20000.00', 0, 2017, 0, 1504044000, '2017-11-15 07:22:58', 1),
(68, 68, '20000.00', 0, 2017, 0, 1504476000, '2017-11-15 07:22:59', 1),
(69, 69, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:22:59', 1),
(70, 70, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:22:59', 1),
(71, 71, '20000.00', 22, 2016, 0, 1475100000, '2017-11-15 07:22:59', 1),
(72, 72, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:22:59', 1),
(73, 73, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:00', 1),
(74, 74, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:23:00', 1),
(75, 75, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:00', 1),
(76, 76, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 07:23:01', 1),
(77, 77, '20000.00', 61, 2016, 0, 1477519200, '2017-11-15 07:23:01', 1),
(78, 78, '20000.00', 35, 2016, 0, 1475791200, '2017-11-15 07:23:01', 1),
(79, 79, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 07:23:02', 1),
(80, 80, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:02', 1),
(81, 81, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:02', 1),
(82, 82, '20000.00', 18, 2016, 0, 1475100000, '2017-11-15 07:23:03', 1),
(83, 83, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:03', 1),
(84, 84, '20000.00', 15, 2016, 0, 1475013600, '2017-11-15 07:23:04', 1),
(85, 85, '20000.00', 63, 2016, 0, 1477605600, '2017-11-15 07:23:04', 1),
(86, 86, '20000.00', 0, 2017, 0, 1503007200, '2017-11-15 07:23:04', 1),
(87, 87, '20000.00', 13, 2017, 0, 1506549600, '2017-11-15 07:23:04', 1),
(88, 88, '20000.00', 73, 2016, 0, 1477954800, '2017-11-15 07:23:04', 1),
(89, 89, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 07:23:04', 1),
(90, 90, '20000.00', 0, 2017, 0, 1509055200, '2017-11-15 07:23:05', 1),
(91, 91, '20000.00', 38, 2016, 0, 1475791200, '2017-11-15 07:23:05', 1),
(92, 92, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 07:23:05', 1),
(93, 93, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:23:05', 1),
(94, 94, '20000.00', 138, 2017, 0, 1484262000, '2017-11-15 07:23:05', 1),
(95, 95, '20000.00', 27, 2016, 0, 1475186400, '2017-11-15 07:23:05', 1),
(96, 96, '20000.00', 0, 2017, 0, 1499119200, '2017-11-15 07:23:06', 1),
(97, 97, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 07:23:06', 1),
(98, 98, '20000.00', 0, 2017, 0, 1509404400, '2017-11-15 07:23:06', 1),
(99, 99, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:23:06', 1),
(100, 100, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:23:06', 1),
(101, 101, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:23:07', 1),
(102, 102, '20000.00', 0, 2017, 0, 1499637600, '2017-11-15 07:23:07', 1),
(103, 103, '20000.00', 33, 2016, 0, 1475532000, '2017-11-15 07:23:07', 1),
(104, 104, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:07', 1),
(105, 105, '20000.00', 0, 2017, 0, 1507586400, '2017-11-15 07:23:07', 1),
(106, 106, '20000.00', 0, 2017, 0, 1507586400, '2017-11-15 07:23:07', 1),
(107, 107, '20000.00', 0, 2017, 0, 1509404400, '2017-11-15 07:23:08', 1),
(108, 108, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:23:08', 1),
(109, 109, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 07:23:08', 1),
(110, 110, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:08', 1),
(111, 111, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:08', 1),
(112, 112, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:09', 1),
(113, 113, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:23:09', 1),
(114, 114, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:09', 1),
(115, 115, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 07:23:09', 1),
(116, 116, '20000.00', 153, 2017, 0, 1484262000, '2017-11-15 07:23:09', 1),
(117, 117, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:23:09', 1),
(118, 118, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 07:23:09', 1),
(119, 119, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:23:09', 1),
(120, 120, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:10', 1),
(121, 121, '20000.00', 0, 2017, 0, 1494799200, '2017-11-15 07:23:10', 1),
(122, 122, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 07:23:10', 1),
(123, 123, '20000.00', 0, 2017, 0, 1509318000, '2017-11-15 07:23:10', 1),
(124, 124, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 07:23:10', 1),
(125, 125, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:23:10', 1),
(126, 126, '20000.00', 11, 2016, 0, 1475013600, '2017-11-15 07:23:11', 1),
(127, 127, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:11', 1),
(128, 128, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:11', 1),
(129, 129, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:12', 1),
(130, 130, '20000.00', 127, 2017, 0, 1483916400, '2017-11-15 07:23:12', 1),
(131, 131, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 07:23:12', 1),
(132, 132, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 07:23:12', 1),
(133, 133, '20000.00', 129, 2017, 0, 1483916400, '2017-11-15 07:23:13', 1),
(134, 134, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:14', 1),
(135, 135, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:14', 1),
(136, 136, '20000.00', 50, 2016, 0, 1476655200, '2017-11-15 07:23:14', 1),
(137, 137, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:14', 1),
(138, 138, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:15', 1),
(139, 139, '20000.00', 0, 2017, 0, 1510791420, '2017-11-15 07:23:15', 1),
(140, 140, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:15', 1),
(141, 141, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 07:23:15', 1),
(142, 142, '20000.00', 133, 2017, 0, 1484175600, '2017-11-15 07:23:15', 1),
(143, 143, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:23:15', 1),
(144, 144, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:15', 1),
(145, 145, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 07:23:15', 1),
(146, 146, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:16', 1),
(147, 147, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:23:16', 1),
(148, 148, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:23:16', 1),
(149, 149, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:23:16', 1),
(150, 150, '20000.00', 142, 2017, 0, 1484262000, '2017-11-15 07:23:16', 1),
(151, 151, '20000.00', 0, 2017, 0, 1501020000, '2017-11-15 07:23:17', 1),
(152, 152, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:23:17', 1),
(153, 153, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:23:17', 1),
(154, 154, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:23:17', 1),
(155, 155, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:17', 1),
(156, 156, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:23:18', 1),
(157, 157, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:23:18', 1),
(158, 158, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 07:23:18', 1),
(159, 159, '20000.00', 0, 2017, 0, 1508364000, '2017-11-15 07:23:18', 1),
(160, 160, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:18', 1),
(161, 161, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:19', 1),
(162, 162, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 07:23:19', 1),
(163, 163, '20000.00', 0, 2017, 0, 1494194400, '2017-11-15 07:23:19', 1),
(164, 164, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:23:19', 1),
(165, 165, '20000.00', 0, 2017, 0, 1500501600, '2017-11-15 07:23:19', 1),
(166, 166, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:19', 1),
(167, 167, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 07:23:19', 1),
(168, 168, '20000.00', 131, 2017, 0, 1484175600, '2017-11-15 07:23:20', 1),
(169, 169, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:20', 1),
(170, 170, '20000.00', 119, 2017, 0, 1483657200, '2017-11-15 07:23:20', 1),
(171, 171, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:20', 1),
(172, 172, '20000.00', 0, 2017, 0, 1496786400, '2017-11-15 07:23:20', 1),
(173, 173, '20000.00', 150, 2017, 0, 1484262000, '2017-11-15 07:23:20', 1),
(174, 174, '20000.00', 88, 2016, 0, 1480028400, '2017-11-15 07:23:20', 1),
(175, 175, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:23:20', 1),
(176, 176, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:20', 1),
(177, 177, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:23:20', 1),
(178, 178, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:21', 1),
(179, 179, '20000.00', 0, 2017, 0, 1503957600, '2017-11-15 07:23:21', 1),
(180, 180, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:21', 1),
(181, 181, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:21', 1),
(182, 182, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:23:22', 1),
(183, 183, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:23:22', 1),
(184, 184, '20000.00', 0, 2017, 0, 1502402400, '2017-11-15 07:23:22', 1),
(185, 185, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 07:23:23', 1),
(186, 186, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:23:23', 1),
(187, 187, '20000.00', 0, 2017, 0, 1505858400, '2017-11-15 07:23:23', 1),
(188, 188, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 07:23:24', 1),
(189, 189, '20000.00', 8, 2016, 0, 1474236000, '2017-11-15 07:23:24', 1),
(190, 190, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:25', 1),
(191, 191, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:25', 1),
(192, 192, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:25', 1),
(193, 193, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:23:25', 1),
(194, 194, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 07:23:25', 1),
(195, 195, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:23:25', 1),
(196, 196, '20000.00', 132, 2017, 0, 1484175600, '2017-11-15 07:23:25', 1),
(197, 197, '20000.00', 117, 2017, 0, 1483657200, '2017-11-15 07:23:25', 1),
(198, 198, '20000.00', 0, 2017, 0, 1501884000, '2017-11-15 07:23:26', 1),
(199, 199, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:23:26', 1),
(200, 200, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:26', 1),
(201, 201, '20000.00', 0, 2017, 0, 1494280800, '2017-11-15 07:23:26', 1),
(202, 202, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:26', 1),
(203, 203, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:26', 1),
(204, 204, '20000.00', 87, 2016, 0, 1480028400, '2017-11-15 07:23:26', 1),
(205, 205, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:27', 1),
(206, 206, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:27', 1),
(207, 207, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:27', 1),
(208, 208, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:27', 1),
(209, 209, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:27', 1),
(210, 210, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 07:23:28', 1),
(211, 211, '20000.00', 0, 2017, 0, 1497909600, '2017-11-15 07:23:28', 1),
(212, 212, '20000.00', 84, 2016, 0, 1479855600, '2017-11-15 07:23:28', 1),
(213, 213, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:23:28', 1),
(214, 214, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:23:28', 1),
(215, 215, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:23:28', 1),
(216, 216, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:28', 1),
(217, 217, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:28', 1),
(218, 218, '20000.00', 0, 2017, 0, 1499724000, '2017-11-15 07:23:29', 1),
(219, 219, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:29', 1),
(220, 220, '20000.00', 83, 2016, 0, 1479423600, '2017-11-15 07:23:29', 1),
(221, 221, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:29', 1),
(222, 222, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:23:29', 1),
(223, 223, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:23:29', 1),
(224, 224, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:29', 1),
(225, 225, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 07:23:29', 1),
(226, 226, '20000.00', 154, 2017, 0, 1484262000, '2017-11-15 07:23:29', 1),
(227, 227, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 07:23:29', 1),
(228, 228, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:23:30', 1),
(229, 229, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 07:23:30', 1),
(230, 230, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:30', 1),
(231, 231, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 07:23:30', 1),
(232, 232, '20000.00', 25, 2016, 0, 1475100000, '2017-11-15 07:23:30', 1),
(233, 233, '20000.00', 0, 2017, 0, 1500242400, '2017-11-15 07:23:30', 1),
(234, 234, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:31', 1),
(235, 235, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:23:31', 1),
(236, 236, '20000.00', 0, 2017, 0, 1506895200, '2017-11-15 07:23:32', 1),
(237, 237, '25000.00', 0, 2017, 0, 1502143200, '2017-11-15 07:23:32', 1),
(238, 238, '20000.00', 116, 2017, 0, 1483657200, '2017-11-15 07:23:32', 1),
(239, 239, '20000.00', 149, 2017, 0, 1484262000, '2017-11-15 07:23:33', 1),
(240, 240, '20000.00', 0, 2017, 0, 1504821600, '2017-11-15 07:23:33', 1),
(241, 241, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:33', 1),
(242, 242, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 07:23:33', 1),
(243, 243, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 07:23:34', 1),
(244, 244, '20000.00', 155, 2017, 0, 1484262000, '2017-11-15 07:23:34', 1),
(245, 245, '20000.00', 0, 2017, 0, 1499292000, '2017-11-15 07:23:35', 1),
(246, 246, '20000.00', 0, 2017, 0, 1501452000, '2017-11-15 07:23:35', 1),
(247, 247, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 07:23:35', 1),
(248, 248, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:36', 1),
(249, 249, '20000.00', 123, 2017, 0, 1483916400, '2017-11-15 07:23:36', 1),
(250, 250, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:23:36', 1),
(251, 251, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:23:36', 1),
(252, 252, '20000.00', 82, 2016, 0, 1479164400, '2017-11-15 07:23:36', 1),
(253, 253, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:23:36', 1),
(254, 254, '25000.00', 0, 2017, 0, 1501711200, '2017-11-15 07:23:37', 1),
(255, 255, '20000.00', 0, 2017, 0, 1496786400, '2017-11-15 07:23:37', 1),
(256, 256, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:23:37', 1),
(257, 257, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 07:23:37', 1),
(258, 258, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 07:23:37', 1),
(259, 259, '20000.00', 0, 2017, 0, 1495144800, '2017-11-15 07:23:37', 1),
(260, 260, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:37', 1),
(261, 261, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 07:23:37', 1),
(262, 262, '20000.00', 5, 2016, 0, 1472767200, '2017-11-15 07:23:38', 1),
(263, 263, '20000.00', 0, 2017, 0, 1493935200, '2017-11-15 07:23:38', 1),
(264, 264, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 07:23:38', 1),
(265, 265, '20000.00', 0, 2017, 0, 1495490400, '2017-11-15 07:23:38', 1),
(266, 266, '20000.00', 0, 2017, 0, 1491343200, '2017-11-15 07:23:38', 1),
(267, 267, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:38', 1),
(268, 268, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:38', 1),
(269, 269, '20000.00', 62, 2016, 0, 1477519200, '2017-11-15 07:23:39', 1),
(270, 270, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 07:23:39', 1),
(271, 271, '20000.00', 0, 2017, 0, 1497909600, '2017-11-15 07:23:39', 1),
(272, 272, '20000.00', 143, 2017, 0, 1484262000, '2017-11-15 07:23:39', 1),
(273, 273, '20000.00', 0, 2017, 0, 1507672800, '2017-11-15 07:23:39', 1),
(274, 274, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 07:23:39', 1),
(275, 275, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:39', 1),
(276, 276, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:23:40', 1),
(277, 277, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 07:23:40', 1),
(278, 278, '20000.00', 0, 2017, 0, 1493935200, '2017-11-15 07:23:40', 1),
(279, 279, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:23:40', 1),
(280, 280, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:23:40', 1),
(281, 281, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:40', 1),
(282, 282, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:41', 1),
(283, 283, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:23:41', 1),
(284, 284, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 07:23:41', 1),
(285, 285, '20000.00', 0, 2017, 0, 1491343200, '2017-11-15 07:23:41', 1),
(286, 286, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 07:23:41', 1),
(287, 287, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:23:41', 1),
(288, 288, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 07:23:41', 1),
(289, 289, '20000.00', 130, 2017, 0, 1483916400, '2017-11-15 07:23:42', 1),
(290, 290, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:23:42', 1),
(291, 291, '20000.00', 21, 2016, 0, 1475100000, '2017-11-15 07:23:42', 1),
(292, 292, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:23:43', 1),
(293, 293, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:23:43', 1),
(294, 294, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:23:43', 1),
(295, 295, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:43', 1),
(296, 296, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 07:23:44', 1),
(297, 297, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 07:23:44', 1),
(298, 298, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 07:23:44', 1),
(299, 299, '20000.00', 0, 2017, 0, 1491170400, '2017-11-15 07:23:44', 1),
(300, 300, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:23:45', 1),
(301, 301, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:45', 1),
(302, 302, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:45', 1),
(303, 303, '20000.00', 128, 2017, 0, 1483916400, '2017-11-15 07:23:45', 1),
(304, 304, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 07:23:45', 1),
(305, 305, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:46', 1),
(306, 306, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:46', 1),
(307, 307, '20000.00', 0, 2017, 0, 1494799200, '2017-11-15 07:23:46', 1),
(308, 308, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:23:46', 1),
(309, 309, '20000.00', 7, 2016, 0, 1474236000, '2017-11-15 07:23:47', 1),
(310, 310, '20000.00', 57, 2016, 0, 1477260000, '2017-11-15 07:23:47', 1),
(311, 311, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:23:47', 1),
(312, 312, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:47', 1),
(313, 313, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 07:23:47', 1),
(314, 314, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 07:23:47', 1),
(315, 315, '20000.00', 86, 2016, 0, 1480028400, '2017-11-15 07:23:48', 1),
(316, 316, '20000.00', 0, 2017, 0, 1506463200, '2017-11-15 07:23:48', 1),
(317, 317, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 07:23:48', 1),
(318, 318, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:48', 1),
(319, 319, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:23:48', 1),
(320, 320, '20000.00', 0, 2017, 0, 1493589600, '2017-11-15 07:23:48', 1),
(321, 321, '20000.00', 0, 2017, 0, 1502748000, '2017-11-15 07:23:48', 1),
(322, 322, '20000.00', 0, 2017, 0, 1502229600, '2017-11-15 07:23:48', 1),
(323, 323, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 07:23:49', 1),
(324, 324, '20000.00', 157, 2017, 0, 1484521200, '2017-11-15 07:23:49', 1),
(325, 325, '20000.00', 137, 2017, 0, 1484175600, '2017-11-15 07:23:49', 1),
(326, 326, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 07:23:49', 1),
(327, 327, '20000.00', 0, 2017, 0, 1508104800, '2017-11-15 07:23:49', 1),
(328, 328, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:49', 1),
(329, 329, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:23:49', 1),
(330, 330, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:23:49', 1),
(331, 331, '25000.00', 0, 2017, 0, 1502316000, '2017-11-15 07:23:49', 1),
(332, 332, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 07:23:50', 1),
(333, 333, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:50', 1),
(334, 334, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:23:50', 1),
(335, 335, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 07:23:50', 1),
(336, 336, '20000.00', 70, 2016, 0, 1477954800, '2017-11-15 07:23:50', 1),
(337, 337, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 07:23:50', 1),
(338, 338, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:23:50', 1),
(339, 339, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 07:23:51', 1),
(340, 340, '20000.00', 0, 2017, 0, 1497564000, '2017-11-15 07:23:51', 1),
(341, 341, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:23:51', 1),
(342, 342, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:23:51', 1),
(343, 343, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:23:52', 1),
(344, 344, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:52', 1),
(345, 345, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:53', 1),
(346, 346, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:23:53', 1),
(347, 347, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 07:23:53', 1),
(348, 348, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 07:23:53', 1),
(349, 349, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 07:23:54', 1),
(350, 350, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:54', 1),
(351, 351, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:23:54', 1),
(352, 352, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:23:54', 1),
(353, 353, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:23:55', 1),
(354, 354, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:23:55', 1),
(355, 355, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:23:55', 1),
(356, 356, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:55', 1),
(357, 357, '20000.00', 139, 2017, 0, 1484262000, '2017-11-15 07:23:55', 1),
(358, 358, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:23:55', 1),
(359, 359, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:23:55', 1),
(360, 360, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:23:56', 1),
(361, 361, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:23:56', 1),
(362, 362, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:56', 1),
(363, 363, '20000.00', 34, 2016, 0, 1475532000, '2017-11-15 07:23:56', 1),
(364, 364, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 07:23:57', 1),
(365, 365, '20000.00', 0, 2017, 0, 1491170400, '2017-11-15 07:23:57', 1),
(366, 366, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:23:57', 1),
(367, 367, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:23:57', 1),
(368, 368, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:23:57', 1),
(369, 369, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 07:23:57', 1),
(370, 370, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:23:57', 1),
(371, 371, '20000.00', 0, 2017, 0, 1496008800, '2017-11-15 07:23:57', 1),
(372, 372, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:23:57', 1),
(373, 373, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 07:23:57', 1),
(374, 374, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 07:23:58', 1),
(375, 375, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 07:23:58', 1),
(376, 376, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:23:58', 1),
(377, 377, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:23:58', 1),
(378, 378, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:23:58', 1),
(379, 379, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:23:58', 1),
(380, 380, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:23:59', 1),
(381, 381, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:23:59', 1),
(382, 382, '20000.00', 0, 2017, 0, 1494453600, '2017-11-15 07:23:59', 1),
(383, 383, '20000.00', 72, 2016, 0, 1477954800, '2017-11-15 07:23:59', 1),
(384, 384, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 07:23:59', 1),
(385, 385, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:23:59', 1),
(386, 386, '20000.00', 115, 2017, 0, 1483570800, '2017-11-15 07:24:00', 1),
(387, 387, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:00', 1),
(388, 388, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:00', 1),
(389, 389, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:24:00', 1),
(390, 390, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 07:24:00', 1),
(391, 391, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:00', 1),
(392, 392, '20000.00', 0, 2017, 0, 1508709600, '2017-11-15 07:24:01', 1),
(393, 393, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 07:24:01', 1),
(394, 394, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:24:01', 1),
(395, 395, '20000.00', 16, 2016, 0, 1475013600, '2017-11-15 07:24:01', 1),
(396, 396, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 07:24:01', 1),
(397, 397, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:24:01', 1),
(398, 398, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:24:01', 1),
(399, 399, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 07:24:02', 1),
(400, 400, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 07:24:02', 1),
(401, 401, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:24:02', 1),
(402, 402, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:24:03', 1),
(403, 403, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:03', 1),
(404, 404, '10000.00', 136, 2017, 0, 1484175600, '2017-11-15 07:24:03', 1),
(405, 405, '20000.00', 140, 2017, 0, 1484262000, '2017-11-15 07:24:03', 1),
(406, 406, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:24:04', 1),
(407, 407, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:24:04', 1),
(408, 408, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:04', 1),
(409, 409, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:24:04', 1),
(410, 410, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:24:04', 1),
(411, 411, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 07:24:05', 1),
(412, 412, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:24:05', 1),
(413, 413, '20000.00', 20, 2016, 0, 1475100000, '2017-11-15 07:24:05', 1),
(414, 414, '20000.00', 9, 2016, 0, 1474236000, '2017-11-15 07:24:05', 1),
(415, 415, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:24:05', 1),
(416, 416, '20000.00', 146, 2017, 0, 1484262000, '2017-11-15 07:24:05', 1),
(417, 417, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:24:06', 1),
(418, 418, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:24:06', 1),
(419, 419, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 07:24:06', 1),
(420, 420, '20000.00', 0, 2017, 0, 1492466400, '2017-11-15 07:24:07', 1),
(421, 421, '20000.00', 145, 2017, 0, 1484262000, '2017-11-15 07:24:07', 1),
(422, 422, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:24:07', 1),
(423, 423, '20000.00', 0, 2017, 0, 1508191200, '2017-11-15 07:24:07', 1),
(424, 424, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:24:07', 1),
(425, 425, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:24:08', 1),
(426, 426, '20000.00', 0, 2017, 0, 1500588000, '2017-11-15 07:24:08', 1),
(427, 427, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:24:08', 1),
(428, 428, '20000.00', 144, 2017, 0, 1484262000, '2017-11-15 07:24:08', 1),
(429, 429, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:24:08', 1),
(430, 430, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 07:24:08', 1),
(431, 431, '20000.00', 0, 2017, 0, 1495144800, '2017-11-15 07:24:09', 1),
(432, 432, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:09', 1),
(433, 433, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:24:09', 1),
(434, 434, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:24:09', 1),
(435, 435, '20000.00', 0, 2017, 0, 1499205600, '2017-11-15 07:24:09', 1),
(436, 436, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:24:09', 1),
(437, 437, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:24:09', 1),
(438, 438, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:10', 1),
(439, 439, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:24:10', 1),
(440, 440, '20000.00', 0, 2017, 0, 1509055200, '2017-11-15 07:24:10', 1),
(441, 441, '20000.00', 93, 2016, 0, 1481583600, '2017-11-15 07:24:10', 1),
(442, 442, '20000.00', 54, 2016, 0, 1477000800, '2017-11-15 07:24:10', 1),
(443, 443, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 07:24:10', 1),
(444, 444, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:24:11', 1),
(445, 445, '20000.00', 0, 2017, 0, 1500415200, '2017-11-15 07:24:11', 1),
(446, 446, '20000.00', 0, 2017, 0, 1493330400, '2017-11-15 07:24:11', 1),
(447, 447, '20000.00', 0, 2017, 0, 1504044000, '2017-11-15 07:24:11', 1),
(448, 448, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:24:11', 1),
(449, 449, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:24:11', 1),
(450, 450, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 07:24:11', 1),
(451, 451, '20000.00', 45, 2016, 0, 1476223200, '2017-11-15 07:24:12', 1),
(452, 452, '20000.00', 0, 2017, 0, 1501106400, '2017-11-15 07:24:12', 1),
(453, 453, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:12', 1),
(454, 454, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 07:24:12', 1),
(455, 455, '20000.00', 0, 2017, 0, 1506895200, '2017-11-15 07:24:13', 1),
(456, 456, '20000.00', 58, 2016, 0, 1477260000, '2017-11-15 07:24:13', 1),
(457, 457, '20000.00', 0, 2017, 0, 1492466400, '2017-11-15 07:24:14', 1),
(458, 458, '20000.00', 0, 2017, 0, 1502229600, '2017-11-15 07:24:14', 1),
(459, 459, '20000.00', 78, 2016, 0, 1479078000, '2017-11-15 07:24:14', 1),
(460, 460, '20000.00', 118, 2017, 0, 1483657200, '2017-11-15 07:24:14', 1),
(461, 461, '20000.00', 0, 2017, 0, 1502402400, '2017-11-15 07:24:14', 1),
(462, 462, '20000.00', 0, 2017, 0, 1501797600, '2017-11-15 07:24:15', 1),
(463, 463, '20000.00', 134, 2017, 0, 1484175600, '2017-11-15 07:24:15', 1),
(464, 464, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 07:24:15', 1),
(465, 465, '20000.00', 59, 2016, 0, 1477260000, '2017-11-15 07:24:15', 1),
(466, 466, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:24:15', 1),
(467, 467, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 07:24:15', 1),
(468, 468, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:24:15', 1),
(469, 469, '20000.00', 0, 2017, 0, 1502143200, '2017-11-15 07:24:16', 1),
(470, 470, '20000.00', 0, 2017, 0, 1503525600, '2017-11-15 07:24:16', 1),
(471, 471, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 07:24:16', 1),
(472, 472, '20000.00', 0, 2017, 0, 1500933600, '2017-11-15 07:24:16', 1),
(473, 473, '20000.00', 14, 2016, 0, 1475013600, '2017-11-15 07:24:16', 1),
(474, 474, '20000.00', 0, 2017, 0, 1502748000, '2017-11-15 07:24:17', 1),
(475, 475, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:24:17', 1),
(476, 476, '20000.00', 17, 2016, 0, 1475013600, '2017-11-15 07:24:17', 1),
(477, 477, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:24:17', 1),
(478, 478, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:24:17', 1),
(479, 479, '20000.00', 121, 2017, 0, 1483657200, '2017-11-15 07:24:18', 1),
(480, 480, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:24:18', 1),
(481, 481, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:24:18', 1),
(482, 482, '20000.00', 0, 2017, 0, 1505685600, '2017-11-15 07:24:18', 1),
(483, 483, '20000.00', 0, 2017, 0, 1502316000, '2017-11-15 07:24:18', 1),
(484, 484, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 07:24:18', 1),
(485, 485, '20000.00', 52, 2016, 0, 1476914400, '2017-11-15 07:24:18', 1),
(486, 486, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 07:24:19', 1),
(487, 487, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 07:24:19', 1),
(488, 488, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:24:19', 1),
(489, 489, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:19', 1),
(490, 490, '20000.00', 4, 2016, 0, 1470693600, '2017-11-15 07:24:19', 1),
(491, 491, '20000.00', 91, 2016, 0, 1480546800, '2017-11-15 07:24:19', 1),
(492, 492, '20000.00', 0, 2017, 0, 1502834400, '2017-11-15 07:24:19', 1),
(493, 493, '20000.00', 0, 2017, 0, 1506549600, '2017-11-15 07:24:20', 1),
(494, 494, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:20', 1),
(495, 495, '20000.00', 147, 2017, 0, 1484262000, '2017-11-15 07:24:20', 1),
(496, 496, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 07:24:20', 1),
(497, 497, '20000.00', 67, 2016, 0, 1477605600, '2017-11-15 07:24:20', 1),
(498, 498, '20000.00', 64, 2016, 0, 1477605600, '2017-11-15 07:24:20', 1),
(499, 499, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:24:21', 1),
(500, 500, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:24:21', 1),
(501, 501, '20000.00', 0, 2017, 0, 1499292000, '2017-11-15 07:24:21', 1),
(502, 502, '25000.00', 0, 2017, 0, 1501711200, '2017-11-15 07:24:21', 1),
(503, 503, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:21', 1),
(504, 504, '20000.00', 19, 2016, 0, 1475100000, '2017-11-15 07:24:22', 1),
(505, 505, '20000.00', 148, 2017, 0, 1484262000, '2017-11-15 07:24:22', 1),
(506, 506, '20000.00', 0, 2017, 0, 1493589600, '2017-11-15 07:24:22', 1),
(507, 507, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 07:24:23', 1),
(508, 508, '20000.00', 0, 2017, 0, 1495058400, '2017-11-15 07:24:23', 1),
(509, 509, '20000.00', 40, 2016, 0, 1475791200, '2017-11-15 07:24:23', 1),
(510, 510, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 07:24:23', 1),
(511, 511, '20000.00', 42, 2016, 0, 1475791200, '2017-11-15 07:24:24', 1),
(512, 512, '20000.00', 0, 2017, 0, 1504562400, '2017-11-15 07:24:24', 1),
(513, 513, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:24:24', 1),
(514, 514, '20000.00', 151, 2017, 0, 1484262000, '2017-11-15 07:24:25', 1),
(515, 515, '20000.00', 85, 2016, 0, 1479942000, '2017-11-15 07:24:25', 1),
(516, 516, '20000.00', 28, 2016, 0, 1475186400, '2017-11-15 07:24:26', 1),
(517, 517, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:24:26', 1),
(518, 518, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 07:24:26', 1),
(519, 519, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 07:24:26', 1),
(520, 520, '20000.00', 0, 2017, 0, 1500501600, '2017-11-15 07:24:26', 1),
(521, 521, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 07:24:27', 1),
(522, 522, '20000.00', 0, 2017, 0, 1507240800, '2017-11-15 07:24:27', 1),
(523, 523, '20000.00', 74, 2016, 0, 1478214000, '2017-11-15 07:24:27', 1),
(524, 524, '20000.00', 60, 2016, 0, 1477260000, '2017-11-15 07:24:27', 1),
(525, 525, '20000.00', 0, 2017, 0, 1493935200, '2017-11-15 07:24:28', 1),
(526, 526, '20000.00', 0, 2017, 0, 1509318000, '2017-11-15 07:24:28', 1),
(527, 527, '20000.00', 0, 2017, 0, 1496786400, '2017-11-15 07:24:28', 1),
(528, 528, '20000.00', 41, 2016, 0, 1476914400, '2017-11-15 07:24:28', 1),
(529, 529, '20000.00', 36, 2016, 0, 1475791200, '2017-11-15 07:24:28', 1),
(530, 530, '20000.00', 0, 2017, 0, 1495058400, '2017-11-15 07:24:28', 1),
(531, 531, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 07:24:28', 1),
(532, 532, '20000.00', 0, 2017, 0, 1492466400, '2017-11-15 07:24:29', 1),
(533, 533, '20000.00', 0, 2017, 0, 1495490400, '2017-11-15 07:24:29', 1),
(534, 534, '20000.00', 0, 2017, 0, 1501106400, '2017-11-15 07:24:29', 1),
(535, 535, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:24:29', 1),
(536, 536, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:24:29', 1),
(537, 537, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 07:24:29', 1),
(538, 538, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:29', 1),
(539, 539, '20000.00', 0, 2017, 0, 1499637600, '2017-11-15 07:24:30', 1),
(540, 540, '20000.00', 69, 2016, 0, 1477954800, '2017-11-15 07:24:30', 1),
(541, 541, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 07:24:30', 1),
(542, 542, '20000.00', 75, 2016, 0, 1478214000, '2017-11-15 07:24:30', 1),
(543, 543, '20000.00', 0, 2017, 0, 1499292000, '2017-11-15 07:24:30', 1),
(544, 544, '20000.00', 141, 2017, 0, 1484262000, '2017-11-15 07:24:30', 1),
(545, 545, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:30', 1),
(546, 546, '20000.00', 156, 2017, 0, 1484262000, '2017-11-15 07:24:31', 1),
(547, 547, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 07:24:31', 1),
(548, 548, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:24:31', 1),
(549, 549, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 07:24:31', 1),
(550, 550, '20000.00', 0, 2017, 0, 1504476000, '2017-11-15 07:24:31', 1),
(551, 551, '20000.00', 0, 2017, 0, 1494453600, '2017-11-15 07:24:31', 1),
(552, 552, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:24:31', 1),
(553, 553, '20000.00', 65, 2016, 0, 1477605600, '2017-11-15 07:24:32', 1),
(554, 554, '20000.00', 37, 2016, 0, 1475791200, '2017-11-15 07:24:32', 1),
(555, 555, '20000.00', 26, 2016, 0, 1475100000, '2017-11-15 07:24:32', 1),
(556, 556, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 07:24:32', 1),
(557, 557, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:32', 1),
(558, 558, '20000.00', 0, 2017, 0, 1502316000, '2017-11-15 07:24:33', 1),
(559, 559, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 07:24:33', 1),
(560, 560, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 07:24:33', 1),
(561, 561, '20000.00', 79, 2016, 0, 1479078000, '2017-11-15 07:24:33', 1),
(562, 562, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 07:24:34', 1),
(563, 563, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 07:24:34', 1),
(564, 564, '20000.00', 0, 2017, 0, 1501106400, '2017-11-15 07:24:35', 1),
(565, 565, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:35', 1),
(566, 566, '20000.00', 152, 2017, 0, 1484262000, '2017-11-15 07:24:35', 1),
(567, 567, '20000.00', 0, 2017, 0, 1507240800, '2017-11-15 07:24:36', 1),
(568, 568, '20000.00', 122, 2017, 0, 1483916400, '2017-11-15 07:24:36', 1),
(569, 569, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 07:24:36', 1),
(570, 570, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 07:24:37', 1),
(571, 571, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:24:37', 1),
(572, 572, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:37', 1),
(573, 573, '20000.00', 90, 2016, 0, 1480546800, '2017-11-15 07:24:37', 1),
(574, 574, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:24:37', 1),
(575, 575, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:24:37', 1),
(576, 576, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:24:38', 1),
(577, 577, '20000.00', 0, 2017, 0, 1506636000, '2017-11-15 07:24:38', 1),
(578, 578, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 07:24:38', 1),
(579, 579, '20000.00', 0, 2017, 0, 1500242400, '2017-11-15 07:24:39', 1),
(580, 580, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:39', 1),
(581, 581, '20000.00', 49, 2016, 0, 1476396000, '2017-11-15 07:24:39', 1),
(582, 582, '20000.00', 10, 2016, 0, 1475013600, '2017-11-15 07:24:39', 1),
(583, 583, '20000.00', 0, 2017, 0, 1503007200, '2017-11-15 07:24:39', 1),
(584, 584, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 07:24:39', 1),
(585, 585, '20000.00', 0, 2017, 0, 1500933600, '2017-11-15 07:24:39', 1),
(586, 586, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 07:24:40', 1),
(587, 587, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 07:24:40', 1),
(588, 588, '20000.00', 12, 2016, 0, 1475013600, '2017-11-15 07:24:40', 1),
(589, 589, '20000.00', 44, 2016, 0, 1476223200, '2017-11-15 07:24:40', 1),
(590, 590, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 07:24:40', 1),
(591, 591, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 07:24:41', 1),
(592, 592, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 07:24:41', 1),
(593, 593, '20000.00', 0, 2017, 0, 1493589600, '2017-11-15 07:24:41', 1),
(594, 594, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 07:24:41', 1),
(595, 595, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:42', 1),
(596, 596, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 07:24:42', 1),
(597, 597, '20000.00', 0, 2017, 0, 1503525600, '2017-11-15 07:24:42', 1),
(598, 598, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 07:24:42', 1),
(599, 599, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:24:42', 1),
(600, 600, '20000.00', 0, 2017, 0, 1491343200, '2017-11-15 07:24:42', 1),
(601, 601, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:43', 1),
(602, 602, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:43', 1),
(603, 603, '20000.00', 0, 2017, 0, 1501452000, '2017-11-15 07:24:43', 1),
(604, 604, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 07:24:43', 1),
(605, 605, '20000.00', 0, 2017, 0, 1506549600, '2017-11-15 07:24:43', 1),
(606, 606, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 07:24:43', 1),
(607, 607, '20000.00', 0, 2017, 0, 1501452000, '2017-11-15 07:24:43', 1),
(608, 608, '20000.00', 0, 2017, 0, 1502402400, '2017-11-15 07:24:43', 1),
(609, 609, '20000.00', 89, 2016, 0, 1480287600, '2017-11-15 07:24:43', 1),
(610, 610, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:44', 1),
(611, 611, '20000.00', 0, 2017, 0, 1499896800, '2017-11-15 07:24:44', 1),
(612, 612, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 07:24:44', 1),
(613, 613, '20000.00', 56, 2016, 0, 1477260000, '2017-11-15 07:24:44', 1),
(614, 614, '20000.00', 2, 2016, 0, 1472594400, '2017-11-15 07:24:44', 1),
(615, 615, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 07:24:45', 1),
(616, 616, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:46', 1),
(617, 617, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 07:24:46', 1),
(618, 618, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 07:24:46', 1),
(619, 619, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 07:24:47', 1),
(620, 620, '20000.00', 158, 2017, 0, 1484694000, '2017-11-15 07:24:47', 1),
(621, 621, '20000.00', 0, 2017, 0, 1506463200, '2017-11-15 07:24:47', 1),
(622, 622, '20000.00', 68, 2016, 0, 1477954800, '2017-11-15 07:24:48', 1),
(623, 623, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:48', 1),
(624, 624, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:24:48', 1),
(625, 625, '20000.00', 6, 2016, 0, 1474236000, '2017-11-15 07:24:48', 1),
(626, 626, '20000.00', 120, 2017, 0, 1483657200, '2017-11-15 07:24:48', 1),
(627, 627, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 07:24:49', 1),
(628, 628, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:24:49', 1),
(629, 629, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:24:49', 1),
(630, 630, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 07:24:49', 1),
(631, 631, '20000.00', 0, 2017, 0, 1502143200, '2017-11-15 07:24:50', 1),
(632, 632, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 07:24:50', 1),
(633, 633, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 07:24:50', 1),
(634, 634, '20000.00', 71, 2016, 0, 1477954800, '2017-11-15 07:24:50', 1),
(635, 635, '20000.00', 95, 2016, 0, 1482274800, '2017-11-15 07:24:50', 1),
(636, 636, '20000.00', 0, 2017, 0, 1491948000, '2017-11-15 07:24:50', 1),
(637, 637, '20000.00', 23, 2016, 0, 1475100000, '2017-11-15 07:24:51', 1),
(638, 638, '20000.00', 0, 2017, 0, 1508450400, '2017-11-15 07:24:51', 1),
(639, 639, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 07:24:51', 1),
(640, 640, '20000.00', 80, 2016, 0, 1479164400, '2017-11-15 07:24:51', 1),
(641, 641, '20000.00', 43, 2016, 0, 1476136800, '2017-11-15 07:24:51', 1),
(642, 642, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:24:51', 1),
(643, 643, '20000.00', 0, 2017, 0, 1504044000, '2017-11-15 07:24:52', 1),
(644, 644, '20000.00', 0, 2017, 0, 1494280800, '2017-11-15 07:24:52', 1),
(645, 645, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:52', 1),
(646, 646, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 07:24:52', 1),
(647, 647, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 07:24:53', 1),
(648, 648, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:24:53', 1),
(649, 649, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 07:24:53', 1),
(650, 650, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 07:24:53', 1),
(651, 651, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 07:24:53', 1),
(652, 652, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 07:24:53', 1),
(653, 653, '20000.00', 0, 2017, 0, 1498168800, '2017-11-15 07:24:53', 1),
(654, 654, '20000.00', 29, 2016, 0, 1475186400, '2017-11-15 07:24:53', 1),
(655, 655, '20000.00', 39, 2016, 0, 1475791200, '2017-11-15 07:24:53', 1),
(656, 656, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:24:54', 1),
(657, 657, '20000.00', 46, 2016, 0, 1476309600, '2017-11-15 07:24:54', 1),
(658, 658, '20000.00', 0, 2017, 0, 1508191200, '2017-11-15 07:24:54', 1),
(659, 659, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:54', 1),
(660, 660, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 07:24:54', 1),
(661, 661, '20000.00', 0, 2017, 0, 1505685600, '2017-11-15 07:24:54', 1),
(662, 662, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 07:24:54', 1),
(663, 663, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 07:24:54', 1),
(664, 664, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 07:24:54', 1),
(665, 665, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 07:24:54', 1),
(666, 666, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 07:24:55', 1),
(667, 667, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:55', 1),
(668, 668, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:55', 1),
(669, 669, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 07:24:55', 1),
(670, 670, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 07:24:56', 1),
(671, 671, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 07:24:56', 1),
(672, 672, '20000.00', 0, 2017, 0, 1499724000, '2017-11-15 07:24:56', 1),
(673, 673, '20000.00', 178, 2017, 0, 1486335600, '2017-11-15 07:24:56', 1),
(674, 674, '20000.00', 160, 2017, 0, 1486422000, '2017-11-15 07:24:57', 1),
(675, 675, '20000.00', 105, 2017, 0, 1485126000, '2017-11-15 07:24:57', 1),
(676, 676, '20000.00', 173, 2017, 0, 1486335600, '2017-11-15 07:24:58', 1),
(677, 677, '20000.00', 0, 2017, 0, 1489014000, '2017-11-15 07:24:58', 1),
(678, 678, '20000.00', 183, 2017, 0, 1486422000, '2017-11-15 07:24:58', 1),
(679, 679, '20000.00', 159, 2017, 0, 1485903600, '2017-11-15 07:24:58', 1),
(680, 680, '20000.00', 112, 2017, 0, 1485730800, '2017-11-15 07:24:59', 1),
(681, 681, '20000.00', 97, 2017, 0, 1483398000, '2017-11-15 07:24:59', 1),
(682, 682, '20000.00', 99, 2017, 0, 1483657200, '2017-11-15 07:24:59', 1),
(683, 683, '20000.00', 111, 2017, 0, 1485730800, '2017-11-15 07:24:59', 1),
(684, 684, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 07:25:00', 1),
(685, 685, '20000.00', 190, 2017, 0, 1487890800, '2017-11-15 07:25:00', 1),
(686, 686, '20000.00', 165, 2017, 0, 1486422000, '2017-11-15 07:25:00', 1),
(687, 687, '20000.00', 169, 2017, 0, 1486594800, '2017-11-15 07:25:00', 1),
(688, 688, '20000.00', 0, 2017, 0, 1490050800, '2017-11-15 07:25:00', 1),
(689, 689, '20000.00', 167, 2017, 0, 1486422000, '2017-11-15 07:25:01', 1),
(690, 690, '20000.00', 166, 2017, 0, 1486422000, '2017-11-15 07:25:01', 1),
(691, 691, '20000.00', 177, 2017, 0, 1486335600, '2017-11-15 07:25:01', 1),
(692, 692, '20000.00', 162, 2017, 0, 1486422000, '2017-11-15 07:25:01', 1);
INSERT INTO `subscription` (`id`, `memberId`, `amount`, `receipt_no`, `subscriptionYear`, `receivedBy`, `datePaid`, `dateModified`, `modifiedBy`) VALUES
(693, 693, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 07:25:01', 1),
(694, 694, '20000.00', 106, 2017, 0, 1485730800, '2017-11-15 07:25:01', 1),
(695, 695, '20000.00', 110, 2017, 0, 1485730800, '2017-11-15 07:25:01', 1),
(696, 696, '20000.00', 174, 2017, 0, 1486335600, '2017-11-15 07:25:02', 1),
(697, 697, '20000.00', 188, 2017, 0, 1487804400, '2017-11-15 07:25:02', 1),
(698, 698, '20000.00', 107, 2017, 0, 1485730800, '2017-11-15 07:25:02', 1),
(699, 699, '20000.00', 108, 2017, 0, 1485730800, '2017-11-15 07:25:02', 1),
(700, 700, '20000.00', 161, 2017, 0, 1486422000, '2017-11-15 07:25:02', 1),
(701, 701, '20000.00', 102, 2017, 0, 1484521200, '2017-11-15 07:25:02', 1),
(702, 702, '20000.00', 164, 2017, 0, 1486422000, '2017-11-15 07:25:03', 1),
(703, 703, '20000.00', 186, 2017, 0, 1487545200, '2017-11-15 07:25:03', 1),
(704, 704, '10000.00', 113, 2017, 0, 1485730800, '2017-11-15 07:25:03', 1),
(705, 705, '20000.00', 168, 2017, 0, 1486594800, '2017-11-15 07:25:03', 1),
(706, 706, '20000.00', 176, 2017, 0, 1486335600, '2017-11-15 07:25:03', 1),
(707, 707, '20000.00', 191, 2017, 0, 1487890800, '2017-11-15 07:25:03', 1),
(708, 708, '20000.00', 172, 2017, 0, 1486335600, '2017-11-15 07:25:04', 1),
(709, 709, '20000.00', 185, 2017, 0, 1486594800, '2017-11-15 07:25:04', 1),
(710, 710, '20000.00', 192, 2017, 0, 1488150000, '2017-11-15 07:25:04', 1),
(711, 711, '20000.00', 171, 2017, 0, 1486335600, '2017-11-15 07:25:04', 1),
(712, 712, '20000.00', 0, 2017, 0, 1490050800, '2017-11-15 07:25:04', 1),
(713, 713, '20000.00', 180, 2017, 0, 1486422000, '2017-11-15 07:25:04', 1),
(714, 714, '20000.00', 98, 2017, 0, 1483657200, '2017-11-15 07:25:04', 1),
(715, 715, '20000.00', 0, 2017, 0, 1490223600, '2017-11-15 07:25:04', 1),
(716, 716, '20000.00', 103, 2017, 0, 1484780400, '2017-11-15 07:25:04', 1),
(717, 717, '20000.00', 193, 2017, 0, 1488150000, '2017-11-15 07:25:05', 1),
(718, 718, '20000.00', 114, 2017, 0, 1483570800, '2017-11-15 07:25:05', 1),
(719, 719, '20000.00', 194, 2017, 0, 1489100400, '2017-11-15 07:25:05', 1),
(720, 720, '20000.00', 195, 2017, 0, 1489100400, '2017-11-15 07:25:05', 1),
(721, 721, '20000.00', 175, 2017, 0, 1486335600, '2017-11-15 07:25:05', 1),
(722, 722, '20000.00', 187, 2017, 0, 1487631600, '2017-11-15 07:25:05', 1),
(723, 723, '20000.00', 104, 2017, 0, 1484780400, '2017-11-15 07:25:05', 1),
(724, 724, '20000.00', 181, 2017, 0, 1486422000, '2017-11-15 07:25:06', 1),
(725, 725, '20000.00', 196, 2017, 0, 1489532400, '2017-11-15 07:25:06', 1),
(726, 726, '20000.00', 184, 2017, 0, 1486508400, '2017-11-15 07:25:06', 1),
(727, 727, '20000.00', 163, 2017, 0, 1486422000, '2017-11-15 07:25:07', 1),
(728, 728, '20000.00', 100, 2017, 0, 1483916400, '2017-11-15 07:25:07', 1),
(729, 729, '20000.00', 109, 2017, 0, 1485730800, '2017-11-15 07:25:07', 1),
(730, 730, '20000.00', 101, 2017, 0, 1484262000, '2017-11-15 07:25:08', 1),
(731, 731, '20000.00', 170, 2017, 0, 1486594800, '2017-11-15 07:25:08', 1),
(732, 732, '20000.00', 179, 2017, 0, 1486422000, '2017-11-15 07:25:08', 1),
(733, 733, '20000.00', 189, 2017, 0, 1487804400, '2017-11-15 07:25:08', 1),
(734, 734, '20000.00', 182, 2017, 0, 1486422000, '2017-11-15 07:25:09', 1),
(735, 735, '20000.00', 0, 2017, 0, 1488495600, '2017-11-15 07:25:09', 1),
(736, 736, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 07:25:09', 1),
(737, 745, '20000.00', 11, 2016, 0, 1474243200, '2017-11-22 09:04:12', 1),
(738, 746, '20000.00', 12, 2016, 0, 1474243200, '2017-11-22 09:04:12', 1),
(739, 747, '20000.00', 13, 2016, 0, 1474243200, '2017-11-22 09:04:12', 1),
(740, 748, '20000.00', 14, 2016, 0, 1475020800, '2017-11-22 09:04:12', 1),
(741, 749, '20000.00', 15, 2016, 0, 1475020800, '2017-11-22 09:04:12', 1),
(742, 750, '20000.00', 16, 2016, 0, 1475020800, '2017-11-22 09:04:12', 1),
(743, 751, '20000.00', 22, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(744, 752, '20000.00', 23, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(745, 753, '20000.00', 24, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(746, 754, '20000.00', 25, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(747, 755, '20000.00', 27, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(748, 756, '20000.00', 28, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(749, 757, '20000.00', 29, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(750, 758, '20000.00', 30, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(751, 759, '20000.00', 31, 2016, 0, 1475107200, '2017-11-22 09:04:12', 1),
(752, 760, '20000.00', 32, 2016, 0, 1475193600, '2017-11-22 09:04:12', 1),
(753, 761, '20000.00', 33, 2016, 0, 1475193600, '2017-11-22 09:04:12', 1),
(754, 762, '20000.00', 75, 2016, 0, 1477526400, '2017-11-22 09:04:12', 1),
(755, 763, '20000.00', 76, 2016, 0, 1477526400, '2017-11-22 09:04:12', 1),
(756, 764, '20000.00', 80, 2016, 0, 1477612800, '2017-11-22 09:04:12', 1),
(757, 765, '20000.00', 81, 2016, 0, 1477612800, '2017-11-22 09:04:12', 1),
(758, 766, '20000.00', 82, 2016, 0, 1477612800, '2017-11-22 09:04:12', 1);

-- --------------------------------------------------------

--
-- Table structure for table `systemaccesslogs`
--

CREATE TABLE `systemaccesslogs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date_logged_in` datetime NOT NULL,
  `date_logged_out` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tax_rate_source`
--

CREATE TABLE `tax_rate_source` (
  `id` int(11) NOT NULL,
  `description` varchar(100) NOT NULL,
  `taxRate` decimal(4,2) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Unix timestamp for the datetime of addition',
  `createdBy` int(11) NOT NULL COMMENT 'Reference to the staff that added this entry',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Unix timestamp for the datetime modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff that modified this entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_district`
--

CREATE TABLE `tbl_district` (
  `id` int(10) UNSIGNED NOT NULL,
  `district_name` varchar(50) NOT NULL,
  `fk_zone_id` tinyint(2) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Districts in Uganda';

--
-- Dumping data for table `tbl_district`
--

INSERT INTO `tbl_district` (`id`, `district_name`, `fk_zone_id`) VALUES
(1, 'ABIM', 9),
(2, 'ADJUMANI', 7),
(3, 'AGAGO', 0),
(4, 'ALEBTONG', 8),
(5, 'AMOLATAR', 8),
(6, 'AMUDAT', 16),
(7, 'AMURIA', 13),
(8, 'AMURU', 0),
(9, 'APAC', 8),
(10, 'ARUA', 7),
(11, 'BUDAKA', 0),
(12, 'BUDUDA', 15),
(13, 'BUGIRI', 4),
(14, 'BUHWEJU', 0),
(15, 'BUIKWE', 3),
(16, 'BUKEDEA', 13),
(17, 'BUKOMANSIMBI', 6),
(18, 'BUKWO', 15),
(19, 'BULAMBULI', 0),
(20, 'BULIISA', 0),
(21, 'BUNDIBUGYO', 0),
(22, 'BUSHENYI', 10),
(23, 'BUSIA', 15),
(24, 'BUTALEJA', 15),
(25, 'BUTAMBALA', 5),
(26, 'BUVUMA', 0),
(27, 'BUYENDE', 4),
(28, 'DOKOLO', 8),
(29, 'GOMBA', 5),
(30, 'GULU', 8),
(31, 'HOIMA', 12),
(32, 'IBANDA', 10),
(33, 'IGANGA', 4),
(34, 'ISINGIRO', 0),
(35, 'JINJA', 4),
(36, 'KAABONG', 9),
(37, 'KABALE', 10),
(38, 'KABAROLE', 11),
(39, 'KABERAMAIDO', 13),
(40, 'KALANGALA', 6),
(41, 'KALIRO', 4),
(42, 'KALUNGU', 6),
(43, 'KAMPALA', 1),
(44, 'KAMULI', 4),
(45, 'KAMWENGE', 0),
(46, 'KANUNGU', 0),
(47, 'KAPCHORWA', 15),
(48, 'KASESE', 11),
(49, 'KATAKWI', 13),
(50, 'KAYUNGA', 3),
(51, 'KIBAALE', 12),
(52, 'KIBOGA', 12),
(53, 'KIBUKU', 15),
(54, 'KIRUHURA', 10),
(55, 'KIRYANDONGO', 0),
(56, 'KISORO', 0),
(57, 'KITGUM', 8),
(58, 'KOBOKO', 7),
(59, 'KOLE', 8),
(60, 'KOTIDO', 9),
(61, 'KUMI', 13),
(62, 'KWEEN', 15),
(63, 'KYANKWANZI', 0),
(64, 'KYEGEGWA', 11),
(65, 'KYENJOJO', 11),
(66, 'LAMWO', 0),
(67, 'LIRA', 8),
(68, 'LUUKA', 4),
(69, 'LUWEERO', 5),
(70, 'LWENGO', 6),
(71, 'LYANTONDE', 0),
(72, 'MANAFWA', 15),
(73, 'MARACHA', 7),
(74, 'MASAKA', 6),
(75, 'MASINDI', 12),
(76, 'MAYUGE', 4),
(77, 'MBALE', 15),
(78, 'MBARARA', 10),
(79, 'MITOOMA', 0),
(80, 'MITYANA', 5),
(81, 'MOROTO', 16),
(82, 'MOYO', 7),
(83, 'MPIGI', 5),
(84, 'MUBENDE', 11),
(85, 'MUKONO', 3),
(86, 'NAKAPIRIPIRIT', 16),
(87, 'NAKASEKE', 5),
(88, 'NAKASONGOLA', 5),
(89, 'NAMAYINGO', 4),
(90, 'NAMUTUMBA', 4),
(91, 'NAPAK', 16),
(92, 'NEBBI', 7),
(93, 'NGORA', 13),
(94, 'NTOROKO', 0),
(95, 'NTUNGAMO', 10),
(96, 'NWOYA', 8),
(97, 'OTUKE', 0),
(98, 'OYAM', 8),
(99, 'PADER', 8),
(100, 'PALLISA', 15),
(101, 'RAKAI', 6),
(102, 'RUBIRIZI', 0),
(103, 'RUKUNGIRI', 10),
(104, 'SERERE', 13),
(105, 'SHEEMA', 0),
(106, 'SIRONKO', 15),
(107, 'SOROTI', 13),
(108, 'SSEMBABULE', 6),
(109, 'TORORO', 15),
(110, 'WAKISO', 2),
(111, 'YUMBE', 7),
(112, 'ZOMBO', 7);

-- --------------------------------------------------------

--
-- Table structure for table `time_units`
--

CREATE TABLE `time_units` (
  `id` int(11) NOT NULL,
  `time_unit` varbinary(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Time units definitions';

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

CREATE TABLE `transaction` (
  `id` int(11) NOT NULL,
  `transaction_type` varchar(45) NOT NULL,
  `branch_number` varchar(45) NOT NULL,
  `personId` int(11) NOT NULL,
  `amount` varchar(45) NOT NULL,
  `amount_description` varchar(256) NOT NULL,
  `transacted_by` varchar(100) NOT NULL,
  `transaction_date` date NOT NULL,
  `approved_by` varchar(45) NOT NULL,
  `comments` text NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `transfer`
--

CREATE TABLE `transfer` (
  `id` int(11) NOT NULL,
  `bank` int(11) NOT NULL,
  `deposited_from` int(11) NOT NULL,
  `from_bank_branch` int(11) NOT NULL,
  `from_branch` int(11) NOT NULL,
  `to_branch` int(11) NOT NULL,
  `account_number` varchar(100) NOT NULL,
  `amount` text NOT NULL,
  `transfered_by` int(11) NOT NULL,
  `transfer_date` date NOT NULL,
  `added_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accesslevel`
--
ALTER TABLE `accesslevel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `address_type`
--
ALTER TABLE `address_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deposit_account`
--
ALTER TABLE `deposit_account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkDepositProductId` (`depositProductId`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `account_no` (`account_no`);

--
-- Indexes for table `deposit_account_fee`
--
ALTER TABLE `deposit_account_fee`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deposit_account_transaction`
--
ALTER TABLE `deposit_account_transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`depositAccountId`);

--
-- Indexes for table `deposit_product`
--
ALTER TABLE `deposit_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkCreatedBy` (`createdBy`);

--
-- Indexes for table `deposit_product_fee`
--
ALTER TABLE `deposit_product_fee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkDateModified` (`dateModified`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `fkDateCreated` (`dateCreated`);

--
-- Indexes for table `deposit_product_feen`
--
ALTER TABLE `deposit_product_feen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`) USING BTREE;

--
-- Indexes for table `deposit_product_type`
--
ALTER TABLE `deposit_product_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `expensetypes`
--
ALTER TABLE `expensetypes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fee_type`
--
ALTER TABLE `fee_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `group_deposit_account`
--
ALTER TABLE `group_deposit_account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkDepositAccountId` (`depositAccountId`),
  ADD KEY `fkSaccoGroupId` (`saccoGroupId`);

--
-- Indexes for table `group_loan_account`
--
ALTER TABLE `group_loan_account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkGroupId` (`saccoGroupId`),
  ADD KEY `fkLoanId` (`loanProductId`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkMemberId` (`memberId`),
  ADD KEY `fkGroupId` (`groupId`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkCreatedBy` (`createdBy`);

--
-- Indexes for table `guarantor`
--
ALTER TABLE `guarantor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `id_card_types`
--
ALTER TABLE `id_card_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `income`
--
ALTER TABLE `income`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `income_sources`
--
ALTER TABLE `income_sources`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `individual_type`
--
ALTER TABLE `individual_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_account`
--
ALTER TABLE `loan_account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkGroupLoanAccountId` (`groupLoanAccountId`);

--
-- Indexes for table `loan_account_approval`
--
ALTER TABLE `loan_account_approval`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkLoanAccountId` (`loanAccountId`),
  ADD KEY `fkStaffAccountId` (`staffId`);

--
-- Indexes for table `loan_account_fee`
--
ALTER TABLE `loan_account_fee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkLoanAccountId` (`loanAccountId`) USING BTREE,
  ADD KEY `fkLoanProductFeeId` (`loanProductFeenId`) USING BTREE;

--
-- Indexes for table `loan_account_penalty`
--
ALTER TABLE `loan_account_penalty`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `penaltyId` (`penaltyCalculationMethod`),
  ADD KEY `fkLoanId` (`loanAccountId`) USING BTREE;

--
-- Indexes for table `loan_collateral`
--
ALTER TABLE `loan_collateral`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loanAccountId`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `createdBy` (`createdBy`);

--
-- Indexes for table `loan_documents`
--
ALTER TABLE `loan_documents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_products`
--
ALTER TABLE `loan_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkAvailableTO` (`availableTo`),
  ADD KEY `fkTaxRateSource` (`taxRateSource`),
  ADD KEY `fkTaxCalculationMethod` (`taxCalculationMethod`),
  ADD KEY `fkLinkToDepositAccount` (`linkToDepositAccount`) USING BTREE,
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`);

--
-- Indexes for table `loan_products_penalty`
--
ALTER TABLE `loan_products_penalty`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkCreatedBy` (`createBy`),
  ADD KEY `penaltyChargedAs` (`penaltyChargedAs`),
  ADD KEY `fkPenaltyCalcMethod` (`penaltyCalculationMethodId`);

--
-- Indexes for table `loan_product_fee`
--
ALTER TABLE `loan_product_fee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateCreated` (`dateCreated`);

--
-- Indexes for table `loan_product_feen`
--
ALTER TABLE `loan_product_feen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`) USING BTREE;

--
-- Indexes for table `loan_product_type`
--
ALTER TABLE `loan_product_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_repayment`
--
ALTER TABLE `loan_repayment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loanAccountId`),
  ADD KEY `transaction_date` (`transactionDate`),
  ADD KEY `recieving_staff` (`recievedBy`);

--
-- Indexes for table `marital_status`
--
ALTER TABLE `marital_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id`),
  ADD KEY `added_by` (`addedBy`),
  ADD KEY `person_id` (`personId`);

--
-- Indexes for table `member_deposit_account`
--
ALTER TABLE `member_deposit_account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkDepositAccountId` (`depositAccountId`);

--
-- Indexes for table `member_loan_account`
--
ALTER TABLE `member_loan_account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkMemberId` (`memberId`),
  ADD KEY `fkLoanId` (`loanAccountId`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`);

--
-- Indexes for table `other_settings`
--
ALTER TABLE `other_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `penalty_calculation_method`
--
ALTER TABLE `penalty_calculation_method`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `fkModifiedBy` (`modifiedBy`) USING BTREE;

--
-- Indexes for table `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_type` (`id_type`),
  ADD KEY `registered_by` (`registered_by`);

--
-- Indexes for table `persontype`
--
ALTER TABLE `persontype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `person_address`
--
ALTER TABLE `person_address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `person_business`
--
ALTER TABLE `person_business`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `person_employment`
--
ALTER TABLE `person_employment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `person_relative`
--
ALTER TABLE `person_relative`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`personId`);

--
-- Indexes for table `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `relationship_type`
--
ALTER TABLE `relationship_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `saccogroup`
--
ALTER TABLE `saccogroup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `modifiedBy` (`modifiedBy`),
  ADD KEY `createdBy` (`createdBy`);

--
-- Indexes for table `securitytype`
--
ALTER TABLE `securitytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shares`
--
ALTER TABLE `shares`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`memberId`);

--
-- Indexes for table `share_rate`
--
ALTER TABLE `share_rate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`personId`),
  ADD KEY `branch_id` (`branch_id`),
  ADD KEY `person_id_2` (`personId`),
  ADD KEY `person_id_3` (`personId`);

--
-- Indexes for table `staff_roles`
--
ALTER TABLE `staff_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`memberId`);

--
-- Indexes for table `systemaccesslogs`
--
ALTER TABLE `systemaccesslogs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tax_rate_source`
--
ALTER TABLE `tax_rate_source`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_district`
--
ALTER TABLE `tbl_district`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_region_id` (`fk_zone_id`);

--
-- Indexes for table `time_units`
--
ALTER TABLE `time_units`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`personId`);

--
-- Indexes for table `transfer`
--
ALTER TABLE `transfer`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accesslevel`
--
ALTER TABLE `accesslevel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `address_type`
--
ALTER TABLE `address_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `deposit_account`
--
ALTER TABLE `deposit_account`
  MODIFY `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `deposit_account_fee`
--
ALTER TABLE `deposit_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deposit_account_transaction`
--
ALTER TABLE `deposit_account_transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `deposit_product`
--
ALTER TABLE `deposit_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `deposit_product_fee`
--
ALTER TABLE `deposit_product_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deposit_product_feen`
--
ALTER TABLE `deposit_product_feen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deposit_product_type`
--
ALTER TABLE `deposit_product_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expensetypes`
--
ALTER TABLE `expensetypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fee_type`
--
ALTER TABLE `fee_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `gender`
--
ALTER TABLE `gender`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `group_deposit_account`
--
ALTER TABLE `group_deposit_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group_loan_account`
--
ALTER TABLE `group_loan_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `guarantor`
--
ALTER TABLE `guarantor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `id_card_types`
--
ALTER TABLE `id_card_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `income`
--
ALTER TABLE `income`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `income_sources`
--
ALTER TABLE `income_sources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `individual_type`
--
ALTER TABLE `individual_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `loan_account`
--
ALTER TABLE `loan_account`
  MODIFY `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;

--
-- AUTO_INCREMENT for table `loan_account_approval`
--
ALTER TABLE `loan_account_approval`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=393;

--
-- AUTO_INCREMENT for table `loan_account_fee`
--
ALTER TABLE `loan_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=585;

--
-- AUTO_INCREMENT for table `loan_account_penalty`
--
ALTER TABLE `loan_account_penalty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loan_collateral`
--
ALTER TABLE `loan_collateral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loan_products`
--
ALTER TABLE `loan_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `loan_products_penalty`
--
ALTER TABLE `loan_products_penalty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loan_product_fee`
--
ALTER TABLE `loan_product_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loan_product_feen`
--
ALTER TABLE `loan_product_feen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `loan_product_type`
--
ALTER TABLE `loan_product_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `loan_repayment`
--
ALTER TABLE `loan_repayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `marital_status`
--
ALTER TABLE `marital_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=973;

--
-- AUTO_INCREMENT for table `member_deposit_account`
--
ALTER TABLE `member_deposit_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `member_loan_account`
--
ALTER TABLE `member_loan_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `other_settings`
--
ALTER TABLE `other_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `penalty_calculation_method`
--
ALTER TABLE `penalty_calculation_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=985;

--
-- AUTO_INCREMENT for table `persontype`
--
ALTER TABLE `persontype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `person_address`
--
ALTER TABLE `person_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `person_business`
--
ALTER TABLE `person_business`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=218;

--
-- AUTO_INCREMENT for table `person_employment`
--
ALTER TABLE `person_employment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=214;

--
-- AUTO_INCREMENT for table `person_relative`
--
ALTER TABLE `person_relative`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=219;

--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `relationship_type`
--
ALTER TABLE `relationship_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `saccogroup`
--
ALTER TABLE `saccogroup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `securitytype`
--
ALTER TABLE `securitytype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `shares`
--
ALTER TABLE `shares`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `share_rate`
--
ALTER TABLE `share_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `staff_roles`
--
ALTER TABLE `staff_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=759;

--
-- AUTO_INCREMENT for table `systemaccesslogs`
--
ALTER TABLE `systemaccesslogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_rate_source`
--
ALTER TABLE `tax_rate_source`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_district`
--
ALTER TABLE `tbl_district`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT for table `time_units`
--
ALTER TABLE `time_units`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transfer`
--
ALTER TABLE `transfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
