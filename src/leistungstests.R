# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

leistungstests2023 <-
  read.csv("data/processed/Leistungsmessung202311.csv")
leistungstests2024 <-
  read.csv("data/processed/Leistungsmessung202410.csv")

# Adjust type and field names ---------------------------------------------

leistungstests2023 <- leistungstests2023 %>%
  mutate(datum = as.Date("2023/11/7")) %>%
  mutate(V.O2.kg.rel = V.O2.kg / max(V.O2.kg))

leistungstests2024 <- leistungstests2024 %>%
  mutate(
    EUFett = as.integer(NA),
    EUKH = as.integer(NA),
    BWG = as.integer(NA),
    datum = as.Date("2024/10/1")
  ) %>%
  mutate(V.O2.kg.rel = V.O2.kg / max(V.O2.kg))

# Join data ---------------------------------------------------------------

leistungstests <- rbind(leistungstests2023, leistungstests2024)

# Plot results ------------------------------------------------------------

leistungstests.plot <- leistungstests %>%
  filter(P > 50) %>%
  mutate(datum = as.factor(datum)) %>%
  ggplot(aes(x = V.O2.kg, y = P, colour = datum)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_y_continuous(labels = label_number(suffix = " W")) +
  scale_x_continuous(
    limits = c(10, 50),
    breaks = seq(10, 50, 5),
    labels = c(
      "10",
      "15",
      "20",
      "25",
      "30",
      "35",
      "40",
      "45",
      expression(50 ~ ml ~ O[2] / min / kg)
    )
  ) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1"),
                      labels = c("2023", "2024")) +
  bbc_style() +
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme") +
  theme(axis.text.x = element_text(hjust = 0, vjust = 0.5),
        plot.margin = margin(9, 110, 9, 0))

finalise_plot(
  plot_name = leistungstests.plot,
  source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
  width_pixels = 800,
  save_filepath = "output/leistungstests_absolut.jpg"
)

leistungstests.plot <- leistungstests %>%
  filter(P > 50, datum == as.Date("2024/10/1")) %>%
  ggplot(aes(x = V.O2.kg.rel, y = P)) +
  geom_point(size = 1) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_y_continuous(labels = label_number(suffix = " W")) +
  scale_x_continuous(
    limits = c(0.3, 1),
    breaks = seq(0.3, 1, 0.1),
    labels = label_percent(suffix = " %")
  ) +
  scale_colour_manual(values = c("#1380A1", "#FAAB18"),
                      labels = c("2023", "2024")) +
  bbc_style() +
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme (% VO2Max)",
       subtitle = "Messung vom 01. 10. 2024")

finalise_plot(
  plot_name = leistungstests.plot,
  source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
  width_pixels = 800,
  save_filepath = "output/leistungstests_relativ.jpg"
)
