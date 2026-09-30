# 🚗 Electric Vehicle (EV) Readiness & Customer Segmentation Analysis

## 📌 Project Overview
This project performs an end-to-end SQL analysis on consumer demographics and Electric Vehicle (EV) readiness data. By bridging customer financial profiles with their environmental attitudes and charging infrastructure accessibility, this analysis identifies high-potential target segments and provides strategic recommendations for EV market expansion.

---

## 📊 Key Business Questions Answered
1. What are the average monthly savings for customers transitioning from traditional fuel to electric vehicles across different regions?
2. How do home charging availability, charging station proximity, and range anxiety influence EV adoption likelihood?
3. How does income level correlate with technology affinity, environmental awareness, and EV knowledge?
4. Who are the top 5 highest earners in each region, and how does individual income compare to regional benchmarks?
5. Which geographic segments hold the largest share of high-likelihood EV adopters?

---

## 🛠️ Tech Stack & SQL Capabilities
* **Database Management System:** SQLite / SQL Server
* **Data Transformation & Aggregation:** `CAST` / `CONVERT`, `CASE WHEN`, `GROUP BY`, `ORDER BY`
* **Relational Joins:** Multi-table `INNER JOIN` operations (`Dim_Customer` and `Fact_EV_Readiness`)
* **Advanced Analytics & CTEs:** 
  * `WITH` clauses (Common Table Expressions) for modular, readable code.
  * **Window Functions:** `ROW_NUMBER() OVER(PARTITION BY ...)` for top-N ranking per category.
  * **Analytic Benchmarking:** `AVG() OVER(PARTITION BY ...)` for dynamic regional averages.
  * **Overall Aggregations:** `SUM() OVER()` for dynamic total market share calculations.

---

## 🏗️ Relational Database Schema
The analysis relies on a relational star/snowflake schema:
* **`Dim_Customer`**: Contains demographic details (`CustomerID`, `city_type`, `annual_income`, `age`, `daily_commute_km`, `fuel_expense_per_month`, `current_vehicle_type`).
* **`Fact_EV_Readiness`**: Contains behavioral metrics (`monthly_charging_cost`, `home_charging_available`, `range_anxiety_score`, `nearest_charging_station_km`, `ev_adoption_likelihood`, `environmental_awareness_score`, `technology_affinity_score`, `ev_knowledge_score`).

---

## 📊 Power BI Dashboard

To complement the SQL analysis, I made an interactive **Power BI Dashboard** to visualize key customer insights, EV adoption readiness, and financial comparisons.

![EV Market Readiness Dashboard](./PowerBI-Dashboard/Dashboard.png)

* **Overview:** Summarizes 50K respondents, tracking average income and fuel expenses.
* **Cost Comparison:** Compares monthly charging vs. fuel costs across Urban, Suburban, and Rural segments.
* **Behavioral Drivers:** Visualizes the relationship between home charging availability, range anxiety, and overall adoption likelihood.

---  

## 📈 Conclusions
* **Cost Savings:** Monthly charging costs are consistently lower than traditional fuel expenses, with the highest potential savings observed in suburban and urban areas due to longer average commutes.
* **Charging Infrastructure:** Home charging availability is the strongest factor in reducing range anxiety and directly aligns with higher adoption likelihood scores.
* **Demographic Trends:** High-income respondents scored higher in tech affinity and EV knowledge. Middle-income segments show high volume potential if marketing focuses on long-term fuel savings.
* **Geographic Distribution:** Urban and suburban markets represent the largest share of high-likelihood EV adopters.

---

## 📂 Project Structure
```text
├── Portfolio_EV_Analysis.sql   # Full SQL script containing all 11 analytical queries
├── Dim_Customer.csv            # Customer demographic dataset
├── Fact_EV_Readiness.csv       # EV adoption & behavioral dataset
└── README.md                   # Project documentation and summary
