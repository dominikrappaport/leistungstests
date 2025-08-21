# Load libraries ----------------------------------------------------------

library("tidyverse")
library("lubridate")
library("bbplot")
library("scales")

# Read from files ---------------------------------------------------------

sickness <- read_csv("data/processed/sickness.csv")

# Reformat table ----------------------------------------------------------

sickness <- sickness %>%
  mutate(
    date = as.Date(date, format = "%d.%m.%y"),
    year = year(date),
    sickness = as.factor(sickness)
  )

# Evaluate

sickness %>%
  mutate(sickdays = ifelse(sickness == "Healthy", 0, 1)) %>%
  select(year, sickdays) %>%
  group_by(year) %>%
  summarise(
    sickdays = sum(sickdays),
  )


sickness %>%
  mutate(sickdays = ifelse(sickness == "healthy", 0, 1)) %>%
  select(year, sickdays) %>%
  filter(is.na(sickdays))

test <- sickness %>%
  mutate(sickdays = ifelse(sickness == "Healthy", 0, 1)) %>%
  select(year, sickness, sickdays)