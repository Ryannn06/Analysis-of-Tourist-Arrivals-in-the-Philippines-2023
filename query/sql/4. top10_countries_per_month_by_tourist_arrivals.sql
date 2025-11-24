CREATE OR REPLACE VIEW top10_countries_per_month AS
with melted_cte AS (
    SELECT country, 'january' AS month, january AS tourist_arrivals FROM tourist WHERE january > 0
    UNION ALL SELECT country, 'february', february FROM tourist WHERE february > 0
    UNION ALL SELECT country, 'march', march FROM tourist WHERE march > 0
    UNION ALL SELECT country, 'april', april FROM tourist WHERE april > 0
    UNION ALL SELECT country, 'may', may FROM tourist WHERE may > 0
    UNION ALL SELECT country, 'june', june FROM tourist WHERE june > 0
    UNION ALL SELECT country, 'july', july FROM tourist WHERE july > 0
    UNION ALL SELECT country, 'august', august FROM tourist  WHERE august > 0
    UNION ALL SELECT country, 'september', september FROM tourist  WHERE september > 0
    UNION ALL SELECT country, 'october', october FROM tourist  WHERE october > 0
), ranked_cte AS (
    SELECT
        country,
        month,
        tourist_arrivals,
        RANK() OVER(PARTITION BY month ORDER BY tourist_arrivals DESC) AS month_rank
    FROM melted_cte
)
SELECT 
    country,
    month,
    tourist_arrivals
FROM ranked_cte
WHERE month_rank <= 10
ORDER BY 
    CASE month
        WHEN 'january' THEN  1
        WHEN 'february' THEN 2
        WHEN 'march' THEN 3
        WHEN 'april' THEN 4
        WHEN 'may' THEN 5
        WHEN 'june' THEN 6
        WHEN 'july' THEN 7
        WHEN 'august' THEN 8
        WHEN 'september' THEN 9
        WHEN 'october' THEN 10
    END, tourist_arrivals DESC;

SELECT * FROM top10_countries_per_month;
