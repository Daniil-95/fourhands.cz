# Fourhands on Nette + Latte

## What is implemented
- Nette 3 application skeleton with Latte templates.
- Public site (`Front:Homepage`) rendered from database content.
- Bilingual routing (`/cs` and `/en`).
- Admin module with login and CRUD:
  - Content blocks
  - Events
  - Media items
- Extended admin auth model (users, roles, users-to-roles, login logs)
- SQL migration with base schema and admin user.
- Import script to pull content from live old site into DB.

## Project structure
- `www/index.php` - front controller
- `app/FrontModule` - public site (presenters + templates)
- `app/AdminModule` - admin panel (presenters + templates)
- `app/Common` - shared presenters and router
- `app/Model` - repositories
- `db/006_borovice_schema.sql` - baseline DB schema
- `db/007_sync_fourhands_to_borovice_schema.sql` - schema sync for `fourhands`
- `bin/import-static-content-borovice.php` - import from `https://fourhands.cz`

## Install
1. Install dependencies:
   ```bash
   composer install
   ```
2. Import DB schema:
   ```bash
   mysql -u root fourhands < db/007_sync_fourhands_to_borovice_schema.sql
   ```
3. Import full existing content from old live site:
   ```bash
   php bin/import-static-content-borovice.php
   ```
4. Ensure Apache document root points to `www/`.

## Admin login
- URL: `/admin/sign`
- Username or email: `admin`
- Password: `ChangeMe123!`

Change the password immediately after first login by updating `users.password`.
