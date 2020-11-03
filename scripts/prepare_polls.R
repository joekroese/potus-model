library(tidyverse)
library(lubridate)

all_polls_2008 <- read_csv("data/all_polls_2008.csv", 
                           col_types = cols(start.date = col_date(format = "%m/%d/%y"),
                                            end.date = col_date(format = "%m/%d/%y")))
all_polls_2012 <- read_csv('data/all_polls_2012.csv',
                           col_types = cols(start.date = col_date(format = "%m/%d/%y"),
                                            end.date = col_date(format = "%m/%d/%y")))
all_polls_2016 <- read_csv("data/all_polls_2016.csv", 
                           col_types = cols(start.date = col_date(format = "%Y-%m-%d"), 
                                            end.date = col_date(format = "%Y-%m-%d"))) %>%
  mutate(entry.date.time..et. = ymd_hms(entry.date.time..et.))
all_polls_2020 <- read_csv(file = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQ56fySJKLL18Lipu1_i3ID9JE06voJEz2EXm6JW4Vh11zmndyTwejMavuNntzIWLY0RyhA1UsVEen0/pub?gid=0&single=true&output=csv") %>%
  mutate(start.date = mdy(start.date),
         end.date = mdy(end.date),
         lubridate::mdy_hms(entry.date.time..et.))

all_polls_2008 <- all_polls_2008 %>%
  rename(democratic_candidate = obama,
         republican_candidate = mccain)
all_polls_2012 <- all_polls_2012 %>%
  rename(democratic_candidate = obama,
         republican_candidate = romney)
all_polls_2016 <- all_polls_2016 %>%
  rename(democratic_candidate = clinton,
         republican_candidate = trump)
all_polls_2020 <- all_polls_2020 %>%
  rename(democratic_candidate = biden,
         republican_candidate = trump) %>%
  dplyr::select(state,
                pollster, 
                number.of.observations, mode, population,
                start.date, 
                end.date,
                democratic_candidate, republican_candidate, undecided, other) %>%
  mutate(partisan = "Nonpartisan") # partisan is not defined for 2020 results

all_polls <- all_polls_2016 %>%
  dplyr::select(state,
                pollster, 
                number.of.observations, mode, population,
                start.date, 
                end.date,
                democratic_candidate, republican_candidate, undecided, other,
                partisan) %>%
  add_case(all_polls_2008) %>%
  add_case(all_polls_2012) %>%
  add_case(all_polls_2020) %>%
  rename(n = number.of.observations)


# pollster mutations
all_polls <- all_polls %>%
  mutate(pollster = str_extract(pollster, pattern = "[A-z0-9 ]+") %>% sub("\\s+$", "", .),
         pollster = replace(pollster, pollster == "Fox News", "FOX"), # Fixing inconsistencies in pollster names
         pollster = replace(pollster, pollster == "WashPost", "Washington Post"),
         pollster = replace(pollster, pollster == "ABC News", "ABC"),
         pollster = replace(pollster, pollster == "DHM Research", "DHM"),
         pollster = replace(pollster, pollster == "Public Opinion Strategies", "POS"),
         undecided = ifelse(is.na(undecided), 0, undecided),
         other = ifelse(is.na(other), 0, other))

# vote shares etc
all_polls <- all_polls %>%
  mutate(two_party_sum = democratic_candidate + republican_candidate,
         polltype = as.integer(as.character(recode(population, 
                                                   "Likely Voters" = "0", 
                                                   "Registered Voters" = "1",
                                                   "Adults" = "2"))), 
         n_respondents = round(n),
         # democratic_candidate
         n_democratic_candidate = round(n * democratic_candidate/100),
         pct_democratic_candidate = democratic_candidate/two_party_sum,
         # republican_candidate
         n_republican_candidate = round(n * republican_candidate/100),
         pct_republican_candidate = republican_candidate/two_party_sum,
         # third-party
         n_other = round(n * other/100),
         p_other = other/100)

write_csv(all_polls, "data/computed/all_polls.csv")
