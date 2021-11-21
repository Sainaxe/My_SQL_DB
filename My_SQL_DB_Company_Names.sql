/* БД "legal_entities" мировых компаний "Единорогов".
 * 
 * Цель:
 * 1. Собрать базу имён компаний которые достигали параметра "Единорог" (рыночная стоимость более 1 млрд. USD после IPO).
 * 2. Обучить нейронную сеть генерировать названия компаний на основе БД "Единорогов".
 * 
 * Структура БД "legal_entities":
 * 1. company_profile - главная таблица, дополнительно содержит контакты компании;
 * 2. founders - данные об основателях (включая часть владения);
 * 3. company_success_parameters - параметры определения "Единорога" (по IPO);
 * 4. company_jurisdiction - юрисдикция (где зарегистрирована компания, приоритетеное право);
 * 5. foundation - данные по дате основания компании и существует ли компания сегодня;
 * 6. employees - количество работников;
 * 7. cash_flow - денежные потоки;
 * 8. logo - хранение логотипов ссылками на внешний ресурс;
 * 9. investors - инвесторы, по сути вторая часть таблицы 2. founders;
 * 10. produce_value - продукт компании (создаваемая ценность).
 * 
 * Триггер: счетчик компаний + дата обновления счетчика.
 * 
 * Функция с применением JOIN: цена компании сегодня за минусом инвестиций (сгенерированная ценность).
 * 
 */

DROP DATABASE IF EXISTS `legal_entities`;
CREATE DATABASE `legal_entities`;
USE `legal_entities`;

DROP TABLE IF EXISTS `company_profile`;
CREATE TABLE `company_profile` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`founders_id` INT UNSIGNED, -- mark
	`company_name` VARCHAR(255), -- mark
	`email` VARCHAR(255) DEFAULT NULL,
	`phone` BIGINT UNSIGNED DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX `founders_id`
ON `company_profile` (`founders_id`);

