CREATE TABLE IF NOT EXISTS publications (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  lang CHAR(2) NOT NULL DEFAULT 'cs',
  title VARCHAR(255) NOT NULL,
  source VARCHAR(255) DEFAULT NULL,
  short_description TEXT DEFAULT NULL,
  url VARCHAR(500) DEFAULT NULL,
  image_path VARCHAR(255) DEFAULT NULL,
  publish_date DATE DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 100,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created DATETIME NOT NULL,
  PRIMARY KEY (id),
  KEY idx_publications_lang_active (lang, active, publish_date),
  KEY idx_publications_sort (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
