# 📊 Layoffs Exploratory Data Analysis (EDA) - MySQL

A comprehensive **Exploratory Data Analysis** project using **MySQL** to uncover insights and patterns from a cleaned global layoffs dataset spanning 3 years of corporate restructuring data.

---

## 🚀 Key Features

- **📈 Trend Analysis** – Identified layoff patterns across time periods and industries
- **🏢 Company Rankings** – Ranked companies by total layoffs with year-over-year analysis
- **🌍 Geographic Insights** – Analyzed layoffs impact across different countries
- **📅 Temporal Patterns** – Discovered seasonal trends and rolling totals over time
- **💰 Financial Analysis** – Correlated layoffs with company funding and closure rates
- **🏭 Industry Impact** – Identified most affected sectors during economic shifts

---

## 📋 Prerequisites

Before running this analysis, ensure you have:

- MySQL (v8.0 or higher recommended)
- SQL client (MySQL Workbench, DBeaver, etc.)
- **Cleaned layoffs dataset** (from previous data cleaning project)
- Understanding of SQL aggregate functions and window functions

---

## 📊 Analysis Overview

### **Dataset Scope**
- **Time Period:** 3-year span of layoffs data
- **Geographic Coverage:** Global companies across multiple countries
- **Industries:** Technology, Crypto, Consumer, Healthcare, and more
- **Metrics:** Total layoffs, percentage layoffs, funding data, company stages

---

## 🔍 Key Analysis Areas

### **1. Maximum Impact Assessment**
*Identified the most severe layoffs in the dataset*

```sql
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_dummy;
```

### **2. Complete Company Closures**
*Found companies that laid off 100% of their workforce*

```sql
SELECT * 
FROM layoffs_dummy
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
```

### **3. Company-Level Analysis**
*Ranked companies by total layoffs across the entire period*

```sql
SELECT company, SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY company
ORDER BY 2 DESC;
```

### **4. Industry Impact Analysis**
*Determined which industries were hit hardest by layoffs*

```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY industry
ORDER BY 2 DESC;
```

### **5. Geographic Distribution**
*Analyzed layoff patterns across different countries*

```sql
SELECT country, SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY country
ORDER BY 2 DESC;
```

### **6. Temporal Trends**
*Examined layoff patterns over time with year-wise breakdown*

```sql
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_dummy
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
```

### **7. Rolling Totals Analysis**
*Calculated cumulative layoffs month-over-month using advanced SQL*

```sql
WITH Rolling_Total AS (
    SELECT SUBSTRING(`date`,1,7) AS Month, SUM(total_laid_off) AS Total_layoff
    FROM layoffs_dummy
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY Month
    ORDER BY 1 ASC
)
SELECT Month, Total_layoff, 
       SUM(Total_layoff) OVER(ORDER BY Month) AS rolling_total 
FROM Rolling_Total;
```

### **8. Top Companies by Year**
*Advanced ranking analysis using window functions and CTEs*

```sql
WITH Company_Rank AS (
    SELECT company, YEAR(`date`) as Years, SUM(total_laid_off) as Total_laid_off
    FROM layoffs_dummy
    GROUP BY company, YEAR(`date`)
), Top_Companies AS (
    SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS Rankings 
    FROM Company_Rank
    WHERE Years IS NOT NULL
) 
SELECT * FROM Top_Companies WHERE Rankings <= 5;
```

---

## 📈 Key Findings & Insights

### **🔥 Most Impacted Sectors**
| **Rank** | **Industry** | **Impact Level** |
|----------|-------------|------------------|
| 1 | Consumer Services | 🔴 Severe |
| 2 | Retail Services | 🔴 Severe |
| 3 | Transportation | 🟠 High |
| 4 | Finance | 🟡 Moderate |

### **🌍 Country-Wise Impact**
- **United States:** Highest absolute numbers
- **India:** Significantly larger
- **Netherlands:** High numbers but gradually decreasing

### **📅 Temporal Patterns**
- **Peak layoff periods:** Identified specific months with highest activity - 2022 (Worst Year)
- **Seasonal trends:** Discovered patterns in corporate restructuring timing 
- **Year-over-year growth:** Tracked escalation in layoff frequency - 2020 to 2023 (Numbers increasing drastically)

---

## 🛠️ Advanced SQL Techniques Used

- **📊 Window Functions** – `ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()`
- **🔗 Common Table Expressions (CTEs)** – For complex multi-step analysis
- **📝 String Functions** – `SUBSTRING()` for date manipulation
- **📅 Date Functions** – `YEAR()`, `STR_TO_DATE()` for temporal analysis
- **🔄 Self-Joins** – For comparative analysis
- **📈 Aggregate Functions** – `SUM()`, `MAX()`, `COUNT()` with grouping

---

## 📁 Project Structure

```
layoffs_eda_analysis/
├── 📊 Exploratory_Data_Analysis_MySQL.sql    # Complete EDA queries
├── 🧹 Data_Cleaning_MySQL.sql               # Prerequisite cleaning script
├── 📈 analysis_results/                      # Query outputs (optional)
└── 📖 README.md                              # This documentation
```

---

## 🎯 Business Value & Applications

**📋 Strategic Insights:**
- Market trend identification for investors
- Industry risk assessment for stakeholders
- Economic impact analysis for researchers
- Corporate health monitoring for analysts

**🔮 Predictive Applications:**
- Early warning systems for market downturns
- Industry vulnerability assessments
- Geographic risk mapping
- Investment decision support

---

## 🔮 Future Enhancements

**🎯 Planned Extensions:**
- **Interactive Dashboards** – Learning Tableau/Power BI for visual storytelling
- **Python Integration** – Statistical analysis and machine learning applications  
- **Advanced Visualizations** – Geographic mapping and trend forecasting
- **Automated Reporting** – Scheduled analysis updates

**📈 Additional Analysis Opportunities:**
- Cross-industry correlation patterns
- Seasonal layoff predictions  
- Company recovery timelines
- Economic indicator relationships

---

## 🙏 Acknowledgments

- Built on **cleaned layoffs dataset** from data cleaning project
- Utilizes **MySQL 8.0** advanced SQL features
- Analysis covers **3+ years** of global corporate data
- Follows **data analysis best practices** and SQL optimization techniques
