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