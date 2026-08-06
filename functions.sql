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

-- without function
SELECT
  employee_id,
  first_name,
  salary,
  max_salary,
  max_salary - salary AS possible_raise
FROM
  employees
  INNER JOIN jobs ON jobs.job_id = employees.job_id;

-- with function
CREATE OR REPLACE FUNCTION max_raise (empl_id int) 
RETURNS NUMERIC(8, 2) AS $$

DECLARE
	possible_raise NUMERIC(8,2);

BEGIN

	SELECT max_salary - salary INTO possible_raise
	FROM employees
	INNER JOIN jobs ON jobs.job_id = employees.job_id
	WHERE employee_id = empl_id;
	
	RETURN possible_raise;

END;

$$ LANGUAGE plpgsql;

SELECT employee_id, first_name, max_raise(employee_id) FROM employees;