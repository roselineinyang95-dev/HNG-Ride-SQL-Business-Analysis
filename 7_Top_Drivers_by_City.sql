----Q7...Top 3 drivers in each city by total revenue
---Calaculate revenue per driver per city
SELECT
    r.pickup_city,
    d.driver_id,
    d.name AS driver_name,
    SUM(p.amount) AS total_revenue
FROM rides_clean r
INNER JOIN drivers_clean d
    ON r.driver_id = d.driver_id
INNER JOIN payments_clean p
    ON r.ride_id = p.ride_id
WHERE p.amount > 0
    AND r.request_time >= '2021-06-01'
    AND r.request_time < '2025-01-01'
GROUP BY
    r.pickup_city,
    d.driver_id,
    d.name
ORDER BY
    r.pickup_city,
    total_revenue DESC;

---Getting top 3
WITH DriverCityRevenue AS (
    SELECT
        r.pickup_city,
        d.driver_id,
        d.name AS driver_name,
        SUM(p.amount) AS total_revenue
    FROM rides_clean r
    INNER JOIN drivers_clean d
        ON r.driver_id = d.driver_id
    INNER JOIN payments_clean p
        ON r.ride_id = p.ride_id
    WHERE p.amount > 0
        AND r.request_time >= '2021-06-01'
        AND r.request_time < '2025-01-01'
    GROUP BY
        r.pickup_city,
        d.driver_id,
        d.name
),
RankedDrivers AS (
    SELECT
        pickup_city,
        driver_id,
        driver_name,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY pickup_city
            ORDER BY total_revenue DESC
        ) AS city_rank
    FROM DriverCityRevenue
)
SELECT
    pickup_city,
    driver_id,
    driver_name,
    total_revenue,
    city_rank
FROM RankedDrivers
WHERE city_rank <= 3
ORDER BY
    pickup_city,
    city_rank;
