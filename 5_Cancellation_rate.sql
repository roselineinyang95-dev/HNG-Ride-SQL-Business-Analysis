---Q.5---Canacellation Rate per city
---Counting total and cancelled rides by city
SELECT
    r.pickup_city,
    COUNT(*) AS total_rides,
    SUM(
        CASE
            WHEN r.status = 'cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_rides
FROM rides_clean r
WHERE r.request_time >= '2021-06-01'
    AND r.request_time < '2025-01-01'
GROUP BY r.pickup_city
ORDER BY cancelled_rides DESC;

----Calculating Cancellation Rate
SELECT
    r.pickup_city,
    COUNT(*) AS total_rides,
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
WHERE r.request_time >= '2021-06-01'
    AND r.request_time < '2025-01-01'
GROUP BY r.pickup_city
ORDER BY cancellation_rate_percent DESC;