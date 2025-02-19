# Imran-SQL-Portfolio


# 1. Data Cleaning Project: Layoffs Dataset

## Overview
This project focuses on cleaning a raw dataset of company layoffs using SQL. The goal was to ensure data consistency, remove duplicates, handle null values, and standardize formats for accurate analysis.

## Key Steps
1. **Duplicate Raw Data**: Created a backup of the raw data to prevent data loss.
2. **Remove Duplicates**: Identified and removed duplicate records using `ROW_NUMBER()` and CTEs.
3. **Standardize Data**:
   - Removed leading/trailing whitespaces.
   - Consolidated similar categories (e.g., "Crypto" and "Cryptocurrency" → "Crypto").
   - Fixed inconsistent country names (e.g., "United States" vs. "United States.").
   - Converted date strings to `DATE` format using `STR_TO_DATE`.
4. **Handle Null/Blank Values**:
   - Populated missing industry values based on other rows for the same company.
   - Removed records with null values in `total_laid_off` and `percentage_laid_off`.
5. **Remove Unnecessary Columns**: Deleted temporary columns like `row_num` after cleaning.

## Tools Used
- **SQL**: For data cleaning and transformation.
- **MySQL Workbench**: For executing queries and managing the database.

## Project Structure
- `data/`: Contains the raw and cleaned datasets (`layoffs.csv` and `layoffs_cleaned.csv`).
- `scripts/`: Contains the SQL script (`data_cleaning.sql`).

## Where I got my data from: 
https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv

# 2. Unluckiest Football Players Analysis (2024)

## Overview
This project identifies the **unluckiest football players** of the 2023/2024 season in the Premier League by analyzing the gap between their **expected goals (xG)** and **actual goals scored**. Using SQL and Tableau, I uncovered players who underperformed despite having high-quality chances.

## Key Insights
- **Dominic Calvert Lewin** had the worst luck score (-5.90), scoring only 7 goals from an xG of 12.9.
- **Liverpool** had 3 players in the top 10 unluckiest list, suggesting systemic issues.
- The average luck score across the league was -0.01, indicating a slight underperformance.

## Tools Used
- **SQL**: For data querying and analysis.
- **Tableau**: For visualizing the results.
- **GitHub**: For hosting the project.

## Project Structure
- `data/`: Contains the dataset (`pl_player24.csv`).
- `scripts/`: Contains the SQL query
- `visuals/`: Contains a screenshot of the Tableau dashboard.

## My Tableau Portfolio
- https://public.tableau.com/app/profile/imran.khalid1687/viz/MyDataanalystPortfolio/Sheet1

## Where I got my data from: 
https://www.kaggle.com/datasets/orkunaktas/premier-league-all-players-stats-2324

