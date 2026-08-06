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


--multiple queries
CREATE OR REPLACE FUNCTION max_raise_multiple_variable (empl_id int) 
RETURNS NUMERIC(8, 2) AS $$

DECLARE
	employee_job_id int;
	current_salary NUMERIC(8,2);
	
	job_max_salary NUMERIC(8,2);
	possible_raise NUMERIC(8,2);

BEGIN
	-- Take the job and the salary
	SELECT job_id, salary 
	INTO employee_job_id, current_salary
	FROM employees
	WHERE employee_id = empl_id;
	
	-- Take the highest salary based on the employee's work
	SELECT max_salary INTO job_max_salary 
	FROM jobs 
	WHERE job_id = employee_job_id;
	
	-- Calculations
	possible_raise = job_max_salary - current_salary;
	
	RETURN possible_raise;

END;

$$ LANGUAGE plpgsql;

SELECT
  employee_id,
  first_name,
  max_raise (employee_id),
  max_raise_multiple_variable(employee_id)
FROM
  employees;

-- use IF, THEN END IF
CREATE OR REPLACE FUNCTION max_raise_multiple_variable (empl_id int) 
RETURNS NUMERIC(8, 2) AS $$

DECLARE
	employee_job_id int;
	current_salary NUMERIC(8,2);
	
	job_max_salary NUMERIC(8,2);
	possible_raise NUMERIC(8,2);

BEGIN
	-- Take the job and the salary
	SELECT job_id, salary 
	INTO employee_job_id, current_salary
	FROM employees
	WHERE employee_id = empl_id;
	
	-- Take the highest salary based on the employee's work
	SELECT max_salary INTO job_max_salary 
	FROM jobs 
	WHERE job_id = employee_job_id;
	
	-- Calculations
	possible_raise = job_max_salary - current_salary;
	
	IF possible_raise < 0 THEN
		RAISE EXCEPTION 'Person with highest salary max_salary: %', empl_id;
-- 		possible_raise = 0;
	END IF;
	
	RETURN possible_raise;

END;

$$ LANGUAGE plpgsql;

SELECT
  employee_id,
  first_name,
  max_raise (employee_id),
  max_raise_multiple_variable(employee_id)
FROM
  employees;
  
-- SELECT * FROM employees WHERE employee_id = 206;


-- use ROWTYPE
CREATE OR REPLACE FUNCTION max_raise_multiple_variable (empl_id int) 
RETURNS NUMERIC(8, 2) AS $$

DECLARE
	
	selected_employee employees%rowtype;
	selected_job jobs%rowtype;
	possible_raise NUMERIC(8,2);

BEGIN
	-- Take the job and the salary
	SELECT *
	FROM employees
	INTO selected_employee
	WHERE employee_id = empl_id;
	
	-- Take the highest salary based on the employee's work
	SELECT *
	FROM jobs
	INTO selected_job
	WHERE job_id = selected_employee.job_id;
	
	-- Calculations
	possible_raise = selected_job.max_salary - selected_employee.salary;
	
	IF possible_raise < 0 THEN
		RAISE EXCEPTION 'Person with highest salary max_salary: id:%, %', selected_employee.employee_id, selected_employee.first_name;
-- 		possible_raise = 0;
	END IF;
	
	RETURN possible_raise;

END;

$$ LANGUAGE plpgsql;

SELECT
  employee_id,
  first_name,
  max_raise (employee_id),
  max_raise_multiple_variable(employee_id)
FROM
  employees;
