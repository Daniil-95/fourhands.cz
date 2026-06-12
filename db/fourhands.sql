-- Adminer 5.4.1 MySQL 8.4.7 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `article_category`;
CREATE TABLE `article_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `highlight` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `images_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `article_category_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `article_category2articles`;
CREATE TABLE `article_category2articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `article_category_id` int NOT NULL,
  `articles_id` int NOT NULL,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `article_category_id` (`article_category_id`),
  KEY `articles_id` (`articles_id`),
  CONSTRAINT `article_category2articles_ibfk_1` FOREIGN KEY (`article_category_id`) REFERENCES `article_category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `article_category2articles_ibfk_2` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `introduction` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `user_label` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `images_id` int DEFAULT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `articles2documents`;
CREATE TABLE `articles2documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `documents_id` int NOT NULL,
  `title_override` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle_override` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `documents_id` (`documents_id`),
  CONSTRAINT `articles2documents_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `articles2documents_ibfk_2` FOREIGN KEY (`documents_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `articles2images`;
CREATE TABLE `articles2images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `images_id` int NOT NULL,
  `title_override` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle_override` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `articles2images_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `articles2images_ibfk_2` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `articles2tags`;
CREATE TABLE `articles2tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `tags_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `tags_id` (`tags_id`),
  CONSTRAINT `articles2tags_ibfk_3` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articles2tags_ibfk_4` FOREIGN KEY (`tags_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `articles2users`;
CREATE TABLE `articles2users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `users_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `articles2users_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`),
  CONSTRAINT `articles2users_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `articles2videos`;
CREATE TABLE `articles2videos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `videos_id` int NOT NULL,
  `title_override` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `videos_id` (`videos_id`),
  CONSTRAINT `articles2videos_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `articles2videos_ibfk_2` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `tld` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `eu` int NOT NULL DEFAULT '0',
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `documents2tags`;
CREATE TABLE `documents2tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `documents_id` int NOT NULL,
  `tags_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `documents_id` (`documents_id`),
  KEY `tags_id` (`tags_id`),
  CONSTRAINT `documents2tags_ibfk_1` FOREIGN KEY (`documents_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `documents2tags_ibfk_2` FOREIGN KEY (`tags_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int DEFAULT NULL,
  `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `crop` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `images_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `images` (`id`, `users_id`, `file`, `title`, `subtitle`, `crop`, `created`, `changed`) VALUES
(63,	3,	'images/kids2-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(64,	3,	'images/kids3-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(65,	3,	'images/kids4-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(66,	3,	'images/kids5-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(67,	3,	'images/kids6-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(68,	3,	'images/kids7-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(69,	3,	'images/kids1-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(70,	3,	'images/kids8-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(71,	3,	'images/kids9-thumb.jpg',	'',	'',	0,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17');

DROP TABLE IF EXISTS `images2tags`;
CREATE TABLE `images2tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `images_id` int NOT NULL,
  `tags_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  KEY `tags_id` (`tags_id`),
  CONSTRAINT `images2tags_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `images2tags_ibfk_2` FOREIGN KEY (`tags_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `log_article_display`;
CREATE TABLE `log_article_display` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `date` date NOT NULL,
  `display_count` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `year` (`date`),
  KEY `articles_id` (`articles_id`),
  CONSTRAINT `log_article_display_ibfk_3` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `log_exports`;
CREATE TABLE `log_exports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dataMethod` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `dumpMethod` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `users_id` int NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `log_exports_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `log_sent_email`;
CREATE TABLE `log_sent_email` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `parameter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `users_id` int DEFAULT NULL,
  `recipients` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `log_sent_email_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `log_users_login`;
CREATE TABLE `log_users_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `remote_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `remote_host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `log_users_login_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `log_users_login` (`id`, `users_id`, `remote_ip`, `remote_host`, `timestamp`) VALUES
(11,	3,	'::1',	'fourhands.local',	'2026-04-15 15:39:17'),
(12,	3,	'',	'admin',	'2026-04-15 15:39:23'),
(13,	3,	'::1',	'fourhands.local',	'2026-04-15 15:39:34');

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `group` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `file` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `checksum` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `executed` datetime NOT NULL,
  `ready` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_file` (`group`,`file`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_czech_ci;


DROP TABLE IF EXISTS `mirror_structure_group`;
CREATE TABLE `mirror_structure_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_czech_ci;


DROP TABLE IF EXISTS `mirror_structure_item`;
CREATE TABLE `mirror_structure_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mirror_structure_group_id` int NOT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `structure_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_structure_id` (`lang`,`structure_id`),
  UNIQUE KEY `mirror_structure_group_id_lang` (`mirror_structure_group_id`,`lang`),
  KEY `structure_id` (`structure_id`),
  CONSTRAINT `mirror_structure_item_ibfk_1` FOREIGN KEY (`mirror_structure_group_id`) REFERENCES `mirror_structure_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `mirror_structure_item_ibfk_2` FOREIGN KEY (`structure_id`) REFERENCES `structure` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_czech_ci;


DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `articles_id` int DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `news` (`id`, `title`, `publish_date`, `articles_id`, `lang`, `active`, `created`, `changed`) VALUES
(539,	'17.1.2026 - Knihovna Velké Popovice - Novoroční koncert, v 18 h.',	'2026-01-17 18:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(540,	'10.2.2026 - Bystřice nad Pernštejnem - kulturní dům, v 19 h.',	'2026-02-10 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(541,	'17.2.2026 - Kolín - Městský společenský dům, v 19 h.',	'2026-02-17 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(542,	'23.4.2026 - Vysočanská radnice, v 19 h.',	'2026-04-23 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(543,	'1.10.2026 - Opava.',	'2026-10-01 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(544,	'10.11.2026 - Emauzský klášter - Barokní refektář (spolupráce s agenturou Fidelio), v 18.30 h.',	'2026-11-10 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(545,	'12.11.2025 - Barokní sál Emauzského kláštera - Galakoncert, v 18:30 h. (spolupráce s uměleckou agenturou Fidelio).',	'2025-11-12 18:30:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(546,	'14.9.2025 - Tábor - Divadlo Oskara Nedbala - B. Smetana - Má Vlast, v 19 h.',	'2025-09-14 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(547,	'23.9.2025 - Frenštát pod Radhoštěm - Dům Kultury, v 19h. (spolupráce s uměleckou agenturou GLOBART).',	'2025-09-23 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(548,	'26.7.2025 - Vysoká u Příbramě - Památník A. Dvořáka - Komponovaný pořad \"Tanec v barvě árodní\".',	'2025-07-26 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(549,	'2.4.2025 - Velké Meziříčí - Jupiter Club, v 19 h. (spolupráce s uměleckou agenturou Globart).',	'2025-04-02 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(550,	'21.3.2025 - Rájec - Jestřebí - Kulturní centrum, v 19 h. (spolupráce s uměleckou agenturou Globart).',	'2025-03-21 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(551,	'2.3.2025 - Muzeum Bedřicha Smetany v Praze, v 18 h.',	'2025-03-02 18:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(552,	'4.2.2025 - Přerov - Městský dům, v 19 h. (spolupráce s uměleckou agenturou Globart).',	'2025-02-04 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(553,	'18.1.2025 - Velké Popovice, Knihovna, v 18 h.',	'2025-01-18 18:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(554,	'23.1.2025 - Ostrov, Stará radnice, v 17 h.',	'2025-01-23 17:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(555,	'3.12.2024 - Adventní koncert Libeňský zámeček, v 19 h.',	'2024-12-03 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(556,	'14.11.2024 - Výchovné koncerty Knihovna Velké Popovice.',	'2024-11-14 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(557,	'11.10.2024 - Říčany Babice - Koncert filmové hudby, v 19 h. v Kulturním domě.',	'2024-10-11 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(558,	'8.6.2024 - Liberec - Palác Liebieg, koncert filmové hudby na letní scéně, v 14 h.',	'2024-06-08 14:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(559,	'16.5.2024 - Praha Chodovská tvrz, v 19 h.',	'2024-05-16 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(560,	'4.4.2024 - Praha, ZUŠ Jižní město.',	'2024-04-04 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(561,	'2.3.2024 - Památník A. Dvořáka - Má Vlast - koncert k 200letému výročí narození B. Smetany.',	'2024-03-02 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(562,	'7.3.2024 - Brno Bystrc, v 19h. (spolupráce s uměleckou agenturou GLOBART).',	'2024-03-07 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(563,	'22.2.2024 - Třebíč, v 19h. (spolupráce s uměleckou agenturou GLOBART).',	'2024-02-22 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(564,	'15.2.2024 - Vyškov, v 19h. (spolupráce s uměleckou agenturou GLOBART).',	'2024-02-15 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(565,	'20.1.2024 - Knihovna V. Popovice, v 19h. Novoroční koncert: Slavné klasické a filmové melodie.',	'2024-01-20 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(566,	'7.12.2023 - Výchovné koncerty knihovna V. Popovice.',	'2023-12-07 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(567,	'8.11.2023 - Říčany Babice - KD.',	'2023-11-08 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(568,	'1.11.2023 - Kostel sv. Vavřince pod Petřínem - B. Smetana “Má vlast”.',	'2023-11-01 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(569,	'28.4.2023 - Chodovská tvrz “Tance v Proměnách”.',	'2023-04-28 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(570,	'27.4.2023 - Vzorná knihovna Velké Popovice - Výchovné koncerty “Pohádkové balety”.',	'2023-04-27 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(571,	'7.1.2023 - “Tance v hudbě s projekci” Atrium na Žižkově.',	'2023-01-07 19:00:00',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(572,	'12.2022 - Vzorná lidová knihovna Velké Popovice.',	'2026-04-15 16:02:17',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(573,	'12.2022 - Výchovné koncerty - P. I. Čajkovskij -Louskáček.',	'2026-04-15 16:02:17',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(574,	'6.2022 - Ostravská univerzita/fakulta umění - Katedra klávesových nástrojů “S tancem kolem světa“.',	'2026-04-15 16:02:17',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(575,	'5.2022 - Atrium na Žižkově.',	'2026-04-15 16:02:17',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(576,	'3.2022 - Praha, ZUŠ Jižní město.',	'2026-04-15 16:02:17',	NULL,	'cs',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(577,	'17.1.2026 – Knihovna Velké Popovice – New Year’s Concert, 18:00.',	'2026-01-17 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(578,	'10.2.2026 – Bystřice nad Pernštejnem – Cultural centre, 19:00.',	'2026-02-10 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(579,	'17.2.2026 – Kolín – Municipal Social House, 19:00.',	'2026-02-17 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(580,	'23.4.2026 – Vysočany Town Hall, 19:00.',	'2026-04-23 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(581,	'1.10.2026 – Opava.',	'2026-10-01 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(582,	'10.11.2026 – Emmaus Monastery – Baroque Refectory (in cooperation with agency Fidelio), 18:30.',	'2026-11-10 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(583,	'12.11.2025 – Baroque Hall of the Emmaus Monastery – Gala concert, 18:30 (in cooperation with agency Fidelio).',	'2025-11-12 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(584,	'14.9.2025 – Tábor – Oskar Nedbal Theatre – B. Smetana – Má vlast, 19:00.',	'2025-09-14 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(585,	'23.9.2025 – Frenštát pod Radhoštěm – House of Culture, 19:00 (in cooperation with agency GLOBART).',	'2025-09-23 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(586,	'26.7.2025 – Vysoká u Příbramě – Antonín Dvořák Memorial – Programme “Dance in National Colours”.',	'2025-07-26 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(587,	'2.4.2025 – Velké Meziříčí – Jupiter Club, 19:00 (in cooperation with agency Globart).',	'2025-04-02 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(588,	'21.3.2025 – Rájec-Jestřebí – Cultural Centre, 19:00 (in cooperation with agency Globart).',	'2025-03-21 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(589,	'2.3.2025 – Bedřich Smetana Museum, Prague, 18:00.',	'2025-03-02 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(590,	'4.2.2025 – Přerov – Municipal House, 19:00 (in cooperation with agency Globart).',	'2025-02-04 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(591,	'18.1.2025 – Velké Popovice, Library, 18:00.',	'2025-01-18 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(592,	'23.1.2025 – Ostrov, Old Town Hall, 17:00.',	'2025-01-23 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(593,	'3.12.2024 – Advent concert, Libeň Chateau, 19:00.',	'2024-12-03 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(594,	'14.11.2024 – Educational concerts, Library Velké Popovice.',	'2024-11-14 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(595,	'11.10.2024 – Říčany Babice – Concert of film music, 19:00, Cultural House.',	'2024-10-11 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(596,	'8.6.2024 – Liberec – Liebieg Palace, concert of film music on the summer stage, 14:00.',	'2024-06-08 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(597,	'16.5.2024 – Prague, Chodovská tvrz, 19:00.',	'2024-05-16 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(598,	'4.4.2024 – Prague, Primary Art School Jižní Město.',	'2024-04-04 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(599,	'2.3.2024 – Antonín Dvořák Memorial – Má vlast – concert for the 200th anniversary of B. Smetana’s birth.',	'2024-03-02 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(600,	'7.3.2024 – Brno-Bystrc, 19:00 (in cooperation with agency GLOBART).',	'2024-03-07 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(601,	'22.2.2024 – Třebíč, 19:00 (in cooperation with agency GLOBART).',	'2024-02-22 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(602,	'15.2.2024 – Vyškov, 19:00 (in cooperation with agency GLOBART).',	'2024-02-15 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(603,	'20.1.2024 – Library Velké Popovice, 19:00 – New Year’s concert: Famous classical and film melodies.',	'2024-01-20 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(604,	'7.12.2023 – Educational concerts, Library Velké Popovice.',	'2023-12-07 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(605,	'8.11.2023 – Říčany Babice – Cultural House.',	'2023-11-08 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(606,	'1.11.2023 – Church of St. Lawrence under Petřín – B. Smetana “Má vlast”.',	'2023-11-01 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(607,	'28.4.2023 – Chodovská tvrz – “Dances in Transformation”.',	'2023-04-28 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(608,	'27.4.2023 – Library Velké Popovice – Educational concerts “Fairytale Ballets”.',	'2023-04-27 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(609,	'7.1.2023 – “Dances in Music with Projection”, Atrium Žižkov.',	'2023-01-07 19:00:00',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(610,	'12.2022 – Library Velké Popovice.',	'2026-04-15 16:02:17',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(611,	'12.2022 – Educational concerts – P. I. Tchaikovsky – The Nutcracker.',	'2026-04-15 16:02:17',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(612,	'6.2022 – University of Ostrava / Faculty of Fine Arts – Department of Keyboard Instruments – “Dancing Around the World”.',	'2026-04-15 16:02:17',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(613,	'5.2022 – Atrium Žižkov.',	'2026-04-15 16:02:17',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(614,	'3.2022 – Prague, Primary Art School Jižní Město.',	'2026-04-15 16:02:17',	NULL,	'en',	1,	'2026-04-15 18:02:17',	'2026-04-15 16:02:17');

DROP TABLE IF EXISTS `partner_category`;
CREATE TABLE `partner_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `partner_category2partners`;
CREATE TABLE `partner_category2partners` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partner_category_id` int NOT NULL,
  `partners_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `partner_category_id` (`partner_category_id`),
  KEY `partners_id` (`partners_id`),
  CONSTRAINT `partner_category2partners_ibfk_1` FOREIGN KEY (`partner_category_id`) REFERENCES `partner_category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `partner_category2partners_ibfk_2` FOREIGN KEY (`partners_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `partners`;
CREATE TABLE `partners` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `images_id` int DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `partners_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `role_privileges`;
CREATE TABLE `role_privileges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `resource` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `privilege` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `deny` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `privilege` (`privilege`),
  KEY `role` (`role`),
  CONSTRAINT `role_privileges_ibfk_5` FOREIGN KEY (`role`) REFERENCES `roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `inherits_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role` (`role`),
  KEY `id_order` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `roles` (`id`, `role`, `description`, `inherits_from`, `order`) VALUES
(6,	'admin',	'Administrator',	NULL,	1);

DROP TABLE IF EXISTS `search_index`;
CREATE TABLE `search_index` (
  `id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `keywords` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `html_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `update` int NOT NULL DEFAULT '0',
  `priority` decimal(1,1) NOT NULL DEFAULT '0.0',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `slideshows`;
CREATE TABLE `slideshows` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `slideshows_slides`;
CREATE TABLE `slideshows_slides` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slideshows_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `videos_id` int DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  KEY `slideshows_id` (`slideshows_id`),
  KEY `videos_id` (`videos_id`),
  CONSTRAINT `slideshows_slides_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `slideshows_slides_ibfk_2` FOREIGN KEY (`slideshows_id`) REFERENCES `slideshows` (`id`) ON DELETE CASCADE,
  CONSTRAINT `slideshows_slides_ibfk_3` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `structure`;
CREATE TABLE `structure` (
  `id` int NOT NULL AUTO_INCREMENT,
  `structure_branches_id` int NOT NULL,
  `parent` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `link_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link_append` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `presenter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `redirect` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `css_class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `show_submenu` int NOT NULL DEFAULT '0',
  `show_subordinate` int NOT NULL DEFAULT '0',
  `seo_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seo_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seo_keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `branch` (`structure_branches_id`),
  KEY `images_id` (`images_id`),
  KEY `parent` (`parent`),
  CONSTRAINT `structure_ibfk_2` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `structure_ibfk_3` FOREIGN KEY (`structure_branches_id`) REFERENCES `structure_branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `structure_ibfk_4` FOREIGN KEY (`parent`) REFERENCES `structure` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `structure2structure`;
CREATE TABLE `structure2structure` (
  `id` int NOT NULL AUTO_INCREMENT,
  `structure_id` int NOT NULL,
  `target_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `structure_id` (`structure_id`),
  KEY `target_id` (`target_id`),
  CONSTRAINT `structure2structure_ibfk_1` FOREIGN KEY (`structure_id`) REFERENCES `structure` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `structure2structure_ibfk_2` FOREIGN KEY (`target_id`) REFERENCES `structure` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `structure_branches`;
CREATE TABLE `structure_branches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `shortcut` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `public` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `structure_components`;
CREATE TABLE `structure_components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `structure_id` int NOT NULL,
  `block` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `create_parameters` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `structure_id` (`structure_id`),
  CONSTRAINT `structure_components_ibfk_2` FOREIGN KEY (`structure_id`) REFERENCES `structure` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `text_snippets`;
CREATE TABLE `text_snippets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_lang` (`code`,`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `text_snippets` (`id`, `code`, `lang`, `content`, `created`, `changed`) VALUES
(52,	'about',	'cs',	'<p>Členky klavírního dua Fourhands započaly spolupráci na podzim roku 2021 při přípravě\n                                            adventního koncertu. Jejich první společnou skladbou byla svita z baletu Louskáček a\n                                            následně přišla myšlenka program rozšířit o další baletní hudbu tak, aby koncerty\n                                            s názvem Pohádkové balety byly tématické. Společně absolvovaly již řadu koncertů a svůj repertoár\n                                            mimo čtyřručních standartů rády rozšiřují o další hudební žánry.\n                                        </p>\n\n                                        <p>V současné době pořádají koncerty zaměřené především na díla předních českých mistrů\n                                            jako například Dvořákovy Slovanské tance, celý Smetanův cyklus Má vlast, dále pak\n                                            jazzové skladby soudobých českých autorů, úpravy orchestrálních a symfonických děl a filmovou\n                                            hudbu. Pořádají také výchovné koncerty pro školy. Kromě čtyřruční hry zařazují do\n                                            repertoáru i skladby pro dva klavíry. V rámci koncertů a projektů spolupracují mj.\n                                            s uměleckou agenturou Globarts a Fidelio, skladatelem Zdeňkem Králem.\n                                        </p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(53,	'about',	'en',	'<p>The members of the piano duo Fourhands started working together in the autumn of 2021\n                                        while preparing an Advent concert. Their first piece together was a suite from Tchaikovsky’s\n                                        ballet <em>The Nutcracker</em>, and soon the idea arose to expand the programme with other\n                                        ballet music so that the concerts under the title “Fairytale Ballets” would form a themed\n                                        whole. Since then, they have played numerous concerts together and, besides four-hand\n                                        standards, they enjoy broadening their repertoire with other musical genres.\n                                    </p>\n\n                                    <p>At present they organise concerts focused mainly on works by leading Czech composers,\n                                        such as Dvořák’s <em>Slavonic Dances</em> and the complete cycle <em>Má vlast</em> by Bedřich\n                                        Smetana. They also perform jazz pieces by contemporary Czech composers, arrangements of\n                                        orchestral and symphonic works and film music. They give educational concerts for schools as\n                                        well. In addition to four-hand piano music they also include compositions for two pianos.\n                                        As part of their concerts and projects they cooperate, among others, with the artist\n                                        agencies Globarts and Fidelio and with the composer Zdeněk Král.\n                                    </p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(54,	'performances',	'cs',	'',	'2026-04-15 17:48:00',	'2026-04-15 15:48:00'),
(55,	'performances',	'en',	'',	'2026-04-15 17:48:00',	'2026-04-15 15:48:00'),
(56,	'artist_katerina',	'cs',	'<p>\n                                                Kateřina Konopová (roz. Turková) je rodačka z Opavy, kde navštěvovala místní\n                                                ZUŠ pod vedením Mgr. Oriany Šenfeldové. Dále absolvovala Janáčkovu\n                                                konzervatoř v Ostravě a Institut pro umělecká studia Ostravské univerzity\n                                                pod vedením profesorky Marty Toaderové.\n                                            </p><p>\n                                                Poté úspěšně ukončila doktorandské studium na VŠMU v Bratislavě pod vedením\n                                                profesora Stanislava Zamborského, kde se podrobněji zabývala tvorbou\n                                                Bohuslava Martinů.\n                                            </p><p>\n                                                Je laureátkou několika mezinárodních soutěží – 1. cenu v sólové hře získala\n                                                na soutěži Art-duo Competition v Praze (2018), dále 2. cenu v sólové hře na\n                                                International Master Competition ve Varšavě (2019 a 2022) a 1. cenu v\n                                                Art-duo Competition v Barceloně (2019).\n                                            </p><p>\n                                                V roce 2005 získala 2. cenu na The First Henri Selmer Bass Clarinet\n                                                Competition v Rotterdamu v duu spolu s basklarinetistou Jiřím Porubiakem.\n                                                Jako klavírní duo získali spolu s Miroslavem Míčem v roce 2019 Grand Prix na\n                                                mezinárodní soutěži ve Varšavě a první cenu na mezinárodní soutěži v\n                                                Barceloně. V témže roce také podnikli koncertní turné na Taiwanu pod\n                                                záštitou Ministerstva zahraničních věcí.\n                                            </p><p>\n                                                Pedagogicky působila na Fakultě umění Ostravské univerzity a na Janáčkově\n                                                konzervatoři v Ostravě. V současné době se věnuje jak koncertní sólové hře,\n                                                tak i interpretaci komorní hudby a je vyhledávanou korepetitorkou. Od roku\n                                                2014 spolupracuje s Pražskou Kantilénou.\n                                            </p><p>\n                                                Nadále se také úspěšně věnuje pedagogické činnosti a působí jako\n                                                korepetitorka na konzervatoři Jaroslava Ježka v Praze.\n                                            </p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(57,	'artist_katerina',	'en',	'<p>\n                                            She studied at the Janáček Conservatoire in Ostrava and graduated from the\n                                            Institute for Artistic Studies (today Faculty of Arts) of the University of\n                                            Ostrava under the guidance of professor Marta Toaderová. After that she\n                                            success fully completed her postgraduante studies at VŠMU (Academy of\n                                            Performing Arts) in Bratislava, under the guidance of professor Stanislav\n                                            Zamborský. Here she focused in detail on the work of Bohuslav Martinů.\n                                        </p><p>\n                                            She has won several awards in international competitions–she was awarded\n                                            first prize for her solo performance in the Art-duo Competition (2018),\n                                            second prize again for her solo performance, this time in the International\n                                            Master Competition in Warsaw (2019) and first prize in Art-duo Competition\n                                            in Barcelona. As a piano duo with Miroslav Míč, The Grand Prix award from\n                                            the International Master Competition in Warsaw and first prize in the\n                                            International Competition in Barcelona, both held in 2019, can be regarded\n                                            as their biggest joint succes so far.\n                                        </p><p>\n                                            Besides, in autumn 2019, they gave as a piano duo a series of concerts in\n                                            Taiwan, where they were invited on the occasion of celebrations relating to\n                                            the anniversary of the birth of Czechoslovakia, organized by the Ministry of\n                                            foreign Affairs of the Czech Republic.\n                                            In 2005, she was presented second prize in The First Henri Selmer Bass\n                                            Clarinet Competition in Rotterdam for a duo performance along with the bass\n                                            clarinetist Jiří Porubiak. In addition, she has received free awards in\n                                            competitions with wind instruments and with the Pražská kantiléna choir for\n                                            outstanding piano accompaniment.\n                                        </p><p>\n                                            She has attended several international master piano courses. As an orchestra\n                                            player, she has been cooperating with the Janáček Philharmonic Ostrava.\n                                            Several times, she even performed with them as a soloist. She was teaching\n                                            at the Faculty of Arts of the University of Ostrava and at the Janáček\n                                            Conservatoire in Ostrava. At present, she is not only a concert soloist, she\n                                            also dedicates herself to interpretations of chamber music and is a much\n                                            sought-after accompanist. She enjoys cooperating with the Pražská Kantiléna\n                                            choir. She has also been cooperating several times as an accompanist in\n                                            International clarinet xcourses in Ostrava.\n                                            Apart from all that, she success fully pursues her teaching aktivity at\n                                            Conservatory Jaroslav Ježek in Prague.\n                                        </p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(58,	'artist_irena',	'cs',	'<p>\n                                                Irena Andruško (roz. Irina Čerkašina) začala studovat hru na klavír v šesti\n                                                letech ve třídě N. Avramenko na Střední odborné hudební škole v Charkově. Od\n                                                počátku se zúčastňovala mezinárodních soutěží, koncertů a festivalů na\n                                                Ukrajině i v zahraničí a vystoupila několikrát s orchestrem Charkovské\n                                                filharmonie.\n                                            </p><p>\n                                                V roce 2003 získala III. cenu v klavírním duu v soutěži „Návštěva u\n                                                Ajvazovského“ (Ukrajina). O rok později získala II. cenu v Mezinárodní\n                                                soutěži Virtuosi per musica di pianoforte v Ústí nad Labem. Významnou pro ni\n                                                byla také II. cena v soutěži J. Poljanského v kategorii komorní soubory\n                                                (Ukrajina) v roce 2006 a II. cena v Mezinárodní soutěži Virtuosi per musica\n                                                di pianoforte v Ústí nad Labem v roce 2009.\n                                            </p><p>\n                                                V letech 2012–2017 byla studentkou Pražské konzervatoře ve třídě Milana\n                                                Langera. V roce 2016 získala III. cenu na Mezinárodní soutěži Z. Fibicha v\n                                                interpretaci melodramů a II. cenu na XXXIX. Soutěžní přehlídce konzervatoří\n                                                a hudebních gymnázií ČR.\n                                            </p><p>\n                                                Aktivně se zúčastnila klavírních kurzů pod vedením významných pianistů –\n                                                prof. Bernd Goetzke (Německo), prof. Milan Langer, prof. Michal Rezek, prof.\n                                                Martin Kasík, Denis Severin (Švýcarsko – komorní hra), prof. Marcin\n                                                Sieniawski (Německo – komorní hra), prof. Viktor Goldberg (Izrael), prof.\n                                                Maria Samson-Primachenko (Rusko–Francie) a dalších.\n                                            </p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(59,	'artist_irena',	'en',	'<p>\n                                            Irena Andruško (born Irina Čerkašina) began studying piano at the age of six\n                                            in the class of N. Avramenko at the Central Professional Music School in\n                                            Kharkov. From the beginning, she participated in international competitions,\n                                            concerts and festivals in Ukraine and abroad, and performed several times\n                                            with the Kharkov Philharmonic Orchestra.\n                                        </p><p>\n                                            In 2003, she received the 1st prize in the piano duo competition “A Visit to\n                                            Ajvazovsky” (Ukraine). A year later she won 1st prize in the International\n                                            Virtuosi per musica di pianoforte competition in Ústí nad Labem. Also\n                                            significant for her was the 2nd prize in the J. Poljansky Competition in the\n                                            chamber ensembles category (Ukraine) in 2006, and the 2nd prize in the\n                                            International Virtuosi per musica di pianoforte competition in Ústí nad\n                                            Labem in 2009.\n                                        </p><p>\n                                            In the years 2012–2017 she was a student at the Prague Conservatory in the\n                                            class of Milan Langer. In 2016 she won 2nd prize at the International Z.\n                                            Fibich Competition in Melodrama Interpretation and 2nd prize at the XXXIXth\n                                            Competition of Conservatories and Music Gymnasiums of the Czech Republic.\n                                        </p><p>\n                                            She actively participated in piano courses under the guidance of prominent\n                                            pianists — prof. Bernd Goetzke (Germany), prof. Milan Langer, prof. Michal\n                                            Rezek, prof. Martin Kasík, Denis Severin (Switzerland — chamber music),\n                                            prof. Marcin Sieniawski (Germany — chamber music), prof. Viktor Goldberg\n                                            (Israel), prof. Maria Samson-Primachenko (Russia–France) and others.\n                                        </p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(60,	'program',	'cs',	'<span>Nabízíme tato hudební pásma:</span>\n\n                                            <p>B. Smetana - Má vlast</p>\n                                            <p>Pocta českým mistrům - díla A. Dvořáka, B. Smetany, Z. Fibicha, K.\n                                                Slavického, E. Hradeckého\n                                            </p>\n                                            <p>Pohádkové balety - hudba z baletů P. I. Čajkovského, M. de Fally, S.\n                                                Prokofjeva doprovázená\n                                                projekcí</p>\n                                            <p>Tanec v proměnách - A. Dvořák - Slovanské tance, J. Turína - Španělské tance,\n                                                F. Chopin -\n                                                Valčíky, Polonézy,\n                                                E. Hradecký - Jazzové taneční skladby apod.</p>\n                                            <p>Filmová hudba, možná v kombinaci s výše uvedeným programem.</p>\n                                            <p>Jazzová hudba, možná v kombinaci s bicími nástroji.</p>\n                                            <p>Podoba orchestru v klavíru - úpravy symfonických a orchestrálních skladeb (W.\n                                                A. Mozart - předehry k operám, A. Dvořák - Novosvětská symfonie, G.\n                                                Gershwin- Porgy and Bess, Rhapsodie v modrém).</p>\n                                            <p>\"Tanec v barvě národní\" - komponovaný pořad. (Tance Dvořáka, Griega,\n                                                Brahmse)</p>\n                                            <p>\"Příběhy a pověsti v hudbě české\" (Dvořák - Legendy, Suk - Radúz a Mahulena,\n                                                Smetana Má Vlast - výběr)</p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(61,	'program',	'en',	'<span>We offer the following concert programmes:</span>\n\n                                        <p>B. Smetana – <em>Má vlast</em></p>\n                                        <p>Homage to Czech Masters – works by A. Dvořák, B. Smetana, Z. Fibich,\n                                            K. Slavický, E. Hradecký.</p>\n                                        <p>Fairytale Ballets – music from ballets by P. I. Tchaikovsky, M. de Falla,\n                                            S. Prokofiev, accompanied by projection.</p>\n                                        <p>Dance in Transformation – A. Dvořák – <em>Slavonic Dances</em>, J. Turina –\n                                            <em>Spanish Dances</em>, F. Chopin – Waltzes and Polonaises, E. Hradecký –\n                                            Jazz dance pieces, etc.</p>\n                                        <p>Film music, possibly in combination with the programmes above.</p>\n                                        <p>Jazz music, possibly in combination with percussion.</p>\n                                        <p>The Sound of the Orchestra in the Piano – arrangements of symphonic and\n                                            orchestral works (W. A. Mozart – opera overtures, A. Dvořák –\n                                            <em>New World Symphony</em>, G. Gershwin – <em>Porgy and Bess</em>,\n                                            <em>Rhapsody in Blue</em>).</p>\n                                        <p>“Dance in National Colours” – a themed programme (dances by Dvořák, Grieg,\n                                            Brahms).</p>\n                                        <p>“Stories and Legends in Czech Music” (Dvořák – <em>Legends</em>,\n                                            Suk – <em>Radúz and Mahulena</em>, Smetana – selections from <em>Má vlast</em>).</p>',	'2026-04-15 17:48:00',	'2026-04-15 16:00:06'),
(62,	'contacts',	'cs',	'',	'2026-04-15 17:48:00',	'2026-04-15 15:52:36'),
(63,	'contacts',	'en',	'',	'2026-04-15 17:48:00',	'2026-04-15 15:52:36'),
(64,	'copyright',	'cs',	'Copyright 2025 Four hands. Všechna práva vyhrazena.<br>Grafický návrh vytvořil a nakódoval Daniil A.',	'2026-04-15 17:48:00',	'2026-04-15 15:58:09'),
(65,	'copyright',	'en',	'Copyright 2025 Fourhands. All rights reserved.<br>Graphic design and coding by Daniil A.',	'2026-04-15 17:48:00',	'2026-04-15 15:58:09');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `surname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `initials` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `activation_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `activation_timestamp` datetime DEFAULT NULL,
  `reset_password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `reset_password_timestamp` datetime DEFAULT NULL,
  `registration_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `users` (`id`, `username`, `password`, `name`, `surname`, `initials`, `active`, `activation_hash`, `activation_timestamp`, `reset_password_hash`, `reset_password_timestamp`, `registration_date`) VALUES
(3,	'admin',	'$2y$10$6oExV99udm0jM1wWnf94mO9Z32hVztwMo6Wk7Xk87FjWYF/4Pq10a',	'Admin',	'User',	'AD',	1,	NULL,	NULL,	NULL,	NULL,	'2026-04-15 17:39:14');

DROP TABLE IF EXISTS `users_data`;
CREATE TABLE `users_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `author` int NOT NULL DEFAULT '0',
  `title_before` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title_after` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `cellphone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `telephone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `street` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `building_identification_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `zip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  `occupation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `company_registration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `vat_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `mailing_consent` int NOT NULL DEFAULT '0',
  `default_page_admin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_id_unique` (`users_id`),
  KEY `users_id` (`users_id`),
  KEY `country_id` (`country_id`),
  CONSTRAINT `users_data_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users_data_ibfk_3` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;


DROP TABLE IF EXISTS `users_roles`;
CREATE TABLE `users_roles` (
  `users_id` int NOT NULL,
  `roles_id` int NOT NULL,
  PRIMARY KEY (`users_id`,`roles_id`),
  KEY `IDX_2DE8C6A3A76ED395` (`users_id`),
  KEY `IDX_2DE8C6A3D60322AC` (`roles_id`),
  CONSTRAINT `users_roles_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_roles_ibfk_2` FOREIGN KEY (`roles_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `users_roles` (`users_id`, `roles_id`) VALUES
(3,	6);

DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `embed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `ratio` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO `videos` (`id`, `users_id`, `title`, `file`, `embed`, `ratio`, `created`, `changed`) VALUES
(153,	3,	'Bedřich Smetana - Má vlast (v jedné minutě)',	'https://www.facebook.com/reel/941975404240005',	'https://www.facebook.com/reel/941975404240005',	'images/kids3-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(154,	3,	'P. I.Čajkovskij Labutí jezero: Předehra',	'https://youtu.be/65J5ta7K_a8',	'https://youtu.be/65J5ta7K_a8',	'images/kids4-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(155,	3,	'Aram Chačaturjan - Šavlový tanec',	'https://youtu.be/ZUR0WTwmEgU',	'https://youtu.be/ZUR0WTwmEgU',	'images/kids3-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(156,	3,	'P. I. Čajkovskij - Louskáček (Tanec cukrové víly)',	'https://www.youtube.com/watch?v=uKAC7z6m65g',	'https://www.youtube.com/watch?v=uKAC7z6m65g',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(157,	3,	'Slovanský tanec Č. 1 C dur Presto (Furiant), I. řada (op. 46)',	'https://www.youtube.com/watch?v=Di0srOkj2b4',	'https://www.youtube.com/watch?v=Di0srOkj2b4',	'images/kids3-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(158,	3,	'Slovanský tanec Č. 2 e moll Allegretto scherzando (Dumka), I. řada (op. 46)',	'https://www.youtube.com/watch?v=IZKmkxSB0Rg',	'https://www.youtube.com/watch?v=IZKmkxSB0Rg',	'images/kids4-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(159,	3,	'Slovanský tanecČ. 5 A dur Allegro vivace (Skočná), I. řada (op.46)',	'https://www.youtube.com/watch?v=Jv5hB-_lgtM',	'https://www.youtube.com/watch?v=Jv5hB-_lgtM',	'images/kids3-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(160,	3,	'Slovanský tanec Č. 7 c moll Allegro assai (Skočná), I. řada (op.46)',	'https://www.youtube.com/watch?v=y6A9lVS71UY',	'https://www.youtube.com/watch?v=y6A9lVS71UY',	'images/kids4-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(161,	3,	'Slovanský tanec Č. 8 g moll Presto (Furiant), I. řada (op. 46)',	'https://www.youtube.com/watch?v=AUAlcoFSTD0',	'https://www.youtube.com/watch?v=AUAlcoFSTD0',	'images/kids3-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(162,	3,	'Bedřich Smetana - Má vlast: Tábor',	'https://www.youtube.com/watch?v=QjhJf8f-UvA',	'https://www.youtube.com/watch?v=QjhJf8f-UvA',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(163,	3,	'Bedřich Smetana - Má vlast: Z českých luhů a hájů',	'https://www.youtube.com/watch?v=LzugaT-BlyE',	'https://www.youtube.com/watch?v=LzugaT-BlyE',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(164,	3,	'Bedřich Smetana - Má vlast : Šárka',	'https://www.youtube.com/watch?v=sUJlL1Amz-4',	'https://www.youtube.com/watch?v=sUJlL1Amz-4',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(165,	3,	'Bedřich Smetana - Má vlast: Vltava',	'https://www.youtube.com/watch?v=kPcXeCDpgvA',	'https://www.youtube.com/watch?v=kPcXeCDpgvA',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(166,	3,	'Bedřich Smetana - Má vlast: Blaník',	'https://youtu.be/gpFoNt3N4oo',	'https://youtu.be/gpFoNt3N4oo',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17'),
(167,	3,	'Bedřich Smetana - Má vlast: Vyšehrad',	'https://www.youtube.com/watch?v=i22GyhUMFdQ',	'https://www.youtube.com/watch?v=i22GyhUMFdQ',	'images/kids2-thumb.jpg',	'2026-04-15 18:02:17',	'2026-04-15 16:02:17');

-- 2026-04-15 16:06:21 UTC
