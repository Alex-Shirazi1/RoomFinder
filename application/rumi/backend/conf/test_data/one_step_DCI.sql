-- Having some foreign key constraints might prevent you from executing drop table, 
-- so the first thing you should do is to temporarily disable all the foreign key constraints in order for the drop statements work
SET FOREIGN_KEY_CHECKS = 0;

-- Then you list all the available tables from the current database
SELECT
    table_name
FROM
    information_schema.tables
WHERE
    table_schema = 'rumi-db2';

-- And delete all tables on by one from the list
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS favorite;
DROP TABLE IF EXISTS list;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS searchtext;
DROP TABLE IF EXISTS user;

-- And delete all tables on by one from the list
SET FOREIGN_KEY_CHECKS = 1;

-- MySQL Script generated by MySQL Workbench
-- Wed Oct  6 12:49:27 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema rumi-db2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema rumi-db2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rumi-db2` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema rumi
-- -----------------------------------------------------
USE `rumi-db2` ;

-- -----------------------------------------------------
-- Table `rumi-db2`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` CHAR(36) NOT NULL,
  `password` CHAR(36) NOT NULL,
  `last_name` CHAR(255) NULL,
  `first_name` CHAR(255) NULL,
  `email` CHAR(255) NOT NULL,
  `phone` VARCHAR(45) NULL,
  `description` TEXT NULL,
  `gender` CHAR(1) NULL,
  `birthday` DATETIME NULL,
  `school` CHAR(255) NULL,
  `major` CHAR(255) NULL,
  `smoker` INT NULL,
  `pets` INT NULL,
  `language` VARCHAR(255) NULL,
  `interests` VARCHAR(255) NULL,
  `hobbies` VARCHAR(255) NULL,
  `created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted` INT NULL,
  `deleted_date` DATETIME NULL,
  `admin` INT NULL,
  `activated` INT NULL,
  `photo` varchar(2048) DEFAULT NULL,
  `thumbnail` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`list` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `category` CHAR(32) NOT NULL,
  `value` CHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `caption` CHAR(255) NOT NULL,
  `description` TEXT(2048) NULL,
  `photo` VARCHAR(2048) NULL,
  `thumbnail` VARCHAR(2048) NULL,
  `location` INT NOT NULL,
  `price` INT NULL,
  `parking` INT,
  `pet` INT,
  `smoking` INT,
  `gender` CHAR(1), -- N:no preference/F:female/M:male
  `creator_id` INT NOT NULL,
  `created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted` INT NOT NULL,
  `deleted_date` DATETIME NULL,
  `latitude` INT NOT NULL,
  `longitude` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `userid_idx` (`creator_id` ASC) VISIBLE,
  INDEX `locationid_idx` (`location` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `userid`
    FOREIGN KEY (`creator_id`)
    REFERENCES `rumi-db2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `locationid`
    FOREIGN KEY (`location`)
    REFERENCES `rumi-db2`.`list` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` TEXT(2048) NOT NULL,
  `post_id` INT NOT NULL,
  `creator_id` INT NOT NULL,
  `created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted` BIT(1) NULL,
  `deleted_date` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `userid_idx` (`creator_id` ASC) VISIBLE,
  INDEX `postid_idx` (`post_id` ASC) VISIBLE,
  CONSTRAINT `commentuserid`
    FOREIGN KEY (`creator_id`)
    REFERENCES `rumi-db2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `commentpostid`
    FOREIGN KEY (`post_id`)
    REFERENCES `rumi-db2`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`message` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(2048) NOT NULL,
  `from_id` INT NOT NULL,
  `to_id` INT NOT NULL,
  `is_read` INT NOT NULL,
  `creator_id` INT NOT NULL,
  `created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted` INT NULL,
  `deleted_date` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fromid_idx` (`from_id` ASC) VISIBLE,
  INDEX `toid_idx` (`to_id` ASC) VISIBLE,
  CONSTRAINT `fromid`
    FOREIGN KEY (`from_id`)
    REFERENCES `rumi-db2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `toid`
    FOREIGN KEY (`to_id`)
    REFERENCES `rumi-db2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`favorite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`favorite` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `saved_by` INT NOT NULL,
  `saved_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `unsaved` int NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `postid_idx` (`post_id` ASC) VISIBLE,
  INDEX `userid_idx` (`saved_by` ASC) VISIBLE,
  CONSTRAINT `favoritepostid`
    FOREIGN KEY (`post_id`)
    REFERENCES `rumi-db2`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `favoriteuserid`
    FOREIGN KEY (`saved_by`)
    REFERENCES `rumi-db2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`review` (
  `id` INT NOT NULL,
  `text` VARCHAR(2048) NOT NULL,
  `star` INT NOT NULL,
  `post_id` INT NOT NULL,
  `creator_id` INT NOT NULL,
  `created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted` BIT(1) NULL,
  `deleted_date` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `postid_idx` (`post_id` ASC) VISIBLE,
  INDEX `userid_idx` (`creator_id` ASC) VISIBLE,
  CONSTRAINT `reviewpostid`
    FOREIGN KEY (`post_id`)
    REFERENCES `rumi-db2`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `reviewuserid`
    FOREIGN KEY (`creator_id`)
    REFERENCES `rumi-db2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -- -----------------------------------------------------
-- -- Table `rumi-db2`.`notification`
-- -- -----------------------------------------------------
CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `text` varchar(2048) NOT NULL,
  `from_id` int DEFAULT NULL,
  `to_id` int NOT NULL,
  `post_id` int NULL,
  `unread` int NOT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `deleted` int DEFAULT NULL,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fromid_idx` (`from_id`),
  KEY `toid_idx` (`to_id`),
  KEY `postid_idx` (`post_id`),
    CONSTRAINT `notifromid` 
      FOREIGN KEY (`from_id`) 
      REFERENCES `user` (`id`)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    CONSTRAINT `notitoid` 
      FOREIGN KEY (`to_id`) 
      REFERENCES `user` (`id`)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
    CONSTRAINT `notipostid` 
      FOREIGN KEY (`post_id`) 
      REFERENCES `post` (`id`)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rumi-db2`.`searchtext`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rumi-db2`.`searchtext` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` CHAR(255) NOT NULL,
  `frequency` INT NOT NULL,
  `created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted` BIT(1) NULL,
  `deleted_date` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'Daly City');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'San Francisco');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'South San Francisco');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'Berkeley');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'Oakland');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'Alameda');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'San Mateo');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('location',
'San Leandro');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Accounting');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Computer Science');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Finance');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Business Management');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Biology');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Economics');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Chinese');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'English');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Law');

