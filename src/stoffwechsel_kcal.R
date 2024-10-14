
# Read file ---------------------------------------------------------------

stoffwechsel <- read_csv("data/processed/stoffwechsel2024.csv") %>%
  mutate(Fett = Fett*9, Kohlenhydrate=Kohlenhydrate*4)

# Reformat table ----------------------------------------------------------

stoffwechsel <- stoffwechsel %>%
  pivot_longer(cols = Fett:Kohlenhydrate, names_to = "Nährstoff", values_to = "Brennwert")

# Plot file ---------------------------------------------------------------

stoffwechsel.plot <- stoffwechsel %>%
  ggplot(aes(x=Watt,y=Brennwert,colour=Nährstoff)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(limits=c(60, 240), breaks=seq(60, 240, 20), labels=c(seq(60, 220, 20), "240 W")) +
  scale_y_continuous(limits=c(0, 800), breaks=seq(0, 800, 100), labels = label_number(suffix = " kcal")) +
  scale_colour_manual(values = c("#1380A1", "#FAAB18"), labels = c("Fett", "Kohlenhydrate")) +
  bbc_style() +
  labs(title = "Nährstoffverbrauch [kcal]") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 20, 9, 0))

finalise_plot(plot_name = stoffwechsel.plot,
              source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
              width_pixels = 800,
              save_filepath = "output/stoffwechsel2024_kcal.jpg")