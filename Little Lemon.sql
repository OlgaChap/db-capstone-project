

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;


CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Booking` (
  `BookingID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `TableNumber` INT NOT NULL,
  PRIMARY KEY (`BookingID`))
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `CustomerID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`DeliveryStatus` (
  `DeliveryID` INT NOT NULL,
  `DeliveryDate` DATETIME NOT NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL NULL,
  `Booking_BookingID` INT NOT NULL,
  `Customer_CustomerID` INT NOT NULL,
  `Menu_MenuID` INT NOT NULL,
  `DeliveryStatus_DeliveryID` INT NOT NULL,
  PRIMARY KEY (`OrderID`, `Customer_CustomerID`, `Menu_MenuID`, `DeliveryStatus_DeliveryID`),
  INDEX `fk_Orders_Booking_idx` (`Booking_BookingID` ASC) VISIBLE,
  INDEX `fk_Orders_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  INDEX `fk_Orders_Menu1_idx` (`Menu_MenuID` ASC) VISIBLE,
  INDEX `fk_Orders_DeliveryStatus1_idx` (`DeliveryStatus_DeliveryID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Booking`
    FOREIGN KEY (`Booking_BookingID`)
    REFERENCES `LittleLemonDB`.`Booking` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`Menu_MenuID`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_DeliveryStatus1`
    FOREIGN KEY (`DeliveryStatus_DeliveryID`)
    REFERENCES `LittleLemonDB`.`DeliveryStatus` (`DeliveryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Salary` DECIMAL NOT NULL,
  `Customer_CustomerID` INT NOT NULL,
  PRIMARY KEY (`StaffID`),
  INDEX `fk_Staff_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Staff_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

CREATE VIEW OrdersView AS
SELECT orders.OrderID, orders.Quantity, orders.TotalCost
FROM orders
WHERE orders.Quantity > 2;

CREATE VIEW OrdersView2 AS
SELECT customer.CustomerID, customer.FullName, orders.OrderID, orders.TotalCost
FROM customer INNER JOIN orders
WHERE orders.TotalCost > 150
ORDER BY orders.TotalCost DESC;

CREATE PROCEDURE GetMaxQuantity()

SELECT MAX(orders.Quantity)
FROM orders;

PREPARE GetOrderDetail FROM @order;

CREATE PROCEDURE CancelOrder(in OrderID INT)
DELETE FROM orders;