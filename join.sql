-- using name UNION
SELECT CODE, NAME, '123' FROM continent WHERE "name" like '%America%'
UNION
SELECT CODE, 'ABC', NAME FROM continent WHERE code IN (3,5)
ORDER BY NAME DESC