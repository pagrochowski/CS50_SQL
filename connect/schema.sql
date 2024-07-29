CREATE TABLE users (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "first name" TEXT,
    "last name" TEXT,
    "password" TEXT,
    "username" TEXT
);

CREATE TABLE schools (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name of school" TEXT,
    "type of school" TEXT,
    "school location" TEXT,
    "school year" INTEGER
);

CREATE TABLE company (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name of company" TEXT,
    "company industry" TEXT,
    "company location" TEXT
);

CREATE TABLE connections_people ( 
    "user id1" INTEGER, 
    "user id2" INTEGER, 
    FOREIGN KEY ("user id1") REFERENCES users(id), 
    FOREIGN KEY ("user id2") REFERENCES users(id) 
);

CREATE TABLE connections_schools (
    "user id" INTEGER ,
    "school id" INTEGER,
    FOREIGN KEY ("user id") REFERENCES users(id), 
    FOREIGN KEY ("school id") REFERENCES schools(id)
);

CREATE TABLE connections_companies (
    "user id" INTEGER ,
    "company id" INTEGER,
    FOREIGN KEY ("user id") REFERENCES users(id), 
    FOREIGN KEY ("company id") REFERENCES company(id)
);

