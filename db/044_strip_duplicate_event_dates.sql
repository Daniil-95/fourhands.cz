-- Remove date prefixes duplicated in event descriptions (date already stored in publish_date column).
-- Also fixes 5 English records whose publish_date was accidentally overwritten with an edit timestamp
-- instead of the real event date (corrected using the matching Czech record as source of truth).

-- Czech records
UPDATE news SET title = 'Opava.' WHERE id = 543;
UPDATE news SET title = 'Vysočanská radnice, v 19 h.' WHERE id = 542;
UPDATE news SET title = 'Kolín - Městský společenský dům, v 19 h.' WHERE id = 541;
UPDATE news SET title = 'Bystřice nad Pernštejnem - kulturní dům, v 19 h.' WHERE id = 540;
UPDATE news SET title = 'Knihovna Velké Popovice - Novoroční koncert, v 18 h.' WHERE id = 539;
UPDATE news SET title = 'Barokní sál Emauzského kláštera - Galakoncert, v 18:30 h. (spolupráce s uměleckou agenturou Fidelio).' WHERE id = 545;
UPDATE news SET title = 'Frenštát pod Radhoštěm - Dům Kultury, v 19h. (spolupráce s uměleckou agenturou GLOBART).' WHERE id = 547;
UPDATE news SET title = 'Tábor - Divadlo Oskara Nedbala - B. Smetana - Má Vlast, v 19 h.' WHERE id = 546;
UPDATE news SET title = 'Vysoká u Příbramě - Památník A. Dvořáka - Komponovaný pořad "Tanec v barvě árodní".' WHERE id = 548;
UPDATE news SET title = 'Velké Meziříčí - Jupiter Club, v 19 h. (spolupráce s uměleckou agenturou Globart).' WHERE id = 549;
UPDATE news SET title = 'Rájec - Jestřebí - Kulturní centrum, v 19 h. (spolupráce s uměleckou agenturou Globart).' WHERE id = 550;
UPDATE news SET title = 'Muzeum Bedřicha Smetany v Praze, v 18 h.' WHERE id = 551;
UPDATE news SET title = 'Přerov - Městský dům, v 19 h. (spolupráce s uměleckou agenturou Globart).' WHERE id = 552;
UPDATE news SET title = 'Ostrov, Stará radnice, v 17 h.' WHERE id = 554;
UPDATE news SET title = 'Velké Popovice, Knihovna, v 18 h.' WHERE id = 553;
UPDATE news SET title = 'Adventní koncert Libeňský zámeček, v 19 h.' WHERE id = 555;
UPDATE news SET title = 'Výchovné koncerty Knihovna Velké Popovice.' WHERE id = 556;
UPDATE news SET title = 'Říčany Babice - Koncert filmové hudby, v 19 h. v Kulturním domě.' WHERE id = 557;
UPDATE news SET title = 'Liberec - Palác Liebieg, koncert filmové hudby na letní scéně, v 14 h.' WHERE id = 558;
UPDATE news SET title = 'Praha Chodovská tvrz, v 19 h.' WHERE id = 559;
UPDATE news SET title = 'Praha, ZUŠ Jižní město.' WHERE id = 560;
UPDATE news SET title = 'Brno Bystrc, v 19h. (spolupráce s uměleckou agenturou GLOBART).' WHERE id = 562;
UPDATE news SET title = 'Památník A. Dvořáka - Má Vlast - koncert k 200letému výročí narození B. Smetany.' WHERE id = 561;
UPDATE news SET title = 'Třebíč, v 19h. (spolupráce s uměleckou agenturou GLOBART).' WHERE id = 563;
UPDATE news SET title = 'Vyškov, v 19h. (spolupráce s uměleckou agenturou GLOBART).' WHERE id = 564;
UPDATE news SET title = 'Knihovna V. Popovice, v 19h. Novoroční koncert: Slavné klasické a filmové melodie.' WHERE id = 565;
UPDATE news SET title = 'Výchovné koncerty knihovna V. Popovice.' WHERE id = 566;
UPDATE news SET title = 'Říčany Babice - KD.' WHERE id = 567;
UPDATE news SET title = 'Kostel sv. Vavřince pod Petřínem - B. Smetana “Má vlast”.' WHERE id = 568;
UPDATE news SET title = 'Chodovská tvrz “Tance v Proměnách”.' WHERE id = 569;
UPDATE news SET title = 'Vzorná knihovna Velké Popovice - Výchovné koncerty “Pohádkové balety”.' WHERE id = 570;
UPDATE news SET title = '“Tance v hudbě s projekci” Atrium na Žižkově.' WHERE id = 571;

