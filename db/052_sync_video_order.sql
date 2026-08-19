UPDATE media_translations english
JOIN media_translations czech
    ON czech.asset_id = english.asset_id
   AND czech.lang = 'cs'
SET english.sort_order = czech.sort_order
WHERE english.lang = 'en';