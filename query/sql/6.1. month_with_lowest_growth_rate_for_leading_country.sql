WITH growth_rank AS(
    SELECT
        *,
        RANK() OVER(PARTITION BY country ORDER BY growth_rate_in_pct ASC) AS growth_rank
    FROM growth_trends_for_leading_countries
)
SELECT 
    country,
    month,
    tourist_arrivals,
    growth_rate_in_pct
FROM growth_rank
WHERE growth_rank = 1
ORDER BY country;