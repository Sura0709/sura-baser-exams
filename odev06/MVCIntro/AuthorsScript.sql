CREATE TABLE "Authors"(
    "Id" SERIAL PRIMARY KEY,
    "FirstName" VARCHAR(100) NOT NULL,
    "LastName" VARCHAR(100) NOT NULL,
    "Age" INT NOT NULL
);


INSERT INTO "Authors" ("FirstName", "LastName", "Age") VALUES
    ('Fyodor', 'Dostoyevski', 44),
    ('Leo', 'Tolstoy', 82),
    ('Franz', 'Kafka', 40);


-- YAZAR LİSTELEME
SELECT * FROM "Authors";

-- DETAY
SELECT * FROM "Authors"
WHERE "Id" = 1; 

-- YENİ YAZAR EKLE
INSERT INTO "Authors" ("FirstName", "LastName", "Age") VALUES 
    ('Orhan', 'Pamuk', 71);

-- DÜZENLE
UPDATE "Authors" SET 
    "FirstName" = 'Güncellenmiş Ad',
    "LastName" = 'Güncellenmiş Soyad',
    "Age" = 50
WHERE "Id" = 2; 

-- SİL
DELETE FROM "Authors"
WHERE "Id" = 3;