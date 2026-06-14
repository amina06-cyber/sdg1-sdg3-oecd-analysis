# Data Source

The data used in this project comes from the **OECD Sustainable Development Goals (SDG) Dataset**.

- **Platform:** OECD Data Explorer
- **Link:** [OECD SDG Dataset](https://data-explorer.oecd.org/vis?lc=en&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_SDG%40DF_SDG_G_1&df[ag]=OECD.WISE.RSB&dq=..1_2..._T._T._T._T._T.&lom=LASTNPERIODS&lo=5&to[TIME_PERIOD]=false)
- **Goals used:** SDG Goal 1 (No Poverty) and SDG Goal 3 (Good Health and Well-being)
- **Countries:** 38 OECD member states
- **Time period:** 2000–2021

> **Note on filtering:** The full OECD SDG dataset covers all 17 goals. To replicate this project's dataset, follow these steps after opening the link:
> 1. Filter by **Goal** → select **SDG 1** (No Poverty) and **SDG 3** (Good Health and Well-being)
> 2. Filter by **Population** → select **Total** only (deselect all breakdowns by age, sex, income, education, urban/rural)
> 3. Filter by **Time Period** → set range to **2000–2021**
> 4. Filter by **Country** → select all **38 OECD member states**
> 5. Select the following **indicators:** relative income poverty rate (SDG 1.2), infant mortality rate, and UHC service coverage index (SDG 3.8)
> 6. Export as CSV
