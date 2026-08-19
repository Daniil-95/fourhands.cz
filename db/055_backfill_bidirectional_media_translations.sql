INSERT INTO media_translations (asset_id, lang, title, description, alt_text, sort_order, active, created)
SELECT source.asset_id,
       'en',
       '',
       '',
       '',
       source.sort_order,
       source.active,
       NOW()
FROM media_translations source
LEFT JOIN media_translations target
       ON target.asset_id = source.asset_id
      AND target.lang = 'en'
WHERE source.lang = 'cs'
  AND target.id IS NULL;

INSERT INTO media_translations (asset_id, lang, title, description, alt_text, sort_order, active, created)
SELECT source.asset_id,
       'cs',
       '',
       '',
       '',
       source.sort_order,
       source.active,
       NOW()
FROM media_translations source
LEFT JOIN media_translations target
       ON target.asset_id = source.asset_id
      AND target.lang = 'cs'
WHERE source.lang = 'en'
  AND target.id IS NULL;
