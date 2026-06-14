# ---- SETUP ----
library(tidyverse)

# ---- LOAD DATA ----
df <- read_csv("sdg_data.csv")

# ---- CLEAN ----
df_clean <- df %>%
  filter(SDG_GOAL %in% c("G_1", "G_3")) %>%
  filter(AGE == "_T", SEX == "_T",
         INCOME_WEALTH_QUANTILE == "_T",
         EDUCATION_LEV == "_T", DEG_URB == "_T")

# ---- SELECT INDICATORS ----
key_indicators <- c(
  "Relative income poverty rate",
  "Proportion of population living below the national poverty line",
  "Proportion of total government spending on social protection",
  "Infant mortality rate",
  "Suicide mortality rate",
  "Universal health coverage (UHC) service coverage index"
)

df_selected <- df_clean %>%
  filter(`SDG series` %in% key_indicators)

# ---- FILTER TO 2000-2021 ----
df_analysis <- df_selected %>%
  filter(TIME_PERIOD >= 2000 & TIME_PERIOD <= 2021)

# ---- CHECK ----
print(nrow(df_analysis))
print(df_analysis %>% count(`SDG series`))

install.packages("ggrepel")
library(ggrepel)

ggplot(scatter_data, aes(x = poverty, y = infant_mortality, label = `Reference area`)) +
  geom_point(color = "steelblue", size = 4) +
  geom_text_repel(size = 3, max.overlaps = 20) +
  geom_smooth(method = "lm", se = TRUE, color = "red", alpha = 0.15) +
  labs(
    title = "Poverty Rate vs Infant Mortality across OECD Countries (2021)",
    x = "Relative Income Poverty Rate (%)",
    y = "Infant Mortality Rate (per 1,000 live births)",
    caption = "Source: OECD SDG Dataset"
  ) +
  theme_minimal(base_size = 13)

# ---- CORRELATION: Poverty vs Infant Mortality ----
cor_test <- cor.test(scatter_data$poverty, scatter_data$infant_mortality)
print(cor_test)
# ---- PLOT 2: Trend over time - Poverty vs Infant Mortality ----

# Get average poverty rate per year across all OECD countries
poverty_trend <- df_analysis %>%
  filter(`SDG series` == "Relative income poverty rate") %>%
  group_by(TIME_PERIOD) %>%
  summarise(avg_poverty = mean(OBS_VALUE, na.rm = TRUE))

# Get average infant mortality per year
health_trend <- df_analysis %>%
  filter(`SDG series` == "Infant mortality rate") %>%
  group_by(TIME_PERIOD) %>%
  summarise(avg_infant_mortality = mean(OBS_VALUE, na.rm = TRUE))

# Join
trend_data <- inner_join(poverty_trend, health_trend, by = "TIME_PERIOD")

# ---- PLOT 2: Trend over time - Poverty vs Infant Mortality ----

# Get average poverty rate per year across all OECD countries
poverty_trend <- df_analysis %>%
  filter(`SDG series` == "Relative income poverty rate") %>%
  group_by(TIME_PERIOD) %>%
  summarise(avg_poverty = mean(OBS_VALUE, na.rm = TRUE))

# Get average infant mortality per year
health_trend <- df_analysis %>%
  filter(`SDG series` == "Infant mortality rate") %>%
  group_by(TIME_PERIOD) %>%
  summarise(avg_infant_mortality = mean(OBS_VALUE, na.rm = TRUE))

# Join
trend_data <- inner_join(poverty_trend, health_trend, by = "TIME_PERIOD")

# Plot
ggplot(trend_data, aes(x = TIME_PERIOD)) +
  geom_line(aes(y = avg_poverty, color = "Poverty Rate"), size = 1.2) +
  geom_line(aes(y = avg_infant_mortality, color = "Infant Mortality"), size = 1.2) +
  scale_color_manual(values = c("Poverty Rate" = "steelblue", 
                                "Infant Mortality" = "red")) +
  labs(
    title = "Average Poverty Rate and Infant Mortality across OECD Countries (2000-2021)",
    x = "Year",
    y = "Average Value",
    color = "Indicator",
    caption = "Source: OECD SDG Dataset"
  ) +
  theme_minimal(base_size = 13)

# ---- PLOT 3: Outlier Analysis ----

# Get latest available year for each country for both indicators
poverty_latest <- df_analysis %>%
  filter(`SDG series` == "Relative income poverty rate") %>%
  group_by(`Reference area`) %>%
  slice_max(TIME_PERIOD, n = 1) %>%
  select(`Reference area`, poverty = OBS_VALUE)

health_latest <- df_analysis %>%
  filter(`SDG series` == "Infant mortality rate") %>%
  group_by(`Reference area`) %>%
  slice_max(TIME_PERIOD, n = 1) %>%
  select(`Reference area`, infant_mortality = OBS_VALUE)

# Join
outlier_data <- inner_join(poverty_latest, health_latest, by = "Reference area")

# Add average lines and categorize countries
outlier_data <- outlier_data %>%
  mutate(
    category = case_when(
      poverty < mean(poverty) & infant_mortality < mean(infant_mortality) ~ "Low poverty, Low mortality",
      poverty > mean(poverty) & infant_mortality > mean(infant_mortality) ~ "High poverty, High mortality",
      poverty < mean(poverty) & infant_mortality > mean(infant_mortality) ~ "Low poverty, High mortality",
      poverty > mean(poverty) & infant_mortality < mean(infant_mortality) ~ "High poverty, Low mortality"
    )
  )

