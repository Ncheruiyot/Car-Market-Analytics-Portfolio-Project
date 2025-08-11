CREATE DATABASE CARS;

USE CARS;

SELECT * FROM CARS_2025;

DESCRIBE CARS_2025;

-- DATA CLEANING --
SELECT 
  COUNT(*) AS TOTAL_ROWS,
  SUM(CASE WHEN `COMPANY NAMES` IS NULL OR `COMPANY NAMES` = '' THEN 1 ELSE 0 END) AS NULL_COMPANY,
  SUM(CASE WHEN `CARS NAMES` IS NULL OR `CARS NAMES` = '' THEN 1 ELSE 0 END) AS NULL_CAR_NAME,
  SUM(CASE WHEN `ENGINES` IS NULL OR `ENGINES` = '' THEN 1 ELSE 0 END) AS NULL_ENGINES,
  SUM(CASE WHEN `CC/BATTERY CAPACITY` IS NULL OR `CC/BATTERY CAPACITY` = '' THEN 1 ELSE 0 END) AS NULL_CCBATTERY_CAPACITY,
  SUM(CASE WHEN `HORSEPOWER` IS NULL OR `HORSEPOWER` = '' THEN 1 ELSE 0 END) AS NULL_HORSEPOWER,
  SUM(CASE WHEN `TOTAL SPEED` IS NULL OR `TOTAL SPEED` = '' THEN 1 ELSE 0 END) AS NULL_TOTAL_SPEEDR,
  SUM(CASE WHEN `PERFORMANCE(0 - 100 )KM/H` IS NULL OR `PERFORMANCE(0 - 100 )KM/H` = '' THEN 1 ELSE 0 END) AS NULL_PERFORMANCE,
  SUM(CASE WHEN `CARS PRICES` IS NULL OR `CARS PRICES` = '' THEN 1 ELSE 0 END) AS NULL_CAR_PRICES,
  SUM(CASE WHEN `FUEL TYPES` IS NULL OR `FUEL TYPES` = '' THEN 1 ELSE 0 END) AS NULL_FUEL_TYPES,
  SUM(CASE WHEN `SEATS` IS NULL OR `SEATS` = '' THEN 1 ELSE 0 END) AS NULL_SEATS,
  SUM(CASE WHEN `TORQUE` IS NULL OR `TORQUE` = '' THEN 1 ELSE 0 END) AS NULL_TORQUE
FROM CARS_2025;

SELECT * FROM CARS_2025
WHERE `CC/BATTERY CAPACITY` IS NULL 
OR TRIM(`CC/BATTERY CAPACITY`) = '' ;

DELETE FROM CARS_2025
WHERE `CC/BATTERY CAPACITY` IS NULL 
OR `CC/BATTERY CAPACITY` = '' ;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;


-- ANALYSIS--
SELECT * FROM cars_2025;
-- 1. Count the number of unique car brands and models
SELECT COUNT(DISTINCT `Company Names`) AS total_brands,
       COUNT(DISTINCT `Cars Names`) AS total_models
FROM cars_2025;


-- 2. Top 10 Most Powerful Cars (by HorsePower)
SELECT `Company Names`, `Cars Names`, `HorsePower`
FROM cars_2025
ORDER BY CAST(REPLACE(REPLACE(`HorsePower`, ' hp', ''), ',', '') AS UNSIGNED) DESC
LIMIT 10;

-- 3. Fastest Cars (by Total Speed)
SELECT `Company Names`, `Cars Names`, `Total Speed`
FROM cars_2025
ORDER BY CAST(REPLACE(REPLACE(`Total Speed`, ' km/h', ''), ',', '') AS UNSIGNED) DESC
LIMIT 10;

-- 4. Cars with Best Acceleration (smallest 0-100 time)
SELECT `Company Names`, `Cars Names`, `Performance(0 - 100 )KM/H`
FROM cars_2025
WHERE `Performance(0 - 100 )KM/H` IS NOT NULL AND `Performance(0 - 100 )KM/H` != 'N/A'
ORDER BY CAST(REPLACE(REPLACE(REPLACE(`Performance(0 - 100 )KM/H`, ' sec', ''), 's', ''), ',', '') AS DECIMAL(4,2)) ASC
LIMIT 10;

-- 5. Price Range Analysis (Min, Max, Avg) - Remove $ and commas, handle ranges
SELECT
  MIN(CAST(REPLACE(SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(REPLACE(`Cars Prices`, '$', ''), ' ', ''), ',', ''), '�', ''), '-', 1), ',', '') AS UNSIGNED)) AS min_price,
  MAX(CAST(REPLACE(SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(REPLACE(`Cars Prices`, '$', ''), ' ', ''), ',', ''), '�', ''), '-', -1), ',', '') AS UNSIGNED)) AS max_price,
  AVG(CAST(REPLACE(SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(REPLACE(`Cars Prices`, '$', ''), ' ', ''), ',', ''), '�', ''), '-', 1), ',', '') AS UNSIGNED)) AS avg_price
FROM cars_2025
WHERE `Cars Prices` IS NOT NULL AND `Cars Prices` != '';

-- 6. Count of Cars by Fuel Type
SELECT `Fuel Types`, COUNT(*) AS total
FROM cars_2025
GROUP BY `Fuel Types`
ORDER BY total DESC;

SELECT * FROM cars_2025;

-- 7. Average Horsepower and Torque by Brand
SELECT `Company Names`,
       AVG(CAST(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`HorsePower`, ' ', 1), ',', ''), 'hp', ''), 'HP', '') AS UNSIGNED)) AS avg_hp,
       AVG(CAST(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`Torque`, ' ', 1), ',', ''), 'Nm', ''), 'NM', ''), '+', '') AS UNSIGNED)) AS avg_torque
