# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

file_path = list.files(path = "data/processed/bb",
                       pattern = "csv",
                       full.names = TRUE)
bodybattery <- read_csv(file_path)
intensityfactorvalues <- read_csv("data/processed/if.csv")
hrv.garmin <- read_csv("data/processed/hrv/garmin.csv")

# Reformat table ----------------------------------------------------------

intensityfactorvalues <- intensityfactorvalues %>%
  mutate(date = dmy(str_sub(date, 1, 8))) %>%
  group_by(date) %>%
  summarise(intensityfactor = max(intensityfactor))

bodybattery <- bodybattery %>%
  drop_na(min, max) %>%
  mutate(date = as.Date(date))

hrv.garmin <- hrv.garmin %>%
  mutate(date = as.Date(date, format = "%d.%m.%y"), hrv = HRV) %>%
  select(date, hrv)

if_and_bodybattery_and_hrv <- intensityfactorvalues %>%
  mutate(date = date - days(1)) %>%
  inner_join(bodybattery, by = join_by(date)) %>%
  inner_join(hrv.garmin, by = join_by(date))

# Plot results ------------------------------------------------------------

recharged_if_bb.plot <- if_and_bodybattery_and_hrv  %>%
  ggplot(aes(x = intensityfactor, y = charged)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(labels = label_percent(), breaks = seq(0, 1, 0.1)) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  bbc_style() +
  labs(title = "Aufladung der Body Battery nach Intensität am Vortag")

recharged_if_hrv.plot <- if_and_bodybattery_and_hrv %>%
  ggplot(aes(x = intensityfactor, y = hrv)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  geom_hline(yintercept = 20,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(labels = label_percent(), breaks = seq(0, 1, 0.1)) +
  scale_y_continuous(limits = c(20, max(if_and_bodybattery_and_hrv$hrv)), labels = label_number(suffix = " ms")) +
  bbc_style() +
  labs(title = "Herzfrequenzvariabilität nach Intensität (IF) am Vortag") +
  theme(plot.margin = margin(9, 29, 9, 9))

finalise_plot(
  plot_name = recharged_if_bb.plot,
  source = "Quelle: Messung mit Garmin Fenix",
  width_pixels = 800,
  save_filepath = "output/recharge_bodybattery.jpg"
)

finalise_plot(
  plot_name = recharged_if_hrv.plot,
  source = "Quelle: Messung mit Garmin Fenix",
  width_pixels = 800,
  save_filepath = "output/recharge_hrv.jpg"
)