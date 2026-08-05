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