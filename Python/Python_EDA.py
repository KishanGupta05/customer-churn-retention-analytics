import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# # Load the cleaned dataset
df = pd.read_csv("Cleaned Csv.csv")

# # Display first 5 rows
# print(df.head())

#------------------------------------------------------------------------------------------------------------------------------------------------
## Dataset Structure & Validation
#------------------------------------------------------------------------------------------------------------------------------------------------

# # Dataset Dimension
# print("Dataset Shape: ",df.shape)
# # Total Rows
# print("Total Customers: ",df.shape[0])
# # Total Columns
# print("Total Columns: ",df.shape[1])

# # Dataset Information
# print("\nDataset Information: ")
# df.info()
# Missing Value in each column
print("\nMissing Values: ")
print(df.isnull().sum())


# Duplicate rows
print("\nDuplicate Rows: ",df.duplicated().sum())
# Duplicate Customer ids
print("Duplicate Customers IDs: ",df["customerID"].duplicated().sum())
# Missing customer IDs
print("Missing Customer IDs: ",df["customerID"].isnull().sum())


# Inspect TotalCharges data type
print("TotalCharges dtype:", df["TotalCharges"].dtype)

# Inspect first 15 TotalCharges values
print("\nSample TotalCharges values:")
print(df["TotalCharges"].head(15).to_list())

# Count empty or whitespace-only values
blank_total_charges = (
    df["TotalCharges"]
    .astype("string")
    .str.strip()
    .eq("")
    .sum()
)

print("\nBlank TotalCharges values:", blank_total_charges)



# Clean TotalCharges
df["TotalCharges"] = df["TotalCharges"].astype("string").str.strip()
df["TotalCharges"] = df["TotalCharges"].replace("", pd.NA)

# Convert text to numeric
total_charges_numeric = pd.to_numeric(
    df["TotalCharges"], errors="coerce"
)

# Check for unexpected non-numeric values
conversion_errors = (
    df["TotalCharges"].notna()
    & total_charges_numeric.isna()
)

print("Unexpected conversion errors:", conversion_errors.sum())

# Apply conversion only if no unexpected values were found
if conversion_errors.sum() == 0:
    df["TotalCharges"] = total_charges_numeric

print("TotalCharges dtype:", df["TotalCharges"].dtype)
print("Missing TotalCharges:", df["TotalCharges"].isna().sum())


#------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------

## First Business KPI: Overall Churn Rate
    #“Total customers mein se kitne percent customers company chhod chuke hain?”

# Overall Customer Churn Analysis

# Count churned and retained customers
churn_counts = df["Churn"].value_counts()

print("Customer Churn Counts:")
print(churn_counts)

# Calculate total customers
total_customers = len(df)

# Calculate churned customers
churned_customers = (df["Churn"] == "Yes").sum()

# Calculate retained customers
retained_customers = (df["Churn"] == "No").sum()

# Calculate churn rate
churn_rate = (churned_customers / total_customers) * 100

# Calculate retention rate
retention_rate = (retained_customers / total_customers) * 100

print("\nTotal Customers:", total_customers)
print("Churned Customers:", churned_customers)
print("Retained Customers:", retained_customers)
print(f"Churn Rate: {churn_rate:.2f}%")
print(f"Retention Rate: {retention_rate:.2f}%")


## “Kya senior citizens ka churn rate non-senior customers se different hai?”

# Churn analysis by senior citizen status

churn_by_senior = pd.crosstab(
    df["SeniorCitizen"],
    df["Churn"],
    normalize="index"
) * 100

print("Churn Rate by Senior Citizen Status:")
print(churn_by_senior.round(2))

# Calculate customer counts by group
print("\nCustomer Counts:")
print(df.groupby("SeniorCitizen")["customerID"].count())


## Contract Type vs Churn

# Churn analysis by contract type

contract_churn = pd.crosstab(
    df["Contract"],
    df["Churn"],
    normalize="index"
) * 100

print("Churn Rate by Contract Type:")
print(contract_churn.round(2))

# Customer count by contract type
print("\nCustomer Count by Contract:")
print(df["Contract"].value_counts())


## Payment Method vs Churn

# Churn analysis by payment method

payment_churn = pd.crosstab(
    df["PaymentMethod"],
    df["Churn"],
    normalize="index"
) * 100

print("Churn Rate by Payment Method:")
print(payment_churn.round(2))

print("\nCustomer Count by Payment Method:")
print(df["PaymentMethod"].value_counts())


## Tenure vs. churn
tenure_churn = df.groupby("Churn")["tenure"].agg(
    ["count", "mean", "median", "min", "max"]
)

print("Tenure Summary by Churn Status:")
print(tenure_churn.round(2))


df["TenureGroup"] = pd.cut(
    df["tenure"],
    bins=[-1, 12, 24, 48, 60, 72],
    labels=[
        "0-12 months",
        "13-24 months",
        "25-48 months",
        "49-60 months",
        "61-72 months"
    ]
)

tenure_group_churn = pd.crosstab(
    df["TenureGroup"],
    df["Churn"],
    normalize="index"
) * 100

