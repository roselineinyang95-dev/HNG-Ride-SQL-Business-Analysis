## PROJECT OVERVIEW
This project involved using SQL Server to query and analyze ride-hailing data to identify patterns and generate insights from the database. The project demonstrates how SQL can be used to transform raw operational data into business insights that can support decision-making.

## Objectives
The objective of this project was to review performance for the period of June 2021 to December 2024 to understand how operations have evolved and where to improve. It was to answer eight business questions around ride activity, rider retention, revenue growth, driver performance, cancellation rates, payment behavior, city-level performance, and driver eligibility for bonuses.

## Dataset: HNG Ride 
The HNG Ride dataset contains data from a mid-sized transportation company and ride-hailing business operating in North American cities, covering ride activity from June 2021 to December 2024. The database contains four related business tables: 
Drivers — driver profiles, cities, signup dates, and ratings

Riders — rider profiles, cities, signup dates, and email information

Rides — ride requests, pickup/drop-off times, locations, distance, status, and fare

Payments — payment records, amounts, payment methods, and payment dates
The raw data contained approximately 2,000 drivers, 10,000 riders, 5,000 payment records, and 5,000 ride records in the initial files, with the analysis database ultimately containing 50,000 ride records. 
For the analysis, a completed ride was defined as having a payment amount greater than zero.

## Data Cleaning and Preparation
The raw tables were cleaned and transformed before analysis. Key preparation steps included removing or investigating duplicates, standardizing inconsistent city and status values, correcting payment-method variations, converting text-based numeric fields into appropriate data types, handling invalid fares and payment amounts, and validating dates, ratings, and relationships between tables. 
Clean versions of the tables were then created for analysis: drivers_clean, riders_clean, rides_clean,payments_clean.

## Analysis
The analysis was performed in SQL Server using relational database techniques including: JOIN, GROUP BY, Aggregate functions, CASE statements, Date and time functions, Filtering and conditional logic, Common Table Expressions, Window functions/ranking, Calculated metrics, Quarterly and year-over-year analysis.
The analysis focused on eight key business operations.
1. Longest Rides: I identified the longest rides in the dataset and found that the 10 longest were tied at 9.99km.
2. 2021 Riders Who Rode in 2024: I examined riders who signed up in 2021 and determined how many of them had ride activity in 2024.
3. Quarterly Revenue & Year-over-Year Growth: I analyzed revenue by quarter and compared performance across years.
4. Driver Consistency: Driver activity was analyzed based on rides completed relative to the number of months in which each driver was active.
5. Cancellation Rates by City: Cancellation rates were calculated across cities to identify locations with higher cancellation activity.
6. Riders with more than 10 Rides and no cash payments: I identified riders who completed more than 10 rides while using payment methods other than cash.
7. Top-Earning Drivers by City: Driver revenue was compared across cities to identify high-performing drivers.
8. Bonus-Qualified Drivers: I identified drivers meeting the specified performance criteria based on rating, completed rides, and cancellation rate.

## Key Insights
The SQL analysis revealed several important patterns within the ride-hailing data:
** 

















