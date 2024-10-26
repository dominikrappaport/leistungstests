# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")
library("lubridate")

# Read from files ---------------------------------------------------------

segment <-
  read.csv("data/processed/stravasegments/leaderboard_37299908.csv")

# Reformat table ----------------------------------------------------------

segment <- segment %>%
  mutate(
    Date = as.Date(Date, format="%d %b %Y"),
    Time = hms(
      ifelse(str_count(Time, pattern = ":") == 2, Time, paste0("0:", Time))
      ),
    Sex = as.factor(Sex),
    Age.group = as.factor(Age.group),
    Weight.group = as.factor(Weight.group)
  )

# Plot results ------------------------------------------------------------

segment %>%
  mutate(Time = period_to_seconds(Time)/60) %>%
  filter(Sex %in% c("Men", "Women")) %>%
  ggplot(aes(x = Time, fill = Sex)) +
  geom_histogram(binwidth = 5, colour = "white", position = position_dodge2()) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(
    limits = c(0, 90), 
    labels = c(seq(0, 85, 5), "90 Minuten"), breaks=seq(0, 90, 5)
    ) +
  scale_fill_manual(
    values = c("#1380A1", "#FAAB18"), 
    labels=c("Männer", "Frauen")
    ) +
  bbc_style() +
  labs(title = "Strava Segment QD-Kahlenberg-Auffahrt von Klosterneuburg") +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 60, 9, 0))
