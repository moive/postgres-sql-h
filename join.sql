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