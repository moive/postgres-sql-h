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