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