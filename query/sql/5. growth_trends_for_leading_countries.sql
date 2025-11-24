CREATE OR REPLACE VIEW growth_trends_for_leading_countries AS
WITH melted_countries AS(
    SELECT country, 'january' AS month, 1 as month_order, january AS tourist_arrivals FROM leading_countries
    UNION ALL SELECT country, 'february', 2 as month_order, february FROM leading_countries
    UNION ALL SELECT country, 'march', 3 as month_order, march FROM leading_countries
    UNION ALL SELECT country, 'april', 4 as month_order, april FROM leading_countries
    UNION ALL SELECT country, 'may', 5 as month_order, may FROM leading_countries
    UNION ALL SELECT country, 'june', 6 as month_order, june FROM leading_countries
    UNION ALL SELECT country, 'july', 7 as month_order, july FROM leading_countries
    UNION ALL SELECT country, 'august', 8 as month_order, august FROM leading_countries
    UNION ALL SELECT country, 'september', 9 as month_order, september FROM leading_countries
    UNION ALL SELECT country, 'october', 10 as month_order, october FROM leading_countries
)
SELECT
    *,
    COALESCE(ROUND(
        (tourist_arrivals::numeric - LAG(tourist_arrivals) OVER(PARTITION BY country ORDER BY month_order ASC))
        / NULLIF(LAG(tourist_arrivals) OVER(PARTITION BY country ORDER BY month_order ASC)::numeric,0) * 100,
        2
    ), 0) AS growth_rate_in_pct
FROM melted_countries;

-- growth trends for leading countries in tourist arrivals
SELECT
    country,
    month,
    tourist_arrivals,
    growth_rate_in_pct
FROM growth_trends_for_leading_countries;