-- Netflix Data Cleaning
-- =============================================

CREATE TABLE net1 LIKE netflix_titles;

INSERT INTO net1
SELECT * FROM netflix_titles;

CREATE TABLE `net2` (
  `show_id` text,
  `type` text,
  `title` text,
  `director` text,
  `cast` text,
  `country` text,
  `date_added` text,
  `release_year` int DEFAULT NULL,
  `rating` text,
  `duration` text,
  `listed_in` text,
  `description` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO net2
SELECT *, ROW_NUMBER() OVER(
    PARTITION BY show_id, `type`, title, director, cast, country,
    date_added, release_year, rating, duration, listed_in, `description`
) AS row_num
FROM net1;

DELETE FROM net2
WHERE row_num > 1;


UPDATE net2 SET director = NULL WHERE director = '';
UPDATE net2 SET cast = NULL WHERE cast = '';
UPDATE net2 SET country = NULL WHERE country = '';
UPDATE net2 SET date_added = NULL WHERE date_added = '';
UPDATE net2 SET rating = NULL WHERE rating = '';
UPDATE net2 SET duration = NULL WHERE duration = '';

UPDATE net2 SET title = TRIM(title);
UPDATE net2 SET director = TRIM(director);
UPDATE net2 SET cast = TRIM(cast);
UPDATE net2 SET country = TRIM(country);
UPDATE net2 SET description = TRIM(description);

UPDATE net2 t1
JOIN net2 t2
    ON t1.director = t2.director
SET t1.country = t2.country
WHERE t1.country IS NULL
    AND t2.country IS NOT NULL;

UPDATE net2
SET `date_added` = STR_TO_DATE(`date_added`, '%M %d, %Y')
WHERE `date_added` LIKE '%,%';

ALTER TABLE net2
MODIFY COLUMN `date_added` DATE;

ALTER TABLE net2
DROP COLUMN row_num;
