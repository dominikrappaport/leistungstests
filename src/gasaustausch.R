# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")
library("lubridate")

# Read from files ---------------------------------------------------------

gasaustausch <-
  read.csv("data/processed/Leistungsmessung202410.csv")

# Reformat table ----------------------------------------------------------

gasaustausch <- gasaustausch %>%
  mutate(t = hms(t)) %>%
  pivot_longer(
    cols = c("V.O2", "V.CO2"),
    names_to = "Gas",
    values_to = "Gas.Wert"
  )

# Plot results ------------------------------------------------------------

gasaustausch.plot <- gasaustausch %>%
  filter(P > 50) %>%
  ggplot(aes(x = t, y = Gas.Wert, colour = Gas)) +
  geom_line() +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_time(labels = c("0", "10", "20", "30 min")) +
  scale_y_continuous(labels = label_number(suffix = " l/min"), limits =
                       c(0, 4)) +
  scale_color_manual(
    values = c("#1380A1", "#FAAB18"),
    labels = c(expression(VCO[2]), expression(VO[2]))
  ) +
  bbc_style() +
  labs(title = "Gasaustausch während des VO2Max Tests") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 30, 9, 0))

finalise_plot(
  plot_name = gasaustausch.plot,
  source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
  width_pixels = 800,
  save_filepath = "output/gasaustausch.jpg"
)
