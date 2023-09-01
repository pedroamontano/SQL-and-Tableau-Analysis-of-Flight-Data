use airtraffic;
-- Question #1:

# 1. How many flights were there in 2018 and 2019 separately?

SELECT
    COUNT(CASE WHEN YEAR(FlightDate) = 2018 THEN id END) AS '2018_Flights',
    COUNT(CASE WHEN YEAR(FlightDate) = 2019 THEN id END) AS '2019_Flights'
FROM flights;

/*
2018_Flights	2019_Flights
3,218,653		3,302,708
	
    This query provides us with the total number of flights in 2018 and 2019 as a side by side comparison.
*/

# 2. In total, how many flights were cancelled or departed late over both years?

SELECT COUNT(id) AS Delayed_Flights FROM flights
WHERE DepDelay > 0;
/*
Delayed Flights = 2,542,442

	These are the total number of flights that were delayed in 2018 and 2019. We are specifically asking for the data where the delay 
    of a flight was higher than 0 minutes.
*/

SELECT COUNT(id) AS Cancelled_Flights FROM flights 
WHERE Cancelled = 1;
/*
Cancelled Flights = 92,363

	These are the total number of flights that were canceled in 2018 and 2019. The data in the Cancelled column shows a "0" for not cancelled, and a "1" for cancelled.
*/

# 3. Show the number of flights that were cancelled broken down by the reason for cancellation

SELECT CancellationReason, COUNT(id) AS Cancelled_Flights FROM flights 
WHERE Cancelled = 1
GROUP BY CancellationReason;
/*
Cancellation Reason					Cancelled Flights
Weather Cancellations				50,225
Carrier Cancellations				34,141
National Air System Cancellations	7,962
Security Cancellations	 			35

	In this query we display how many flights were cancelled for each cancellation reason listed in the data.
*/

# 4a. For each month in 2019, report both the total number of flights and percentage of flights cancelled.

SELECT MONTH(FlightDate), COUNT(id) AS Flight_Count, CONCAT(FORMAT(SUM(Cancelled = 1)*100/COUNT(id), 2), '%') AS Cancelled_Flight_Percent
FROM flights
WHERE YEAR(FlightDate) = 2019
GROUP BY MONTH(FlightDate)
ORDER BY MONTH(FlightDate) ASC;
/*
Month		Number of Flights	Percentage of Flights Cancelled
January			262,165						2.21%
February		237,896						2.31%
March			283,648						2.50%
April			274,115						2.71%
May				285,094						2.42%
June			282,653						2.18%
July 			291,955						1.55%
August			290,493						1.25%
September		268,625						1.24%
October			283,815						0.81%
November		266,878						0.59%
December		275,371						0.51%

	This table is organized per month and shows the number of flights and what percentage of those flights was cancelled in 2019. 
*/

# 4b. Based on your results, what might you say about the cyclic nature of airline revenue?

/* 
	The highest amount of flights per month are during July, August, May, June, and March. The lowest amount of flights are in February. This shows the fluctuation 
	in demand for flights throughout the year. For example, June, July, and August may have more flights due to summer break in schools. Likewise, January and February 
	have the least amount of flights as it is usually when school starts after winter break.
 */
 
#Extra query used for this question to order by the number of flights for 2018 and 2019.

SELECT MONTH(FlightDate), COUNT(id) AS Flights 
FROM flights
GROUP BY MONTH(FlightDate)
ORDER BY COUNT(id) DESC;

-- Question #2:

# 1. Create two new tables, one for each year (2018 and 2019) showing the total miles traveled and number of flights broken down by airline.

SELECT AirlineName AS Airline, SUM(Distance) AS Miles_2018, COUNT(*) AS Flights_2018
FROM flights
WHERE YEAR(FlightDate) = 2018
GROUP BY Airline
ORDER BY Airline;
/*
Airline							Miles_2018		Flights_2018
American Airlines Inc.			933,094,276		916,818
Delta Air Lines Inc.			842,409,169		949,283
Southwest Airlines Co.			1,012,847,097	1,352,552
	
    This query provides us with the total number of miles and flights for 2018 per each of the three airlines in our data set.
*/

SELECT AirlineName AS Airline, SUM(Distance) AS Miles_2019, COUNT(*) AS Flights_2019
FROM flights
WHERE YEAR(FlightDate) = 2019
GROUP BY Airline
ORDER BY Airline;

/*
Airline							Miles_2019		Flights_2019
American Airlines Inc.			938,328,443		946,776
Delta Air Lines Inc.			889,277,534		991,986
Southwest Airlines Co.			1,011,583,832	1,363,946

	Much like the previous query, this one provides us with the miles taveled and the number of flights in 2019 per airline.
*/

