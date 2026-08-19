UPDATE media_translations translation
JOIN media_assets duplicate_asset ON duplicate_asset.id = translation.asset_id
JOIN media_assets canonical_asset
    ON canonical_asset.type = 'video'
   AND canonical_asset.embed_url = CASE duplicate_asset.embed_url
       WHEN 'https://www.youtube.com/watch?v=gpFoNt3N4oo' THEN 'https://youtu.be/gpFoNt3N4oo'
       WHEN 'https://www.youtube.com/watch?v=65J5ta7K_a8' THEN 'https://youtu.be/65J5ta7K_a8'
   END
SET translation.asset_id = canonical_asset.id
WHERE translation.lang = 'en'
  AND duplicate_asset.embed_url IN (
      'https://www.youtube.com/watch?v=gpFoNt3N4oo',
      'https://www.youtube.com/watch?v=65J5ta7K_a8'
  );

DELETE duplicate_asset
FROM media_assets duplicate_asset
WHERE duplicate_asset.type = 'video'
  AND duplicate_asset.embed_url IN (
      'https://www.youtube.com/watch?v=gpFoNt3N4oo',
      'https://www.youtube.com/watch?v=65J5ta7K_a8'
  );

UPDATE media_translations english
JOIN media_translations czech
        ON czech.asset_id = english.asset_id
     AND czech.lang = 'cs'
SET english.sort_order = czech.sort_order
WHERE english.lang = 'en';

INSERT INTO media_translations (asset_id, lang, title, description, sort_order, active, created)
SELECT a.id, 'en',
    CASE a.embed_url
        WHEN 'https://www.facebook.com/reel/941975404240005' THEN 'Bedřich Smetana - My Country (in one minute)'
        WHEN 'https://youtu.be/ZUR0WTwmEgU' THEN 'Aram Khachaturian - Sabre Dance'
        WHEN 'https://www.youtube.com/watch?v=uKAC7z6m65g' THEN 'Tchaikovsky: The Nutcracker - Dance of the Sugar Plum Fairy'
    END,
    '', czech.sort_order, czech.active, NOW()
FROM media_assets a
JOIN media_translations czech ON czech.asset_id = a.id AND czech.lang = 'cs'
WHERE a.type = 'video'
  AND a.embed_url IN (
      'https://www.facebook.com/reel/941975404240005',
      'https://youtu.be/ZUR0WTwmEgU',
      'https://www.youtube.com/watch?v=uKAC7z6m65g'
  )
  AND NOT EXISTS (
      SELECT 1 FROM media_translations existing
      WHERE existing.asset_id = a.id AND existing.lang = 'en'
  );