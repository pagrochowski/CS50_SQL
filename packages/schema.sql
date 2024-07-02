CREATE TABLE IF NOT EXISTS "addresses" (
    "id" INTEGER,
    "address" TEXT,
    "type" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "packages" (
    "id" INTEGER,
    "contents" TEXT,
    "from_address_id" INTEGER,
    "to_address_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("from_address_id") REFERENCES "addresses"("id"),
    FOREIGN KEY("to_address_id") REFERENCES "addresses"("id")
);
CREATE TABLE IF NOT EXISTS "drivers" (
    "id" INTEGER,
    "name" TEXT,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "scans" (
    "id" INTEGER,
    "driver_id" INTEGER,
    "package_id" INTEGER,
    "address_id" INTEGER,
    "action" TEXT,
    "timestamp" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("driver_id") REFERENCES "drivers"("id"),
    FOREIGN KEY("package_id") REFERENCES "packages"("id"),
    FOREIGN KEY("address_id") REFERENCES "addresses"("id")
);