---Q2. How many riders who signed up in 2021 still rides in 2024?
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