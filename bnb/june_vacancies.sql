-- In june_vacancies.sql, write a SQL statement to create a view named june_vacancies. 
-- This view should contain all listings and the number of days in June of 2023 that they remained vacant. 
-- Ensure the view contains the following columns:

-- id, which is the id of the listing from the listings table.
-- property_type, from the listings table.
-- host_name, from the listings table.
-- days_vacant, which is the number of days in June of 2023, that the given listing was marked as available.

CREATE VIEW june_vacancies AS
SELECT l.id, l.property_type, l.host_name, COUNT(a.date) AS days_vacant
FROM listings l
JOIN availabilities a ON l.id = a.listing_id
WHERE a.date >= '2023-06-01' AND a.date < '2023-07-01' AND a.available = 'TRUE'
GROUP BY l.id;