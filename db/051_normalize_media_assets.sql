CREATE TABLE IF NOT EXISTS media_assets (
    id INT NOT NULL AUTO_INCREMENT,
    type ENUM('photo', 'video') NOT NULL,
    file VARCHAR(255) DEFAULT NULL,
    embed_url VARCHAR(255) DEFAULT NULL,
    thumbnail_path VARCHAR(255) DEFAULT NULL,
    users_id INT DEFAULT NULL,
    created DATETIME DEFAULT NULL,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY media_assets_photo_file (type, file),
    UNIQUE KEY media_assets_video_url (type, embed_url),
    KEY users_id (users_id),
    CONSTRAINT media_assets_users_fk FOREIGN KEY (users_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE IF NOT EXISTS media_translations (
    id INT NOT NULL AUTO_INCREMENT,
    asset_id INT NOT NULL,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    title VARCHAR(255) DEFAULT NULL,
    description TEXT DEFAULT NULL,
    alt_text VARCHAR(255) DEFAULT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created DATETIME DEFAULT NULL,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY media_translations_asset_lang (asset_id, lang),
    KEY media_translations_lang (lang),
    CONSTRAINT media_translations_asset_fk FOREIGN KEY (asset_id) REFERENCES media_assets (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO media_assets (type, file, users_id, created)
SELECT 'photo', NULLIF(file, ''), MIN(users_id), MIN(created)
FROM images
GROUP BY file;

INSERT INTO media_assets (type, embed_url, thumbnail_path, users_id, created)
SELECT 'video', NULLIF(COALESCE(NULLIF(embed, ''), NULLIF(file, '')), ''),
       NULLIF(ratio, ''), MIN(users_id), MIN(created)
FROM videos
GROUP BY COALESCE(NULLIF(embed, ''), NULLIF(file, ''));

INSERT INTO media_translations (asset_id, lang, title, description, alt_text, sort_order, active, created)
SELECT a.id, i.lang, i.title, i.subtitle, i.alt_text, i.sort_order, i.active, i.created
FROM images i
JOIN media_assets a ON a.type = 'photo' AND a.file <=> NULLIF(i.file, '')
ON DUPLICATE KEY UPDATE
    title = VALUES(title), description = VALUES(description), alt_text = VALUES(alt_text),
    sort_order = VALUES(sort_order), active = VALUES(active);

INSERT INTO media_translations (asset_id, lang, title, description, sort_order, active, created)
SELECT a.id, v.lang, v.title, v.description, v.sort_order, v.active, v.created
FROM videos v
JOIN media_assets a ON a.type = 'video'
    AND a.embed_url <=> NULLIF(COALESCE(NULLIF(v.embed, ''), NULLIF(v.file, '')), '')
ON DUPLICATE KEY UPDATE
    title = VALUES(title), description = VALUES(description),
    sort_order = VALUES(sort_order), active = VALUES(active);