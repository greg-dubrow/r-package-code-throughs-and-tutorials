library(janitor)
library(tidyverse)
library(here)
library(readxl)

# usethis::use_git()
 getwd()


## load tdf data - not a janitor function, but still important
tdf <- read_excel("/Users/gregdubrow/Data/tour_de_france.xlsx")
glimpse(tdf)

# not a janitor cleaning issue, but greg lemond spelled differently, needs fixing
tdf <- tdf %>%
  mutate(winner = str_replace(winner, "Greg Lemond", "Greg LeMond"))

# adding already "clean" field to see what clean_names() does
tdf$start_date_clean <- tdf$`Start Date`

### clean & explore the data
## lots of data names have spaces, use clean_names()
tdf <- clean_names(tdf)
glimpse(tdf)

## start_date_clean ignored, no need for it so delete to keep set clean
tdf <- tdf %>%
  select(-start_date_clean)

## check for dupes, mainly useful for data w/ fields like ids where repeating values could be problem
# but use here to count winners. since it returns object in console, entire dataframe will come with it
# best to limit to fields you want to examine

tdf %>%
  select(winners_team, winners_nationality, year) %>%
  get_dupes(winners_team)

# output as df (useful if needs to be manipulated in another step, sent to someone, etc)
tdf_dupe_team <- tdf %>%
  select(winners_team, year) %>%
  get_dupes(winners_team)


## tabyl for tables, cross-tabs...
# default sort is alpha, so if you want by freq or percent use arrange
tdf %>%
  tabyl(winners_team) %>%
  arrange(desc(n))

# cross-tab - easier to demo w/ smaller N by N
# only row obs keep original col name. observations from 2nd var called become their own cols
mtcars_out <- ## to ouput as object for other uses
mtcars %>%
  tabyl(gear, cyl) %>%
  adorn_totals("row") %>% # creates row of sum of cols
  adorn_totals("col") %>% # creates col of sum of rows
#  adorn_totals(c("col", "row")) %>% # does both can add in 1 statement or separate
  adorn_percentages(c("col")) %>% # sums columnwise, bottom row should be 100%
  adorn_percentages(c("row")) %>% # sum row-wise to 100% 
         #can only be one or the other, row or col, last one in chain will output
  adorn_pct_formatting(digits = 1) %>% 
  adorn_ns() %>% # if NA is set, will add them to output
  adorn_title("top", row_name = "Gears", col_name = "Cylindars") # adds field titles if output


# to output as df object
# tdf_crosstab1 <- tdf %>%
#   tabyl(winners_team, winners_nationality) %>%
#   adorn_totals(c("row", "col")) %>% # adds row and/or column totals 
#   adorn_percentages() %>% # on own replaces n w/ percent.  
#   adorn_pct_formatting(digits = 2)
#   adorn_percentages("row")


glimpse(tdf_crosstab1)
# add adorn

# use w/



## load data sources
roster_raw <- read_excel(here("dirty_data.xlsx"))  

