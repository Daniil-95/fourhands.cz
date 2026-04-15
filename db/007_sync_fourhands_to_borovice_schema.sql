
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


USE `fourhands`;
DROP TABLE IF EXISTS `article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `article_category2articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `tld` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `eu` int NOT NULL DEFAULT '0',
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=250 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documents2tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `images2tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_article_display`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_article_display` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `date` date NOT NULL,
  `display_count` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `year` (`date`),
  KEY `articles_id` (`articles_id`),
  CONSTRAINT `log_article_display_ibfk_3` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_exports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_sent_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_users_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_users_login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `remote_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `remote_host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `log_users_login_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `group` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `file` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `checksum` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_czech_ci NOT NULL,
  `executed` datetime NOT NULL,
  `ready` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_file` (`group`,`file`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mirror_structure_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mirror_structure_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mirror_structure_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partner_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partner_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partner_category2partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `role_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `inherits_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role` (`role`),
  KEY `id_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `search_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `slideshows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slideshows` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `slideshows_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `structure2structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `structure_branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `structure_branches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `shortcut` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `public` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `structure_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `text_snippets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `text_snippets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci NOT NULL,
  `lang` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_lang` (`code`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_roles` (
  `users_id` int NOT NULL,
  `roles_id` int NOT NULL,
  PRIMARY KEY (`users_id`,`roles_id`),
  KEY `IDX_2DE8C6A3A76ED395` (`users_id`),
  KEY `IDX_2DE8C6A3D60322AC` (`roles_id`),
  CONSTRAINT `users_roles_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_roles_ibfk_2` FOREIGN KEY (`roles_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

