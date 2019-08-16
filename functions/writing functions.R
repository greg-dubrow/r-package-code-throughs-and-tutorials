## functions tutorials from http://adv-r.had.co.nz/Functional-programming.html

library(tidyverse)

### problem - reset missing codes to NA

# sample dataset
set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]

glimpse(df)

#function

fix_missing <- function(x) {
  x[x == -99] <- NA
  x
}

# in theory would need to be applied to each var separately, but can be done via lapply
dfl <- lapply(df, fix_missing) #returns list
glimpse(dfl)

# or do for subset
dfl2 <- lapply(df[1:5], fix_missing)

# return unlisted
dflu <- unlist(lapply(df, fix_missing))
class(dflu)
glimpse(dflu)

dfs <- sapply(df, fix_missing) #returns matrix
class(dfs)

dfv <- vapply(df, fix_missing) #returns vector but throwing error here, not sure why
dfv


# or map?
dfm <- map_df(df, fix_missing)
glimpse(dfm)


# anonymous functions are not named, usually exist just for one-time purpose

lapply(mtcars, function(x) length(unique(x)))  # returns length of vars in mtcars

# exercise
# Use lapply() and an anonymous function to find the coefficient of variation (the standard deviation divided by the mean) 
# for all columns in the mtcars dataset.
lapply(mtcars, function(x) sd(x) / mean(x))


# Map (note uppercase)

xs <- replicate(5, runif(10), simplify = FALSE)
ws <- replicate(5, rpois(10, 5) + 1, simplify = FALSE)

unlist(lapply(xs, mean))
