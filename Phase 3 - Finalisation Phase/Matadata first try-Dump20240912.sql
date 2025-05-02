CREATE DATABASE  IF NOT EXISTS `airbnb_datamart_sky` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `airbnb_datamart_sky`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: airbnb_datamart_sky
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `amenity`
--

DROP TABLE IF EXISTS `amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenity` (
  `AmenityID` int NOT NULL AUTO_INCREMENT,
  `AmenityName` varchar(100) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`AmenityID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `BookingID` int NOT NULL AUTO_INCREMENT,
  `GuestID` int NOT NULL,
  `RoomID` int NOT NULL,
  `BookingDate` datetime NOT NULL,
  `CheckInDate` date NOT NULL,
  `CheckOutDate` date NOT NULL,
  `TotalPrice` float NOT NULL,
  `PaymentStatus` enum('Paid','Pending','Cancelled') NOT NULL,
  `LengthOfStay` int NOT NULL,
  `CancellationDeadline` date DEFAULT NULL,
  `CancellationRefund` float DEFAULT NULL,
  `DateOfCancellation` date DEFAULT NULL,
  `HostPayout` float DEFAULT NULL,
  `EventName` varchar(255) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`BookingID`),
  KEY `GuestID` (`GuestID`),
  KEY `RoomID` (`RoomID`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`) ON DELETE CASCADE,
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`RoomID`) REFERENCES `room` (`RoomID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cancellationpolicy`
--

DROP TABLE IF EXISTS `cancellationpolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cancellationpolicy` (
  `PolicyID` int NOT NULL AUTO_INCREMENT,
  `PolicyName` varchar(100) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`PolicyID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `CityID` int NOT NULL AUTO_INCREMENT,
  `CityName` varchar(100) DEFAULT NULL,
  `Country` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CityID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customerservice`
--

DROP TABLE IF EXISTS `customerservice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerservice` (
  `CustomerServiceID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int NOT NULL,
  `IssueDescription` text,
  `Resolution` text,
  `ContactMethod` varchar(255) DEFAULT NULL,
  `ResolutionDate` date DEFAULT NULL,
  PRIMARY KEY (`CustomerServiceID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `customerservice_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event` (
  `EventID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int NOT NULL,
  `EventName` varchar(255) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`EventID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `event_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `GuestID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `ProfilePicture` varchar(255) DEFAULT NULL,
  `Street` varchar(255) DEFAULT NULL,
  `City` varchar(255) DEFAULT NULL,
  `State` varchar(255) DEFAULT NULL,
  `Country` varchar(255) DEFAULT NULL,
  `GDPRAcknowledgement` tinyint(1) DEFAULT NULL,
  `LanguageSettings` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`GuestID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guestsocialnetwork`
--

DROP TABLE IF EXISTS `guestsocialnetwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guestsocialnetwork` (
  `GuestSocialNetworkID` int NOT NULL AUTO_INCREMENT,
  `GuestID` int NOT NULL,
  `NetworkID` int NOT NULL,
  `ProfileURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`GuestSocialNetworkID`),
  KEY `GuestID` (`GuestID`),
  KEY `NetworkID` (`NetworkID`),
  CONSTRAINT `guestsocialnetwork_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`),
  CONSTRAINT `guestsocialnetwork_ibfk_2` FOREIGN KEY (`NetworkID`) REFERENCES `socialnetwork` (`NetworkID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host`
--

DROP TABLE IF EXISTS `host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host` (
  `HostID` int NOT NULL AUTO_INCREMENT,
  `GuestID` int NOT NULL,
  `Rating` float DEFAULT NULL,
  `Verified` tinyint(1) DEFAULT NULL,
  `HostSince` date DEFAULT NULL,
  `Stars` int DEFAULT NULL,
  `ExternalReviews` text,
  `ReferredByHostID` int DEFAULT NULL,
  PRIMARY KEY (`HostID`),
  KEY `GuestID` (`GuestID`),
  KEY `ReferredByHostID` (`ReferredByHostID`),
  CONSTRAINT `host_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`) ON DELETE CASCADE,
  CONSTRAINT `host_ibfk_2` FOREIGN KEY (`ReferredByHostID`) REFERENCES `host` (`HostID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `LocationID` int NOT NULL AUTO_INCREMENT,
  `CityID` int DEFAULT NULL,
  `Country` varchar(100) DEFAULT NULL,
  `PartOfCity` varchar(100) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LocationID`),
  KEY `CityID` (`CityID`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`CityID`) REFERENCES `city` (`CityID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loginhistory`
--

DROP TABLE IF EXISTS `loginhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loginhistory` (
  `LoginID` int NOT NULL AUTO_INCREMENT,
  `GuestID` int NOT NULL,
  `LoginTimestamp` datetime DEFAULT NULL,
  `IPAddress` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`LoginID`),
  KEY `GuestID` (`GuestID`),
  CONSTRAINT `loginhistory_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `NotificationID` int NOT NULL AUTO_INCREMENT,
  `GuestID` int NOT NULL,
  `Content` text,
  `Timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`NotificationID`),
  KEY `GuestID` (`GuestID`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion` (
  `PromotionID` int NOT NULL AUTO_INCREMENT,
  `VacationRentalID` int NOT NULL,
  `DiscountPercentage` float DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  PRIMARY KEY (`PromotionID`),
  KEY `VacationRentalID` (`VacationRentalID`),
  CONSTRAINT `promotion_ibfk_1` FOREIGN KEY (`VacationRentalID`) REFERENCES `vacationrental` (`VacationRentalID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `ReservationID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int NOT NULL,
  `AdminID` int NOT NULL,
  `DateOfReservation` date DEFAULT NULL,
  `PaymentStatus` enum('Paid','Pending','Cancelled') DEFAULT NULL,
  `LengthOfStay` int DEFAULT NULL,
  `CancellationPolicy` text,
  `RefundPolicy` text,
  PRIMARY KEY (`ReservationID`),
  KEY `BookingID` (`BookingID`),
  KEY `AdminID` (`AdminID`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`AdminID`) REFERENCES `traveladmin` (`AdminID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `ReviewID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int NOT NULL,
  `ReviewerID` int NOT NULL,
  `ReviewerType` enum('Guest','Host') NOT NULL,
  `Rating` int DEFAULT NULL,
  `Comment` text,
  `ReviewDate` date DEFAULT NULL,
  PRIMARY KEY (`ReviewID`),
  KEY `BookingID` (`BookingID`),
  KEY `ReviewerID` (`ReviewerID`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`) ON DELETE CASCADE,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`ReviewerID`) REFERENCES `guest` (`GuestID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `RoomID` int NOT NULL AUTO_INCREMENT,
  `VacationRentalID` int NOT NULL,
  `RoomType` varchar(100) DEFAULT NULL,
  `PricePerNight` float DEFAULT NULL,
  `AvailableFrom` date DEFAULT NULL,
  `AvailableTo` date DEFAULT NULL,
  PRIMARY KEY (`RoomID`),
  KEY `VacationRentalID` (`VacationRentalID`),
  CONSTRAINT `room_ibfk_1` FOREIGN KEY (`VacationRentalID`) REFERENCES `vacationrental` (`VacationRentalID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `socialnetwork`
--

DROP TABLE IF EXISTS `socialnetwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socialnetwork` (
  `NetworkID` int NOT NULL AUTO_INCREMENT,
  `NetworkName` varchar(100) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`NetworkID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `TransactionID` int NOT NULL AUTO_INCREMENT,
  `GuestID` int NOT NULL,
  `BookingID` int NOT NULL,
  `Amount` float NOT NULL,
  `TransactionDate` datetime NOT NULL,
  `PaymentMethod` enum('CreditCard','BankTransfer','Cash','Voucher','PayPal','ApplePay','GPay','CreditCard_MasterCard','CreditCard_Visa','CreditCard_AMEX','CreditCard_FirstCard','CreditCard_DinersClub','Maestro','SOFORT_Payment','BNPL','Klarna') NOT NULL,
  `TransactionType` enum('Payment','Refund') NOT NULL,
  `RefundProcessedDate` datetime DEFAULT NULL,
  `Description` text NOT NULL,
  PRIMARY KEY (`TransactionID`),
  KEY `GuestID` (`GuestID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`),
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `traveladmin`
--

DROP TABLE IF EXISTS `traveladmin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `traveladmin` (
  `AdminID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `GuestID` int NOT NULL,
  PRIMARY KEY (`AdminID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `GuestID` (`GuestID`),
  CONSTRAINT `traveladmin_ibfk_1` FOREIGN KEY (`GuestID`) REFERENCES `guest` (`GuestID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacationrental`
--

DROP TABLE IF EXISTS `vacationrental`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacationrental` (
  `VacationRentalID` int NOT NULL AUTO_INCREMENT,
  `HostID` int NOT NULL,
  `LocationID` int NOT NULL,
  `PropertyType` varchar(100) DEFAULT NULL,
  `Description` text,
  `MaxGuests` int DEFAULT NULL,
  `RatePerPerson` float DEFAULT NULL,
  `OwnBathroom` tinyint(1) DEFAULT NULL,
  `DogFriendly` tinyint(1) DEFAULT NULL,
  `FreeParking` tinyint(1) DEFAULT NULL,
  `NumberOfBeds` int DEFAULT NULL,
  `CalendarAvailability` text,
  `ProximityToBeach` varchar(255) DEFAULT NULL,
  `ProximityToShops` varchar(255) DEFAULT NULL,
  `ProximityToSightSeeing` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`VacationRentalID`),
  KEY `HostID` (`HostID`),
  KEY `LocationID` (`LocationID`),
  CONSTRAINT `vacationrental_ibfk_1` FOREIGN KEY (`HostID`) REFERENCES `host` (`HostID`) ON DELETE CASCADE,
  CONSTRAINT `vacationrental_ibfk_2` FOREIGN KEY (`LocationID`) REFERENCES `location` (`LocationID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacationrentalamenity`
--

DROP TABLE IF EXISTS `vacationrentalamenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacationrentalamenity` (
  `VacationRentalID` int NOT NULL,
  `AmenityID` int NOT NULL,
  PRIMARY KEY (`VacationRentalID`,`AmenityID`),
  KEY `AmenityID` (`AmenityID`),
  CONSTRAINT `vacationrentalamenity_ibfk_1` FOREIGN KEY (`VacationRentalID`) REFERENCES `vacationrental` (`VacationRentalID`),
  CONSTRAINT `vacationrentalamenity_ibfk_2` FOREIGN KEY (`AmenityID`) REFERENCES `amenity` (`AmenityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacationrentalpolicy`
--

DROP TABLE IF EXISTS `vacationrentalpolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacationrentalpolicy` (
  `VacationRentalID` int NOT NULL,
  `PolicyID` int NOT NULL,
  PRIMARY KEY (`VacationRentalID`,`PolicyID`),
  KEY `PolicyID` (`PolicyID`),
  CONSTRAINT `vacationrentalpolicy_ibfk_1` FOREIGN KEY (`VacationRentalID`) REFERENCES `vacationrental` (`VacationRentalID`),
  CONSTRAINT `vacationrentalpolicy_ibfk_2` FOREIGN KEY (`PolicyID`) REFERENCES `cancellationpolicy` (`PolicyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-12 21:49:50