# Plot
ggplot(outlier_data, aes(x = poverty, y = infant_mortality, 
                         color = category, label = `Reference area`)) +
  geom_point(size = 4) +
  geom_text_repel(size = 3, max.overlaps = 20) +
  geom_vline(xintercept = mean(outlier_data$poverty), 
             linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = mean(outlier_data$infant_mortality), 
             linetype = "dashed", color = "gray50") +
  scale_color_manual(values = c(
    "Low poverty, Low mortality" = "steelblue",
    "High poverty, High mortality" = "red",
    "Low poverty, High mortality" = "orange",
    "High poverty, Low mortality" = "darkgreen"
  )) +
  labs(
    title = "OECD Countries by Poverty and Infant Mortality (Latest Available Year)",
    x = "Relative Income Poverty Rate (%)",
    y = "Infant Mortality Rate (per 1,000 live births)",
    color = "Category",
    caption = "Source: OECD SDG Dataset"
  ) +
  theme_minimal(base_size = 13)
# Add average lines and categorize countries
avg_poverty <- mean(outlier_data$poverty, na.rm = TRUE)
avg_mortality <- mean(outlier_data$infant_mortality, na.rm = TRUE)

outlier_data <- outlier_data %>%
  mutate(
    category = case_when(
      poverty < avg_poverty & infant_mortality < avg_mortality ~ "Low poverty, Low mortality",
      poverty > avg_poverty & infant_mortality > avg_mortality ~ "High poverty, High mortality",
      poverty < avg_poverty & infant_mortality > avg_mortality ~ "Low poverty, High mortality",
      poverty > avg_poverty & infant_mortality < avg_mortality ~ "High poverty, Low mortality",
      TRUE ~ "Average"
    )
  )
# Join
outlier_data <- inner_join(poverty_latest, health_latest, by = "Reference area")

# Calculate averages first
avg_poverty <- mean(outlier_data$poverty, na.rm = TRUE)
avg_mortality <- mean(outlier_data$infant_mortality, na.rm = TRUE)

# Categorize countries
outlier_data$category <- case_when(
  outlier_data$poverty < avg_poverty & outlier_data$infant_mortality < avg_mortality ~ "Low poverty, Low mortality",
  outlier_data$poverty > avg_poverty & outlier_data$infant_mortality > avg_mortality ~ "High poverty, High mortality",
  outlier_data$poverty < avg_poverty & outlier_data$infant_mortality > avg_mortality ~ "Low poverty, High mortality",
  outlier_data$poverty > avg_poverty & outlier_data$infant_mortality < avg_mortality ~ "High poverty, Low mortality",
  TRUE ~ "Average"
)

# Plot
ggplot(outlier_data, aes(x = poverty, y = infant_mortality, 
                         color = category, label = `Reference area`)) +
  geom_point(size = 4) +
  geom_text_repel(size = 3, max.overlaps = 20) +
  geom_vline(xintercept = avg_poverty, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = avg_mortality, linetype = "dashed", color = "gray50") +
  scale_color_manual(values = c(
    "Low poverty, Low mortality" = "steelblue",
    "High poverty, High mortality" = "red",
    "Low poverty, High mortality" = "orange",
    "High poverty, Low mortality" = "darkgreen",
    "Average" = "gray"
  )) +
  labs(
    title = "OECD Countries by Poverty and Infant Mortality (Latest Available Year)",
    x = "Relative Income Poverty Rate (%)",
    y = "Infant Mortality Rate (per 1,000 live births)",
    color = "Category",
    caption = "Source: OECD SDG Dataset"
  ) +
  theme_minimal(base_size = 13)

# ---- PLOT 4: UHC Coverage vs Poverty Rate ----

uhc_latest <- df_analysis %>%
  filter(`SDG series` == "Universal health coverage (UHC) service coverage index") %>%
  group_by(`Reference area`) %>%
  slice_max(TIME_PERIOD, n = 1) %>%
  select(`Reference area`, uhc = OBS_VALUE)

poverty_latest2 <- df_analysis %>%
  filter(`SDG series` == "Relative income poverty rate") %>%
  group_by(`Reference area`) %>%
  slice_max(TIME_PERIOD, n = 1) %>%
  select(`Reference area`, poverty = OBS_VALUE)

uhc_data <- inner_join(uhc_latest, poverty_latest2, by = "Reference area")

ggplot(uhc_data, aes(x = poverty, y = uhc, label = `Reference area`)) +
  geom_point(color = "darkgreen", size = 4) +
  geom_text_repel(size = 3, max.overlaps = 20) +
  geom_smooth(method = "lm", se = TRUE, color = "red", alpha = 0.15) +
  labs(
    title = "Poverty Rate vs Universal Health Coverage across OECD Countries",
    x = "Relative Income Poverty Rate (%)",
    y = "UHC Service Coverage Index (0-100)",
    caption = "Source: OECD SDG Dataset"
  ) +
  theme_minimal(base_size = 13)
# ---- SAVE FIGURES ----

# Figure 1 - Scatter poverty vs infant mortality
ggsave("figure1_scatter.png", plot = last_plot(), 
       width = 10, height = 7, dpi = 300)
# ---- PLOT 2 ----
plot2 <- ggplot(trend_data, aes(x = TIME_PERIOD)) +
  geom_line(aes(y = avg_poverty, color = "Poverty Rate"), size = 1.2) +
  geom_line(aes(y = avg_infant_mortality, color = "Infant Mortality"), size = 1.2) +
  scale_color_manual(values = c("Poverty Rate" = "steelblue", "Infant Mortality" = "red")) +
  labs(
    title = "Average Poverty Rate and Infant Mortality across OECD Countries (2000-2021)",
    x = "Year", y = "Average Value", color = "Indicator",
    caption = "Source: OECD SDG Dataset"
  ) +
  theme_minimal(base_size = 13)
ggsave("figure2_trend.png",   plot = plot2, width = 10, height = 7, dpi = 300)

