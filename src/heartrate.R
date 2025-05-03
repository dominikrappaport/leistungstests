# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

file_path = list.files(path = "data/processed/hr",
                       pattern = "csv",
                       full.names = TRUE)
hr <- read_csv(file_path)

# Reformat table ----------------------------------------------------------

hr <- hr %>%
  drop_na() %>%
  mutate(timestamp = as_datetime(timestamp))

# Plot results ------------------------------------------------------------

hr.plot <- hr %>%
  ggplot(aes(x = timestamp, y = heartrate)) +
  geom_line() +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_datetime() +
  scale_y_continuous() +
  scale_color_manual(values = c("#1380A1"),
                     labels = c("Heartrate")) +
  bbc_style() +
  labs(title = "Heartrate") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 30, 9, 0))

finalise_plot(
  plot_name = hr.plot,
  source = "Quelle: Messung mit Garmin Fenix",
  width_pixels = 800,
  save_filepath = "output/hr.jpg"
)
