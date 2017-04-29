-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 29, 2017 at 02:27 PM
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
(1, 'Administator', 'This will be able to add settings'),
(2, 'Manager', 'Can view, edit and delete'),
(3, 'Field Operators', 'Can Add, Limited Views');

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `account_number` bigint(20) NOT NULL,
  `balance` decimal(19,2) NOT NULL,
  `person_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `date_created` date NOT NULL,
  `created_by` int(11) NOT NULL,
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `account_number`, `balance`, `person_id`, `status`, `date_created`, `created_by`, `date_modified`) VALUES
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
  `person_id` int(11) NOT NULL,
  `amount` decimal(19,2) NOT NULL,
  `comment` text NOT NULL,
  `transaction_type` varchar(30) NOT NULL,
  `transacted_by` varchar(120) NOT NULL,
  `date_added` date NOT NULL,
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added_by` int(11) NOT NULL
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
-- Table structure for table `employment`
--

CREATE TABLE `employment` (
  `id` int(11) NOT NULL,
  `employer` varchar(100) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  `monthlySalary` decimal(15,2) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Creation timestamp',
  `createdBy` int(11) NOT NULL COMMENT 'ID for user adding the record',
  `dateModified` int(11) NOT NULL COMMENT 'modification timestamp',
  `modifiedBy` int(11) NOT NULL COMMENT 'ID for user modifying the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `dateModified` int(11) NOT NULL COMMENT 'Timestamp for when this record was added',
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
-- Table structure for table `fees`
--

CREATE TABLE `fees` (
  `id` int(11) NOT NULL,
  `feeName` varchar(50) NOT NULL,
  `feeType` tinyint(4) DEFAULT NULL,
  `amountCalculatedAs` tinyint(1) NOT NULL COMMENT '1-Percentage, 2 - Fixed Amount',
  `requiredFee` tinyint(1) NOT NULL COMMENT '1 - Required, 0 - Optional',
  `amount` decimal(12,2) NOT NULL COMMENT 'Amount or %age to be charged'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fee_type`
--

CREATE TABLE `fee_type` (
  `id` int(11) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Type of the fee to be charged';

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
-- Table structure for table `group_loan`
--

CREATE TABLE `group_loan` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL COMMENT 'Refence key to the group',
  `loanId` int(11) NOT NULL COMMENT 'Reference key to the loan'
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
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `guarantor`
--

CREATE TABLE `guarantor` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `guarantor`
--

INSERT INTO `guarantor` (`id`, `person_id`, `loan_id`) VALUES
(1, 3, 4),
(2, 4, 4),
(3, 3, 5),
(4, 4, 5),
(5, 2, 6);

-- --------------------------------------------------------

--
-- Table structure for table `id_card_types`
--

CREATE TABLE `id_card_types` (
  `id` int(11) NOT NULL,
  `id_type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `dateModified` int(11) NOT NULL COMMENT 'Timestamp for when this record was modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'ID of staff who modified the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `income`
--

INSERT INTO `income` (`id`, `incomeType`, `amount`, `dateAdded`, `addedBy`, `description`, `dateModified`, `modifiedBy`) VALUES
(1, 1, '20000.00', 20161124, 1, 'Annual subscription paid by Cissy  Ge for year 2016', 2147483647, 0),
(2, 1, '20000.00', 20170108, 1, 'Annual subscription paid by Ronald  Matovu for year 2017', 2147483647, 0);

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
  `personNo` int(11) NOT NULL,
  `loanNo` varchar(45) NOT NULL,
  `branchId` int(11) NOT NULL COMMENT 'Branch id the loan was taken out from',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Pending Approval, 2-Partial_Application, 3-Approved',
  `loanProductId` int(11) NOT NULL COMMENT 'Reference to the loan product',
  `applicationDate` int(11) NOT NULL COMMENT 'Date loan was applied for',
  `disbursementDate` int(11) DEFAULT NULL COMMENT 'Date loan was disbursed',
  `offSetPeriod` tinyint(4) NOT NULL COMMENT 'Time unit to offset the loan',
  `loanPeriod` tinyint(4) NOT NULL COMMENT 'Period the loan will take',
  `loanAmount` decimal(15,2) NOT NULL,
  `interestRate` decimal(4,2) NOT NULL,
  `expectedPayback` decimal(15,2) NOT NULL,
  `dailyDefaultAmount` decimal(4,2) NOT NULL,
  `approvedBy` int(11) NOT NULL COMMENT 'Loans officer who approved the loan',
  `repaymentsMadeEvery` tinyint(4) NOT NULL COMMENT '1 - Day, 2-Week, 3 - Month',
  `comments` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Accounts for the loans given out';

--
-- Dumping data for table `loan_account`
--

INSERT INTO `loan_account` (`id`, `personNo`, `loanNo`, `branchId`, `status`, `loanProductId`, `applicationDate`, `disbursementDate`, `offSetPeriod`, `loanPeriod`, `loanAmount`, `interestRate`, `expectedPayback`, `dailyDefaultAmount`, `approvedBy`, `repaymentsMadeEvery`, `comments`) VALUES
(1, 2, 'MUGANZIRWAZA-1611240015', 0, 1, 1, 0, 2147483647, 0, 0, '8900000.00', '13.00', '10057000.00', '9.99', 1, 1, 'pending approval'),
(2, 2, 'MUGANZIRWAZA-1611241124', 0, 1, 1, 0, 2147483647, 0, 0, '560000.00', '12.00', '627200.00', '9.99', 1, 4, 'Pending confirmation'),
(3, 2, 'MUGANZIRWAZA-1611242200', 0, 1, 1, 0, 2147483647, 0, 0, '5600000.00', '12.00', '6272000.00', '9.99', 1, 1, 'Provided security'),
(4, 2, 'MUGANZIRWAZA-1611242200', 0, 1, 1, 0, 2147483647, 0, 0, '1200000.00', '10.00', '1320000.00', '9.99', 1, 1, 'Yours truly'),
(5, 2, 'MUGANZIRWAZA-1611240919', 0, 1, 1, 0, 2147483647, 0, 0, '650000.00', '12.00', '728000.00', '19.99', 1, 1, 'Please avail yourself'),
(6, 7, 'MUGANZIRWAZA-1701080338', 0, 1, 1, 0, 2147483647, 0, 127, '300000.00', '15.00', '345000.00', '2.00', 1, 60, 'a');

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
-- Table structure for table `loan_fee`
--

CREATE TABLE `loan_fee` (
  `id` int(11) NOT NULL,
  `loanProductId` int(11) NOT NULL,
  `feeId` int(11) NOT NULL,
  `feeAmount` decimal(12,2) DEFAULT NULL
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
  `dateCreated` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan accounts are be subjected to';

-- --------------------------------------------------------

--
-- Table structure for table `loan_products`
--

CREATE TABLE `loan_products` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `productType` tinyint(4) NOT NULL COMMENT 'Type of the loan product',
  `availableTo` tinyint(4) NOT NULL COMMENT '1 - Clients, 2 - Groups or 3 - Both',
  `defAmount` decimal(15,2) NOT NULL COMMENT 'Default amount that can be disbursed for this product',
  `minAmount` decimal(12,2) NOT NULL COMMENT 'Min Amount that can be loaned for this produc',
  `maxAmount` decimal(12,2) NOT NULL COMMENT 'Max Amount that can be loan for this product',
  `maxTranches` tinyint(2) DEFAULT NULL COMMENT 'maximum number of disbursements for thisproduct',
  `defInterest` decimal(4,2) DEFAULT NULL COMMENT 'Default interest amount',
  `minInterest` decimal(4,2) NOT NULL COMMENT 'min interest rate',
  `maxInterest` decimal(4,2) NOT NULL COMMENT 'maximum interest rate',
  `repaymentsMadeEvery` tinyint(1) NOT NULL COMMENT '1 - Day, 2-Week, 3 - Month',
  `repaymentsFrequency` tinyint(4) NOT NULL COMMENT 'Number of repayments in a schedule',
  `minRepaymentFrequency` tinyint(4) NOT NULL COMMENT 'minimum frequency in which the loan can be repaid',
  `maxRepaymentFrequency` tinyint(4) NOT NULL COMMENT 'maximum frequency in which the loan can be repaid',
  `daysOfYear` tinyint(2) NOT NULL COMMENT 'Days of the year 1 - 360, 2 - 365',
  `intialAccountState` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-Pending Approval, 2-Partial_Application',
  `defGracePeriod` tinyint(4) NOT NULL COMMENT 'Default grace period for this product',
  `minGracePeriod` tinyint(4) NOT NULL COMMENT 'Minimum grace period for the loan',
  `maxGracePeriod` tinyint(4) NOT NULL COMMENT 'Maximum grace period for the loan',
  `minCollateralRequired` decimal(6,2) NOT NULL COMMENT 'Percentage of the loan required as collateral',
  `minGuarantorsRequired` tinyint(1) NOT NULL COMMENT 'Minimum number of guarantors required',
  `defaultOffSet` tinyint(4) NOT NULL COMMENT 'Default Offset for first repayment date',
  `minOffSet` tinyint(4) NOT NULL COMMENT 'minimum offset for repayment date',
  `maxOffSet` tinyint(4) NOT NULL COMMENT 'maximum offset for repayment date',
  `penaltyApplicable` tinyint(4) NOT NULL COMMENT '1 - Yes, 0 - No',
  `taxRateSource` tinyint(4) NOT NULL COMMENT 'Reference to the tax rate source',
  `taxCalculationMethod` tinyint(4) NOT NULL COMMENT '1-Inclusive, 2- Exclusive',
  `linkToDepositAccount` tinyint(1) DEFAULT NULL COMMENT '0-No, 1-Yes'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_products`
--

INSERT INTO `loan_products` (`id`, `name`, `description`, `productType`, `availableTo`, `defAmount`, `minAmount`, `maxAmount`, `maxTranches`, `defInterest`, `minInterest`, `maxInterest`, `repaymentsMadeEvery`, `repaymentsFrequency`, `minRepaymentFrequency`, `maxRepaymentFrequency`, `daysOfYear`, `intialAccountState`, `defGracePeriod`, `minGracePeriod`, `maxGracePeriod`, `minCollateralRequired`, `minGuarantorsRequired`, `defaultOffSet`, `minOffSet`, `maxOffSet`, `penaltyApplicable`, `taxRateSource`, `taxCalculationMethod`, `linkToDepositAccount`) VALUES
(1, 'Development Loan', '', 0, 0, '0.00', '0.00', '0.00', NULL, NULL, '0.00', '0.00', 0, 0, 0, 0, 0, 0, 0, 0, 0, '0.00', 0, 0, 0, 0, 0, 0, 0, 0),
(2, 'Land Acquisition', '', 0, 0, '0.00', '0.00', '0.00', NULL, NULL, '0.00', '0.00', 0, 0, 0, 0, 0, 0, 0, 0, 0, '0.00', 0, 0, 0, 0, 0, 0, 0, 0),
(3, 'Quick Loan', '', 0, 0, '0.00', '0.00', '0.00', NULL, NULL, '0.00', '0.00', 0, 0, 0, 0, 0, 0, 0, 0, 0, '0.00', 0, 0, 0, 0, 0, 0, 0, 0),
(4, 'Land Title Acquisition', '', 0, 0, '0.00', '0.00', '0.00', NULL, NULL, '0.00', '0.00', 0, 0, 0, 0, 0, 0, 0, 0, 0, '0.00', 0, 0, 0, 0, 0, 0, 0, 0);

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
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Penalties that loan products can be subjected to';

-- --------------------------------------------------------

--
-- Table structure for table `loan_product_type`
--

CREATE TABLE `loan_product_type` (
  `id` int(11) NOT NULL,
  `typeName` varchar(50) NOT NULL COMMENT 'Name of the product type',
  `description` varchar(250) NOT NULL COMMENT 'Description',
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp record was entered',
  `dateModified` int(11) NOT NULL COMMENT 'Record modification date',
  `createdBy` int(11) NOT NULL COMMENT 'staff that entered record',
  `modifiedBy` int(11) NOT NULL COMMENT 'User modifying entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_product_type`
--

INSERT INTO `loan_product_type` (`id`, `typeName`, `description`, `dateCreated`, `dateModified`, `createdBy`, `modifiedBy`) VALUES
(1, 'Fixed Term Loan', 'A type of product with Fixed interest rate', 280092020, 280092020, 1, 1),
(2, 'Dynamic Term Loan', 'A type of product with Dynamic interest rate', 280092020, 280092020, 1, 1),
(3, 'Revolving Credit', 'A type of product that allows multiple disbursements and repayments on the account, similar to an overdraft, except that it has a payment plan associated with it in which some amount of principal and interest may be paid', 280092020, 280092020, 1, 1),
(4, 'Payment Plan', 'A type of product with no interest charged', 280092020, 280092020, 1, 1),
(5, 'Tranched Loan', 'A type of product that allows for loan disbursement in tranches', 280092020, 280092020, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `loan_repayment`
--

CREATE TABLE `loan_repayment` (
  `id` int(11) NOT NULL,
  `transactionId` int(11) NOT NULL,
  `branchId` int(11) NOT NULL,
  `loanId` int(11) NOT NULL COMMENT 'Loan ID',
  `amount` decimal(15,2) NOT NULL,
  `transactionType` tinyint(1) NOT NULL,
  `transactionDate` int(11) NOT NULL,
  `comments` text NOT NULL,
  `recievedBy` int(11) NOT NULL,
  `addedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_repayment`
--

INSERT INTO `loan_repayment` (`id`, `transactionId`, `branchId`, `loanId`, `amount`, `transactionType`, `transactionDate`, `comments`, `recievedBy`, `addedBy`) VALUES
(1, 43, 1, 1, '10200000.00', 1, 20170129, 'Fully paid up', 1, 0),
(2, 2443, 23, 4, '50000.00', 1, 20170124, 'Paid by cheque', 1, 54);

-- --------------------------------------------------------

--
-- Table structure for table `mdtransfer`
--

CREATE TABLE `mdtransfer` (
  `id` int(11) NOT NULL,
  `amount` varchar(100) NOT NULL,
  `sent_by` int(11) NOT NULL,
  `date_sent` date NOT NULL,
  `branch` int(11) NOT NULL,
  `bank` int(11) NOT NULL,
  `bank_branch` int(11) NOT NULL,
  `added_by` int(11) NOT NULL,
  `direction` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` int(11) NOT NULL,
  `personId` int(11) NOT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Whether member active or not',
  `branchId` int(11) NOT NULL COMMENT 'Ref to branch member registered from from',
  `memberType` int(11) NOT NULL,
  `dateAdded` int(11) NOT NULL COMMENT 'Timestamp of the moment the member was added',
  `added_by` int(11) NOT NULL,
  `comment` text,
  `dateModified` int(11) NOT NULL COMMENT 'Timestamp of the moment the member was modified',
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to staff who modified the record'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `personId`, `active`, `branchId`, `memberType`, `dateAdded`, `added_by`, `comment`, `dateModified`, `modifiedBy`) VALUES
(1, 2, 1, 0, 1, 20161116, 1, 'New member', 0, 0),
(2, 3, 0, 0, 0, 20161124, 1, 'Comments from here', 0, 0),
(3, 4, 1, 0, 0, 20161124, 1, 'Cissy buladde sacco', 0, 0),
(4, 7, 1, 0, 0, 20170108, 1, 'Registered from muganzirwaza', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `member_loan`
--

CREATE TABLE `member_loan` (
  `id` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `loanId` int(11) NOT NULL
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
  `dateAdded` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Methods for calculating penalities';

--
-- Dumping data for table `penalty_calculation_method`
--

INSERT INTO `penalty_calculation_method` (`id`, `methodDescription`, `dateAdded`, `createdBy`, `dateModified`, `modifiedBy`) VALUES
(1, 'No penalty', 280209228, 1, 280209228, 1),
(2, 'Overdue Principal * # of Late Days * Penalty Rate', 280209228, 1, 280209228, 1),
(3, '(Overdue Principal + Overdue Interest) * # of Late Days * Penalty Rate', 280209228, 1, 280209228, 1),
(4, 'Outstanding Principal * # of Late Days * Penalty Rate', 280209228, 1, 280209228, 1);

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
  `parish` int(11) NOT NULL,
  `village` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `gender`, `dateofbirth`, `phone`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `parish`, `village`) VALUES
(1, 'Mr', 2, 'S161116102242', 'Alfred', 'Platin', 'M', 0, 'B94994', 'M', '1988-08-08', '0702-771-124', 'mplat84@gmail.com', '', 'Kampala', '', 0, 0, '', '', 'First user registration', '2016-11-16 00:00:00', 1, 1, 1),
(2, 'Mr', 1, 'M161116200538', 'Brayan', 'Matovu', 'W', 0, '898438948934', 'M', '1987-08-08', '(0701) 108-622', 'mplat84@gmail.com', '36211 Kampala', 'Kampala', 'IT', 0, 0, '', '', 'New member', '2016-11-16 00:00:00', 1, 1, 1),
(3, 'Mr', 1, 'M241116093854', 'Allan', 'Jesse', '', 0, '8483934', 'M', '1987-03-02', '0702 771-124', 'mplat84@gmail.com', 'Hello there', 'Kampala ', 'Consultancy', 0, 0, '', '', 'Comments from here', '2016-11-24 00:00:00', 1, 1, 1),
(4, 'Mrs', 1, 'M241116095244', 'Cissy', 'Ge', '', 0, '8382383', 'F', '1984-01-07', '0702 771-124', 'mplat84@gmail.com', '', '36211 kampala', 'Finance', 0, 0, '', '', 'Cissy buladde sacco', '2016-11-24 00:00:00', 1, 1, 1),
(5, 'Mr', 2, 'S080117180211', 'Mathias', 'Musoke', '', 0, 'CM89808303939', '1', '1986-09-21', '0700-987-309', 'mmusoke@gmail.com', 'P O Box 34909 Kampala', 'Kitezi complex', '', 0, 0, '', '', 'Staff credentials accepted', '2017-01-08 00:00:00', 1, 1, 1),
(6, 'Mr', 2, 'S080117181259', 'Leonard', 'Kabuye', '', 0, '37838793893', 'M', '1976-02-08', '0702-711-332', 'mplat84@gmail.com', '', 'kampala', '', 0, 0, '', '', 'eweewe', '2017-01-08 00:00:00', 1, 1, 1),
(7, 'Mr', 1, 'BFS080117182251', 'Ronald', 'Matovu', '', 0, '67367367363', 'M', '1987-08-08', '0702 771-124', 'freddagates@empire.com', '256', 'kampala', 'IT Consultant', 0, 0, '', 'img/profiles/IMG_20160901_130726.jpg', 'Registered from muganzirwaza', '2017-01-08 00:00:00', 1, 1, 1);

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
  `person_id` int(11) NOT NULL,
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
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `name`, `description`) VALUES
(1, 'Administrator', NULL),
(2, 'Manager', NULL),
(3, 'Loans Officer', NULL),
(4, 'Supervisor', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `relationship_type`
--

CREATE TABLE `relationship_type` (
  `id` int(11) NOT NULL,
  `rel_type` varchar(100) NOT NULL COMMENT 'Type of relationship'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `relative`
--

CREATE TABLE `relative` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `next_of_kin` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 - Yes, 0 - No',
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `other_names` varchar(50) DEFAULT NULL,
  `gender` tinyint(2) NOT NULL,
  `relationship` tinyint(2) NOT NULL,
  `address` varchar(100) NOT NULL,
  `address2` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `repaymentduration`
--

CREATE TABLE `repaymentduration` (
  `id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL COMMENT 'Durations for a client to be repaying back the loan -- Weekly, Monthly, ',
  `no_of_days` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `repaymentduration`
--

INSERT INTO `repaymentduration` (`id`, `name`, `no_of_days`) VALUES
(1, 'Monthly repayment', 0),
(2, 'Quarterly repayment\r\n', 0),
(3, 'Half year repayment', 0),
(4, 'Annual repayment\r\n', 0),
(5, 'Weekly', 0);

-- --------------------------------------------------------

--
-- Table structure for table `saccogroup`
--

CREATE TABLE `saccogroup` (
  `id` int(11) NOT NULL,
  `description` varchar(150) NOT NULL,
  `dateCreated` int(11) NOT NULL COMMENT 'Timestamp of creation',
  `createdBy` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL COMMENT 'Timestamp at modification',
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `security`
--

CREATE TABLE `security` (
  `id` int(11) NOT NULL,
  `security_type` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `name` varchar(156) NOT NULL,
  `specification` text NOT NULL,
  `date_added` date NOT NULL,
  `approved_by` varchar(45) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `security`
--

INSERT INTO `security` (`id`, `security_type`, `loan_id`, `name`, `specification`, `date_added`, `approved_by`, `status`, `comment`) VALUES
(1, 1, 1, 'Land Title 50 X 100', 'Not developed lan', '2016-10-24', '3', 0, 'Land title was approved');

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
  `person_id` int(11) NOT NULL,
  `no_shares` int(10) UNSIGNED NOT NULL COMMENT 'No of shares',
  `amount` decimal(12,2) NOT NULL,
  `date_paid` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recorded_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shares`
--

INSERT INTO `shares` (`id`, `person_id`, `no_shares`, `amount`, `date_paid`, `recorded_by`) VALUES
(1, 2, 0, '43.00', '2016-11-29 11:50:41', 1),
(2, 3, 0, '42.00', '2016-11-29 11:50:41', 1),
(3, 4, 0, '28.00', '2016-11-29 11:50:41', 1);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
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

INSERT INTO `staff` (`id`, `person_id`, `branch_id`, `position_id`, `username`, `password`, `access_level`, `status`, `start_date`, `end_date`, `date_added`, `added_by`) VALUES
(1, 1, 0, 1, 'platin', '807c1c8ea54c81e6167a19275211b2a3', 1, 1, '0000-00-00', NULL, '2016-11-16', '1'),
(2, 5, 0, 3, 'mmusoke', 'a698aac3a8775508d6a03cb9fa002a1f', 3, 1, '0000-00-00', NULL, '2017-01-08', '1'),
(3, 6, 0, 4, 'lkabuye', '6dd59a8d3ddd2527963b972c7014b1e9', 2, 1, '0000-00-00', NULL, '2017-01-08', '1');

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
  `dateModified` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL COMMENT 'Reference to the staff modifying the entry'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`id`, `personId`, `amount`, `subscriptionYear`, `paidBy`, `receivedBy`, `datePaid`, `dateModified`, `modifiedBy`) VALUES
(1, 4, '20000.00', 2016, 0, 1, 20161124, 2147483647, 0),
(2, 7, '20000.00', 2017, 0, 1, 20170108, 2147483647, 0);

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
  `dateModified` int(11) NOT NULL COMMENT 'Unix timestamp for the datetime modified',
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
  `person_id` int(11) NOT NULL,
  `amount` varchar(45) NOT NULL,
  `amount_description` varchar(256) NOT NULL,
  `transacted_by` varchar(100) NOT NULL,
  `transaction_date` date NOT NULL,
  `approved_by` varchar(45) NOT NULL,
  `comments` text NOT NULL,
  `date_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `transaction_type`, `branch_number`, `person_id`, `amount`, `amount_description`, `transacted_by`, `transaction_date`, `approved_by`, `comments`, `date_modified`) VALUES
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
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `staff_number` varchar(45) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `access_level` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `validity` int(11) NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `created_by` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `staff_number`, `username`, `password`, `access_level`, `date_created`, `validity`, `status`, `created_by`) VALUES
(1, '1', 'platin', '9e11830101b6b723ae3fb11e660a2123', 2, '2016-10-23 00:00:00', 1, '1', '1'),
(2, '2', 'cmurungi', '2d38c92d23c2f449db7c016c4f7e56e9', 1, '2016-10-24 07:21:40', 1, 'Active', '1 - platin'),
(3, '3', 'bmatovu', '542183e2280fde195b0cd2b2339dabac', 3, '2016-10-24 07:24:18', 1, 'Active', '2 - cmurungi');

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
  ADD KEY `person_id` (`person_id`);

--
-- Indexes for table `account_transaction`
--
ALTER TABLE `account_transaction`
  ADD KEY `person_id` (`person_id`);

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
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employment`
--
ALTER TABLE `employment`
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
-- Indexes for table `fees`
--
ALTER TABLE `fees`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `group_loan`
--
ALTER TABLE `group_loan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkGroupId` (`groupId`),
  ADD KEY `fkLoanId` (`loanId`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD KEY `fkMemberId` (`memberId`),
  ADD KEY `fkGroupId` (`groupId`),
  ADD KEY `fkModifiedBy` (`modifiedBy`),
  ADD KEY `fkCreatedBy` (`createdBy`);

--
-- Indexes for table `guarantor`
--
ALTER TABLE `guarantor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_number` (`person_id`),
  ADD KEY `loan_id` (`loan_id`);

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
  ADD KEY `loanProductId` (`loanProductId`);

--
-- Indexes for table `loan_documents`
--
ALTER TABLE `loan_documents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_fee`
--
ALTER TABLE `loan_fee`
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
  ADD KEY `fkLinkToDepositAccount` (`linkToDepositAccount`) USING BTREE;

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
-- Indexes for table `loan_product_type`
--
ALTER TABLE `loan_product_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_repayment`
--
ALTER TABLE `loan_repayment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loanId`),
  ADD KEY `transaction_date` (`transactionDate`),
  ADD KEY `recieving_staff` (`recievedBy`);

--
-- Indexes for table `mdtransfer`
--
ALTER TABLE `mdtransfer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id`),
  ADD KEY `added_by` (`added_by`),
  ADD KEY `person_id` (`personId`);

--
-- Indexes for table `member_loan`
--
ALTER TABLE `member_loan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkMemberId` (`memberId`),
  ADD KEY `fkLoanId` (`loanId`);

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
-- Indexes for table `relative`
--
ALTER TABLE `relative`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`person_id`);

--
-- Indexes for table `repaymentduration`
--
ALTER TABLE `repaymentduration`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `saccogroup`
--
ALTER TABLE `saccogroup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `modifiedBy` (`modifiedBy`),
  ADD KEY `createdBy` (`createdBy`);

--
-- Indexes for table `security`
--
ALTER TABLE `security`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loan_id`);

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
  ADD KEY `purchase_date` (`date_paid`),
  ADD KEY `person_id` (`person_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`person_id`),
  ADD KEY `branch_id` (`branch_id`),
  ADD KEY `person_id_2` (`person_id`),
  ADD KEY `person_id_3` (`person_id`);

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
  ADD KEY `person_id` (`person_id`);

--
-- Indexes for table `transfer`
--
ALTER TABLE `transfer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
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
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `employment`
--
ALTER TABLE `employment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
-- AUTO_INCREMENT for table `fees`
--
ALTER TABLE `fees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `gender`
--
ALTER TABLE `gender`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `group_loan`
--
ALTER TABLE `group_loan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `guarantor`
--
ALTER TABLE `guarantor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `id_card_types`
--
ALTER TABLE `id_card_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_fee`
--
ALTER TABLE `loan_fee`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `loan_products_penalty`
--
ALTER TABLE `loan_products_penalty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
-- AUTO_INCREMENT for table `mdtransfer`
--
ALTER TABLE `mdtransfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `persontype`
--
ALTER TABLE `persontype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `relationship_type`
--
ALTER TABLE `relationship_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `relative`
--
ALTER TABLE `relative`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `repaymentduration`
--
ALTER TABLE `repaymentduration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `saccogroup`
--
ALTER TABLE `saccogroup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `security`
--
ALTER TABLE `security`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
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
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `village`
--
ALTER TABLE `village`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
