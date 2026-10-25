CREATE TABLE churn_analytics (
    customerid VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    seniorcitizen INTEGER,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure INTEGER,
    phoneservice VARCHAR(5),
    multiplelines VARCHAR(30),
    internetservice VARCHAR(30),
    onlinesecurity VARCHAR(30),
    onlinebackup VARCHAR(30),
    deviceprotection VARCHAR(30),
    techsupport VARCHAR(30),
    streamingtv VARCHAR(30),
    streamingmovies VARCHAR(30),
    contract VARCHAR(30),
    paperlessbilling VARCHAR(5),
    paymentmethod VARCHAR(50),
    monthlycharges NUMERIC(10,2),
    totalcharges NUMERIC(10,2),
    churn VARCHAR(5)
    
);
SELECT * FROM churn_analytics;
SELECT
    COUNT(*) AS total_customers,
    COUNT(totalcharges) AS non_null_totalcharges,
    COUNT(*) - COUNT(totalcharges) AS missing_totalcharges
FROM churn_analytics;

-- Overall Churn Analysis
SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    COUNT(*) FILTER (
        WHERE churn = 'No'
    ) AS retained_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'No'
        ) / COUNT(*),
        2
    ) AS retention_rate_percentage

FROM churn_analytics;


-- Churn by Contract Type
SELECT
    contract,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY contract

ORDER BY churn_rate_percentage DESC;


-- Churn by Payment Method
SELECT
    paymentmethod,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY paymentmethod

ORDER BY churn_rate_percentage DESC;


-- Churn by Tenure Group
SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
        WHEN tenure BETWEEN 61 AND 72 THEN '61-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
        WHEN tenure BETWEEN 61 AND 72 THEN '61-72 months'
    END

ORDER BY MIN(tenure);


-- Churn by Internet Service
SELECT
    internetservice,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY internetservice

ORDER BY churn_rate_percentage DESC;


-- Churn by Monthly Charges
WITH charge_groups AS (
    SELECT
        CASE
            WHEN monthlycharges <= 35 THEN '0-35'
            WHEN monthlycharges <= 60 THEN 'Above 35-60'
            WHEN monthlycharges <= 90 THEN 'Above 60-90'
            ELSE 'Above 90-120'
        END AS monthly_charge_group,
        churn
    FROM churn_analytics
)
SELECT
    monthly_charge_group,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM charge_groups

GROUP BY monthly_charge_group

ORDER BY
    CASE monthly_charge_group
        WHEN '0-35' THEN 1
        WHEN 'Above 35-60' THEN 2
        WHEN 'Above 60-90' THEN 3
        WHEN 'Above 90-120' THEN 4
    END;


-- Churn by Senior Citizen Status
SELECT
    CASE
        WHEN seniorcitizen = 1 THEN 'Senior Citizen'
        ELSE 'Non-Senior Citizen'
    END AS customer_segment,

    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY seniorcitizen

ORDER BY seniorcitizen;


-- Churn by Online Security
SELECT
    onlinesecurity,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY onlinesecurity

ORDER BY churn_rate_percentage DESC;


-- Churn by Tech Support
SELECT
    techsupport,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY techsupport

ORDER BY churn_rate_percentage DESC;


-- Churn by Online Backup
SELECT
    onlinebackup,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY onlinebackup

ORDER BY churn_rate_percentage DESC;


--Churn by Device Protection
SELECT
    deviceprotection,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY deviceprotection

ORDER BY churn_rate_percentage DESC;


-- Churn by Paperless Billing
SELECT
    paperlessbilling,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY paperlessbilling

ORDER BY churn_rate_percentage DESC;


-- Churn by Gender
SELECT
    gender,
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY gender

ORDER BY churn_rate_percentage DESC;


-- Churn by Multiple Customer Factors
SELECT
    contract,

    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        WHEN tenure <= 60 THEN '49-60 months'
        ELSE '61-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY
    contract,
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        WHEN tenure <= 60 THEN '49-60 months'
        ELSE '61-72 months'
    END

ORDER BY
    contract,
    MIN(tenure);


--Churn by Payment Method + Contract Type
SELECT
    contract,
    paymentmethod,

    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM churn_analytics

GROUP BY
    contract,
    paymentmethod

ORDER BY
    contract,
    churn_rate_percentage DESC;

-------------------------------------------------------------------------------------------------------------------------------------
--Verify overall customer counts
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customerid) AS unique_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    COUNT(*) FILTER (
        WHERE churn = 'No'
    ) AS retained_customers,

    COUNT(*) FILTER (
        WHERE churn IS NULL
    ) AS missing_churn_values

FROM churn_analytics;


-------------------------------------------------------------------------------------------------------------------------------------
--Verify missing values
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE totalcharges IS NULL
    ) AS missing_totalcharges,

    COUNT(*) FILTER (
        WHERE customerid IS NULL
    ) AS missing_customerid,

    COUNT(*) FILTER (
        WHERE tenure IS NULL
    ) AS missing_tenure,

    COUNT(*) FILTER (
        WHERE monthlycharges IS NULL
    ) AS missing_monthlycharges

FROM churn_analytics;


-------------------------------------------------------------------------------------------------------------------------------------
--Verify churn rate independently
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE churn = 'Yes'
    ) AS churned_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'Yes'
        ) / COUNT(*),
        2
    ) AS churn_rate_percentage,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE churn = 'No'
        ) / COUNT(*),
        2
    ) AS retention_rate_percentage

FROM churn_analytics;










