print("\nChurn Rate by Tenure Group:")
print(tenure_group_churn.round(2))

print("\nCustomer Count by Tenure Group:")
print(df["TenureGroup"].value_counts().sort_index())


## Which services are associated with churn?
service_columns = [
    "InternetService",
    "OnlineSecurity",
    "TechSupport",
    "OnlineBackup",
    "DeviceProtection",
    "PaperlessBilling"
]

for col in service_columns:
    print(f"\n--- Churn by {col} ---")

    churn_rate = pd.crosstab(
        df[col],
        df["Churn"],
        normalize="index"
    ) * 100

    customer_count = df[col].value_counts(dropna=False)

    print(churn_rate.round(2))
    print("\nCustomer count:")
    print(customer_count)


## Monthly Charges vs. Churn
print("Monthly Charges by Churn Status:")

monthly_charges = df.groupby("Churn")["MonthlyCharges"].agg(
    ["count", "mean", "median", "min", "max"]
)

print(monthly_charges.round(2))


df["MonthlyChargeGroup"] = pd.cut(
    df["MonthlyCharges"],
    bins=[0, 35, 60, 90, 120],
    labels=[
        "0-35",
        "35-60",
        "60-90",
        "90-120"
    ],
    include_lowest=True
)

charge_churn = pd.crosstab(
    df["MonthlyChargeGroup"],
    df["Churn"],
    normalize="index"
) * 100

print("\nChurn Rate by Monthly Charge Group:")
print(charge_churn.round(2))

print("\nCustomer Count by Monthly Charge Group:")
print(df["MonthlyChargeGroup"].value_counts().sort_index())


#------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------

## Overall Churn Distribution
import matplotlib.pyplot as plt
import seaborn as sns

# Count customers by churn status
churn_counts = df["Churn"].value_counts()

# Create chart
plt.figure(figsize=(7, 5))

sns.barplot(
    x=churn_counts.index,
    y=churn_counts.values
)

plt.title("Customer Churn Distribution")
plt.xlabel("Churn Status")
plt.ylabel("Number of Customers")

plt.tight_layout()
plt.show()


# =====================================
# CHART 2: Churn by Contract Type
# =====================================

plt.figure(figsize=(8, 5))

sns.barplot(
    data=df,
    x="Contract",
    y=df["Churn"].eq("Yes").astype(int),
    errorbar=None
)

plt.title("Churn Rate by Contract Type")
plt.xlabel("Contract Type")
plt.ylabel("Churn Rate")

plt.tight_layout()
plt.show()


# =====================================
# CHART 3: Churn by Tenure Group
# =====================================

plt.figure(figsize=(8, 5))

sns.barplot(
    data=df,
    x="TenureGroup",
    y=df["Churn"].eq("Yes").astype(int),
    errorbar=None
)

plt.title("Churn Rate by Customer Tenure")
plt.xlabel("Tenure Group")
plt.ylabel("Churn Rate")

plt.tight_layout()
plt.show()


# =====================================
# CHART 4: Churn by Payment Method
# =====================================

plt.figure(figsize=(9, 5))

sns.barplot(
    data=df,
    x="PaymentMethod",
    y=df["Churn"].eq("Yes").astype(int),
    errorbar=None
)

plt.title("Churn Rate by Payment Method")
plt.xlabel("Payment Method")
plt.ylabel("Churn Rate")

plt.xticks(rotation=15)
plt.tight_layout()
plt.show()


# =====================================
# CHART 5: Churn by Internet Service
# =====================================

plt.figure(figsize=(8, 5))

sns.barplot(
    data=df,
    x="InternetService",
    y=df["Churn"].eq("Yes").astype(int),
    errorbar=None
)

plt.title("Churn Rate by Internet Service")
plt.xlabel("Internet Service")
plt.ylabel("Churn Rate")

plt.tight_layout()
plt.show()


# =====================================
# CHART 6: Churn by Monthly Charge Group
# =====================================

plt.figure(figsize=(8, 5))

sns.barplot(
    data=df,
    x="MonthlyChargeGroup",
    y=df["Churn"].eq("Yes").astype(int),
    errorbar=None
)

plt.title("Churn Rate by Monthly Charges")
plt.xlabel("Monthly Charge Group")
plt.ylabel("Churn Rate")

plt.tight_layout()
plt.show()


# =====================================
## END
# =====================================


print(df.columns.tolist())

import pandas as pd

# Load the original cleaned CSV
df = pd.read_csv(
    "Cleaned Csv.csv",
    dtype={"TotalCharges": "string"},
    keep_default_na=False
)

# Remove leading/trailing spaces from TotalCharges
df["TotalCharges"] = df["TotalCharges"].str.strip()

# Convert empty strings to proper missing values
df["TotalCharges"] = df["TotalCharges"].replace("", pd.NA)

# Check missing values
print("Missing TotalCharges:", df["TotalCharges"].isna().sum())

# Save a new CSV file; keep the original unchanged
df.to_csv("Cleaned_Csv_SQL.csv", index=False)

print("New CSV created successfully!")