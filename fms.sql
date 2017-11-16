-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 15, 2017 at 03:09 PM
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
(2, 'FREE SAVINGS', 'SAVINGS WITHDRAW-ABLE AT ANY TIME ', 1, 3, '2000.00', '5000000.00', 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 0, '2000.00', '2000.00', '0.00', 0, 0, 0, 1, 0, 1510036235, 1, 1510036235, '0000-00-00 00:00:00');

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
  `interestRate` decimal(4,2) NOT NULL,
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
  `attachmentUrl` varchar(150) DEFAULT NULL,
  `dateCreated` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modifiedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(1, 'individual loan', 'provides individual collateral', 1, 1, 1, '100000.00', '100000.00', '30000000.00', 1, '24.00', '24.00', '30.00', 1, 3, 1, 1, 36, 1, 0, 0, 0, '25.00', 1, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510138090, 1, '2017-11-08 10:48:10', 1),
(2, 'Quick loan', 'quick loan to individuals', 1, 1, 1, '100000.00', '100000.00', '30000000.00', 1, '60.00', '60.00', '99.99', 1, 3, 1, 1, 12, 1, 0, 0, 0, '25.00', 0, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510138955, 1, '2017-11-08 11:02:35', 1),
(3, 'Group Loan', ' Group Loan', 1, 1, 3, '100000.00', '100000.00', '30000000.00', 1, '30.00', '25.00', '30.00', 1, 2, 1, 1, 127, 1, 0, 0, 0, '25.00', 0, 7, 7, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510139226, 1, '2017-11-08 11:07:06', 1),
(4, 'Salary', ' Salary Loan', 1, 1, 3, '100000.00', '100000.00', '30000000.00', 1, '24.00', '10.00', '30.00', 1, 3, 1, 1, 36, 1, 0, 0, 0, '25.00', 1, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 0, 1510139922, 1, '2017-11-08 11:18:42', 1),
(5, 'Land Acquisitation / Development', 'Land Acquisitation / Development', 1, 1, 1, '100000.00', '100000.00', '30000000.00', 1, '25.00', '10.00', '30.00', 1, 3, 1, 1, 36, 1, 0, 0, 0, '25.00', 1, 30, 30, 30, NULL, 1, 0, 0, '0.00', '0.00', '0.00', 0, 0, 0, 1, 1510140192, 1, '2017-11-08 11:23:12', 1);

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
(2, 'Insurance Fee', 1, 2, 1, '2.00', 1508144331, 1, '2017-10-16 08:58:51', 1),
(3, 'Compulsary Saving', 1, 2, 1, '10.00', 1508144331, 1, '2017-10-16 08:58:51', 1),
(4, 'Loan Form Fee', 1, 1, 1, '20000.00', 1510070142, 1, '2017-11-08 10:48:48', 1),
(5, 'Application fee', 1, 2, 1, '3.00', 1510138090, 1, '2017-11-08 10:48:10', 1);

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
(1, 1, 5, 1, 1510138091, 1, '2017-11-08 10:48:11'),
(2, 1, 2, 1, 1510138091, 1, '2017-11-08 10:48:11'),
(3, 1, 3, 1, 1510138091, 1, '2017-11-08 10:48:11'),
(4, 1, 4, 1, 1510138091, 1, '2017-11-08 10:48:11'),
(5, 2, 2, 1, 1510138955, 1, '2017-11-08 11:02:35'),
(6, 2, 4, 1, 1510138955, 1, '2017-11-08 11:02:35'),
(7, 2, 5, 1, 1510138955, 1, '2017-11-08 11:02:35'),
(8, 2, 3, 1, 1510138955, 1, '2017-11-08 11:02:35'),
(9, 3, 2, 1, 1510139226, 1, '2017-11-08 11:07:06'),
(10, 3, 4, 1, 1510139226, 1, '2017-11-08 11:07:06'),
(11, 3, 5, 1, 1510139226, 1, '2017-11-08 11:07:06'),
(12, 3, 3, 1, 1510139226, 1, '2017-11-08 11:07:06'),
(13, 4, 2, 1, 1510139922, 1, '2017-11-08 11:18:42'),
(14, 4, 4, 1, 1510139923, 1, '2017-11-08 11:18:43'),
(15, 4, 5, 1, 1510139923, 1, '2017-11-08 11:18:43'),
(16, 4, 3, 1, 1510139923, 1, '2017-11-08 11:18:43'),
(17, 5, 2, 1, 1510140192, 1, '2017-11-08 11:23:12'),
(18, 5, 3, 1, 1510140192, 1, '2017-11-08 11:23:12'),
(19, 5, 4, 1, 1510140192, 1, '2017-11-08 11:23:12'),
(20, 5, 5, 1, 1510140192, 1, '2017-11-08 11:23:12');

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
  `modifiedBy` int(11) NOT NULL COMMENT 'User modifying entry',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_product_type`
--

INSERT INTO `loan_product_type` (`id`, `typeName`, `description`, `dateCreated`, `dateModified`, `createdBy`, `modifiedBy`, `active`) VALUES
(1, 'Fixed Term Loan', 'A Fixed interest rate which allows accurate prediction of future payments', 0, '2017-06-26 13:35:13', 0, 0, 1),
(2, 'Dynamic Term Loan', 'Allows dynamic calculation of the interest rate, and thus, future payments\r\n', 0, '2017-06-26 13:35:40', 0, 0, 1);

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
(1, 1, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:46', 1),
(2, 2, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:46', 1),
(3, 3, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:46', 1),
(4, 4, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:47', 1),
(5, 5, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:47', 1),
(6, 6, 1, 1, 1, 1476309600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:47', 1),
(7, 7, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:47', 1),
(8, 8, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(9, 9, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(10, 10, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(11, 11, 1, 1, 1, 1504476000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(12, 12, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(13, 13, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(14, 14, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(15, 15, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(16, 16, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:48', 1),
(17, 17, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:49', 1),
(18, 18, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:49', 1),
(19, 19, 1, 1, 1, 1504562400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:49', 1),
(20, 20, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:49', 1),
(21, 21, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:50', 1),
(22, 22, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:50', 1),
(23, 23, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:51', 1),
(24, 24, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:51', 1),
(25, 25, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:51', 1),
(26, 26, 1, 1, 1, 1501711200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:52', 1),
(27, 27, 1, 1, 1, 1509055200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:52', 1),
(28, 28, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:52', 1),
(29, 29, 1, 1, 1, 1497564000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:52', 1),
(30, 30, 1, 1, 1, 1491170400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:52', 1),
(31, 31, 1, 1, 1, 1503957600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(32, 32, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(33, 33, 1, 1, 1, 1472594400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(34, 34, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(35, 35, 1, 1, 1, 1501020000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(36, 36, 1, 1, 1, 1476914400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(37, 37, 1, 1, 1, 1481065200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:53', 1),
(38, 38, 1, 1, 1, 1479164400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:54', 1),
(39, 39, 1, 1, 1, 1478646000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:54', 1),
(40, 40, 1, 1, 1, 1502229600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:54', 1),
(41, 41, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:54', 1),
(42, 42, 1, 1, 1, 1506376800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:54', 1),
(43, 43, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:54', 1),
(44, 44, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(45, 45, 1, 1, 1, 1482274800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(46, 46, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(47, 47, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(48, 48, 1, 1, 1, 1506636000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(49, 49, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(50, 50, 1, 1, 1, 1478214000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(51, 51, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:55', 1),
(52, 52, 1, 1, 1, 1499637600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:56', 1),
(53, 53, 1, 1, 1, 1507759200, 1, 'This member data was exported from an excel', '2017-11-15 08:22:56', 1),
(54, 54, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:56', 1),
(55, 55, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:56', 1),
(56, 56, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:56', 1),
(57, 57, 1, 1, 1, 1494194400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:57', 1),
(58, 58, 1, 1, 1, 1505685600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:57', 1),
(59, 59, 1, 1, 1, 1507672800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:57', 1),
(60, 60, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:57', 1),
(61, 61, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:57', 1),
(62, 62, 1, 1, 1, 1494453600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:57', 1),
(63, 63, 1, 1, 1, 1472594400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:58', 1),
(64, 64, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:58', 1),
(65, 65, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:58', 1),
(66, 66, 1, 1, 1, 1476309600, 1, 'This member data was exported from an excel', '2017-11-15 08:22:58', 1),
(67, 67, 1, 1, 1, 1504044000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:58', 1),
(68, 68, 1, 1, 1, 1504476000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:59', 1),
(69, 69, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:22:59', 1),
(70, 70, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:22:59', 1),
(71, 71, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:59', 1),
(72, 72, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:22:59', 1),
(73, 73, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:00', 1),
(74, 74, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:00', 1),
(75, 75, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:00', 1),
(76, 76, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:01', 1),
(77, 77, 1, 1, 1, 1477519200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:01', 1),
(78, 78, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:01', 1),
(79, 79, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:01', 1),
(80, 80, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:02', 1),
(81, 81, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:02', 1),
(82, 82, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:03', 1),
(83, 83, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:03', 1),
(84, 84, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(85, 85, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(86, 86, 1, 1, 1, 1503007200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(87, 87, 1, 1, 1, 1506549600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(88, 88, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(89, 89, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(90, 90, 1, 1, 1, 1509055200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:04', 1),
(91, 91, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:05', 1),
(92, 92, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:05', 1),
(93, 93, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:05', 1),
(94, 94, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:05', 1),
(95, 95, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:05', 1),
(96, 96, 1, 1, 1, 1499119200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:06', 1),
(97, 97, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:06', 1),
(98, 98, 1, 1, 1, 1509404400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:06', 1),
(99, 99, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:06', 1),
(100, 100, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:06', 1),
(101, 101, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:07', 1),
(102, 102, 1, 1, 1, 1499637600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:07', 1),
(103, 103, 1, 1, 1, 1475532000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:07', 1),
(104, 104, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:07', 1),
(105, 105, 1, 1, 1, 1507586400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:07', 1),
(106, 106, 1, 1, 1, 1507586400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:07', 1),
(107, 107, 1, 1, 1, 1509404400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:08', 1),
(108, 108, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:08', 1),
(109, 109, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:08', 1),
(110, 110, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:08', 1),
(111, 111, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:08', 1),
(112, 112, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(113, 113, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(114, 114, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(115, 115, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(116, 116, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(117, 117, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(118, 118, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(119, 119, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:09', 1),
(120, 120, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:10', 1),
(121, 121, 1, 1, 1, 1494799200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:10', 1),
(122, 122, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:10', 1),
(123, 123, 1, 1, 1, 1509318000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:10', 1),
(124, 124, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:10', 1),
(125, 125, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:10', 1),
(126, 126, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:11', 1),
(127, 127, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:11', 1),
(128, 128, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:11', 1),
(129, 129, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:12', 1),
(130, 130, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:12', 1),
(131, 131, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:12', 1),
(132, 132, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:12', 1),
(133, 133, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:13', 1),
(134, 134, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:14', 1),
(135, 135, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:14', 1),
(136, 136, 1, 1, 1, 1476655200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:14', 1),
(137, 137, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:14', 1),
(138, 138, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:14', 1),
(139, 139, 1, 1, 1, 1510744119, 1, 'This member data was exported from an excel', '2017-11-15 11:09:40', 1),
(140, 140, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:15', 1),
(141, 141, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:15', 1),
(142, 142, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:15', 1),
(143, 143, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:15', 1),
(144, 144, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:15', 1),
(145, 145, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:15', 1),
(146, 146, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:16', 1),
(147, 147, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:16', 1),
(148, 148, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:16', 1),
(149, 149, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:16', 1),
(150, 150, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:16', 1),
(151, 151, 1, 1, 1, 1501020000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:17', 1),
(152, 152, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:17', 1),
(153, 153, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:17', 1),
(154, 154, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:17', 1),
(155, 155, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:17', 1),
(156, 156, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:17', 1),
(157, 157, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:18', 1),
(158, 158, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:18', 1),
(159, 159, 1, 1, 1, 1508364000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:18', 1),
(160, 160, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:18', 1),
(161, 161, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(162, 162, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(163, 163, 1, 1, 1, 1494194400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(164, 164, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(165, 165, 1, 1, 1, 1500501600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(166, 166, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(167, 167, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:19', 1),
(168, 168, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(169, 169, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(170, 170, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(171, 171, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(172, 172, 1, 1, 1, 1496786400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(173, 173, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(174, 174, 1, 1, 1, 1480028400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(175, 175, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(176, 176, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(177, 177, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:20', 1),
(178, 178, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:21', 1),
(179, 179, 1, 1, 1, 1503957600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:21', 1),
(180, 180, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:21', 1),
(181, 181, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:21', 1),
(182, 182, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:21', 1),
(183, 183, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:22', 1),
(184, 184, 1, 1, 1, 1502402400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:22', 1),
(185, 185, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:23', 1),
(186, 186, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:23', 1),
(187, 187, 1, 1, 1, 1505858400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:23', 1),
(188, 188, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:23', 1),
(189, 189, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:24', 1),
(190, 190, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:24', 1),
(191, 191, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(192, 192, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(193, 193, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(194, 194, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(195, 195, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(196, 196, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(197, 197, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:25', 1),
(198, 198, 1, 1, 1, 1501884000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(199, 199, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(200, 200, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(201, 201, 1, 1, 1, 1494280800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(202, 202, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(203, 203, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(204, 204, 1, 1, 1, 1480028400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:26', 1),
(205, 205, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:27', 1),
(206, 206, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:27', 1),
(207, 207, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:27', 1),
(208, 208, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:27', 1),
(209, 209, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:27', 1),
(210, 210, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(211, 211, 1, 1, 1, 1497909600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(212, 212, 1, 1, 1, 1479855600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(213, 213, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(214, 214, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(215, 215, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(216, 216, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(217, 217, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(218, 218, 1, 1, 1, 1499724000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:28', 1),
(219, 219, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(220, 220, 1, 1, 1, 1479423600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(221, 221, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(222, 222, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(223, 223, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(224, 224, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(225, 225, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(226, 226, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(227, 227, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:29', 1),
(228, 228, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:30', 1),
(229, 229, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:30', 1),
(230, 230, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:30', 1),
(231, 231, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:30', 1),
(232, 232, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:30', 1),
(233, 233, 1, 1, 1, 1500242400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:30', 1),
(234, 234, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:31', 1),
(235, 235, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:31', 1),
(236, 236, 1, 1, 1, 1506895200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:31', 1),
(237, 237, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:32', 1),
(238, 238, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:32', 1),
(239, 239, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:33', 1),
(240, 240, 1, 1, 1, 1504821600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:33', 1),
(241, 241, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:33', 1),
(242, 242, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:33', 1),
(243, 243, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:34', 1),
(244, 244, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:34', 1),
(245, 245, 1, 1, 1, 1499292000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:35', 1),
(246, 246, 1, 1, 1, 1501452000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:35', 1),
(247, 247, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:35', 1),
(248, 248, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:36', 1),
(249, 249, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:36', 1),
(250, 250, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:36', 1),
(251, 251, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:36', 1),
(252, 252, 1, 1, 1, 1479164400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:36', 1),
(253, 253, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:36', 1),
(254, 254, 1, 1, 1, 1501711200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(255, 255, 1, 1, 1, 1496786400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(256, 256, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(257, 257, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(258, 258, 1, 1, 1, 1491516000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(259, 259, 1, 1, 1, 1495144800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(260, 260, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(261, 261, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:37', 1),
(262, 262, 1, 1, 1, 1472767200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(263, 263, 1, 1, 1, 1493935200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(264, 264, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(265, 265, 1, 1, 1, 1495490400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(266, 266, 1, 1, 1, 1491343200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(267, 267, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(268, 268, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:38', 1),
(269, 269, 1, 1, 1, 1477519200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(270, 270, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(271, 271, 1, 1, 1, 1497909600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(272, 272, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(273, 273, 1, 1, 1, 1507672800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(274, 274, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(275, 275, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:39', 1),
(276, 276, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(277, 277, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(278, 278, 1, 1, 1, 1493935200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(279, 279, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(280, 280, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(281, 281, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(282, 282, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:40', 1),
(283, 283, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:41', 1),
(284, 284, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:41', 1),
(285, 285, 1, 1, 1, 1491343200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:41', 1),
(286, 286, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:41', 1),
(287, 287, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:41', 1),
(288, 288, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:41', 1),
(289, 289, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:42', 1),
(290, 290, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:42', 1),
(291, 291, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:42', 1),
(292, 292, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:43', 1),
(293, 293, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:43', 1),
(294, 294, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:43', 1),
(295, 295, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:43', 1),
(296, 296, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:44', 1),
(297, 297, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:44', 1),
(298, 298, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:44', 1),
(299, 299, 1, 1, 1, 1491170400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:44', 1),
(300, 300, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:45', 1),
(301, 301, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:45', 1),
(302, 302, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:45', 1),
(303, 303, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:45', 1),
(304, 304, 1, 1, 1, 1496872800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:45', 1),
(305, 305, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:45', 1),
(306, 306, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:46', 1),
(307, 307, 1, 1, 1, 1494799200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:46', 1),
(308, 308, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:46', 1),
(309, 309, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(310, 310, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(311, 311, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(312, 312, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(313, 313, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(314, 314, 1, 1, 1, 1494540000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(315, 315, 1, 1, 1, 1480028400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:47', 1),
(316, 316, 1, 1, 1, 1506463200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(317, 317, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(318, 318, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(319, 319, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(320, 320, 1, 1, 1, 1493589600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(321, 321, 1, 1, 1, 1502748000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(322, 322, 1, 1, 1, 1502229600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:48', 1),
(323, 323, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(324, 324, 1, 1, 1, 1484521200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(325, 325, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(326, 326, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(327, 327, 1, 1, 1, 1508104800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(328, 328, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(329, 329, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(330, 330, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(331, 331, 1, 1, 1, 1502316000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:49', 1),
(332, 332, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(333, 333, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(334, 334, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(335, 335, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(336, 336, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(337, 337, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(338, 338, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(339, 339, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:50', 1),
(340, 340, 1, 1, 1, 1497564000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:51', 1),
(341, 341, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:51', 1),
(342, 342, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:51', 1),
(343, 343, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:52', 1),
(344, 344, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:52', 1),
(345, 345, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:53', 1),
(346, 346, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:53', 1),
(347, 347, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:53', 1),
(348, 348, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:53', 1),
(349, 349, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:53', 1),
(350, 350, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:54', 1),
(351, 351, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:54', 1),
(352, 352, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:54', 1),
(353, 353, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:54', 1),
(354, 354, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:55', 1),
(355, 355, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:55', 1),
(356, 356, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:55', 1),
(357, 357, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:55', 1),
(358, 358, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:55', 1),
(359, 359, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:55', 1),
(360, 360, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:56', 1),
(361, 361, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:56', 1),
(362, 362, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:56', 1),
(363, 363, 1, 1, 1, 1475532000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:56', 1),
(364, 364, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:56', 1),
(365, 365, 1, 1, 1, 1491170400, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(366, 366, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(367, 367, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(368, 368, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(369, 369, 1, 1, 1, 1496700000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(370, 370, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(371, 371, 1, 1, 1, 1496008800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(372, 372, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(373, 373, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:57', 1),
(374, 374, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:58', 1),
(375, 375, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:58', 1),
(376, 376, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:58', 1),
(377, 377, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:58', 1),
(378, 378, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:58', 1),
(379, 379, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:58', 1),
(380, 380, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:59', 1),
(381, 381, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:59', 1),
(382, 382, 1, 1, 1, 1494453600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:59', 1),
(383, 383, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 08:23:59', 1),
(384, 384, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 08:23:59', 1),
(385, 385, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:23:59', 1),
(386, 386, 1, 1, 1, 1483570800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:00', 1),
(387, 387, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:00', 1),
(388, 388, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:00', 1),
(389, 389, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:00', 1),
(390, 390, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:00', 1),
(391, 391, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:00', 1),
(392, 392, 1, 1, 1, 1508709600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(393, 393, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(394, 394, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(395, 395, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(396, 396, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(397, 397, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(398, 398, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(399, 399, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:01', 1),
(400, 400, 1, 1, 1, 1490911200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:02', 1),
(401, 401, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:02', 1),
(402, 402, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:02', 1),
(403, 403, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:03', 1),
(404, 404, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:03', 1),
(405, 405, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:03', 1),
(406, 406, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:04', 1),
(407, 407, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:04', 1),
(408, 408, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:04', 1),
(409, 409, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:04', 1),
(410, 410, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:04', 1),
(411, 411, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(412, 412, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(413, 413, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(414, 414, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(415, 415, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(416, 416, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(417, 417, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:05', 1),
(418, 418, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:06', 1),
(419, 419, 1, 1, 1, 1491775200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:06', 1),
(420, 420, 1, 1, 1, 1492466400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:07', 1),
(421, 421, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:07', 1),
(422, 422, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:07', 1),
(423, 423, 1, 1, 1, 1508191200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:07', 1),
(424, 424, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:07', 1),
(425, 425, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:08', 1),
(426, 426, 1, 1, 1, 1500588000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:08', 1),
(427, 427, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:08', 1),
(428, 428, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:08', 1),
(429, 429, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:08', 1),
(430, 430, 1, 1, 1, 1491256800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:08', 1),
(431, 431, 1, 1, 1, 1495144800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(432, 432, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(433, 433, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(434, 434, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(435, 435, 1, 1, 1, 1499205600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(436, 436, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(437, 437, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(438, 438, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:09', 1),
(439, 439, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:10', 1),
(440, 440, 1, 1, 1, 1509055200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:10', 1),
(441, 441, 1, 1, 1, 1481583600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:10', 1),
(442, 442, 1, 1, 1, 1477000800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:10', 1),
(443, 443, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:10', 1),
(444, 444, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:10', 1),
(445, 445, 1, 1, 1, 1500415200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(446, 446, 1, 1, 1, 1493330400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(447, 447, 1, 1, 1, 1504044000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(448, 448, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(449, 449, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(450, 450, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(451, 451, 1, 1, 1, 1476223200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:11', 1),
(452, 452, 1, 1, 1, 1501106400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:12', 1),
(453, 453, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:12', 1),
(454, 454, 1, 1, 1, 1505340000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:12', 1),
(455, 455, 1, 1, 1, 1506895200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:12', 1),
(456, 456, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:13', 1),
(457, 457, 1, 1, 1, 1492466400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:13', 1),
(458, 458, 1, 1, 1, 1502229600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:14', 1),
(459, 459, 1, 1, 1, 1479078000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:14', 1),
(460, 460, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:14', 1),
(461, 461, 1, 1, 1, 1502402400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:14', 1),
(462, 462, 1, 1, 1, 1501797600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1),
(463, 463, 1, 1, 1, 1484175600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1),
(464, 464, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1),
(465, 465, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1),
(466, 466, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1),
(467, 467, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1);
INSERT INTO `member` (`id`, `personId`, `active`, `branch_id`, `memberType`, `dateAdded`, `addedBy`, `comment`, `dateModified`, `modifiedBy`) VALUES
(468, 468, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:15', 1),
(469, 469, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:16', 1),
(470, 470, 1, 1, 1, 1503525600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:16', 1),
(471, 471, 1, 1, 1, 1504648800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:16', 1),
(472, 472, 1, 1, 1, 1500933600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:16', 1),
(473, 473, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:16', 1),
(474, 474, 1, 1, 1, 1502748000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:17', 1),
(475, 475, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:17', 1),
(476, 476, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:17', 1),
(477, 477, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:17', 1),
(478, 478, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:17', 1),
(479, 479, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:17', 1),
(480, 480, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:18', 1),
(481, 481, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:18', 1),
(482, 482, 1, 1, 1, 1505685600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:18', 1),
(483, 483, 1, 1, 1, 1502316000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:18', 1),
(484, 484, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:18', 1),
(485, 485, 1, 1, 1, 1476914400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:18', 1),
(486, 486, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(487, 487, 1, 1, 1, 1494972000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(488, 488, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(489, 489, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(490, 490, 1, 1, 1, 1470693600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(491, 491, 1, 1, 1, 1480546800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(492, 492, 1, 1, 1, 1502834400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:19', 1),
(493, 493, 1, 1, 1, 1506549600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(494, 494, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(495, 495, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(496, 496, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(497, 497, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(498, 498, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(499, 499, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:20', 1),
(500, 500, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:21', 1),
(501, 501, 1, 1, 1, 1499292000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:21', 1),
(502, 502, 1, 1, 1, 1501711200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:21', 1),
(503, 503, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:21', 1),
(504, 504, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:22', 1),
(505, 505, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:22', 1),
(506, 506, 1, 1, 1, 1493589600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:22', 1),
(507, 507, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:23', 1),
(508, 508, 1, 1, 1, 1495058400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:23', 1),
(509, 509, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:23', 1),
(510, 510, 1, 1, 1, 1493676000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:23', 1),
(511, 511, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:24', 1),
(512, 512, 1, 1, 1, 1504562400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:24', 1),
(513, 513, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:24', 1),
(514, 514, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:24', 1),
(515, 515, 1, 1, 1, 1479942000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:25', 1),
(516, 516, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:26', 1),
(517, 517, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:26', 1),
(518, 518, 1, 1, 1, 1507154400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:26', 1),
(519, 519, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:26', 1),
(520, 520, 1, 1, 1, 1500501600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:26', 1),
(521, 521, 1, 1, 1, 1499032800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:27', 1),
(522, 522, 1, 1, 1, 1507240800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:27', 1),
(523, 523, 1, 1, 1, 1478214000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:27', 1),
(524, 524, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:27', 1),
(525, 525, 1, 1, 1, 1493935200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:27', 1),
(526, 526, 1, 1, 1, 1509318000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:28', 1),
(527, 527, 1, 1, 1, 1496786400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:28', 1),
(528, 528, 1, 1, 1, 1476914400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:28', 1),
(529, 529, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:28', 1),
(530, 530, 1, 1, 1, 1495058400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:28', 1),
(531, 531, 1, 1, 1, 1492639200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:28', 1),
(532, 532, 1, 1, 1, 1492466400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(533, 533, 1, 1, 1, 1495490400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(534, 534, 1, 1, 1, 1501106400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(535, 535, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(536, 536, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(537, 537, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(538, 538, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:29', 1),
(539, 539, 1, 1, 1, 1499637600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(540, 540, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(541, 541, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(542, 542, 1, 1, 1, 1478214000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(543, 543, 1, 1, 1, 1499292000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(544, 544, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(545, 545, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(546, 546, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:30', 1),
(547, 547, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:31', 1),
(548, 548, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:31', 1),
(549, 549, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:31', 1),
(550, 550, 1, 1, 1, 1504476000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:31', 1),
(551, 551, 1, 1, 1, 1494453600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:31', 1),
(552, 552, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:31', 1),
(553, 553, 1, 1, 1, 1477605600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:32', 1),
(554, 554, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:32', 1),
(555, 555, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:32', 1),
(556, 556, 1, 1, 1, 1494367200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:32', 1),
(557, 557, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:32', 1),
(558, 558, 1, 1, 1, 1502316000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:32', 1),
(559, 559, 1, 1, 1, 1508277600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:33', 1),
(560, 560, 1, 1, 1, 1497391200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:33', 1),
(561, 561, 1, 1, 1, 1479078000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:33', 1),
(562, 562, 1, 1, 1, 1502920800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:34', 1),
(563, 563, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:34', 1),
(564, 564, 1, 1, 1, 1501106400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:35', 1),
(565, 565, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:35', 1),
(566, 566, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:35', 1),
(567, 567, 1, 1, 1, 1507240800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:36', 1),
(568, 568, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:36', 1),
(569, 569, 1, 1, 1, 1493071200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:36', 1),
(570, 570, 1, 1, 1, 1499983200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:37', 1),
(571, 571, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:37', 1),
(572, 572, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:37', 1),
(573, 573, 1, 1, 1, 1480546800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:37', 1),
(574, 574, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:37', 1),
(575, 575, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:37', 1),
(576, 576, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:38', 1),
(577, 577, 1, 1, 1, 1506636000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:38', 1),
(578, 578, 1, 1, 1, 1493244000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:38', 1),
(579, 579, 1, 1, 1, 1500242400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:38', 1),
(580, 580, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(581, 581, 1, 1, 1, 1476396000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(582, 582, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(583, 583, 1, 1, 1, 1503007200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(584, 584, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(585, 585, 1, 1, 1, 1500933600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(586, 586, 1, 1, 1, 1495663200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:39', 1),
(587, 587, 1, 1, 1, 1498600800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:40', 1),
(588, 588, 1, 1, 1, 1475013600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:40', 1),
(589, 589, 1, 1, 1, 1476223200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:40', 1),
(590, 590, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:40', 1),
(591, 591, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:41', 1),
(592, 592, 1, 1, 1, 1506290400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:41', 1),
(593, 593, 1, 1, 1, 1493589600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:41', 1),
(594, 594, 1, 1, 1, 1491861600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:41', 1),
(595, 595, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:41', 1),
(596, 596, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:42', 1),
(597, 597, 1, 1, 1, 1503525600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:42', 1),
(598, 598, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:42', 1),
(599, 599, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:42', 1),
(600, 600, 1, 1, 1, 1491343200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:42', 1),
(601, 601, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:42', 1),
(602, 602, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(603, 603, 1, 1, 1, 1501452000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(604, 604, 1, 1, 1, 1503352800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(605, 605, 1, 1, 1, 1506549600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(606, 606, 1, 1, 1, 1505080800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(607, 607, 1, 1, 1, 1501452000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(608, 608, 1, 1, 1, 1502402400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(609, 609, 1, 1, 1, 1480287600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:43', 1),
(610, 610, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:44', 1),
(611, 611, 1, 1, 1, 1499896800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:44', 1),
(612, 612, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:44', 1),
(613, 613, 1, 1, 1, 1477260000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:44', 1),
(614, 614, 1, 1, 1, 1472594400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:44', 1),
(615, 615, 1, 1, 1, 1498428000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:45', 1),
(616, 616, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:46', 1),
(617, 617, 1, 1, 1, 1492034400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:46', 1),
(618, 618, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:46', 1),
(619, 619, 1, 1, 1, 1504130400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:47', 1),
(620, 620, 1, 1, 1, 1484694000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:47', 1),
(621, 621, 1, 1, 1, 1506463200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:47', 1),
(622, 622, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:48', 1),
(623, 623, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:48', 1),
(624, 624, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:48', 1),
(625, 625, 1, 1, 1, 1474236000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:48', 1),
(626, 626, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:48', 1),
(627, 627, 1, 1, 1, 1493762400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:49', 1),
(628, 628, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:49', 1),
(629, 629, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:49', 1),
(630, 630, 1, 1, 1, 1505253600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:49', 1),
(631, 631, 1, 1, 1, 1502143200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:50', 1),
(632, 632, 1, 1, 1, 1499378400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:50', 1),
(633, 633, 1, 1, 1, 1493157600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:50', 1),
(634, 634, 1, 1, 1, 1477954800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:50', 1),
(635, 635, 1, 1, 1, 1482274800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:50', 1),
(636, 636, 1, 1, 1, 1491948000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:50', 1),
(637, 637, 1, 1, 1, 1475100000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:51', 1),
(638, 638, 1, 1, 1, 1508450400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:51', 1),
(639, 639, 1, 1, 1, 1496181600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:51', 1),
(640, 640, 1, 1, 1, 1479164400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:51', 1),
(641, 641, 1, 1, 1, 1476136800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:51', 1),
(642, 642, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:51', 1),
(643, 643, 1, 1, 1, 1504044000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:52', 1),
(644, 644, 1, 1, 1, 1494280800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:52', 1),
(645, 645, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:52', 1),
(646, 646, 1, 1, 1, 1492552800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:52', 1),
(647, 647, 1, 1, 1, 1502661600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:52', 1),
(648, 648, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(649, 649, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(650, 650, 1, 1, 1, 1503439200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(651, 651, 1, 1, 1, 1497304800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(652, 652, 1, 1, 1, 1490738400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(653, 653, 1, 1, 1, 1498168800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(654, 654, 1, 1, 1, 1475186400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(655, 655, 1, 1, 1, 1475791200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:53', 1),
(656, 656, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(657, 657, 1, 1, 1, 1476309600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(658, 658, 1, 1, 1, 1508191200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(659, 659, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(660, 660, 1, 1, 1, 1505944800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(661, 661, 1, 1, 1, 1505685600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(662, 662, 1, 1, 1, 1490565600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(663, 663, 1, 1, 1, 1491429600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(664, 664, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(665, 665, 1, 1, 1, 1503612000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:54', 1),
(666, 666, 1, 1, 1, 1503871200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:55', 1),
(667, 667, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:55', 1),
(668, 668, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:55', 1),
(669, 669, 1, 1, 1, 1499810400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:55', 1),
(670, 670, 1, 1, 1, 1492984800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:56', 1),
(671, 671, 1, 1, 1, 1503266400, 1, 'This member data was exported from an excel', '2017-11-15 08:24:56', 1),
(672, 672, 1, 1, 1, 1499724000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:56', 1),
(673, 673, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:56', 1),
(674, 674, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:57', 1),
(675, 675, 1, 1, 1, 1485126000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:57', 1),
(676, 676, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:58', 1),
(677, 677, 1, 1, 1, 1489014000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:58', 1),
(678, 678, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:58', 1),
(679, 679, 1, 1, 1, 1485903600, 1, 'This member data was exported from an excel', '2017-11-15 08:24:58', 1),
(680, 680, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:59', 1),
(681, 681, 1, 1, 1, 1483398000, 1, 'This member data was exported from an excel', '2017-11-15 08:24:59', 1),
(682, 682, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:24:59', 1),
(683, 683, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:24:59', 1),
(684, 684, 1, 1, 1, 1490824800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:00', 1),
(685, 685, 1, 1, 1, 1487890800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:00', 1),
(686, 686, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:00', 1),
(687, 687, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:00', 1),
(688, 688, 1, 1, 1, 1490050800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:00', 1),
(689, 689, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(690, 690, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(691, 691, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(692, 692, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(693, 693, 1, 1, 1, 1492725600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(694, 694, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(695, 695, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:01', 1),
(696, 696, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:02', 1),
(697, 697, 1, 1, 1, 1487804400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:02', 1),
(698, 698, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:02', 1),
(699, 699, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:02', 1),
(700, 700, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:02', 1),
(701, 701, 1, 1, 1, 1484521200, 1, 'This member data was exported from an excel', '2017-11-15 08:25:02', 1),
(702, 702, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:03', 1),
(703, 703, 1, 1, 1, 1487545200, 1, 'This member data was exported from an excel', '2017-11-15 08:25:03', 1),
(704, 704, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:03', 1),
(705, 705, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:03', 1),
(706, 706, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:03', 1),
(707, 707, 1, 1, 1, 1487890800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:03', 1),
(708, 708, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(709, 709, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(710, 710, 1, 1, 1, 1488150000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(711, 711, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(712, 712, 1, 1, 1, 1490050800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(713, 713, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(714, 714, 1, 1, 1, 1483657200, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(715, 715, 1, 1, 1, 1490223600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(716, 716, 1, 1, 1, 1484780400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:04', 1),
(717, 717, 1, 1, 1, 1488150000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(718, 718, 1, 1, 1, 1483570800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(719, 719, 1, 1, 1, 1489100400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(720, 720, 1, 1, 1, 1489100400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(721, 721, 1, 1, 1, 1486335600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(722, 722, 1, 1, 1, 1487631600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(723, 723, 1, 1, 1, 1484780400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:05', 1),
(724, 724, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:06', 1),
(725, 725, 1, 1, 1, 1489532400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:06', 1),
(726, 726, 1, 1, 1, 1486508400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:06', 1),
(727, 727, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:06', 1),
(728, 728, 1, 1, 1, 1483916400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:07', 1),
(729, 729, 1, 1, 1, 1485730800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:07', 1),
(730, 730, 1, 1, 1, 1484262000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:08', 1),
(731, 731, 1, 1, 1, 1486594800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:08', 1),
(732, 732, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:08', 1),
(733, 733, 1, 1, 1, 1487804400, 1, 'This member data was exported from an excel', '2017-11-15 08:25:08', 1),
(734, 734, 1, 1, 1, 1486422000, 1, 'This member data was exported from an excel', '2017-11-15 08:25:09', 1),
(735, 735, 1, 1, 1, 1488495600, 1, 'This member data was exported from an excel', '2017-11-15 08:25:09', 1),
(736, 736, 1, 1, 1, 1493848800, 1, 'This member data was exported from an excel', '2017-11-15 08:25:09', 1);

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
(1, 3, 1, 1510753541, 2, '2017-11-15 13:45:41', 2);

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
(15, '', 1, 'BFS00000015', '', 'Ssuna', 'Francis', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-06 00:00:00', 0, '', '', '', '', '', 0),
(16, '', 1, 'BFS00000016', 'ISAAC', 'SSIMBWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-12 00:00:00', 0, '', '', '', '', '', 0),
(17, '', 1, 'BFS00000017', 'DAVID', 'SSEVUME', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(18, '', 1, 'BFS00000018', 'Mukiibi', 'Ssetuba', 'Sserunjoji', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-31 00:00:00', 0, '', '', '', '', '', 0),
(19, '', 1, 'BFS00000019', '', 'SSETTUBA', 'FREDRICK', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-05 00:00:00', 0, '', '', '', '', '', 0),
(20, '', 1, 'BFS00000020', 'Hussein', 'Ssesanga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-04 00:00:00', 0, '', '', '', '', '', 0),
(21, '', 1, 'BFS00000021', 'DEO', 'SSERUTEEGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(22, '', 1, 'BFS00000022', 'PETER', 'SSENYONDO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(23, '', 1, 'BFS00000023', 'ROBERT', 'SSENGENDO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-22 00:00:00', 0, '', '', '', '', '', 0),
(24, '', 1, 'BFS00000024', 'Bruhan', 'Ssemwogerere', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(25, '', 1, 'BFS00000025', 'YEKO', 'SSEMBALIRWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-13 00:00:00', 0, '', '', '', '', '', 0),
(26, '', 1, 'BFS00000026', 'ALLAN', 'SSEMANDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-03 00:00:00', 0, '', '', '', '', '', 0),
(27, '', 1, 'BFS00000027', 'EMMANUEL', 'SSEMAKULA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-27 00:00:00', 0, '', '', '', '', '', 0),
(28, '', 1, 'BFS00000028', '', 'Ssemakula', 'Zakalia', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-11 00:00:00', 0, '', '', '', '', '', 0),
(29, '', 1, 'BFS00000029', 'DAVID', 'SSEGULANI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-16 00:00:00', 0, '', '', '', '', '', 0),
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
(75, '', 1, 'BFS00000075', 'GODFREY', 'NYANZI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
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
(97, '', 1, 'BFS00000097', 'DEO', 'NKUNDIZIZANA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-26 00:00:00', 0, '', '', '', '', '', 0),
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
(123, '', 1, 'BFS00000123', 'MASTULA', 'NASSANGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-30 00:00:00', 0, '', '', '', '', '', 0),
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
(141, '', 1, 'BFS00000141', 'ROBINAH', 'NANTUBWE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-06 00:00:00', 0, '', '', '', '', '', 0),
(142, '', 1, 'BFS00000142', 'Masitulah', 'Nantongo', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-12 00:00:00', 0, '', '', '', '', '', 0),
(143, '', 1, 'BFS00000143', 'Hasifah', 'Nantongo', 'Amir', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-13 00:00:00', 0, '', '', '', '', '', 0),
(144, '', 1, 'BFS00000144', 'Fatuma', 'Nanteza', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
(145, '', 1, 'BFS00000145', 'ANNET', 'NANTEZA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-18 00:00:00', 0, '', '', '', '', '', 0),
(146, '', 1, 'BFS00000146', 'Nooru', 'Nansubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-27 00:00:00', 0, '', '', '', '', '', 0),
(147, '', 1, 'BFS00000147', 'Justine', 'Nansubuga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
(148, '', 1, 'BFS00000148', 'JAZIRAAH', 'NANSUBUGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-06 00:00:00', 0, '', '', '', '', '', 0),
(149, '', 1, 'BFS00000149', '', 'NANSUBUGA', 'ROBINAH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
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
(187, '', 1, 'BFS00000187', 'JULIET', 'NAMUTEBI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-20 00:00:00', 0, '', '', '', '', '', 0),
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
(208, '', 1, 'BFS00000208', 'JOYCE', 'NAMUGERWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(209, '', 1, 'BFS00000209', 'Masitula', 'Namugenyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-24 00:00:00', 0, '', '', '', '', '', 0),
(210, '', 1, 'BFS00000210', 'JAMIDAH', 'NAMUGENYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-14 00:00:00', 0, '', '', '', '', '', 0),
(211, '', 1, 'BFS00000211', 'HALIMA', 'NAMUGENYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-20 00:00:00', 0, '', '', '', '', '', 0),
(212, '', 1, 'BFS00000212', 'Aida', 'Namugenyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-23 00:00:00', 0, '', '', '', '', '', 0),
(213, '', 1, 'BFS00000213', 'BENAH', 'NAMUGAYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(214, '', 1, 'BFS00000214', 'LOSIRA', 'NAMUGAYA', 'EDITH', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-25 00:00:00', 0, '', '', '', '', '', 0),
(215, '', 1, 'BFS00000215', '', 'NAMUGANZA', 'SALIMA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
(216, '', 1, 'BFS00000216', 'Milly', 'Namuganyi', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(217, '', 1, 'BFS00000217', '', 'Namugambe', 'Grace', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(218, '', 1, 'BFS00000218', 'IRENE', 'NAMUGABO', 'JOYCE', 0, '', '', '', '', '0000-00-00', '789477920', '73600923', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-11 00:00:00', 0, '', '', '', '', '', 0),
(219, '', 1, 'BFS00000219', 'REGINAH', 'NAMUDDU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-02 00:00:00', 0, '', '', '', '', '', 0),
(220, '', 1, 'BFS00000220', 'c', 'Namuddu', 'Kiyaga', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-18 00:00:00', 0, '', '', '', '', '', 0),
(221, '', 1, 'BFS00000221', 'Teddy', 'Namubiru', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-07 00:00:00', 0, '', '', '', '', '', 0),
(222, '', 1, 'BFS00000222', 'MAYI', 'NAMUBIRU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(223, '', 1, 'BFS00000223', 'HASIFAH', 'NAMUBIIRU', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
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
(311, '', 1, 'BFS00000311', 'CATHY', 'NAKITTO', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
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
(339, '', 1, 'BFS00000339', '', 'NAKAYIKI', 'LYDIA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
(340, '', 1, 'BFS00000340', 'RUKIA', 'NAKAYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-16 00:00:00', 0, '', '', '', '', '', 0),
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
(380, '', 1, 'BFS00000380', 'YUNIA', 'NAJJEMBA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(381, '', 1, 'BFS00000381', 'RUKIA', 'NAIGAGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-28 00:00:00', 0, '', '', '', '', '', 0),
(382, '', 1, 'BFS00000382', 'GRACE', 'NAIGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-11 00:00:00', 0, '', '', '', '', '', 0),
(383, '', 1, 'BFS00000383', 'Diana', 'Naiga', 'Rose', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-01 00:00:00', 0, '', '', '', '', '', 0),
(384, '', 1, 'BFS00000384', 'BETTY', 'NAIGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
(385, '', 1, 'BFS00000385', 'Annet', 'Naiga', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(386, '', 1, 'BFS00000386', '', 'Nagujja', 'Evelyne', 0, '', '', '', '', '0000-00-00', '704296702', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-01-05 00:00:00', 0, '', '', '', '', '', 0),
(387, '', 1, 'BFS00000387', 'HAMIDAH', 'NAGILINYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(388, '', 1, 'BFS00000388', 'SARAH', 'NAGAYI', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(389, '', 1, 'BFS00000389', 'YUDAYA', 'NAGAWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-23 00:00:00', 0, '', '', '', '', '', 0),
(390, '', 1, 'BFS00000390', 'SANDRA', 'NAGAWA', 'KABANDA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-03 00:00:00', 0, '', '', '', '', '', 0),
(391, '', 1, 'BFS00000391', 'MARIAM', 'NAGAWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-21 00:00:00', 0, '', '', '', '', '', 0),
(392, '', 1, 'BFS00000392', 'KIGUNDU', 'NAGAWA', 'PROSCOVIA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-23 00:00:00', 0, '', '', '', '', '', 0),
(393, '', 1, 'BFS00000393', 'MEGA', 'NADUGGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-10 00:00:00', 0, '', '', '', '', '', 0),
(394, '', 1, 'BFS00000394', 'Maria', 'Nabwetunge', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(395, '', 1, 'BFS00000395', 'Erios', 'Nabunya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-09-28 00:00:00', 0, '', '', '', '', '', 0),
(396, '', 1, 'BFS00000396', 'BERNA', 'NABUNYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-18 00:00:00', 0, '', '', '', '', '', 0),
(397, '', 1, 'BFS00000397', 'Masitulah', 'Nabulya', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-19 00:00:00', 0, '', '', '', '', '', 0),
(398, '', 1, 'BFS00000398', 'JOYCE', 'NABUKENYA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
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
(436, '', 1, 'BFS00000436', 'Violet', 'Nabadda', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(437, '', 1, 'BFS00000437', 'Mayimuna', 'Nabadda', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-26 00:00:00', 0, '', '', '', '', '', 0),
(438, '', 1, 'BFS00000438', 'CHRISTINE', 'NABADDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0),
(439, '', 1, 'BFS00000439', '', 'Nabacwa', 'Rose', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-21 00:00:00', 0, '', '', '', '', '', 0),
(440, '', 1, 'BFS00000440', 'JOHN', 'MUYUNGA', 'IAN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-27 00:00:00', 0, '', '', '', '', '', 0),
(441, '', 1, 'BFS00000441', 'Francis', 'Muyomba', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-12-13 00:00:00', 0, '', '', '', '', '', 0),
(442, '', 1, 'BFS00000442', 'Richard', 'Muwonge', 'Newton', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-21 00:00:00', 0, '', '', '', '', '', 0),
(443, '', 1, 'BFS00000443', 'LAMECK', 'MUWONGE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-08-14 00:00:00', 0, '', '', '', '', '', 0),
(444, '', 1, 'BFS00000444', 'NICHOLAS', 'MUWNGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-14 00:00:00', 0, '', '', '', '', '', 0),
(445, '', 1, 'BFS00000445', 'ABDUL', 'MUWANIKA', 'HAKIM', 0, '', '', '', '', '0000-00-00', '774951498', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-19 00:00:00', 0, '', '', '', '', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
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
(468, '', 1, 'BFS00000468', 'HERBERT', 'MUKISA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
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
(522, '', 1, 'BFS00000522', 'JOSEPH', 'LUBEGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-06 00:00:00', 0, '', '', '', '', '', 0),
(523, '', 1, 'BFS00000523', 'David', 'Lubega', 'Mutunzi', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-11-04 00:00:00', 0, '', '', '', '', '', 0),
(524, '', 1, 'BFS00000524', 'Alex', 'Lubega', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-24 00:00:00', 0, '', '', '', '', '', 0),
(525, '', 1, 'BFS00000525', 'AKIM', 'LUBEGA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-05 00:00:00', 0, '', '', '', '', '', 0),
(526, '', 1, 'BFS00000526', 'FUMUSI', 'LUBANJWA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-30 00:00:00', 0, '', '', '', '', '', 0),
(527, '', 1, 'BFS00000527', 'ARTHUR', 'KYOBE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-07 00:00:00', 0, '', '', '', '', '', 0),
(528, '', 1, 'BFS00000528', 'David', 'Kyewalabye', 'Male', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-20 00:00:00', 0, '', '', '', '', '', 0),
(529, '', 1, 'BFS00000529', 'James', 'Kyeswa', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2016-10-07 00:00:00', 0, '', '', '', '', '', 0),
(530, '', 1, 'BFS00000530', 'PETER', 'KYEGUNJA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-18 00:00:00', 0, '', '', '', '', '', 0),
(531, '', 1, 'BFS00000531', 'Sarah', 'Kyaterekera', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-20 00:00:00', 0, '', '', '', '', '', 0),
(532, '', 1, 'BFS00000532', 'Crofasi', 'Kyasimire', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-04-18 00:00:00', 0, '', '', '', '', '', 0),
(533, '', 1, 'BFS00000533', 'FRED', 'KYALIGONZA', 'BIRUNGI', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-23 00:00:00', 0, '', '', '', '', '', 0),
(534, '', 1, 'BFS00000534', 'SADIIKI', 'KULABIGWO', '', 0, '', '', '', '', '0000-00-00', '775294909', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-27 00:00:00', 0, '', '', '', '', '', 0),
(535, '', 1, 'BFS00000535', 'Vanessa', 'Kobusingye', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-29 00:00:00', 0, '', '', '', '', '', 0),
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
(586, '', 1, 'BFS00000586', 'PAULINE', 'KANYANGE', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-25 00:00:00', 0, '', '', '', '', '', 0),
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
(623, '', 1, 'BFS00000623', '', 'GOLOOBA', 'DAVID', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-09-13 00:00:00', 0, '', '', '', '', '', 0),
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
(638, '', 1, 'BFS00000638', 'AHMED', 'BUKENYA', 'YIGA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-10-20 00:00:00', 0, '', '', '', '', '', 0),
(639, '', 1, 'BFS00000639', '', 'BUKENYA', 'SULAIMAN', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-05-31 00:00:00', 0, '', '', '', '', '', 0),
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
(653, '', 1, 'BFS00000653', 'JOSEPH', 'BALIKUDEMBE', 'LUBOYELA', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-06-23 00:00:00', 0, '', '', '', '', '', 0),
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
(667, '', 1, 'BFS00000667', 'ANITAH', 'AKUNDA', '', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-07-12 00:00:00', 0, '', '', '', '', '', 0);
INSERT INTO `person` (`id`, `title`, `person_type`, `person_number`, `firstname`, `lastname`, `othername`, `id_type`, `id_number`, `id_specimen`, `gender`, `marital_status`, `dateofbirth`, `phone`, `phone2`, `email`, `postal_address`, `physical_address`, `occupation`, `children_no`, `dependants_no`, `CRB_card_no`, `photograph`, `comment`, `date_registered`, `registered_by`, `district`, `county`, `subcounty`, `parish`, `village`, `modifiedBy`) VALUES
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
(684, '', 1, 'BFS00000684', 'Nankya', '', 'Joweria', 0, '', '', '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, NULL, '', 'This member data was exported from an excel', '2017-03-30 00:00:00', 0, '', '', '', '', '', 0),
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
(738, 'Mr', 1, 'SBFS00000738', 'P', 'Joshua', 'A', 1, '8932923', '', 'M', '', '1980-01-01', '(070) 277-1124', '', 'mplat84@gmail.com', '', 'kampala', '', 0, 0, NULL, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', '', 0);

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
(1, 737, 1, 1, 'platin', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-11-15', '<br />\r\n<b>Notice</b>:  Undefined index: Staf'),
(2, 738, 1, 7, 'joshua', '9e11830101b6b723ae3fb11e660a2123', 0, 1, '0000-00-00', NULL, '2017-11-15', '<br />\r\n<b>Notice</b>:  Undefined index: Staf');

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
(4, 7, 718),
(5, 2, 719),
(6, 3, 720),
(7, 5, 721),
(8, 7, 722),
(9, 1, 1),
(10, 1, 724),
(11, 1, 725),
(12, 1, 737),
(13, 7, 738);

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
(1, 1, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:22:46', 1),
(2, 2, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:22:46', 1),
(3, 3, '25000.00', 0, 2017, 0, 1502143200, '2017-11-15 08:22:46', 1),
(4, 4, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 08:22:47', 1),
(5, 5, '20000.00', 135, 2017, 0, 1484175600, '2017-11-15 08:22:47', 1),
(6, 6, '20000.00', 47, 2016, 0, 1476309600, '2017-11-15 08:22:47', 1),
(7, 7, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:22:47', 1),
(8, 8, '20000.00', 126, 2017, 0, 1483916400, '2017-11-15 08:22:48', 1),
(9, 9, '20000.00', 125, 2017, 0, 1483916400, '2017-11-15 08:22:48', 1),
(10, 10, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:22:48', 1),
(11, 11, '20000.00', 0, 2017, 0, 1504476000, '2017-11-15 08:22:48', 1),
(12, 12, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:22:48', 1),
(13, 13, '20000.00', 124, 2017, 0, 1483916400, '2017-11-15 08:22:48', 1),
(14, 14, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:22:48', 1),
(15, 15, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:22:48', 1),
(16, 16, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:22:48', 1),
(17, 17, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:22:49', 1),
(18, 18, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 08:22:49', 1),
(19, 19, '20000.00', 0, 2017, 0, 1504562400, '2017-11-15 08:22:49', 1),
(20, 20, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:22:50', 1),
(21, 21, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 08:22:50', 1),
(22, 22, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:22:50', 1),
(23, 23, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 08:22:51', 1),
(24, 24, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:22:51', 1),
(25, 25, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 08:22:52', 1),
(26, 26, '25000.00', 0, 2017, 0, 1501711200, '2017-11-15 08:22:52', 1),
(27, 27, '20000.00', 0, 2017, 0, 1509055200, '2017-11-15 08:22:52', 1),
(28, 28, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:22:52', 1),
(29, 29, '20000.00', 0, 2017, 0, 1497564000, '2017-11-15 08:22:52', 1),
(30, 30, '20000.00', 0, 2017, 0, 1491170400, '2017-11-15 08:22:52', 1),
(31, 31, '20000.00', 0, 2017, 0, 1503957600, '2017-11-15 08:22:53', 1),
(32, 32, '20000.00', 32, 2016, 0, 1475186400, '2017-11-15 08:22:53', 1),
(33, 33, '20000.00', 3, 2016, 0, 1472594400, '2017-11-15 08:22:53', 1),
(34, 34, '20000.00', 30, 2016, 0, 1475186400, '2017-11-15 08:22:53', 1),
(35, 35, '20000.00', 0, 2017, 0, 1501020000, '2017-11-15 08:22:53', 1),
(36, 36, '20000.00', 53, 2016, 0, 1476914400, '2017-11-15 08:22:53', 1),
(37, 37, '20000.00', 92, 2016, 0, 1481065200, '2017-11-15 08:22:53', 1),
(38, 38, '20000.00', 81, 2016, 0, 1479164400, '2017-11-15 08:22:54', 1),
(39, 39, '20000.00', 77, 2016, 0, 1478646000, '2017-11-15 08:22:54', 1),
(40, 40, '20000.00', 0, 2017, 0, 1502229600, '2017-11-15 08:22:54', 1),
(41, 41, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 08:22:54', 1),
(42, 42, '20000.00', 0, 2017, 0, 1506376800, '2017-11-15 08:22:54', 1),
(43, 43, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:22:54', 1),
(44, 44, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:22:55', 1),
(45, 45, '20000.00', 94, 2016, 0, 1482274800, '2017-11-15 08:22:55', 1),
(46, 46, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:22:55', 1),
(47, 47, '20000.00', 24, 2016, 0, 1475100000, '2017-11-15 08:22:55', 1),
(48, 48, '20000.00', 0, 2017, 0, 1506636000, '2017-11-15 08:22:55', 1),
(49, 49, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:22:55', 1),
(50, 50, '20000.00', 76, 2016, 0, 1478214000, '2017-11-15 08:22:55', 1),
(51, 51, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 08:22:55', 1),
(52, 52, '20000.00', 0, 2017, 0, 1499637600, '2017-11-15 08:22:56', 1),
(53, 53, '20000.00', 0, 2017, 0, 1507759200, '2017-11-15 08:22:56', 1),
(54, 54, '20000.00', 66, 2016, 0, 1477605600, '2017-11-15 08:22:56', 1),
(55, 55, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 08:22:56', 1),
(56, 56, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 08:22:56', 1),
(57, 57, '20000.00', 0, 2017, 0, 1494194400, '2017-11-15 08:22:57', 1),
(58, 58, '20000.00', 0, 2017, 0, 1505685600, '2017-11-15 08:22:57', 1),
(59, 59, '20000.00', 0, 2017, 0, 1507672800, '2017-11-15 08:22:57', 1),
(60, 60, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:22:57', 1),
(61, 61, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:22:57', 1),
(62, 62, '20000.00', 0, 2017, 0, 1494453600, '2017-11-15 08:22:57', 1),
(63, 63, '10000.00', 1, 2016, 0, 1472594400, '2017-11-15 08:22:58', 1),
(64, 64, '20000.00', 55, 2016, 0, 1477260000, '2017-11-15 08:22:58', 1),
(65, 65, '20000.00', 31, 2016, 0, 1475186400, '2017-11-15 08:22:58', 1),
(66, 66, '20000.00', 48, 2016, 0, 1476309600, '2017-11-15 08:22:58', 1),
(67, 67, '20000.00', 0, 2017, 0, 1504044000, '2017-11-15 08:22:58', 1),
(68, 68, '20000.00', 0, 2017, 0, 1504476000, '2017-11-15 08:22:59', 1),
(69, 69, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:22:59', 1),
(70, 70, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:22:59', 1),
(71, 71, '20000.00', 22, 2016, 0, 1475100000, '2017-11-15 08:22:59', 1),
(72, 72, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:22:59', 1),
(73, 73, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:00', 1),
(74, 74, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:23:00', 1),
(75, 75, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:00', 1),
(76, 76, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 08:23:01', 1),
(77, 77, '20000.00', 61, 2016, 0, 1477519200, '2017-11-15 08:23:01', 1),
(78, 78, '20000.00', 35, 2016, 0, 1475791200, '2017-11-15 08:23:01', 1),
(79, 79, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 08:23:02', 1),
(80, 80, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:02', 1),
(81, 81, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:02', 1),
(82, 82, '20000.00', 18, 2016, 0, 1475100000, '2017-11-15 08:23:03', 1),
(83, 83, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:03', 1),
(84, 84, '20000.00', 15, 2016, 0, 1475013600, '2017-11-15 08:23:04', 1),
(85, 85, '20000.00', 63, 2016, 0, 1477605600, '2017-11-15 08:23:04', 1),
(86, 86, '20000.00', 0, 2017, 0, 1503007200, '2017-11-15 08:23:04', 1),
(87, 87, '20000.00', 13, 2017, 0, 1506549600, '2017-11-15 08:23:04', 1),
(88, 88, '20000.00', 73, 2016, 0, 1477954800, '2017-11-15 08:23:04', 1),
(89, 89, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 08:23:04', 1),
(90, 90, '20000.00', 0, 2017, 0, 1509055200, '2017-11-15 08:23:05', 1),
(91, 91, '20000.00', 38, 2016, 0, 1475791200, '2017-11-15 08:23:05', 1),
(92, 92, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 08:23:05', 1),
(93, 93, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:23:05', 1),
(94, 94, '20000.00', 138, 2017, 0, 1484262000, '2017-11-15 08:23:05', 1),
(95, 95, '20000.00', 27, 2016, 0, 1475186400, '2017-11-15 08:23:05', 1),
(96, 96, '20000.00', 0, 2017, 0, 1499119200, '2017-11-15 08:23:06', 1),
(97, 97, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 08:23:06', 1),
(98, 98, '20000.00', 0, 2017, 0, 1509404400, '2017-11-15 08:23:06', 1),
(99, 99, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:23:06', 1),
(100, 100, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:23:06', 1),
(101, 101, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:23:07', 1),
(102, 102, '20000.00', 0, 2017, 0, 1499637600, '2017-11-15 08:23:07', 1),
(103, 103, '20000.00', 33, 2016, 0, 1475532000, '2017-11-15 08:23:07', 1),
(104, 104, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:07', 1),
(105, 105, '20000.00', 0, 2017, 0, 1507586400, '2017-11-15 08:23:07', 1),
(106, 106, '20000.00', 0, 2017, 0, 1507586400, '2017-11-15 08:23:07', 1),
(107, 107, '20000.00', 0, 2017, 0, 1509404400, '2017-11-15 08:23:08', 1),
(108, 108, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:23:08', 1),
(109, 109, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 08:23:08', 1),
(110, 110, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:08', 1),
(111, 111, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:08', 1),
(112, 112, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:09', 1),
(113, 113, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:23:09', 1),
(114, 114, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:09', 1),
(115, 115, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 08:23:09', 1),
(116, 116, '20000.00', 153, 2017, 0, 1484262000, '2017-11-15 08:23:09', 1),
(117, 117, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:23:09', 1),
(118, 118, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 08:23:09', 1),
(119, 119, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:23:09', 1),
(120, 120, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:10', 1),
(121, 121, '20000.00', 0, 2017, 0, 1494799200, '2017-11-15 08:23:10', 1),
(122, 122, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 08:23:10', 1),
(123, 123, '20000.00', 0, 2017, 0, 1509318000, '2017-11-15 08:23:10', 1),
(124, 124, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 08:23:10', 1),
(125, 125, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:23:10', 1),
(126, 126, '20000.00', 11, 2016, 0, 1475013600, '2017-11-15 08:23:11', 1),
(127, 127, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:11', 1),
(128, 128, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:11', 1),
(129, 129, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:12', 1),
(130, 130, '20000.00', 127, 2017, 0, 1483916400, '2017-11-15 08:23:12', 1),
(131, 131, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 08:23:12', 1),
(132, 132, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 08:23:12', 1),
(133, 133, '20000.00', 129, 2017, 0, 1483916400, '2017-11-15 08:23:13', 1),
(134, 134, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:14', 1),
(135, 135, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:14', 1),
(136, 136, '20000.00', 50, 2016, 0, 1476655200, '2017-11-15 08:23:14', 1),
(137, 137, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:14', 1),
(138, 138, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:15', 1),
(139, 139, '20000.00', 0, 2017, 0, 1510791420, '2017-11-15 08:23:15', 1),
(140, 140, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:15', 1),
(141, 141, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 08:23:15', 1),
(142, 142, '20000.00', 133, 2017, 0, 1484175600, '2017-11-15 08:23:15', 1),
(143, 143, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:23:15', 1),
(144, 144, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:15', 1),
(145, 145, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 08:23:15', 1),
(146, 146, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:16', 1),
(147, 147, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:23:16', 1),
(148, 148, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:23:16', 1),
(149, 149, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:23:16', 1),
(150, 150, '20000.00', 142, 2017, 0, 1484262000, '2017-11-15 08:23:16', 1),
(151, 151, '20000.00', 0, 2017, 0, 1501020000, '2017-11-15 08:23:17', 1),
(152, 152, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:23:17', 1),
(153, 153, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:23:17', 1),
(154, 154, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:23:17', 1),
(155, 155, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:17', 1),
(156, 156, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:23:18', 1),
(157, 157, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:23:18', 1),
(158, 158, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 08:23:18', 1),
(159, 159, '20000.00', 0, 2017, 0, 1508364000, '2017-11-15 08:23:18', 1),
(160, 160, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:18', 1),
(161, 161, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:19', 1),
(162, 162, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 08:23:19', 1),
(163, 163, '20000.00', 0, 2017, 0, 1494194400, '2017-11-15 08:23:19', 1),
(164, 164, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:23:19', 1),
(165, 165, '20000.00', 0, 2017, 0, 1500501600, '2017-11-15 08:23:19', 1),
(166, 166, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:19', 1),
(167, 167, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 08:23:19', 1),
(168, 168, '20000.00', 131, 2017, 0, 1484175600, '2017-11-15 08:23:20', 1),
(169, 169, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:20', 1),
(170, 170, '20000.00', 119, 2017, 0, 1483657200, '2017-11-15 08:23:20', 1),
(171, 171, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:20', 1),
(172, 172, '20000.00', 0, 2017, 0, 1496786400, '2017-11-15 08:23:20', 1),
(173, 173, '20000.00', 150, 2017, 0, 1484262000, '2017-11-15 08:23:20', 1),
(174, 174, '20000.00', 88, 2016, 0, 1480028400, '2017-11-15 08:23:20', 1),
(175, 175, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:23:20', 1),
(176, 176, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:20', 1),
(177, 177, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:23:20', 1),
(178, 178, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:21', 1),
(179, 179, '20000.00', 0, 2017, 0, 1503957600, '2017-11-15 08:23:21', 1),
(180, 180, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:21', 1),
(181, 181, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:21', 1),
(182, 182, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:23:22', 1),
(183, 183, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:23:22', 1),
(184, 184, '20000.00', 0, 2017, 0, 1502402400, '2017-11-15 08:23:22', 1),
(185, 185, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 08:23:23', 1),
(186, 186, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:23:23', 1),
(187, 187, '20000.00', 0, 2017, 0, 1505858400, '2017-11-15 08:23:23', 1),
(188, 188, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 08:23:24', 1),
(189, 189, '20000.00', 8, 2016, 0, 1474236000, '2017-11-15 08:23:24', 1),
(190, 190, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:25', 1),
(191, 191, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:25', 1),
(192, 192, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:25', 1),
(193, 193, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:23:25', 1),
(194, 194, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 08:23:25', 1),
(195, 195, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:23:25', 1),
(196, 196, '20000.00', 132, 2017, 0, 1484175600, '2017-11-15 08:23:25', 1),
(197, 197, '20000.00', 117, 2017, 0, 1483657200, '2017-11-15 08:23:25', 1),
(198, 198, '20000.00', 0, 2017, 0, 1501884000, '2017-11-15 08:23:26', 1),
(199, 199, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:23:26', 1),
(200, 200, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:26', 1),
(201, 201, '20000.00', 0, 2017, 0, 1494280800, '2017-11-15 08:23:26', 1),
(202, 202, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:26', 1),
(203, 203, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:26', 1),
(204, 204, '20000.00', 87, 2016, 0, 1480028400, '2017-11-15 08:23:26', 1),
(205, 205, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:27', 1),
(206, 206, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:27', 1),
(207, 207, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:27', 1),
(208, 208, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:27', 1),
(209, 209, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:27', 1),
(210, 210, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 08:23:28', 1),
(211, 211, '20000.00', 0, 2017, 0, 1497909600, '2017-11-15 08:23:28', 1),
(212, 212, '20000.00', 84, 2016, 0, 1479855600, '2017-11-15 08:23:28', 1),
(213, 213, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:23:28', 1),
(214, 214, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:23:28', 1),
(215, 215, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:23:28', 1),
(216, 216, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:28', 1),
(217, 217, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:28', 1),
(218, 218, '20000.00', 0, 2017, 0, 1499724000, '2017-11-15 08:23:29', 1),
(219, 219, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:29', 1),
(220, 220, '20000.00', 83, 2016, 0, 1479423600, '2017-11-15 08:23:29', 1),
(221, 221, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:29', 1),
(222, 222, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:23:29', 1),
(223, 223, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:23:29', 1),
(224, 224, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:29', 1),
(225, 225, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 08:23:29', 1),
(226, 226, '20000.00', 154, 2017, 0, 1484262000, '2017-11-15 08:23:29', 1),
(227, 227, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 08:23:29', 1),
(228, 228, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:23:30', 1),
(229, 229, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 08:23:30', 1),
(230, 230, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:30', 1),
(231, 231, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 08:23:30', 1),
(232, 232, '20000.00', 25, 2016, 0, 1475100000, '2017-11-15 08:23:30', 1),
(233, 233, '20000.00', 0, 2017, 0, 1500242400, '2017-11-15 08:23:30', 1),
(234, 234, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:31', 1),
(235, 235, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:23:31', 1),
(236, 236, '20000.00', 0, 2017, 0, 1506895200, '2017-11-15 08:23:32', 1),
(237, 237, '25000.00', 0, 2017, 0, 1502143200, '2017-11-15 08:23:32', 1),
(238, 238, '20000.00', 116, 2017, 0, 1483657200, '2017-11-15 08:23:32', 1),
(239, 239, '20000.00', 149, 2017, 0, 1484262000, '2017-11-15 08:23:33', 1),
(240, 240, '20000.00', 0, 2017, 0, 1504821600, '2017-11-15 08:23:33', 1),
(241, 241, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:33', 1),
(242, 242, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 08:23:33', 1),
(243, 243, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 08:23:34', 1),
(244, 244, '20000.00', 155, 2017, 0, 1484262000, '2017-11-15 08:23:34', 1),
(245, 245, '20000.00', 0, 2017, 0, 1499292000, '2017-11-15 08:23:35', 1),
(246, 246, '20000.00', 0, 2017, 0, 1501452000, '2017-11-15 08:23:35', 1),
(247, 247, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 08:23:35', 1),
(248, 248, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:36', 1),
(249, 249, '20000.00', 123, 2017, 0, 1483916400, '2017-11-15 08:23:36', 1),
(250, 250, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:23:36', 1),
(251, 251, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:23:36', 1),
(252, 252, '20000.00', 82, 2016, 0, 1479164400, '2017-11-15 08:23:36', 1),
(253, 253, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:23:36', 1),
(254, 254, '25000.00', 0, 2017, 0, 1501711200, '2017-11-15 08:23:37', 1),
(255, 255, '20000.00', 0, 2017, 0, 1496786400, '2017-11-15 08:23:37', 1),
(256, 256, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:23:37', 1),
(257, 257, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 08:23:37', 1),
(258, 258, '20000.00', 0, 2017, 0, 1491516000, '2017-11-15 08:23:37', 1),
(259, 259, '20000.00', 0, 2017, 0, 1495144800, '2017-11-15 08:23:37', 1),
(260, 260, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:37', 1),
(261, 261, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 08:23:37', 1),
(262, 262, '20000.00', 5, 2016, 0, 1472767200, '2017-11-15 08:23:38', 1),
(263, 263, '20000.00', 0, 2017, 0, 1493935200, '2017-11-15 08:23:38', 1),
(264, 264, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 08:23:38', 1),
(265, 265, '20000.00', 0, 2017, 0, 1495490400, '2017-11-15 08:23:38', 1),
(266, 266, '20000.00', 0, 2017, 0, 1491343200, '2017-11-15 08:23:38', 1),
(267, 267, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:38', 1),
(268, 268, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:38', 1),
(269, 269, '20000.00', 62, 2016, 0, 1477519200, '2017-11-15 08:23:39', 1),
(270, 270, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 08:23:39', 1),
(271, 271, '20000.00', 0, 2017, 0, 1497909600, '2017-11-15 08:23:39', 1),
(272, 272, '20000.00', 143, 2017, 0, 1484262000, '2017-11-15 08:23:39', 1),
(273, 273, '20000.00', 0, 2017, 0, 1507672800, '2017-11-15 08:23:39', 1),
(274, 274, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 08:23:39', 1),
(275, 275, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:39', 1),
(276, 276, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:23:40', 1),
(277, 277, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 08:23:40', 1),
(278, 278, '20000.00', 0, 2017, 0, 1493935200, '2017-11-15 08:23:40', 1),
(279, 279, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:23:40', 1),
(280, 280, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:23:40', 1),
(281, 281, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:40', 1),
(282, 282, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:41', 1),
(283, 283, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:23:41', 1),
(284, 284, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 08:23:41', 1),
(285, 285, '20000.00', 0, 2017, 0, 1491343200, '2017-11-15 08:23:41', 1),
(286, 286, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 08:23:41', 1),
(287, 287, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:23:41', 1),
(288, 288, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 08:23:41', 1),
(289, 289, '20000.00', 130, 2017, 0, 1483916400, '2017-11-15 08:23:42', 1),
(290, 290, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:23:42', 1),
(291, 291, '20000.00', 21, 2016, 0, 1475100000, '2017-11-15 08:23:42', 1),
(292, 292, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:23:43', 1),
(293, 293, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:23:43', 1),
(294, 294, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:23:43', 1),
(295, 295, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:43', 1),
(296, 296, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 08:23:44', 1),
(297, 297, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 08:23:44', 1),
(298, 298, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 08:23:44', 1),
(299, 299, '20000.00', 0, 2017, 0, 1491170400, '2017-11-15 08:23:44', 1),
(300, 300, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:23:45', 1),
(301, 301, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:45', 1),
(302, 302, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:45', 1),
(303, 303, '20000.00', 128, 2017, 0, 1483916400, '2017-11-15 08:23:45', 1),
(304, 304, '20000.00', 0, 2017, 0, 1496872800, '2017-11-15 08:23:45', 1),
(305, 305, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:46', 1),
(306, 306, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:46', 1),
(307, 307, '20000.00', 0, 2017, 0, 1494799200, '2017-11-15 08:23:46', 1),
(308, 308, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:23:46', 1),
(309, 309, '20000.00', 7, 2016, 0, 1474236000, '2017-11-15 08:23:47', 1),
(310, 310, '20000.00', 57, 2016, 0, 1477260000, '2017-11-15 08:23:47', 1),
(311, 311, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:23:47', 1),
(312, 312, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:47', 1),
(313, 313, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 08:23:47', 1),
(314, 314, '20000.00', 0, 2017, 0, 1494540000, '2017-11-15 08:23:47', 1),
(315, 315, '20000.00', 86, 2016, 0, 1480028400, '2017-11-15 08:23:48', 1),
(316, 316, '20000.00', 0, 2017, 0, 1506463200, '2017-11-15 08:23:48', 1),
(317, 317, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 08:23:48', 1),
(318, 318, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:48', 1),
(319, 319, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:23:48', 1),
(320, 320, '20000.00', 0, 2017, 0, 1493589600, '2017-11-15 08:23:48', 1),
(321, 321, '20000.00', 0, 2017, 0, 1502748000, '2017-11-15 08:23:48', 1),
(322, 322, '20000.00', 0, 2017, 0, 1502229600, '2017-11-15 08:23:48', 1),
(323, 323, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 08:23:49', 1),
(324, 324, '20000.00', 157, 2017, 0, 1484521200, '2017-11-15 08:23:49', 1),
(325, 325, '20000.00', 137, 2017, 0, 1484175600, '2017-11-15 08:23:49', 1),
(326, 326, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 08:23:49', 1),
(327, 327, '20000.00', 0, 2017, 0, 1508104800, '2017-11-15 08:23:49', 1),
(328, 328, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:49', 1),
(329, 329, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:23:49', 1),
(330, 330, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:23:49', 1),
(331, 331, '25000.00', 0, 2017, 0, 1502316000, '2017-11-15 08:23:49', 1),
(332, 332, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 08:23:50', 1),
(333, 333, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:50', 1),
(334, 334, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:23:50', 1),
(335, 335, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 08:23:50', 1),
(336, 336, '20000.00', 70, 2016, 0, 1477954800, '2017-11-15 08:23:50', 1),
(337, 337, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 08:23:50', 1),
(338, 338, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:23:50', 1),
(339, 339, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 08:23:51', 1),
(340, 340, '20000.00', 0, 2017, 0, 1497564000, '2017-11-15 08:23:51', 1),
(341, 341, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:23:51', 1),
(342, 342, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:23:51', 1),
(343, 343, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:23:52', 1),
(344, 344, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:52', 1),
(345, 345, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:53', 1),
(346, 346, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:23:53', 1),
(347, 347, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 08:23:53', 1),
(348, 348, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 08:23:53', 1),
(349, 349, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 08:23:54', 1),
(350, 350, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:54', 1),
(351, 351, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:23:54', 1),
(352, 352, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:23:54', 1),
(353, 353, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:23:55', 1),
(354, 354, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:23:55', 1),
(355, 355, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:23:55', 1),
(356, 356, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:55', 1),
(357, 357, '20000.00', 139, 2017, 0, 1484262000, '2017-11-15 08:23:55', 1),
(358, 358, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:23:55', 1),
(359, 359, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:23:55', 1),
(360, 360, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:23:56', 1),
(361, 361, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:23:56', 1),
(362, 362, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:56', 1),
(363, 363, '20000.00', 34, 2016, 0, 1475532000, '2017-11-15 08:23:56', 1),
(364, 364, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 08:23:57', 1),
(365, 365, '20000.00', 0, 2017, 0, 1491170400, '2017-11-15 08:23:57', 1),
(366, 366, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:23:57', 1),
(367, 367, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:23:57', 1),
(368, 368, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:23:57', 1),
(369, 369, '20000.00', 0, 2017, 0, 1496700000, '2017-11-15 08:23:57', 1),
(370, 370, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:23:57', 1),
(371, 371, '20000.00', 0, 2017, 0, 1496008800, '2017-11-15 08:23:57', 1),
(372, 372, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:23:57', 1),
(373, 373, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 08:23:57', 1),
(374, 374, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 08:23:58', 1),
(375, 375, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 08:23:58', 1),
(376, 376, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:23:58', 1),
(377, 377, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:23:58', 1),
(378, 378, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:23:58', 1),
(379, 379, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:23:58', 1),
(380, 380, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:23:59', 1),
(381, 381, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:23:59', 1),
(382, 382, '20000.00', 0, 2017, 0, 1494453600, '2017-11-15 08:23:59', 1),
(383, 383, '20000.00', 72, 2016, 0, 1477954800, '2017-11-15 08:23:59', 1),
(384, 384, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 08:23:59', 1),
(385, 385, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:23:59', 1),
(386, 386, '20000.00', 115, 2017, 0, 1483570800, '2017-11-15 08:24:00', 1),
(387, 387, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:00', 1),
(388, 388, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:00', 1),
(389, 389, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:24:00', 1),
(390, 390, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 08:24:00', 1),
(391, 391, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:00', 1),
(392, 392, '20000.00', 0, 2017, 0, 1508709600, '2017-11-15 08:24:01', 1),
(393, 393, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 08:24:01', 1),
(394, 394, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:24:01', 1),
(395, 395, '20000.00', 16, 2016, 0, 1475013600, '2017-11-15 08:24:01', 1),
(396, 396, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 08:24:01', 1),
(397, 397, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:24:01', 1),
(398, 398, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:24:01', 1),
(399, 399, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 08:24:02', 1),
(400, 400, '20000.00', 0, 2017, 0, 1490911200, '2017-11-15 08:24:02', 1),
(401, 401, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:24:02', 1),
(402, 402, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:24:03', 1),
(403, 403, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:03', 1),
(404, 404, '10000.00', 136, 2017, 0, 1484175600, '2017-11-15 08:24:03', 1),
(405, 405, '20000.00', 140, 2017, 0, 1484262000, '2017-11-15 08:24:03', 1),
(406, 406, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:24:04', 1),
(407, 407, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:24:04', 1),
(408, 408, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:04', 1),
(409, 409, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:24:04', 1),
(410, 410, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:24:04', 1),
(411, 411, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 08:24:05', 1),
(412, 412, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:24:05', 1),
(413, 413, '20000.00', 20, 2016, 0, 1475100000, '2017-11-15 08:24:05', 1),
(414, 414, '20000.00', 9, 2016, 0, 1474236000, '2017-11-15 08:24:05', 1),
(415, 415, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:24:05', 1),
(416, 416, '20000.00', 146, 2017, 0, 1484262000, '2017-11-15 08:24:05', 1),
(417, 417, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:24:06', 1),
(418, 418, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:24:06', 1),
(419, 419, '20000.00', 0, 2017, 0, 1491775200, '2017-11-15 08:24:06', 1),
(420, 420, '20000.00', 0, 2017, 0, 1492466400, '2017-11-15 08:24:07', 1),
(421, 421, '20000.00', 145, 2017, 0, 1484262000, '2017-11-15 08:24:07', 1),
(422, 422, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:24:07', 1),
(423, 423, '20000.00', 0, 2017, 0, 1508191200, '2017-11-15 08:24:07', 1),
(424, 424, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:24:07', 1),
(425, 425, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:24:08', 1),
(426, 426, '20000.00', 0, 2017, 0, 1500588000, '2017-11-15 08:24:08', 1),
(427, 427, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:24:08', 1),
(428, 428, '20000.00', 144, 2017, 0, 1484262000, '2017-11-15 08:24:08', 1),
(429, 429, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:24:08', 1),
(430, 430, '20000.00', 0, 2017, 0, 1491256800, '2017-11-15 08:24:08', 1),
(431, 431, '20000.00', 0, 2017, 0, 1495144800, '2017-11-15 08:24:09', 1),
(432, 432, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:09', 1),
(433, 433, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:24:09', 1),
(434, 434, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:24:09', 1),
(435, 435, '20000.00', 0, 2017, 0, 1499205600, '2017-11-15 08:24:09', 1),
(436, 436, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:24:09', 1),
(437, 437, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:24:09', 1),
(438, 438, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:10', 1),
(439, 439, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:24:10', 1),
(440, 440, '20000.00', 0, 2017, 0, 1509055200, '2017-11-15 08:24:10', 1),
(441, 441, '20000.00', 93, 2016, 0, 1481583600, '2017-11-15 08:24:10', 1),
(442, 442, '20000.00', 54, 2016, 0, 1477000800, '2017-11-15 08:24:10', 1),
(443, 443, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 08:24:10', 1),
(444, 444, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:24:11', 1),
(445, 445, '20000.00', 0, 2017, 0, 1500415200, '2017-11-15 08:24:11', 1),
(446, 446, '20000.00', 0, 2017, 0, 1493330400, '2017-11-15 08:24:11', 1),
(447, 447, '20000.00', 0, 2017, 0, 1504044000, '2017-11-15 08:24:11', 1),
(448, 448, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:24:11', 1),
(449, 449, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:24:11', 1),
(450, 450, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 08:24:11', 1),
(451, 451, '20000.00', 45, 2016, 0, 1476223200, '2017-11-15 08:24:12', 1),
(452, 452, '20000.00', 0, 2017, 0, 1501106400, '2017-11-15 08:24:12', 1),
(453, 453, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:12', 1),
(454, 454, '20000.00', 0, 2017, 0, 1505340000, '2017-11-15 08:24:12', 1),
(455, 455, '20000.00', 0, 2017, 0, 1506895200, '2017-11-15 08:24:13', 1),
(456, 456, '20000.00', 58, 2016, 0, 1477260000, '2017-11-15 08:24:13', 1),
(457, 457, '20000.00', 0, 2017, 0, 1492466400, '2017-11-15 08:24:14', 1),
(458, 458, '20000.00', 0, 2017, 0, 1502229600, '2017-11-15 08:24:14', 1),
(459, 459, '20000.00', 78, 2016, 0, 1479078000, '2017-11-15 08:24:14', 1),
(460, 460, '20000.00', 118, 2017, 0, 1483657200, '2017-11-15 08:24:14', 1),
(461, 461, '20000.00', 0, 2017, 0, 1502402400, '2017-11-15 08:24:14', 1),
(462, 462, '20000.00', 0, 2017, 0, 1501797600, '2017-11-15 08:24:15', 1),
(463, 463, '20000.00', 134, 2017, 0, 1484175600, '2017-11-15 08:24:15', 1),
(464, 464, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 08:24:15', 1),
(465, 465, '20000.00', 59, 2016, 0, 1477260000, '2017-11-15 08:24:15', 1),
(466, 466, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:24:15', 1),
(467, 467, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 08:24:15', 1),
(468, 468, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:24:15', 1),
(469, 469, '20000.00', 0, 2017, 0, 1502143200, '2017-11-15 08:24:16', 1),
(470, 470, '20000.00', 0, 2017, 0, 1503525600, '2017-11-15 08:24:16', 1),
(471, 471, '20000.00', 0, 2017, 0, 1504648800, '2017-11-15 08:24:16', 1),
(472, 472, '20000.00', 0, 2017, 0, 1500933600, '2017-11-15 08:24:16', 1),
(473, 473, '20000.00', 14, 2016, 0, 1475013600, '2017-11-15 08:24:16', 1),
(474, 474, '20000.00', 0, 2017, 0, 1502748000, '2017-11-15 08:24:17', 1),
(475, 475, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:24:17', 1),
(476, 476, '20000.00', 17, 2016, 0, 1475013600, '2017-11-15 08:24:17', 1),
(477, 477, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:24:17', 1),
(478, 478, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:24:17', 1),
(479, 479, '20000.00', 121, 2017, 0, 1483657200, '2017-11-15 08:24:18', 1),
(480, 480, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:24:18', 1),
(481, 481, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:24:18', 1),
(482, 482, '20000.00', 0, 2017, 0, 1505685600, '2017-11-15 08:24:18', 1),
(483, 483, '20000.00', 0, 2017, 0, 1502316000, '2017-11-15 08:24:18', 1),
(484, 484, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 08:24:18', 1),
(485, 485, '20000.00', 52, 2016, 0, 1476914400, '2017-11-15 08:24:18', 1),
(486, 486, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 08:24:19', 1),
(487, 487, '20000.00', 0, 2017, 0, 1494972000, '2017-11-15 08:24:19', 1),
(488, 488, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:24:19', 1),
(489, 489, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:19', 1),
(490, 490, '20000.00', 4, 2016, 0, 1470693600, '2017-11-15 08:24:19', 1),
(491, 491, '20000.00', 91, 2016, 0, 1480546800, '2017-11-15 08:24:19', 1),
(492, 492, '20000.00', 0, 2017, 0, 1502834400, '2017-11-15 08:24:19', 1),
(493, 493, '20000.00', 0, 2017, 0, 1506549600, '2017-11-15 08:24:20', 1),
(494, 494, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:20', 1),
(495, 495, '20000.00', 147, 2017, 0, 1484262000, '2017-11-15 08:24:20', 1),
(496, 496, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 08:24:20', 1),
(497, 497, '20000.00', 67, 2016, 0, 1477605600, '2017-11-15 08:24:20', 1),
(498, 498, '20000.00', 64, 2016, 0, 1477605600, '2017-11-15 08:24:20', 1),
(499, 499, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:24:21', 1),
(500, 500, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:24:21', 1),
(501, 501, '20000.00', 0, 2017, 0, 1499292000, '2017-11-15 08:24:21', 1),
(502, 502, '25000.00', 0, 2017, 0, 1501711200, '2017-11-15 08:24:21', 1),
(503, 503, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:21', 1),
(504, 504, '20000.00', 19, 2016, 0, 1475100000, '2017-11-15 08:24:22', 1),
(505, 505, '20000.00', 148, 2017, 0, 1484262000, '2017-11-15 08:24:22', 1),
(506, 506, '20000.00', 0, 2017, 0, 1493589600, '2017-11-15 08:24:22', 1),
(507, 507, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 08:24:23', 1),
(508, 508, '20000.00', 0, 2017, 0, 1495058400, '2017-11-15 08:24:23', 1),
(509, 509, '20000.00', 40, 2016, 0, 1475791200, '2017-11-15 08:24:23', 1),
(510, 510, '20000.00', 0, 2017, 0, 1493676000, '2017-11-15 08:24:23', 1),
(511, 511, '20000.00', 42, 2016, 0, 1475791200, '2017-11-15 08:24:24', 1),
(512, 512, '20000.00', 0, 2017, 0, 1504562400, '2017-11-15 08:24:24', 1),
(513, 513, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:24:24', 1),
(514, 514, '20000.00', 151, 2017, 0, 1484262000, '2017-11-15 08:24:25', 1),
(515, 515, '20000.00', 85, 2016, 0, 1479942000, '2017-11-15 08:24:25', 1),
(516, 516, '20000.00', 28, 2016, 0, 1475186400, '2017-11-15 08:24:26', 1),
(517, 517, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:24:26', 1),
(518, 518, '20000.00', 0, 2017, 0, 1507154400, '2017-11-15 08:24:26', 1),
(519, 519, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 08:24:26', 1),
(520, 520, '20000.00', 0, 2017, 0, 1500501600, '2017-11-15 08:24:26', 1),
(521, 521, '20000.00', 0, 2017, 0, 1499032800, '2017-11-15 08:24:27', 1),
(522, 522, '20000.00', 0, 2017, 0, 1507240800, '2017-11-15 08:24:27', 1),
(523, 523, '20000.00', 74, 2016, 0, 1478214000, '2017-11-15 08:24:27', 1),
(524, 524, '20000.00', 60, 2016, 0, 1477260000, '2017-11-15 08:24:27', 1),
(525, 525, '20000.00', 0, 2017, 0, 1493935200, '2017-11-15 08:24:28', 1),
(526, 526, '20000.00', 0, 2017, 0, 1509318000, '2017-11-15 08:24:28', 1),
(527, 527, '20000.00', 0, 2017, 0, 1496786400, '2017-11-15 08:24:28', 1),
(528, 528, '20000.00', 41, 2016, 0, 1476914400, '2017-11-15 08:24:28', 1),
(529, 529, '20000.00', 36, 2016, 0, 1475791200, '2017-11-15 08:24:28', 1),
(530, 530, '20000.00', 0, 2017, 0, 1495058400, '2017-11-15 08:24:28', 1),
(531, 531, '20000.00', 0, 2017, 0, 1492639200, '2017-11-15 08:24:28', 1),
(532, 532, '20000.00', 0, 2017, 0, 1492466400, '2017-11-15 08:24:29', 1),
(533, 533, '20000.00', 0, 2017, 0, 1495490400, '2017-11-15 08:24:29', 1),
(534, 534, '20000.00', 0, 2017, 0, 1501106400, '2017-11-15 08:24:29', 1),
(535, 535, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:24:29', 1),
(536, 536, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:24:29', 1),
(537, 537, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 08:24:29', 1),
(538, 538, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:29', 1),
(539, 539, '20000.00', 0, 2017, 0, 1499637600, '2017-11-15 08:24:30', 1),
(540, 540, '20000.00', 69, 2016, 0, 1477954800, '2017-11-15 08:24:30', 1),
(541, 541, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 08:24:30', 1),
(542, 542, '20000.00', 75, 2016, 0, 1478214000, '2017-11-15 08:24:30', 1),
(543, 543, '20000.00', 0, 2017, 0, 1499292000, '2017-11-15 08:24:30', 1),
(544, 544, '20000.00', 141, 2017, 0, 1484262000, '2017-11-15 08:24:30', 1),
(545, 545, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:30', 1),
(546, 546, '20000.00', 156, 2017, 0, 1484262000, '2017-11-15 08:24:31', 1),
(547, 547, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 08:24:31', 1),
(548, 548, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:24:31', 1),
(549, 549, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 08:24:31', 1),
(550, 550, '20000.00', 0, 2017, 0, 1504476000, '2017-11-15 08:24:31', 1),
(551, 551, '20000.00', 0, 2017, 0, 1494453600, '2017-11-15 08:24:31', 1),
(552, 552, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:24:31', 1),
(553, 553, '20000.00', 65, 2016, 0, 1477605600, '2017-11-15 08:24:32', 1),
(554, 554, '20000.00', 37, 2016, 0, 1475791200, '2017-11-15 08:24:32', 1),
(555, 555, '20000.00', 26, 2016, 0, 1475100000, '2017-11-15 08:24:32', 1),
(556, 556, '20000.00', 0, 2017, 0, 1494367200, '2017-11-15 08:24:32', 1),
(557, 557, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:32', 1),
(558, 558, '20000.00', 0, 2017, 0, 1502316000, '2017-11-15 08:24:33', 1),
(559, 559, '20000.00', 0, 2017, 0, 1508277600, '2017-11-15 08:24:33', 1),
(560, 560, '20000.00', 0, 2017, 0, 1497391200, '2017-11-15 08:24:33', 1),
(561, 561, '20000.00', 79, 2016, 0, 1479078000, '2017-11-15 08:24:33', 1),
(562, 562, '20000.00', 0, 2017, 0, 1502920800, '2017-11-15 08:24:34', 1),
(563, 563, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 08:24:34', 1),
(564, 564, '20000.00', 0, 2017, 0, 1501106400, '2017-11-15 08:24:35', 1),
(565, 565, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:35', 1),
(566, 566, '20000.00', 152, 2017, 0, 1484262000, '2017-11-15 08:24:35', 1),
(567, 567, '20000.00', 0, 2017, 0, 1507240800, '2017-11-15 08:24:36', 1),
(568, 568, '20000.00', 122, 2017, 0, 1483916400, '2017-11-15 08:24:36', 1),
(569, 569, '20000.00', 0, 2017, 0, 1493071200, '2017-11-15 08:24:36', 1),
(570, 570, '20000.00', 0, 2017, 0, 1499983200, '2017-11-15 08:24:37', 1),
(571, 571, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:24:37', 1),
(572, 572, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:37', 1),
(573, 573, '20000.00', 90, 2016, 0, 1480546800, '2017-11-15 08:24:37', 1),
(574, 574, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:24:37', 1),
(575, 575, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:24:37', 1),
(576, 576, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:24:38', 1),
(577, 577, '20000.00', 0, 2017, 0, 1506636000, '2017-11-15 08:24:38', 1),
(578, 578, '20000.00', 0, 2017, 0, 1493244000, '2017-11-15 08:24:38', 1),
(579, 579, '20000.00', 0, 2017, 0, 1500242400, '2017-11-15 08:24:39', 1),
(580, 580, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:39', 1),
(581, 581, '20000.00', 49, 2016, 0, 1476396000, '2017-11-15 08:24:39', 1),
(582, 582, '20000.00', 10, 2016, 0, 1475013600, '2017-11-15 08:24:39', 1),
(583, 583, '20000.00', 0, 2017, 0, 1503007200, '2017-11-15 08:24:39', 1),
(584, 584, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 08:24:39', 1),
(585, 585, '20000.00', 0, 2017, 0, 1500933600, '2017-11-15 08:24:39', 1),
(586, 586, '20000.00', 0, 2017, 0, 1495663200, '2017-11-15 08:24:40', 1),
(587, 587, '20000.00', 0, 2017, 0, 1498600800, '2017-11-15 08:24:40', 1),
(588, 588, '20000.00', 12, 2016, 0, 1475013600, '2017-11-15 08:24:40', 1),
(589, 589, '20000.00', 44, 2016, 0, 1476223200, '2017-11-15 08:24:40', 1),
(590, 590, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 08:24:40', 1),
(591, 591, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 08:24:41', 1),
(592, 592, '20000.00', 0, 2017, 0, 1506290400, '2017-11-15 08:24:41', 1),
(593, 593, '20000.00', 0, 2017, 0, 1493589600, '2017-11-15 08:24:41', 1),
(594, 594, '20000.00', 0, 2017, 0, 1491861600, '2017-11-15 08:24:41', 1),
(595, 595, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:42', 1),
(596, 596, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 08:24:42', 1),
(597, 597, '20000.00', 0, 2017, 0, 1503525600, '2017-11-15 08:24:42', 1),
(598, 598, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 08:24:42', 1),
(599, 599, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:24:42', 1),
(600, 600, '20000.00', 0, 2017, 0, 1491343200, '2017-11-15 08:24:42', 1),
(601, 601, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:43', 1),
(602, 602, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:43', 1),
(603, 603, '20000.00', 0, 2017, 0, 1501452000, '2017-11-15 08:24:43', 1),
(604, 604, '20000.00', 0, 2017, 0, 1503352800, '2017-11-15 08:24:43', 1),
(605, 605, '20000.00', 0, 2017, 0, 1506549600, '2017-11-15 08:24:43', 1),
(606, 606, '20000.00', 0, 2017, 0, 1505080800, '2017-11-15 08:24:43', 1),
(607, 607, '20000.00', 0, 2017, 0, 1501452000, '2017-11-15 08:24:43', 1),
(608, 608, '20000.00', 0, 2017, 0, 1502402400, '2017-11-15 08:24:43', 1),
(609, 609, '20000.00', 89, 2016, 0, 1480287600, '2017-11-15 08:24:43', 1),
(610, 610, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:44', 1),
(611, 611, '20000.00', 0, 2017, 0, 1499896800, '2017-11-15 08:24:44', 1),
(612, 612, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 08:24:44', 1),
(613, 613, '20000.00', 56, 2016, 0, 1477260000, '2017-11-15 08:24:44', 1),
(614, 614, '20000.00', 2, 2016, 0, 1472594400, '2017-11-15 08:24:44', 1),
(615, 615, '20000.00', 0, 2017, 0, 1498428000, '2017-11-15 08:24:45', 1),
(616, 616, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:46', 1),
(617, 617, '20000.00', 0, 2017, 0, 1492034400, '2017-11-15 08:24:46', 1),
(618, 618, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 08:24:46', 1),
(619, 619, '20000.00', 0, 2017, 0, 1504130400, '2017-11-15 08:24:47', 1),
(620, 620, '20000.00', 158, 2017, 0, 1484694000, '2017-11-15 08:24:47', 1),
(621, 621, '20000.00', 0, 2017, 0, 1506463200, '2017-11-15 08:24:47', 1),
(622, 622, '20000.00', 68, 2016, 0, 1477954800, '2017-11-15 08:24:48', 1),
(623, 623, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:48', 1),
(624, 624, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:24:48', 1),
(625, 625, '20000.00', 6, 2016, 0, 1474236000, '2017-11-15 08:24:48', 1),
(626, 626, '20000.00', 120, 2017, 0, 1483657200, '2017-11-15 08:24:48', 1),
(627, 627, '20000.00', 0, 2017, 0, 1493762400, '2017-11-15 08:24:49', 1),
(628, 628, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:24:49', 1),
(629, 629, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:24:49', 1),
(630, 630, '20000.00', 0, 2017, 0, 1505253600, '2017-11-15 08:24:49', 1),
(631, 631, '20000.00', 0, 2017, 0, 1502143200, '2017-11-15 08:24:50', 1),
(632, 632, '20000.00', 0, 2017, 0, 1499378400, '2017-11-15 08:24:50', 1),
(633, 633, '20000.00', 0, 2017, 0, 1493157600, '2017-11-15 08:24:50', 1),
(634, 634, '20000.00', 71, 2016, 0, 1477954800, '2017-11-15 08:24:50', 1),
(635, 635, '20000.00', 95, 2016, 0, 1482274800, '2017-11-15 08:24:50', 1),
(636, 636, '20000.00', 0, 2017, 0, 1491948000, '2017-11-15 08:24:50', 1),
(637, 637, '20000.00', 23, 2016, 0, 1475100000, '2017-11-15 08:24:51', 1),
(638, 638, '20000.00', 0, 2017, 0, 1508450400, '2017-11-15 08:24:51', 1),
(639, 639, '20000.00', 0, 2017, 0, 1496181600, '2017-11-15 08:24:51', 1),
(640, 640, '20000.00', 80, 2016, 0, 1479164400, '2017-11-15 08:24:51', 1),
(641, 641, '20000.00', 43, 2016, 0, 1476136800, '2017-11-15 08:24:51', 1),
(642, 642, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:24:51', 1),
(643, 643, '20000.00', 0, 2017, 0, 1504044000, '2017-11-15 08:24:52', 1),
(644, 644, '20000.00', 0, 2017, 0, 1494280800, '2017-11-15 08:24:52', 1),
(645, 645, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:52', 1),
(646, 646, '20000.00', 0, 2017, 0, 1492552800, '2017-11-15 08:24:52', 1),
(647, 647, '20000.00', 0, 2017, 0, 1502661600, '2017-11-15 08:24:53', 1),
(648, 648, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:24:53', 1),
(649, 649, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 08:24:53', 1),
(650, 650, '20000.00', 0, 2017, 0, 1503439200, '2017-11-15 08:24:53', 1),
(651, 651, '20000.00', 0, 2017, 0, 1497304800, '2017-11-15 08:24:53', 1),
(652, 652, '20000.00', 0, 2017, 0, 1490738400, '2017-11-15 08:24:53', 1),
(653, 653, '20000.00', 0, 2017, 0, 1498168800, '2017-11-15 08:24:53', 1),
(654, 654, '20000.00', 29, 2016, 0, 1475186400, '2017-11-15 08:24:53', 1),
(655, 655, '20000.00', 39, 2016, 0, 1475791200, '2017-11-15 08:24:53', 1),
(656, 656, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:24:54', 1),
(657, 657, '20000.00', 46, 2016, 0, 1476309600, '2017-11-15 08:24:54', 1),
(658, 658, '20000.00', 0, 2017, 0, 1508191200, '2017-11-15 08:24:54', 1),
(659, 659, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:54', 1),
(660, 660, '20000.00', 0, 2017, 0, 1505944800, '2017-11-15 08:24:54', 1),
(661, 661, '20000.00', 0, 2017, 0, 1505685600, '2017-11-15 08:24:54', 1),
(662, 662, '20000.00', 0, 2017, 0, 1490565600, '2017-11-15 08:24:54', 1),
(663, 663, '20000.00', 0, 2017, 0, 1491429600, '2017-11-15 08:24:54', 1),
(664, 664, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 08:24:54', 1),
(665, 665, '20000.00', 0, 2017, 0, 1503612000, '2017-11-15 08:24:54', 1),
(666, 666, '20000.00', 0, 2017, 0, 1503871200, '2017-11-15 08:24:55', 1),
(667, 667, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:55', 1),
(668, 668, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:55', 1),
(669, 669, '20000.00', 0, 2017, 0, 1499810400, '2017-11-15 08:24:55', 1),
(670, 670, '20000.00', 0, 2017, 0, 1492984800, '2017-11-15 08:24:56', 1),
(671, 671, '20000.00', 0, 2017, 0, 1503266400, '2017-11-15 08:24:56', 1),
(672, 672, '20000.00', 0, 2017, 0, 1499724000, '2017-11-15 08:24:56', 1),
(673, 673, '20000.00', 178, 2017, 0, 1486335600, '2017-11-15 08:24:56', 1),
(674, 674, '20000.00', 160, 2017, 0, 1486422000, '2017-11-15 08:24:57', 1),
(675, 675, '20000.00', 105, 2017, 0, 1485126000, '2017-11-15 08:24:57', 1),
(676, 676, '20000.00', 173, 2017, 0, 1486335600, '2017-11-15 08:24:58', 1),
(677, 677, '20000.00', 0, 2017, 0, 1489014000, '2017-11-15 08:24:58', 1),
(678, 678, '20000.00', 183, 2017, 0, 1486422000, '2017-11-15 08:24:58', 1),
(679, 679, '20000.00', 159, 2017, 0, 1485903600, '2017-11-15 08:24:58', 1),
(680, 680, '20000.00', 112, 2017, 0, 1485730800, '2017-11-15 08:24:59', 1),
(681, 681, '20000.00', 97, 2017, 0, 1483398000, '2017-11-15 08:24:59', 1),
(682, 682, '20000.00', 99, 2017, 0, 1483657200, '2017-11-15 08:24:59', 1),
(683, 683, '20000.00', 111, 2017, 0, 1485730800, '2017-11-15 08:24:59', 1),
(684, 684, '20000.00', 0, 2017, 0, 1490824800, '2017-11-15 08:25:00', 1),
(685, 685, '20000.00', 190, 2017, 0, 1487890800, '2017-11-15 08:25:00', 1),
(686, 686, '20000.00', 165, 2017, 0, 1486422000, '2017-11-15 08:25:00', 1),
(687, 687, '20000.00', 169, 2017, 0, 1486594800, '2017-11-15 08:25:00', 1),
(688, 688, '20000.00', 0, 2017, 0, 1490050800, '2017-11-15 08:25:00', 1),
(689, 689, '20000.00', 167, 2017, 0, 1486422000, '2017-11-15 08:25:01', 1),
(690, 690, '20000.00', 166, 2017, 0, 1486422000, '2017-11-15 08:25:01', 1),
(691, 691, '20000.00', 177, 2017, 0, 1486335600, '2017-11-15 08:25:01', 1),
(692, 692, '20000.00', 162, 2017, 0, 1486422000, '2017-11-15 08:25:01', 1);
INSERT INTO `subscription` (`id`, `memberId`, `amount`, `receipt_no`, `subscriptionYear`, `receivedBy`, `datePaid`, `dateModified`, `modifiedBy`) VALUES
(693, 693, '20000.00', 0, 2017, 0, 1492725600, '2017-11-15 08:25:01', 1),
(694, 694, '20000.00', 106, 2017, 0, 1485730800, '2017-11-15 08:25:01', 1),
(695, 695, '20000.00', 110, 2017, 0, 1485730800, '2017-11-15 08:25:01', 1),
(696, 696, '20000.00', 174, 2017, 0, 1486335600, '2017-11-15 08:25:02', 1),
(697, 697, '20000.00', 188, 2017, 0, 1487804400, '2017-11-15 08:25:02', 1),
(698, 698, '20000.00', 107, 2017, 0, 1485730800, '2017-11-15 08:25:02', 1),
(699, 699, '20000.00', 108, 2017, 0, 1485730800, '2017-11-15 08:25:02', 1),
(700, 700, '20000.00', 161, 2017, 0, 1486422000, '2017-11-15 08:25:02', 1),
(701, 701, '20000.00', 102, 2017, 0, 1484521200, '2017-11-15 08:25:02', 1),
(702, 702, '20000.00', 164, 2017, 0, 1486422000, '2017-11-15 08:25:03', 1),
(703, 703, '20000.00', 186, 2017, 0, 1487545200, '2017-11-15 08:25:03', 1),
(704, 704, '10000.00', 113, 2017, 0, 1485730800, '2017-11-15 08:25:03', 1),
(705, 705, '20000.00', 168, 2017, 0, 1486594800, '2017-11-15 08:25:03', 1),
(706, 706, '20000.00', 176, 2017, 0, 1486335600, '2017-11-15 08:25:03', 1),
(707, 707, '20000.00', 191, 2017, 0, 1487890800, '2017-11-15 08:25:03', 1),
(708, 708, '20000.00', 172, 2017, 0, 1486335600, '2017-11-15 08:25:04', 1),
(709, 709, '20000.00', 185, 2017, 0, 1486594800, '2017-11-15 08:25:04', 1),
(710, 710, '20000.00', 192, 2017, 0, 1488150000, '2017-11-15 08:25:04', 1),
(711, 711, '20000.00', 171, 2017, 0, 1486335600, '2017-11-15 08:25:04', 1),
(712, 712, '20000.00', 0, 2017, 0, 1490050800, '2017-11-15 08:25:04', 1),
(713, 713, '20000.00', 180, 2017, 0, 1486422000, '2017-11-15 08:25:04', 1),
(714, 714, '20000.00', 98, 2017, 0, 1483657200, '2017-11-15 08:25:04', 1),
(715, 715, '20000.00', 0, 2017, 0, 1490223600, '2017-11-15 08:25:04', 1),
(716, 716, '20000.00', 103, 2017, 0, 1484780400, '2017-11-15 08:25:04', 1),
(717, 717, '20000.00', 193, 2017, 0, 1488150000, '2017-11-15 08:25:05', 1),
(718, 718, '20000.00', 114, 2017, 0, 1483570800, '2017-11-15 08:25:05', 1),
(719, 719, '20000.00', 194, 2017, 0, 1489100400, '2017-11-15 08:25:05', 1),
(720, 720, '20000.00', 195, 2017, 0, 1489100400, '2017-11-15 08:25:05', 1),
(721, 721, '20000.00', 175, 2017, 0, 1486335600, '2017-11-15 08:25:05', 1),
(722, 722, '20000.00', 187, 2017, 0, 1487631600, '2017-11-15 08:25:05', 1),
(723, 723, '20000.00', 104, 2017, 0, 1484780400, '2017-11-15 08:25:05', 1),
(724, 724, '20000.00', 181, 2017, 0, 1486422000, '2017-11-15 08:25:06', 1),
(725, 725, '20000.00', 196, 2017, 0, 1489532400, '2017-11-15 08:25:06', 1),
(726, 726, '20000.00', 184, 2017, 0, 1486508400, '2017-11-15 08:25:06', 1),
(727, 727, '20000.00', 163, 2017, 0, 1486422000, '2017-11-15 08:25:07', 1),
(728, 728, '20000.00', 100, 2017, 0, 1483916400, '2017-11-15 08:25:07', 1),
(729, 729, '20000.00', 109, 2017, 0, 1485730800, '2017-11-15 08:25:07', 1),
(730, 730, '20000.00', 101, 2017, 0, 1484262000, '2017-11-15 08:25:08', 1),
(731, 731, '20000.00', 170, 2017, 0, 1486594800, '2017-11-15 08:25:08', 1),
(732, 732, '20000.00', 179, 2017, 0, 1486422000, '2017-11-15 08:25:08', 1),
(733, 733, '20000.00', 189, 2017, 0, 1487804400, '2017-11-15 08:25:08', 1),
(734, 734, '20000.00', 182, 2017, 0, 1486422000, '2017-11-15 08:25:09', 1),
(735, 735, '20000.00', 0, 2017, 0, 1488495600, '2017-11-15 08:25:09', 1),
(736, 736, '20000.00', 0, 2017, 0, 1493848800, '2017-11-15 08:25:09', 1);

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
  MODIFY `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `deposit_account_fee`
--
ALTER TABLE `deposit_account_fee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `deposit_account_transaction`
--
ALTER TABLE `deposit_account_transaction`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_products`
--
ALTER TABLE `loan_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=737;
--
-- AUTO_INCREMENT for table `member_deposit_account`
--
ALTER TABLE `member_deposit_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=739;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `person_employment`
--
ALTER TABLE `person_employment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `person_relative`
--
ALTER TABLE `person_relative`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=737;
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
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
