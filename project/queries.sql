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

