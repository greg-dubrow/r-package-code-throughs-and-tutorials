# web scraping tutorial from 
# https://towardsdatascience.com/tidy-web-scraping-in-r-tutorial-and-resources-ac9f72b4fe47

library(rvest)
library(xml2)
library(knitr)
library(gt)
library(dplyr)

hot100page <- "https://www.billboard.com/charts/hot-100"
hot100 <- read_html(hot100page)
hot100
str(hot100)

body_nodes <- hot100 %>%
  html_node("body") %>%
  html_children()

body_nodes %>%
  html_children()

rank <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__rank__number')]") %>%
                 html_text()
rank

artist <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__information__artist')]") %>%
  rvest::html_text()
artist

title <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__information__song')]") %>%
  html_text()
title

# here we need \ at end of text string to get all instances
# of chart-element__trend chart-element__trend
trend <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__trend chart-element__trend\')]") %>%
  html_text()
trend

last <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__meta text--center color--secondary text--last')]") %>%
  html_text()
last

peak <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__meta text--center color--secondary text--peak')]") %>%
  html_text()
peak

duration <- hot100 %>%
  html_nodes("body") %>%
  xml_find_all("//span[contains(@class, 
               'chart-element__meta text--center color--secondary text--week')]") %>%
  html_text()
duration

# chart-element__meta text--center color--secondary text--last
# peak
# week

chart_df <- as.data.frame(data.frame(rank, artist, title, trend, last, peak)) %>%
  mutate(rank = as.numeric(rank)) %>%
  mutate(last = as.numeric(last))
  
tibble::glimpse(chart_df)

knitr::kable(chart_df %>% 
               head(10))
  
gt(chart_df)
