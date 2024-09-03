# Installiere Pakete, wenn notwendig

if(!require(devtools)) install.packages("devtools")
if(!require(pacman)) install.packages("pacman")

# Installiere BBC-Thema von GitHub

devtools::install_github("bbc/bbplot")

# Importiere Bibliotheken

pacman::p_load(
  "tidyverse", "lubridate", "scales", "scales", "ggbeeswarm", "gapminder",
  "ggalt", "forcats", "R.utils", "png", "grid", "ggpubr", "bbplot")

# Lade Dateien

leistungstests <- read.csv("data/processed/Leistungsmessung202311.csv")

# Plotte

leistungstest2023 <- leistungstests %>%
  filter(P > 0) %>%
  mutate(V.O2.kg = V.O2.kg/max(V.O2.kg)) %>%
  ggplot(aes(x = V.O2.kg, y = P)) +
  geom_point(colour = "#1380A1", size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth",
              colour = "#FAAB18") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_y_continuous(labels = label_number(suffix = " W")) +
  scale_x_continuous(limits = c(0.3, 1), breaks = seq(0.3, 1, 0.1), labels = label_percent()) +
  bbc_style() +
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme (% VO2Max)")

finalise_plot(plot_name = leistungstest2023,
              source = "Quelle: Messung vom 7. 11. 2023, High Performance Coaching Clemens Rumpel, St. Pölten",
              width_pixels = 800,
              save_filepath = "output/leistungstest2023.jpg")