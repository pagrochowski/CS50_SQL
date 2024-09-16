-- 1. Create new table to contain only relevant rows
CREATE TABLE "selected_rows" AS
SELECT * FROM "sentences"
WHERE id IN (14, 114, 618, 630, 932, 2230, 2346, 3041);

-- 2. Create new table with substring information
CREATE TABLE substring_info (
    id INTEGER,
    start_pos INTEGER,
    length INTEGER
);

-- 3. Populate table with substring information
INSERT INTO substring_info (id, start_pos, length) VALUES (14, 98, 4), (114, 3, 5), (618, 72, 9), (630, 7, 3), (932, 12, 5), (2230, 50, 7), (2346, 44, 10), (3041, 14, 5);

-- 4. Select sentences with substrings
SELECT substr(sr.sentence, si.start_pos, si.length)
FROM selected_rows sr
JOIN substring_info si ON sr.id = si.id;

-- 5. Create a view that contains the sentences with substrings
CREATE VIEW message AS
SELECT substr(sr.sentence, si.start_pos, si.length) AS phrase
FROM selected_rows sr
JOIN substring_info si ON sr.id = si.id;