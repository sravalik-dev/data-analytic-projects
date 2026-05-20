-- World Layoffs Data Cleaning
-- =============================================

-- Step 1: Create staging table
CREATE TABLE layys LIKE layoffs;

INSERT INTO layys
SELECT * FROM layoffs;

-- Step 2: Create second staging table with row numbers for deduplication
CREATE TABLE `layys2` (
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

INSERT INTO layys2
SELECT *, ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
    stage, country, funds_raised_millions
) AS row_num
FROM layys;

-- Step 3: Delete duplicates
DELETE FROM layys2
WHERE row_num > 1;

-- Step 4: Standardize text fields
UPDATE layys2
SET company = TRIM(company);

UPDATE layys2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layys2
SET country = TRIM(TRAILING '.' FROM country);

-- Step 5: Fill missing industry via self-join on company
UPDATE layys2 t1
JOIN layys2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
    AND t2.industry IS NOT NULL;

-- Step 6: Convert date column from text to DATE format
UPDATE layys2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layys2
MODIFY COLUMN `date` DATE;

-- Step 7: Remove unusable rows where both layoff columns are NULL
DELETE FROM layys2
WHERE total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

-- Step 8: Drop row_num column
ALTER TABLE layys2
DROP COLUMN row_num;
