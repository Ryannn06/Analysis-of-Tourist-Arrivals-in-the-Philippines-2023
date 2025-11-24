# Analysis of Tourist Arrivals in the Philippines, 2023

## <br>Table of Content
- [Analysis of Tourist Arrivals in the Philippines, 2023](#analysis-of-tourist-arrivals-in-the-philippines-2023)
  - [Table of Content](#table-of-content)
  - [Project Overview](#project-overview)
  - [Objectives](#objectives)
  - [Dataset](#dataset)
  - [Key Findings](#key-findings)
  - [Sample Queries](#sample-queries)
    - [SQL Queries](#sql-queries)
  - [Tools \& Technologies](#tools--technologies)
  - [License](#license)


## <br>Project Overview
This project analyzes international visitor arrivals to the Philippines from **January to October 2023**, using official data by country of residence from the Department of Tourism.

## <br>Objectives
This project aims to uncover key tourism insights: 
- Top Source Markets
- Growth Trends
- Market Concentration
- Peak and Low Seasons

## <br>Dataset
- table name: `tourist`
- key columns: `country`, `january`, `february`,...,`october`, `total`
- dataset source: [data.gov.ph](https://data.gov.ph/index/public/dataset/Tourism%20Demand%20Statistics%20on%20Visitor%20Arrivals%20to%20the%20Philippines/pqj5mu1b-5tsg-7dcb-oj3y-s1jcu1ys2h3a)

## <br>Key Findings
- **Peak season** ran from **January to April**, recording the highest monthly arrivals.
- **Low season** spans **May to October**, with every month falling **below the 10-month average**.
- **South Korea, USA, Japan, and China** were the dominant source markets throughout the period.
- **July** recorded the strongest month-on-month rebound among several key markets:
  | Country       | July MoM Growth |
  |---------------|-----------------|
  | United Kingdom| **+93.14%**     |
  | China         | **+55.26%**     |
  | Canada        | **+49.55%**     |
  | South Korea   | **+19.86%**     |
- **South Korea** led with the largest market share at **28.71%** of total arrivals (Jan–Oct 2023).
- **Most stable/consistent performer**: South Korea (top 1 ranking almost every month).

## <br>Sample Queries
### SQL Queries
1. Growth Trends for Leading Countries
    <details>
    <summary><i>click to show sql</i></summary>

    ```sql
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
    ```
    </details>

2. Peak and Low Seasons
    <details>
    <summary><i>click to show sql</i></summary>

    ```sql
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
    ```
    </details>

3. Top 10 Countries per Month by Tourist Arrivals
    <details>
    <summary><i>click to show sql</i></summary>

    ```sql
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

    ```
    </details>
## <br>Tools & Technologies

- **Python**  
  - `pdfplumber` – PDF extraction  
  - `pandas` – data transformation and analysis  
  - `SQLAlchemy` – PostgreSQL connection  
  
- **Database & Querying**  
  - PostgreSQL (extensive SQL queries: CTEs, window functions, aggregates, etc.)
  
- **Other Tools**  
  - Microsoft Excel

## <br>License
For educational and research purposes. Please credit DepEd Philippines when using in reports or projects.

<br><hr>
*Built by Ryannn06*