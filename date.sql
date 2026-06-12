-- Trabajando con fechas
SELECT
  now(),
  CURRENT_DATE,
  CURRENT_TIME,
  date_part('hours', now()) AS hours,
  date_part('minutes', now()) AS minutes,
  date_part('seconds', now()) AS seconds,
  date_part('days', now()) AS days,
  date_part('months', now()) AS months,
  date_part('years', now()) AS years

-- Empleados mayores a 1998-02-05
SELECT * FROM employees
WHERE hire_date > date('1998-02-05')
ORDER BY hire_date DESC;

-- El mas antiguo y el mas reciente
SELECT
  MAX(hire_date) as max_new,
  MIN(hire_date) AS first_employee
FROM
  employees;
  
-- Seleccionado por rango de fecha con BETWEEN  
SELECT * FROM employees
WHERE hire_date BETWEEN '1999-01-01' AND '2001-01-04'
ORDER BY hire_date DESC;

-- INTERVAL
SELECT
  MAX(hire_date) AS maxx,
  --   MAX(hire_date) + INTERVAL '1 days' AS days,
  --   MAX(hire_date) + INTERVAL '1 months' AS months,
  --   MAX(hire_date) + INTERVAL '1 years' AS years
  MAX(hire_date) + INTERVAL '1 years' + INTERVAL '1 days' AS years,
  date_part('year', now()) AS now,
  MAKE_INTERVAL(YEARS := date_part('year', now()):: INTEGER),
  MAX(hire_date) + make_interval(YEARS:=23) AS max_make_interval
FROM
  employees;

-- diferencia entre fechas
SELECT 
	hire_date, 
	make_interval( YEARS := 2023 - EXTRACT( YEARS FROM hire_date )::INTEGER ) AS manual,
	make_interval( YEARS := date_part('years', CURRENT_DATE)::INTEGER - EXTRACT( YEARS FROM hire_date )::INTEGER ) AS computed
FROM employees
ORDER BY hire_date DESC;

-- actualizar hire_date agregando año actual de edición
SELECT 
	hire_date, 
	hire_date + INTERVAL '26 years' 
FROM employees
ORDER BY hire_date DESC;

UPDATE employees
SET hire_date = hire_date + INTERVAL '26 years'