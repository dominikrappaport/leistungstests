
# Read from files ---------------------------------------------------------

wattvergleich.cyclus2 <-
  read_csv(
    "data/processed/wattvergleich/Cyclus 2.csv",
    col_types = cols_only(
      "Type" = col_character(),
      "Message" = col_character(),
      "Value 1" = col_integer(),
      "Value 7" = col_integer()
    )
  )
wattvergleich.favero <-
  read_csv(
    "data/processed/wattvergleich/Favero Assioma Duo.csv",
    col_types = cols_only(
      "Type" = col_character(),
      "Message" = col_character(),
      "Value 1" = col_integer(),
      "Value 4" = col_integer()
    )
  )
wattvergleich.laps <-
  read_csv("data/processed/wattvergleich/Laps.csv")

# Adjust type and field names and apply filters ---------------------------

wattvergleich.cyclus2 <- wattvergleich.cyclus2 %>%
  mutate(Timestamp = `Value 1`, WattCyclus2 = `Value 7`) %>%
  filter(Timestamp >= 1096705521, Type == "Data", Message == "record") %>%
  mutate(Timestamp = as_datetime(Timestamp + 631065600, tz = "Europe/Vienna")) %>%
  select(Timestamp, WattCyclus2)

wattvergleich.favero <- wattvergleich.favero %>%
  mutate(Timestamp = `Value 1`, WattFavero = `Value 4`) %>%
  filter(Timestamp >= 1096705521,
         Type == "Data",
         Message == "record",
         WattFavero > 0) %>%
  mutate(Timestamp = as_datetime(Timestamp + 631065600, tz = "Europe/Vienna")) %>%
  select(Timestamp, WattFavero)

wattvergleich.laps <- wattvergleich.laps %>%
  mutate(Timestamp = as_datetime(Timestamp + 631065600, tz = "Europe/Vienna")) %>%
  select(Timestamp, Lap, RelTime)

# Join data ---------------------------------------------------------------

wattvergleich <- wattvergleich.cyclus2 %>%
  inner_join(wattvergleich.favero, by = join_by(Timestamp)) %>%
  inner_join(wattvergleich.laps, by = join_by(Timestamp)) %>%
  filter(WattFavero > 0, RelTime > 10) %>%
  mutate(vergleich = WattFavero - WattCyclus2) %>%
  group_by(Lap, WattCyclus2) %>%
  summarise(WattAbweichung = mean(vergleich)) %>%
  mutate(
    WattFavero = WattCyclus2 + WattAbweichung,
    WattAbweichungRelativ = abs(WattAbweichung) / WattCyclus2
  ) %>%
  select(Lap,
         WattCyclus2,
         WattFavero,
         WattAbweichung,
         WattAbweichungRelativ)

# Plot results ------------------------------------------------------------

wattvergleich.diagram <- wattvergleich %>%
  select(Lap, WattCyclus2, WattFavero) %>%
  pivot_longer(
    cols = c(WattCyclus2, WattFavero),
    names_to = "Source",
    values_to = "Watt"
  ) %>%
  ggplot(aes(x = Lap, y = Watt, colour = Source)) +
  geom_step(linewidth = 1) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_colour_manual(
    values = c("#FAAB18", "#1380A1"),
    labels = c("Cyclus 2", "Favero Assioma Duo")
  ) +
  scale_x_continuous(
    limits = c(1, 13),
    breaks = seq(1, 13),
    labels = c(
      "1.",
      "2.",
      "3.",
      "4.",
      "5.",
      "6.",
      "7.",
      "8.",
      "9.",
      "10.",
      "11.",
      "12.",
      "13. Runde"
    )
  ) +
  scale_y_continuous(
    labels = label_number(suffix = " W"),
    limits = c(40, 240),
    breaks = seq(40, 240, 20)
  ) +
  bbc_style() +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 55, 9, 0)) +
  labs(title = "Vergleich Wattmessung Cyclus 2 und Favero Assioma Duo", subtitle =
         "Messung vom 01. 10. 2024")

finalise_plot(
  plot_name = wattvergleich.diagram,
  source = "Quelle: High Performance Coaching Clemens Rumpl, St. Pölten",
  width_pixels = 1000,
  save_filepath = "output/leistungstest2024_wattvergleich.jpg"
)
