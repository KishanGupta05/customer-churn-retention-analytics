# Customer Churn & Retention Analytics

An end-to-end analytics project using **Python, PostgreSQL, and Power
BI** to explore churn patterns in the IBM Telco Customer Churn dataset.

## Project Overview

The goal is to identify customer segments associated with higher churn
and translate the findings into practical retention recommendations.

**Scope note:** This is descriptive analytics, not a churn prediction
model. Segment differences are associations, not proof of causation.
Recommendations have not been experimentally tested.

## Business Questions

-   What are the overall churn and retention rates?
-   How does churn vary by contract type and tenure?
-   Which payment methods and internet service types are associated with
    higher churn?
-   How do optional services and customer attributes relate to churn?
-   How should retention efforts be prioritized?

## Tools & Skills

-   **Python:** data inspection, cleaning checks, exploratory data
    analysis (EDA)
-   **PostgreSQL / SQL:** aggregations, filtering, grouping, segment
    analysis, validation
-   **Power BI:** two-page interactive dashboard, KPI cards, slicers,
    visuals, DAX measures
-   **Business analysis:** insights, recommendations, measurement
    planning

## Dataset

-   **Dataset:** IBM Telco Customer Churn sample dataset
-   **Rows:** 7,043 customers
-   **Original columns:** 21
-   **Customer identifier:** `customerID`
-   **Target column:** `Churn`

`TotalCharges` had 11 missing values, all associated with zero-tenure
customers. They were retained as missing rather than replaced without
evidence.

## Key Findings

  Metric / Segment                            Result
  ----------------------------------------- --------
  Total customers                              7,043
  Churned customers                            1,869
  Retained customers                           5,174
  Overall churn rate                          26.54%
  Overall retention rate                      73.46%
  Month-to-month contract churn               42.71%
  One-year contract churn                     11.27%
  Two-year contract churn                      2.83%
  Electronic-check payment churn              45.29%
  Month-to-month + electronic-check churn     53.73%
  Churn for 0--12 months tenure               47.44%
  Fiber-optic internet churn                  41.89%
  Churn without Online Security               41.77%
  Churn with Online Security                  14.61%
  Churn without Tech Support                  41.64%
  Churn with Tech Support                     15.17%

These are descriptive comparisons from this dataset. They do not prove
that a contract, payment method, or service causes churn.

## Power BI Dashboard

### Page 1 — Customer Churn Overview

* KPI cards: total customers, churned customers, churn rate, retained customers, and retention rate.
* Churn comparisons by contract, tenure group, internet service, payment method, monthly charges, and senior-citizen status.

![Customer Churn Overview](Screenshots/Dashboard%20Image%201.png)

### Page 2 — Customer Risk & Retention Insights

* Churn comparisons by Paperless Billing, Online Security, Tech Support, Online Backup, and Device Protection.
* Matrices combining contract type with tenure and payment method.
* Slicers for contract, internet service, payment method, senior-citizen status, paperless billing, and tenure group.

![Customer Risk and Retention Insights](Screenshots/Dashboard%20Image%202.png)

## DAX Measures

``` dax
Total Customers =
DISTINCTCOUNT(churn_analytics[customerid])

Churned Customers =
CALCULATE(
    [Total Customers],
    churn_analytics[churn] = "Yes"
)

Churn Rate % =
DIVIDE([Churned Customers], [Total Customers], 0)

Retained Customers =
CALCULATE(
    [Total Customers],
    churn_analytics[churn] = "No"
)

Retention Rate % =
DIVIDE([Retained Customers], [Total Customers], 0)
```

Update table or column names if your Power BI model uses different
names.

## Recommendations

1.  **Review month-to-month customers:** Investigate cancellation
    reasons and test appropriate retention offers or contract options.
2.  **Focus on early-tenure experience:** Improve onboarding,
    first-month support, and proactive customer check-ins.
3.  **Investigate electronic-check customers:** Explore whether payment
    friction or other factors are associated with their higher churn.
4.  **Evaluate support and security service adoption:** Test clearer
    service education, relevant bundles, or targeted offers.
5.  **Prioritize by value and cost:** Consider churn risk alongside
    revenue, profitability, customer lifetime value, and intervention
    cost.
6.  **Measure impact:** Where feasible, run controlled tests and monitor
    churn, retention, offer cost, and incremental retention ROI.

## Data Quality & Validation

-   Checked customer-level uniqueness using `customerID`.
-   Validated total rows and churn / retained counts.
-   Identified 11 missing `TotalCharges` values, all associated with
    zero-tenure customers.
-   Avoided replacing missing values with zero without confirming
    business meaning.
-   Validated key segment results between SQL and Power BI.

## Limitations

-   The sample dataset may not represent every telecom business.
-   The analysis is descriptive and does not establish causality.
-   No machine-learning churn prediction model was built.
-   Recommendations have not been implemented or experimentally
    validated.
-   Revenue, profitability, and customer lifetime value were not fully
    evaluated in the core findings; use those measures before final
    investment decisions.





