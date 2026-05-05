
# Financial Fraud Transaction Analysis

**Tools:** Snowflake · SQL · Power BI · Excel

---

## Project Overview

A self-initiated data analysis project simulating the transaction monitoring and fraud detection work performed by financial analyst teams. Built using a 100,000-record synthetic financial transactions dataset sourced from Kaggle.

Here's a 3min [LOOM presentation](https://www.loom.com/share/db8988eebca642faa96af3ccef907d53) I did to go over the project

---

## Objectives

- Identify fraud patterns across transaction type, payment channel, merchant category, device and geographic location
- Analyse risk scoring metrics to determine their effectiveness as fraud predictors
- Build an interactive dashboard for business stakeholders to explore fraud trends dynamically

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **Snowflake** | Cloud database — data storage and SQL querying |
| **SQL** | Data aggregation, fraud metric calculation and pattern analysis |
| **Power BI** | Interactive KPI dashboard and data visualisation |
| **Excel** | Initial data cleaning and preparation |

---

## Process

### 1. Data Ingestion
Loaded a 100,000-record CSV dataset into Snowflake by creating a database, schema and table with defined data types before importing the file directly into the cloud warehouse.

### 2. SQL Analysis
Wrote 10 SQL queries in Snowflake to aggregate fraud metrics across key dimensions — transaction type, payment channel, merchant category, device and location. Also wrote risk score analysis queries comparing confirmed fraud transactions against legitimate ones across velocity, spending deviation and geo-anomaly scores. see [SQL file here](fraud-analysis-queries.sql)

### 3. Power BI Dashboard
Connected Power BI directly to Snowflake and built an interactive dashboard featuring:
- 5 KPI cards — Total Transactions, Total Fraud Cases, Fraud Rate %, Total Transaction Value and Average Fraud Amount
- Bar and donut charts breaking down fraud rate by transaction type, payment channel, merchant category and device
- Location slicer enabling dynamic city-level filtering across all visuals
- Top 5 highest value fraud transactions table

---

## Key Insights

Confirmed fraud transactions do not exhibit dramatically high risk scores. Across all three risk indicators, velocity score, spending deviation and geo-anomaly , fraudulent transactions cluster in the mid-range and have transaction amounts close to the legitimate average ($397 vs $357).

This points to two conclusions:

1. Sophisticated fraudsters deliberately mimic normal behaviour to avoid triggering automated detection thresholds
2. The risk scoring model in this dataset is insufficient as a standalone fraud predictor. Real-world detection requires additional signals and modelling in order to result in more accurate fraud detection. This analysis is too rudementary in its detection.

---

## Dashboard Preview


 <img width="1151" height="646" alt="fraud-dash" src="https://github.com/user-attachments/assets/c6b99671-8875-4a04-8b6a-de5d6849dfad" />


---

## Dataset
- **Source:** Kaggle — Synthetic Financial Transactions Dataset for Fraud Detection
- **Records:** 100,000 transactions
- **Variables:** 18
- **Fraud Rate:** 0.238%

---

## Status
✅ Complete





