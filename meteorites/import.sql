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
SET "lat" = ROUND("lat", 2)
WHERE "lat" IS NOT NULL;

UPDATE "meteorites_temp"
SET "long" = ROUND("long", 2)
WHERE "long" IS NOT NULL;

-- 2.5. Convert the year column to an integer
UPDATE "meteorites_temp"
SET "year" = CAST("year" AS INTEGER)
WHERE "year" IS NOT NULL;

-- All meteorites with the nametype “Relict” are not included in the meteorites table.
-- 3. Delete all rows with the nametype “Relict” from the meteorites_temp table
DELETE FROM "meteorites_temp"
WHERE "nametype" = 'Relict';


-- 4. Recreate the meteorites_temp table without the id column
CREATE TABLE "clean_meteorites" AS
SELECT
    "name", "class", "mass", "discovery", "year", "lat", "long"
FROM
    "meteorites_temp";

-- 5. Drop the old table that still has the id column
DROP TABLE "meteorites_temp";

-- 6. Create the final meteorites table with an auto-increment id
CREATE TABLE IF NOT EXISTS "meteorites" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT, 
    "class" TEXT,
    "mass" REAL,
    "discovery" TEXT,
    "year" INTEGER,
    "lat" REAL,
    "long" REAL
);

-- 7. Insert sorted data into the meteorites table
INSERT INTO "meteorites" ("name", "class", "mass", "discovery", "year", "lat", "long")
SELECT "name", "class", "mass", "discovery", "year", "lat", "long"
FROM "clean_meteorites"
ORDER BY "year", "name";

-- 8. Drop the temporary table as it is no longer needed
DROP TABLE "clean_meteorites";