-- English records
UPDATE news SET title = 'Emmaus Monastery – Baroque Refectory (in cooperation with agency Fidelio), 18:30.' WHERE id = 582;
UPDATE news SET title = 'Opava.' WHERE id = 581;
UPDATE news SET title = 'Vysočany Town Hall, 19:00.' WHERE id = 580;
UPDATE news SET title = 'Kolín – Municipal Social House, 19:00.' WHERE id = 579;
UPDATE news SET title = 'Bystřice nad Pernštejnem – Cultural centre, 19:00.' WHERE id = 578;
UPDATE news SET title = 'Knihovna Velké Popovice – New Year’s Concert, 18:00.' WHERE id = 577;
UPDATE news SET title = 'Baroque Hall of the Emmaus Monastery – Gala concert, 18:30 (in cooperation with agency Fidelio).' WHERE id = 583;
UPDATE news SET title = 'Frenštát pod Radhoštěm – House of Culture, 19:00 (in cooperation with agency GLOBART).' WHERE id = 585;
UPDATE news SET title = 'Tábor – Oskar Nedbal Theatre – B. Smetana – Má vlast, 19:00.' WHERE id = 584;
UPDATE news SET title = 'Vysoká u Příbramě – Antonín Dvořák Memorial – Programme “Dance in National Colours”.' WHERE id = 586;
UPDATE news SET title = 'Velké Meziříčí – Jupiter Club, 19:00 (in cooperation with agency Globart).' WHERE id = 587;
UPDATE news SET title = 'Rájec-Jestřebí – Cultural Centre, 19:00 (in cooperation with agency Globart).' WHERE id = 588;
UPDATE news SET title = 'Bedřich Smetana Museum, Prague, 18:00.' WHERE id = 589;
UPDATE news SET title = 'Přerov – Municipal House, 19:00 (in cooperation with agency Globart).' WHERE id = 590;
UPDATE news SET title = 'Ostrov, Old Town Hall, 17:00.' WHERE id = 592;
UPDATE news SET title = 'Velké Popovice, Library, 18:00.' WHERE id = 591;
UPDATE news SET title = 'Advent concert, Libeň Chateau, 19:00.' WHERE id = 593;
UPDATE news SET title = 'Educational concerts, Library Velké Popovice.' WHERE id = 594;
UPDATE news SET title = 'Říčany Babice – Concert of film music, 19:00, Cultural House.' WHERE id = 595;
UPDATE news SET title = 'Liberec – Liebieg Palace, concert of film music on the summer stage, 14:00.' WHERE id = 596;
UPDATE news SET title = 'Prague, Chodovská tvrz, 19:00.' WHERE id = 597;
UPDATE news SET title = 'Prague, Primary Art School Jižní Město.' WHERE id = 598;
UPDATE news SET title = 'Brno-Bystrc, 19:00 (in cooperation with agency GLOBART).' WHERE id = 600;
UPDATE news SET title = 'Antonín Dvořák Memorial – Má vlast – concert for the 200th anniversary of B. Smetana’s birth.' WHERE id = 599;
UPDATE news SET title = 'Třebíč, 19:00 (in cooperation with agency GLOBART).' WHERE id = 601;
UPDATE news SET title = 'Vyškov, 19:00 (in cooperation with agency GLOBART).' WHERE id = 602;
UPDATE news SET title = 'Library Velké Popovice, 19:00 – New Year’s concert: Famous classical and film melodies.' WHERE id = 603;
UPDATE news SET title = 'Educational concerts, Library Velké Popovice.' WHERE id = 604;
UPDATE news SET title = 'Říčany Babice – Cultural House.' WHERE id = 605;
UPDATE news SET title = 'Church of St. Lawrence under Petřín – B. Smetana “Má vlast”.' WHERE id = 606;
UPDATE news SET title = 'Chodovská tvrz – “Dances in Transformation”.' WHERE id = 607;
UPDATE news SET title = 'Library Velké Popovice – Educational concerts “Fairytale Ballets”.' WHERE id = 608;
UPDATE news SET title = '“Dances in Music with Projection”, Atrium Žižkov.' WHERE id = 609;

-- English records with publish_date corrected to match the Czech counterpart, then date prefix stripped
UPDATE news SET publish_date = '2022-12-22 00:00:00', title = 'Library Velké Popovice.' WHERE id = 610;
UPDATE news SET publish_date = '2022-12-19 00:00:00', title = 'Educational concerts – P. I. Tchaikovsky – The Nutcracker.' WHERE id = 611;
UPDATE news SET publish_date = '2022-06-14 00:00:00', title = 'University of Ostrava / Faculty of Fine Arts – Department of Keyboard Instruments – “Dancing Around the World”.' WHERE id = 612;
UPDATE news SET publish_date = '2022-05-06 00:00:00', title = 'Atrium Žižkov.' WHERE id = 613;
UPDATE news SET publish_date = '2022-03-15 00:00:00', title = 'Prague, Primary Art School Jižní Město.' WHERE id = 614;
