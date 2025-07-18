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
  geom_line(color = "#1380A1") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_datetime() +
  scale_y_continuous() +
  bbc_style() +
  labs(title = "Herzfrequenz") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 30, 9, 0))

hr.histo.plot <- hr %>%
  ggplot(aes(x = heartrate)) +
  geom_histogram(aes(y = after_stat(count / sum(count))), binwidth = 5, colour = "white", fill = "#1380A1") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(limits = c(50, 130), breaks = seq(50, 130, 5)) +
  bbc_style() +
  labs(title = "Herzfrequenz") +
  theme(plot.margin = margin(9, 30, 9, 0))


finalise_plot(
  plot_name = hr.plot,
  source = "Quelle: Messung mit Garmin Fenix",
  width_pixels = 800,
  save_filepath = "output/hr.jpg"
)
