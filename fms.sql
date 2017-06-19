-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 05, 2017 at 06:14 PM
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
CREATE DEFINER=`root`@`localhost` FUNCTION `default_days` (`loan_id` INT UNSIGNED, `loan_date` DATE, `loan_end_date` DATE, `cur_date` DATE, `exp_payback` DECIMAL(12,2)) RETURNS INT(11) READS SQL DATA
BEGIN
	DECLARE temp_days, no_days, loan_duration, loan_age INT DEFAULT 0;
    DECLARE tempDate DATE;
	SET loan_duration = TIMESTAMPDIFF(MONTH,loan_date,loan_end_date);
	SET loan_age = TIMESTAMPDIFF(MONTH,loan_date,cur_date);
	IF loan_age >0 THEN
        WHILE (loan_age > 0) DO
            SET loan_age = loan_age-1;
            SET tempDate = DATE_SUB(cur_date, INTERVAL loan_age MONTH);
            CALL exceeded_days(loan_id, loan_date, cur_date, loan_duration, exp_payback, loan_age,temp_days);
            SET no_days = no_days + temp_days;
        END WHILE;
    END IF;
	
	RETURN no_days;
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
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `account_number` bigint(20) NOT NULL,
  `balance` decimal(19,2) NOT NULL,
  `personId` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `date_created` date NOT NULL,
  `created_by` int(11) NOT NULL,
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `account_number`, `balance`, `personId`, `status`, `date_created`, `created_by`, `date_modified`) VALUES
(1, 2846298541, '0.00', 1, 1, '2016-11-16', 0, '2016-11-16 09:24:20'),
(2, 6281206434, '5000.00', 2, 1, '2016-11-16', 0, '2016-11-23 10:45:20'),
(3, 3459593919, '0.00', 3, 1, '2016-11-24', 0, '2016-11-24 08:41:05'),
(4, 3190239904, '0.00', 4, 1, '2016-11-24', 1, '2016-11-24 08:54:48'),
(5, 3699647649, '0.00', 5, 1, '2017-01-08', 0, '2017-01-08 17:07:35'),
(6, 1208039482, '0.00', 6, 1, '2017-01-08', 0, '2017-01-08 17:14:52'),
(7, 1581388289, '0.00', 7, 1, '2017-01-08', 1, '2017-01-08 17:25:02');

-- --------------------------------------------------------

--
-- Table structure for table `account_transaction`
--

CREATE TABLE `account_transaction` (
  `id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  `amount` decimal(19,2) NOT NULL,
  `comment` text NOT NULL,
  `transactionType` varchar(30) NOT NULL,
  `transactedBy` varchar(120) NOT NULL,
  `dateAdded` date NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `addedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 'BR00001', 'Muganzirwaza', 'Muganzirwaza First Floor', '073-666-999', '', 'financialservices@buladde.or.ug');

-- --------------------------------------------------------

--
-- Table structure for table `clientpayback`
--

CREATE TABLE `clientpayback` (
  `id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `amount` text NOT NULL,
  `paid_by` int(11) NOT NULL,
  `date_paid_back` date NOT NULL,
  `mode_paid` varchar(20) NOT NULL,
  `account_number` varchar(100) NOT NULL,
  `bank_branch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 0, '0.00', '0.00', '23.00', '0.00', 3, 1496052915, 1, 1496052915, 1),
(2, 1, '0.00', '0.00', '20.00', '10000.00', 10, 1496088967, 1, 1496088967, 1),
(3, 1, '0.00', '0.00', '0.00', '0.00', 0, 1496089454, 1, 1496089454, 1);

-- --------------------------------------------------------

--
-- Table structure for table `deposit_account_fee`
--

