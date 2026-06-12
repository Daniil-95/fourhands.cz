-- Add missing site settings keys for content that was hardcoded
INSERT IGNORE INTO site_settings (lang, group_name, key_name, label, value_text, sort_order) VALUES
('cs', 'general', 'hero_image', 'Hero obrázek na pozadí', 'images/story.jpg', 1),
('en', 'general', 'hero_image', 'Hero background image', 'images/story.jpg', 1),
('cs', 'general', 'hero_heading', 'Hero nadpis', 'FOURHANDS', 2),
('en', 'general', 'hero_heading', 'Hero heading', 'FOURHANDS', 2),
('cs', 'general', 'hero_lead', 'Hero podnadpis', 'Klavírní duo pro výjimečné okamžiky vašeho života.', 3),
('en', 'general', 'hero_lead', 'Hero lead text', 'Piano duo for the exceptional moments of your life.', 3),
('cs', 'general', 'hero_cta', 'Hero CTA tlačítko', 'Nezávazná poptávka', 4),
('en', 'general', 'hero_cta', 'Hero CTA button', 'Non-binding inquiry', 4),
('cs', 'general', 'hero_scroll', 'Hero scroll text', 'Objevte nás', 5),
('en', 'general', 'hero_scroll', 'Hero scroll text', 'Discover us', 5),
('cs', 'general', 'about_image', 'O nás obrázek', 'images/slider2.jpg', 6),
('en', 'general', 'about_image', 'About us image', 'images/slider2.jpg', 6),
('cs', 'general', 'about_heading', 'O nás nadpis', 'Hudba, která spojuje a vytváří emoce', 7),
('en', 'general', 'about_heading', 'About us heading', 'Music that connects and creates emotions', 7),
('cs', 'general', 'about_eyebrow', 'O nás popisek', 'O nás', 8),
('en', 'general', 'about_eyebrow', 'About us eyebrow', 'About us', 8),
('cs', 'general', 'about_cta', 'O nás CTA', 'Poznejte nás', 9),
('en', 'general', 'about_cta', 'About us CTA', 'Get to know us', 9),
('cs', 'general', 'stat_1_number', 'Statistika 1 – číslo', '10+', 10),
('en', 'general', 'stat_1_number', 'Stat 1 – number', '10+', 10),
('cs', 'general', 'stat_1_label', 'Statistika 1 – popisek', 'let praxe', 11),
('en', 'general', 'stat_1_label', 'Stat 1 – label', 'years of playing', 11),
('cs', 'general', 'stat_2_number', 'Statistika 2 – číslo', '150+', 12),
('en', 'general', 'stat_2_number', 'Stat 2 – number', '150+', 12),
('cs', 'general', 'stat_2_label', 'Statistika 2 – popisek', 'koncertů', 13),
('en', 'general', 'stat_2_label', 'Stat 2 – label', 'concerts', 13),
('cs', 'general', 'stat_3_number', 'Statistika 3 – číslo', '1000+', 14),
('en', 'general', 'stat_3_number', 'Stat 3 – number', '1000+', 14),
('cs', 'general', 'stat_3_label', 'Statistika 3 – popisek', 'spokojených hostů', 15),
('en', 'general', 'stat_3_label', 'Stat 3 – label', 'satisfied guests', 15),
('cs', 'general', 'member_katerina_image', 'Kateřina – fotka', 'images/katerina.jpg', 20),
('en', 'general', 'member_katerina_image', 'Katerina – photo', 'images/katerina.jpg', 20),
('cs', 'general', 'member_irena_image', 'Irena – fotka', 'images/Irena.jpg', 21),
('en', 'general', 'member_irena_image', 'Irena – photo', 'images/Irena.jpg', 21),
('cs', 'general', 'footer_copyright', 'Copyright v patičce', '© Fourhands', 30),
('en', 'general', 'footer_copyright', 'Footer copyright', '© Fourhands', 30),
('cs', 'social', 'gdpr_url', 'GDPR odkaz', '', 65),
('en', 'social', 'gdpr_url', 'GDPR URL', '', 65),
('cs', 'social', 'cookies_url', 'Cookies odkaz', '', 66),
('en', 'social', 'cookies_url', 'Cookies URL', '', 66),
('cs', 'seo', 'seo_keywords', 'Meta keywords', 'klavírní duo, čtyřručně, svatba, koncert, Praha', 85),
('en', 'seo', 'seo_keywords', 'Meta keywords', 'piano duo, four hands, wedding, concert, Prague', 85),
('cs', 'seo', 'og_title', 'Open Graph title', 'Fourhands – klavírní duo', 90),
('en', 'seo', 'og_title', 'Open Graph title', 'Fourhands – piano duo', 90),
('cs', 'seo', 'og_description', 'Open Graph description', 'Klavírní duo pro výjimečné okamžiky vašeho života.', 91),
('en', 'seo', 'og_description', 'Open Graph description', 'Piano duo for the exceptional moments of your life.', 91),
('cs', 'seo', 'og_image', 'Open Graph image', 'images/og-image.jpg', 92),
('en', 'seo', 'og_image', 'Open Graph image', 'images/og-image.jpg', 92),
('cs', 'seo', 'seo_canonical', 'Canonical URL', '', 93),
('en', 'seo', 'seo_canonical', 'Canonical URL', '', 93);

