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

## 📈 Analysis Queries

The following analyses are included:

<img width="538" height="193" alt="Screenshot 2025-08-11 230647" src="https://github.com/user-attachments/assets/a1939bbe-e4ab-468b-b41b-2e4c44a4ee63" />

<img width="735" height="421" alt="Screenshot 2025-08-11 231514" src="https://github.com/user-attachments/assets/12ec0ddf-e27b-4db3-b7bd-829a8e4bac98" />

<img width="763" height="377" alt="Screenshot 2025-08-11 231601" src="https://github.com/user-attachments/assets/c4a5d172-c077-4b35-81c4-458f5727bd95" />
<img width="1027" height="413" alt="Screenshot 2025-08-11 231653" src="https://github.com/user-attachments/assets/714e050d-a596-458e-8357-e0c276355be7" />
<img width="1413" height="270" alt="Screenshot 2025-08-11 232129" src="https://github.com/user-attachments/assets/36435c58-02e0-4e70-a0b1-1df718994124" />
<img width="481" height="475" alt="Screenshot 2025-08-11 232317" src="https://github.com/user-attachments/assets/315a58d4-59ad-4a96-bc01-f3e76be554bf" />

---

## 🌟 Key Findings

- *Electric and hybrid vehicles are increasingly represented, especially among high-performance models.*
- *Luxury and supercar brands dominate the top horsepower and speed rankings.*
- *The price range is vast, with both affordable and ultra-luxury options present.*

---

## 🚀 How to Use

1. **Clone the repository**

   ```sh
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

2. **Open MySQL Workbench**
3. **Import the dataset** (`Cars Datasets 2025.csv`) into your `CARS` database as table `cars_2025`.
4. **Run the analysis scripts** in [`analysis.sql`](analysis.sql).
5. **Review the output** and use it for further reporting or visualization.

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome! Please open an [issue](https://github.com/yourusername/your-repo-name/issues) or submit a pull request.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

**Author:** [Your Name]  
**Year:** 2025

---
