-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Oct 27, 2017 at 08:21 AM
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
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `group_loan_account`
--
ALTER TABLE `group_loan_account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
