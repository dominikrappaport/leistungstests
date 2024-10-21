# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

file_path = list.files(path = "data/processed/bb",
                       pattern = "csv",
                       full.names = TRUE)
bodybattery <- read_csv(file_path)

# Reformat table ----------------------------------------------------------

bodybattery <- bodybattery %>%
  drop_na(min, max) %>%
  mutate(date = as.Date(date)) %>%
  pivot_longer(cols = c(max, min),
               names_to = "highandlow",
               values_to = "bodybattery")

# Plot results ------------------------------------------------------------

bodybattery %>%
  ggplot(aes(x = date, y = bodybattery, colour = highandlow)) +
  geom_line() +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_date() +
  scale_y_continuous() +
  scale_color_manual(values = c("#1380A1", "#FAAB18"),
                     labels = c("Maximum", "Minimum")) +
  bbc_style() +
  labs(title = "Garmin Body Battery") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 30, 9, 0))
