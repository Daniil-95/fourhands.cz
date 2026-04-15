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
- Import script to move content from existing static HTML files into DB.

## Project structure
- `www/index.php` - front controller
- `app/FrontModule` - public site (presenters + templates)
- `app/AdminModule` - admin panel (presenters + templates)
- `app/Common` - shared presenters and router
- `app/Model` - repositories
- `db/001_init.sql` - schema + base seed
- `db/002_auth_rbac.sql` - auth/RBAC extension + migration from `admin_users`
- `bin/import-static-content.php` - import from `index.html` + `index-en.html`

## Install
1. Install dependencies:
   ```bash
   composer install
   ```
2. Import DB migrations:
   ```bash
   mysql -u root fourhands < db/001_init.sql
   mysql -u root fourhands < db/002_auth_rbac.sql
   ```
3. Import full existing content from static files:
   ```bash
   php bin/import-static-content.php
   ```
4. Ensure Apache document root points to `www/`.

## Admin login
- URL: `/admin/sign`
- Username or email: `admin`
- Password: `ChangeMe123!`

Change the password immediately after first login by updating `admin_users.password_hash`.
