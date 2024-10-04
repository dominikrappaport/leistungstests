
# Read from files ---------------------------------------------------------

hrv.garmin <- read_csv("data/processed/hrv/garmin.csv")
hrv.oura <- read_csv("data/processed/hrv/oura.csv")

# Adjust type and field names ---------------------------------------------

hrv.garmin <- hrv.garmin %>%
  mutate(date = as.Date(date, format = "%d.%m.%y"), hrv = HRV) %>%
  select(date, hrv)
hrv.oura <- hrv.oura %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"), hrv = `Average HRV`) %>%
  select(date, hrv)

# Join data ---------------------------------------------------------------

hrv <- hrv.garmin %>% inner_join(hrv.oura, by = join_by(date), suffix = c("Garmin", "Oura"))

# Make table longer -------------------------------------------------------

hrv <- hrv %>%
  pivot_longer(cols = c(hrvGarmin, hrvOura), names_to = "source", values_to = "hrv")

# Plot results ------------------------------------------------------------

hrv.plot <- hrv %>%
  ggplot(aes(x=date, y=hrv, colour=source)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_colour_manual(values = c("#FAAB18", "#1380A1"), labels = c("Garmin", "Oura")) +
  bbc_style() +
  labs(title = "HRV-Vergleich")

finalise_plot(plot_name = hrv.plot,
              source = "Quelle: Messung mit Garmin Fenix 6 und Oura Ring",
              width_pixels = 800,
              save_filepath = "output/hrv_vergleich.jpg")
