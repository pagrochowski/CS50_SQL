CREATE TABLE passengers (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "first_name" TEXT,
    "last_name" TEXT,
    "age" INTEGER
);

CREATE TABLE check_ins (
    "date" DATE,
    "time" TIME,
    "flight_id" INTEGER,
    FOREIGN KEY(flight_id) REFERENCES flights(id)
);

CREATE TABLE airlines (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT,
    "concourse" TEXT
);

CREATE TABLE flights (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "flight_number" INTEGER,
    "airline" TEXT,
    "from_airport" TEXT,
    "to_airport" TEXT,
    "departure" TIMESTAMP,
    "arrival" TIMESTAMP
);

