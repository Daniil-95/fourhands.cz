# fourhands.cz

Firemní webová prezentace a vlastní redakční systém (CMS) společnosti Fourhands vytvořený pomocí frameworku Nette.

## O projektu

Projekt fourhands.cz představuje moderní webovou aplikaci určenou pro prezentaci služeb společnosti Fourhands. Součástí řešení je veřejná část webu a vlastní administrace pro správu obsahu, událostí a médií.

Aplikace je postavena na frameworku Nette a využívá šablonovací systém Latte. Administrace umožňuje pohodlnou správu jednotlivých sekcí webu bez nutnosti zásahu do zdrojového kódu.

## Hlavní funkce

* Správa obsahu webu
* Správa událostí
* Správa médií a obrázků
* Vlastní administrátorské rozhraní
* Responzivní design
* Vícejazyčná podpora
* SEO optimalizovaná struktura

## Použité technologie

### Backend

* PHP 8
* Nette Framework
* Latte Templates
* MySQL

### Frontend

* HTML5
* CSS3
* JavaScript
* Font Awesome

## Struktura projektu

```text
app/
├── AdminModule/
├── FrontModule/
├── Model/
├── Security/

config/
├── common.neon
├── local.neon

www/
├── css/
├── images/

vendor/
```

## Architektura

Projekt využívá architekturu MVC poskytovanou frameworkem Nette.

Klíčové části aplikace:

* FrontModule – veřejná část webu
* AdminModule – administrátorské rozhraní
* ContentRepository – správa obsahu
* EventRepository – správa událostí
* MediaRepository – správa médií

## Autor

Daniil Andrushko
