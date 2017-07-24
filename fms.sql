-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2017 at 04:29 PM
-- Server version: 10.1.13-MariaDB
-- PHP Version: 5.5.35

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

CREATE DEFINER=`root`@`localhost` FUNCTION `ImmediateDueDate` (`disbursementDate` DATETIME, `installments` TINYINT(2), `time_unit` TINYINT(1), `repaymentsFreq` TINYINT(1), `start_date` DATETIME) RETURNS DATE NO SQL
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
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accesslevel`
--

INSERT INTO `accesslevel` (`id`, `name`, `description`) VALUES
(1, 'Administrator', 'Over all user of the system'),
(2, 'Loan Officers', 'General operating Staff'),
(3, 'Branch Managers', 'Manager of the organisation'),
(4, 'Branch Credit Committee', 'Executive commite member'),
(5, 'Management Credit Committee\r\n', NULL),
(6, 'Executive board committe', NULL);

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
  `email_address` varchar(156) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`id`, `branch_number`, `branch_name`, `physical_address`, `office_phone`, `postal_address`, `email_address`) VALUES
(6, '', 'Muganzirwaza', 'Kampala', '(073) 000-0000', 'kampala', 'info@buladde.or.ug');

-- --------------------------------------------------------

--
-- Table structure for table `counties`
--

CREATE TABLE `counties` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `district_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `countries` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `deposit_account` (
  `id` int(11) NOT NULL,
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

INSERT INTO `deposit_account` (`id`, `depositProductId`, `recomDepositAmount`, `maxWithdrawalAmount`, `interestRate`, `openingBalance`, `termLength`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, '10000.00', '500000.00', '0.00', '500000.00', 1, 1499160187, 0, 1499160187, 2),
(2, 4, '10000.00', '500000.00', '0.00', '400000.00', 12, 1499160651, 0, 1499160651, 2);

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

--
-- Dumping data for table `deposit_account_fee`
--

INSERT INTO `deposit_account_fee` (`id`, `depositProductFeeId`, `depositAccountId`, `amount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 1, '1000.00', 1499160187, 2, 1499160187, 2),
(2, 0, 0, '1000.00', 1499160651, 2, 1499160651, 2);

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
(1, 2, '70000.00', 'Well received', 1, 2, 1499160742, '0000-00-00 00:00:00', 2),
(2, 1, '670000.00', '', 1, 1, 1499625806, '0000-00-00 00:00:00', 1),
(3, 1, '70000.00', 'returning', 2, 1, 1499625873, '0000-00-00 00:00:00', 1),
(4, 1, '40000.00', 'Deposited by Andrew Olokojo', 1, 1, 1499626389, '0000-00-00 00:00:00', 1),
(5, 1, '450000.00', 'Received by the accountant as is', 1, 1, 1499626536, '0000-00-00 00:00:00', 1);

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
  `modifiedBy` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Deposit Products Table';

--
-- Dumping data for table `deposit_product`
--

INSERT INTO `deposit_product` (`id`, `productName`, `description`, `productType`, `availableTo`, `recommededDepositAmount`, `maxWithdrawalAmount`, `interestPaid`, `defaultInterestRate`, `minInterestRate`, `maxInterestRate`, `perNoOfDays`, `accountBalForCalcInterest`, `whenInterestIsPaid`, `daysInYear`, `applyWHTonInterest`, `defaultOpeningBal`, `minOpeningBal`, `maxOpeningBal`, `defaultTermLength`, `minTermLength`, `maxTermLength`, `termTimeUnit`, `allowArbitraryFees`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Keba account', ' Keba Savings club', 1, 1, '10000.00', '500000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '10000.00', '5000.00', '0.00', 1, 1, 30, 1, 0, 1498485472, 1, 1498485472, '0000-00-00 00:00:00'),
(4, 'Group Plus', ' Group Savings ', 1, 1, '10000.00', '500000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '10000.00', '5000.00', '0.00', 12, 12, 12, 3, 0, 1498486182, 1, 1498486182, '0000-00-00 00:00:00'),
(5, 'Individual Savings Account', 'individual', 1, 1, '10000.00', '500000.00', 0, '1.00', '1.00', '1.00', 30, 1, 1, 2, 0, '10000.00', '10000.00', '10000.00', 12, 1, 12, 3, 0, 1498486623, 1, 1498486623, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `deposit_product_fee`
--

CREATE TABLE `deposit_product_fee` (
  `id` int(11) NOT NULL,
  `feeName` varchar(150) NOT NULL,
  `depositProductID` int(11) NOT NULL COMMENT 'ID of the deposit product',
  `amount` decimal(12,2) NOT NULL,
  `chargeTrigger` tinyint(2) NOT NULL,
  `dateApplicationMethod` tinyint(1) DEFAULT NULL COMMENT '1-Manual, 2-Monthly',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a deposit product';

--
-- Dumping data for table `deposit_product_fee`
--

INSERT INTO `deposit_product_fee` (`id`, `feeName`, `depositProductID`, `amount`, `chargeTrigger`, `dateApplicationMethod`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(2, 'Account Maintenance', 2, '1000.00', 2, 1, 1498485490, 1, '0000-00-00 00:00:00', 1);

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
(2, 'Fixed Deposit ', 'clients make deposits to open the account and can only withdraw the money after an established period of time. The account can''t be closed or withdrawn before the end of that period.', 280092020, '0000-00-00 00:00:00', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `country_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `modifiedBy` int(11) NOT NULL COMMENT 'Staff who modified the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `expense`
--

INSERT INTO `expense` (`id`, `expenseName`, `staff`, `expenseType`, `amountUsed`, `amountDescription`, `createdBy`, `expenseDate`, `dateModified`, `modifiedBy`) VALUES
(1, 'Air time', 1, 1, '100000.00', 'Money used to bus airtime to call due clients', 1, 1498658846, '2017-06-28 14:08:31', 1);

-- --------------------------------------------------------

--
-- Table structure for table `expensetypes`
--

CREATE TABLE `expensetypes` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `loanAccountId` int(11) NOT NULL COMMENT 'Reference key to the loan account',
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_loan_account`
--

INSERT INTO `group_loan_account` (`id`, `saccoGroupId`, `loanAccountId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 2, 0, 1499134023, 1, '0000-00-00 00:00:00', 1),
(2, 2, 1, 1499135099, 1, '0000-00-00 00:00:00', 1);

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

CREATE TABLE `guarantor` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL COMMENT 'Fk reference to member Id',
  `loanAccountId` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `id_card_types` (
  `id` int(11) NOT NULL,
  `id_type` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `income` (
  `id` int(11) NOT NULL,
  `incomeType` int(11) NOT NULL COMMENT 'ID for the income type',
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
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `individual_type` (
  `1` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `loan_account` (
  `id` int(11) NOT NULL,
  `loanNo` varchar(45) DEFAULT NULL,
  `branch_id` int(11) NOT NULL COMMENT 'Branch id the loan was taken out from',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Partial_Application, 2-Pending Approval, 3-Approved',
  `loanProductId` int(11) NOT NULL COMMENT 'Reference to the loan product',
  `requestedAmount` decimal(15,2) NOT NULL COMMENT 'Amount applied for',
  `applicationDate` int(11) NOT NULL COMMENT 'Date loan was applied for',
  `disbursedAmount` decimal(15,2) DEFAULT NULL COMMENT 'Amount disbursed to client',
  `disbursementDate` int(11) DEFAULT NULL COMMENT 'Date loan was disbursed',
  `disbursementNotes` text,
  `interestRate` decimal(4,2) NOT NULL,
  `offSetPeriod` tinyint(4) NOT NULL COMMENT 'Time unit to offset the loan',
  `loanPeriod` tinyint(4) DEFAULT NULL COMMENT 'Period the loan will take',
  `gracePeriod` tinyint(4) NOT NULL,
  `repaymentsFrequency` tinyint(2) NOT NULL,
  `repaymentsMadeEvery` tinyint(4) NOT NULL COMMENT '1 - Day, 2-Week, 3 - Month',
  `installments` tinyint(4) NOT NULL COMMENT 'Number of repayment installments',
  `penaltyCalculationMethodId` tinyint(2) DEFAULT NULL,
  `penaltyTolerancePeriod` tinyint(4) DEFAULT NULL,
  `penaltyRateChargedPer` tinyint(1) DEFAULT NULL,
  `penaltyRate` decimal(4,2) DEFAULT NULL,
  `linkToDepositAccount` tinyint(1) NOT NULL COMMENT 'Link to deposit Account for repayments',
  `expectedPayback` decimal(15,2) DEFAULT NULL,
  `dailyDefaultAmount` decimal(4,2) DEFAULT NULL,
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

INSERT INTO `loan_account` (`id`, `loanNo`, `branch_id`, `status`, `loanProductId`, `requestedAmount`, `applicationDate`, `disbursedAmount`, `disbursementDate`, `disbursementNotes`, `interestRate`, `offSetPeriod`, `loanPeriod`, `gracePeriod`, `repaymentsFrequency`, `repaymentsMadeEvery`, `installments`, `penaltyCalculationMethodId`, `penaltyTolerancePeriod`, `penaltyRateChargedPer`, `penaltyRate`, `linkToDepositAccount`, `expectedPayback`, `dailyDefaultAmount`, `comments`, `amountApproved`, `approvalDate`, `approvedBy`, `approvalNotes`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, '-1707042459', 0, 4, 1, '2300000.00', 1499115600, '2300000.00', 1499154151, 'Full amount disbursed', '13.00', 1, NULL, 2, 1, 3, 4, 2, 7, 3, '0.00', 0, NULL, NULL, '', '2300000.00', 1499153695, 2, NULL, 1, 1499135099, 1, '2017-07-04 07:42:31'),
(2, 'L1707105718', 0, 1, 2, '1000000.00', 1498942800, '0.00', 0, NULL, '7.90', 3, NULL, 1, 1, 3, 1, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1499666238, 1, '0000-00-00 00:00:00'),
(3, 'L1707100621', 0, 1, 2, '1000000.00', 1498942800, '0.00', 0, NULL, '7.90', 3, NULL, 1, 1, 3, 1, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1499666781, 1, '0000-00-00 00:00:00'),
(4, 'L1707100954', 0, 1, 2, '1000000.00', 1498942800, '0.00', 0, NULL, '7.90', 3, NULL, 1, 1, 3, 1, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1499666994, 1, '0000-00-00 00:00:00'),
(5, 'L1707101059', 0, 1, 2, '1000000.00', 1498942800, '0.00', 0, NULL, '7.90', 3, NULL, 1, 1, 3, 1, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1499667059, 1, '0000-00-00 00:00:00'),
(6, 'L1707174841', 0, 1, 2, '300000.00', 1500238800, '0.00', 0, NULL, '9.80', 4, NULL, 1, 1, 3, 1, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1500317321, 1, '0000-00-00 00:00:00'),
(7, 'L1707175147', 0, 1, 2, '400000.00', 1500238800, '0.00', 0, NULL, '9.80', 4, NULL, 1, 1, 3, 1, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, NULL, NULL, NULL, 1, 1500317507, 1, '0000-00-00 00:00:00');

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
  `attachmentUrl` varchar(30) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_collateral`
--

INSERT INTO `loan_collateral` (`id`, `loanAccountId`, `itemName`, `description`, `itemValue`, `attachmentUrl`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 5, 'Motor vehicle', 'Harrier 4 seater, black, UAJ 432B. Log book provided', '4500000.00', 'undefined', 1499667059, 1, '2017-07-10 06:10:59', 1),
(2, 6, 'Beds', '4 metallic beds valued at 300k each', '1200000.00', 'undefined', 1500317322, 1, '2017-07-17 18:48:42', 1),
(3, 7, 'Beds', '4 metallic beds valued at 300k each', '300000.00', 'undefined', 1500317507, 1, '2017-07-17 18:51:47', 1);

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
(1, 'Group Loan', ' Loan to be disbursed to Sacco members group', 1, 1, 2, '5000000.00', '2000000.00', '10000000.00', 1, '15.00', '10.00', '30.00', 1, 3, 6, 1, 6, 1, 7, 1, 7, '40.00', 3, 1, 1, 3, NULL, 2, 7, 3, '10.00', '0.00', '10.00', 0, 1, 1, 0, 1498482882, 1, '0000-00-00 00:00:00', 1),
(2, 'Quick Loan', 'Loan disbursed like immediately', 1, 1, 1, '100000.00', '100000.00', '1000000.00', 1, '5.00', '5.00', '30.00', 1, 3, 1, 1, 1, 1, 1, 1, 1, '60.00', 0, 30, 0, 30, NULL, 2, 1, 1, '5.00', '5.00', '5.00', 0, 1, 1, 1, 1498485018, 1, '0000-00-00 00:00:00', 1);

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

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_feen`
--

CREATE TABLE `loan_product_feen` (
  `id` int(11) NOT NULL,
  `loanProductId` int(11) NOT NULL,
  `loanProductFeeId` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a loan product';

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
(1, 'Fixed Term Loan', 'A Fixed interest rate which allows accurate prediction of future payments', 0, '2017-06-26 13:35:13', 0, 0),
(2, 'Dynamic Term Loan', 'Allows dynamic calculation of the interest rate, and thus, future payments\r\n', 0, '2017-06-26 13:35:40', 0, 0);

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

--
-- Dumping data for table `loan_repayment`
--

INSERT INTO `loan_repayment` (`id`, `transactionId`, `branch_id`, `loanAccountId`, `amount`, `transactionType`, `comments`, `transactionDate`, `recievedBy`, `dateModified`, `modifiedBy`) VALUES
(1, 0, NULL, 1, '67000.00', NULL, 'Great service from our client', 1499155090, 2, 1499155090, 2);

-- --------------------------------------------------------

--
-- Table structure for table `marital_status`
--

CREATE TABLE `marital_status` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 3, 1, 0, 0, '0000-00-00 00:00:00', 2),
(2, 3, 2, 0, 0, '0000-00-00 00:00:00', 2);

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

--
-- Dumping data for table `member_loan_account`
--

INSERT INTO `member_loan_account` (`id`, `memberId`, `loanAccountId`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 4, 2, 1499666238, 1, '0000-00-00 00:00:00', 1),
(2, 4, 3, 1499666781, 1, '0000-00-00 00:00:00', 1),
(3, 4, 4, 1499666994, 1, '0000-00-00 00:00:00', 1),
(4, 4, 5, 1499667059, 1, '0000-00-00 00:00:00', 1),
(5, 5, 6, 1500317321, 1, '0000-00-00 00:00:00', 1),
(6, 3, 7, 1500317507, 1, '0000-00-00 00:00:00', 1);

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
-- Table structure for table `parish`
--

CREATE TABLE `parish` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `subcounty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
(1, 'Mr', 2, 'S161116102242', 'Alfred', 'Platin', 'M', 0, 'B94994', '', 'M', '', '1988-08-08', '0702-771-124', 'mplat84@gmail.com', '', 'Kampala', '', 0, 0, '', '', 'First user registration', '2016-11-16 00:00:00', 1, '', '', '', '1', '1', 0),
(28, 'Mr', 0, 'BFS00000028', 'Sulaiman', 'Katumba', '', 1, '94394', 'img/ids/20170618_192630.jpg', 'M', 'Married', '1970-01-01', '(073) 000-0000', '', '36211 kampala', 'kampala', 'BLB Tenant', 1, 1, NULL, '', 'Created successfully', '2017-06-26 00:00:00', 1, 'kampala', 'Kawempe', 'Kawempe', '', 'kawempe tula', 0),
(29, 'Mrs', 0, 'BFS00000029', 'Christine', 'Lwanga', '', 1, '9238', 'img/ids/logo.jpg', 'F', '', '1980-07-08', '(073) 000-0000', '', '', 'kampala', 'BLB Staff', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(30, 'Mr', 0, 'BFS00000030', 'Simon', 'Kabogoza', '', 1, '32828', 'img/ids/developr.jpg', 'M', 'Married', '2017-02-08', '(073) 000-0000', 'mplat84@gmail.com', '', 'kampala', 'kampala', 1, 1, NULL, '', 'Client has business in Kampala and is an It consultant', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(31, 'Mr', 0, 'BFS00000031', 'Francis', 'Muyomba', '', 1, '433423', 'img/ids/maxresdefault.jpg', 'M', 'Single', '1980-01-02', '(023) 000-0000', '', 'kampala', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(32, 'Mr', 0, 'BFS00000032', 'Katende', 'Mukwaba', '', 1, '3434343', 'img/ids/expi.PNG', 'M', 'Single', '1949-02-02', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(33, 'Mr', 0, 'BFS00000033', 'Baker', 'Namukala', '', 1, '74383', 'img/ids/aaa.PNG', 'M', 'Single', '1987-02-04', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(34, 'Mr', 0, 'BFS00000034', 'Daniel', 'Twinamatsiko', '', 1, '93438', 'img/ids/queen-elizabeth-national-park.jpg', 'M', '', '2001-01-04', '(073) 290-1901', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(35, 'Mr', 0, 'BFS00000035', 'Fred', 'Tukamuhabwa', '', 1, '84389', 'img/ids/acc-ndali-lodge.jpg', 'M', '', '1988-07-02', '(073) 278-2378', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(36, 'Mrs', 0, 'BFS00000036', 'Christine', 'Tibagwa', '', 1, '438934', 'img/ids/logo.png', 'F', 'Single', '1988-03-02', '(073) 723-7823', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(37, 'Mr', 0, 'BFS00000037', 'Eroni', 'Kikomaga', '', 1, '84589', 'img/ids/image002.jpg', 'M', 'Single', '2000-03-02', '(073) 439-0309', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(38, 'Mrs', 0, 'BFS00000038', 'Ruth', 'Nsamba', '', 1, '848389', 'img/ids/logo.png', 'F', 'Single', '1970-01-01', '(074) 378-4378', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(39, 'Mr', 0, 'BFS00000039', 'William', 'Mugejjera', '', 1, '948389', 'img/ids/payment.PNG', 'M', 'Single', '1988-07-02', '(095) 095-4095', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(40, 'Mrs', 0, 'BFS00000040', 'Rose', 'Nakanyike ', '', 1, '93292', 'img/ids/animated-overlay.gif', 'F', 'Married', '1965-04-03', '(088) 238-2923', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(41, 'Mrs', 0, 'BFS00000041', 'Agnes', 'Nansereko', '', 1, '94393', 'img/ids/jcrop.gif', 'F', '', '1987-02-04', '(074) 383-9894', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(42, 'Mr', 0, 'BFS00000042', 'Christine', 'Nabaweesi', '', 1, '843893', 'img/ids/apple-touch-icon-72-precomposed.png', 'F', '', '1987-08-09', '(903) 409-3409', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-26 00:00:00', 1, '', '', '', '', '', 0),
(43, 'Mrs', 1, 'SBFS00000043', 'Janet', 'Adong', '', 1, 'cm34jjf93lfff', '', 'F', '', '1970-01-01', '(908) 083-9393', 'adongjanet@yahoo.com', '20938', 'Kampala', '', 0, 0, NULL, '', 'Approved to join the team', '0000-00-00 00:00:00', 1, 'Kampala', 'Kampala', 'Kampala', 'Kampala', 'Kampala', 0);

-- --------------------------------------------------------

--
-- Table structure for table `persontype`
--

CREATE TABLE `persontype` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 28, '', 'Connectsoft Limited', 'Equatoria Building ', 3, '10.00', '4413', '', 2017, 1, '2017-06-26 10:46:37'),
(2, 29, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 10:53:31'),
(3, 30, '', 'CS', 'CS', 99, '90.00', '4413', '', 2017, 1, '2017-06-26 10:58:04'),
(4, 31, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:29:13'),
(5, 32, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:31:39'),
(6, 33, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:33:29'),
(7, 34, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:34:46'),
(8, 35, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:36:26'),
(9, 36, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:37:34'),
(10, 37, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:38:52'),
(11, 38, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:39:46'),
(12, 39, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:48:51'),
(13, 40, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:50:15'),
(14, 41, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:51:14'),
(15, 42, '', '', '', 0, '0.00', '', '', 2017, 1, '2017-06-26 12:52:11');

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

CREATE TABLE `position` (
  `id` int(11) NOT NULL,
  `access_level` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `access_level`, `name`, `description`, `active`) VALUES
(1, 1, 'Administrator', 'General System Administration', 1),
(2, 2, 'Loan Officer ', 'Credit officers', 1),
(3, 3, 'Branch Manager', 'Branch Managers', 1),
(4, 5, 'Branch Credit Committee Officer', 'Branch Credit Committee Officer', 1),
(5, 5, 'Management Credit Committee member\n', 'Management Credit Committee\r\n', 1),
(6, 6, 'Executive board committe member', 'Executive board committe', 1);

-- --------------------------------------------------------

--
-- Table structure for table `relationship_type`
--

CREATE TABLE `relationship_type` (
  `id` int(11) NOT NULL,
  `rel_type` varchar(100) NOT NULL COMMENT 'Type of relationship',
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `saccogroup` (
  `id` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL COMMENT 'Name of the group',
  `description` text NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp of creation',
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp at modification',
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `saccogroup`
--

INSERT INTO `saccogroup` (`id`, `groupName`, `description`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'St Francis Bwaise', 'St Francis Bwaise group', 1498490848, 1, '2017-06-26 15:29:57', 1),
(2, 'Yesu Afuga Nabweru', 'Yesu Afuga Nabweru group', 1498491029, 1, '2017-06-26 15:31:36', 1);

-- --------------------------------------------------------

--
-- Table structure for table `securitytype`
--

CREATE TABLE `securitytype` (
  `id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

INSERT INTO `staff` (`id`, `personId`, `branch_id`, `position_id`, `username`, `password`, `access_level`, `status`, `start_date`, `end_date`, `date_added`, `added_by`) VALUES
(1, 1, 0, 1, 'platin', '807c1c8ea54c81e6167a19275211b2a3', 1, 1, '0000-00-00', NULL, '2016-11-16', '1'),
(2, 43, 6, 4, 'adongjanet', 'a0c987a78152fd5a7dde640e6a510336', 0, 1, '0000-00-00', NULL, '2017-07-04', '1');

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
(16, 1, 1),
(17, 4, 43);

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
-- Table structure for table `subcounty`
--

CREATE TABLE `subcounty` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `county_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `subscription` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `subscriptionYear` year(4) NOT NULL,
  `receivedBy` int(11) NOT NULL,
  `datePaid` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff modifying the entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

-- --------------------------------------------------------

--
-- Table structure for table `village`
--

CREATE TABLE `village` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `parish_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `village`
--

INSERT INTO `village` (`id`, `name`, `parish_id`) VALUES
(1, 'Kawempe TC', 1),
(2, 'Kawempe Town', 2);

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
-- Indexes for table `counties`
--
ALTER TABLE `counties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
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
  ADD KEY `dateCreated` (`dateCreated`);

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
  ADD KEY `fkDateCreated` (`dateCreated`),
  ADD KEY `fkDepositProductId` (`depositProductID`);

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
-- Indexes for table `expense`
--
ALTER TABLE `expense`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expense_type` (`expenseType`);

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
  ADD KEY `fkLoanId` (`loanAccountId`),
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
  ADD PRIMARY KEY (`1`);

--
-- Indexes for table `loan_account`
--
ALTER TABLE `loan_account`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `parish`
--
ALTER TABLE `parish`
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
  ADD KEY `purchase_date` (`datePaid`),
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
-- Indexes for table `subcounty`
--
ALTER TABLE `subcounty`
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
-- Indexes for table `village`
--
ALTER TABLE `village`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accesslevel`
--
ALTER TABLE `accesslevel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `address_type`
--
ALTER TABLE `address_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `counties`
--
ALTER TABLE `counties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `deposit_account`
--
ALTER TABLE `deposit_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `deposit_account_fee`
--
ALTER TABLE `deposit_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `deposit_account_transaction`
--
ALTER TABLE `deposit_account_transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `deposit_product`
--
ALTER TABLE `deposit_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `deposit_product_fee`
--
ALTER TABLE `deposit_product_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `deposit_product_type`
--
ALTER TABLE `deposit_product_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `expense`
--
ALTER TABLE `expense`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `expensetypes`
--
ALTER TABLE `expensetypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `guarantor`
--
ALTER TABLE `guarantor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
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
  MODIFY `1` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `loan_account`
--
ALTER TABLE `loan_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `loan_account_approval`
--
ALTER TABLE `loan_account_approval`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_account_fee`
--
ALTER TABLE `loan_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_account_penalty`
--
ALTER TABLE `loan_account_penalty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_collateral`
--
ALTER TABLE `loan_collateral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_products`
--
ALTER TABLE `loan_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `loan_products_penalty`
--
ALTER TABLE `loan_products_penalty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_product_fee`
--
ALTER TABLE `loan_product_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_product_feen`
--
ALTER TABLE `loan_product_feen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_product_type`
--
ALTER TABLE `loan_product_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `loan_repayment`
--
ALTER TABLE `loan_repayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `marital_status`
--
ALTER TABLE `marital_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `member_deposit_account`
--
ALTER TABLE `member_deposit_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `member_loan_account`
--
ALTER TABLE `member_loan_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `other_settings`
--
ALTER TABLE `other_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `parish`
--
ALTER TABLE `parish`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `penalty_calculation_method`
--
ALTER TABLE `penalty_calculation_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `person_employment`
--
ALTER TABLE `person_employment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `person_relative`
--
ALTER TABLE `person_relative`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `relationship_type`
--
ALTER TABLE `relationship_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `saccogroup`
--
ALTER TABLE `saccogroup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `securitytype`
--
ALTER TABLE `securitytype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `shares`
--
ALTER TABLE `shares`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `share_rate`
--
ALTER TABLE `share_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `staff_roles`
--
ALTER TABLE `staff_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `subcounty`
--
ALTER TABLE `subcounty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
--
-- AUTO_INCREMENT for table `village`
--
ALTER TABLE `village`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
