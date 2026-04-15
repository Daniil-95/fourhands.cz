
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
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seo` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `class` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `highlight` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `images_id` int DEFAULT NULL,
  `parent` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  KEY `parent` (`parent`),
  CONSTRAINT `article_category_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `article_category_ibfk_2` FOREIGN KEY (`parent`) REFERENCES `article_category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=53904 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `article_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_rating` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `users_id` int NOT NULL,
  `rating` int NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `article_rating_ibfk_3` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `article_rating_ibfk_4` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=265478 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `no_feed` tinyint NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `introduction` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `user_label` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_czech_ci,
  `image` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `image_title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `source` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` varchar(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `approved_date` datetime DEFAULT NULL,
  `approved_date_centrum` datetime DEFAULT NULL,
  `approved_date_drbna` datetime DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `suppress` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `discussion_hidden` tinyint(1) NOT NULL DEFAULT '0',
  `discussion_disabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `articles_ibfk_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles2documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `documents_id` int NOT NULL,
  `title_override` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle_override` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `documents_id` (`documents_id`),
  CONSTRAINT `articles2documents_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `articles2documents_ibfk_2` FOREIGN KEY (`documents_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles2images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `images_id` int NOT NULL,
  `title_override` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle_override` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `articles2images_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `articles2images_ibfk_2` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=193181 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=52354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=44406 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles2videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles2videos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `videos_id` int NOT NULL,
  `title_override` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  KEY `videos_id` (`videos_id`),
  CONSTRAINT `articles2videos_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `articles2videos_ibfk_2` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `articles_drbna`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles_drbna` (
  `id` int NOT NULL AUTO_INCREMENT,
  `no_feed` tinyint NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `publish_date` datetime DEFAULT NULL,
  `approved_date` datetime DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `suppress` int NOT NULL DEFAULT '0',
  `link` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `perex` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_czech_ci,
  `image` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `image_title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` varchar(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `articles_drbna_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `banner_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner_positions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `width` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seznam_feed` int NOT NULL DEFAULT '0',
  `seznam_zone` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `code` text COLLATE utf8mb4_czech_ci,
  `type` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `active` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chat_online`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_online` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `chat_topics_id` int NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `chat_topics_id` (`chat_topics_id`),
  CONSTRAINT `chat_online_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_online_ibfk_2` FOREIGN KEY (`chat_topics_id`) REFERENCES `chat_topics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chat_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_topics_id` int NOT NULL,
  `users_id` int NOT NULL,
  `text` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `parent_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_topics_id` (`chat_topics_id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `chat_posts_ibfk_1` FOREIGN KEY (`chat_topics_id`) REFERENCES `chat_topics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_posts_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=701996 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chat_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  `public` int NOT NULL DEFAULT '1',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `consultancy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultancy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `images_id` int DEFAULT NULL,
  `images_id_2` int DEFAULT NULL,
  `open` int NOT NULL DEFAULT '1',
  `email` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '0',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  KEY `images_id_2` (`images_id_2`),
  CONSTRAINT `consultancy_images_id_2_fk` FOREIGN KEY (`images_id_2`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_consultancy_images` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `consultancy_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultancy_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `consultancy_id` int NOT NULL,
  `users_id` int DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `question` longtext COLLATE utf8mb4_czech_ci,
  `answer` longtext COLLATE utf8mb4_czech_ci,
  `publish` int NOT NULL DEFAULT '0',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `consultancy_id` (`consultancy_id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `consultancy_questions_ibfk_1` FOREIGN KEY (`consultancy_id`) REFERENCES `consultancy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `consultancy_questions_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1063 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(2) COLLATE utf8mb4_czech_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `tld` varchar(5) COLLATE utf8mb4_czech_ci NOT NULL,
  `eu` int NOT NULL DEFAULT '0',
  `remark` varchar(300) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=250 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `dating_ads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dating_ads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `region_id` int DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `text` text COLLATE utf8mb4_czech_ci,
  `image` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `dating_ads_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2784 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `discussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `articles_id` int NOT NULL,
  `parent_id` int DEFAULT NULL,
  `content` text COLLATE utf8mb4_czech_ci NOT NULL,
  `active` int NOT NULL DEFAULT '1',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `articles_id` (`articles_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `discussion_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `discussion_ibfk_2` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_discussion_parent` FOREIGN KEY (`parent_id`) REFERENCES `discussion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=299982 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `file` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
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
DROP TABLE IF EXISTS `event_ads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_ads` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `event_category_id` int NOT NULL,
  `event_date` datetime DEFAULT NULL,
  `event_end_date` datetime DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `text` text COLLATE utf8mb4_czech_ci,
  `label` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `region` int DEFAULT NULL,
  `gps` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '0',
  `priority` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `event_category_id` (`event_category_id`),
  KEY `idx_event_ads_images_id` (`images_id`),
  CONSTRAINT `event_ads_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `event_ads_ibfk_2` FOREIGN KEY (`event_category_id`) REFERENCES `event_category` (`id`),
  CONSTRAINT `fk_event_ads_images` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1497 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `event_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `order` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '0',
  `permanent` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `featured_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `featured_photo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `images_id` int NOT NULL,
  `text` text COLLATE utf8mb4_czech_ci,
  `created` datetime DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `votes` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  KEY `idx_featured_photo_publish_date` (`publish_date`),
  KEY `idx_featured_photo_created` (`created`),
  CONSTRAINT `featured_photo_ibfk_2` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123495 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `featured_photo_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `featured_photo_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `featured_photo_id` int NOT NULL,
  `voted_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_day` (`users_id`,`voted_at`),
  KEY `photo` (`featured_photo_id`),
  CONSTRAINT `featured_photo_votes_ibfk_2` FOREIGN KEY (`featured_photo_id`) REFERENCES `featured_photo` (`id`) ON DELETE CASCADE,
  CONSTRAINT `featured_photo_votes_ibfk_3` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2666441 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `featured_video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `featured_video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `videos_id` int NOT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `videos_id` (`videos_id`),
  CONSTRAINT `featured_video_ibfk_2` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2773 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fellowship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fellowship` (
  `id` int NOT NULL AUTO_INCREMENT,
  `initiator` int NOT NULL,
  `acceptor` int NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `initiator` (`initiator`),
  KEY `acceptor` (`acceptor`),
  CONSTRAINT `fellowship_ibfk_1` FOREIGN KEY (`initiator`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fellowship_ibfk_2` FOREIGN KEY (`acceptor`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12503 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `image_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_gallery` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `owner` int DEFAULT NULL,
  `public` int NOT NULL DEFAULT '1',
  `created` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `changed` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7711 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `image_gallery2images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_gallery2images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `images_id` int NOT NULL,
  `image_gallery_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `image_gallery_id` (`image_gallery_id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `image_gallery2images_ibfk_2` FOREIGN KEY (`image_gallery_id`) REFERENCES `image_gallery` (`id`) ON DELETE CASCADE,
  CONSTRAINT `image_gallery2images_ibfk_5` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=132719 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int DEFAULT NULL,
  `file` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `crop` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `images_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=407855 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
DROP TABLE IF EXISTS `interests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `interest` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `like_dislike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `like_dislike` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `polarity` int NOT NULL DEFAULT '0',
  `content` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `agree_count` int NOT NULL DEFAULT '0',
  `disagree_count` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `idx_like_dislike_active_polarity_created` (`active`,`polarity`,`created`),
  CONSTRAINT `like_dislike_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12048 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_exports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_exports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dataMethod` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `dumpMethod` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `users_id` int NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `log_exports_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_like_dislike_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_like_dislike_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `like_dislike_id` int NOT NULL,
  `http_referer` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `remote_ip` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `remote_host` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `vote` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `like_dislike_id` (`like_dislike_id`),
  KEY `idx_log_like_dislike_votes_ip` (`remote_ip`),
  CONSTRAINT `log_like_dislike_votes_ibfk_1` FOREIGN KEY (`like_dislike_id`) REFERENCES `like_dislike` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=319567 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_poll_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `polls_id` int NOT NULL,
  `poll_options_id` int DEFAULT NULL,
  `http_referer` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `remote_ip` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `remote_host` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `polls_id` (`polls_id`),
  CONSTRAINT `log_poll_votes_ibfk_1` FOREIGN KEY (`polls_id`) REFERENCES `polls` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4335776 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `log_sent_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_sent_email` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `parameter` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `users_id` int DEFAULT NULL,
  `recipients` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
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
  `remote_ip` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `remote_host` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `log_users_login_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `group` varchar(100) COLLATE utf8mb4_czech_ci NOT NULL,
  `file` varchar(100) COLLATE utf8mb4_czech_ci NOT NULL,
  `checksum` char(32) COLLATE utf8mb4_czech_ci NOT NULL,
  `executed` datetime NOT NULL,
  `ready` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_file` (`group`,`file`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mirror_structure_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mirror_structure_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mirror_structure_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mirror_structure_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mirror_structure_group_id` int NOT NULL,
  `lang` varchar(2) COLLATE utf8mb4_czech_ci NOT NULL,
  `structure_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_structure_id` (`lang`,`structure_id`),
  UNIQUE KEY `mirror_structure_group_id_lang` (`mirror_structure_group_id`,`lang`),
  KEY `structure_id` (`structure_id`),
  CONSTRAINT `mirror_structure_item_ibfk_1` FOREIGN KEY (`mirror_structure_group_id`) REFERENCES `mirror_structure_group` (`id`) ON DELETE CASCADE,
  CONSTRAINT `mirror_structure_item_ibfk_2` FOREIGN KEY (`structure_id`) REFERENCES `structure` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `more_recommended_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `more_recommended_articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `articles_id` int NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  CONSTRAINT `more_recommended_articles_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `name_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `name_days` (
  `id` int NOT NULL AUTO_INCREMENT,
  `month` int DEFAULT NULL,
  `day` int DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `month` (`month`),
  KEY `day` (`day`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `articles_id` int DEFAULT NULL,
  `lang` char(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `articles_id` (`articles_id`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partner_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partner_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `images_id` int DEFAULT NULL,
  `link` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `partners_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `poll_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poll_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `polls_id` int NOT NULL,
  `option` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `votes` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `polls_id` (`polls_id`),
  CONSTRAINT `poll_options_ibfk_1` FOREIGN KEY (`polls_id`) REFERENCES `polls` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1860 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `polls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `question` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `answer_limit_per_ip` int DEFAULT NULL,
  `answer_deadline` datetime DEFAULT NULL,
  `active` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=334 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `message_running` text COLLATE utf8mb4_czech_ci,
  `message_finished` text COLLATE utf8mb4_czech_ci,
  `image` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `winner_id` int DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `winner_id` (`winner_id`),
  CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`winner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=691 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `quiz_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_questions_id` int NOT NULL,
  `quiz_options_id` int NOT NULL,
  `users_id` int DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `quiz_questions_id` (`quiz_questions_id`),
  KEY `quiz_options_id` (`quiz_options_id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `quiz_answers_ibfk_1` FOREIGN KEY (`quiz_questions_id`) REFERENCES `quiz_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `quiz_answers_ibfk_2` FOREIGN KEY (`quiz_options_id`) REFERENCES `quiz_options` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `quiz_answers_ibfk_3` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1399472 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `quiz_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_questions_id` int NOT NULL,
  `option` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `correct` int NOT NULL DEFAULT '0',
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `quiz_questions_id` (`quiz_questions_id`),
  CONSTRAINT `quiz_options_ibfk_1` FOREIGN KEY (`quiz_questions_id`) REFERENCES `quiz_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31378 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `quiz_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `date` date DEFAULT NULL,
  `question` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `quiz_questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `role_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_privileges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) COLLATE utf8mb4_czech_ci NOT NULL,
  `resource` varchar(100) COLLATE utf8mb4_czech_ci NOT NULL,
  `privilege` varchar(50) COLLATE utf8mb4_czech_ci NOT NULL,
  `deny` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `privilege` (`privilege`),
  KEY `role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `inherits_from` varchar(50) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role` (`role`),
  KEY `id_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
ALTER TABLE `role_privileges`
  ADD CONSTRAINT `role_privileges_ibfk_5` FOREIGN KEY (`role`) REFERENCES `roles` (`role`) ON DELETE CASCADE ON UPDATE CASCADE;
DROP TABLE IF EXISTS `search_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `search_index` (
  `id` int NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `keywords` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_czech_ci,
  `html_content` text COLLATE utf8mb4_czech_ci,
  `lang` varchar(10) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `update` int NOT NULL DEFAULT '0',
  `priority` decimal(1,1) NOT NULL DEFAULT '0.0',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=471 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `show_load_more` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sections2articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sections2articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sections_id` int NOT NULL,
  `articles_id` int NOT NULL,
  `publish_date` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pin` tinyint(1) NOT NULL DEFAULT '0',
  `pin_expires_at` datetime DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_sections_id` (`sections_id`),
  KEY `idx_articles_id` (`articles_id`),
  CONSTRAINT `fk_sections2articles_articles` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sections2articles_sections` FOREIGN KEY (`sections_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `slideshows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slideshows` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` char(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `slideshows_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slideshows_slides` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slideshows_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `subtitle` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link_title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
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
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `link_type` varchar(20) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `link_append` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `presenter` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `params` text COLLATE utf8mb4_czech_ci,
  `redirect` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `css_class` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `show_submenu` int NOT NULL DEFAULT '0',
  `show_subordinate` int NOT NULL DEFAULT '0',
  `seo_title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seo_description` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `seo_keywords` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `branch` (`structure_branches_id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `structure_ibfk_2` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `structure_ibfk_3` FOREIGN KEY (`structure_branches_id`) REFERENCES `structure_branches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `shortcut` varchar(30) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` char(2) COLLATE utf8mb4_czech_ci NOT NULL,
  `public` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `active` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `structure_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `structure_components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `structure_id` int NOT NULL,
  `block` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `component` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `create_parameters` text COLLATE utf8mb4_czech_ci,
  `active` int NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `structure_id` (`structure_id`),
  CONSTRAINT `structure_components_ibfk_2` FOREIGN KEY (`structure_id`) REFERENCES `structure` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag` varchar(100) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `lang` varchar(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `highlight` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1251 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `text_snippets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `text_snippets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(100) COLLATE utf8mb4_czech_ci NOT NULL,
  `lang` char(2) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_czech_ci,
  `created` datetime DEFAULT NULL,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_lang` (`code`,`lang`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tips` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `description` text COLLATE utf8mb4_czech_ci,
  `message_running` text COLLATE utf8mb4_czech_ci,
  `publish_date` datetime DEFAULT NULL,
  `tipable_days_before` int DEFAULT NULL,
  `winner_id` int DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `winner_id` (`winner_id`),
  CONSTRAINT `tips_ibfk_1` FOREIGN KEY (`winner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tips_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tips_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tips_questions_id` int NOT NULL,
  `answer` varchar(100) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `users_id` int DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tips_questions_id` (`tips_questions_id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `tips_answers_ibfk_1` FOREIGN KEY (`tips_questions_id`) REFERENCES `tips_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tips_answers_ibfk_3` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tips_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tips_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tips_id` int NOT NULL,
  `datetime` datetime DEFAULT NULL,
  `question` varchar(1000) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `correct_answer` varchar(100) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `points` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tips_id` (`tips_id`),
  CONSTRAINT `tips_questions_ibfk_1` FOREIGN KEY (`tips_id`) REFERENCES `tips` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `from` int NOT NULL,
  `to` int NOT NULL,
  `message` text COLLATE utf8mb4_czech_ci,
  `reply_to` int DEFAULT NULL,
  `priority` int NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `read` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `from` (`from`),
  KEY `to` (`to`),
  KEY `reply_to` (`reply_to`),
  CONSTRAINT `fk_reply_to` FOREIGN KEY (`reply_to`) REFERENCES `user_messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_messages_ibfk_3` FOREIGN KEY (`from`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_messages_ibfk_4` FOREIGN KEY (`to`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21470 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sso_id` int DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_czech_ci NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `surname` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `initials` varchar(4) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `activation_hash` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `activation_timestamp` datetime DEFAULT NULL,
  `reset_password_hash` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `reset_password_timestamp` datetime DEFAULT NULL,
  `registration_date` datetime DEFAULT NULL,
  `no_ads` datetime DEFAULT NULL,
  `color_code` varchar(20) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role` (`role`),
  CONSTRAINT `fk_role` FOREIGN KEY (`role`) REFERENCES `roles` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=22633 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users2interests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users2interests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `interests_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  KEY `interests_id` (`interests_id`),
  CONSTRAINT `users2interests_ibfk_3` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users2interests_ibfk_4` FOREIGN KEY (`interests_id`) REFERENCES `interests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15596 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `title_before` varchar(50) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `title_after` varchar(50) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `cellphone` varchar(50) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `telephone` varchar(50) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  `occupation` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `company_registration` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `mailing_consent` int DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `images_id` int DEFAULT NULL,
  `about_me` text COLLATE utf8mb4_czech_ci,
  `education` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `height` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `facebook_id` varchar(100) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_id_unique` (`users_id`),
  KEY `users_id` (`users_id`),
  KEY `country_id` (`country_id`),
  KEY `images_id` (`images_id`),
  CONSTRAINT `users_data_ibfk_1` FOREIGN KEY (`images_id`) REFERENCES `images` (`id`) ON DELETE SET NULL,
  CONSTRAINT `users_data_ibfk_2` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users_data_ibfk_3` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18740 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
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
  `title` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `file` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `embed` varchar(255) COLLATE utf8mb4_czech_ci DEFAULT NULL,
  `ratio` varchar(100) COLLATE utf8mb4_czech_ci NOT NULL DEFAULT '16:9',
  `users_id` int DEFAULT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `changed` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`),
  CONSTRAINT `fk_videos_users` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2799 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

