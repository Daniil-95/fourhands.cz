UPDATE page_sections
SET title = CONVERT(0x48756462612070726F2076C3BD6A696D65C48D6EC3A9206F6B616DC5BE696B79 USING utf8mb4)
WHERE page_key = 'repertoire' AND section_key = 'hero' AND lang = 'cs';

UPDATE page_sections
SET title = 'Music for exceptional moments'
WHERE page_key = 'repertoire' AND section_key = 'hero' AND lang = 'en';

UPDATE page_sections
SET subtitle = CONVERT(0x4b6f6e636572746ec3ad2070726f6772616d792070726f207376617462792c206b6f6e636572747920612076c3bd6a696d65c48d6ec3a9207564c3a16c6f7374692e USING utf8mb4)
WHERE page_key = 'repertoire' AND section_key = 'hero' AND lang = 'cs';

UPDATE page_sections
SET subtitle = 'Concert programmes for weddings, concerts and exceptional events.'
WHERE page_key = 'repertoire' AND section_key = 'hero' AND lang = 'en';