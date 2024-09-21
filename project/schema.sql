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

-- service_type_id: Foreign key pointing to ServiceTypes.
-- rate_per_word: Rate per word (for translation or revision work).
-- rate_per_hour: Rate per hour (for hourly services).
-- art_code: Art code corresponding to the rate.

CREATE TABLE Rates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_type_id INTEGER,
    rate_per_word REAL,
    rate_per_hour REAL,
    art_code TEXT,
    FOREIGN KEY (service_type_id) REFERENCES ServiceTypes(id)
);

