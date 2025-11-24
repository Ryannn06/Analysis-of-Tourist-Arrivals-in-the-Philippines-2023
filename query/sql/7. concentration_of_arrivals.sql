SELECT 
    country, 
    total,
    ROUND(total::numeric/(SELECT SUM(total) FROM tourist) * 100, 2) AS pct_of_share
FROM tourist
LIMIT 10;