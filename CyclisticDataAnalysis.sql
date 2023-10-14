-- # DATA ANALYSIS

-- Summary of Data
SELECT COUNT(ride_id) No_of_rides,
       AVG(ride_min) Avg_ride_mins,
	   MIN(ride_min) Min_ride_min,
	   MAX(ride_min) Max_ride_min
FROM cyclistic_tripdata
             
-- Number of rides per user type
SELECT member_casual,
       COUNT(*) total_rides
FROM cyclistic_tripdata
GROUP BY member_casual
ORDER BY total_rides DESC

-- Number of rides per bike type
SELECT rideable_type, 
       COUNT(*) total_rides
FROM cyclistic_tripdata
GROUP BY rideable_type
ORDER BY total_rides DESC

-- Number of rides by user type and bike type
SELECT member_casual,
       rideable_type,
	   COUNT(*) total_rides
FROM cyclistic_tripdata
GROUP BY member_casual, rideable_type 
ORDER BY rideable_type DESC

-- Top 10 start stations
SELECT TOP 10
       start_station_name, COUNT(*) station_total_rides
FROM cyclistic_tripdata
GROUP BY start_station_name
ORDER BY station_total_rides DESC

-- Top 10 end stations
SELECT TOP 10
       end_station_name, COUNT(*) station_total_rides
FROM cyclistic_tripdata
GROUP BY end_station_name
ORDER BY station_total_rides DESC

-- Rides per time of the day
SELECT ride_time,
       COUNT(*) rides_total
FROM cyclistic_tripdata
GROUP BY ride_time
ORDER BY rides_total DESC

-- User type rides per days of the week
SELECT ride_day,
       member_casual,
       COUNT(*) rides_total
FROM cyclistic_tripdata
GROUP BY ROLLUP (ride_day, member_casual)
ORDER BY rides_total DESC

-- Rides per month
SELECT ride_month,
       COUNT(*) rides_total
FROM cyclistic_tripdata
GROUP BY ride_month
ORDER BY rides_total DESC

-- Quarterly bike rides 
SELECT ride_quarter,
       COUNT(*) rides_total
FROM cyclistic_tripdata
GROUP BY ride_quarter
ORDER BY rides_total DESC

-- Daily average minute of rides
SELECT ride_day,
       AVG(ride_min) average_min
FROM cyclistic_tripdata
GROUP BY ride_day
ORDER BY average_min

-- Rides per period
SELECT ride_period,
       COUNT(*) rides_total
FROM cyclistic_tripdata
GROUP BY ride_period
ORDER BY rides_total DESC

-- Weekday rides VS Weekend rides
SELECT week_period,
       COUNT(*) rides_total
FROM
    (SELECT *, CASE WHEN ride_day IN ('Mon','Tue','Wed','Thu') THEN 'Weekday'
                    WHEN ride_day IN ('Fri','Sat','Sun') THEN 'Weekend'
		            END AS week_period
      FROM cyclistic_tripdata) wp 
GROUP BY week_period
ORDER BY rides_total DESC


