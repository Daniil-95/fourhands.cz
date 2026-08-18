-- Artist photographs are shared between language versions; text remains localized.
UPDATE page_sections AS localized
INNER JOIN page_sections AS source
    ON source.page_key = localized.page_key
    AND source.section_key = localized.section_key
    AND source.lang = 'cs'
SET localized.image_path = source.image_path
WHERE localized.page_key = 'artists'
  AND localized.section_key IN ('katerina', 'irena');