-- # DATA PREPARATION

-- Creating New Table to Merge Dataset from JAN 2021 to DEC 2021
CREATE TABLE cyclistic_tripdata (
    ride_id   NVARCHAR(50),
	rideable_type   NVARCHAR(50),
	started_at   DATETIME2(7),
	ended_at   DATETIME2(7),
	start_station_name   NVARCHAR(MAX),
	start_station_id   NVARCHAR(50),
	end_station_name   NVARCHAR(MAX),
	end_station_id   NVARCHAR(50),
	start_lat   FLOAT,
	start_lng   FLOAT,
	end_lat   FLOAT,
	end_lng   FLOAT,
	member_casual   NVARCHAR(50)
	)

-- Importing Dataset into New Table
INSERT INTO cyclistic_tripdata
SELECT * FROM [202101-divvy-tripdata] UNION ALL
SELECT * FROM [202102-divvy-tripdata] UNION ALL
SELECT * FROM [202103-divvy-tripdata] UNION ALL
SELECT * FROM [202104-divvy-tripdata] UNION ALL
SELECT * FROM [202105-divvy-tripdata] UNION ALL
SELECT * FROM [202106-divvy-tripdata] UNION ALL
SELECT * FROM [202107-divvy-tripdata] UNION ALL
SELECT * FROM [202108-divvy-tripdata] UNION ALL
SELECT * FROM [202109-divvy-tripdata] UNION ALL
SELECT * FROM [202110-divvy-tripdata] UNION ALL
SELECT * FROM [202111-divvy-tripdata] UNION ALL
SELECT * FROM [202112-divvy-tripdata]

--Display of Data
SELECT * FROM cyclistic_tripdata

SELECT COUNT(*)
FROM cyclistic_tripdata
        --- (The table has 13 columns and 5595063 rows.)

-- # DATA CLEANING

-- Checking Length of Ride ID
SELECT LEN(ride_id)
FROM cyclistic_tripdata
WHERE LEN(ride_id) > 16

SELECT DISTINCT ride_id
FROM cyclistic_tripdata
        ---(All ride_id has 16 characters, no mishap detected. They are all distinct values.)

-- Checking for Duplicates 
SELECT ride_id, COUNT(ride_id)
FROM cyclistic_tripdata
GROUP BY ride_id
HAVING COUNT(ride_id) > 1
         ---(No duplicates detected)

-- Removing Unncessary Columns 
ALTER TABLE cyclistic_tripdata
DROP COLUMN start_lat

ALTER TABLE cyclistic_tripdata
DROP COLUMN start_lng

ALTER TABLE cyclistic_tripdata
DROP COLUMN end_lat

ALTER TABLE cyclistic_tripdata
DROP COLUMN end_lng
        ---(These columns are not needed for analysis.)
SELECT * FROM cyclistic_tripdata
   
-- Checking for Distinct Values and Errors in Necessary Columns
SELECT DISTINCT rideable_type
FROM cyclistic_tripdata
       ---(The table has 3 distinct types of rides : classic_bike, electric_bike and docked_bike.) 
       ---(The rideable_type ought to be 2 distinct types. docked_bike is due to naming error which will be changed to classic_bike.) 

SELECT DISTINCT member_casual
FROM cyclistic_tripdata
       ---(The table has 2 distinct type of users : Member user and Casual user. No error detected.)

-- Checking for Null Values
SELECT COUNT(*) start_station_name FROM cyclistic_tripdata WHERE start_station_name IS NULL
SELECT COUNT(*) end_station_name FROM cyclistic_tripdata WHERE end_station_name IS NULL
SELECT COUNT(*) started_at FROM cyclistic_tripdata WHERE started_at IS NULL
SELECT COUNT(*) ended_at FROM cyclistic_tripdata WHERE ended_at IS NULL
SELECT COUNT(*) start_station_id FROM cyclistic_tripdata WHERE start_station_id IS NULL
SELECT COUNT(*) end_station_id FROM cyclistic_tripdata WHERE end_station_id IS NULL
                ---(start_station_name has null values of 690809 rows, end_station_name has null values of 739170 rows.)
		---(started_at has no null values, ended_at has no null values.)
		---(start_station_id has null values of 690809 rows, end_station_id has null values of 739170 rows.)

SELECT ride_id
FROM cyclistic_tripdata
WHERE ride_id IS NULL
        ---(No null values detected)

