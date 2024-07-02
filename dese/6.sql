--DESE wants to assess which schools achieved a 100% graduation rate. 
--In 6.sql, write a SQL query to find the names of schools (public or charter!) that reported a 100% graduation rate.

SELECT name FROM schools WHERE id IN (SELECT school_id FROM graduation_rates WHERE graduated / (graduated + dropped + excluded) = 1 AND (graduated + dropped + excluded) != 0);