-- Create programs table for editable program/service cards
CREATE TABLE IF NOT EXISTS programs (
    id INT NOT NULL AUTO_INCREMENT,
    lang CHAR(2) NOT NULL DEFAULT 'cs',
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    icon VARCHAR(10) NOT NULL DEFAULT '♫',
    image_path VARCHAR(255) NULL,
    sort_order INT NOT NULL DEFAULT 100,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created DATETIME NULL,
    changed TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY program_lang_active_sort (lang, active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Seed default programs
INSERT IGNORE INTO programs (lang, title, description, icon, image_path, sort_order, active, created) VALUES
('cs', 'Svatby', 'Romantická hudba pro obřad, hostinu i večerní zábavu.', '♡', 'kids5-thumb.jpg', 10, 1, NOW()),
('en', 'Weddings', 'Romantic music for ceremony, reception and evening entertainment.', '♡', 'kids5-thumb.jpg', 10, 1, NOW()),
('cs', 'Firemní akce', 'Elegantní doprovod pro večírky, gala večery a eventy.', '◇', 'kids8-thumb.jpg', 20, 1, NOW()),
('en', 'Corporate events', 'Elegant accompaniment for parties, gala evenings and events.', '◇', 'kids8-thumb.jpg', 20, 1, NOW()),
('cs', 'Koncerty', 'Vlastní koncertní programy na prestižních místech.', '♩', 'D55806FE-109C-441B-98E7-8035F609E16F.jpg', 30, 1, NOW()),
('en', 'Concerts', 'Original concert programs at prestigious venues.', '♩', 'D55806FE-109C-441B-98E7-8035F609E16F.jpg', 30, 1, NOW()),
('cs', 'Soukromé akce', 'Hudba na narozeniny, výročí a jiné výjimečné události.', '☆', 'kids7-thumb.jpg', 40, 1, NOW()),
('en', 'Private events', 'Music for birthdays, anniversaries and other special occasions.', '☆', 'kids7-thumb.jpg', 40, 1, NOW());

-- Insert EN translations for existing settings that are missing EN
INSERT IGNORE INTO site_settings (lang, group_name, key_name, label, value_text, sort_order) VALUES
('en', 'contact', 'phone', 'Phone', '+420 777 123 456', 10),
('en', 'contact', 'email', 'E-mail', 'info@fourhands.cz', 20),
('en', 'contact', 'address', 'Address', 'Prague, Czech Republic', 30),
('en', 'social', 'facebook', 'Facebook URL', '', 40),
('en', 'social', 'instagram', 'Instagram URL', '', 50),
('en', 'social', 'youtube', 'YouTube URL', '', 60),
('en', 'seo', 'meta_title', 'Default meta title', 'Fourhands – piano duo', 70),
('en', 'seo', 'meta_description', 'Default meta description', 'Piano duo for the exceptional moments of your life.', 80);

-- Insert EN navigation items
INSERT IGNORE INTO navigation_items (lang, title, url, sort_order, active, created) VALUES
('en', 'Home', '/#uvod', 10, 1, NOW()),
('en', 'About', '/#o-duu', 20, 1, NOW()),
('en', 'Members', '/clenky', 30, 1, NOW()),
('en', 'Programs', '/#programy', 40, 1, NOW()),
('en', 'Gallery', '/galerie', 50, 1, NOW()),
('en', 'Videos', '/videa', 60, 1, NOW()),
('en', 'References', '/#reference', 70, 1, NOW()),
('en', 'Contact', '/#kontakt', 80, 1, NOW());
