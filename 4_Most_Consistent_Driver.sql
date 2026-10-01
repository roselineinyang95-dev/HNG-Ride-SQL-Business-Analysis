----Q4. Most Consistent Drivers
SELECT
    d.driver_id,
    d.name AS driver_name,
    d.signup_date,
    COUNT(*) AS completed_rides
FROM drivers_clean d
INNER JOIN rides_clean r
    ON d.driver_id = r.driver_id
INNER JOIN payments_clean p
    ON r.ride_id = p.ride_id
WHERE p.amount > 0
    AND r.request_time >= '2021-06-01'
    AND r.request_time < '2025-01-01'
GROUP BY
    d.driver_id,
    d.name,
    d.signup_date
ORDER BY completed_rides DESC;

---Calculating active months
SELECT
    d.driver_id,
    d.name AS driver_name,
    d.signup_date,
    DATEDIFF(
        MONTH,
        CASE
            WHEN d.signup_date < '2021-06-01'
                THEN '2021-06-01'
            ELSE d.signup_date
        END,
        '2024-12-31'
    ) + 1 AS active_months
FROM drivers_clean d;

---Calculating Average Monthly Rides
WITH DriverRides AS (
    SELECT
        d.driver_id,
        d.name AS driver_name,
        d.signup_date,
        COUNT(*) AS completed_rides
    FROM drivers_clean d
    INNER JOIN rides_clean r
        ON d.driver_id = r.driver_id
    INNER JOIN payments_clean p
        ON r.ride_id = p.ride_id
    WHERE p.amount > 0
        AND r.request_time >= '2021-06-01'
        AND r.request_time < '2025-01-01'
    GROUP BY
        d.driver_id,
        d.name,
        d.signup_date
),
DriverMonths AS (
    SELECT
        driver_id,
        DATEDIFF(
            MONTH,
            CASE
                WHEN signup_date < '2021-06-01'
                    THEN '2021-06-01'
                ELSE signup_date
            END,
            '2024-12-31'
        ) + 1 AS active_months
    FROM drivers_clean
)
SELECT
    dr.driver_id,
    dr.driver_name,
    dr.completed_rides,
    dm.active_months,
    ROUND(
        CAST(dr.completed_rides AS DECIMAL(10,2))
        / NULLIF(dm.active_months, 0),
        2
    ) AS avg_monthly_rides
FROM DriverRides dr
INNER JOIN DriverMonths dm
    ON dr.driver_id = dm.driver_id
ORDER BY avg_monthly_rides DESC;

----Getting top 5
WITH DriverRides AS (
    SELECT
        d.driver_id,
        d.name AS driver_name,
        d.signup_date,
        COUNT(*) AS completed_rides
    FROM drivers_clean d
    INNER JOIN rides_clean r
        ON d.driver_id = r.driver_id
    INNER JOIN payments_clean p
        ON r.ride_id = p.ride_id
    WHERE p.amount > 0
        AND r.request_time >= '2021-06-01'
        AND r.request_time < '2025-01-01'
    GROUP BY
        d.driver_id,
        d.name,
        d.signup_date
),
DriverMonths AS (
    SELECT
        driver_id,
        DATEDIFF(
            MONTH,
            CASE
                WHEN signup_date < '2021-06-01'
                    THEN '2021-06-01'
                ELSE signup_date
            END,
            '2024-12-31'
        ) + 1 AS active_months
    FROM drivers_clean
)
SELECT TOP 5
    dr.driver_id,
    dr.driver_name,
    dr.completed_rides,
    dm.active_months,
    ROUND(
        CAST(dr.completed_rides AS DECIMAL(10,2))
        / NULLIF(dm.active_months, 0),
        2
    ) AS avg_monthly_rides
FROM DriverRides dr
INNER JOIN DriverMonths dm
    ON dr.driver_id = dm.driver_id
ORDER BY avg_monthly_rides DESC;