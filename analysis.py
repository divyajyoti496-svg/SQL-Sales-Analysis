import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('data/samplesuperstore.csv')

df['discount_bucket'] = pd.cut(
    df['Discount'],
    bins=[0, 0.2, 0.5, 1],
    labels=['Low', 'Medium', 'High']
)

chart_data = df.groupby('discount_bucket')['Profit'].mean().reset_index()

plt.figure()
sns.barplot(x='discount_bucket', y='Profit', data=chart_data)

plt.title('Discount vs Average Profit')
plt.xlabel('Discount Level')
plt.ylabel('Average Profit')

plt.savefig('assets/discount_profit_chart.png')

plt.show()