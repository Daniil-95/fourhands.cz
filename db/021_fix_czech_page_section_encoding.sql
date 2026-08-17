UPDATE page_sections
SET title = CONVERT(0x506F736C6F756368656A7465207369 USING utf8mb4),
    button_text = CONVERT(0x5A6F6272617A69742076C5B16563686E61207669646561 USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'homepage' AND section_key = 'videos';

UPDATE page_sections
SET title = CONVERT(0x506CC3A16E756A65746520616B63693F USING utf8mb4),
    subtitle = CONVERT(0x52C3A164692076C3A16D207A616872616A656D652E USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'homepage' AND section_key = 'contact';

UPDATE page_sections
SET subtitle = CONVERT(0x507261C5BE736BC3A1206B6C6176C3AD726EC3AD2064756F2070726F20C48D7479C5BE692072756365206120647661206B6C6176C3AD72792E USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'about' AND section_key = 'hero';

UPDATE page_sections
SET title = CONVERT(0x4F206EC3A173 USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'about' AND section_key = 'content';

UPDATE page_sections
SET title = CONVERT(0x556DC49B6C6B796EC49B USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'artists' AND section_key = 'hero';

UPDATE page_sections
SET title = CONVERT(0x4B617465C599696E61204B6F6E6F706F76C3A1 USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'artists' AND section_key = 'katerina';

UPDATE page_sections
SET title = CONVERT(0x4972656E6120416E647275C5A16B6F USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'artists' AND section_key = 'irena';

UPDATE page_sections
SET title = CONVERT(0x5265706572746FC3A172 USING utf8mb4),
    subtitle = CONVERT(0x48756462612070726F2076C3BD6A696D65C48D6EC3A9206F6B616DC5BE696B792E USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'repertoire' AND section_key = 'hero';

UPDATE page_sections
SET title = CONVERT(0x4E6162C3AD646B612070726F6772616DC5AF USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'repertoire' AND section_key = 'content';

UPDATE page_sections
SET title = CONVERT(0x5A2070C3B3646961 USING utf8mb4),
    subtitle = CONVERT(0xC48C6CC3A16E6B792C20726F7A686F766F72792C207075626C696B6163652061207A6DC3AD6E6B79206F20466F757268616E64732E USING utf8mb4)
WHERE lang = 'cs' AND page_key = 'from_stage' AND section_key = 'hero';