CREATE TABLE IF NOT EXISTS "episodes" (
    "id" INTEGER,
    "season" INTEGER,
    "episode_in_season" INTEGER,
    "title" TEXT,
    "topic" TEXT,
    "air_date" NUMERIC,
    "production_code" TEXT,
    PRIMARY
);