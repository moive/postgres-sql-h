-- create function greet_employee
CREATE OR REPLACE FUNCTION greet_employee(empl_name VARCHAR)
RETURNS VARCHAR
AS $$
-- DECLARE variables
BEGIN
	RETURN 'Hello ' || empl_name;

END;

$$
LANGUAGE plpgsql;

SELECT first_name, greet_employee(first_name) FROM employees;