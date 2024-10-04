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
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme (ml/min/kg)", subtitle = "Messung vom 07. 11. 2023")

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
  labs(title = "Leistung im Verhältnis zur Sauerstoffaufnahme (% VO2Max)", subtitle = "Messung vom 07. 11. 2023")

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

wattvergleich.cyclus2 <- read_csv("data/processed/wattvergleich/Cyclus 2.csv", col_types = cols_only("Type" = col_character(), "Message" = col_character(), "Value 1" = col_integer(), "Value 7" = col_integer())) %>%
  mutate(Source = "Cyclus 2", Timestamp = `Value 1`, Watt = `Value 7`) %>%
  select(Timestamp, Type, Message, Watt, Source) %>%
  filter(Timestamp >= 1096705521, Type == "Data", Message == "record") %>%
  mutate(Timestamp = as_datetime(Timestamp + 631065600, tz = "Europe/Vienna"))

wattvergleich.favero <- read_csv("data/processed/wattvergleich/Favero Assioma Duo.csv", col_types = cols_only("Type" = col_character(), "Message" = col_character(), "Value 1" = col_integer(), "Value 4" = col_integer())) %>%
  mutate(Source = "Favero Assioma Duo", Timestamp = `Value 1`, Watt = `Value 4`) %>%
  select(Timestamp, Type, Message, Watt, Source) %>%
  filter(Timestamp >= 1096705521, Type == "Data", Message == "record", Watt > 0) %>%
  mutate(Timestamp = as_datetime(Timestamp + 631065600, tz = "Europe/Vienna"))

wattvergleich.laps <- read_csv("data/processed/wattvergleich/Laps.csv") %>%
  mutate(Timestamp = as_datetime(Timestamp + 631065600, tz = "Europe/Vienna"))

wattvergleich <- rbind(wattvergleich.favero, wattvergleich.cyclus2)

wattvergleich %>%
  mutate(Source = as.factor(Source)) %>%
  mutate(Source = fct_relevel(Source, "Favero Assioma Duo", "Cyclus 2")) %>%
  mutate(Timestamp = Timestamp - min(Timestamp)) %>%
  ggplot(aes(x = Timestamp, y = Watt, colour = Source)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_time(labels = label_time(format = "%H:%M")) +
  scale_colour_manual(values = c("#FAAB18", "#1380A1")) +
  scale_y_continuous() +
  bbc_style() +
  labs(title = "Wattvergleich")

wattvergleich <- wattvergleich.cyclus2 %>% 
  inner_join(wattvergleich.favero, by=join_by(Timestamp)) %>%
  inner_join(wattvergleich.laps, by=join_by(Timestamp)) %>%
  filter(Watt.x > 0, RelTime > 10) %>%
  mutate(vergleich = Watt.y - Watt.x) %>%
  group_by(Lap, Watt.x) %>%
  summarise(vergleich.mittel = mean(vergleich)) %>%
  mutate(Watt.Cyclus2 = Watt.x, Watt.FaveroAssioma = Watt.x + vergleich.mittel, Watt.abweichung = vergleich.mittel, Watt.abweichung.relativ = abs(vergleich.mittel)/Watt.x) %>%
  select(Lap, Watt.Cyclus2, Watt.FaveroAssioma, Watt.abweichung, Watt.abweichung.relativ)

wattvergleich.diagram <- wattvergleich %>%
  select(Lap, Watt.Cyclus2, Watt.FaveroAssioma) %>%
  pivot_longer(cols = c(Watt.Cyclus2, Watt.FaveroAssioma), names_to = "Source", values_to = "Watt") %>%
  ggplot(aes(x=Lap, y=Watt,colour=Source)) + 
  geom_step(linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_colour_manual(values = c("#FAAB18", "#1380A1"), labels=c("Cyclus 2", "Favero Assioma Duo")) +
  scale_x_continuous(limits=c(1,13), breaks=seq(1,13), labels=c("1.","2.","3.","4.","5.","6.","7.","8.","9.","10.","11.","12.","13. Runde")) +
  scale_y_continuous(labels = label_number(suffix = " W"), limits=c(40, 240), breaks=seq(40, 240, 20)) +
  bbc_style() +
  theme(axis.text.x=element_text(hjust=0), plot.margin = margin(9,55,9,0)) +
  labs(title = "Vergleich Wattmessung Cyclus 2 und Favero Assioma Duo", subtitle="Messung vom 01. 10. 2024")

finalise_plot(plot_name = wattvergleich.diagram,
              source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
              width_pixels = 1000,
              save_filepath = "output/leistungstest2024_wattvergleich.jpg")

wattvergleich.diagram <- wattvergleich %>%
  ggplot(aes(x=Lap, y=Watt.abweichung.relativ)) +
  geom_line(linewidth = 1, colour = "#1380A1") +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(limits=c(1,13), breaks=seq(1,13), labels=c("1.","2.","3.","4.","5.","6.","7.","8.","9.","10.","11.","12.","13. Runde")) +
  scale_y_continuous(labels = label_percent()) +
  bbc_style() +
  theme(axis.text.x=element_text(hjust=0), plot.margin = margin(9,55,9,0)) +
  labs(title = "Vergleich Wattmessung Cyclus 2 und Favero Assioma Duo (relativ)", subtitle="Messung vom 01. 10. 2024")

finalise_plot(plot_name = wattvergleich.diagram,
              source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
              width_pixels = 1000,
              save_filepath = "output/leistungstest2024_wattvergleich_relativ.jpg")
