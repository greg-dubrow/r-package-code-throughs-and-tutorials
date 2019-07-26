# https://jennybc.github.io/purrr-tutorial/index.html

library(tidyverse)
### vecoros and lists - ecessary because purr iterates over vectors & lists

# vectors
v_log <- c(TRUE, FALSE, FALSE, TRUE)
v_log


v_int <- 1:4
glimpse(v_int)

v_doub <- 1:4 * 1.2
glimpse(v_doub)

v_char <- letters[1:4]

is.logical(v_char)
# test also is.numeric, is.integer, is.character

v_int[0]

# hieararchy of the most common atomic vector types: logical < integer < numeric < character
# keep in mind if trying to coerce from one type to another

as.logical(v_char)

## lists - essentially multiple vectors in the same object. can have multiple layers.
# when contructing by hand, each comma separates levels

l_x <- list(1:3, c("four", "five"))

l_y <- list(logical = TRUE, integer = 4L, double = 4 * 1.2, character = "character")

is.logical(l_y)

l_z <- list(letters[26:22], transcendental = c(pi, exp(1)), f = function(x) x^2)

# when indexing a list single brackets return the named element or number range, i.e.

l_y[2:3] # returns layers 2 & 3 of the 4 layer list

l_z["transcendental"] # returns just the layer named "transcendental"