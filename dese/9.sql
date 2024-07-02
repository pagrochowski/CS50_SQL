--Another parent wants to send their child to a district with few other students. 
--In 9.sql, write a SQL query to find the name (or names) of the school district(s) with the single least number of pupils. Report only the name(s).

SELECT expenditures.pupils, districts.name FROM expenditures JOIN districts ON expenditures.district_id = districts.id ORDER BY expenditures.pupils ASC LIMIT 1;