INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'cs', CONVERT(0x4B6F6E636572746EC3AD2070726F6772616D USING utf8mb4), '/koncertni-program', 40, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'cs' AND url IN ('/koncertni-program', '/repertoar'));

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'en', 'Concert program', '/repertoire', 40, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'en' AND url IN ('/repertoire', '/koncertni-program'));

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'cs', 'Kontakt', '/#kontakt', 90, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'cs' AND url = '/#kontakt');

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'en', 'Contact', '/#kontakt', 90, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'en' AND url = '/#kontakt');

UPDATE page_sections
SET title = CONVERT(0x4B6F6E636572746EC3AD2070726F6772616D USING utf8mb4)
WHERE page_key = 'repertoire' AND section_key = 'hero' AND lang = 'cs';

UPDATE page_sections
SET title = 'Concert program'
WHERE page_key = 'repertoire' AND section_key = 'hero' AND lang = 'en';