# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

tl <- read_csv("data/processed/trainingload.csv")

# Reformat table ----------------------------------------------------------

tl <- tl %>%
  mutate(date = as.Date(date, format = "%d.%m.%y"))

# Plot results ------------------------------------------------------------

tl.plot <- tl %>%
  ggplot(aes(x = date, y = CTL)) +
  geom_line(colour = "#1380A1", linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_date() +
  scale_y_continuous(
    limits = c(0, 80),
    breaks = seq(0, 80, 10),
  ) +
  scale_color_manual(values = c("#1380A1", "#FAAB18"),
                     labels = c("Maximum", "Minimum")) +
  bbc_style() +
  labs(title = "Chronische Trainingslast (CTL)")

finalise_plot(
  plot_name = tl.plot,
  source = "Quelle: WKO5",
  width_pixels = 800,
  save_filepath = "output/tl.jpg"
)