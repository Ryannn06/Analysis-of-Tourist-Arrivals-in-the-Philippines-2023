CREATE OR REPLACE VIEW leading_countries AS
SELECT *
FROM tourist
ORDER BY total DESC
LIMIT 10;

SELECT
    country,
    total
FROM leading_countries;