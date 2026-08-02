--create view comments_per_week
CREATE OR REPLACE VIEW comments_per_week AS

SELECT
  date_trunc('weeks', posts.created_at) AS weeks,
  COUNT(distinct posts.post_id) AS number_of_posts,
  SUM(claps.counter) AS total_claps,
  COUNT(*) AS number_of_claps
FROM
  posts
  INNER JOIN claps ON claps.post_id = posts.post_id
GROUP BY
  weeks
ORDER BY
  weeks DESC;

SELECT * FROM claps WHERE post_id = 1;
SELECT * FROM comments_per_week;

--create view materialized comments_per_week_mat 
CREATE MATERIALIZED VIEW comments_per_week_mat AS

SELECT
  date_trunc('weeks', posts.created_at) AS weeks,
  COUNT(distinct posts.post_id) AS number_of_posts,
  SUM(claps.counter) AS total_claps,
  COUNT(*) AS number_of_claps
FROM
  posts
  INNER JOIN claps ON claps.post_id = posts.post_id
GROUP BY
  weeks
ORDER BY
  weeks DESC;

SELECT * FROM comments_per_week;
SELECT * FROM comments_per_week_mat;
-- for refresh view materialized
REFRESH MATERIALIZED VIEW comments_per_week_mat;

--rename view
SELECT * FROM comments_per_week;
ALTER VIEW comments_per_week RENAME TO posts_per_week
SELECT * FROM posts_per_week;

--rename view materialize
SELECT * FROM comments_per_week_mat;
ALTER MATERIALIZED VIEW comments_per_week_mat RENAME TO posts_per_week_mat
SELECT * FROM posts_per_week_mat;