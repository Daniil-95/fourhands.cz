UPDATE page_sections
SET title = 'Chcete nám napsat?', subtitle = 'Rády vám odpovíme.'
WHERE page_key = 'homepage' AND section_key = 'contact' AND lang = 'cs';

UPDATE page_sections
SET title = 'Would you like to write to us?', subtitle = 'We will be happy to reply.'
WHERE page_key = 'homepage' AND section_key = 'contact' AND lang = 'en';