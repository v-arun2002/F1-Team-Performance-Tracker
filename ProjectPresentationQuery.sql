use F1TestSchema;

# 1. Simple Query - Find the top 5 drivers with the most podiums
SELECT 
    DriverId, 
    Name AS DriverName, 
    Podiums 
FROM 
    Driver
ORDER BY 
    Podiums DESC
LIMIT 5;








# 2. Aggregate Query - Find the sum of all points scored by top 10 drivers from season 2019 to 2023
SELECT 
	P.DriverId, 
    D.Name, 
    sum(P.PointsScored) as TotalPoints 
FROM 
	PerformanceStatistics P, 
    Driver D 
WHERE 
	D.DriverId = P.DriverId
GROUP BY 
	p.DriverID;









# 3. INNER/OUTER JOIN - Find all drivers and the teams they drove for, including drivers who do not currently belong to any team.
SELECT 
    d.DriverId, 
    d.Name AS DriverName, 
    t.TeamName, 
    dr.FromYear, 
    dr.ToYear
FROM 
    Driver d
LEFT JOIN 
    Drives dr ON d.DriverId = dr.DriverId
LEFT JOIN 
    Team t ON dr.TeamID = t.TeamId
ORDER BY 
    d.Name;





# 4. Nested Query - Find the name of the driver who has the highest number of wins in a season.
SELECT 
    d.Name AS DriverName
FROM 
    Driver d
WHERE 
    d.DriverId = (
        SELECT 
            ds.DriverId
        FROM 
            DriverStandings ds
        WHERE 
            ds.Wins = (SELECT MAX(Wins) FROM DriverStandings)
        LIMIT 1
    );
    
# 5. Correlated Query - Find all drivers who scored more points in a race than the average points scored in that race by all drivers.
SELECT 
    d.Name AS DriverName, 
    r.RaceName, 
    ps.PointsScored
FROM 
    Driver d
JOIN 
    PerformanceStatistics ps ON d.DriverId = ps.DriverId
JOIN 
    Race r ON ps.RaceId = r.RaceId
WHERE 
    ps.PointsScored > (
        SELECT 
            AVG(ps2.PointsScored)
        FROM 
            PerformanceStatistics ps2
        WHERE 
            ps2.RaceId = ps.RaceId
    )
ORDER BY 
    ps.PointsScored DESC;

    
# 6. Query with >=ALL/>ANY/EXISTS/NOT EXISTS - Find drivers who have completed all races in the 2023 season.
SELECT 
    d.DriverId, 
    d.Name AS DriverName
FROM 
    Driver d
WHERE 
    NOT EXISTS (
        SELECT 
            1
        FROM 
            Race r
        WHERE 
            r.SeasonId = ( SELECT SeasonId FROM Season WHERE Year = '2023-01-01')
        AND 
            r.RaceId NOT IN ( SELECT ps.RaceId FROM PerformanceStatistics ps WHERE ps.DriverId = d.DriverId )
    );
    
    
# 7. SET operations (UNION) - Get all unique driver names, including both main and reserve drivers
SELECT 
    DriverName
FROM 
    MainDriver
UNION
SELECT 
    DriverName
FROM 
    ReserveDriver;
    
    
    
    
    
    
    

# 8. Sub queries in SELECT and FROM - Find the total number of laps completed by each driver in the 2023 season.
SELECT 
    d.DriverId, 
    d.Name AS DriverName, 
    (SELECT 
            SUM(ps.LapsCompleted)
        FROM 
            PerformanceStatistics ps
        JOIN 
            Race r ON ps.RaceId = r.RaceId
        WHERE 
            ps.DriverId = d.DriverId
        AND 
            r.SeasonId = (SELECT SeasonId FROM Season WHERE Year = '2023-01-01') ) AS TotalLapsCompleted
FROM 
    Driver d
ORDER BY 
    TotalLapsCompleted DESC;

