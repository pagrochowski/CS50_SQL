CREATE TABLE IF NOT EXISTS "districts" (
    "id" INTEGER,
    "name" TEXT,
    "type" TEXT,
    "city" TEXT,
    "state" TEXT,
    "zip" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "schools" (
    "id" INTEGER,
    "district_id" INTEGER,
    "name" TEXT,
    "type" TEXT,
    "city" TEXT,
    "state" TEXT,
    "zip" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("district_id") REFERENCES "districts"("id")
);
CREATE TABLE IF NOT EXISTS "graduation_rates" (
    "id" INTEGER,
    "school_id" INTEGER,
    "graduated" NUMERIC,
    "dropped" NUMERIC,
    "excluded" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("school_id") REFERENCES "schools"("id")
);
CREATE TABLE IF NOT EXISTS "expenditures" (
    "id" INTEGER,
    "district_id" INTEGER,
    "pupils" INTEGER,
    "per_pupil_expenditure" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("district_id") REFERENCES "districts"("id")
);
CREATE TABLE IF NOT EXISTS "staff_evaluations" (
    "id" INTEGER,
    "district_id" INTEGER,
    "evaluated" NUMERIC,
    "exemplary" NUMERIC,
    "proficient" NUMERIC,
    "needs_improvement" NUMERIC,
    "unsatisfactory" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("district_id") REFERENCES "districts"("id")
);