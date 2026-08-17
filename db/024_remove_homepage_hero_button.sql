UPDATE page_sections
SET button_text = '', button_url = ''
WHERE page_key = 'homepage' AND section_key = 'hero';

DELETE FROM site_settings
WHERE key_name = 'hero_cta';
