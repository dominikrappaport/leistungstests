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
    month = as.factor(month(date)),
    week  = as.factor(isoweek(date)),
    day = as.factor(day(date)),
    duration = as.numeric(hms(duration), units="hours"),
    date2 = as.Date(paste0("2001", "-", month, "-", day)))

# Plot results ------------------------------------------------------------

tl.plot <- tl %>%
  ggplot(aes(x = date, y = CTL)) +
  geom_line(colour = "#1380A1", linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_date(
    breaks = seq(as.Date("2020-01-01"), as.Date("2025-12-31"), by = "1 year"),
    date_labels = "%Y"
  ) +
  scale_y_continuous(
    limits = c(0, 80),
    breaks = seq(0, 80, 10),
  ) +
  bbc_style() +
  labs(title = "Chronische Trainingslast (CTL)")

tlyears.plot <- tl %>%
  ggplot(aes(x = date2, y = CTL)) +
  geom_line(colour = "#1380A1", linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_date(
    date_labels = "%b"
  ) +
  scale_y_continuous(
    limits = c(0, 80),
    breaks = seq(0, 80, 10),
  ) +
  facet_wrap(~ year, ncol = 1) +
  bbc_style() +
  labs(title = "Chronische Trainingslast (CTL)")

atl.plot <- tl %>%
  ggplot(aes(x = date, y = ATL)) +
  geom_line(colour = "#1380A1", linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_date(
    breaks = seq(as.Date("2020-01-01"), as.Date("2025-12-31"), by = "1 year"),
    date_labels = "%Y"
  ) +
  scale_y_continuous(
    limits = c(0, 80),
    breaks = seq(0, 80, 10),
  ) +
  bbc_style() +
  labs(title = "Akute Trainingslast (ATL)")

finalise_plot(
  plot_name = tl.plot,
  source = "Quelle: WKO5",
  width_pixels = 800,
  save_filepath = "output/tl.jpg"
)

finalise_plot(
  plot_name = tlyears.plot,
  source = "Quelle: WKO5",
  width_pixels = 800,
  height_pixels = 3000,
  save_filepath = "output/tlyears.jpg"
)

finalise_plot(
  plot_name = atl.plot,
  source = "Quelle: WKO5",
  width_pixels = 800,
  save_filepath = "output/atl.jpg"
)

tl %>% 
  group_by(year) %>%
  summarise(
    training_hours_per_year = sum(duration, na.rm = TRUE),
    training_hours_per_week = training_hours_per_year / 365 * 7,
    TSS_per_year = sum(TSS, na.rm = TRUE),
    TSS_per_week = TSS_per_year / 365 * 7,
    average_CTL = mean(CTL, na.rm = TRUE),
  )
