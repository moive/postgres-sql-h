--table temporal
WITH posts_week_2024 AS (
    SELECT
        date_trunc('week' :: text, posts.created_at) AS weeks,
        SUM(claps.counter) AS total_claps,
        COUNT(DISTINCT posts.post_id) AS number_of_posts,
        COUNT(*) AS number_of_claps
    FROM
        posts
        JOIN claps ON claps.post_id = posts.post_id
    GROUP BY
        (date_trunc('week' :: text, posts.created_at))
    ORDER BY
        (date_trunc('week' :: text, posts.created_at)) DESC
)

-- SELECT * FROM posts_week_2024 WHERE weeks BETWEEN '2024-01-01' AND '2024-12-31';
SELECT * FROM posts_week_2024 WHERE weeks BETWEEN '2024-01-01' AND '2024-12-31' AND total_claps >= 600


--multiples CTEs
WITH claps_per_post AS (
	SELECT post_id, SUM(counter) FROM claps GROUP BY post_id
), posts_from_2023 AS (
	SELECT * FROM posts WHERE created_at BETWEEN '2023-01-01' AND '2023-12-01'
)

SELECT * from claps_per_post
WHERE claps_per_post.post_id IN (SELECT post_id FROM posts_from_2023)

-- CTEs recursive
-- name table memory
-- fields
WITH RECURSIVE countdown (val) AS (
	-- intialize
		SELECT 10 AS val
	UNION ALL
	-- Query recursive
	SELECT val - 1 FROM countdown WHERE val > 1
)
-- select
SELECT * FROM countdown


-- counter number desc
WITH RECURSIVE counter (val) AS (
	-- intialize
		SELECT 1 AS val
	UNION ALL
	-- Query recursive
	SELECT val + 1 FROM counter WHERE val < 10
)
-- select
SELECT * FROM counter

-- table multiplication
WITH RECURSIVE
  multiplication_table (base, val, result) AS (
    SELECT
      5 AS base,
      1 AS val,
      5 AS result
    UNION ALL
    SELECT
      5 AS base,
      val + 1,
      (val + 1) * base AS result
    FROM
      multiplication_table
    WHERE
      val < 10
  )
SELECT
  *
FROM
  multiplication_table;

--create table employees
DROP TABLE IF EXISTS "public"."employees";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS employees_id_seq;

-- Table Definition
CREATE TABLE "public"."employees" (
    "id" int4 NOT NULL DEFAULT nextval('employees_id_seq'::regclass),
    "name" varchar,
    "reports_to" int4,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."employees" ("id", "name", "reports_to") VALUES
(1, 'Jefe Carlos', NULL),
(2, 'SubJefe Susana', 1),
(3, 'SubJefe Juan', 1),
(4, 'Gerente Pedro', 3),
(5, 'Gerente Melisa', 3),
(6, 'Gerente Carmen', 2),
(7, 'SubGerente Ramiro', 5),
(8, 'Programador Fernando', 7),
(9, 'Programador Eduardo', 7),
(10, 'Presidente Karla', NULL),
(11, 'Jr Mariano', 8);

--exercise real
WITH RECURSIVE
  bosses AS (
    -- Init
    SELECT
      id,
      name,
      reports_to
    FROM
      employees
    WHERE
      id = 11
    UNION
    -- Recursive
    SELECT employees.id, employees."name", employees.reports_to FROM employees
    INNER JOIN bosses ON bosses.id = employees.reports_to
  )
SELECT
  *
FROM
  bosses;

-- recursive with limit
WITH RECURSIVE
  bosses AS (
    -- Init
    SELECT
      id,
      name,
      reports_to,
      1 as depth
    FROM
      employees
    WHERE
      id = 1
    UNION
    -- Recursive
    SELECT employees.id, employees."name", employees.reports_to, depth + 1 FROM employees
    INNER JOIN bosses ON bosses.id = employees.reports_to
    WHERE depth < 4
  )
SELECT
  *
FROM
  bosses;

-- display name boss
WITH RECURSIVE
  bosses AS (
    -- Init
    SELECT
      id,
      name,
      reports_to,
      NULL::VARCHAR AS name_boss, -- 'No boss'::VARCHAR AS name_boss,
      1 as depth
    FROM
      employees
    WHERE
      id = 1
    UNION ALL
    -- Recursive
    SELECT
      employees.id,
      employees."name",
      employees.reports_to,
      bosses.name AS name_boss,
      depth + 1
    FROM
      employees
      INNER JOIN bosses ON bosses.id = employees.reports_to
    WHERE
      depth < 10
  )
SELECT
  *
FROM
  bosses;

-- other name MORE EFFICIENT
WITH RECURSIVE
  bosses AS (
    -- Init
    SELECT
      id,
      name,
      reports_to,
      1 as depth
    FROM
      employees
    WHERE
      id = 1
    UNION ALL
    -- Recursive
    SELECT
      employees.id,
      employees."name",
      employees.reports_to,
      depth + 1
    FROM
      employees
      INNER JOIN bosses ON bosses.id = employees.reports_to
    WHERE
      depth < 10
  )
SELECT
  bosses.*, COALESCE(employees.name, 'Sin jefe') AS reports_to_name
FROM
  bosses
LEFT JOIN employees ON employees.id = bosses.reports_to ORDER BY depth