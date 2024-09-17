-- In frequently_reviewed.sql, write a SQL statement to create a view named frequently_reviewed. This view should contain the 100 most frequently reviewed listings, sorted from most- to least-frequently reviewed. Ensure the view contains the following columns:

-- id, which is the id of the listing from the listings table.
-- property_type, from the listings table.
-- host_name, from the listings table.
-- reviews, which is the number of reviews the listing has received.


CREATE VIEW frequently_reviewed AS
SELECT l.id, l.property_type, l.host_name, COUNT(r.id) AS reviews
FROM listings l
JOIN reviews r ON l.id = r.listing_id
GROUP BY l.id
ORDER BY reviews DESC
LIMIT 100;