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


