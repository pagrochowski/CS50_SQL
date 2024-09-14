--Importing raw data from csv file into meteorites_temp table
.mode csv
.headers on
.import meteorites.csv meteorites_temp
.echo on

-- Cleaning up raw data
-- 1. These values should be NULL in the meteorites table.
UPDATE "meteorites_temp"
SET "mass" = NULL
WHERE "mass" = '';

UPDATE "meteorites_temp"
SET "year" = NULL
WHERE "year" = '';

UPDATE "meteorites_temp"
SET "lat" = NULL
WHERE "lat" = '';

UPDATE "meteorites_temp"
SET "long" = NULL
WHERE "long" = '';

-- 2. Round the mass, lat, and long columns to 2 decimal places
UPDATE "meteorites_temp"
SET "mass" = ROUND("mass", 2)
WHERE "mass" IS NOT NULL;

UPDATE "meteorites_temp"
SET "lat" = ROUND("mass", 2)
WHERE "lat" IS NOT NULL;

UPDATE "meteorites_temp"
SET "long" = ROUND("mass", 2)
WHERE "long" IS NOT NULL;

-- 2.5. Convert the year column to an integer
UPDATE "meteorites_temp"
SET "year" = CAST("year" AS INTEGER)
WHERE "year" IS NOT NULL;

-- All meteorites with the nametype “Relict” are not included in the meteorites table.
-- 3. Delete all rows with the nametype “Relict” from the meteorites_temp table
DELETE FROM "meteorites_temp"
WHERE "nametype" = 'Relict';

-- The meteorites are sorted by year, oldest to newest, and then—if any two meteorites landed in the same year—by name, in alphabetical order.
-- 4. Sort the meteorites_temp table by year, oldest to newest, and then if any two meteorites landed in the same year, by name, in alphabetical order
CREATE INDEX IF NOT EXISTS "idx_year_name" ON "meteorites_temp" ("year", "name");


-- Creating meteorites table
CREATE TABLE IF NOT EXISTS "meteorites" (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    class TEXT,
    mass INTEGER,
    discovery TEXT,
    year INTEGER,
    lat INTEGER,
    long INTEGER
);

