SET NAMES utf8mb4;

DELETE FROM text_snippets
WHERE code IN (
    'about', 'performances', 'artist_katerina', 'artist_irena', 'program', 'contacts', 'copyright'
);

INSERT INTO text_snippets (code, lang, content, created) VALUES
('about', 'cs', '<p>Klavírní duo Fourhands vzniklo v roce 2021. Tento obsah upravujte v administraci.</p>', NOW()),
('about', 'en', '<p>The piano duo Fourhands started in 2021. Edit this content in admin.</p>', NOW()),
('performances', 'cs', '', NOW()),
('performances', 'en', '', NOW()),
('artist_katerina', 'cs', '<p>Biografie umělkyně.</p>', NOW()),
('artist_katerina', 'en', '<p>Artist biography.</p>', NOW()),
('artist_irena', 'cs', '<p>Biografie umělkyně.</p>', NOW()),
('artist_irena', 'en', '<p>Artist biography.</p>', NOW()),
('program', 'cs', '<p>Seznam programů.</p>', NOW()),
('program', 'en', '<p>Program list.</p>', NOW()),
('contacts', 'cs', '<div class="row"><div class="col-1-3"><div class="wrap-col"><i class="fa fa-map-marker"></i><h3>Adresa</h3><p>Středočeský kraj, Praha-Újezd, 149 00</p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-phone"></i><h3>Manažerka</h3><p><span>Šárka Belovická:</span> <a href="mailto:fourhandsmanager@seznam.cz">fourhandsmanager@seznam.cz</a></p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-envelope"></i><h3>E-maily</h3><p><span>Irina:</span> <a href="mailto:cherkashynairina@gmail.com">cherkashynairina@gmail.com</a><br><span>Kateřina:</span> <a href="mailto:konopova.ka@seznam.cz">konopova.ka@seznam.cz</a></p></div></div></div>', NOW()),
('contacts', 'en', '<div class="row"><div class="col-1-3"><div class="wrap-col"><i class="fa fa-map-marker"></i><h3>Address</h3><p>Central Bohemian Region, Praha-Újezd, 149 00</p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-phone"></i><h3>Manager</h3><p><span>Šárka Belovická:</span> <a href="mailto:fourhandsmanager@seznam.cz">fourhandsmanager@seznam.cz</a></p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-envelope"></i><h3>E-mails</h3><p><span>Irina:</span> <a href="mailto:cherkashynairina@gmail.com">cherkashynairina@gmail.com</a><br><span>Katerina:</span> <a href="mailto:konopova.ka@seznam.cz">konopova.ka@seznam.cz</a></p></div></div></div>', NOW()),
('copyright', 'cs', 'Copyright 2026 Fourhands. Všechna práva vyhrazena.', NOW()),
('copyright', 'en', 'Copyright 2026 Fourhands. All rights reserved.', NOW());

DELETE FROM news;
INSERT INTO news (title, publish_date, articles_id, lang, active, created) VALUES
('23.4.2026 - Vysočanská radnice, v 19 h.', '2026-04-23 19:00:00', NULL, 'cs', 1, NOW()),
('1.10.2026 - Opava.', '2026-10-01 19:00:00', NULL, 'cs', 1, NOW()),
('23.4.2026 - Vysocany Town Hall, 19:00.', '2026-04-23 19:00:00', NULL, 'en', 1, NOW()),
('1.10.2026 - Opava.', '2026-10-01 19:00:00', NULL, 'en', 1, NOW()),
('12.11.2025 - Barokní sál Emauzského kláštera - Galakoncert, v 18:30 h.', '2025-11-12 18:30:00', NULL, 'cs', 1, NOW()),
('12.11.2025 - Emmaus Monastery - Gala concert, 18:30.', '2025-11-12 18:30:00', NULL, 'en', 1, NOW());

SET @admin_user_id = (SELECT id FROM users WHERE username = 'admin' LIMIT 1);
SET @fallback_user_id = (SELECT id FROM users ORDER BY id ASC LIMIT 1);
SET @seed_user_id = COALESCE(@admin_user_id, @fallback_user_id);

DELETE FROM images;
INSERT INTO images (users_id, file, title, subtitle, crop, created) VALUES
(@seed_user_id, 'images/kids1-thumb.jpg', 'Koncert', 'Ukázková fotografie.', 0, NOW()),
(@seed_user_id, 'images/kids1-thumb.jpg', 'Concert', 'Sample photo.', 0, NOW());

DELETE FROM videos;
INSERT INTO videos (users_id, title, file, embed, ratio, created) VALUES
(@seed_user_id, 'Moldau', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', '16:9', NOW()),
(@seed_user_id, 'Moldau', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', '16:9', NOW());
