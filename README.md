# fourhands.cz

Webová prezentace klavírního uskupení **Fourhands** včetně vlastního redakčního systému (CMS) postaveného na frameworku Nette.

**Živý web:** [https://www.fourhands.cz](https://www.fourhands.cz)

---

## Obsah

- [O projektu](#o-projektu)
- [Hlavní funkce](#hlavní-funkce)
- [Použité technologie](#použité-technologie)
- [Požadavky](#požadavky)
- [Instalace a spuštění](#instalace-a-spuštění)
- [Konfigurace](#konfigurace)
- [Frontend build (SCSS)](#frontend-build-scss)
- [Struktura projektu](#struktura-projektu)
- [Architektura](#architektura)
- [Routování a lokalizace](#routování-a-lokalizace)
- [Databáze a migrace](#databáze-a-migrace)
- [Administrace](#administrace)
- [Bezpečnost a produkční nasazení](#bezpečnost-a-produkční-nasazení)
- [Autor](#autor)

---

## O projektu

Projekt tvoří dvě samostatné části:

- **FrontModule** – veřejná dvoujazyčná (čeština / angličtina) prezentace: úvodní stránka, profily umělkyň, repertoár, koncerty, fotogalerie, videogalerie, ohlasy z pódia a kontaktní formulář.
- **AdminModule** – vlastní administrace, která umožňuje spravovat veškerý obsah webu bez zásahu do zdrojového kódu.

Veškerý textový obsah, navigace i nastavení webu jsou uloženy v databázi vždy zvlášť pro každý jazyk (sloupec `lang` s hodnotami `cs` / `en`).

## Hlavní funkce

- Správa obsahu stránek po sekcích (`page_sections`)
- Správa koncertů a událostí včetně archivu
- Správa fotogalerie a videogalerie (YouTube)
- Správa publikací a ohlasů z médií
- Editovatelná navigace webu
- Nastavení webu a SEO metadat
- Kontaktní formulář s ukládáním poptávek a e-mailovou notifikací
- Dvoujazyčnost (cs/en) na frontendu i v administraci
- Přihlašování do administrace s logováním pokusů
- Responzivní design

## Použité technologie

### Backend

- PHP 8.2+
- Nette Framework 3.2 (`application`, `bootstrap`, `database`, `di`, `forms`, `http`, `security`, `utils`)
- Latte 3 – šablonovací systém
- Tracy 2.10 – ladicí nástroj
- MySQL 8 (utf8mb4, `utf8mb4_czech_ci`)

### Frontend

- HTML5, SCSS (Dart Sass 1.80), JavaScript (vanilla)
- Font Awesome

### Nástroje

- Composer (PHP závislosti, PSR-4 autoloading `App\` → `app/`)
- npm + Sass (kompilace stylů)

## Požadavky

- PHP >= 8.2
- MySQL 8+
- Composer
- Node.js (pro kompilaci SCSS; ověřeno na Node 20)
- Apache s `mod_rewrite`, document root musí směřovat do složky `www/`

## Instalace a spuštění

```bash
# 1) Závislosti
composer install
npm install

# 2) Databáze – import základního schématu a následně migrací z db/
mysql -u root fourhands < db/fourhands.sql

# 3) Lokální konfigurace
#    app/config/local.neon (není verzován) – viz sekce Konfigurace

# 4) Kompilace stylů
npm run build:css
```

Zapisovatelné musí být složky `temp/` a `log/`.

## Konfigurace

Konfigurace je rozdělena do tří souborů v `app/config/`:

| Soubor | Účel |
| --- | --- |
| `common.neon` | Sdílené nastavení – routování, mapování presenterů, registrace služeb a repozitářů |
| `local.neon` | Lokální vývoj (není ve verzování) – připojení k databázi |
| `www.neon` | Produkce – databáze, zabezpečení session, produkční režim |

O výběru konfigurace rozhoduje `bootstrap.php` podle hostitele: pro `fourhands.cz` a `www.fourhands.cz` se načte `www.neon` a vypne se ladicí režim, jinak se použije `local.neon` s aktivní Tracy.

Příklad `app/config/local.neon`:

```neon
database:
    dsn: 'mysql:host=127.0.0.1;dbname=fourhands'
    user: root
    password: ''
```

## Frontend build (SCSS)

```bash
npm run build:css   # jednorázová kompilace
npm run watch:css   # kompilace při každé změně souborů
```

| Zdroj | Výstup |
| --- | --- |
| `www/scss/style.scss` | `www/css/style.css` |
| `www/scss/admin.scss` | `www/css/admin.css` |

Soubory `www/css/*.css` a jejich source mapy jsou generované a nepatří do repozitáře.

## Autor

Daniil Andrushko