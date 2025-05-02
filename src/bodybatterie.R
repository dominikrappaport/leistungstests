# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

file_path = list.files(path = "data/processed/bb",
                       pattern = "csv",
                       full.names = TRUE)
bodybattery <- read_csv(file_path)
tssvalues <- read_csv("data/processed/tss.csv")
hrv.garmin <- read_csv("data/processed/hrv/garmin.csv")

# Reformat table ----------------------------------------------------------

bodybattery <- bodybattery %>%
  drop_na(min, max) %>%
  mutate(date = as.Date(date))

tssvalues <- tssvalues %>%
  mutate(date = dmy(str_sub(date, 1, 8))) %>%
  group_by(date) %>%
  summarise(tss = sum(TSS))

hrv.garmin <- hrv.garmin %>%
  mutate(date = as.Date(date, format = "%d.%m.%y"), hrv = HRV) %>%
  select(date, hrv)

tss_and_bodybattery_and_hrv <- tssvalues %>%
  mutate(date = date - days(1)) %>%
  inner_join(bodybattery, by = join_by(date)) %>%
  inner_join(hrv.garmin, by = join_by(date))


# Plot results ------------------------------------------------------------

bodybattery.plot <- bodybattery %>%
  pivot_longer(cols = c(max, min),
               names_to = "highandlow",
               values_to = "bodybattery") %>%
  ggplot(aes(x = date, y = bodybattery, colour = highandlow)) +
  geom_line() +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  geom_vline(xintercept = as.Date("2024-11-07"),
             linewidth = 1,
             colour = "red") +
  scale_x_date() +
  scale_y_continuous() +
  scale_color_manual(values = c("#1380A1", "#FAAB18"),
                     labels = c("Maximum", "Minimum")) +
  bbc_style() +
  labs(title = "Garmin Body Battery") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 30, 9, 0))

recharged_bb.plot <- tss_and_bodybattery_and_hrv  %>%
  ggplot(aes(x = tss, y = charged)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(
    limits = c(0, 400),
    breaks = seq(0, 400, 100),
    labels = c("0", "100", "200", "300", "400 TSS")
  ) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  bbc_style() +
  labs(title = "Aufladung der Body Battery nach Leistung am Vortag") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 50, 9, 0))

recharged_hrv.plot <- tss_and_bodybattery_and_hrv %>%
  ggplot(aes(x = tss, y = hrv)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(
    limits = c(0, 400),
    breaks = seq(0, 400, 100),
    labels = c("0", "100", "200", "300", "400 TSS")
  ) +
  scale_y_continuous(labels = label_number(suffix = " ms")) +
  bbc_style() +
  labs(title = "Herzfrequenzvariabilität nach Leistung am Vortag") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 50, 9, 0))

finalise_plot(
  plot_name = bodybattery.plot,
  #source = "Quelle: Messung mit Garmin Fenix",
  source = "Source: Garmin Fenix 6 and 8",
  width_pixels = 800,
  save_filepath = "output/bodybattery.jpg"
)

finalise_plot(
  plot_name = recharged_bb.plot,
  source = "Quelle: Messung mit Garmin Fenix",
  width_pixels = 800,
  save_filepath = "output/recharge_bodybattery.jpg"
)

finalise_plot(
  plot_name = recharged_hrv.plot,
  source = "Quelle: Messung mit Garmin Fenix",
  width_pixels = 800,
  save_filepath = "output/recharge_hrv.jpg"
)