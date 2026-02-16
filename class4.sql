-- create table continent
SELECT DISTINCT continent FROM country ORDER BY continent ASC;

CREATE TABLE continent (
  code SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

INSERT INTO
  continent (name)
  SELECT DISTINCT
    continent
  FROM
    country
  ORDER BY
    continent ASC;
  --code select distinct continent replace values of insert data
SELECT * FROM continent;


INSERT INTO country_bk
SELECT * FROM country -- replace values of inserta data

--delete country_continent_check
ALTER TABLE country
DROP CONSTRAINT country_continent_check


-- update TABLE country row continent
SELECT
  a."name",
  a.continent,
  (SELECT "code" FROM continent b WHERE b."name" = a.continent)
FROM
  country a;
  
  
UPDATE country a
SET continent = (SELECT "code" FROM continent b WHERE b."name" = a.continent)

SELECT * FROM country;

-- alter type column: continent
ALTER TABLE country
ALTER COLUMN continent
TYPE int4
USING continent::integer

-- add foreign key country to references continent(code)
ALTER TABLE country
ADD CONSTRAINT fk_country_continent
FOREIGN KEY (continent)
REFERENCES continent(code)