SELECT member_casual
FROM cyclistic_tripdata
WHERE member_casual IS NULL
        --(No null values detected)

-- Deleting Columns with Null Values
DELETE FROM cyclistic_tripdata
WHERE start_station_name IS NULL

DELETE FROM cyclistic_tripdata
WHERE end_station_name IS NULL

DELETE FROM cyclistic_tripdata
WHERE started_at IS NULL

DELETE FROM cyclistic_tripdata
WHERE ended_at IS NULL

DELETE FROM cyclistic_tripdata
WHERE start_station_id IS NULL

DELETE FROM cyclistic_tripdata
WHERE end_station_id IS NULL
              ---(All columns with null values were deleted.)
SELECT COUNT(*)
FROM cyclistic_tripdata

-- Renaming 'docked_bike' to 'classic_bike'
UPDATE cyclistic_tripdata SET rideable_type = REPLACE(rideable_type, 'docked_bike', 'classic_bike') 

SELECT DISTINCT (rideable_type)
FROM cyclistic_tripdata

-- Checking for Errors in Ending time and Starting time
SELECT * 
FROM cyclistic_tripdata
WHERE started_at > ended_at
          ---(116 rows are detected.)
DELETE FROM cyclistic_tripdata
WHERE started_at > ended_at
          ---(The rows were deleted.)

-- Checking Data after Removing Nulls and Errors
SELECT COUNT(ride_id),
       COUNT(started_at),
       COUNT(ended_at),
       COUNT(start_station_id),
       COUNT(end_station_id),
       COUNT(start_station_name),
       COUNT(end_station_name),
       COUNT(member_casual),
       COUNT(rideable_type)
FROM cyclistic_tripdata

SELECT COUNT(*) 
FROM cyclistic_tripdata
         ---(Now have 4588186 rows of data.)
	 ---(Total of 1006877 of uncleaned data have been removed which would have affected our analysis.)

--# DATA MANIPULATION

-- Creating and Updating New Columns
ALTER TABLE cyclistic_tripdata
ADD ride_min INT

UPDATE cyclistic_tripdata SET ride_min = DATEDIFF(MINUTE,started_at,ended_at) 
          ---(New column for ride_min - Total minutes of bike ride.)

ALTER TABLE cyclistic_tripdata
ADD ride_time INT

UPDATE cyclistic_tripdata SET ride_time = DATEPART(HOUR,started_at)
           ---(New column for ride_time - Time of the day of bike ride.)

ALTER TABLE cyclistic_tripdata
ADD ride_period NVARCHAR(50)

UPDATE cyclistic_tripdata SET ride_period  = CASE WHEN ride_time BETWEEN 6 AND 12 THEN 'Morning'
	                                          WHEN ride_time BETWEEN 13 AND 17 THEN 'Afternoon'
		                                  WHEN ride_time BETWEEN 18 AND 23 THEN 'Evening'
		                                  ELSE 'Night' END 
            ---(New column for ride_period - Morning, Afternooon, Evening, Night.)

ALTER TABLE cyclistic_tripdata
ADD ride_day NVARCHAR(50)

UPDATE cyclistic_tripdata SET ride_day = FORMAT(started_at,'ddd')
             ---(New column for ride_day - Day of the week of bike ride.)
			 
ALTER TABLE cyclistic_tripdata
ADD ride_month NVARCHAR(50)

UPDATE cyclistic_tripdata SET ride_month = FORMAT(started_at,'MMM')
             ---(New column for ride_month - Month of the year of bike ride.)

ALTER TABLE cyclistic_tripdata
ADD ride_quarter INT

UPDATE cyclistic_tripdata SET ride_quarter = DATEPART(QUARTER,started_at) 
             ---(New column for ride_quarter - Quarter of the year of bike ride.)

-- Checking Rides with Abnormal Time Duration
SELECT *
FROM cyclistic_tripdata
WHERE ride_min <= 1 OR ride_min >= 1440
             ---(83552 rows were detected of bike ride time duration less than a minute and above 24 hours.)
 DELETE FROM cyclistic_tripdata
 WHERE ride_min <= 1 OR ride_min >= 1440
             ---(Abnormal bike ride duration were deleted.)

-- Overview of Data after Cleaning and Manipulation
SELECT * FROM cyclistic_tripdata

SELECT COUNT(*) FROM cyclistic_tripdata
                         ---(Total of 15 columns)
			 ---(Total of 4504634 rows)
			 ---(Total of 1090429 removed rows)
