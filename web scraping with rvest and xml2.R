# web scraping tutorial from 
# https://towardsdatascience.com/tidy-web-scraping-in-r-tutorial-and-resources-ac9f72b4fe47

library(rvest)
library(xml2)
library(knitr)
library(gt)
library(dplyr)
library(tidylog)

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

chart_df <- as.data.frame(data.frame(rank, artist, title, 
                                     trend, last, peak, duration, stringsAsFactors = FALSE)) %>%
  mutate(rank = as.numeric(rank)) %>%
  mutate(last = as.numeric(last)) %>%
  mutate(peak = as.numeric(peak)) %>%
  mutate(duration = as.numeric(duration)) %>%
  mutate(difference = rank - last) %>% 
  mutate(difference = ifelse(is.na(difference), 100 - rank, difference)) %>%
  select(rank, artist, title, trend, last, difference, peak, duration)
  
tibble::glimpse(chart_df)

gt(chart_df)

knitr::kable(chart_df %>% 
               head(10))
  

## function to scrape Eurovision
# https://github.com/keithmcnulty/scraping/blob/master/eurovision_scraping.R
get_eurovision <- function(year) {
  
  # get url from input and read html
  input <- paste0("https://en.wikipedia.org/wiki/Eurovision_Song_Contest_", year) 
  chart_page <- xml2::read_html(input, fill = TRUE)
  
  
  # scrape data from any sortable table
  chart <- chart_page %>% 
    rvest::html_nodes("#mw-content-text") %>% 
    xml2::xml_find_all("//table[contains(@class, 'sortable')]")
  
  charts <- list()
  chartvec <- vector()
  
  for (i in 1:length(chart)) {
    assign(paste0("chart", i),
           # allow for unexpected errors but warn user
           tryCatch({rvest::html_table(chart[[i]], fill = TRUE)}, error = function (e) {print("Potential issue discovered in this year!")})
    )
    
    
    charts[[i]] <- get(paste0("chart", i))
    # only include tables that have Points
    chartvec[i] <- sum(grepl("Points", colnames(get(paste0("chart", i))))) == 1 & sum(grepl("Category|Venue|Broadcaster", colnames(get(paste0("chart", i))))) == 0 
  }
  
  results_charts <- charts[chartvec]
  
  # account for move to semifinals and qualifying rounds
  if (year < 1956) {
    stop("Contest was not held before 1956!")
  } else if (year == 1956) {
    stop("Contest was held in 1956 but no points were awarded!")
  } else if (year %in% c(1957:1995)) {
    results_charts[[1]] %>% 
      dplyr::arrange(Place) %>% 
      dplyr::select(-Draw)
  } else if (year == 1996) {
    results_charts[[2]] %>% 
      dplyr::arrange(Place) %>% 
      dplyr::select(-Draw)
  } else if (year %in% 1997:2003) {
    results_charts[[1]] %>% 
      dplyr::arrange(Place) %>% 
      dplyr::select(-Draw)
  } else if (year %in% 2004:2007) {
    results_charts[[2]] %>% 
      dplyr::arrange(Place) %>% 
      dplyr::select(-Draw)
  } else {
    results_charts[[3]] %>% 
      dplyr::arrange(Place) %>% 
      dplyr::select(-Draw)
  }
}

eurov65 <- get_eurovision(1965) 
names(eurov65[1])

euyear <- seq(1980, 1990)

eurov80s <- map2_df(euyear, names(comentarios), ~ mutate(.x, ID = .y)) 

eurov80s <- purrr::map(euyear, get_eurovision)
names(eurov80s[[1]])

change_names <- function(x) {
  names(x) <- sub("^Language$", "Language", names(x))
  x
}
eurov80s2 <- purrr::map(eurov80s, ~change_names(.x))

names(eurov80s2[[1]])

eurov80s_df <- as.data.frame(eurov80s)
