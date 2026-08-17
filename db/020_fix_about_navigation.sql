UPDATE navigation_items
SET title = CONVERT(0x4F206EC3A173 USING utf8mb4), url = '/o-nas'
WHERE lang = 'cs' AND (url = '/#o-duu' OR title = 'O duu');

UPDATE navigation_items
SET title = 'About', url = '/about'
WHERE lang = 'en' AND (url = '/#o-duu' OR title = 'About');