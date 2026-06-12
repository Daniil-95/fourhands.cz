SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_connection = utf8mb4;
SET character_set_results = utf8mb4;

-- Drop and recreate programs table with icon as class name
DROP TABLE IF EXISTS programs;
CREATE TABLE IF NOT EXISTS programs (
    id INT NOT NULL AUTO_INCREMENT,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    icon VARCHAR(30) NOT NULL DEFAULT 'music-note',
    image_path VARCHAR(255) NULL,
    sort_order INT NOT NULL DEFAULT 100,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created DATETIME NULL,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY program_lang_active_sort (lang, active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO programs (lang, title, description, icon, image_path, sort_order, active, created) VALUES
('cs', 'Svatby', 'Romantická hudba pro obřad, hostinu i večerní zábavu.', 'heart', 'kids5-thumb.jpg', 10, 1, NOW()),
('en', 'Weddings', 'Romantic music for ceremony, reception and evening entertainment.', 'heart', 'kids5-thumb.jpg', 10, 1, NOW()),
('cs', 'Firemní akce', 'Elegantní doprovod pro večírky, gala večery a eventy.', 'diamond', 'kids8-thumb.jpg', 20, 1, NOW()),
('en', 'Corporate events', 'Elegant accompaniment for parties, gala evenings and events.', 'diamond', 'kids8-thumb.jpg', 20, 1, NOW()),
('cs', 'Koncerty', 'Vlastní koncertní programy na prestižních místech.', 'note', 'D55806FE-109C-441B-98E7-8035F609E16F.jpg', 30, 1, NOW()),
('en', 'Concerts', 'Original concert programs at prestigious venues.', 'note', 'D55806FE-109C-441B-98E7-8035F609E16F.jpg', 30, 1, NOW()),
('cs', 'Soukromé akce', 'Hudba na narozeniny, výročí a jiné výjimečné události.', 'star', 'kids7-thumb.jpg', 40, 1, NOW()),
('en', 'Private events', 'Music for birthdays, anniversaries and other special occasions.', 'star', 'kids7-thumb.jpg', 40, 1, NOW());

-- Fix any corrupted site_settings (re-insert with proper UTF-8)
DELETE FROM site_settings WHERE key_name IN (
    'hero_lead', 'hero_cta', 'hero_scroll', 'about_heading', 'about_eyebrow',
    'about_cta', 'stat_1_label', 'stat_2_label', 'stat_3_label',
    'seo_keywords', 'og_title', 'og_description',
    'footer_copyright', 'member_katerina_image', 'member_irena_image'
);

INSERT IGNORE INTO site_settings (lang, group_name, key_name, label, value_text, sort_order) VALUES
('cs', 'general', 'hero_lead', 'Hero podnadpis', 'Klavírní duo pro výjimečné okamžiky vašeho života.', 3),
('en', 'general', 'hero_lead', 'Hero lead text', 'Piano duo for the exceptional moments of your life.', 3),
('cs', 'general', 'hero_cta', 'Hero CTA tlačítko', 'Nezávazná poptávka', 4),
('en', 'general', 'hero_cta', 'Hero CTA button', 'Non-binding inquiry', 4),
('cs', 'general', 'hero_scroll', 'Hero scroll text', 'Objevte nás', 5),
('en', 'general', 'hero_scroll', 'Hero scroll text', 'Discover us', 5),
('cs', 'general', 'about_heading', 'O nás nadpis', 'Hudba, která spojuje a vytváří emoce', 7),
('en', 'general', 'about_heading', 'About us heading', 'Music that connects and creates emotions', 7),
('cs', 'general', 'about_eyebrow', 'O nás popisek', 'O nás', 8),
('en', 'general', 'about_eyebrow', 'About us eyebrow', 'About us', 8),
('cs', 'general', 'about_cta', 'O nás CTA', 'Poznejte nás', 9),
('en', 'general', 'about_cta', 'About us CTA', 'Get to know us', 9),
('cs', 'general', 'stat_1_label', 'Statistika 1 – popisek', 'let praxe', 11),
('en', 'general', 'stat_1_label', 'Stat 1 – label', 'years of playing', 11),
('cs', 'general', 'stat_2_label', 'Statistika 2 – popisek', 'koncertů', 13),
('en', 'general', 'stat_2_label', 'Stat 2 – label', 'concerts', 13),
('cs', 'general', 'stat_3_label', 'Statistika 3 – popisek', 'spokojených hostů', 15),
('en', 'general', 'stat_3_label', 'Stat 3 – label', 'satisfied guests', 15),
('cs', 'seo', 'seo_keywords', 'Meta keywords', 'klavírní duo, čtyřručně, svatba, koncert, Praha', 85),
('en', 'seo', 'seo_keywords', 'Meta keywords', 'piano duo, four hands, wedding, concert, Prague', 85),
('cs', 'seo', 'og_title', 'Open Graph title', 'Fourhands – klavírní duo', 90),
('en', 'seo', 'og_title', 'Open Graph title', 'Fourhands – piano duo', 90),
('cs', 'seo', 'og_description', 'Open Graph description', 'Klavírní duo pro výjimečné okamžiky vašeho života.', 91),
('en', 'seo', 'og_description', 'Open Graph description', 'Piano duo for the exceptional moments of your life.', 91),
('cs', 'general', 'footer_copyright', 'Copyright v patičce', '© Fourhands', 30),
('en', 'general', 'footer_copyright', 'Footer copyright', '© Fourhands', 30),
('cs', 'general', 'member_katerina_image', 'Kateřina – fotka', 'images/katerina.jpg', 20),
('en', 'general', 'member_katerina_image', 'Katerina – photo', 'images/katerina.jpg', 20),
('cs', 'general', 'member_irena_image', 'Irena – fotka', 'images/Irena.jpg', 21),
('en', 'general', 'member_irena_image', 'Irena – photo', 'images/Irena.jpg', 21);
