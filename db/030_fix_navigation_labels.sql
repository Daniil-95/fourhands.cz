-- Restore the exact editable labels used by the public navigation.
UPDATE navigation_items SET title = CONVERT(0xC39A766F64 USING utf8mb4), url = '/#uvod'
WHERE lang = 'cs' AND url = '/#uvod';

UPDATE navigation_items SET title = CONVERT(0x4F206EC3A173 USING utf8mb4), url = '/o-nas'
WHERE lang = 'cs' AND url = '/o-nas';

UPDATE navigation_items SET title = CONVERT(0x556DC49B6C6B796EC49B USING utf8mb4), url = '/umelkyne'
WHERE lang = 'cs' AND url IN ('/clenky', '/umelkyne');

UPDATE navigation_items SET title = 'Galerie', url = '/galerie'
WHERE lang = 'cs' AND url = '/galerie';

UPDATE navigation_items SET title = 'Videa', url = '/videa'
WHERE lang = 'cs' AND url = '/videa';

UPDATE navigation_items SET title = CONVERT(0x5A2070C3B3646961 USING utf8mb4), url = '/z-podia'
WHERE lang = 'cs' AND url = '/z-podia';

UPDATE navigation_items SET title = CONVERT(0x5564C3A16C6F737469 USING utf8mb4), url = '/udalosti'
WHERE lang = 'cs' AND url = '/udalosti';

UPDATE navigation_items SET title = 'Kontakt', url = '/#kontakt'
WHERE lang = 'cs' AND url = '/#kontakt';

UPDATE navigation_items SET title = 'Home', url = '/#uvod'
WHERE lang = 'en' AND url = '/#uvod';

UPDATE navigation_items SET title = 'About us', url = '/about'
WHERE lang = 'en' AND url = '/about';

UPDATE navigation_items SET title = 'Artists', url = '/artists'
WHERE lang = 'en' AND url = '/artists';

UPDATE navigation_items SET title = 'Gallery', url = '/galerie'
WHERE lang = 'en' AND url = '/galerie';

UPDATE navigation_items SET title = 'Videos', url = '/videa'
WHERE lang = 'en' AND url = '/videa';

UPDATE navigation_items SET title = 'From the stage', url = '/from-stage'
WHERE lang = 'en' AND url = '/from-stage';

UPDATE navigation_items SET title = 'Events', url = '/events'
WHERE lang = 'en' AND url = '/events';

UPDATE navigation_items SET title = 'Contact', url = '/#kontakt'
WHERE lang = 'en' AND url = '/#kontakt';