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