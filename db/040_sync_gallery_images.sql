INSERT INTO images (users_id, lang, file, title, subtitle, alt_text, crop, sort_order, active, created)
SELECT 3, 'en', file,
    CASE
        WHEN file LIKE '%kids1-thumb%' THEN 'Fourhands piano duo'
        WHEN file LIKE '%kids2-thumb%' THEN 'Fourhands performance'
        WHEN file LIKE '%kids3-thumb%' THEN 'Fourhands concert'
        WHEN file LIKE '%kids4-thumb%' THEN 'Fourhands musicians'
        WHEN file LIKE '%kids5-thumb%' THEN 'Fourhands on stage'
        WHEN file LIKE '%kids6-thumb%' THEN 'Fourhands piano performance'
        WHEN file LIKE '%kids7-thumb%' THEN 'Fourhands concert moment'
        WHEN file LIKE '%kids8-thumb%' THEN 'Fourhands live performance'
        WHEN file LIKE '%kids9-thumb%' THEN 'Fourhands musical evening'
        ELSE 'Fourhands photo'
    END,
    '',
    CASE
        WHEN file LIKE '%kids1-thumb%' THEN 'Fourhands piano duo'
        WHEN file LIKE '%kids2-thumb%' THEN 'Fourhands performance'
        WHEN file LIKE '%kids3-thumb%' THEN 'Fourhands concert'
        WHEN file LIKE '%kids4-thumb%' THEN 'Fourhands musicians'
        WHEN file LIKE '%kids5-thumb%' THEN 'Fourhands on stage'
        WHEN file LIKE '%kids6-thumb%' THEN 'Fourhands piano performance'
        WHEN file LIKE '%kids7-thumb%' THEN 'Fourhands concert moment'
        WHEN file LIKE '%kids8-thumb%' THEN 'Fourhands live performance'
        WHEN file LIKE '%kids9-thumb%' THEN 'Fourhands musical evening'
        ELSE 'Fourhands photo'
    END,
    crop, sort_order, active, NOW()
FROM images AS source
WHERE source.lang = 'cs'
  AND NOT EXISTS (
      SELECT 1 FROM images AS localized
      WHERE localized.lang = 'en' AND localized.file = source.file
  );