INSERT INTO `rumi-db2`.`list`
(`category`,
`value`)
VALUES
('major',
'Physical Science');

-- user
INSERT INTO `rumi-db2`.`user`
(
`username`,
`password`,
`email`,
`description`,
`gender`,
`school`,
`major`,
`smoker`,
`pets`,
`activated`,
`deleted`)
VALUES
(
'rumi1',
'password',
'rumi1@rumi.com',
'I am normal user',
'F',
'SFSU',
30,
1,
1,
1,
0);

INSERT INTO `rumi-db2`.`user`
(
`username`,
`password`,
`email`,
`description`,
`gender`,
`school`,
`major`,
`smoker`,
`pets`,
`activated`,
`deleted`)
VALUES
(
'rumi2',
'password',
'rumi2@rumi.com',
'I am normal user',
'M',
'SFSU',
31,
0,
1,
1,
0);

INSERT INTO `rumi-db2`.`user`
(
`username`,
`password`,
`email`,
`birthday`,
`activated`,
`admin`,
`deleted`)
VALUES
(
'admin',
'password',
'admin@rumi.com',
current_timestamp(),
1,1,0);


-- post
INSERT INTO `rumi-db2`.`post`
(
`caption`,
`description`,
`price`,
`location`,
`photo`,
`thumbnail`,
`parking`,
`pet`,
`smoking`,
`gender`,
`latitude`,
`longitude`,
`creator_id`,
`deleted`)
VALUES
(
'JTHAVN Joshua Tree Remote Desert Bubble Stargazing',
'Unique desert bubble is located in a private 30 acres lot! ~13 miles from Joshua Tree National Park in Joshua Tree, California!
If you love traveling, camping, uniqueness, nature, adventure and experience the magic of the desert, the bubble is a purposefully designed tent with intentional features to help you maximize your travel experiences. Comfortable, luxurious and right in the middle of the desert. Experience the best of both world.',
1000,
1,
'image1.jpeg',
'thumbnail-image1.jpeg',
0,
1,
1,
'N',
1,1,
2,
0);

INSERT INTO `rumi-db2`.`post`
(
`caption`,
`description`,
`price`,
`location`,
`photo`,
`thumbnail`,
`parking`,
`pet`,
`smoking`,
`gender`,
`latitude`,
`longitude`,
`creator_id`,
`deleted`)
VALUES
(
'Glass cottage with Hot tub "Blár"',
'Welcome to Glass cottages Iceland.

We are located on a lava desert in the south of Iceland. 5 minutes from the small town of Hella, close to all the popular attractions that southern Iceland has to offer, but also in a secret and secluded location.',
800,
2,
'image2.jpeg',
'thumbnail-image2.jpeg',
1,
0,
1,
'F',1,1,
1,
0);

INSERT INTO `rumi-db2`.`post`
(
`caption`,
`description`,
`price`,
`location`,
`photo`,
`thumbnail`,
`parking`,
`pet`,
`smoking`,
`gender`,
`latitude`,
`longitude`,
`creator_id`,
`deleted`)
VALUES
(
'Invisible House Joshua Tree - Skyscraper with Pool',
'Quite simply, Invisible House is the most spectacular house in Joshua Tree. As seen in design and lifestyle publications worldwide, this mirrored 22 story horizontal skyscraper virtually disappears into the vast desert landscape. The luxurious 100-foot indoor swimming pool contrasts with the High Desert surroundings. The 90 acre property has its own 4000ft mountain and shares half a mile border with the National Park.',
900,
3,
'image3.jpeg',
'thumbnail-image3.jpeg',
1,
1,
0,
'M',1,1,
2,
0);
