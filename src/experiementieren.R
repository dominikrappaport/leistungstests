x <- wattvergleich.cyclus2 %>% 
  inner_join(wattvergleich.favero, by=join_by(Timestamp)) %>%
  inner_join(wattvergleich.laps, by=join_by(Timestamp)) %>%
  filter(Watt.x > 0) %>%
  mutate(vergleich = Watt.y - Watt.x) %>%
  filter(Lap == 11)
