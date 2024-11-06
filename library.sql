-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema library
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema library
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `library` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `library` ;

-- -----------------------------------------------------
-- Table `library`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `type` ENUM('admin', 'customer') NOT NULL DEFAULT 'customer',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`admin` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_admin_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_admin_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `library`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`department` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_department_admin1_idx` (`admin_id` ASC),
  CONSTRAINT `fk_department_admin1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `library`.`admin` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`publisher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`publisher` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(200) NULL,
  `phone` VARCHAR(15) NULL,
  `fax` VARCHAR(15) NULL,
  `website` VARCHAR(100) NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_publisher_admin1_idx` (`admin_id` ASC),
  CONSTRAINT `fk_publisher_admin1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `library`.`admin` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`book` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `page_number` INT NULL,
  `price` FLOAT NOT NULL,
  `language` ENUM('Ar', 'En') NULL DEFAULT 'Ar',
  `image` VARCHAR(100) NOT NULL,
  `department_id` INT NOT NULL,
  `publisher_id` INT NOT NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_book_department1_idx` (`department_id` ASC),
  INDEX `fk_book_publisher1_idx` (`publisher_id` ASC),
  INDEX `fk_book_admin1_idx` (`admin_id` ASC),
  CONSTRAINT `fk_book_department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `library`.`department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_publisher1`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `library`.`publisher` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_admin1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `library`.`admin` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`auther`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`auther` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_auther_admin1_idx` (`admin_id` ASC),
  CONSTRAINT `fk_auther_admin1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `library`.`admin` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`book_has_auther`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`book_has_auther` (
  `book_id` INT NOT NULL,
  `auther_id` INT NOT NULL,
  PRIMARY KEY (`book_id`, `auther_id`),
  INDEX `fk_book_has_auther_auther1_idx` (`auther_id` ASC),
  INDEX `fk_book_has_auther_book_idx` (`book_id` ASC),
  CONSTRAINT `fk_book_has_auther_book`
    FOREIGN KEY (`book_id`)
    REFERENCES `library`.`book` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_has_auther_auther1`
    FOREIGN KEY (`auther_id`)
    REFERENCES `library`.`auther` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`customer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `phone` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_customer_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_customer_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `library`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_customer1_idx` (`customer_id` ASC),
  CONSTRAINT `fk_orders_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `library`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `library`.`book_has_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library`.`book_has_orders` (
  `book_id` INT NOT NULL,
  `orders_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `total_cost` FLOAT NULL,
  PRIMARY KEY (`book_id`, `orders_id`),
  INDEX `fk_book_has_orders_orders1_idx` (`orders_id` ASC),
  INDEX `fk_book_has_orders_book1_idx` (`book_id` ASC),
  CONSTRAINT `fk_book_has_orders_book1`
    FOREIGN KEY (`book_id`)
    REFERENCES `library`.`book` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_has_orders_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `library`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
