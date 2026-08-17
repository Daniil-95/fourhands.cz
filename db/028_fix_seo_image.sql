-- Use an existing image for Open Graph previews.
UPDATE site_settings
SET value_text = 'images/slider2.jpg'
WHERE group_name = 'seo'
  AND key_name = 'og_image';