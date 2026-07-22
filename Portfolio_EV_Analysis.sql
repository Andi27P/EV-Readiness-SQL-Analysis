
-- Count of respondents by city type and education level.
Select Count(CustomerID), city_type, education_level From Dim_Customer
GROUP BY city_type, education_level


-- Checking average anual income, age of respondents and daily comute distance. 

Select avg(age), avg(annual_income), avg(daily_commute_km) FROM Dim_Customer


-- Checking the average income by age group.
Select daily_commute_km, avg(annual_income),
CASE 
    WHEN age<=30 THEN 'Young'
    WHEN age>30 and age <=50 THEN 'Mid' 
    ELSE 'Old' 
END AS age_group
FROM Dim_Customer
GROUP BY age_group, daily_commute_km

-- Fuel expense by residential area.
Select city_type, avg(fuel_expense_per_month) FROM Dim_Customer
GROUP BY city_type
ORDER BY avg(fuel_expense_per_month) DESC




-- Fuel expense by residential area and car type.
Select city_type, current_vehicle_type, avg(fuel_expense_per_month) FROM Dim_Customer
GROUP BY city_type, current_vehicle_type  
ORDER BY avg(fuel_expense_per_month) DESC  



-- Average Saving by city type if transition to electric vehicle.
Select C.city_type,
       round(AVG(EV.monthly_charging_cost), 2) AS Electric_car_expense,
       round(AVG(C.fuel_expense_per_month), 2) AS Gas_fuel_expense,
       round(avg(C.fuel_expense_per_month - EV.monthly_charging_cost), 2) AS Average_saving
FROM Dim_Customer C
JOIN Fact_EV_Readiness EV  ON C.CustomerID = EV.CustomerID
GROUP BY C.city_type
ORDER BY Average_saving DESC



-- Relationship between home charging station availability, autonomy anxiety and willingness to switch to electric vehicle.

Select Count(C.CustomerID) AS Total_respondents,
       C.city_type,
       EV.home_charging_available,
       Round(avg(EV.range_anxiety_score), 2) AS Average_range_anxiety,
       Round(avg(EV.nearest_charging_station_km), 2) AS Average_nearest_charging_station,

-- Transform text from adoption_likelihood to numeric value for average calculation.

       ROUND(AVG(
           CASE 
               WHEN EV.ev_adoption_likelihood = 'Low' THEN 1
               WHEN EV.ev_adoption_likelihood = 'Medium' THEN 2
               WHEN EV.ev_adoption_likelihood = 'High' THEN 3
               ELSE NULL
           END
       ), 2) AS Average_ev_adoption_score
FROM Dim_Customer C
JOIN Fact_EV_Readiness EV  ON C.CustomerID = EV.CustomerID
GROUP BY C.city_type, EV.home_charging_available



-- Segmenting buyers by Income & attitude towards EV adoption

Select 
    CASE
-- Convert annual_income from VARCHAR to FLOAT to allow accurate numerical comparison   
        When CAST(C.annual_income AS FLOAT) <50000 Then 'Low Income'
        When CAST(C.annual_income AS FLOAT) >=50000 and CAST(C.annual_income AS FLOAT) <=100000 Then 'Middle Income'
        Else 'High Income'
    End AS income_group,
    Round(AVG(EV.environmental_awareness_score), 2) AS Average_environmental_awareness,
    Round(AVG(EV.technology_affinity_score), 2) AS Average_technology_affinity,
    ROUND(AVG(
           CASE 
               WHEN EV.ev_adoption_likelihood = 'Low' THEN 1
               WHEN EV.ev_adoption_likelihood = 'Medium' THEN 2
               WHEN EV.ev_adoption_likelihood = 'High' THEN 3
               ELSE NULL
           END
       ), 2) AS Average_ev_adoption_score,
    Round(AVG(EV.ev_knowledge_score), 2) AS Average_ev_knowledge
FROM Dim_Customer C
JOIN Fact_EV_Readiness EV ON C.CustomerID = EV.CustomerID
GROUP BY income_group
ORDER BY average_ev_adoption_score DESC


/*
Top 5 Highest earning respondents by city type.
Identifying the top 5 highest earning respondents in each city type category, based on their annual income.
*/
WITH RankedCustomers AS (
    SELECT C.CustomerID,
           C.city_type,
           CAST(C.annual_income AS Float) AS income_numeric,
           ROW_Number() OVER (
            PARTITION BY C.city_type
            ORDER BY CAST(C.annual_income AS FLOAT) DESC    
           ) AS income_rank
    From Dim_Customer C
)
SELECT 
    city_type,
    income_rank,
    CustomerID,
    income_numeric AS annual_income_numeric
FROM RankedCustomers
WHERE income_rank <= 5
ORDER BY city_type, income_rank


/*
Customer Income Benchmarking vs Regional Average.
This query compares each customer's annual income against the average income of their respective city type.
*/

With Income_Comparision AS (
    SELECT C.CustomerID,
           C.city_type,
           Cast(C.annual_income AS FLOAT) AS customer_income,
           Round(
            AVG(CAST(C.annual_income AS FLOAT)) OVER (PARTITION BY C.city_type), 2
           ) AS avg_city_income
    FROM Dim_Customer C
)
SELECT CustomerID,
       city_type,
       customer_income,
       avg_city_income,
-- Difference BETWEEN Customer income and average income by his region.
       Round(customer_income-avg_city_income, 2) AS Diferrence_income
FROM Income_Comparision
ORDER BY city_type, customer_income DESC




-- Regional Share of High EV Adoption Customers(as procent)

With HighAdoption_Rate AS (
    SELECT C.city_type,
           Count(C.CustomerID) AS High_adoption_count
    FROM Dim_Customer C       
    JOIN Fact_EV_Readiness EV ON C.CustomerID = EV.CustomerID 
    WHERE EV.ev_adoption_likelihood LIKE 'High'
    GROUP BY C.city_type  
)
SELECT city_type,
       High_adoption_count,
       -- General Total over all region
       SUM(High_adoption_count) OVER () AS total_high_adoption_customers,
       Round (
       (high_adoption_count * 100)/SUM(High_adoption_count) OVER (),2
       ) AS Percentage_Share
FROM HighAdoption_rate
ORDER BY Percentage_share DESC;       