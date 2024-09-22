-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Find all translators who do software translation for ENG - GER language pair
SELECT DISTINCT supplier_name, supplier_code
FROM LinguistServices
WHERE language_pair = 'ENG - GER'
AND service_type = 'Translation'
AND sub_service_type = 'Software';

-- Find all revisors who do documentation revision for ENG - ITA language pair
SELECT DISTINCT supplier_name, supplier_code
FROM LinguistServices
WHERE language_pair = 'ENG - ITA'
AND service_type = 'Revision'
AND sub_service_type = 'Documentation';

-- Find all language leads for ENG - FRE language pair
SELECT DISTINCT supplier_name, supplier_code
FROM LinguistServices
WHERE language_pair = 'ENG - FRE'
AND service_type = 'Language Lead';

-- Find all linguists for ENG - DAN language pair
SELECT DISTINCT supplier_name, supplier_code
FROM LinguistServices
WHERE language_pair = 'ENG - DAN';

-- Find top 3 chepeast translators for ENG - SPA language pair
WITH RankedSuppliers AS (
    SELECT
        supplier_name,
        supplier_code,
        rate_per_word,
        ROW_NUMBER() OVER (PARTITION BY supplier_code ORDER BY rate_per_word ASC) AS rn
    FROM LinguistServices
    WHERE language_pair = 'ENG - SPA'
    AND service_type = 'Translation'
)
SELECT supplier_name, supplier_code, rate_per_word
FROM RankedSuppliers
WHERE rn = 1
ORDER BY rate_per_word ASC
LIMIT 3;

-- Adding new linguist
INSERT INTO Linguists (name, supplier_code)
VALUES ('John Doe', 'SUP12345');

-- Insert language pair for the previously added linguist
INSERT INTO LanguagePairs (linguist_id, source_language, target_language)
VALUES (last_insert_rowid(), 'ENG', 'SPA');

-- Insert service type and rates for the same linguist
INSERT INTO ServiceTypes (linguist_id, service_type, sub_service_type, rate_per_word, rate_per_hour, art_code)
VALUES (last_insert_rowid(), 'Translation', 'Software', 0.10, NULL, 'SW123');

-- Insert contact details
INSERT INTO ContactDetails (linguist_id, email, phone)
VALUES (last_insert_rowid(), 'johndoe@example.com', '+123456789');

-- Update linguists details
UPDATE Linguists
SET name = 'Jane Doe'
WHERE supplier_code = 'SUP12345';

UPDATE LanguagePairs
SET target_language = 'FRE'
WHERE linguist_id = 1
AND source_language = 'ENG'
AND target_language = 'SPA';

UPDATE ServiceTypes
SET rate_per_word = 0.12
WHERE linguist_id = 1
AND service_type = 'Translation'
AND sub_service_type = 'Software';

UPDATE ContactDetails
SET email = 'jane.doe@example.com', phone = '+987654321'
WHERE linguist_id = 1;

-- Soft deletion example
UPDATE Linguists
SET removed = 1
WHERE supplier_code = 'SUP12345';

-- Restoring soft deletion
UPDATE Linguists
SET removed = 0
WHERE supplier_code = 'SUP12345';
