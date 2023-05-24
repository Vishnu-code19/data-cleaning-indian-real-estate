CREATE DATABASE RealEstateIndianCities; -- Imported .csv data as table in this database through import wizard
SHOW tables;
SELECT * FROM re_ic;
-- -----------------------------------------------------------------------
-- NOW I AM GONNA START THE DATA CLEANING PROCEDURE --
-- -----------------------------------------------------------------------
ALTER TABLE re_ic
ADD COLUMN BHK FLOAT AFTER `Property Title`; -- Adding a Coloumn for no. of bedroom

UPDATE re_ic 
SET BHK = SUBSTRING_INDEX(`Property Title`,' ',1) 
WHERE SUBSTRING(`Property Title`,1,1) not RLIKE '[A-Za-z]' AND `Property Title` not like '5+%';
UPDATE re_ic
SET BHK = SUBSTRING(`Property Title`,1,1)
WHERE `Property Title` LIKE '5+%';

-- -------------
ALTER TABLE re_ic
ADD COLUMN `Price(Cr)` FLOAT AFTER Price;

DELETE FROM re_ic WHERE PRICE LIKE '%k'; -- this was done to correct a little unexpectedly off format data

UPDATE re_ic 
SET `Price(Cr)` = SUBSTRING(SUBSTRING_INDEX(Price,' ',1),2,6);

UPDATE re_ic 
SET `Price(Cr)` = `Price(Cr)`/100 WHERE Price LIKE '%L' ;

ALTER TABLE re_ic
DROP COLUMN PRICE;

-- -----------
UPDATE re_ic
SET `PROPERTY TITLE` = SUBSTRING(`PROPERTY TITLE`,
								(LOCATE('BHK ',`Property Title`)+4),
                             (LOCATE(' for',`Property Title`))-(LOCATE('BHK ',`Property Title`)+4))
                             WHERE BHK IS NOT NULL;
UPDATE re_ic
SET `PROPERTY TITLE` = SUBSTRING(`PROPERTY TITLE`,
 								1,
                                (LOCATE(' for',`Property Title`)))
                                WHERE BHK IS NULL;

ALTER TABLE re_ic
RENAME COLUMN `Property Title` TO `Property Type`;
 
UPDATE re_ic
SET `PROPERTY Type` = SUBSTRING(`PROPERTY Type`,3,50)
WHERE `PROPERTY TYPE` LIKE 'K%';
-- -------------
ALTER TABLE re_ic
ADD COLUMN City VARCHAR(50) AFTER LOCATION;

UPDATE re_ic
SET City = SUBSTRING_INDEX(Location,',',-1);
UPDATE re_ic
SET City = TRIM(CITY);
-- -------------
ALTER TABLE re_ic
MODIFY COLUMN Description VARCHAR(1000) AFTER BALCONY;
ALTER TABLE re_ic
MODIFY COLUMN Location VARCHAR(300) AFTER BALCONY;
-- -----------------------------------------------------------------------
-- DATA IS CLEANED--
 -- while cleaning I extensively made sure that no gets eliminated unnoticed in filtering process -- 
-- -----------------------------------------------------------------------

