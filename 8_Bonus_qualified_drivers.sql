---Q8...Bonus qualified drivers

---checking status values in rides_clean
SELECT
    status,
    COUNT(*) AS ride_count
FROM rides_clean
GROUP BY status
ORDER BY ride_count DESC;

----checking completed rides and cancellation rate per driver
SELECT
    r.driver_id,
    d.name AS driver_name,
    d.rating,
    COUNT(*) AS total_rides,
    SUM(
        CASE
            WHEN p.amount > 0 THEN 1
            ELSE 0
        END
    ) AS completed_rides,
    SUM(
        CASE
            WHEN r.status = 'cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_rides,
    ROUND(
        CAST(
            SUM(
                CASE
                    WHEN r.status = 'cancelled' THEN 1
                    ELSE 0
                END
            ) AS DECIMAL(10,2)
        ) / COUNT(*) * 100,
        2
    ) AS cancellation_rate_percent
FROM rides_clean r
INNER JOIN drivers_clean d
    ON r.driver_id = d.driver_id
INNER JOIN payments_clean p
    ON r.ride_id = p.ride_id
WHERE r.request_time >= '2021-06-01'
    AND r.request_time < '2025-01-01'
GROUP BY
    r.driver_id,
    d.name,
    d.rating
ORDER BY
    completed_rides DESC;

----Bonus qualified drivers
WITH DriverPerformance AS (
    SELECT
        r.driver_id,
        d.name AS driver_name,
        d.rating,
        COUNT(*) AS total_rides,
        SUM(
            CASE
                WHEN p.amount > 0 THEN 1
                ELSE 0
            END
        ) AS completed_rides,
        SUM(
            CASE
                WHEN r.status = 'cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_rides,
        ROUND(
            CAST(
                SUM(
                    CASE
                        WHEN r.status = 'cancelled' THEN 1
                        ELSE 0
                    END
                ) AS DECIMAL(10,2)
            ) / COUNT(*) * 100,
            2
        ) AS cancellation_rate_percent
    FROM rides_clean r
    INNER JOIN drivers_clean d
        ON r.driver_id = d.driver_id
    INNER JOIN payments_clean p
        ON r.ride_id = p.ride_id
    WHERE r.request_time >= '2021-06-01'
        AND r.request_time < '2025-01-01'
    GROUP BY
        r.driver_id,
        d.name,
        d.rating
)
SELECT TOP 10
    driver_id,
    driver_name,
    rating,
    completed_rides,
    cancelled_rides,
    cancellation_rate_percent
FROM DriverPerformance
WHERE completed_rides >= 30
    AND rating >= 4.5
    AND cancellation_rate_percent < 5
ORDER BY
    completed_rides DESC;