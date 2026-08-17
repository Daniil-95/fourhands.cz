DELETE FROM navigation_items
WHERE url = '/#programy';

DELETE FROM page_sections
WHERE page_key = 'homepage' AND section_key = 'programs';

DROP TABLE IF EXISTS programs;