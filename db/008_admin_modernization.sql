ALTER TABLE text_snippets
    ADD COLUMN title VARCHAR(255) NULL AFTER lang,
    ADD COLUMN category VARCHAR(50) NOT NULL DEFAULT 'content' AFTER title,
    ADD COLUMN sort_order INT NOT NULL DEFAULT 100 AFTER content,
    ADD COLUMN active TINYINT(1) NOT NULL DEFAULT 1 AFTER sort_order;

ALTER TABLE images
    ADD COLUMN lang CHAR(2) NOT NULL DEFAULT 'cs' AFTER users_id,
    ADD COLUMN alt_text VARCHAR(255) NULL AFTER subtitle,
    ADD COLUMN sort_order INT NOT NULL DEFAULT 100 AFTER crop,
    ADD COLUMN active TINYINT(1) NOT NULL DEFAULT 1 AFTER sort_order;

ALTER TABLE videos
    ADD COLUMN lang CHAR(2) NOT NULL DEFAULT 'cs' AFTER users_id,
    ADD COLUMN description TEXT NULL AFTER title,
    ADD COLUMN sort_order INT NOT NULL DEFAULT 100 AFTER ratio,
    ADD COLUMN active TINYINT(1) NOT NULL DEFAULT 1 AFTER sort_order;

ALTER TABLE news
    ADD COLUMN slug VARCHAR(255) NULL AFTER title,
    ADD COLUMN perex TEXT NULL AFTER slug,
    ADD COLUMN content MEDIUMTEXT NULL AFTER perex,
    ADD COLUMN meta_title VARCHAR(255) NULL AFTER content,
    ADD COLUMN meta_description VARCHAR(500) NULL AFTER meta_title,
    ADD COLUMN sort_order INT NOT NULL DEFAULT 100 AFTER active,
    ADD UNIQUE INDEX news_slug_lang (slug, lang),
    ADD INDEX news_active_publish (active, publish_date);

CREATE TABLE IF NOT EXISTS site_settings (
    id INT NOT NULL AUTO_INCREMENT,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    group_name VARCHAR(50) NOT NULL DEFAULT 'general',
    key_name VARCHAR(100) NOT NULL,
    label VARCHAR(255) NOT NULL,
    value_text TEXT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY setting_key_lang (key_name, lang),
    KEY setting_group_sort (group_name, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE IF NOT EXISTS navigation_items (
    id INT NOT NULL AUTO_INCREMENT,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    title VARCHAR(100) NOT NULL,
    url VARCHAR(255) NOT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created DATETIME NULL,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY navigation_lang_active_sort (lang, active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE IF NOT EXISTS testimonials (
    id INT NOT NULL AUTO_INCREMENT,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    client_name VARCHAR(255) NOT NULL,
    project_name VARCHAR(255) NULL,
    quote_text TEXT NOT NULL,
    event_date DATE NULL,
    image_path VARCHAR(255) NULL,
    sort_order INT NOT NULL DEFAULT 100,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created DATETIME NULL,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY testimonial_lang_active_sort (lang, active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT IGNORE INTO site_settings (lang, group_name, key_name, label, value_text, sort_order) VALUES
('cs', 'contact', 'phone', 'Telefon', '+420 777 123 456', 10),
('cs', 'contact', 'email', 'E-mail', 'info@fourhands.cz', 20),
('cs', 'contact', 'address', 'Adresa', 'Praha, Česká republika', 30),
('cs', 'social', 'facebook', 'Facebook URL', '', 40),
('cs', 'social', 'instagram', 'Instagram URL', '', 50),
('cs', 'social', 'youtube', 'YouTube URL', '', 60),
('cs', 'seo', 'meta_title', 'Výchozí meta title', 'Fourhands – klavírní duo', 70),
('cs', 'seo', 'meta_description', 'Výchozí meta description', 'Klavírní duo pro výjimečné okamžiky vašeho života.', 80);

INSERT IGNORE INTO navigation_items (lang, title, url, sort_order, active, created) VALUES
('cs', 'Úvod', '/#uvod', 10, 1, NOW()),
('cs', 'O duu', '/#o-duu', 20, 1, NOW()),
('cs', 'Členky', '/clenky', 30, 1, NOW()),
('cs', 'Programy', '/#programy', 40, 1, NOW()),
('cs', 'Galerie', '/galerie', 50, 1, NOW()),
('cs', 'Videa', '/videa', 60, 1, NOW()),
('cs', 'Reference', '/#reference', 70, 1, NOW()),
('cs', 'Kontakt', '/#kontakt', 80, 1, NOW());
