-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- id: Primary key, unique for each linguist.
-- name: Linguist's name.
-- supplier_code: A unique code identifying the supplier (linguist).

CREATE TABLE Linguists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    supplier_code TEXT NOT NULL UNIQUE,
    removed INTEGER DEFAULT 0
);

-- linguist_id: Foreign key pointing to the Linguists table.
-- email: Contact email of the linguist, cannot be null.
-- phone: Phone number of the linguist (optional)

CREATE TABLE ContactDetails (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    linguist_id INTEGER,
    email TEXT NOT NULL,
    phone TEXT,
    FOREIGN KEY (linguist_id) REFERENCES Linguists(id)
);

-- linguist_id: Foreign key pointing to the Linguists table.
-- source_language: The source language.
-- target_language: The target language.

CREATE TABLE LanguagePairs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    linguist_id INTEGER,
    source_language TEXT NOT NULL,
    target_language TEXT NOT NULL,
    FOREIGN KEY (linguist_id) REFERENCES Linguists(id)
);

-- linguist_id: Foreign key pointing to the Linguists table.
-- service_type: Type of service (e.g., "Translation", "Revision", "Language Lead").
-- sub_service_type: If the service is Translation/Revision, specify "Software" or "Documentation".
-- rate_per_word: Rate per word (for Translation/Revision services).
-- rate_per_hour: Rate per hour (for Language Lead services or other hourly work).
-- art_code: Art code for the specific rate

CREATE TABLE ServiceTypes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    linguist_id INTEGER,
    service_type TEXT NOT NULL,  -- Translation, Revision, Language Lead
    sub_service_type TEXT,       -- Software, Documentation
    rate_per_word REAL,
    rate_per_hour REAL,
    art_code TEXT,
    FOREIGN KEY (linguist_id) REFERENCES Linguists(id)
);

-- VIEWS

CREATE VIEW LinguistServices AS
SELECT
    l.name AS supplier_name,
    l.supplier_code,
    lp.source_language || ' - ' || lp.target_language AS language_pair,
    st.service_type,
    st.sub_service_type,
    st.rate_per_word,
    st.rate_per_hour
FROM Linguists l
JOIN LanguagePairs lp ON l.id = lp.linguist_id
JOIN ServiceTypes st ON l.id = st.linguist_id
WHERE l.removed = 0;


CREATE VIEW Translators AS
SELECT
    l.name AS supplier_name,
    l.supplier_code,
    lp.source_language || ' - ' || lp.target_language AS language_pair,
    st.rate_per_word,
    st.art_code
FROM Linguists l
JOIN LanguagePairs lp ON l.id = lp.linguist_id
JOIN ServiceTypes st ON l.id = st.linguist_id
WHERE st.service_type = 'Translation'
AND l.removed = 0;


CREATE VIEW Revisors AS
SELECT
    l.name AS supplier_name,
    l.supplier_code,
    lp.source_language || ' - ' || lp.target_language AS language_pair,
    st.rate_per_word,
    st.rate_per_hour,
    st.art_code
FROM Linguists l
JOIN LanguagePairs lp ON l.id = lp.linguist_id
JOIN ServiceTypes st ON l.id = st.linguist_id
WHERE st.service_type = 'Revision'
AND l.removed = 0;


-- Indexes on supplier code, language_pair, service_type, and rate_per_word will optimize common queries, particularly when filtering and sorting.

CREATE INDEX idx_language_pair ON LanguagePairs(source_language, target_language);
CREATE INDEX idx_service_type ON ServiceTypes(service_type);
CREATE INDEX idx_rate_per_word ON ServiceTypes(rate_per_word);
CREATE INDEX idx_supplier_code ON Linguists(supplier_code);
