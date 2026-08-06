--create function return table
CREATE OR REPLACE FUNCTION country_region()
RETURNS TABLE(id CHARACTER(2), name VARCHAR(40), region VARCHAR(25)) 
AS $$
	BEGIN
		RETURN query
			SELECT country_id, country_name, region_name FROM countries
			INNER JOIN regions ON countries.region_id = regions.region_id;
	END;
$$ LANGUAGE plpgsql;


SELECT * from country_region();


-- create stored procedure
CREATE
OR REPLACE PROCEDURE insert_region_proc (int, varchar) AS $$
BEGIN
	INSERT INTO regions (region_id, region_name)
	VALUES($1, $2);
	
	RAISE NOTICE 'Variables: %, %', $1, $2;
	
-- 	ROLLBACK;
	COMMIT;

END;

$$ LANGUAGE plpgsql;

CALL insert_region_proc(5, 'Central America');

SELECT * FROM regions;


-- Salary increase
SELECT
  current_date AS "date",
  salary,
  max_raise (employee_id),
  max_raise (employee_id) * 0.01 AS amount,
  1 AS percentage
FROM
  employees;