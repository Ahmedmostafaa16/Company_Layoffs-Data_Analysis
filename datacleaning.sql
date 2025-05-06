-- Create a backup copy of the original table to preserve raw data
create TABLE layoff_backup LIKE layoffs ;
insert layoff_backup
SELECT *
FROM layoffs ;
-- Create a new table with an additional column `row_num` to identify duplicates
DROP TABLE IF EXISTS layoffs_duplicates;

CREATE TABLE layoffs_duplicates AS
SELECT *, 
       ROW_NUMBER() OVER (
         PARTITION BY company, location, industry, total_laid_off, 
                      percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_number_
FROM layoffs;                 -- Use the ROW_NUMBER() function to assign a number to each duplicate based on a group of columns
-- Delete duplicate records that have a row number of 2 or more
SET SQL_SAFE_UPDATES = 0;
delete FROM layoffs_duplicates
WHERE row_number_ >= 2 ;

-- Remove leading and trailing spaces from company names
UPDATE layoffs_duplicates
set company = trim(company) ;


-- Correct misspellings in the location column to standardize location names
SELECT DISTINCT location
from layoffs_duplicates ORDER BY 1;
update layoffs_duplicates set location = 'rubbish' where location = 'Tel Aviv' ;
UPDATE layoffs_duplicates Set location = 'Düsseldorf' WHERE location = 'DÃ¼sseldorf';
UPDATE layoffs_duplicates Set location = 'Florianópolis' WHERE location = 'FlorianÃ³polis';
UPDATE layoffs_duplicates Set location = 'Malmö' WHERE location = 'MalmÃ¶';
UPDATE layoffs_duplicates Set location = 'Other' WHERE location = 'Non-U.S.';

-- Standardize the industry names (e.g., unify all variations of "Crypto")
UPDATE layoffs_duplicates set industry ='Crypto' where industry like 'crypto%' ;
Update layoffs_duplicates set industry = null where industry='';  -- Set blank values in the industry column to NULL
-- Convert the date column from text to proper DATE format
update layoffs_duplicates set `date` = str_to_date(`date`,'%m/%d/%Y') ;
ALTER TABLE layoffs_duplicates Modify column `date` DATE;
-- Remove trailing periods in country names to make them consistent

update layoffs_duplicates set country = trim(trailing '.' FROM country) ;

-- Fill in missing industry values by matching with other records from the same company
-- self join is used to compare values 
select  t1.company ,t1.industry,t2.company,t2.industry 
from layoffs_duplicates as t1
join layoffs_duplicates as t2
on t1.company = t2.company
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL ;
update layoffs_duplicates as t1 
join layoffs_duplicates as t2
on t1.company = t2.company
set t1.industry=t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL ;
-- Delete rows where both `total_laid_off` and `percentage_laid_off` are NULL, as they carry no meaningful data
delete from layoffs_duplicates
where total_laid_off is null OR percentage_laid_off is null ;
-- Drop the `row_num` column since it's no longer needed after duplicate removal
alter TABLE layoffs_duplicates drop column row_number_;
select * FROM layoffs_duplicates;

