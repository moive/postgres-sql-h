-- ADD PRIMARY KEY
SELECT
  *
FROM
  country
WHERE
  code = 'NLD'
  AND code2 = 'NA'
  
DELETE FROM country
WHERE
  code = 'NLD'
  AND code2 = 'NA'
  
ALTER TABLE country
ADD PRIMARY KEY (code)

-- ADD CHECK, DROP CONSTRAINT AND MULTI CHECK

SELECT * FROM country WHERE CODE = 'CRI'

ALTER TABLE country
ADD CHECK (surfacearea >= 0)

SELECT DISTINCT continent FROM country;

ALTER TABLE country
ADD CHECK (
  (continent = 'Asia'::TEXT)
  OR (continent = 'South America'::TEXT)
  OR (continent = 'North America'::TEXT)
  OR (continent = 'Oceania'::TEXT)
  OR (continent = 'Antarctica'::TEXT)
  OR (continent = 'Africa'::TEXT)
  OR (continent = 'Europe'::TEXT)
  OR (continent = 'Central America'::TEXT)
)

ALTER TABLE country
DROP CONSTRAINT "country_continent_check1"

-- create indexes
CREATE UNIQUE INDEX "unique_country_name" ON country (name)

CREATE INDEX "country_continent" ON country(continent)


-- Display restrictions fields on the table
SELECT 
    conname AS constraint_name,
    contype AS constraint_type,
    condeferrable AS is_deferrable,
    condeferred AS is_deferred,
    pg_catalog.pg_get_constraintdef(c.oid) AS definition
FROM 
    pg_catalog.pg_constraint c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.connamespace
WHERE 
    c.conrelid = 'country'::regclass;


-- working with indexes
SELECT
  *
FROM
  city
WHERE
  name = 'Jinzhou'
  AND countrycode = 'CHN'
  AND district = 'Liaoning'

CREATE UNIQUE INDEX "unique_name_countrycode_district" ON city (name, countrycode, district);

CREATE INDEX "city_district" ON city (district);

-- create foreign key
SELECT * FROM city WHERE countrycode = 'AFG';
SELECT * FROM country WHERE code = 'AFG';

ALTER TABLE city
  ADD CONSTRAINT fk_countrycode 
  FOREIGN KEY (countrycode) 
  REFERENCES country (code); -- ON DELETE CASCADE
  
ALTER TABLE city DROP CONSTRAINT fk_countrycode


-- INSERT DATA
INSERT INTO country
		values('AFG', 'Afghanistan', 'Asia', 'Southern Asia', 652860, 1919, 40000000, 62, 69000000, NULL, 'Afghanistan', 'Totalitarian', NULL, NULL, 'AF');