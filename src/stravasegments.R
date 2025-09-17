# Load libraries ----------------------------------------------------------

library("tidyverse")
library("bbplot")
library("scales")
library("lubridate")


# Define Strava segment number --------------------------------------------

segment <- "2891805"
segment_title <- "Jauerling ganz rauf"

# Read from files ---------------------------------------------------------

segment <-
  read.csv(paste0("data/processed/stravasegments/leaderboard_", segment,".csv"))

# Reformat table ----------------------------------------------------------

segment <- segment %>%
  mutate(
    Date = as.Date(Date, format = "%b %d, %Y"),
    Time = period_to_seconds(hms(ifelse(
      str_count(Time, pattern = ":") == 2, Time, paste0("0:", Time)
    ))) / 60,
    Sex = as.factor(Sex) %>% fct_relevel("Men", "Women", ""),
    Age.group = as.factor(Age.group),
    Weight.group = as.factor(Weight.group)
  )

# Plot results ------------------------------------------------------------

segment.verteilung.plot <- segment %>%
  filter(Sex %in% c("Men", "Women")) %>%
  ggplot(aes(x = Time, fill = Sex)) +
  geom_histogram(
    binwidth = 5,
    colour = "white",
    position = position_dodge2(reverse = TRUE)
  ) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_continuous(
    limits = c(15, 60),
    labels = c(seq(15, 55, 5), "60 Minuten"),
    breaks = seq(15, 60, 5)
  ) +
  scale_fill_manual(values = c("#1380A1", "#FAAB18"),
                    labels = c("Männer", "Frauen")) +
  bbc_style() +
  labs(title = "Time to finish-Verteilung", subtitle = paste("Strava-Segment", segment_title)) +
  theme(axis.text.x = element_text(hjust = 0),
        plot.margin = margin(9, 70, 9, 0))

segment.verteilung.gewichtsgruppen.plot <- segment %>%
  mutate(
    Weight.group = Weight.group %>%
      fct_relevel(
        "54 kg and under",
        "55 to 64 kg",
        "65 to 74 kg",
        "75 to 84 kg",
        "85 to 94 kg",
        "95 kg to 104 kg",
        "105 kg to 114 kg",
        "115 kg and over"
      )
  ) %>%
  #  group_by(Sex, Weight.group) %>%
  #  count() %>%
  filter(Weight.group != "") %>%
  ggplot(aes(x = Weight.group, fill = Sex)) +
  geom_histogram(
    colour = "white",
    position = position_dodge2(preserve = "single"),
    stat = "count"
  ) +
  geom_hline(yintercept = 0,
             linewidth = 1,
             colour = "#333333") +
  scale_x_discrete(
    labels = c(
      "54 kg und leichter",
      "55 – 64 kg",
      "65 – 74 kg",
      "75 – 84 kg",
      "85 – 94 kg",
      "95–104 kg",
      "105–114 kg",
      "115 kg und mehr"
    )
  ) +
  scale_fill_manual(values = c("#1380A1", "#FAAB18"),
                    labels = c("Männer", "Frauen")) +
  bbc_style() +
  labs(title = "Gewichtsverteilung", subtitle = paste("Strava-Segment", segment_title)) +
  theme(axis.text.x = element_text(
    angle = 90,
    vjust = 0.5,
    hjust = 1
  ))

finalise_plot(
  plot_name = segment.verteilung.plot,
  source = "Quelle: Strava Leaderboard",
  width_pixels = 800,
  save_filepath = paste0("output/segment_distribution_", segment, ".jpg")
)

finalise_plot(
  plot_name = segment.verteilung.gewichtsgruppen.plot,
  source = "Quelle: Strava Leaderboard",
  width_pixels = 800,
  save_filepath = paste0("output/segment_distribution_", segment, "weightgroups.jpg")
)