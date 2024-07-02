
-- *** The Lost Letter ***
-- Check the address table format types
SELECT * FROM "addresses";

-- Find the mentioned addresses ids
SELECT "id" FROM "addresses" WHERE "address" = "900 Somerville Avenue"; result: 432
SELECT "id" FROM "addresses" WHERE "address" = "2 Finnegan Street"; result: none

-- Check for packages sent from address id 432
SELECT "contents" FROM "packages" WHERE "from_address_id" = "432";

-- We can see a Congratulatory letter, check it's id
SELECT "id" FROM "packages" WHERE "from_address_id" = "432" AND "contents" = "Congratulatory letter"; result: 384

-- Check where the package was sent to
SELECT "to_address_id" FROM "packages" WHERE "id" = "384"; result: 854

-- Check the address of that id
SELECT "address" FROM "addresses" WHERE "id" = "854"; result: "2 Finnigan Street"

-- Find out the type of the address the package is at
SELECT "type" FROM "addresses" WHERE "id" = "854"; result: "Residential"

-- *** The Devious Delivery ***
-- Check for packages sent without 'from' address
SELECT * FROM "packages" WHERE "from_address_id" IS NULL; result:
id|contents|from_address_id|to_address_id
5098|Duck debugger||50

-- Check the scans for that address
SELECT * FROM "scans" WHERE "address_id" = "50"; result: 
id|driver_id|package_id|address_id|action|timestamp
30123|10|5098|50|Pick|2023-10-24 08:40:16.246648

-- Check the latest pick driver's name
SELECT "name" FROM "drivers" WHERE "id" = "10"; result: Josephine

-- Check Josephine's scans for that package
SELECT * FROM "scans" WHERE "driver_id" = "10" AND "package_id" = "5098"; result:
id|driver_id|package_id|address_id|action|timestamp
30123|10|5098|50|Pick|2023-10-24 08:40:16.246648
30140|10|5098|348|Drop|2023-10-24 10:08:55.610754

-- Check where the package was dropped
SELECT * FROM "addresses" WHERE "id" = "348"; result: 348|7 Humboldt Place|Police Station


-- *** The Forgotten Gift ***
-- Check addresses ids
SELECT "id" FROM "addresses" WHERE "address" = "728 Maple Place"; result: 4983
SELECT "id" FROM "addresses" WHERE "address" = "109 Tileston Street"; result: 9873

-- Check packages sent between those addresses
SELECT * FROM "packages" WHERE "from_address_id" = "9873" AND "to_address_id" = "4983"; result: 9523|Flowers|9873|4983

-- Check scans for package id 9523
SELECT * FROM "scans" WHERE "package_id" = "9523"; 
result: 
10432|11|9523|9873|Pick|2023-08-16 21:41:43.219831
10500|11|9523|7432|Drop|2023-08-17 03:31:36.856889
12432|17|9523|7432|Pick|2023-08-23 19:41:47.913410

-- Check the latest pick driver's name
SELECT "name" FROM "drivers" WHERE "id" = "17"; result: Mikel