FROM cars_2025
GROUP BY `Company Names`
ORDER BY avg_hp DESC;

-- 8. Distribution of Seating Capacity
SELECT `Seats`, COUNT(*) AS num_models
FROM cars_2025
GROUP BY `Seats`
ORDER BY CAST(REPLACE(REPLACE(REPLACE(`Seats`, '+', ''), '-', ''), ' ', '') AS UNSIGNED);

-- 9. Count of Cars by Engine Type
SELECT `Engines`, COUNT(*) AS total
FROM cars_2025
GROUP BY `Engines`
ORDER BY total DESC;

-- 10. Find All Electric Cars
SELECT `Company Names`, `Cars Names`, `Engines`, `CC/Battery Capacity`, `HorsePower`, `Total Speed`, `Cars Prices`
FROM cars_2025
WHERE LOWER(`Fuel Types`) LIKE '%electric%';

-- 11. Top 5 Most Expensive Cars
SELECT `Company Names`, `Cars Names`, `Cars Prices`
FROM cars_2025
ORDER BY CAST(REPLACE(REPLACE(REPLACE(REPLACE(`Cars Prices`, '$', ''), ' ', ''), ',', ''), '�', '') AS UNSIGNED) DESC
LIMIT 5;

-- 12. Brand with Most Models 
SELECT `Company Names`, COUNT(*) AS model_count
FROM cars_2025
GROUP BY `Company Names`
ORDER BY model_count DESC
LIMIT 1;

-- 13. Count Cars by Type of Engine (e.g., V6, V8, I4, etc.)
SELECT `Engines`, COUNT(*) AS num_models
FROM cars_2025
GROUP BY `Engines`
ORDER BY num_models DESC;

-- 14. Average 0-100 Acceleration by Brand (for available data)
SELECT `Company Names`,
       AVG(CAST(REPLACE(REPLACE(REPLACE(`Performance(0 - 100 )KM/H`, ' sec', ''), 's', ''), ',', '') AS DECIMAL(4,2))) AS avg_0_100
FROM cars_2025
WHERE `Performance(0 - 100 )KM/H` IS NOT NULL AND `Performance(0 - 100 )KM/H` != 'N/A'
GROUP BY `Company Names`
ORDER BY avg_0_100 ASC;

-- 15. Hybrid Cars by Brand
SELECT `Company Names`, COUNT(*) AS hybrid_models
FROM cars_2025
WHERE LOWER(`Fuel Types`) LIKE '%hybrid%'
GROUP BY `Company Names`
ORDER BY hybrid_models DESC;

-- 16. For Each Brand, Show Fastest Model
SELECT t1.`Company Names`, t1.`Cars Names`, t1.`Total Speed`
FROM cars_2025 t1
INNER JOIN (
    SELECT `Company Names`, MAX(CAST(REPLACE(REPLACE(`Total Speed`, ' km/h', ''), ',', '') AS UNSIGNED)) AS max_speed
    FROM cars_2025
    GROUP BY `Company Names`
) t2
ON t1.`Company Names` = t2.`Company Names`
AND CAST(REPLACE(REPLACE(t1.`Total Speed`, ' km/h', ''), ',', '') AS UNSIGNED) = t2.max_speed
ORDER BY t2.max_speed DESC;

-- 17. Count of Cars per Torque Ranges (Group by 0-200, 200-400, 400-600, etc.)
SELECT
  CASE
    WHEN CAST(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`Torque`, ' ', 1), ',', ''), 'Nm', ''), 'NM', ''), '+', '') AS UNSIGNED) < 200 THEN '<200 Nm'
    WHEN CAST(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`Torque`, ' ', 1), ',', ''), 'Nm', ''), 'NM', ''), '+', '') AS UNSIGNED) BETWEEN 200 AND 399 THEN '200-399 Nm'
    WHEN CAST(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`Torque`, ' ', 1), ',', ''), 'Nm', ''), 'NM', ''), '+', '') AS UNSIGNED) BETWEEN 400 AND 599 THEN '400-599 Nm'
    WHEN CAST(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`Torque`, ' ', 1), ',', ''), 'Nm', ''), 'NM', ''), '+', '') AS UNSIGNED) BETWEEN 600 AND 799 THEN '600-799 Nm'
    WHEN CAST(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(`Torque`, ' ', 1), ',', ''), 'Nm', ''), 'NM', ''), '+', '') AS UNSIGNED) >= 800 THEN '800+ Nm'
    ELSE 'Unknown'
  END AS torque_range,
  COUNT(*) AS num_models
FROM cars_2025
GROUP BY torque_range
ORDER BY torque_range;

-- 18. Average Price by Fuel Type
SELECT `Fuel Types`,
  AVG(CAST(REPLACE(SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(REPLACE(`Cars Prices`, '$', ''), ' ', ''), ',', ''), '�', ''), '-', 1), ',', '') AS UNSIGNED)) AS avg_price
FROM cars_2025
WHERE `Cars Prices` IS NOT NULL AND `Cars Prices` != ''
GROUP BY `Fuel Types`
ORDER BY avg_price DESC;

-- 19. Most Common Battery Capacity (for Electric Cars)
SELECT `CC/Battery Capacity`, COUNT(*) as count
FROM cars_2025
WHERE LOWER(`Fuel Types`) LIKE '%electric%'
GROUP BY `CC/Battery Capacity`
ORDER BY count DESC
LIMIT 1;

-- 20. All Plug-in Hybrid Cars
SELECT `Company Names`, `Cars Names`, `Cars Prices`
FROM cars_2025
WHERE LOWER(`Fuel Types`) LIKE '%plug-in hybrid%' OR LOWER(`Fuel Types`) LIKE '%plug in hybrid%';