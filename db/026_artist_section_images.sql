-- Fotky umělkyň se nově spravují přímo v sekcích stránky "Umělkyně".

UPDATE page_sections
SET image_path = 'images/katerina.jpg'
WHERE page_key = 'artists' AND section_key = 'katerina' AND image_path = '';

UPDATE page_sections
SET image_path = 'images/Irena.jpg'
WHERE page_key = 'artists' AND section_key = 'irena' AND image_path = '';
