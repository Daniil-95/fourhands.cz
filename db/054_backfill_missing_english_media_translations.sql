INSERT INTO media_translations (asset_id, lang, title, description, alt_text, sort_order, active, created)
SELECT czech.asset_id,
       'en',
       '',
       '',
       '',
       czech.sort_order,
       czech.active,
       NOW()
FROM media_translations czech
LEFT JOIN media_translations english
       ON english.asset_id = czech.asset_id
      AND english.lang = 'en'
WHERE czech.lang = 'cs'
  AND english.id IS NULL;
