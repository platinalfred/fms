-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 21, 2017 at 07:24 PM
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
  `approvalDate` int(11) NOT NULL COMMENT 'Date and time of loan application approval',
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

INSERT INTO `loan_account` (`id`, `loanNo`, `branch_id`, `status`, `loanProductId`, `requestedAmount`, `applicationDate`, `disbursedAmount`, `disbursementDate`, `interestRate`, `offSetPeriod`, `loanPeriod`, `gracePeriod`, `repaymentsFrequency`, `repaymentsMadeEvery`, `installments`, `penaltyCalculationMethodId`, `penaltyTolerancePeriod`, `penaltyRateChargedPer`, `penaltyRate`, `linkToDepositAccount`, `expectedPayback`, `dailyDefaultAmount`, `comments`, `amountApproved`, `approvalDate`, `approvedBy`, `approvalNotes`, `createdBy`, `dateCreated`, `modifiedBy`, `dateModified`) VALUES
(1, '-1706135220', 0, 3, 1, '45000.00', 1497301200, '0.00', 0, '12.00', 1, NULL, 5, 4, 2, 6, 2, 2, 1, '0.00', 1, NULL, NULL, '', '45000.00', 1497959635, 1, 'The board is in full approval of the application', 1, 1497336740, 1, '2017-06-20 11:53:55'),
(2, '-1706203420', 0, 2, 2, '130000.00', 1497906000, '0.00', 0, '8.00', 2, NULL, 3, 1, 3, 6, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, 1497989500, 1, 'Some of the details could not be verified', 1, 1497987260, 1, '2017-06-20 20:11:40'),
(3, '-1706201933', 0, 1, 2, '300000.00', 1497906000, '0.00', 0, '12.00', 1, NULL, 2, 1, 3, 5, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, 0, NULL, NULL, 1, 1497989973, 1, '0000-00-00 00:00:00'),
(4, '-1706215006', 0, 1, 2, '450000.00', 1497992400, '0.00', 0, '13.00', 3, NULL, 0, 1, 3, 7, 2, 1, 1, '0.00', 1, NULL, NULL, '', NULL, 0, NULL, NULL, 1, 1498020606, 1, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `loan_collateral`
--

CREATE TABLE `loan_collateral` (
  `id` int(11) NOT NULL,
  `loanAccountId` int(11) NOT NULL,
  `itemName` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `itemValue` decimal(15,2) NOT NULL COMMENT 'value of the item',
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
(1, 1, 'Laptop computer', 'Dell Inspiron 15". 500 GB Hard Drive. Core i5', '0.00', NULL, 1496426991, 1, '0000-00-00 00:00:00', 1),
(2, 0, 'Land title', 'The land is located in Gayaza, Kazo zone', '0.00', 'C:fakepathunra.pdf', 1497297283, 1, '0000-00-00 00:00:00', 1),
(3, 0, 'Laptop computer', 'HP 15" Laptop in very perfect condition', '0.00', 'undefined', 1497298165, 1, '0000-00-00 00:00:00', 1),
(4, 1, 'Television set', '32" sony bravia tv', '0.00', 'undefined', 1497329425, 1, '0000-00-00 00:00:00', 1),
(5, 1, 'Mobile phone', 'Samsung Veto', '0.00', 'undefined', 1497336251, 1, '0000-00-00 00:00:00', 1),
(6, 2, 'Mobile phone', 'Samsung Veto', '0.00', 'undefined', 1497336516, 1, '0000-00-00 00:00:00', 1),
(7, 1, 'Mobile phone', 'Samsung Veto', '0.00', 'undefined', 1497336740, 1, '0000-00-00 00:00:00', 1),
(8, 2, 'SUV', 'Isuzu SUV, UAJ 456J, 2008 model', '0.00', 'undefined', 1497987260, 1, '0000-00-00 00:00:00', 1),
(9, 3, 'Motor cycle', 'Hero motor bike, UDC 453K', '0.00', 'undefined', 1497989973, 1, '0000-00-00 00:00:00', 1),
(10, 4, 'Land title', 'Piece of land in Bweyogerere', '0.00', 'undefined', 1498020607, 1, '0000-00-00 00:00:00', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `guarantor`
--
ALTER TABLE `guarantor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_number` (`memberId`),
  ADD KEY `loan_id` (`loanAccountId`),
  ADD KEY `dateCreated` (`dateCreated`),
  ADD KEY `fkCreatedBy` (`createdBy`),
  ADD KEY `dateModified` (`dateModified`),
  ADD KEY `fkModifiedBy` (`modifiedBy`);

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
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `guarantor`
--
ALTER TABLE `guarantor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `loan_account`
--
ALTER TABLE `loan_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `loan_collateral`
--
ALTER TABLE `loan_collateral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
