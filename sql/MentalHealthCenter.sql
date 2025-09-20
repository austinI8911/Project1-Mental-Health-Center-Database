-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Client` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Client` (
  `ClientID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `DOB` DATE NULL,
  `Email` VARCHAR(45) NULL,
  PRIMARY KEY (`ClientID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Staff` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Staff` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `UserName` VARCHAR(45) NOT NULL,
  `Role` ENUM('Counselor', 'Admin', 'Staff') NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `UserName_UNIQUE` (`UserName` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Counselor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Counselor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Counselor` (
  `CounselorID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `LicenseNumber` VARCHAR(45) NOT NULL,
  `Specialties` VARCHAR(100) NULL,
  `Staff_UserID` INT NOT NULL,
  PRIMARY KEY (`CounselorID`, `Staff_UserID`),
  UNIQUE INDEX `LicenseNumber_UNIQUE` (`LicenseNumber` ASC) VISIBLE,
  INDEX `fk_Counselor_Staff1_idx` (`Staff_UserID` ASC) VISIBLE,
  CONSTRAINT `fk_Counselor_Staff1`
    FOREIGN KEY (`Staff_UserID`)
    REFERENCES `mydb`.`Staff` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Room` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Room` (
  `RoomID` INT NOT NULL AUTO_INCREMENT,
  `RoomNum` VARCHAR(10) NOT NULL,
  `Capacity` INT NULL,
  PRIMARY KEY (`RoomID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Appointment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Appointment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Appointment` (
  `AppID` INT NOT NULL AUTO_INCREMENT,
  `StartDateTime` DATETIME NOT NULL,
  `DurationMin` TIME NOT NULL,
  `Status` ENUM('Scheduled', 'Completed', 'Canceled') NULL,
  `Fee` DECIMAL(8,2) NOT NULL,
  `Client_ClientID` INT NOT NULL,
  `Room_RoomID` INT NOT NULL,
  `Counselor_CounselorID` INT NOT NULL,
  PRIMARY KEY (`AppID`, `Client_ClientID`, `Room_RoomID`, `Counselor_CounselorID`),
  INDEX `fk_Appointment_Client_idx` (`Client_ClientID` ASC) VISIBLE,
  INDEX `fk_Appointment_Room1_idx` (`Room_RoomID` ASC) VISIBLE,
  INDEX `fk_Appointment_Counselor1_idx` (`Counselor_CounselorID` ASC) VISIBLE,
  CONSTRAINT `fk_Appointment_Client`
    FOREIGN KEY (`Client_ClientID`)
    REFERENCES `mydb`.`Client` (`ClientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appointment_Room1`
    FOREIGN KEY (`Room_RoomID`)
    REFERENCES `mydb`.`Room` (`RoomID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appointment_Counselor1`
    FOREIGN KEY (`Counselor_CounselorID`)
    REFERENCES `mydb`.`Counselor` (`CounselorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TreatmentPlan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`TreatmentPlan` ;

CREATE TABLE IF NOT EXISTS `mydb`.`TreatmentPlan` (
  `PlanID` INT NOT NULL AUTO_INCREMENT,
  `StartDate` DATE NULL,
  `EndDate` DATE NULL,
  `Status` TEXT(100) NULL,
  `Client_ClientID` INT NOT NULL,
  PRIMARY KEY (`PlanID`, `Client_ClientID`),
  INDEX `fk_TreatmentPlan_Client1_idx` (`Client_ClientID` ASC) VISIBLE,
  CONSTRAINT `fk_TreatmentPlan_Client1`
    FOREIGN KEY (`Client_ClientID`)
    REFERENCES `mydb`.`Client` (`ClientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Diagnosis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Diagnosis` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Diagnosis` (
  `DiagnosisID` INT NOT NULL AUTO_INCREMENT,
  `Code` VARCHAR(20) NOT NULL,
  `Descripstion` VARCHAR(200) NULL,
  PRIMARY KEY (`DiagnosisID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Insurance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Insurance` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Insurance` (
  `InsuranceID` INT NOT NULL AUTO_INCREMENT,
  `Provider` VARCHAR(45) NOT NULL,
  `Phone` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`InsuranceID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Payment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Payment` (
  `PaymentID` INT NOT NULL AUTO_INCREMENT,
  `Amount` DECIMAL(8,2) NOT NULL,
  `Method` ENUM('Cash', 'Card', 'Insurance', 'Other') NULL,
  `DatePaid` DATE NOT NULL,
  `Appointment_AppID` INT NOT NULL,
  `Appointment_Client_ClientID` INT NOT NULL,
  PRIMARY KEY (`PaymentID`, `Appointment_AppID`, `Appointment_Client_ClientID`),
  INDEX `fk_Payment_Appointment1_idx` (`Appointment_AppID` ASC, `Appointment_Client_ClientID` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Appointment1`
    FOREIGN KEY (`Appointment_AppID` , `Appointment_Client_ClientID`)
    REFERENCES `mydb`.`Appointment` (`AppID` , `Client_ClientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SessionNote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`SessionNote` ;

CREATE TABLE IF NOT EXISTS `mydb`.`SessionNote` (
  `NoteID` INT NOT NULL AUTO_INCREMENT,
  `CreatedBy` VARCHAR(45) NOT NULL,
  `Date` DATE NOT NULL,
  `Visibility` TEXT NOT NULL,
  `Counselor_CounselorID` INT NOT NULL,
  `Appointment_AppID` INT NOT NULL,
  PRIMARY KEY (`NoteID`, `Counselor_CounselorID`, `Appointment_AppID`),
  INDEX `fk_SessionNote_Counselor1_idx` (`Counselor_CounselorID` ASC) VISIBLE,
  INDEX `fk_SessionNote_Appointment1_idx` (`Appointment_AppID` ASC) VISIBLE,
  CONSTRAINT `fk_SessionNote_Counselor1`
    FOREIGN KEY (`Counselor_CounselorID`)
    REFERENCES `mydb`.`Counselor` (`CounselorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SessionNote_Appointment1`
    FOREIGN KEY (`Appointment_AppID`)
    REFERENCES `mydb`.`Appointment` (`AppID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PlanDiagnosis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`PlanDiagnosis` ;

CREATE TABLE IF NOT EXISTS `mydb`.`PlanDiagnosis` (
  `TreatmentPlan_PlanID` INT NOT NULL,
  `TreatmentPlan_Client_ClientID` INT NOT NULL,
  `Diagnosis_DiagnosisID` INT NOT NULL,
  PRIMARY KEY (`TreatmentPlan_PlanID`, `TreatmentPlan_Client_ClientID`, `Diagnosis_DiagnosisID`),
  INDEX `fk_TreatmentPlan_has_Diagnosis_Diagnosis1_idx` (`Diagnosis_DiagnosisID` ASC) VISIBLE,
  INDEX `fk_TreatmentPlan_has_Diagnosis_TreatmentPlan1_idx` (`TreatmentPlan_PlanID` ASC, `TreatmentPlan_Client_ClientID` ASC) VISIBLE,
  CONSTRAINT `fk_TreatmentPlan_has_Diagnosis_TreatmentPlan1`
    FOREIGN KEY (`TreatmentPlan_PlanID` , `TreatmentPlan_Client_ClientID`)
    REFERENCES `mydb`.`TreatmentPlan` (`PlanID` , `Client_ClientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TreatmentPlan_has_Diagnosis_Diagnosis1`
    FOREIGN KEY (`Diagnosis_DiagnosisID`)
    REFERENCES `mydb`.`Diagnosis` (`DiagnosisID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ClientInsurance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ClientInsurance` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ClientInsurance` (
  `Client_ClientID` INT NOT NULL,
  `Insurance_InsuranceID` INT NOT NULL,
  `PolicyNumber` VARCHAR(45) NULL,
  PRIMARY KEY (`Client_ClientID`, `Insurance_InsuranceID`),
  INDEX `fk_Client_has_Insurance_Insurance1_idx` (`Insurance_InsuranceID` ASC) VISIBLE,
  INDEX `fk_Client_has_Insurance_Client1_idx` (`Client_ClientID` ASC) VISIBLE,
  CONSTRAINT `fk_Client_has_Insurance_Client1`
    FOREIGN KEY (`Client_ClientID`)
    REFERENCES `mydb`.`Client` (`ClientID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Client_has_Insurance_Insurance1`
    FOREIGN KEY (`Insurance_InsuranceID`)
    REFERENCES `mydb`.`Insurance` (`InsuranceID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
