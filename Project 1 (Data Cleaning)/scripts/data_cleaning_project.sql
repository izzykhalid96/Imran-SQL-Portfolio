
-- DATA CLEANING PROJECT 

-- 1. Remove Duplicates

-- Duplicate raw data to prevent data loss 
SELECT * FROM layoffs;
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging 
SELECT * FROM layoffs;

-- Check table if there's any duplicates
SELECT *,ROW_NUMBER () OVER (PARTITION BY company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num FROM layoffs_staging;

WITH duplicate_cte AS (SELECT *,ROW_NUMBER () OVER (PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num FROM layoffs_staging )

-- If there are duplicates, the row_num will be 2 or above
SELECT * FROM duplicate_cte WHERE row_num > 1;

SELECT * FROM layoffs_staging
WHERE company = 'Casper' ;

-- Create duplicate table to prevent data loss from layoff_duplicate
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM layoffs_staging2;
INSERT INTO layoffs_staging2 SELECT *,ROW_NUMBER () OVER (PARTITION BY company, location,  industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num FROM layoffs_staging;

DELETE FROM layoffs_staging2
WHERE row_num >1 ;
-- Had error code 1175 because using safe mode. this is how I turn the safety off
SET SQL_SAFE_UPDATES = 0;

-- Once done, I turn the safety on just to be safe
SET SQL_SAFE_UPDATES = 1;

-- When run the query below, there are no row returned, suggesting that the duplicates has been successfully removed
SELECT * FROM layoffs_staging2
WHERE row_num >1 ;

-- 2. Standardize the Data 
-- In company column, some rows have white space. To remove it, I will need to trim the column
SELECT company, TRIM(company) FROM layoffs_staging2;
-- Can't update without turning the safety off
SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2
SET company = TRIM(company);
SELECT * FROM layoffs_staging2;

-- Turning safety on once done
SET SQL_SAFE_UPDATES = 1;


SELECT DISTINCT industry FROM layoffs_staging2
ORDER BY 1;
-- In industry column, there are a few duplicate industries (eg. Crypto and Cryptocurrency). Need to update all of the industries to Crypto only.

SELECT * FROM layoffs_staging2
WHERE industry LIKE '%Crypto%';

SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

SET SQL_SAFE_UPDATES = 1;

SELECT DISTINCT country FROM layoffs_staging2
ORDER BY 1;

-- When checking the country row, there's duplicate in United States (United States and United States.)
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%United States%';

-- Set date from string to date

SELECT * FROM layoffs_staging2;
UPDATE layoffs_staging2
SET  `date` = str_to_date(`date`,'%m/%d/%Y');

SET SQL_SAFE_UPDATES = 1;


-- 3. Deleting Null Values or blank values
-- Checking if the industry column has blank or null values

SELECT * FROM layoffs_staging2
WHERE industry IS NULL OR industry ='' ;

SELECT * FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company AND t1.location = t2.location

WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

-- Changing the blank values to NULL so that the data can be cleared together
SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2
SET industry  = NULL 
WHERE industry = '';

-- add the industry values for same company in the same location for the blank or null values

UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2 
ON t1.company = t2.company AND t1.location = t2.location

SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

SET SQL_SAFE_UPDATES = 1;

-- Removing rows that has null value in total laid off and percentage laid off column
SELECT * FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL
OR industry = '';


SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL
OR industry = '';

SELECT * FROM layoffs_staging2;


-- 4. Remove Any Columns
-- Removing row_num column since we do not need it anymore
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM layoffs_staging2;