# 2. Using your new tables, find the year-over-year percent change in total flights and miles traveled for each airline.

SELECT Airline, 
CONCAT(FORMAT((Flights_2019 - Flights_2018) / Flights_2018 * 100, 2), '%') AS Flight_Percent_Change,
CONCAT(FORMAT((Miles_2019 - Miles_2018) / Miles_2018 * 100, 2), '%') AS Miles_Percent_Change
FROM
	(SELECT
		AirlineName AS Airline,
		SUM(CASE WHEN YEAR(FlightDate) = 2018 THEN Distance END) AS Miles_2018, 
		COUNT(CASE WHEN YEAR(FlightDate) = 2018 THEN ID END) AS Flights_2018,
		SUM(CASE WHEN YEAR(FlightDate) = 2019 THEN Distance END) AS Miles_2019, 
		COUNT(CASE WHEN YEAR(FlightDate) = 2019 THEN ID END) AS Flights_2019
	FROM FLIGHTS
	GROUP BY Airline) AS subquery
ORDER BY Airline;
/*
Airline					Flight % Change		Miles % Change
American Airlines Inc.		3.27%				0.56%
Delta Air Lines Inc.		4.50%				5.56%
Southwest Airlines Co.		0.84%				-0.12%

	This analysis shows us the percentage increase or decrease in number of flights and miles traveled from 2018 to 2019. The results are specific to each of the 
    three airlines in our data set.
*/

# What investment guidance would you give to the fund managers based on your results?

/* 
Despite the higher percent increase in flights from American Airlines and Delta Airlines, Southwest Airlines has consistently held a higher number 
of flights in 2018 and 2019. Additionally, Southwest had a smaller increase in flights from 2018 to 2019 but they reduced their miles flown, thereby reducing flight 
costs. Southwest airlines would be the best investment option due to their consistency in flights flown as well as their strategy in reducing fuel and overhead costs.
*/

-- Question #3:

# 1. What are the names of the 10 most popular destination airports overall? 

SELECT a.AirportName, COUNT(f.id) AS Flights_Total
FROM airports a
JOIN flights f ON a.AirportID = f.DestAirportID
GROUP BY a.airportname
ORDER BY Flights_Total DESC limit 10;

/*
					Airport									Total Flights	
Hartsfield-Jackson Atlanta International						595,527
Dallas/Fort Worth International									314,423
Phoenix Sky Harbor International								253,697
Los Angeles International										238,092
Charlotte Douglas International									216,389
Harry Reid International										216,389
Denver International											184,935
Baltimore/Washington International Thurgood Marshall			168,334
Minneapolis-St Paul International								165,367
Chicago Midway International									165,007

	These results show us the most popular destination airports by counting the number of flights to each airport. The data only shows us the number of flights per 
    the id for each destination airport. The secondary table with airport information was required to display the airport names.
*/

# 2. Answer the same question but using a subquery to aggregate & limit the flight data before your join with the airport information, hence optimizing your query 
# runtime.

SELECT a.AirportName AS Airport_Name, af.tf AS Total_Flights
FROM
	(SELECT f.DestAirportID, COUNT(f.id) AS tf
	FROM flights f
	GROUP BY f.DestAirportID
    ORDER BY COUNT(f.id) DESC
	limit 10) AS af
JOIN airports a ON a.AirportID = af.DestAirportID
ORDER BY Total_Flights DESC;

# Which is faster (runtime) and why?

/*
The second method, using the subquery, has a faster runtime by almost 40 seconds. This is because we are limiting the amount of data being queried. In this case, 
the subquery counts the flight IDs for each destination airport ID and gives us only the 10 destinations with the most flight IDs. Then the airports table is
joined to query the airport names.
*/

-- Question #4:

# 1. A flight's tail number is the actual number affixed to the fuselage of an aircraft, much like a car license plate. 
# As such, each plane has a unique tail number and the number of unique tail numbers for each airline should approximate how many planes the airline operates in total. 
# Using this information, determine the number of unique aircraft each airline operated in total over 2018-2019.

SELECT AirlineName, COUNT(DISTINCT Tail_Number) AS Planes_Total
FROM flights
GROUP BY AirlineName;
/*
	Airline				Total Planes
American Airlines Inc.		993
Delta Air Lines Inc.		988
Southwest Airlines Co.		754
	
    This table shows the total number of planes per airline. This was achieved through the use of the tail numbers on each plane as unique identifiers. Only each
	distinct tail number is counted to avoid counting the tail number again when it appears in a different flight.
*/

