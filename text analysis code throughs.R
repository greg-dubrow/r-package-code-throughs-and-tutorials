## code through with tidy text and other text mining packages

# from https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html
library(janeaustenr)
library(tidyverse)
library(tidytext)
library(tidylog) 

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(line = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter[\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()
glimpse(original_books)
original_books

# takes original_books and breaks each word to its own line
tidy_books <- original_books %>%
  unnest_tokens(word, text)

# takes tidy_books and anti_joins out the stopwords
cleaned_books <- tidy_books %>%
  anti_join(get_stopwords())

cleaned_books %>%
  count(word, sort = TRUE)

# do sentiment analysis 
# first, set up df of bing lexicon of word::sentiment
bing <- get_sentiments("bing")


# merge sentiment to tidy_books
# tutorial uses inner_join but that only includes words w/ sentiment attached
jasent <- tidy_books %>%
  inner_join(bing) %>%
#  filter(!is.na(book)) %>%
#  mutate(sentiment = ifelse(is.na(sentiment), "neutral", sentiment)) %>%
  count(book, index = line %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment_score = positive - negative)

# plot of sentiment over index (which is line number?)
ggplot(jasent, aes(index, sentiment_score, fill = book)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free_x")

jasent %>%
  count(book)

