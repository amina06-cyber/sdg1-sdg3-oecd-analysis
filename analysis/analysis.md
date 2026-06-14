# Analysis

This folder contains the analysis scripts implementing the full study pipeline in two languages.

## Files

### `analysis.R`
The primary analysis script written in R (v4.6.0). Uses `tidyverse`, `dplyr`, `ggplot2`, and `ggrepel` to carry out data cleaning, filtering, correlation analysis, trend analysis, outlier/quadrant classification, and all visualizations. Pearson correlation is calculated using base R's `cor.test()`.

### `analysis.ipynb`
The same analysis reimplemented in Python (Google Colab notebook). Uses `pandas` and `numpy` for data manipulation, `matplotlib` for visualizations, and `scipy` for Pearson correlation tests. Produces equivalent results to the R script.

---

> Both scripts use the OECD SDG dataset (Goals 1 & 3, 2000–2021) — see the `data/` folder for the source link.
