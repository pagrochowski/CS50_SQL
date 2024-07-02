CREATE TABLE IF NOT EXISTS "players" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "bats" TEXT,
    "throws" TEXT,
    "weight" INTEGER,
    "height" INTEGER,
    "debut" NUMERIC,
    "final_game" NUMERIC,
    "birth_year" INTEGER,
    "birth_month" INTEGER,
    "birth_day" INTEGER,
    "birth_city" TEXT,
    "birth_state" TEXT,
    "birth_country" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "teams" (
    "id" INTEGER,
    "year" INTEGER,
    "name" TEXT,
    "park" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "salaries" (
    "id" INTEGER,
    "player_id" INTEGER,
    "team_id" INTEGER,
    "year" INTEGER,
    "salary" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("player_id") REFERENCES "players"("id"),
    FOREIGN KEY("team_id") REFERENCES "teams"("id")
);
CREATE TABLE IF NOT EXISTS "performances" (
    "id" INTEGER,
    "player_id" INTEGER,
    "team_id" INTEGER,
    "year" INTEGER,
    "G" INTEGER,
    "AB" INTEGER,
    "H" INTEGER,
    "2B" INTEGER,
    "3B" INTEGER,
    "HR" INTEGER,
    "RBI" INTEGER,
    "SB" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("player_id") REFERENCES "players"("id"),
    FOREIGN KEY("team_id") REFERENCES "teams"("id")
);