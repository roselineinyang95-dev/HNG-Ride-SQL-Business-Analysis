-----Q1. What are the top 10 longest rides by distance?including Driver name, Rider name, Pickup/Dropoff Cities and Payment Method.
SELECT TOP 10
    r.ride_id,
    d.name AS driver_name,
    ri.name AS rider_name,
    r.pickup_city,
    r.dropoff_city,
    r.distance_km,
    p.method AS payment_method
FROM rides_clean r
INNER JOIN drivers_clean d
    ON r.driver_id = d.driver_id
INNER JOIN riders_clean ri
    ON r.rider_id = ri.rider_id
INNER JOIN payments_clean p
    ON r.ride_id = p.ride_id
WHERE p.amount > 0
ORDER BY r.distance_km DESC;

---Q2. How many riders who signed up in 2021 still rides in 2024?
SELECT COUNT(*) AS riders_signed_up_2021
FROM riders_clean
WHERE signup_date >= '2021-01-01'
  AND signup_date< '2022-01-01';

SELECT COUNT(DISTINCT r.rider_id) AS riders_from_2021_who_rode_in_2024
FROM riders_clean ri
INNER JOIN rides_clean r
    ON ri.rider_id = r.rider_id
INNER JOIN payments_clean p
    ON r.ride_id = p.ride_id
WHERE ri.signup_date >= '2021-01-01'
  AND ri.signup_date < '2022-01-01'
  AND r.request_time >= '2024-01-01'
  AND r.request_time < '2025-01-01'
  AND p.amount > 0;

---Q.3..Compare quartely revenue from 2021-2024. Which quarter had the biggest year-over-year growth?
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
