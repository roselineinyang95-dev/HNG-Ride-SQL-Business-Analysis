----Q3: Compare quarterly revenue from 2021–2024. Which quarter had the biggest year-over-year growth?
SELECT
    YEAR(r.request_time) AS ride_year,
    DATEPART(QUARTER, r.request_time) AS ride_quarter,
    SUM(p.amount) AS quarterly_revenue
FROM rides_clean r
INNER JOIN payments_clean p
    ON r.ride_id = p.ride_id
WHERE p.amount > 0
    AND r.request_time >= '2021-06-01'
    AND r.request_time < '2025-01-01'
GROUP BY
    YEAR(r.request_time),
    DATEPART(QUARTER, r.request_time)
ORDER BY
    ride_year,
    ride_quarter;

---Calculating Yoy growth
WITH QuarterlyRevenue AS (
    SELECT
        YEAR(r.request_time) AS ride_year,
        DATEPART(QUARTER, r.request_time) AS ride_quarter,
        SUM(p.amount) AS quarterly_revenue
    FROM rides_clean r
    INNER JOIN payments_clean p
        ON r.ride_id = p.ride_id
    WHERE p.amount > 0
        AND r.request_time >= '2021-06-01'
        AND r.request_time < '2025-01-01'
    GROUP BY
        YEAR(r.request_time),
        DATEPART(QUARTER, r.request_time)
),
RevenueWithPreviousYear AS (
    SELECT
        ride_year,
        ride_quarter,
        quarterly_revenue,
        LAG(quarterly_revenue) OVER (
            PARTITION BY ride_quarter
            ORDER BY ride_year
        ) AS previous_year_revenue
    FROM QuarterlyRevenue
)
SELECT
    ride_year,
    ride_quarter,
    quarterly_revenue,
    previous_year_revenue,
    ROUND(
        ((quarterly_revenue - previous_year_revenue)
        / NULLIF(previous_year_revenue, 0)) * 100,
        2
    ) AS yoy_growth_percent
FROM RevenueWithPreviousYear
ORDER BY ride_year, ride_quarter;
----2022 Q2 has the biggest YoY growth of 200.8%