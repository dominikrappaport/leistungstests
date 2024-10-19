# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

hrv.garmin <- read_csv("data/processed/hrv/garmin.csv")
hrv.oura <- read_csv("data/processed/hrv/oura.csv")
hrv.vitalmonitor <- read_csv("data/processed/hrv/vitalmonitor.csv")

# Adjust type and field names ---------------------------------------------

hrv.garmin <- hrv.garmin %>%
  mutate(date = as.Date(date, format = "%d.%m.%y"),
         hrvGarmin = HRV) %>%
  select(date, hrvGarmin)
hrv.oura <- hrv.oura %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"), hrvOura = `Average HRV`) %>%
  select(date, hrvOura)
hrv.vitalmonitor <- hrv.vitalmonitor %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"),
         hrvVitalmonitor = hrv) %>%
  select(date, hrvVitalmonitor)

# Join data ---------------------------------------------------------------

hrv <- hrv.garmin %>%
  inner_join(hrv.oura, by = join_by(date)) %>%
  inner_join(hrv.vitalmonitor, by = join_by(date))

# Make table longer -------------------------------------------------------

hrv <- hrv %>%
  pivot_longer(
    cols = c(hrvGarmin, hrvOura, hrvVitalmonitor),
    names_to = "source",
    values_to = "hrv"
  )

# Plot results ------------------------------------------------------------

hrv.plot <- hrv %>%
  ggplot(aes(
    x = date,
    y = hrv,
    colour = source,
    tooltip = source,
    data_id = source
  )) +
  geom_line(linewidth = 1, hover_nearest = TRUE) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_colour_manual(
    values = c("#FAAB18", "#1380A1", "#990000"),
    labels = c("Garmin Fenix 6", "Oura Ring", "Vitalmonitor")
  ) +
  bbc_style() +
  labs(title = "HRV-Vergleich")

finalise_plot(
  plot_name = hrv.plot,
  source = "Quelle: Messung mit Garmin Fenix 6, Oura Ring und Vitalmonitor",
  width_pixels = 800,
  save_filepath = "output/hrv_vergleich.jpg"
)
