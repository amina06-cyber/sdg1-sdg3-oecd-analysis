# Income Poverty, Universal Health Coverage, and Health Outcomes in OECD Countries

A data science project exploring whether income poverty is linked to worse health outcomes across OECD countries, and whether universal health coverage (UHC) moderates this relationship.

**Dataset:** OECD Sustainable Development Goals Dataset (SDG Goals 1 & 3 · 38 OECD Countries · 2000–2021)

---

## Research Question

> *Is income poverty linked to worse health outcomes across OECD countries, and has this link changed between 2000 and 2021?*

Poverty is measured using the **relative income poverty rate** (SDG 1.2 — share of population living below 50% of median national income). Health outcomes are captured through the **infant mortality rate** and the **UHC service coverage index** (SDG 3.8).

The analysis is structured around three sub-questions:

1. Is there a statistically significant cross-sectional association between income poverty and infant mortality across OECD countries in 2021?
2. Has the relationship between poverty and infant mortality changed over the period 2000–2021?
3. Which countries deviate from the expected poverty–health pattern, and can UHC coverage help explain these deviations?

---

## Key Findings

- There is a moderate but statistically significant positive association between poverty and infant mortality across OECD countries in 2021 (r = 0.37, p = 0.035)
- Despite rising poverty rates since the 2008 financial crisis, infant mortality has steadily declined — suggesting healthcare systems have cushioned some of poverty's health impact
- The **United States** stands out: highest poverty rate among high-income OECD members and above-average infant mortality, linked to gaps in universal coverage
- **Japan and Korea** show that strong UHC can protect infant health even when relative poverty is high
- Countries with the best outcomes (low poverty + low mortality) are concentrated in Northern and Western Europe

---

## Methodology

The analysis is structured around three sub-questions:

1. **Cross-sectional analysis (2021)** — Scatter plot + Pearson correlation between poverty rate and infant mortality
2. **Trend analysis (2000–2021)** — OECD-wide yearly averages for both indicators plotted over time
3. **Outlier/quadrant analysis** — Countries classified into four groups based on OECD average cut-offs, with UHC as a moderating variable

---

## Repository Structure

> Each folder contains a markdown file with more details about its contents. Check `data/SOURCE.md`, `analysis/analysis.md`, and `figures/figures.md` for more info.

```
📁 sdg1-sdg3-oecd-analysis/
├── README.md
├── data/
│   └── SOURCE.md             # Link to the OECD SDG dataset
├── analysis/
│   ├── analysis.R            # Full analysis in R
│   └── analysis.ipynb        # Same analysis in Python (Google Colab)
└── figures/
    ├── figure1_scatter.png   # Poverty vs infant mortality scatter (2021)
    ├── figure2_trend.png     # Trend over time (2000–2021)
    ├── Rplot3.png            # Quadrant/outlier analysis
    └── Rplot4.png            # UHC vs poverty rate
```

## Tools & Libraries

**R (v4.6.0)** — `tidyverse`, `dplyr`, `ggplot2`, `ggrepel`, `cor.test()` (base R)

**Python** — `pandas`, `numpy`, `matplotlib`, `scipy`

> The analysis is implemented in both R and Python and produces equivalent results.

---

## Data Source

OECD. (2024). *Sustainable Development Goals dataset*. [https://data-explorer.oecd.org](https://data-explorer.oecd.org)
