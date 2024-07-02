-- What are top 5 worst schools names? Sort by least graduation rate compared to all students

SELECT ROUND((dropped + excluded) / (graduated + dropped + excluded), 2) AS fail_rate, name, graduated, dropped, excluded FROM schools 
JOIN graduation_rates ON schools.id = graduation_rates.school_id 
ORDER BY (dropped + excluded) / (graduated + dropped + excluded) DESC
LIMIT 5;