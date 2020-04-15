input <- "https://en.wikipedia.org/wiki/Eurovision_Song_Contest_", year) 
chart_page <- xml2::read_html("https://en.wikipedia.org/wiki/Eurovision_Song_Contest_1980", fill = TRUE)


# scrape data from any sortable table
chart <- chart_page %>% 
  rvest::html_nodes("#mw-content-text") %>% 
  xml2::xml_find_all("//table[contains(@class, 'sortable')]")

charts <- list()
chartvec <- vector()

for (i in 1:length(chart)) {
  assign(paste0("chart", i),
         # allow for unexpected errors but warn user
         tryCatch({rvest::html_table(chart[[i]], fill = TRUE)}, 
                  error = function (e) {print("Potential issue discovered in this year!")})
  )
}
  charts[[i]] <- get(paste0("chart", i))
  # only include tables that have Points
  chartvec[i] <- sum(grepl("Points", colnames(get(paste0("chart", i))))) == 1 & 
    sum(grepl("Category|Venue|Broadcaster", colnames(get(paste0("chart", i))))) == 0 
  
  results_charts <- charts[chartvec]
  
results_charts[[1]]
charts[1][4]