# 2. Similarly, the total miles traveled by each airline gives an idea of total fuel costs and the distance traveled per plane gives an approximation of total equipment 
# costs. What is the average distance traveled per aircraft for each of the three airlines?

SELECT f.AirlineName AS Airline, FORMAT(AVG(AvgTail.Avg_Aircraft_Distance), 2) AS Avg_Airline_Distance
FROM flights f
INNER JOIN
    (SELECT 
        f.Tail_Number, AVG(f.Distance) AS Avg_Aircraft_Distance
    FROM
        flights f
    GROUP BY f.Tail_Number) AS AvgTail ON AvgTail.Tail_Number = f.Tail_Number
GROUP BY f.AirlineName;
/*
	Airline				Avg Aircraft Distance Traveled
Delta Air Lines Inc.			892.04
American Airlines Inc.			1,004.20
Southwest Airlines Co.			744.89
	
    Using the same unique identifier as before, this query calculates the average distance traveled for each aircraft. This will give us an idea of how much fuel,
    overhead costs, and maintenance each airline could be spending. The results are rounded to two decimals.
*/

# Compare the three airlines with respect to your findings: how do these results impact your estimates of each airline's finances?

/*
Delta and American Airlines surpass Southwest in number of airplanes by more than 200. Additionally, Delta and American flew their planes for longer distances 
on average. This inevitably results in higher costs for maintenance of their aircraft. American Airlines is likely the airline with the most overhead and maintenance 
costs. In terms of efficiency in reducing costs, Southwest Airlines continues to surpass its two competitors. 
*/

-- Question #5 (For each of the following questions, consider early departures and arrivals (negative values) as on-time (0 delay) in your calculations.):

# 1. Next, we will look into on-time performance more granularly in relation to the time of departure. We can break up the departure times into four categories:
# Morning, afternoon, evening, and night.
# Find the average departure delay for each time-of-day across the whole data set. Can you explain the pattern you see?

SELECT CONCAT(FORMAT(AVG(DepDelay), 2), ' min.') AS AvgDelay, Time_of_Day
FROM
	(SELECT CRSDepTime, DepDelay,
	CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS Time_of_Day 
	FROM flights) AS Time_Slot_Table
GROUP BY Time_of_Day
ORDER BY TIme_of_Day ASC;

/*
AvgDelay		Time_of_Day
5.33 min.		1-morning
11.69 min.		2-afternoon
16.41 min.		3-evening
4.92 min.		4-night
	
    This query gives us the average delay times per each time window as described above. The results are in minutes rounded to two decimal points and they are
    in order of the time of day.

	Evening flights have the highest delay times followed by afternoon flights. This indicates that between noon and 9pm there are a lot more delays than the other 
	time slots. Morning flights are the most common and it is likely that airplanes have flown several times before noon each day. This may cause delays in the 
    afternoon which are carried over to the evening. We see a sharp drop in delay times in the evening when the flight delays have been mostly caught up by the past 
    two time slots.
*/

# 2. Now, find the average departure delay for each airport and time-of-day combination.

SELECT AVG(DepDelay) AS AvgDelay, Time_of_Day, airports.AirportName AS Airport
FROM
	(SELECT CRSDepTime, DepDelay, OriginAirportID, 
	CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS Time_of_Day 
	FROM flights) AS Time_Slot_Table
JOIN airports ON OriginAirportID = airports.AirportID
GROUP BY Time_of_Day, airports.AirportName
ORDER BY Airport ASC;

/*
Query returned 621 rows, so I will not be showing them here. However, the results do show how many minutes flights are delayed on average at each airport depending
on the time of day. When ordered by average time delayed, Rapid City in South Dakota in the afternoon has the highest average delayed time at 5 hours. 
*/

# 3. Next, limit your average departure delay analysis to morning delays and airports with at least 10,000 flights.

SELECT CONCAT(FORMAT(AVG(DepDelay), 2), ' min.') AS AvgDelay, Time_of_Day, airports.AirportName AS Airport, COUNT(OriginAirportID) AS Flights
FROM
	(SELECT CRSDepTime, DepDelay, OriginAirportID, 
	CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS Time_of_Day 
	FROM flights) AS Time_Slot_Table
JOIN airports ON OriginAirportID = airports.AirportID
WHERE Time_of_Day = "1-morning"
GROUP BY Time_of_Day, airports.AirportName
HAVING COUNT(OriginAirportID) >= 10000
ORDER BY Airport ASC;

