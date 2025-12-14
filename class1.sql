CREATE TABLE users (
	name VARCHAR(10) UNIQUE
)

INSERT INTO
  users
VALUES
  ('Tom')
  
UPDATE users
SET
  name = 'Alberto'
WHERE
  name = 'Moises';
  
SELECT *
FROM users 
LIMIT 2 
OFFSET 3;

SELECT *
FROM users
WHERE name LIKE '%e%';


SELECT *
FROM users
WHERE name LIKE '_om%';

DELETE FROM users
WHERE name LIKE '_om';

DELETE FROM users; -- elimina todos los registros

TRUNCATE TABLE users; -- no elimina la table solo registros
DROP TABLE users; -- elimina la tabla usuarios y registros

SELECT
  id,
  UPPER(name) AS upper_name,
  LOWER(name) AS lower_name,
  LENGTH(name) AS length,
  '20' AS constante,
  '*'||id||'-' || name ||'*' AS barcode,
  CONCAT('*', id, '-', name, '*') AS concat,
  name
FROM
  users;

SELECT
  name,
  SUBSTRING(name, 0, 5),
  POSITION(' ' in name),
  SUBSTRING(name, 0, POSITION(' ' in name)) AS first_name, -- get first name
  SUBSTRING(name, POSITION(' ' in name) + 1) AS last_name -- get last name
FROM
  users;

-- update users table, add first_name and last_name columns
UPDATE users
SET
  first_name = SUBSTRING(name, 0, POSITION(' ' in name)),
  last_name = SUBSTRING(name, POSITION(' ' in name) + 1)
  
-- check updated table users
SELECT * FROM users;