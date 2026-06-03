-- using name UNION
SELECT CODE, NAME, '123' FROM continent WHERE "name" like '%America%'
UNION
SELECT CODE, 'ABC', NAME FROM continent WHERE code IN (3,5)
ORDER BY NAME DESC

--join tables: country and continent
SELECT C.NAME AS Country, CT.NAME AS Continent FROM country C, continent CT
WHERE C.continent = CT.code
ORDER BY CT.NAME ASC

-- use JOIN to connect the country continent tables
SELECT A."name" AS COUNTRY, B."name" AS CONTINENT FROM country A
INNER JOIN continent B
ON A.continent = B.code
ORDER BY A."name" ASC

-- use FULL OUTER JOIN
SELECT
  a.name AS country,
  a.continent AS continentCode,
  b.name AS continentName
FROM
  country a
  FULL OUTER JOIN continent b ON a.continent = b.code
ORDER BY
  a.name DESC;

-- use RIGHT OUTER JOIN
SELECT
  a.name AS country,
  a.continent AS continentCode,
  b.name AS continentName
FROM
  country AS a
  RIGHT JOIN continent AS b ON a.continent = b.code
WHERE
  a.continent IS NULL
  ORDER BY a.name DESC;

--agregation join
SELECT COUNT(*) AS count, b.name FROM country AS a
FULL OUTER JOIN continent AS b
ON a.continent = b.code
GROUP BY b.name

UNION

SELECT 0 AS count, b.name FROM country AS a
RIGHT JOIN continent AS b
ON a.continent = b.code
WHERE a.continent IS NULL
GROUP BY b.name
ORDER BY count ASC;

--homework
-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa

(SELECT COUNT(*) AS Total, b.name AS Continent FROM country AS a
INNER JOIN continent AS b
ON a.continent = b.code
WHERE b.name NOT like '%America%'
GROUP BY b.name)
UNION
(SELECT COUNT(*) AS Total, 'America' AS Continent FROM country AS a
INNER JOIN continent AS b
ON a.continent = b.code
WHERE b.name like '%America%')
ORDER BY Total;


-- Quiero que me muestren el país con más ciudades
-- Campos: total de ciudades y el nombre del país
-- usar INNER JOIN
SELECT
  count(*) AS total,
  co.name AS country
FROM
  city ci
  INNER JOIN country co ON ci.countrycode = co.code
GROUP BY
  co.name
ORDER BY
  count(*) DESC
LIMIT 1;

-- Quiero saber los idiomas oficiales que se hablan por continente

SELECT DISTINCT la.language AS idiomas, co.name AS continent from countrylanguage la
INNER JOIN country cou ON la.countrycode = cou.code
INNER JOIN continent co ON cou.continent = co.code
WHERE isofficial IS TRUE;

-- ¿Cuántos idiomas oficiales se hablan por continente?

SELECT
  count(*),
  continent
FROM
  (
    SELECT DISTINCT
      la.language AS idiomas,
      co.name AS continent
    from
      countrylanguage la
      INNER JOIN country cou ON la.countrycode = cou.code
      INNER JOIN continent co ON cou.continent = co.code
    WHERE
      isofficial IS TRUE
  ) AS totales
  
GROUP by continent