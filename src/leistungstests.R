# Installiere Pakete, wenn notwendig

if(!require(devtools)) install.packages("devtools")
if(!require(pacman)) install.packages("pacman")

# Installiere BBC-Thema von GitHub

devtools::install_github("bbc/bbplot")

# Importiere Bibliotheken

pacman::p_load(
  "tidyverse", "lubridate", "scales", "scales", "ggbeeswarm", "gapminder",
  "ggalt", "forcats", "R.utils", "png", "grid", "ggpubr", "bbplot", "gridExtra",
  "envalysis", "cowplot")

# Lade Dateien

leistungstests <- read.csv("data/processed/Leistungsmessung202311.csv") %>%
  mutate(datum = as.Date("2023/11/7")) %>%
  mutate(V.O2.kg.rel = V.O2.kg/max(V.O2.kg))

# Plotte

leistungstests.plot <- leistungstests %>%
  filter(P > 50) %>%
  ggplot(aes(x = V.O2.kg, y = P, group = datum)) +
  geom_point(colour = "#1380A1", size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth",
              colour = "#FAAB18") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_y_continuous(labels = label_number(suffix = " W")) +
  scale_x_continuous(limits = c(10, 45), breaks = seq(10, 45, 5)) +
  bbc_style() +
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme (mmol/l)")

finalise_plot(plot_name = leistungstests.plot,
              source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
              width_pixels = 800,
              save_filepath = "output/leistungstest2023_absolut.jpg")

leistungstests.plot <- leistungstests %>%
  filter(P > 50) %>%
  ggplot(aes(x = V.O2.kg.rel, y = P, group = datum)) +
  geom_point(colour = "#1380A1", size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth",
              colour = "#FAAB18") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_y_continuous(labels = label_number(suffix = " W")) +
  scale_x_continuous(limits = c(0.3, 1), breaks = seq(0.3, 1, 0.1), labels = label_percent(suffix = " %")) +
  bbc_style() +
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme (% VO2Max)")

finalise_plot(plot_name = leistungstests.plot,
              source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
              width_pixels = 800,
              save_filepath = "output/leistungstest2023_relativ.jpg")

d1 <- leistungstests %>%
  filter(P > 0) %>%
  mutate(t = hms(t)) %>%
  ggplot() +
  geom_line(aes(x=t, y=P), colour = "#1380A1", size = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_time() +
  scale_y_continuous() +
  bbc_style() +
  labs(title = "Leistung [W]")

d2 <- leistungstests %>%
  filter(P > 0) %>%
  mutate(t = hms(t)) %>%
  ggplot() +
  geom_line(aes(x=t, y=HF), colour = "#FAAB18", size = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_time() +
  scale_y_continuous() +
  bbc_style() +
  labs(title = "Herzfrequenz [1/min]")

d3 <- leistungstests %>%
  filter(P > 0) %>%
  mutate(t = hms(t)) %>%
  ggplot() +
  geom_line(aes(x=t, y=V.O2.kg), colour = "#990000", size = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_time() +
  scale_y_continuous() +
  bbc_style() +
  labs(title = "VO2 [ml/min/kg]")

grid.arrange(d1, d2, d3, ncol = 1)



leistungstests %>%
  mutate(t = hms(t)) %>%
  filter(P > 50) %>%
  pivot_longer(cols = c("V.O2", "V.CO2"), names_to = "Gas", values_to = "Gas.Wert") %>%
  ggplot(aes(x = t, y = Gas.Wert, colour = Gas)) +
  geom_line() +
  #geom_point() +
  scale_x_time(labels = label_time(format = "%M")) +
  scale_y_continuous() +
  scale_color_discrete(labels = c("VCO2 l/min", "VO2 l/min")) +
  theme_cowplot() +
  labs(title = "Gasaustausch während des VO2 Max Tests", x = "Zeit (in Minuten)", y = "l/min", colour = NULL)
