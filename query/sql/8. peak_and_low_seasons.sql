DROP VIEW IF EXISTS total_arrivals_per_month;
CREATE OR REPLACE VIEW total_arrivals_per_month AS
SELECT 'january' AS month, SUM(january) AS total_arrivals FROM tourist
UNION ALL SELECT 'february' AS month, SUM(february) AS february FROM tourist
UNION ALL SELECT 'march' AS month, SUM(march) AS march FROM tourist
UNION ALL SELECT 'april' AS month, SUM(april) AS april FROM tourist
UNION ALL SELECT 'may' AS month, SUM(may) AS may FROM tourist
UNION ALL SELECT 'june' AS month, SUM(june) AS june FROM tourist
UNION ALL SELECT 'july' AS month, SUM(july) AS july FROM tourist
UNION ALL SELECT 'august' AS month, SUM(august) AS august FROM tourist
UNION ALL SELECT 'september' AS month, SUM(september) AS september FROM tourist
UNION ALL SELECT 'october' AS month, SUM(october) AS october FROM tourist;

-- months above average (peak season)
SELECT *
FROM total_arrivals_per_month
WHERE total_arrivals >= (
    SELECT AVG(total_arrivals)
    FROM total_arrivals_per_month
)

-- months below average (low season)
SELECT *
FROM total_arrivals_per_month
WHERE total_arrivals < (
    SELECT AVG(total_arrivals)
    FROM total_arrivals_per_month
)

-- growth rate by month
SELECT 
    *,
    total_arrivals,
    COALESCE(ROUND(
        (total_arrivals::numeric - LAG(total_arrivals) OVER())
         /NULLIF(LAG(total_arrivals) OVER(),0) * 100,
        2
    ),0) AS growth_rate
FROM total_arrivals_per_month;