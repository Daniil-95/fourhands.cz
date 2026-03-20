# Fourhands on Nette + Latte

## What is implemented
- Nette 3 application skeleton with Latte templates.
- Public site (`Front:Homepage`) rendered from database content.
- Bilingual routing (`/cs` and `/en`).
- Admin module with login and CRUD:
  - Content blocks
  - Events
  - Media items
- SQL migration with base schema and admin user.
- Import script to move content from existing static HTML files into DB.

## Project structure
- `www/index.php` - front controller
- `app/Presentation/Front` - public site
- `app/Presentation/Admin` - admin panel
- `app/Model` - repositories
- `db/001_init.sql` - schema + base seed
- `bin/import-static-content.php` - import from `index.html` + `index-en.html`

## Install
1. Install dependencies:
   ```bash
   composer install
   ```
2. Import DB migration:
   ```bash
   mysql -u root fourhands < db/001_init.sql
   ```
3. Import full existing content from static files:
   ```bash
   php bin/import-static-content.php
   ```
4. Ensure Apache document root points to `www/`.

## Admin login
- URL: `/admin/sign`
- Username: `admin`
- Password: `ChangeMe123!`

Change the password immediately after first login by updating `admin_users.password_hash`.
