# Load libraries ----------------------------------------------------------

library("tidyverse")
library("lubridate")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

tl <- read_csv("data/processed/trainingload.csv")

# Reformat table ----------------------------------------------------------

tl <- tl %>%
  mutate(
    date = as.Date(date, format = "%d.%m.%y"), 
    year = as.factor(year(date)),
    week  = isoweek(date)
  ) %>%
  select(year, week, TSS)

# Calculate TSS per week --------------------------------------------------

tl <- tl %>%
  group_by(year, week) %>%
  summarise(
    TSS = sum(TSS, na.rm = TRUE),
    .groups = "drop"
  )

# Plot results ------------------------------------------------------------

tl.plot <- tl %>%
  ggplot(aes(x = week, y = TSS)) +
  geom_line(colour = "#1380A1", linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(
    limits = c(1, 53),
    breaks = seq(0, 50, 5)
  ) +
  scale_y_continuous(
    limits = c(0, 1000),
    breaks = seq(0, 1000, 200),
  ) +
  facet_wrap(~ year, ncol = 1) +
  bbc_style() +
  labs(title = "TSS pro Woche")