/*
AvgDelay	Time_of_Day			Airport													Flights
4.5994		1-morning		Austin - Bergstrom International							24,737
4.6407		1-morning		Baltimore/Washington International Thurgood Marshall		51,614
3.5544		1-morning		Bob Hope													16,715
4.2033		1-morning		Charlotte Douglas International								68,672
8.6348		1-morning		Chicago Midway International								46,019
8.9384		1-morning		Chicago O'Hare International								51,333
2.2052		1-morning		Cincinnati/Northern Kentucky International					10,492
6.7577		1-morning		Dallas Love Field											41,007
8.9553		1-morning		Dallas/Fort Worth International								101,468
6.9857		1-morning		Denver International										56,619
3.2155		1-morning		Detroit Metro Wayne County									43,716
3.6092		1-morning		Fort Lauderdale-Hollywood International						26,738
2.8614		1-morning		General Mitchell International								11,766
6.3647		1-morning		Harry Reid International									62,223
3.4058		1-morning		Hartsfield-Jackson Atlanta International					179,940
4.5952		1-morning		Indianapolis International									14,026
3.5561		1-morning		John F. Kennedy International								35,826
4.1229		1-morning		John Glenn Columbus International							11,974
4.8945		1-morning		John Wayne Airport-Orange County							19,790
3.9795		1-morning		Kansas City International									23,079
5.4329		1-morning		LaGuardia													42,512
5.7104		1-morning		Logan International											35,650
9.0311		1-morning		Los Angeles International									82,301
5.1587		1-morning		Louis Armstrong New Orleans International					22,497
5.6512		1-morning		Metro Oakland International									27,181
5.1943		1-morning		Miami International											28,231
3.4613		1-morning		Minneapolis-St Paul International							52,214
5.0637		1-morning		Nashville International										33,985
3.5663		1-morning		Newark Liberty International								11,166
3.7071		1-morning		Norman Y. Mineta San Jose International						23,985
4.2146		1-morning		Orlando International										55,731
4.5563		1-morning		Philadelphia International									40,748
6.0789		1-morning		Phoenix Sky Harbor International							88,999
4.0847		1-morning		Pittsburgh International									13,392
4.1578		1-morning		Portland International										15,001
6.1462		1-morning		Raleigh-Durham International								19,713
4.2541		1-morning		Ronald Reagan Washington National							28,996
3.2215		1-morning		Sacramento International									20,355
4.8382		1-morning		Salt Lake City International								47,435
5.0041		1-morning		San Antonio International									17,310
6.4414		1-morning		San Diego International										38,018
11.0652		1-morning		San Francisco International									29,517
7.7666		1-morning		Seattle/Tacoma International								35,530
2.609		1-morning		Southwest Florida International								11,579
6.2221		1-morning		St Louis Lambert International								33,994
3.6671		1-morning		Tampa International											34,577
6.6089		1-morning		William P Hobby												34,356
	
	The results are a little more maneagable than the previous query as this only returns 47 rows. When limited by only morning delays we can see the highest average
	is 11.07 minutes at San Francico Internation Airport, which also has 29,517 flights leaving at that time.
*/	

# 4. Finally, name the top-10 airports with the highest average morning delay. In what cities are these airports located?
SELECT CONCAT(FORMAT(AVG(DepDelay), 2), ' min.') AS AvgDelay, Time_of_Day, airports.AirportName AS Airport, City
FROM
	(SELECT CRSDepTime, DepDelay, OriginAirportID, 
	CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS Time_of_Day 
	FROM flights) AS Time_Slot_Table
JOIN airports ON OriginAirportID = airports.AirportID
WHERE Time_of_Day = "1-morning"
GROUP BY Time_of_Day, airports.AirportName, City
ORDER BY AvgDelay DESC
Limit 10;

/*
AvgDelay	Time of Day				Airport							City			
9.34 min.	1-morning		City of Colorado Springs Municipal		Colorado Springs, CO
9.33 min.	1-morning		George Bush Intercontinental/Houston	Houston, TX
9.16 min.	1-morning		Joe Foss Field							Sioux Falls, SD
9.03 min.	1-morning		Los Angeles International				Los Angeles, CA
8.96 min.	1-morning		Dallas/Fort Worth International			Dallas/Fort Worth, TX
8.94 min.	1-morning		Chicago O'Hare International			Chicago, IL
8.90 min.	1-morning		Westchester County						White Plains, NY
8.63 min.	1-morning		Chicago Midway International			Chicago, IL
8.12 min.	1-morning		Jackson Hole							Jackson, WY
7.77 min.	1-morning		Seattle/Tacoma International			Seattle, WA

	By removing the 10,000 flights limitation the results show the actual highest average delay in the morning per airport. We do see a few of the airports that showed
    up on the previous query, but the three airports with the highest average delay do not have more than 10,000 flights in the morning.
*/