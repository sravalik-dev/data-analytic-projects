# data-analytic-projects
A collection of data cleaning projects using MySQL, focused on real-world datasets.

---

## Projects

### 1. Layoffs Data Cleaning
**Dataset:** [World Layoffs 2022 – Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

Cleaned a dataset of global tech layoffs from 2020–2023.

**Steps performed:**
- Removed duplicate records using ROW_NUMBER() and staging tables
- Standardized text fields (TRIM, industry name fixes)
- Handled NULL values and removed unusable rows
- Converted date column from text to DATE format

---

### 2. Netflix Movies & TV Shows Data Cleaning
**Dataset:** [Netflix Movies and TV Shows – Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)

Cleaned a dataset of 8800+ Netflix titles.

**Steps performed:**
- Removed duplicate records using ROW_NUMBER() and staging tables
- Converted empty strings to NULL across all columns
- Filled missing country values via self-join on director
- Standardized text fields using TRIM
- Converted date_added column from text to DATE format

---

## Tools Used
- MySQL
- MySQL Workbench

---

## Author
**Sravalik** — Aspiring Data Analyst
