INSERT INTO roles (`role`, `description`, `inherits_from`, `order`)
VALUES ('admin', 'Administrator', NULL, 1)
ON DUPLICATE KEY UPDATE
    `description` = VALUES(`description`);

INSERT INTO users (`username`, `password`, `role`, `name`, `surname`, `active`, `registration_date`)
SELECT 'admin', '$2y$10$x7pVPxkfgqRy9MFKXiLjIezZe8d2Vc4KfjJqJWuRefKbtO36.CqL6', 'admin', 'Admin', 'User', 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE username = 'admin'
);

UPDATE users u
JOIN admin_users au ON au.username = 'admin'
SET
    u.password = au.password_hash,
    u.role = 'admin',
    u.active = 1
WHERE u.username = 'admin';

INSERT INTO users_roles (users_id, roles_id)
SELECT u.id, r.id
FROM users u
JOIN roles r ON r.role = 'admin'
LEFT JOIN users_roles ur ON ur.users_id = u.id AND ur.roles_id = r.id
WHERE u.username = 'admin' AND ur.users_id IS NULL;
