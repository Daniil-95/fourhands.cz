-- Stránka "O nás" má nově jedinou editovatelnou sekci (content).
-- Texty z původní sekce "hero" se přesouvají do sekce "content".

UPDATE page_sections c
JOIN page_sections h
    ON h.page_key = 'about' AND h.section_key = 'hero' AND h.lang = c.lang
SET c.title = h.title,
    c.subtitle = h.subtitle
WHERE c.page_key = 'about' AND c.section_key = 'content';

DELETE FROM page_sections WHERE page_key = 'about' AND section_key = 'hero';

UPDATE page_sections
SET image_path = 'images/slider2.jpg'
WHERE page_key = 'about' AND section_key = 'content' AND image_path = '';
