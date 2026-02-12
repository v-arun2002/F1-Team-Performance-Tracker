# 🏎️ F1 Team Performance Tracker

A comprehensive database management system for tracking, analyzing, and visualizing Formula 1 performance data across teams, drivers, circuits, races, and seasons.

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat&logo=mongodb&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)



**Key Capabilities:**
- Track driver and team results across multiple seasons (2019-2023)
- Analyze race metrics: lap times, positions, pit stops, points
- Compare constructor standings and championship progressions
- Visualize performance trends with Python analytics

---

## 🏗️ System Architecture

### Database Design

The system uses a **hybrid database approach**:

| Component | Technology | Purpose |
|-----------|------------|---------|
| Relational DB | MySQL | Structured queries, joins, aggregations |
| Document DB | MongoDB | Flexible schemas, rapid prototyping |
| Analytics | Python + Pandas | Visualization and trend analysis |

### Entity-Relationship Model

```
┌─────────┐     ┌─────────┐     ┌─────────┐
│  Team   │────<│ Drives  │>────│ Driver  │
└────┬────┘     └─────────┘     └────┬────┘
     │                               │
     │         ┌─────────┐          │
     └────────>│  Race   │<─────────┘
               └────┬────┘
                    │
     ┌──────────────┼──────────────┐
     ▼              ▼              ▼
┌─────────┐  ┌───────────┐  ┌──────────┐
│  Track  │  │  Season   │  │ Results  │
└─────────┘  └───────────┘  └──────────┘
```

**Core Entities:** Team, Driver, Race, Track, Season, PerformanceStatistics, DriverStandings, ConstructorStandings

---

## 🔍 SQL Query Examples

### Simple Query — Top 5 Drivers by Podiums
```sql
SELECT DriverId, Name AS DriverName, Podiums 
FROM Driver
ORDER BY Podiums DESC
LIMIT 5;
```

### Aggregate Query — Total Points by Driver
```sql
SELECT P.DriverId, D.Name, SUM(P.PointsScored) AS TotalPoints 
FROM PerformanceStatistics P
JOIN Driver D ON D.DriverId = P.DriverId
GROUP BY P.DriverID;
```

### Correlated Subquery — Drivers Outperforming Race Average
```sql
SELECT d.Name, r.RaceName, ps.PointsScored
FROM Driver d
JOIN PerformanceStatistics ps ON d.DriverId = ps.DriverId
JOIN Race r ON ps.RaceId = r.RaceId
WHERE ps.PointsScored > (
    SELECT AVG(ps2.PointsScored)
    FROM PerformanceStatistics ps2
    WHERE ps2.RaceId = ps.RaceId
)
ORDER BY ps.PointsScored DESC;
```

### NOT EXISTS — Drivers Completing All 2023 Races
```sql
SELECT d.DriverId, d.Name AS DriverName
FROM Driver d
WHERE NOT EXISTS (
    SELECT 1 FROM Race r
    WHERE r.SeasonId = (SELECT SeasonId FROM Season WHERE Year = '2023-01-01')
    AND r.RaceId NOT IN (
        SELECT ps.RaceId FROM PerformanceStatistics ps 
        WHERE ps.DriverId = d.DriverId
    )
);
```

---

## 🍃 MongoDB Queries

```javascript
// Find driver by name
db.Driver.find({"Name": "Lewis Hamilton"});

// Active drivers with 5+ championships
db.Driver.find({ 
    "Championships": { $gt: 5 },
    "Status": "Active"
});

// Aggregate championships by nationality
db.Driver.aggregate([
    { $group: { 
        _id: "$Nationality", 
        totalChampionships: { $sum: "$Championships" }
    }},
    { $sort: { totalChampionships: -1 }}
]);
```

---

## 📊 Visualizations

Python analytics pipeline using `mysql.connector`, `pandas`, and `matplotlib`:

| Visualization | Insight |
|---------------|---------|
| **Top 10 Teams by Avg Points** | Constructor performance comparison |
| **Driver Performance by Year** | Multi-season trend analysis |
| **Team Points Distribution** | Season championship breakdown |

```python
# Example: Connect and visualize
import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt

conn = mysql.connector.connect(host='localhost', database='F1TestSchema', ...)
df = pd.read_sql(query, conn)
df.plot(kind='bar', x='TeamName', y='AvgPoints')
```

---

## 📁 Project Structure

```
f1-performance-tracker/
├── sql/
│   └── DMA_Project_Presentation_Query.sql   # All SQL queries
├── mongodb/
│   └── nosql_queries.js                      # MongoDB implementations
├── python/
│   └── visualization.py                      # Analytics & charts
├── docs/
│   ├── Project_Report.pdf                    # Full documentation
│   ├── Relational_Model.pdf                  # EER & schema design
│   └── NoSQL_Implementation.pdf              # MongoDB setup
└── README.md
```

---

## 🛠️ Tech Stack

**Databases:** MySQL 8.0, MongoDB (Compass)  
**Languages:** SQL, Python 3.x, JavaScript (MongoDB shell)  
**Libraries:** pandas, matplotlib, mysql-connector-python  
**Modeling:** EER Diagrams, UML Class Diagrams

---

## 🚀 Future Enhancements

- [ ] **Real-time data integration** via Ergast Developer API
- [ ] **REST API layer** for external application access
- [ ] **ML predictions** for race outcomes using historical data
- [ ] **Cloud deployment** on AWS RDS / MongoDB Atlas
- [ ] **Performance indexing** on frequently queried fields

