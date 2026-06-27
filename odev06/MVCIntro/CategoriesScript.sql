CREATE TABLE "Categories"(
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Description" VARCHAR(250) NULL
);


INSERT INTO "Categories" ("Name", "Description") VALUES
    ('Roman','Roman açıklaması'),
    ('Edebiyat','Edebiyat açıklaması'),
    ('Bilim','Bilim açıklaması');

-- YENİ KATEGORİ EKLE
INSERT INTO "Categories" ("Name", "Description") VALUES 
    ('Tarih', 'Tarih açıklaması');

-- DETAY
SELECT * FROM "Categories" WHERE "Id" = 1;

-- SİL
DELETE FROM "Categories" WHERE "Id" = 2;

-- DÜZENLE
UPDATE "Categories" SET 
    "Name" = 'Roman',
    "Description" = 'Roman açıklaması 2'
WHERE "Id" = 3;