import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# --- Setup ---
os.makedirs('assets', exist_ok=True)
df = pd.read_csv('data/samplesuperstore.csv')

sns.set_theme(style='whitegrid')

# --- Chart 1: Discount vs Average Profit ---
df['discount_bucket'] = pd.cut(
    df['Discount'],
    bins=[-0.01, 0.2, 0.5, 1],
    labels=['Low', 'Medium', 'High']
)
chart1 = df.groupby('discount_bucket', observed=True)['Profit'].mean().reset_index()

plt.figure(figsize=(8, 5))
sns.barplot(x='discount_bucket', y='Profit', data=chart1, palette='RdYlGn')
plt.title('Discount Level vs Average Profit')
plt.xlabel('Discount Level')
plt.ylabel('Average Profit ($)')
plt.tight_layout()
plt.savefig('assets/discount_profit_chart.png')
plt.close()
print("Chart 1 saved.")

# --- Chart 2: Profit by Category ---
chart2 = df.groupby('Category')['Profit'].sum().reset_index()

plt.figure(figsize=(8, 5))
sns.barplot(x='Category', y='Profit', data=chart2, palette='Blues_d')
plt.title('Total Profit by Category')
plt.xlabel('Category')
plt.ylabel('Total Profit ($)')
plt.tight_layout()
plt.savefig('assets/profit_by_category.png')
plt.close()
print("Chart 2 saved.")

# --- Chart 3: Profit by Region ---
chart3 = df.groupby('Region')['Profit'].sum().reset_index()

plt.figure(figsize=(8, 5))
sns.barplot(x='Region', y='Profit', data=chart3, palette='Set2')
plt.title('Total Profit by Region')
plt.xlabel('Region')
plt.ylabel('Total Profit ($)')
plt.tight_layout()
plt.savefig('assets/profit_by_region.png')
plt.close()
print("Chart 3 saved.")

# --- Chart 4: Monthly Revenue Trend ---
df['Order Date'] = pd.to_datetime(df['Order Date'])
df['YearMonth'] = df['Order Date'].dt.to_period('M')
chart4 = df.groupby('YearMonth')['Sales'].sum().reset_index()
chart4['YearMonth'] = chart4['YearMonth'].astype(str)

plt.figure(figsize=(14, 5))
sns.lineplot(x='YearMonth', y='Sales', data=chart4, marker='o', color='steelblue')
plt.title('Monthly Revenue Trend')
plt.xlabel('Month')
plt.ylabel('Total Sales ($)')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('assets/monthly_revenue_trend.png')
plt.close()
print("Chart 4 saved.")

# --- Chart 5: Top 10 Customers by Profit ---
chart5 = (
    df.groupby('Customer Name')['Profit']
    .sum()
    .reset_index()
    .sort_values('Profit', ascending=False)
    .head(10)
)

plt.figure(figsize=(10, 6))
sns.barplot(x='Profit', y='Customer Name', data=chart5, palette='viridis')
plt.title('Top 10 Customers by Profit')
plt.xlabel('Total Profit ($)')
plt.ylabel('Customer Name')
plt.tight_layout()
plt.savefig('assets/top10_customers.png')
plt.close()
print("Chart 5 saved.")

print("\nAll charts saved to /assets.")