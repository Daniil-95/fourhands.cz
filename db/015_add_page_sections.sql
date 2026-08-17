CREATE TABLE IF NOT EXISTS page_sections (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    page_key VARCHAR(50) NOT NULL,
    section_key VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL DEFAULT '',
    subtitle VARCHAR(500) NOT NULL DEFAULT '',
    content MEDIUMTEXT NULL,
    button_text VARCHAR(255) NOT NULL DEFAULT '',
    button_url VARCHAR(500) NOT NULL DEFAULT '',
    image_path VARCHAR(255) NOT NULL DEFAULT '',
    sort_order INT NOT NULL DEFAULT 100,
    active TINYINT(1) NOT NULL DEFAULT 1,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY page_section_lang (page_key, section_key, lang),
    KEY page_section_sort (page_key, lang, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT IGNORE INTO page_sections (lang, page_key, section_key, title, subtitle, content, button_text, button_url, image_path, sort_order) VALUES
('cs', 'homepage', 'hero', 'FOURHANDS', 'Klavírní duo pro výjimečné okamžiky vašeho života.', '', 'Nezávazná poptávka', '#kontakt', 'images/story.jpg', 10),
('en', 'homepage', 'hero', 'FOURHANDS', 'Piano duo for the exceptional moments of your life.', '', 'Non-binding inquiry', '#kontakt', 'images/story.jpg', 10),
('cs', 'homepage', 'programs', 'Kde nás můžete slyšet', 'Nadcházející programy', '', 'Všechny programy', '/udalosti', '', 20),
('en', 'homepage', 'programs', 'Where can you hear us', 'Upcoming programs', '', 'All programs', '/udalosti', '', 20),
('cs', 'homepage', 'videos', 'Poslouchejte nás', 'Video prezentace', '', 'Zobrazit všechna videa', '/videa', '', 30),
('en', 'homepage', 'videos', 'Listen to us', 'Video presentation', '', 'Show all videos', '/videa', '', 30),
('cs', 'homepage', 'gallery', 'Momenty v obrazech', 'Fotogalerie', '', 'Zobrazit celou galerii', '/galerie', '', 40),
('en', 'homepage', 'gallery', 'Moments in pictures', 'Photo gallery', '', 'Show entire gallery', '/galerie', '', 40),
('cs', 'homepage', 'contact', 'Plánujete akci?', 'Rádi vám zahrajeme.', '', '', '#kontakt', '', 50),
('en', 'homepage', 'contact', 'Planning an event?', 'We would be happy to play for you.', '', '', '#kontakt', '', 50),
('cs', 'about', 'hero', 'Four hands. One musical voice.', 'Pražské klavírní duo pro čtyři ruce a dva klavíry.', '', '', '', '', 10),
('en', 'about', 'hero', 'Four hands. One musical voice.', 'A Prague-based piano duo exploring the repertoire for four hands and two pianos.', '', '', '', '', 10),
('cs', 'about', 'content', 'O nás', '', 'Vítejte v Fourhands.', '', '', '', 20),
('en', 'about', 'content', 'About us', '', 'Welcome to Fourhands.', '', '', '', 20),
('cs', 'artists', 'hero', 'Umělkyně', 'Poznejte duo Fourhands.', '', '', '', '', 10),
('en', 'artists', 'hero', 'Artists', 'Meet the Fourhands duo.', '', '', '', '', 10),
('cs', 'artists', 'katerina', 'Kateřina Konopová', '', '', '', '', '', 20),
('en', 'artists', 'katerina', 'Katerina Konopova', '', '', '', '', '', 20),
('cs', 'artists', 'irena', 'Irena Andruško', '', '', '', '', '', 30),
('en', 'artists', 'irena', 'Irena Andrusko', '', '', '', '', '', 30),
('cs', 'repertoire', 'hero', 'Repertoár', 'Hudba pro výjimečné okamžiky.', '', '', '', '', 10),
('en', 'repertoire', 'hero', 'Repertoire', 'Music for exceptional moments.', '', '', '', '', 10),
('cs', 'repertoire', 'content', 'Nabídka programů', '', 'Repertoár bude doplněn v administraci.', '', '', '', 20),
('en', 'repertoire', 'content', 'Programmes', '', 'The repertoire will be added in the administration.', '', '', '', 20),
('cs', 'events', 'hero', 'Program', 'Nadcházející vystoupení a koncerty.', '', '', '', '', 10),
('en', 'events', 'hero', 'Events', 'Upcoming performances and concerts.', '', '', '', '', 10),
('cs', 'from_stage', 'hero', 'Z pódia', 'Články, rozhovory, publikace a zmínky o Fourhands.', '', '', '', '', 10),
('en', 'from_stage', 'hero', 'From the stage', 'Articles, interviews, publications and mentions about Fourhands.', '', '', '', '', 10);

UPDATE page_sections AS section
JOIN site_settings AS setting ON setting.lang COLLATE utf8mb4_unicode_ci = section.lang AND setting.key_name = CASE section.section_key
    WHEN 'hero' THEN 'hero_heading' ELSE '' END
SET section.title = setting.value_text
WHERE section.page_key = 'homepage' AND section.section_key = 'hero';

UPDATE page_sections AS section
JOIN site_settings AS setting ON setting.lang COLLATE utf8mb4_unicode_ci = section.lang AND setting.key_name = 'hero_lead'
SET section.subtitle = setting.value_text
WHERE section.page_key = 'homepage' AND section.section_key = 'hero';

UPDATE page_sections AS section
JOIN site_settings AS setting ON setting.lang COLLATE utf8mb4_unicode_ci = section.lang AND setting.key_name = 'hero_cta'
SET section.button_text = setting.value_text
WHERE section.page_key = 'homepage' AND section.section_key = 'hero';

UPDATE page_sections AS section
JOIN site_settings AS setting ON setting.lang COLLATE utf8mb4_unicode_ci = section.lang AND setting.key_name = 'hero_image'
SET section.image_path = setting.value_text
WHERE section.page_key = 'homepage' AND section.section_key = 'hero';

UPDATE page_sections AS section
JOIN text_snippets AS snippet ON snippet.lang COLLATE utf8mb4_unicode_ci = section.lang AND snippet.code COLLATE utf8mb4_unicode_ci = CASE section.section_key
    WHEN 'content' THEN CASE section.page_key WHEN 'about' THEN 'about' WHEN 'repertoire' THEN 'program' ELSE '' END
    WHEN 'katerina' THEN 'artist_katerina'
    WHEN 'irena' THEN 'artist_irena'
    ELSE '' END
SET section.title = COALESCE(NULLIF(snippet.title, ''), section.title), section.content = snippet.content
WHERE section.page_key IN ('about', 'repertoire', 'artists') AND section.section_key IN ('content', 'katerina', 'irena');

DELETE FROM site_settings
WHERE key_name IN ('hero_image', 'hero_heading', 'hero_lead', 'hero_cta', 'hero_scroll');