DROP TABLE IF EXISTS `founders`;
CREATE TABLE `founders` (
	`founder_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`founder_info_updated_at` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	`gender` CHAR(1) DEFAULT NULL,
	`ownership_share` INT DEFAULT NULL,
	`founder_name` VARCHAR(255) DEFAULT NULL,
	`founder_surname` VARCHAR(255) DEFAULT NULL,
	`founder_email` VARCHAR(255) DEFAULT NULL,
	`founder_phone` BIGINT UNSIGNED DEFAULT NULL,
	`hometown` VARCHAR(255) DEFAULT NULL,
	`birthday` DATE DEFAULT NULL,
	PRIMARY KEY (`founder_id`),
	CONSTRAINT `founder_id`
	FOREIGN KEY (`founder_id`) REFERENCES `company_profile` (`founders_id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `company_success_parameters`;
CREATE TABLE `company_success_parameters` (
	`id` INT UNSIGNED NOT NULL UNIQUE, -- mark
	`unicorn` BIT DEFAULT 1,
	`unicorn_at` DATETIME DEFAULT NULL,
	`max_ipo_price` BIGINT UNSIGNED DEFAULT NULL,
	`ipo_at` DATETIME DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `company_success_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `company_jurisdiction`;
CREATE TABLE `company_jurisdiction` (
	`id` INT UNSIGNED NOT NULL UNIQUE, -- mark
	`jurisdiction` VARCHAR(255) DEFAULT NULL,
	`registered_at` DATE DEFAULT NULL,
	`priority_low` VARCHAR(255) DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `company_jurisdiction_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

DROP TABLE IF EXISTS `foundation`;
CREATE TABLE `foundation` (
	`id` INT  UNSIGNED NOT NULL UNIQUE, -- mark
	`is_exists` BIT DEFAULT NULL,
	`check_at_date` DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
	`foundation_date` DATETIME DEFAULT NULL,
	`bankruptcy_date` DATETIME DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `foundation_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
	`id` INT UNSIGNED NOT NULL UNIQUE, -- mark
	`number_of_employees` INT DEFAULT NULL,
	`temporary_employees` INT DEFAULT NULL,
	`regular_employees` INT DEFAULT NULL,
	`at_date` DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	CONSTRAINT `employees_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

DROP TABLE IF EXISTS `cash_flow`;
CREATE TABLE `cash_flow` (
	`id` INT UNSIGNED NOT NULL UNIQUE, -- mark
	`capex` INT DEFAULT NULL,
	`opex` INT DEFAULT NULL,
	`at_date` DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	CONSTRAINT `cash_flow_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;	

DROP TABLE IF EXISTS `logo`;
CREATE TABLE `logo` (
	`id` INT UNSIGNED NOT NULL UNIQUE, -- mark
	`hash` CHAR(32) DEFAULT NULL,
	`file_name` CHAR(255) DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `logo_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;	

DROP TABLE IF EXISTS `investors`;
CREATE TABLE `investors` (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`info_updated_at` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	`gender` CHAR(1) DEFAULT NULL,
	`ownership_share` INT DEFAULT NULL,
	`investor_name` VARCHAR(255) DEFAULT NULL,
	`investor_surname` VARCHAR(255) DEFAULT NULL,
	`investor_email` VARCHAR(255) DEFAULT NULL,
	`investor_phone` BIGINT UNSIGNED DEFAULT NULL,
	`hometown` VARCHAR(255) DEFAULT NULL,
	`birthday` DATE DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `investor_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`founders_id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `produce_value`;
CREATE TABLE `produce_value` (
	`id` INT UNSIGNED NOT NULL UNIQUE, -- mark
	`value_category_servises` BIT DEFAULT 1,
	`value_category_produce` BIT DEFAULT 1,
	`value_discription` VARCHAR(255) DEFAULT NULL,
	`updated_at` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	`servises_quantity_per_year` INT DEFAULT NULL,
	`produce_quantity_per_year` INT DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `value_id`
	FOREIGN KEY (`id`) REFERENCES `company_profile` (`id`)
	ON UPDATE SET DEFAULT
	ON DELETE SET DEFAULT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `company_profile`
ADD `counter` INT DEFAULT NULL;

ALTER TABLE `company_profile`
ADD `updated_at` DATETIME DEFAULT NULL;

-- DATA

INSERT INTO `company_profile`
	(`founders_id`,	`company_name`)
VALUES
	(1, 'Balistreri, Schulist and Denesik'),
	(2, 'Beer-Jast'),
	(3, 'Beier-Zieme'),
	(4, 'Bins, Thiel and Fritsch'),
	(5, 'Crona, Volkman and Cormier'),
	(6, 'Dietrich and Sons'),
	(7, 'Frami-Schumm'),
	(8, 'Huel PLC'),
	(9, 'Jenkins, Pfannerstill and Daniel'),
	(10, 'Kilback, Sanford and Miller');

INSERT INTO `founders`
	(`gender`,	`ownership_share`, `founder_name`)
VALUES
	(1, 100, 'William'),
	(1, 100, 'Dennis'),
	(1, 100, 'Alex'),
	(0, 100, 'Jessica'),
	(0, 100, 'Mary'),
	(1, 100, 'Carl'),
	(1, 100, 'Metthey'),
	(1, 100, 'David'),
	(1, 100, 'Hecter'),
	(0, 100, 'Victory');

INSERT INTO `company_success_parameters`
	(`id`,	`unicorn_at`, `max_ipo_price`)
VALUES
	(1, NOW(), 1911344567),
	(2, NOW(), 1015304566),
	(3, NOW(), 1342986798),
	(4, NOW(), 3259875332),
	(5, NOW(), 2305979233),
	(6, NOW(), 3295732352),
	(7, NOW(), 3928563532),
	(8, NOW(), 9843622224),
	(9, NOW(), 2352346037),
	(10, NOW(), 3253256998);

INSERT INTO `company_jurisdiction`
	(`id`, `jurisdiction`)
VALUES
	(1, 'Swedish law'),
	(2, 'British law'),
	(3, 'British law'),
	(4, 'British law'),
	(5, 'British law'),
	(6, 'Swedish law'),
	(7, 'British law'),
	(8, 'Swedish law'),
	(9, 'British law'),
	(10, 'Swedish law');

INSERT INTO `foundation`
	(`id`, `is_exists`)
VALUES
	(1, 0),
	(2, 0),
	(3, 0),
	(4, 0),
	(5, 0),
	(6, 0),
	(7, 0),
	(8, 0),
	(9, 0),
	(10, 0);

-- TRIGGER

DROP TRIGGER IF EXISTS `add_company_count`;
delimiter //
CREATE TRIGGER `add_company_count` AFTER INSERT ON `company_profile`
FOR EACH ROW BEGIN
BEGIN
	UPDATE `company_profile` SET `company_profile`.`counter`= `company_profile`.`counter`+1 WHERE `company_profile`.id = NEW.`company_profile`.id;
	INSERT INTO `company_profile` (`updated_at`) VALUES (NOW());
END //
delimiter ;

-- FUNCTION

-- REVIEW WELTH AT TODAY
DROP FUNCTION IF EXISTS rate;
DELIMITER //
CREATE FUNCTION rate(r_id INT UNSIGNED)
	RETURNS INT DETERMINISTIC
BEGIN
	RETURN 
		SELECT today.prise - investments.money
			  FROM (
					   SELECT `max_ipo_price` AS prise
						 FROM `company_success_parameters`
					) AS today
					   JOIN (
				  SELECT `ownership_share` AS money
					FROM `investors`
					) AS investments
		   );
END;
//
DELIMITER ;
