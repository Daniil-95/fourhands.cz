-- Sync the public FourhandsPiano channel without duplicating existing video IDs.

INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'BedЕ™ich Smetana: MГЎ vlast / My Country DEMO', '', 'https://www.youtube.com/watch?v=w5Tr2hSzJQo', 'https://www.youtube.com/watch?v=w5Tr2hSzJQo', '', 20, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%w5Tr2hSzJQo%' OR file LIKE '%w5Tr2hSzJQo%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'TЕ™i oЕ™Г­ЕЎky pro Popelku Piano Four hands', '', 'https://www.youtube.com/watch?v=gZJ1UyuayJA', 'https://www.youtube.com/watch?v=gZJ1UyuayJA', '', 30, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%gZJ1UyuayJA%' OR file LIKE '%gZJ1UyuayJA%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'G.Gershwin: Rhapsody in Blue for Piano, Four Hands DEMO', '', 'https://www.youtube.com/watch?v=Q0YuX-feyds', 'https://www.youtube.com/watch?v=Q0YuX-feyds', '', 40, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%Q0YuX-feyds%' OR file LIKE '%Q0YuX-feyds%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'A.DvoЕ™ГЎk: Slavonic Dances op. 72 No. 4', '', 'https://www.youtube.com/watch?v=m13ZqMG1uL4', 'https://www.youtube.com/watch?v=m13ZqMG1uL4', '', 50, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%m13ZqMG1uL4%' OR file LIKE '%m13ZqMG1uL4%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'A. DvoЕ™ГЎk: Symphony No. 9 вЂFrom the New WorldвЂ™, IV. Allegro con fuoco Demo piano Fourhands duo', '', 'https://www.youtube.com/watch?v=cxNEAlWuyC8', 'https://www.youtube.com/watch?v=cxNEAlWuyC8', '', 60, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%cxNEAlWuyC8%' OR file LIKE '%cxNEAlWuyC8%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'Johannes Brahms - Hungarian Dance No. 6', '', 'https://www.youtube.com/watch?v=xeZs4zv2c_A', 'https://www.youtube.com/watch?v=xeZs4zv2c_A', '', 70, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%xeZs4zv2c_A%' OR file LIKE '%xeZs4zv2c_A%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'A. DvoЕ™ГЎk - SlovanskГ© tance, 2. Е™ada, op. 72, ДЌ. 7 Allegro vivace "Kolo"', '', 'https://www.youtube.com/watch?v=c_8a0uf771o', 'https://www.youtube.com/watch?v=c_8a0uf771o', '', 80, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%c_8a0uf771o%' OR file LIKE '%c_8a0uf771o%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'Mendelsohn Trio D moll 1.', '', 'https://www.youtube.com/watch?v=sHeAILLzygE', 'https://www.youtube.com/watch?v=sHeAILLzygE', '', 210, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%sHeAILLzygE%' OR file LIKE '%sHeAILLzygE%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'S. Rachmaninov Piano Concerto No. 3 Iryna Cherkashyna', '', 'https://www.youtube.com/watch?v=HCD_-Ur4J6U', 'https://www.youtube.com/watch?v=HCD_-Ur4J6U', '', 220, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%HCD_-Ur4J6U%' OR file LIKE '%HCD_-Ur4J6U%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'F.Chopin Nokturne Des-dur в„–2 РѕСЂ.27', '', 'https://www.youtube.com/watch?v=YAEpNiIx-7k', 'https://www.youtube.com/watch?v=YAEpNiIx-7k', '', 230, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%YAEpNiIx-7k%' OR file LIKE '%YAEpNiIx-7k%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'F. Liszt Koncert в„–2 A-dur', '', 'https://www.youtube.com/watch?v=5ULUD82bcNg', 'https://www.youtube.com/watch?v=5ULUD82bcNg', '', 240, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%5ULUD82bcNg%' OR file LIKE '%5ULUD82bcNg%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'Рќ Р Р°РєРѕРІ РЎРѕРЅР°С‚Р° РґР»СЏ СЃРєСЂРёРїРєРё Рё С„-РЅРѕ 1С‡', '', 'https://www.youtube.com/watch?v=iiNn7Iw_V6g', 'https://www.youtube.com/watch?v=iiNn7Iw_V6g', '', 250, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%iiNn7Iw_V6g%' OR file LIKE '%iiNn7Iw_V6g%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'cs', 'РњРѕС†Р°СЂС‚ РЎРѕРЅР°С‚Р° C dur РґР»СЏ С„-РЅРѕ Рё СЃРєСЂРёРїРєРё', '', 'https://www.youtube.com/watch?v=gj9OFbT-P1Y', 'https://www.youtube.com/watch?v=gj9OFbT-P1Y', '', 260, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'cs' AND (embed LIKE '%gj9OFbT-P1Y%' OR file LIKE '%gj9OFbT-P1Y%'));

INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'ANTONIN DVORAK - SLAVONIC DANCE No. 8, OP. 46 - "FURIANT"', '', 'https://www.youtube.com/watch?v=KGHa_fblkXo', 'https://www.youtube.com/watch?v=KGHa_fblkXo', '', 10, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%KGHa_fblkXo%' OR file LIKE '%KGHa_fblkXo%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'BedЕ™ich Smetana: My Country / MГЎ vlast DEMO', '', 'https://www.youtube.com/watch?v=w5Tr2hSzJQo', 'https://www.youtube.com/watch?v=w5Tr2hSzJQo', '', 20, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%w5Tr2hSzJQo%' OR file LIKE '%w5Tr2hSzJQo%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Three Hazelnuts for Cinderella - piano four hands', '', 'https://www.youtube.com/watch?v=gZJ1UyuayJA', 'https://www.youtube.com/watch?v=gZJ1UyuayJA', '', 30, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%gZJ1UyuayJA%' OR file LIKE '%gZJ1UyuayJA%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Gershwin: Rhapsody in Blue for Piano, Four Hands DEMO', '', 'https://www.youtube.com/watch?v=Q0YuX-feyds', 'https://www.youtube.com/watch?v=Q0YuX-feyds', '', 40, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%Q0YuX-feyds%' OR file LIKE '%Q0YuX-feyds%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Slavonic Dances op. 72 No. 4', '', 'https://www.youtube.com/watch?v=m13ZqMG1uL4', 'https://www.youtube.com/watch?v=m13ZqMG1uL4', '', 50, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%m13ZqMG1uL4%' OR file LIKE '%m13ZqMG1uL4%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Symphony No. 9 вЂњFrom the New WorldвЂќ, IV. Allegro con fuoco - Fourhands demo', '', 'https://www.youtube.com/watch?v=cxNEAlWuyC8', 'https://www.youtube.com/watch?v=cxNEAlWuyC8', '', 60, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%cxNEAlWuyC8%' OR file LIKE '%cxNEAlWuyC8%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Johannes Brahms - Hungarian Dance No. 6', '', 'https://www.youtube.com/watch?v=xeZs4zv2c_A', 'https://www.youtube.com/watch?v=xeZs4zv2c_A', '', 70, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%xeZs4zv2c_A%' OR file LIKE '%xeZs4zv2c_A%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk - Slavonic Dances, Series 2, op. 72 No. 7 "Kolo"', '', 'https://www.youtube.com/watch?v=c_8a0uf771o', 'https://www.youtube.com/watch?v=c_8a0uf771o', '', 80, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%c_8a0uf771o%' OR file LIKE '%c_8a0uf771o%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Smetana: My Country - Blanik', '', 'https://www.youtube.com/watch?v=gpFoNt3N4oo', 'https://www.youtube.com/watch?v=gpFoNt3N4oo', '', 90, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%gpFoNt3N4oo%' OR file LIKE '%gpFoNt3N4oo%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Smetana: My Country - VyЕЎehrad', '', 'https://www.youtube.com/watch?v=i22GyhUMFdQ', 'https://www.youtube.com/watch?v=i22GyhUMFdQ', '', 100, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%i22GyhUMFdQ%' OR file LIKE '%i22GyhUMFdQ%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Smetana: My Country - From Bohemian Woods and Groves', '', 'https://www.youtube.com/watch?v=LzugaT-BlyE', 'https://www.youtube.com/watch?v=LzugaT-BlyE', '', 110, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%LzugaT-BlyE%' OR file LIKE '%LzugaT-BlyE%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Smetana: My Country - Е ГЎrka', '', 'https://www.youtube.com/watch?v=sUJlL1Amz-4', 'https://www.youtube.com/watch?v=sUJlL1Amz-4', '', 120, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%sUJlL1Amz-4%' OR file LIKE '%sUJlL1Amz-4%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Smetana: My Country - Vltava', '', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', '', 130, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%kPcXeCDpgvA%' OR file LIKE '%kPcXeCDpgvA%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Smetana: My Country - Tabor', '', 'https://www.youtube.com/watch?v=QjhJf8f-UvA', 'https://www.youtube.com/watch?v=QjhJf8f-UvA', '', 140, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%QjhJf8f-UvA%' OR file LIKE '%QjhJf8f-UvA%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Slavonic Dance No. 8 in G minor, Furiant', '', 'https://www.youtube.com/watch?v=AUAlcoFSTD0', 'https://www.youtube.com/watch?v=AUAlcoFSTD0', '', 150, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%AUAlcoFSTD0%' OR file LIKE '%AUAlcoFSTD0%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Slavonic Dance No. 7 in C minor, SkoДЌnГЎ', '', 'https://www.youtube.com/watch?v=y6A9lVS71UY', 'https://www.youtube.com/watch?v=y6A9lVS71UY', '', 160, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%y6A9lVS71UY%' OR file LIKE '%y6A9lVS71UY%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Slavonic Dance No. 5 in A major, SkoДЌnГЎ', '', 'https://www.youtube.com/watch?v=Jv5hB-_lgtM', 'https://www.youtube.com/watch?v=Jv5hB-_lgtM', '', 170, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%Jv5hB-_lgtM%' OR file LIKE '%Jv5hB-_lgtM%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Slavonic Dance No. 2 in E minor, Dumka', '', 'https://www.youtube.com/watch?v=IZKmkxSB0Rg', 'https://www.youtube.com/watch?v=IZKmkxSB0Rg', '', 180, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%IZKmkxSB0Rg%' OR file LIKE '%IZKmkxSB0Rg%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'DvoЕ™ГЎk: Slavonic Dance No. 1 in C major, Furiant', '', 'https://www.youtube.com/watch?v=Di0srOkj2b4', 'https://www.youtube.com/watch?v=Di0srOkj2b4', '', 190, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%Di0srOkj2b4%' OR file LIKE '%Di0srOkj2b4%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Tchaikovsky: Swan Lake - Overture', '', 'https://www.youtube.com/watch?v=65J5ta7K_a8', 'https://www.youtube.com/watch?v=65J5ta7K_a8', '', 200, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%65J5ta7K_a8%' OR file LIKE '%65J5ta7K_a8%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Mendelssohn Trio in D minor, I', '', 'https://www.youtube.com/watch?v=sHeAILLzygE', 'https://www.youtube.com/watch?v=sHeAILLzygE', '', 210, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%sHeAILLzygE%' OR file LIKE '%sHeAILLzygE%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Rachmaninoff: Piano Concerto No. 3 - Iryna Cherkashyna', '', 'https://www.youtube.com/watch?v=HCD_-Ur4J6U', 'https://www.youtube.com/watch?v=HCD_-Ur4J6U', '', 220, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%HCD_-Ur4J6U%' OR file LIKE '%HCD_-Ur4J6U%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Chopin: Nocturne in D-flat major No. 2, Op. 27', '', 'https://www.youtube.com/watch?v=YAEpNiIx-7k', 'https://www.youtube.com/watch?v=YAEpNiIx-7k', '', 230, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%YAEpNiIx-7k%' OR file LIKE '%YAEpNiIx-7k%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Liszt: Piano Concerto No. 2 in A major', '', 'https://www.youtube.com/watch?v=5ULUD82bcNg', 'https://www.youtube.com/watch?v=5ULUD82bcNg', '', 240, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%5ULUD82bcNg%' OR file LIKE '%5ULUD82bcNg%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'N. Rakov: Sonata for violin and piano, I', '', 'https://www.youtube.com/watch?v=iiNn7Iw_V6g', 'https://www.youtube.com/watch?v=iiNn7Iw_V6g', '', 250, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%iiNn7Iw_V6g%' OR file LIKE '%iiNn7Iw_V6g%'));
INSERT INTO videos (users_id, lang, title, description, file, embed, ratio, sort_order, active, created)
SELECT 3, 'en', 'Mozart: Sonata in C major for piano and violin', '', 'https://www.youtube.com/watch?v=gj9OFbT-P1Y', 'https://www.youtube.com/watch?v=gj9OFbT-P1Y', '', 260, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM videos WHERE lang = 'en' AND (embed LIKE '%gj9OFbT-P1Y%' OR file LIKE '%gj9OFbT-P1Y%'));

