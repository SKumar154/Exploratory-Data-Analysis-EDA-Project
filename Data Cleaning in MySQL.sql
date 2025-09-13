-- Data Cleaning

SELECT * FROM layoffs;

-- 1. Remove duplicates if any
-- 2. Standardize the data
-- 3. NULL Values and Blank Values
-- 4. Remove unnecessary columns

# To start doing chnages -- First of all create a dummy database similar to that of the original, so that if you make any mistake while makeing the changes it doesn't directly affect the raw data.
# Creating copy of raw data

CREATE TABLE layoffs_dummy
LIKE layoffs; # Created all the column headings

SELECT * FROM layoffs_dummy;

INSERT layoffs_dummy
SELECT * FROM layoffs; # Inserted all the values from the raw dataset

# If we make any kind of mistake, we should have the raw dataset

-- REMOVING DUPLICATES
# Creating a new column for identifying duplicates (Row Number - Window Func)

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off,`date`, 
stage, country, funds_raised_millions) AS `index`
FROM layoffs_dummy; -- If the row number is 2 or above that means there are duplicates

-- Putting into a CTE
WITH duplicate_CTE AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off,`date`, 
stage, country, funds_raised_millions) AS `index`
FROM layoffs_dummy
)
SELECT * FROM duplicate_CTE 
WHERE `index` > 1;

-- Checking if they are actual duplicates
SELECT * FROM layoffs_dummy
WHERE company = 'Casper';

-- Now we cannot delete the duplicates from a CTE as a CTE are unupdatable so we are going to create a new table

CREATE TABLE `layoffs_remove_duplicates` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `index` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_remove_duplicates
WHERE `index` > 1; -- Checking the duplicate rows once

INSERT INTO layoffs_remove_duplicates
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off,`date`, 
stage, country, funds_raised_millions) AS `index`
FROM layoffs_dummy;

-- Deleting duplicate rows
DELETE 
FROM layoffs_remove_duplicates
WHERE `index` > 1; 

SELECT * FROM layoffs_remove_duplicates
WHERE `index` > 1; -- Rechecking if duplicates are removed 



-- STANDARDIZING DATA (finding issues and fixing it)

-- Removing unnecessary spaces

SELECT company , TRIM(company) -- Removing leading spaces
FROM layoffs_dummy;

UPDATE layoffs_dummy
SET company = TRIM(company); -- Updating the trimmed values

SELECT * FROM layoffs_dummy; -- Updated table

-- Checking for similar names of industry 

SELECT DISTINCT industry
FROM layoffs_dummy
ORDER BY industry; -- You can also order by 1 

# After this statement you can see similar names that need to be as one industry

SELECT * 
FROM layoffs_dummy
WHERE industry LIKE 'Crypto%'; -- Similar names of industries

UPDATE layoffs_dummy
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; -- Removed the similar name industries

SELECT * FROM layoffs_dummy
WHERE industry LIKE 'Crypto%'; -- DONE

-------------------
SELECT DISTINCT country FROM layoffs_dummy
ORDER BY country; -- Found an error in United States name as United States.

UPDATE layoffs_dummy
SET country = 'United States'
WHERE country LIKE 'United States%'; -- Removed the spell error

# Another advance method of this would be
# SELECT country , TRIM(TRAILING '.' FROM country)
# FROM layoffs_dummy
-----------------------------
-- Changing the definition of a column
-- The date column is in text

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y') -- (column_name , format)
FROM layoffs_dummy;

UPDATE layoffs_dummy
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');  -- Updating the date column

SELECT `date` FROM layoffs_dummy ORDER BY 1; -- Checking the date 

-- Now if we look, the date column is still text .. we need to change it

ALTER TABLE layoffs_dummy
MODIFY COLUMN `date` DATE; -- Updated the date column

-------------------

SELECT * FROM layoffs_dummy;

-- CHECKING FOR NULL OR BLANK VALUES

SELECT * FROM layoffs_dummy
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_dummy
WHERE industry IS NULL OR industry = ''; -- Check if we can fill them

SELECT * FROM layoffs_dummy
WHERE company LIKE 'Bally%';

UPDATE layoffs_dummy
SET industry = NULL -- To first convert blank values to NULL
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_dummy t1
JOIN layoffs_dummy t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_dummy t1
JOIN layoffs_dummy t2
	ON t1.company = t2.company 
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Deleting rows that have total and percentage layoff as NULL

SELECT * FROM layoffs_dummy
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_dummy
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_dummy;

-- DONE EVERYTHING