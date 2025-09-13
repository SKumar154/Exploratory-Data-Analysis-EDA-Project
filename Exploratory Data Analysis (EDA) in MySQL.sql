-- EXPLORATORY DATA ANALYSIS

SELECT * FROM layoffs_dummy;

SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM layoffs_dummy; -- Maxmimum no of people laid off and what percentage (1 means 100%)

SELECT * 
FROM layoffs_dummy
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; -- This will show which companied laid off 100% of the employees and the total no in DESC order.

-- Lets se how many companies raised funds in millions 
SELECT * 
FROM layoffs_dummy
WHERE percentage_laid_off = 1 -- Companies that raised funds by laying off 100% of employees
ORDER BY funds_raised_millions DESC; 

-- Total no of people laid off 
SELECT company, SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY company
ORDER BY 2 DESC; -- Total people laid off in the time period

-- Finding out the time period
SELECT MAX(`date`), MIN(`date`)
FROM layoffs_dummy; -- Date range (almost 3 years)

-- What industry got hit the most during this time
SELECT industry, SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY industry
ORDER BY 2 DESC; -- Industries that got hit by the layoffs

-- Which country was affected the most
SELECT country, SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY country
ORDER BY 2 DESC; -- Countries impacted the most

-- Which date has the most layoff
SELECT `date`,SUM(total_laid_off) 
FROM layoffs_dummy 
GROUP BY `date`
ORDER BY 1 DESC; -- Date-wise layoffs (Descending Order)

-- Year wise layoff
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; -- Year-wise payoffs

-- Rolling Sum
SELECT SUBSTRING(`date`,1,7) AS Month
, SUM(total_laid_off)
FROM layoffs_dummy
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY Month
ORDER BY 1 ASC; -- Total layoffs every month

-- Now actually doing a rolling sum using CTE

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS Month, SUM(total_laid_off) AS Total_layoff
FROM layoffs_dummy
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY Month
ORDER BY 1 ASC
)
SELECT `Month`, Total_layoff, SUM(Total_layoff) OVER(ORDER BY `Month`) AS total 
FROM Rolling_Total; -- This gives us the rolling total (adds on the next month)

-- Total layeoffs by company, year and total layoffs
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_dummy
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- What i wanna do is rank the companies based on highest layoff
WITH Company_Rank (Company, Years, Total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_dummy
GROUP BY company, YEAR(`date`)
), Top_Companies AS -- Using another CTE for getting year-wise top 5 companies
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS Rankings 
FROM Company_Rank
WHERE Years IS NOT NULL
) -- Biggest layoffs
SELECT *
FROM Top_Companies
WHERE Rankings <=5; -- Top 5 companies in layoffs year by year 

-- We can also look on the basis of industry or by month and all such things. 

-- DONE EVERYTHING