CREATE TABLE `deposit_account_fee` (
  `id` int(11) NOT NULL,
  `depositProductFeeId` int(11) DEFAULT NULL,
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
  `transactedBy` varchar(120) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `addedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 'Home Plus', '', 1, 3, '0.00', '0.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, 1495052697, 1, 1495052697, '0000-00-00 00:00:00'),
(2, 'Home Plus', '', 1, 3, '0.00', '0.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, 1495052989, 1, 1495052989, '0000-00-00 00:00:00');

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
  `expenseType` tinyint(4) NOT NULL,
  `amountUsed` decimal(15,2) NOT NULL,
  `amountDescription` text NOT NULL,
  `createdBy` int(11) NOT NULL COMMENT 'ID of staff who added the record',
  `expenseDate` int(11) NOT NULL COMMENT 'Timestamp for when this record was added',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp for when this record was added',
  `modifiedBy` int(11) NOT NULL COMMENT 'Staff who modified the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `expensetypes`
--

CREATE TABLE `expensetypes` (
  `id` int(11) NOT NULL,
  `expenseName` varchar(50) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 6, 1, 1496674764, 30, '2017-06-05 15:00:20', 30),
(2, 7, 1, 1496674764, 30, '2017-06-05 15:00:20', 30),
(3, 8, 1, 1496674764, 30, '2017-06-05 15:00:20', 30),
(4, 9, 1, 1496674764, 30, '2017-06-05 15:00:20', 30);

-- --------------------------------------------------------

--
-- Table structure for table `guarantor`
--

CREATE TABLE `guarantor` (
  `id` int(11) NOT NULL,
  `guarantorId` int(11) NOT NULL,
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
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `id_card_types`
--

INSERT INTO `id_card_types` (`id`, `id_type`, `description`) VALUES
(1, 'National Id', 'National identification Number');

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

--
-- Dumping data for table `income`
--

INSERT INTO `income` (`id`, `incomeType`, `amount`, `dateAdded`, `addedBy`, `description`, `dateModified`, `modifiedBy`) VALUES
(1, 1, '20000.00', 20161124, 1, 'Annual subscription paid by Cissy  Ge for year 2016', '0000-00-00 00:00:00', 0),
(2, 1, '20000.00', 20170108, 1, 'Annual subscription paid by Ronald  Matovu for year 2017', '0000-00-00 00:00:00', 0);

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
(1, 'Annual Subscription', 'This will be the annual subscription for each member'),
(2, 'Shares', 'Shares of each member');

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
  `loanNo` varchar(45) NOT NULL,
  `branch_id` int(11) NOT NULL COMMENT 'Branch id the loan was taken out from',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Pending Approval, 2-Partial_Application, 3-Approved',
  `loanProductId` int(11) NOT NULL COMMENT 'Reference to the loan product',
  `requestedAmount` decimal(15,2) NOT NULL COMMENT 'Amount applied for',
  `applicationDate` int(11) NOT NULL COMMENT 'Date loan was applied for',
  `disbursedAmount` decimal(15,2) DEFAULT NULL COMMENT 'Amount disbursed to client',
  `disbursementDate` int(11) DEFAULT NULL COMMENT 'Date loan was disbursed',
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
  `approvedBy` int(11) DEFAULT NULL COMMENT 'Loans officer who approved the loan',
  `comments` text,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Accounts for the loans given out';

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
-- Table structure for table `loan_collateral`
--

CREATE TABLE `loan_collateral` (
  `id` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `itemName` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `attachmentUrl` varchar(30) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_collateral`
--

INSERT INTO `loan_collateral` (`id`, `loanAccountId`, `itemName`, `description`, `attachmentUrl`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 1, 'Laptop computer', 'Dell Inspiron 15". 500 GB Hard Drive. Core i5', NULL, 1496426991, 1, '0000-00-00 00:00:00', 1);

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
-- Table structure for table `loan_penalty`
--

CREATE TABLE `loan_penalty` (
  `id` int(11) NOT NULL,
  `loanId` int(11) NOT NULL,
  `penaltyCalculationMethod` tinyint(4) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `penaltyTolerancePeriod` tinyint(4) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateAdded` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan accounts are be subjected to';

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
(1, 'Home Improvement', 'Home Improvement', 1, 1, 1, '0.00', '0.00', '0.00', 1, '8.70', '5.00', '30.00', 4, 2, 10, 5, 0, 1, 0, 0, 0, '110.00', 2, 0, 0, 0, NULL, 2, 2, 1, '3.00', '2.00', '50.00', 0, 2, 1, 1, 1496341121, 1, '0000-00-00 00:00:00', 1),
(2, 'Personal loan', 'Personal loan', 1, 1, 1, '100000.00', '50000.00', '500000.00', 1, '6.70', '5.00', '30.00', 1, 3, 6, 1, 12, 1, 0, 0, 0, '150.00', 4, 0, 0, 0, NULL, 2, 1, 1, '8.00', '3.00', '20.00', 0, 2, 1, 1, 1496378518, 1, '0000-00-00 00:00:00', 1);

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

--
-- Dumping data for table `loan_product_fee`
--

INSERT INTO `loan_product_fee` (`id`, `feeName`, `feeType`, `amountCalculatedAs`, `requiredFee`, `amount`, `dateCreated`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'Loan application fees', 1, 1, 1, '20000.00', 0, 0, '0000-00-00 00:00:00', 0),
(2, 'Loan Processing', 2, 2, 0, '15.00', 0, 0, '0000-00-00 00:00:00', 0);

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

--
-- Dumping data for table `loan_product_feen`
--

INSERT INTO `loan_product_feen` (`id`, `loanProductId`, `loanProductFeeId`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, 2, 1, 1, 1496378518, 1, '0000-00-00 00:00:00'),
(2, 2, 2, 1, 1496378518, 1, '0000-00-00 00:00:00');

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
(1, 'Fixed Term Loan', 'A type of product with Fixed interest rate', 280092020, '0000-00-00 00:00:00', 1, 1),
(2, 'Dynamic Term Loan', 'A type of product with Dynamic interest rate', 280092020, '0000-00-00 00:00:00', 1, 1),
(3, 'Revolving Credit', 'A type of product that allows multiple disbursements and repayments on the account, similar to an overdraft, except that it has a payment plan associated with it in which some amount of principal and interest may be paid', 280092020, '0000-00-00 00:00:00', 1, 1),
(4, 'Payment Plan', 'A type of product with no interest charged', 280092020, '0000-00-00 00:00:00', 1, 1),
(5, 'Tranched Loan', 'A type of product that allows for loan disbursement in tranches', 280092020, '0000-00-00 00:00:00', 1, 1);

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
(1, 43, 1, 1, '10200000.00', 1, 'Fully paid up', 20170129, 1, 0, 0),
(2, 2443, 23, 4, '50000.00', 1, 'Paid by cheque', 20170124, 1, 0, 54);

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
(1, 32, 1, 1, 0, 2017, 9, 'Thanks', '2017-06-05 08:44:24', 0),
(2, 33, 1, 1, 0, 2017, 9, 'An already existing Member', '2017-06-05 08:46:31', 0),
(3, 34, 1, 1, 0, 2017, 9, 'Registered without employment history', '2017-06-05 08:50:57', 0),
(4, 35, 1, 1, 0, 2017, 9, '', '2017-06-05 08:52:59', 0),
(5, 36, 1, 1, 0, 2017, 9, '', '2017-06-05 08:59:52', 0),
(6, 37, 1, 1, 0, 2017, 9, 'Thank you for joining Buladde Financial Services', '2017-06-05 09:06:26', 0),
(7, 38, 1, 1, 0, 2017, 9, 'Thank you for joing Buladde Financial Services', '2017-06-05 09:08:08', 0),
(8, 39, 1, 1, 0, 2017, 9, 'Received', '2017-06-05 09:09:08', 0),
(9, 40, 1, 1, 0, 2017, 9, 'Registered 05th  June 2017', '2017-06-05 09:10:09', 0),
(10, 41, 1, 1, 0, 2017, 9, 'Thanks', '2017-06-05 09:11:27', 0),
(11, 42, 1, 1, 0, 2017, 9, '', '2017-06-05 09:12:21', 0),
(12, 43, 1, 1, 0, 2017, 9, '', '2017-06-05 09:14:08', 0),
(13, 44, 1, 1, 0, 2017, 9, '', '2017-06-05 09:14:47', 0),
(14, 45, 1, 1, 0, 2017, 9, '', '2017-06-05 09:15:44', 0),
(15, 46, 1, 1, 0, 2017, 9, '', '2017-06-05 09:17:54', 0),
(16, 47, 1, 1, 0, 2017, 9, '', '2017-06-05 09:18:40', 0),
(17, 48, 1, 1, 0, 2017, 9, '', '2017-06-05 09:19:16', 0),
(18, 49, 1, 1, 0, 2017, 9, '', '2017-06-05 09:19:45', 0),
(19, 50, 1, 1, 0, 2017, 9, '', '2017-06-05 09:20:22', 0);

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
(1, 3, 1, 1496052915, 1, '0000-00-00 00:00:00', 1),
(2, 2, 2, 1496088967, 1, '0000-00-00 00:00:00', 1),
(3, 3, 3, 1496089454, 1, '0000-00-00 00:00:00', 1);

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

--
-- Dumping data for table `other_settings`
--

INSERT INTO `other_settings` (`id`, `minimum_balance`, `maximum_guarantors`) VALUES
(1, 5000, 0);

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
(1, 'No penalty', 280209228, 1, '2028-02-09 19:08:00', 1),
(2, 'Overdue Principal * # of Late Days * Penalty Rate', 280209228, 1, '2028-02-09 19:08:00', 1),
(3, '(Overdue Principal + Overdue Interest) * # of Late Days * Penalty Rate', 280209228, 1, '2028-02-09 19:08:00', 1),
(4, 'Outstanding Principal * # of Late Days * Penalty Rate', 280209228, 1, '2028-02-09 19:08:00', 1);

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
  `gender` varchar(3) NOT NULL,
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
  `village` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `gender`, `dateofbirth`, `phone`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`) VALUES
(30, 'Mr', 1, 'SBFS00000030', 'platin', 'alfred', '', 1, '892892389', 'M', '1980-08-08', '(073) 000-0000', 'mplat84@gmail.com', 'kampala', 'kampala', '', 0, 0, NULL, '', 'Thank you', '0000-00-00 00:00:00', 0, '', '', '', '', ''),
(31, 'Mr', 1, 'SBFS00000031', 'Cissy', 'M', '', 1, '858945', 'F', '1987-01-01', '(073) 000-0000', 'mplat84@gmail.com', 'kampala', 'kampala', '', 0, 0, NULL, '', 'Thank you', '0000-00-00 00:00:00', 9, '', '', '', '', ''),
(32, 'Mr', 0, 'BFS00000032', 'Sulaiman', 'Katumba ', '', 1, '9439439', 'M', '1971-01-01', '(993) 209-2309', 'mplat84@gmail.com', 'kampala', 'kampala', 'Farmer', 4, 1, NULL, '', 'Thanks', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(33, 'Mrs', 0, 'BFS00000033', 'Christine', 'Lwanga ', '', 1, '344334', 'F', '1981-01-01', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', 'An already existing Member', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(34, 'Mr', 0, 'BFS00000034', 'Simon', 'Kabogoza', '', 1, '7662278', 'M', '1987-01-01', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', 'Registered without employment history', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(35, 'Mr', 0, 'BFS00000035', 'Francis', 'Muyomba ', '', 1, '5484598', '', '1983-01-01', '(073) 000-0000', '', '', 'kampala', '', 1, 3, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(36, 'Mr', 0, 'BFS00000036', 'Mukwaba', ' Katende', '', 1, '55455455', 'M', '1987-01-01', '(073) 000-0000', '', '', 'kampala', 'BLB Staff', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(37, 'Mr', 0, 'BFS00000037', 'Baker', 'Namakula ', 'Namakula ', 1, '8493893489', 'M', '1987-01-01', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', 'Thank you for joining Buladde Financial Services', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(38, 'Mr', 0, 'BFS00000038', 'Daniel', 'Twinamatsiko ', '', 1, '8438934893', 'M', '1981-01-01', '(073) 000-0000', '', '', 'Kampala', '', 0, 0, NULL, '', 'Thank you for joing Buladde Financial Services', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(39, 'Mr', 0, 'BFS00000039', 'Fred', 'Tukamuhabwa ', '', 1, 'asa43554', 'M', '1970-01-01', '(073) 500-0000', '', '', 'Kampala', '', 0, 0, NULL, '', 'Received', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(40, 'Mrs', 0, 'BFS00000040', 'Christine', 'Tibagwa ', '', 1, '8899898', 'F', '1970-01-01', '(077) 799-8989', '', '', 'kampala', '', 0, 0, NULL, '', 'Registered 05th  June 2017', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(41, 'Mr', 0, 'BFS00000041', 'Eroni', 'Kikomaga ', '', 1, '8489398', 'M', '1987-01-01', '(088) 989-8990', '', '', 'kampala', '', 0, 0, NULL, '', 'Thanks', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(42, 'Mrs', 0, 'BFS00000042', 'Ruth', 'Nsamba ', '', 1, '54545', 'F', '1980-02-01', '(073) 000-0000', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(43, 'Mr', 0, 'BFS00000043', 'William', 'Mugejjera ', '', 1, '456665656', 'M', '2017-01-01', '(087) 645-5554', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(44, 'Mrs', 0, 'BFS00000044', 'Rose', 'Nakanyike ', '', 1, '43454545', 'F', '1970-01-01', '(074) 222-4565', '', '', 'kampala', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(45, 'Mrs', 0, 'BFS00000045', 'Agnes', 'Nansereko ', '', 1, '454665', 'F', '1980-07-08', '(073) 777-7777', '', '', 'k', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(46, 'Mrs', 0, 'BFS00000046', 'Christine', 'Nabaweesi ', '', 1, '45665655656', 'F', '1987-02-01', '(085) 645-4343', '', '', 'j', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(47, 'Mrs', 0, 'BFS00000047', 'Lydia', 'Namwase ', '', 1, '46577', 'F', '1970-01-01', '(097) 876-5453', '', '', 'aa', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(48, 'Mrs', 0, 'BFS00000048', 'Hanifa', 'Nabasitu ', '', 1, '6565656656', 'F', '1970-01-01', '(097) 876-6547', '', '', 'h', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(49, 'Mrs', 0, 'BFS00000049', 'Zam', 'Nalule ', '', 1, '43433434', 'F', '1970-01-01', '(075) 344-3443', '', '', 'e', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', ''),
(50, 'Mrs', 0, 'BFS00000050', 'Harriet', 'Nanyonjo ', '', 1, '32223', 'F', '1970-01-01', '(070) 122-3344', '', '', 'h', '', 0, 0, NULL, '', '', '2017-06-05 00:00:00', 9, '', '', '', '', '');

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
(1, 'member', 'Person as Member'),
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
(1, 22, 'Airtel Uganda', 2, '0', NULL, NULL, '400000.00', 0, 0, '2017-06-04 15:07:01', 0),
(2, 23, 'Airtel Uganda', 2, '0', NULL, NULL, '400000.00', 0, 0, '2017-06-04 15:07:49', 0),
(3, 32, 'CS', 2, 'IT', NULL, NULL, '2000000.00', 0, 0, '2017-06-05 08:44:24', 0),
(4, 33, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 08:46:31', 0),
(5, 35, 'MTN Uganda', 2, 'Customer care', NULL, NULL, '600000.00', 0, 0, '2017-06-05 08:52:59', 0),
(6, 36, 'BLB Staff', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 08:59:51', 0),
(7, 37, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:06:26', 0),
(8, 38, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:08:08', 0),
(9, 39, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:09:08', 0),
(10, 40, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:10:09', 0),
(11, 41, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:11:27', 0),
(12, 42, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:12:21', 0),
(13, 43, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:14:08', 0),
(14, 44, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:14:47', 0),
(15, 45, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:15:44', 0),
(16, 46, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:17:54', 0),
(17, 47, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:18:40', 0),
(18, 48, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:19:16', 0),
(19, 49, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:19:45', 0),
(20, 50, '', 0, '', NULL, NULL, '0.00', 0, 0, '2017-06-05 09:20:22', 0);

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
(1, 22, 0, 'Alfred', 'Platin', 'Mugasa', 0, 1, 'kampala', 'kampala', 'kampala'),
(2, 22, 0, 'Brian', 'Matovu', '', 0, 1, 'kampala', 'k', '0808430340'),
(3, 23, 0, 'Alfred', 'Platin', 'Mugasa', 0, 1, 'kampala', 'kampala', 'kampala'),
(4, 23, 0, 'Brian', 'Matovu', '', 0, 1, 'kampala', 'k', '0808430340'),
(5, 32, 0, 'A', 'A', 'A', 0, 1, 'A', 'A', 'A'),
(6, 32, 1, 'C', 'C', 'C', 0, 2, 'C', 'C', 'C'),
(7, 33, 0, '', '', '', 0, 0, '', '', ''),
(8, 34, 0, '', '', '', 0, 0, '', '', ''),
(9, 35, 1, 'Alex', 'Muyomba', '', 0, 1, 'kampala', 'Wakiso', ''),
(10, 36, 0, '', '', '', 0, 0, '', '', ''),
(11, 37, 0, '', '', '', 0, 0, '', '', ''),
(12, 38, 0, '', '', '', 0, 0, '', '', ''),
(13, 39, 0, '', '', '', 0, 0, '', '', ''),
(14, 40, 0, '', '', '', 0, 0, '', '', ''),
(15, 41, 1, 'c', 'c', 'c', 0, 1, '', '', ''),
(16, 42, 0, '', '', '', 0, 0, '', '', ''),
(17, 43, 0, '', '', '', 0, 0, '', '', ''),
(18, 44, 0, '', '', '', 0, 0, '', '', ''),
(19, 45, 0, '', '', '', 0, 0, '', '', ''),
(20, 46, 0, '', '', '', 0, 0, '', '', ''),
(21, 47, 0, '', '', '', 0, 0, '', '', ''),
(22, 48, 0, '', '', '', 0, 0, '', '', ''),
(23, 49, 0, '', '', '', 0, 0, '', '', ''),
(24, 50, 0, '', '', '', 0, 0, '', '', '');

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
(2, 'Sister', '');

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
(1, 'St Francis Bwaise', 'St Francis Bwaise', 1496674764, 30, '2017-06-05 15:00:20', 30);

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
  `personId` int(11) NOT NULL,
  `noShares` int(10) UNSIGNED NOT NULL COMMENT 'No of shares',
  `amount` decimal(12,2) NOT NULL,
  `datePaid` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recordedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `status` int(11) NOT NULL DEFAULT '1',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `date_added` date NOT NULL,
  `added_by` varchar(45) NOT NULL,
  `modified_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `personId`, `branch_id`, `position_id`, `username`, `password`, `status`, `start_date`, `end_date`, `date_added`, `added_by`, `modified_by`) VALUES
(9, 30, 1, 1, 'alfred', '9e11830101b6b723ae3fb11e660a2123', 1, '0000-00-00', NULL, '2017-06-05', '<br />\r\n<b>Notice</b>:  Undefined index: user', 0),
(10, 31, 1, 3, 'Cissy', '6ad14ba9986e3615423dfca256d04e3f', 1, '0000-00-00', NULL, '2017-06-05', '9', 0);

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
(16, 1, 30),
(17, 3, 31);

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
  `personId` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `subscriptionYear` year(4) NOT NULL,
  `paidBy` int(11) NOT NULL,
  `receivedBy` int(11) NOT NULL,
  `datePaid` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff modifying the entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`id`, `personId`, `amount`, `subscriptionYear`, `paidBy`, `receivedBy`, `datePaid`, `dateModified`, `modifiedBy`) VALUES
(1, 4, '20000.00', 2016, 0, 1, 20161124, '0000-00-00 00:00:00', 0),
(2, 7, '20000.00', 2017, 0, 1, 20170108, '0000-00-00 00:00:00', 0);

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

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `transaction_type`, `branch_number`, `personId`, `amount`, `amount_description`, `transacted_by`, `transaction_date`, `approved_by`, `comments`, `dateModified`) VALUES
(1, '1', 'BR00001', 2, '49990', 'Forty Nine Thousand Nine hundred Ninety  Ugandan Shillings Only', 'Alfred', '2016-11-23', '1', 'Kampala', '2016-11-23 09:33:16'),
(2, '2', 'BR00001', 2, '-5000', 'Five Thousand  Ugandan Shillings Only', 'Alfred', '2016-11-23', '1', 'P', '2016-11-23 10:45:20'),
(3, '1', 'BR00001', 7, '130000', 'One hundred thirty thousand shillings only', 'M. Musoke', '2017-02-01', '1', '', '2017-02-03 18:19:08');

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
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`personId`);

--
-- Indexes for table `account_transaction`
--
ALTER TABLE `account_transaction`
  ADD KEY `person_id` (`personId`);

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
-- Indexes for table `clientpayback`
--
ALTER TABLE `clientpayback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loan_id`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkDepositProductFeeId` (`depositProductFeeId`),
  ADD KEY `fkCreationDate` (`dateCreated`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkDateModified` (`dateModified`),
  ADD KEY `fkCreatedBy` (`createdBy`);

--
-- Indexes for table `deposit_account_transaction`
--
ALTER TABLE `deposit_account_transaction`
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
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_number` (`guarantorId`),
  ADD KEY `loan_id` (`loanAccountId`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_end_date` (`loanPeriod`),
  ADD KEY `loan_date` (`disbursementDate`),
  ADD KEY `loan_type` (`loanProductId`),
  ADD KEY `loanProductId` (`loanProductId`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `dateModified` (`dateModified`);

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
-- Indexes for table `loan_penalty`
--
ALTER TABLE `loan_penalty`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `penaltyId` (`penaltyCalculationMethod`),
  ADD KEY `fkLoanId` (`loanId`) USING BTREE;

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
  ADD KEY `person_id` (`personId`);

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
  ADD KEY `person_id` (`personId`);

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
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
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
-- AUTO_INCREMENT for table `clientpayback`
--
ALTER TABLE `clientpayback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `deposit_account_fee`
--
ALTER TABLE `deposit_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `expensetypes`
--
ALTER TABLE `expensetypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `guarantor`
--
ALTER TABLE `guarantor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `id_card_types`
--
ALTER TABLE `id_card_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `income`
--
ALTER TABLE `income`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_account_fee`
--
ALTER TABLE `loan_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_collateral`
--
ALTER TABLE `loan_collateral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_penalty`
--
ALTER TABLE `loan_penalty`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `loan_product_feen`
--
ALTER TABLE `loan_product_feen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `loan_product_type`
--
ALTER TABLE `loan_product_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `loan_repayment`
--
ALTER TABLE `loan_repayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `member_deposit_account`
--
ALTER TABLE `member_deposit_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `other_settings`
--
ALTER TABLE `other_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `parish`
--
ALTER TABLE `parish`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `penalty_calculation_method`
--
ALTER TABLE `penalty_calculation_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `person`
--
ALTER TABLE `person`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;
--
-- AUTO_INCREMENT for table `persontype`
--
ALTER TABLE `persontype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `person_employment`
--
ALTER TABLE `person_employment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `person_relative`
--
ALTER TABLE `person_relative`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `relationship_type`
--
ALTER TABLE `relationship_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `saccogroup`
--
ALTER TABLE `saccogroup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
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
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
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
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
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
