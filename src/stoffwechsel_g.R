
# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read file ---------------------------------------------------------------

stoffwechsel <- read_csv("data/processed/stoffwechsel2024.csv") %>%
  mutate(Summe = Fett + Kohlenhydrate)

# Reformat table ----------------------------------------------------------

stoffwechsel <- stoffwechsel %>%
  pivot_longer(
    cols = c(Fett, Kohlenhydrate, Summe),
    names_to = "Nährstoff",
    values_to = "Menge"
  )

# Plot file ---------------------------------------------------------------

stoffwechsel.plot <- stoffwechsel %>%
  ggplot(aes(x = Watt, y = Menge, colour = Nährstoff)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(
    limits = c(60, 240),
    breaks = seq(60, 240, 20),
    labels = c(seq(60, 220, 20), "240 W")
  ) +
  scale_y_continuous(
    limits = c(0, 200),
    breaks = seq(0, 200, 50),
    labels = label_number(suffix = " g")
  ) +
  scale_colour_manual(
    values = c("#1380A1", "#FAAB18", "#990000"),
    labels = c("Fett", "Kohlenhydrate", "Summe")
  ) +
  bbc_style() +
  labs(title = "Nährstoffverbrauch pro Stunde [g]") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 20, 9, 0))

finalise_plot(
  plot_name = stoffwechsel.plot,
  source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
  width_pixels = 800,
  save_filepath = "output/stoffwechsel2024_g.jpg"
)