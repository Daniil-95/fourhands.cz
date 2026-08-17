-- Keep the editable admin navigation in sync with the public navigation.
INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'cs', 'Z pódia', '/z-podia', 70, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'cs' AND url = '/z-podia');

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'cs', 'Události', '/udalosti', 80, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'cs' AND url = '/udalosti');

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'cs', 'Kontakt', '/#kontakt', 90, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'cs' AND url = '/#kontakt');

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'en', 'From the stage', '/from-stage', 70, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'en' AND url = '/from-stage');

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'en', 'Events', '/events', 80, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'en' AND url = '/events');

INSERT INTO navigation_items (lang, title, url, sort_order, active, created)
SELECT 'en', 'Contact', '/#kontakt', 90, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM navigation_items WHERE lang = 'en' AND url = '/#kontakt');

UPDATE navigation_items
SET title = 'Artists', url = '/artists'
WHERE lang = 'en' AND url = '/clenky';