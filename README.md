# 🚗 Car Market Analytics SQL Portfolio Project

Welcome to the Car Market Analytics SQL Project!  
This repository demonstrates advanced SQL data analysis skills using a rich automotive dataset. The project focuses on data cleaning, exploration, and insights about car brands, models, performance, pricing, fuel types, and technology trends for the year 2025.

---

## 🎯 Project Overview

This portfolio project uses MySQL Workbench to analyze a comprehensive car dataset, demonstrating SQL capabilities in:

- Data cleaning and preparation
- Exploratory data analysis
- Aggregation, filtering, grouping, and string manipulation
- Reporting actionable insights

---

## 📊 Dataset Description

- **Source:** https://www.kaggle.com/datasets/abdulmalik1518/cars-datasets-2025
- **Fields:** Brand, Model, Engine, CC/Battery Capacity, Horsepower, Total Speed, Acceleration, Price, Fuel Type, Seats, Torque
- **Scope:** Includes major manufacturers and models for 2025, covering performance, economy, electric, and hybrid cars.

---

## 🛠️ Database Setup

1. **Create Database and Table**

   ```sql
   CREATE DATABASE CARS;
   USE CARS;
   ```

2. **Import Dataset**

   - Use MySQL Workbench's "Table Data Import Wizard" to load [Cars Datasets 2025.csv](Cars%20Datasets%202025.csv) into a table named `cars_2025`.

3. **Verify Table Structure**

   ```sql
   DESCRIBE cars_2025;
   SELECT * FROM cars_2025 LIMIT 5;
   ```

---

## 🧹 Data Cleaning

- Check for missing or blank values in critical columns
- Remove rows with missing essential information
- Standardize and clean price, horsepower, and torque fields for numeric analysis

```sql

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
```
---

## 📈 Analysis Queries and Key Findings
```sql
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
```

<img width="538" height="193" alt="Screenshot 2025-08-11 230647" src="https://github.com/user-attachments/assets/a1939bbe-e4ab-468b-b41b-2e4c44a4ee63" />

<img width="735" height="421" alt="Screenshot 2025-08-11 231514" src="https://github.com/user-attachments/assets/12ec0ddf-e27b-4db3-b7bd-829a8e4bac98" />

<img width="763" height="377" alt="Screenshot 2025-08-11 231601" src="https://github.com/user-attachments/assets/c4a5d172-c077-4b35-81c4-458f5727bd95" />
<img width="1027" height="413" alt="Screenshot 2025-08-11 231653" src="https://github.com/user-attachments/assets/714e050d-a596-458e-8357-e0c276355be7" />
<img width="1413" height="270" alt="Screenshot 2025-08-11 232129" src="https://github.com/user-attachments/assets/36435c58-02e0-4e70-a0b1-1df718994124" />
<img width="481" height="475" alt="Screenshot 2025-08-11 232317" src="https://github.com/user-attachments/assets/315a58d4-59ad-4a96-bc01-f3e76be554bf" />
<img width="1285" height="827" alt="Screenshot 2025-08-12 105953" src="https://github.com/user-attachments/assets/2facd743-85c5-455f-aca3-f168ba9f03c7" />
<img width="788" height="388" alt="Screenshot 2025-08-12 110116" src="https://github.com/user-attachments/assets/05df3ab9-f9a3-4274-a0b0-ffe1b0fc6465" />
<img width="577" height="821" alt="Screenshot 2025-08-12 110341" src="https://github.com/user-attachments/assets/8d431110-1b2b-444e-a23e-fe12ad40aa61" />
<img width="1062" height="824" alt="Screenshot 2025-08-12 110442" src="https://github.com/user-attachments/assets/5b66607a-264c-4039-a75a-91e35501a612" />
<img width="1019" height="300" alt="Screenshot 2025-08-12 110537" src="https://github.com/user-attachments/assets/f7dd4daf-f9ff-48a2-bec7-332a79b22b65" />
<img width="621" height="260" alt="Screenshot 2025-08-12 110622" src="https://github.com/user-attachments/assets/02f3d5b0-3ebc-42eb-8918-f572495758dd" />
<img width="575" height="815" alt="Screenshot 2025-08-12 110702" src="https://github.com/user-attachments/assets/505f6e31-8899-48b8-8162-023c4fc4849a" />
<img width="1140" height="819" alt="Screenshot 2025-08-12 110803" src="https://github.com/user-attachments/assets/6af4b17d-e417-4293-af12-e7f293feb917" />
<img width="543" height="541" alt="Screenshot 2025-08-12 110902" src="https://github.com/user-attachments/assets/4501c408-8b57-4c84-9d25-9d09de34b019" />
<img width="1084" height="798" alt="Screenshot 2025-08-12 110944" src="https://github.com/user-attachments/assets/81a7dcf2-680d-41f4-91d1-2f6548cc76f7" />
<img width="1306" height="468" alt="Screenshot 2025-08-12 111101" src="https://github.com/user-attachments/assets/ac6c5c2f-a883-4aa1-9912-b6d77e42227b" />
<img width="1251" height="622" alt="Screenshot 2025-08-12 111205" src="https://github.com/user-attachments/assets/29004aca-04f0-4f8e-b03d-d615c09edbf3" />
<img width="612" height="253" alt="Screenshot 2025-08-12 111243" src="https://github.com/user-attachments/assets/fd6959a9-51f4-426a-aa25-8d4520f83749" />
<img width="785" height="316" alt="Screenshot 2025-08-12 111353" src="https://github.com/user-attachments/assets/c2b00ccf-f339-4ad3-8f2e-ddbf26ef45b8" />



---

