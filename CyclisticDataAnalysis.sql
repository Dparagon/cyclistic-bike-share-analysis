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

-- Number of rides per day
SELECT ride_day,
       COUNT(*) total_rides,
	   SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
	   SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM cyclistic_tripdata
GROUP BY ride_day
ORDER BY total_rides DESC

-- Number of rides per month
SELECT ride_month,
       COUNT(*) total_rides,
	   SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
	   SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM cyclistic_tripdata
GROUP BY ride_month
ORDER BY total_rides DESC

-- Number of rides per time of ride
SELECT ride_time,
       COUNT(*) total_rides,
	   SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
	   SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM cyclistic_tripdata
GROUP BY ride_time
ORDER BY total_rides DESC

-- Top 10 start stations
SELECT TOP 10
       start_station_name,
	   COUNT(*) station_total_rides
FROM cyclistic_tripdata
GROUP BY start_station_name
ORDER BY station_total_rides DESC

-- Top 10 end stations
SELECT TOP 10
       end_station_name,
	   COUNT(*) station_total_rides
FROM cyclistic_tripdata
GROUP BY end_station_name
ORDER BY station_total_rides DESC

-- Daily average minute of rides
SELECT ride_day,member_casual,
       AVG(ride_min) average_min
FROM cyclistic_tripdata
GROUP BY ride_day, member_casual
ORDER BY member_casual, average_min DESC

-- Number of rides by user type and bike type
SELECT member_casual,
       rideable_type,
	   COUNT(*) total_rides
FROM cyclistic_tripdata
GROUP BY member_casual, rideable_type 
ORDER BY rideable_type DESC

-- Quarterly bike rides 
SELECT ride_quarter,
       COUNT(*) rides_total,
	   SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member,
	   SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual
FROM cyclistic_tripdata
GROUP BY ride_quarter
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
