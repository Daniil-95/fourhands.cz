CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(64) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(32) NOT NULL DEFAULT 'admin',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE IF NOT EXISTS content_blocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `lang` CHAR(2) NOT NULL,
    key_name VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content_html LONGTEXT NOT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_lang_key (`lang`, key_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `lang` CHAR(2) NOT NULL,
    type ENUM('upcoming','past') NOT NULL,
    event_date DATE NULL,
    description TEXT NOT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE IF NOT EXISTS media_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `lang` CHAR(2) NOT NULL,
    type ENUM('photo','video') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    image_path VARCHAR(255) NULL,
    url VARCHAR(500) NULL,
    sort_order INT NOT NULL DEFAULT 100,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

INSERT INTO admin_users (username, password_hash, role)
VALUES ('admin', '$2y$10$x7pVPxkfgqRy9MFKXiLjIezZe8d2Vc4KfjJqJWuRefKbtO36.CqL6', 'admin')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO content_blocks (`lang`, key_name, title, content_html, sort_order) VALUES
('cs', 'about', 'O nás', '<p>Klavírní duo Fourhands vzniklo v roce 2021. Tento obsah upravujte v administraci.</p>', 10),
('en', 'about', 'About us', '<p>The piano duo Fourhands started in 2021. Edit this content in admin.</p>', 10),
('cs', 'performances', 'Naše vystoupení', '', 20),
('en', 'performances', 'Performances', '', 20),
('cs', 'artist_katerina', 'Kateřina Konopová', '<p>Biografie umělkyně.</p>', 30),
('en', 'artist_katerina', 'Katerina Konopova', '<p>Artist biography.</p>', 30),
('cs', 'artist_irena', 'Irena Andruško', '<p>Biografie umělkyně.</p>', 40),
('en', 'artist_irena', 'Irena Andrusko', '<p>Artist biography.</p>', 40),
('cs', 'program', 'Nabídka programů', '<p>Seznam programů.</p>', 50),
('en', 'program', 'Programmes', '<p>Program list.</p>', 50),
('cs', 'contacts', 'Kontakty', '<div class="row"><div class="col-1-3"><div class="wrap-col"><i class="fa fa-map-marker"></i><h3>Adresa</h3><p>Středočeský kraj, Praha-Újezd, 149 00</p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-phone"></i><h3>Manažerka</h3><p><span>Šárka Belovická:</span> <a href="mailto:fourhandsmanager@seznam.cz">fourhandsmanager@seznam.cz</a></p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-envelope"></i><h3>E-maily</h3><p><span>Irina:</span> <a href="mailto:cherkashynairina@gmail.com">cherkashynairina@gmail.com</a><br><span>Kateřina:</span> <a href="mailto:konopova.ka@seznam.cz">konopova.ka@seznam.cz</a></p></div></div></div>', 60),
('en', 'contacts', 'Contacts', '<div class="row"><div class="col-1-3"><div class="wrap-col"><i class="fa fa-map-marker"></i><h3>Address</h3><p>Central Bohemian Region, Praha-Újezd, 149 00</p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-phone"></i><h3>Manager</h3><p><span>Šárka Belovická:</span> <a href="mailto:fourhandsmanager@seznam.cz">fourhandsmanager@seznam.cz</a></p></div></div><div class="col-1-3"><div class="wrap-col"><i class="fa fa-envelope"></i><h3>E-mails</h3><p><span>Irina:</span> <a href="mailto:cherkashynairina@gmail.com">cherkashynairina@gmail.com</a><br><span>Katerina:</span> <a href="mailto:konopova.ka@seznam.cz">konopova.ka@seznam.cz</a></p></div></div></div>', 60),
('cs', 'copyright', 'Copyright', 'Copyright 2026 Fourhands. Všechna práva vyhrazena.', 99),
('en', 'copyright', 'Copyright', 'Copyright 2026 Fourhands. All rights reserved.', 99)
ON DUPLICATE KEY UPDATE title = VALUES(title), content_html = VALUES(content_html), sort_order = VALUES(sort_order);

INSERT INTO events (`lang`, type, event_date, description, sort_order) VALUES
('cs', 'upcoming', '2026-04-23', '23.4.2026 - Vysočanská radnice, v 19 h.', 10),
('cs', 'upcoming', '2026-10-01', '1.10.2026 - Opava.', 20),
('en', 'upcoming', '2026-04-23', '23.4.2026 - Vysocany Town Hall, 19:00.', 10),
('en', 'upcoming', '2026-10-01', '1.10.2026 - Opava.', 20),
('cs', 'past', '2025-11-12', '12.11.2025 - Barokní sál Emauzského kláštera - Galakoncert, v 18:30 h.', 10),
('en', 'past', '2025-11-12', '12.11.2025 - Emmaus Monastery - Gala concert, 18:30.', 10);

INSERT INTO media_items (`lang`, type, title, description, image_path, url, sort_order) VALUES
('cs', 'photo', 'Koncert', 'Ukázková fotografie.', 'images/kids1-thumb.jpg', NULL, 10),
('en', 'photo', 'Concert', 'Sample photo.', 'images/kids1-thumb.jpg', NULL, 10),
('cs', 'video', 'Moldau', 'Čtyřruční úprava pro klavír', 'images/kids2-thumb.jpg', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', 10),
('en', 'video', 'Moldau', 'Four-hand arrangement for piano', 'images/kids2-thumb.jpg', 'https://www.youtube.com/watch?v=kPcXeCDpgvA', 10);
