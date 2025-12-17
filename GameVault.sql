-- Bölüm 1: Tablo Oluşturma (DDL)
--Yukarıda belirtilen 4 tabloyu oluşturun (CREATE TABLE).
--İlişkileri (FOREIGN KEY) tanımlayın.

CREATE TABLE "developers"(
    "id" SERIAL NOT NULL,
    "company_name" VARCHAR(255) NOT NULL,
    "country" VARCHAR(100) NOT NULL,
    "founded_year" INTEGER NOT NULL
);
ALTER TABLE
    "developers" ADD PRIMARY KEY("id");
CREATE TABLE "games"(
    "id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    "release_date" DATE NOT NULL,
    "rating" DECIMAL(3, 2) NOT NULL,
    "developer_id" INTEGER NOT NULL
);
ALTER TABLE
    "games" ADD PRIMARY KEY("id");
CREATE TABLE "genres"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT NOT NULL
);
ALTER TABLE
    "genres" ADD PRIMARY KEY("id");
ALTER TABLE
    "genres" ADD CONSTRAINT "genres_name_unique" UNIQUE("name");
CREATE TABLE "games_genres"(
    "id" SERIAL NOT NULL,
    "game_id" INTEGER NOT NULL,
    "genre_id" INTEGER NOT NULL
);
ALTER TABLE
    "games_genres" ADD PRIMARY KEY("id");
ALTER TABLE
    "games_genres" ADD CONSTRAINT "games_genres_game_id_foreign" FOREIGN KEY("game_id") REFERENCES "games"("id") ON DELETE CASCADE;
ALTER TABLE
    "games" ADD CONSTRAINT "games_developer_id_foreign" FOREIGN KEY("developer_id") REFERENCES "developers"("id");
ALTER TABLE
    "games_genres" ADD CONSTRAINT "games_genres_genre_id_foreign" FOREIGN KEY("genre_id") REFERENCES "genres"("id");

--Bölüm 2: Veri Ekleme (DML - INSERT)
-- 1) 5 Adet Geliştirici Ekleme
INSERT INTO developers(company_name, country, founded_year) VALUES 
('Rockstar Games', 'United States', 1998),
('From Software', 'Japan', 1986),
('Relic Entertainment', 'Canada', 1997),
('Bethesda Game Studios', 'United States', 2001),
('CD Projekt Red', 'Poland', 1994);
-- 2) 5 Adet Tür Ekleme
INSERT INTO genres(name, description) VALUES 
('Open World', 'Games with large explorable environments and freedom'),
('RPG', 'Role-playing games with character development and story choices'),
('FPS', 'First-person shooter games'),
('Strategy', 'Strategy games'),
('Horror', 'Games designed to frighten and create tension');
-- 3) 10 Adet Oyun Ekleme (Her oyun bir firmaya bağlı)
INSERT INTO games(title, price, release_date, rating, developer_id) VALUES
('Grand Theft Auto V', 29.99, '2013-09-17', 9, 1),
('Dark Souls III', 39.99, '2016-04-12', 8.1, 2),
('Elden Ring', 59.99, '2022-02-25', 9.5, 2),
('Fallout 4', 19.99, '2015-11-10', 8, 4),
('The Elder Scrolls V: Skyrim', 19.99, '2011-11-11', 8.2, 4),
('Red Dead Redemption 2', 59.99, '2018-10-26', 9.6, 1),
('Cyberpunk 2077', 59.99, '2020-12-10', 7.5, 5),
('The Witcher 3: Wild Hunt', 39.99, '2015-05-19', 9, 5),
('Company Of Heroes', 19.99, '2006-09-12', 8, 3),
('Age Of Empires IV', 29.99, '2021-10-28', 8.5, 3);
-- 4) Oyun ve Tür Eşleştirmesi (games_genres tablosu üzerinden)
INSERT INTO games_genres(game_id, genre_id) VALUES
-- The Witcher 3: Open World + RPG
(8, 1),
(8, 2),
-- Cyberpunk 2077: Open World + RPG
(7, 1),
(7, 2),
-- GTA V: Open World
(1, 1),
-- Age Of Empires IV: Strategy
(10, 4),
-- Skyrim: Open World + RPG
(5, 1),
(5, 2),
-- Fallout 4: Open World + RPG + Horror
(4, 1),
(4, 2),
(4, 5),
-- Elden Ring: Open World + RPG
(3, 1),
(3, 2),
-- Dark Souls III: RPG + Horror
(2, 2),
(2, 5),
-- Age Of Empires IV: Strategy
(10, 4),
-- Company Of Heroes: Strategy
(9, 4);
-- BÖLÜM 3: GÜNCELLEME VE SİLME (UPDATE / DELETE)
-- 1) İndirim Zamanı: Tüm oyunların fiyatını %10 düşürme
UPDATE games SET price = price * 0.9;
-- 2) Hata Düzeltme: Bir oyunun puanını güncelleme (Örnek: Cyberpunk 2077'yi 7.8'den 9.0'a çıkarma)
UPDATE games SET rating = 9.0 WHERE title = 'Cyberpunk 2077';
-- 3) Kaldırma: Bir oyunu tamamen silme
-- NOT: games_genres tablosunda ON DELETE CASCADE tanımlı olduğu için
-- oyun silindiğinde ilişkili kayıtlar otomatik olarak silinir
DELETE FROM games WHERE title = 'Company Of Heroes';
-- BÖLÜM 4: RAPORLAMA (SELECT & JOIN)
-- 1) Tüm Oyunlar Listesi: Oyun adı, Fiyatı ve Geliştirici Firma Adı
SELECT
	g.title, g.price, d.company_name
FROM games g
JOIN developers d ON g.developer_id = d.id;
-- 2) Kategori Filtresi: Sadece "RPG" türündeki oyunların adı ve puanı
SELECT
	g.title, g.rating
FROM games g
JOIN games_genres gg ON g.id = gg.game_id
JOIN genres gen ON gg.genre_id = gen.id
WHERE gen.name = 'RPG';
-- 3) Fiyat Analizi: Fiyatı 30 USD üzerinde olan oyunları pahalıdan ucuza sıralama
SELECT 
	title, price
FROM games
WHERE price > 30
ORDER BY price DESC;
-- 4) Arama: İçinde "War" kelimesi geçen oyunları bulma
SELECT 
	title
FROM games 
WHERE title ILIKE '%War%';


